using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data.SqlClient;
using System.Data;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace OnlineGymStore.Pages.Admin
{
    public partial class ManageUsers : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                // Check if admin is logged in (implement your own authentication check)
                // if (!IsAdminLoggedIn()) Response.Redirect("~/Pages/Admin/Login.aspx");

                LoadUsers();
            }
        }

        private void LoadUsers(string searchQuery = "")
        {
            string connectionString = ConfigurationManager.ConnectionStrings["GymShop"].ConnectionString;
            string query = "SELECT UserID, FullName, Email FROM Users";

            if (!string.IsNullOrEmpty(searchQuery))
            {
                query += " WHERE FullName LIKE @Search OR Email LIKE @Search";
            }

            query += " ORDER BY UserID DESC";

            using (SqlConnection con = new SqlConnection(connectionString))
            {
                using (SqlCommand cmd = new SqlCommand(query, con))
                {
                    if (!string.IsNullOrEmpty(searchQuery))
                    {
                        cmd.Parameters.AddWithValue("@Search", "%" + searchQuery + "%");
                    }

                    try
                    {
                        con.Open();
                        SqlDataAdapter da = new SqlDataAdapter(cmd);
                        DataTable dt = new DataTable();
                        da.Fill(dt);

                        gvUsers.DataSource = dt;
                        gvUsers.DataBind();
                    }
                    catch (Exception ex)
                    {
                        ShowAlert("Error loading users: " + ex.Message, "danger");
                    }
                }
            }
        }

        protected void btnSearch_Click(object sender, EventArgs e)
        {
            LoadUsers(txtSearch.Text.Trim());
        }

        protected void btnClear_Click(object sender, EventArgs e)
        {
            txtSearch.Text = string.Empty;
            LoadUsers();
        }

        protected void gvUsers_RowCommand(object sender, GridViewCommandEventArgs e)
        {
            if (e.CommandName == "ResetPassword")
            {
                int userId = Convert.ToInt32(e.CommandArgument);
                // Implement password reset logic here
            }
        }

        protected void gvUsers_RowEditing(object sender, GridViewEditEventArgs e)
        {
            gvUsers.EditIndex = e.NewEditIndex;
            LoadUsers(txtSearch.Text.Trim());
        }

        protected void gvUsers_RowCancelingEdit(object sender, GridViewCancelEditEventArgs e)
        {
            gvUsers.EditIndex = -1;
            LoadUsers(txtSearch.Text.Trim());
        }

        protected void gvUsers_RowUpdating(object sender, GridViewUpdateEventArgs e)
        {
            int userId = Convert.ToInt32(gvUsers.DataKeys[e.RowIndex]["UserID"]);
            TextBox txtFullName = (TextBox)gvUsers.Rows[e.RowIndex].FindControl("txtEditFullName");
            TextBox txtEmail = (TextBox)gvUsers.Rows[e.RowIndex].FindControl("txtEditEmail");

            string fullName = txtFullName.Text.Trim();
            string email = txtEmail.Text.Trim();

            // Basic validation
            if (string.IsNullOrEmpty(fullName) || string.IsNullOrEmpty(email))
            {
                ShowAlert("Full name and email are required", "warning");
                return;
            }

            // Check if email exists for other users
            if (IsEmailExistsForOtherUser(email, userId))
            {
                ShowAlert("Email already exists for another user", "warning");
                return;
            }

            // Update user
            if (UpdateUser(userId, fullName, email))
            {
                gvUsers.EditIndex = -1;
                LoadUsers(txtSearch.Text.Trim());
                ShowAlert("User updated successfully", "success");
            }
            else
            {
                ShowAlert("Failed to update user", "danger");
            }
        }

        protected void gvUsers_RowDeleting(object sender, GridViewDeleteEventArgs e)
        {
            int userId = Convert.ToInt32(gvUsers.DataKeys[e.RowIndex]["UserID"]);

            if (DeleteUserWithAllData(userId))
            {
                LoadUsers(txtSearch.Text.Trim());
                ShowAlert("User and all associated data deleted successfully", "success");
            }
            else
            {
                ShowAlert("Failed to delete user and associated data", "danger");
            }
        }

        private bool DeleteUserWithAllData(int userId)
        {
            string connectionString = ConfigurationManager.ConnectionStrings["GymShop"].ConnectionString;
            SqlTransaction transaction = null;

            using (SqlConnection con = new SqlConnection(connectionString))
            {
                try
                {
                    con.Open();
                    transaction = con.BeginTransaction();

                    // 1. Delete order status logs for user's orders
                    string deleteOrderStatusLogsQuery = @"
                        DELETE FROM OrderStatusLogs 
                        WHERE OrderID IN (SELECT OrderID FROM Orders WHERE UserID = @UserID)";

                    using (SqlCommand cmd = new SqlCommand(deleteOrderStatusLogsQuery, con, transaction))
                    {
                        cmd.Parameters.AddWithValue("@UserID", userId);
                        cmd.ExecuteNonQuery();
                    }

                    // 2. Delete order items for user's orders
                    string deleteOrderItemsQuery = @"
                        DELETE FROM OrderItems 
                        WHERE OrderID IN (SELECT OrderID FROM Orders WHERE UserID = @UserID)";

                    using (SqlCommand cmd = new SqlCommand(deleteOrderItemsQuery, con, transaction))
                    {
                        cmd.Parameters.AddWithValue("@UserID", userId);
                        cmd.ExecuteNonQuery();
                    }

                    // 3. Delete user's orders
                    string deleteOrdersQuery = "DELETE FROM Orders WHERE UserID = @UserID";
                    using (SqlCommand cmd = new SqlCommand(deleteOrdersQuery, con, transaction))
                    {
                        cmd.Parameters.AddWithValue("@UserID", userId);
                        cmd.ExecuteNonQuery();
                    }

                    // 4. Delete cart items for user's carts
                    string deleteCartItemsQuery = @"
                        DELETE FROM CartItems 
                        WHERE CartID IN (SELECT CartID FROM Carts WHERE UserID = @UserID)";

                    using (SqlCommand cmd = new SqlCommand(deleteCartItemsQuery, con, transaction))
                    {
                        cmd.Parameters.AddWithValue("@UserID", userId);
                        cmd.ExecuteNonQuery();
                    }

                    // 5. Delete user's carts
                    string deleteCartsQuery = "DELETE FROM Carts WHERE UserID = @UserID";
                    using (SqlCommand cmd = new SqlCommand(deleteCartsQuery, con, transaction))
                    {
                        cmd.Parameters.AddWithValue("@UserID", userId);
                        cmd.ExecuteNonQuery();
                    }

                    // 6. Finally, delete the user
                    string deleteUserQuery = "DELETE FROM Users WHERE UserID = @UserID";
                    using (SqlCommand cmd = new SqlCommand(deleteUserQuery, con, transaction))
                    {
                        cmd.Parameters.AddWithValue("@UserID", userId);
                        int rowsAffected = cmd.ExecuteNonQuery();

                        if (rowsAffected > 0)
                        {
                            transaction.Commit();
                            return true;
                        }
                        else
                        {
                            transaction.Rollback();
                            return false;
                        }
                    }
                }
                catch (Exception ex)
                {
                    transaction?.Rollback();
                    System.Diagnostics.Debug.WriteLine("Error deleting user and associated data: " + ex.Message);
                    return false;
                }
            }
        }

        private bool UpdateUser(int userId, string fullName, string email)
        {
            string connectionString = ConfigurationManager.ConnectionStrings["GymShop"].ConnectionString;

            using (SqlConnection con = new SqlConnection(connectionString))
            {
                string query = "UPDATE Users SET FullName = @FullName, Email = @Email WHERE UserID = @UserID";

                using (SqlCommand cmd = new SqlCommand(query, con))
                {
                    cmd.Parameters.AddWithValue("@UserID", userId);
                    cmd.Parameters.AddWithValue("@FullName", fullName);
                    cmd.Parameters.AddWithValue("@Email", email);

                    try
                    {
                        con.Open();
                        int rowsAffected = cmd.ExecuteNonQuery();
                        return rowsAffected > 0;
                    }
                    catch (Exception ex)
                    {
                        System.Diagnostics.Debug.WriteLine("Error updating user: " + ex.Message);
                        return false;
                    }
                }
            }
        }

        private bool IsEmailExistsForOtherUser(string email, int currentUserId)
        {
            string connectionString = ConfigurationManager.ConnectionStrings["GymShop"].ConnectionString;

            using (SqlConnection con = new SqlConnection(connectionString))
            {
                string query = "SELECT COUNT(*) FROM Users WHERE Email = @Email AND UserID != @UserID";

                using (SqlCommand cmd = new SqlCommand(query, con))
                {
                    cmd.Parameters.AddWithValue("@Email", email);
                    cmd.Parameters.AddWithValue("@UserID", currentUserId);

                    try
                    {
                        con.Open();
                        int count = Convert.ToInt32(cmd.ExecuteScalar());
                        return count > 0;
                    }
                    catch (Exception ex)
                    {
                        System.Diagnostics.Debug.WriteLine("Email check error: " + ex.Message);
                        return true; // Assume email exists if there's an error
                    }
                }
            }
        }

        private void ShowAlert(string message, string type)
        {
            pnlAlert.Visible = true;
            pnlAlert.CssClass = "alert alert-" + type;
            ltlAlertMessage.Text = message;
        }
    }
}