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
    public partial class ManageCategories : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                // Check if admin is logged in (implement your own authentication check)
                // if (!IsAdminLoggedIn()) Response.Redirect("~/Pages/Admin/Login.aspx");

                LoadCategories();
            }
        }

        private void LoadCategories(string searchQuery = "")
        {
            string connectionString = ConfigurationManager.ConnectionStrings["GymShop"].ConnectionString;
            string query = "SELECT CategoryID, CategoryName, Description, ImageUrl, IsActive, CreatedDate FROM Categories";

            if (!string.IsNullOrEmpty(searchQuery))
            {
                query += " WHERE CategoryName LIKE @Search OR Description LIKE @Search";
            }

            query += " ORDER BY CategoryID DESC";

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

                        gvCategories.DataSource = dt;
                        gvCategories.DataBind();
                    }
                    catch (Exception ex)
                    {
                        ShowAlert("Error loading categories: " + ex.Message, "danger");
                        System.Diagnostics.Debug.WriteLine("Error loading categories: " + ex.Message);
                    }
                }
            }
        }

        protected void btnSearch_Click(object sender, EventArgs e)
        {
            LoadCategories(txtSearch.Text.Trim());
        }

        protected void btnClear_Click(object sender, EventArgs e)
        {
            txtSearch.Text = string.Empty;
            LoadCategories();
        }

        protected void btnAddCategory_Click(object sender, EventArgs e)
        {
            string categoryName = txtCategoryName.Text.Trim();
            string description = txtDescription.Text.Trim();
            string imageUrl = txtImageUrl.Text.Trim();
            bool isActive = chkIsActive.Checked;

            // Check if category name already exists
            if (IsCategoryNameExists(categoryName))
            {
                ShowAlert("Category name already exists", "warning");
                return;
            }

            // Add new category
            if (AddCategory(categoryName, description, imageUrl, isActive))
            {
                ClearAddCategoryForm();
                LoadCategories();
                ShowAlert("Category added successfully", "success");
            }
            else
            {
                ShowAlert("Failed to add category", "danger");
            }
        }

        protected void gvCategories_RowCommand(object sender, GridViewCommandEventArgs e)
        {
            // This method is used for handling custom commands
            // No special commands needed for now, standard commands are handled by their own event handlers
        }

        protected void gvCategories_RowEditing(object sender, GridViewEditEventArgs e)
        {
            // Set the row to edit mode and rebind the grid
            gvCategories.EditIndex = e.NewEditIndex;
            LoadCategories(txtSearch.Text.Trim());
        }

        protected void gvCategories_RowCancelingEdit(object sender, GridViewCancelEditEventArgs e)
        {
            // Exit edit mode and rebind the grid
            gvCategories.EditIndex = -1;
            LoadCategories(txtSearch.Text.Trim());
        }

        protected void gvCategories_RowUpdating(object sender, GridViewUpdateEventArgs e)
        {
            // Get the CategoryID for the row being updated
            int categoryId = Convert.ToInt32(gvCategories.DataKeys[e.RowIndex].Value);

            // Find the controls in the GridView row
            GridViewRow row = gvCategories.Rows[e.RowIndex];
            TextBox txtEditCategoryName = (TextBox)row.FindControl("txtEditCategoryName");
            TextBox txtEditDescription = (TextBox)row.FindControl("txtEditDescription");
            TextBox txtEditImageUrl = (TextBox)row.FindControl("txtEditImageUrl");
            CheckBox chkEditIsActive = (CheckBox)row.FindControl("chkEditIsActive");

            // Validate that we found all the controls
            if (txtEditCategoryName == null || txtEditDescription == null ||
                txtEditImageUrl == null || chkEditIsActive == null)
            {
                ShowAlert("Error finding form controls. Please try again.", "danger");
                gvCategories.EditIndex = -1;
                LoadCategories(txtSearch.Text.Trim());
                return;
            }

            // Get values from controls
            string categoryName = txtEditCategoryName.Text.Trim();
            string description = txtEditDescription.Text.Trim();
            string imageUrl = txtEditImageUrl.Text.Trim();
            bool isActive = chkEditIsActive.Checked;

            // Basic validation
            if (string.IsNullOrEmpty(categoryName))
            {
                ShowAlert("Category name is required", "warning");
                return;
            }

            // Check if category name already exists for other categories
            if (IsCategoryNameExistsForOther(categoryName, categoryId))
            {
                ShowAlert("Category name already exists for another category", "warning");
                return;
            }

            // Update category
            if (UpdateCategory(categoryId, categoryName, description, imageUrl, isActive))
            {
                // Exit edit mode
                gvCategories.EditIndex = -1;
                // Reload the data
                LoadCategories(txtSearch.Text.Trim());
                ShowAlert("Category updated successfully", "success");
            }
            else
            {
                ShowAlert("Failed to update category", "danger");
            }
        }

        protected void gvCategories_RowDeleting(object sender, GridViewDeleteEventArgs e)
        {
            int categoryId = Convert.ToInt32(gvCategories.DataKeys[e.RowIndex].Value);

            // Check if category is being used in products (you'll need to implement this if you have a Products table)
            // if (IsCategoryInUse(categoryId))
            // {
            //     ShowAlert("Cannot delete category because it is associated with products", "warning");
            //     return;
            // }

            if (DeleteCategory(categoryId))
            {
                LoadCategories(txtSearch.Text.Trim());
                ShowAlert("Category deleted successfully", "success");
            }
            else
            {
                ShowAlert("Failed to delete category", "danger");
            }
        }

        private bool IsCategoryNameExists(string categoryName)
        {
            string connectionString = ConfigurationManager.ConnectionStrings["GymShop"].ConnectionString;

            using (SqlConnection con = new SqlConnection(connectionString))
            {
                string query = "SELECT COUNT(*) FROM Categories WHERE CategoryName = @CategoryName";

                using (SqlCommand cmd = new SqlCommand(query, con))
                {
                    cmd.Parameters.AddWithValue("@CategoryName", categoryName);

                    try
                    {
                        con.Open();
                        int count = Convert.ToInt32(cmd.ExecuteScalar());
                        return count > 0;
                    }
                    catch (Exception ex)
                    {
                        System.Diagnostics.Debug.WriteLine("Error checking category name: " + ex.Message);
                        return false;
                    }
                }
            }
        }

        private bool IsCategoryNameExistsForOther(string categoryName, int currentCategoryId)
        {
            string connectionString = ConfigurationManager.ConnectionStrings["GymShop"].ConnectionString;

            using (SqlConnection con = new SqlConnection(connectionString))
            {
                string query = "SELECT COUNT(*) FROM Categories WHERE CategoryName = @CategoryName AND CategoryID != @CategoryID";

                using (SqlCommand cmd = new SqlCommand(query, con))
                {
                    cmd.Parameters.AddWithValue("@CategoryName", categoryName);
                    cmd.Parameters.AddWithValue("@CategoryID", currentCategoryId);

                    try
                    {
                        con.Open();
                        int count = Convert.ToInt32(cmd.ExecuteScalar());
                        return count > 0;
                    }
                    catch (Exception ex)
                    {
                        System.Diagnostics.Debug.WriteLine("Error checking category name: " + ex.Message);
                        return false;
                    }
                }
            }
        }

        private bool AddCategory(string categoryName, string description, string imageUrl, bool isActive)
        {
            string connectionString = ConfigurationManager.ConnectionStrings["GymShop"].ConnectionString;

            using (SqlConnection con = new SqlConnection(connectionString))
            {
                string query = @"INSERT INTO Categories (CategoryName, Description, ImageUrl, IsActive, CreatedDate) 
                        VALUES (@CategoryName, @Description, @ImageUrl, @IsActive, @CreatedDate)";

                using (SqlCommand cmd = new SqlCommand(query, con))
                {
                    cmd.Parameters.AddWithValue("@CategoryName", categoryName);
                    cmd.Parameters.AddWithValue("@Description", string.IsNullOrEmpty(description) ? DBNull.Value : (object)description);
                    cmd.Parameters.AddWithValue("@ImageUrl", string.IsNullOrEmpty(imageUrl) ? DBNull.Value : (object)imageUrl);
                    cmd.Parameters.AddWithValue("@IsActive", isActive);
                    cmd.Parameters.AddWithValue("@CreatedDate", DateTime.Now);

                    try
                    {
                        con.Open();
                        int rowsAffected = cmd.ExecuteNonQuery();
                        return rowsAffected > 0;
                    }
                    catch (Exception ex)
                    {
                        System.Diagnostics.Debug.WriteLine("Error adding category: " + ex.Message);
                        return false;
                    }
                }
            }
        }

        private bool UpdateCategory(int categoryId, string categoryName, string description, string imageUrl, bool isActive)
        {
            string connectionString = ConfigurationManager.ConnectionStrings["GymShop"].ConnectionString;

            using (SqlConnection con = new SqlConnection(connectionString))
            {
                string query = @"UPDATE Categories SET 
                        CategoryName = @CategoryName, 
                        Description = @Description, 
                        ImageUrl = @ImageUrl, 
                        IsActive = @IsActive 
                        WHERE CategoryID = @CategoryID";

                using (SqlCommand cmd = new SqlCommand(query, con))
                {
                    cmd.Parameters.AddWithValue("@CategoryID", categoryId);
                    cmd.Parameters.AddWithValue("@CategoryName", categoryName);
                    cmd.Parameters.AddWithValue("@Description", string.IsNullOrEmpty(description) ? DBNull.Value : (object)description);
                    cmd.Parameters.AddWithValue("@ImageUrl", string.IsNullOrEmpty(imageUrl) ? DBNull.Value : (object)imageUrl);
                    cmd.Parameters.AddWithValue("@IsActive", isActive);

                    try
                    {
                        con.Open();
                        int rowsAffected = cmd.ExecuteNonQuery();
                        return rowsAffected > 0;
                    }
                    catch (Exception ex)
                    {
                        System.Diagnostics.Debug.WriteLine("Error updating category: " + ex.Message);
                        ShowAlert("Database error: " + ex.Message, "danger");
                        return false;
                    }
                }
            }
        }

        private bool DeleteCategory(int categoryId)
        {
            string connectionString = ConfigurationManager.ConnectionStrings["GymShop"].ConnectionString;

            using (SqlConnection con = new SqlConnection(connectionString))
            {
                string query = "DELETE FROM Categories WHERE CategoryID = @CategoryID";

                using (SqlCommand cmd = new SqlCommand(query, con))
                {
                    cmd.Parameters.AddWithValue("@CategoryID", categoryId);

                    try
                    {
                        con.Open();
                        int rowsAffected = cmd.ExecuteNonQuery();
                        return rowsAffected > 0;
                    }
                    catch (Exception ex)
                    {
                        System.Diagnostics.Debug.WriteLine("Error deleting category: " + ex.Message);
                        return false;
                    }
                }
            }
        }

        private void ClearAddCategoryForm()
        {
            txtCategoryName.Text = string.Empty;
            txtDescription.Text = string.Empty;
            txtImageUrl.Text = string.Empty;
            chkIsActive.Checked = true;
        }

        private void ShowAlert(string message, string type)
        {
            pnlAlert.Visible = true;
            pnlAlert.CssClass = "alert alert-" + type;
            ltlAlertMessage.Text = message;
        }
    }
}