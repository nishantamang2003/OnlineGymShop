using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data.SqlClient;
using System.Linq;
using System.Web;
using System.Web.Security;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace OnlineGymStore.Pages.User
{
    public partial class UserProfile : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            // Check if user is logged in
            if (Session["UserEmail"] == null)
            {
                // Redirect to login page if not logged in
                Response.Redirect("~/Pages/User/Login.aspx");
                return;
            }

            // Only load user data when page is first loaded, not on postbacks
            if (!IsPostBack)
            {
                LoadUserProfile();
            }
        }

        protected override void OnPreRender(EventArgs e)
        {
            base.OnPreRender(e);

            // Set the LoginView to display the LoggedInTemplate when user is logged in via session
            if (Session["UserEmail"] != null)
            {
                FormsAuthentication.SetAuthCookie(Session["UserEmail"].ToString(), false);
            }
        }

        private void LoadUserProfile()
        {
            string email = Session["UserEmail"].ToString();
            string connectionString = ConfigurationManager.ConnectionStrings["GymShop"].ConnectionString;

            using (SqlConnection con = new SqlConnection(connectionString))
            {
                string query = "SELECT FullName FROM Users WHERE Email = @Email";

                using (SqlCommand cmd = new SqlCommand(query, con))
                {
                    cmd.Parameters.AddWithValue("@Email", email);

                    try
                    {
                        con.Open();
                        SqlDataReader reader = cmd.ExecuteReader();

                        if (reader.Read())
                        {
                            txtFullName.Text = reader["FullName"].ToString();
                            txtEmail.Text = email;
                        }
                        reader.Close();
                    }
                    catch (Exception ex)
                    {
                        lblProfileMessage.Text = "Error loading profile: " + ex.Message;
                        lblProfileMessage.CssClass = "validation-error";
                        lblProfileMessage.Visible = true;
                    }
                }
            }
        }

        protected void btnUpdateProfile_Click(object sender, EventArgs e)
        {
            string fullName = txtFullName.Text.Trim();
            string email = Session["UserEmail"].ToString();

            // Basic validation
            if (string.IsNullOrEmpty(fullName))
            {
                lblProfileMessage.Text = "Full name cannot be empty";
                lblProfileMessage.CssClass = "validation-error";
                lblProfileMessage.Visible = true;
                return;
            }

            // Update user profile
            if (UpdateUserProfile(fullName, email))
            {
                lblProfileMessage.Text = "Profile updated successfully";
                lblProfileMessage.CssClass = "success-message";
                lblProfileMessage.Visible = true;
            }
            else
            {
                lblProfileMessage.Text = "Failed to update profile. Please try again.";
                lblProfileMessage.CssClass = "validation-error";
                lblProfileMessage.Visible = true;
            }
        }

        private bool UpdateUserProfile(string fullName, string email)
        {
            string connectionString = ConfigurationManager.ConnectionStrings["GymShop"].ConnectionString;

            using (SqlConnection con = new SqlConnection(connectionString))
            {
                string query = "UPDATE Users SET FullName = @FullName WHERE Email = @Email";

                using (SqlCommand cmd = new SqlCommand(query, con))
                {
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
                        System.Diagnostics.Debug.WriteLine("Error updating profile: " + ex.Message);
                        return false;
                    }
                }
            }
        }

        protected void btnChangePassword_Click(object sender, EventArgs e)
        {
            string currentPassword = txtCurrentPassword.Text.Trim();
            string newPassword = txtNewPassword.Text.Trim();
            string confirmPassword = txtConfirmNewPassword.Text.Trim();
            string email = Session["UserEmail"].ToString();

            // Basic validation
            if (string.IsNullOrEmpty(currentPassword) || string.IsNullOrEmpty(newPassword) || string.IsNullOrEmpty(confirmPassword))
            {
                lblPasswordMessage.Text = "Please fill in all password fields";
                lblPasswordMessage.CssClass = "validation-error";
                lblPasswordMessage.Visible = true;
                return;
            }

            if (newPassword != confirmPassword)
            {
                lblPasswordMessage.Text = "New passwords do not match";
                lblPasswordMessage.CssClass = "validation-error";
                lblPasswordMessage.Visible = true;
                return;
            }

            // Verify current password
            if (!VerifyCurrentPassword(email, currentPassword))
            {
                lblPasswordMessage.Text = "Current password is incorrect";
                lblPasswordMessage.CssClass = "validation-error";
                lblPasswordMessage.Visible = true;
                return;
            }

            // Update password
            if (UpdatePassword(email, newPassword))
            {
                ClearPasswordFields();
                lblPasswordMessage.Text = "Password updated successfully";
                lblPasswordMessage.CssClass = "success-message";
                lblPasswordMessage.Visible = true;
            }
            else
            {
                lblPasswordMessage.Text = "Failed to update password. Please try again.";
                lblPasswordMessage.CssClass = "validation-error";
                lblPasswordMessage.Visible = true;
            }
        }

        private bool VerifyCurrentPassword(string email, string password)
        {
            string connectionString = ConfigurationManager.ConnectionStrings["GymShop"].ConnectionString;

            using (SqlConnection con = new SqlConnection(connectionString))
            {
                string query = "SELECT COUNT(*) FROM Users WHERE Email = @Email AND Password = @Password";

                using (SqlCommand cmd = new SqlCommand(query, con))
                {
                    cmd.Parameters.AddWithValue("@Email", email);
                    cmd.Parameters.AddWithValue("@Password", password);

                    try
                    {
                        con.Open();
                        int count = Convert.ToInt32(cmd.ExecuteScalar());
                        return count > 0;
                    }
                    catch (Exception ex)
                    {
                        System.Diagnostics.Debug.WriteLine("Password verification error: " + ex.Message);
                        return false;
                    }
                }
            }
        }

        private bool UpdatePassword(string email, string newPassword)
        {
            string connectionString = ConfigurationManager.ConnectionStrings["GymShop"].ConnectionString;

            using (SqlConnection con = new SqlConnection(connectionString))
            {
                string query = "UPDATE Users SET Password = @Password WHERE Email = @Email";

                using (SqlCommand cmd = new SqlCommand(query, con))
                {
                    cmd.Parameters.AddWithValue("@Password", newPassword);
                    cmd.Parameters.AddWithValue("@Email", email);

                    try
                    {
                        con.Open();
                        int rowsAffected = cmd.ExecuteNonQuery();
                        return rowsAffected > 0;
                    }
                    catch (Exception ex)
                    {
                        System.Diagnostics.Debug.WriteLine("Error updating password: " + ex.Message);
                        return false;
                    }
                }
            }
        }

        private void ClearPasswordFields()
        {
            txtCurrentPassword.Text = "";
            txtNewPassword.Text = "";
            txtConfirmNewPassword.Text = "";
        }
    }
}