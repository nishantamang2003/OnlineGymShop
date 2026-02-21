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
    public partial class Signup : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            // Check if the user is logged in using your session variable
            if (Session["UserEmail"] != null)
            {
                // User is logged in, no need to set lblUsername as we're using Session directly in the markup
            }

            // Set Cart Count based on session or database
            if (Session["CartCount"] != null)
            {
                //lblCartCount.Text = Session["CartCount"].ToString();
            }
            else
            {
                //lblCartCount.Text = "0"; // Default to 0 if no session count
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

        protected void btnSignup_Click(object sender, EventArgs e)
        {
            string fullName = txtFullName.Text.Trim();
            string email = txtEmail.Text.Trim();
            string password = txtPassword.Text.Trim();
            string confirmPassword = txtConfirmPassword.Text.Trim();

            // Basic validation
            if (string.IsNullOrEmpty(fullName) || string.IsNullOrEmpty(email) ||
                string.IsNullOrEmpty(password) || string.IsNullOrEmpty(confirmPassword))
            {
                lblMessage.Text = "Please fill in all fields";
                lblMessage.CssClass = "validation-error";
                lblMessage.Visible = true;
                return;
            }

            if (password != confirmPassword)
            {
                lblMessage.Text = "Passwords do not match";
                lblMessage.CssClass = "validation-error";
                lblMessage.Visible = true;
                return;
            }

            if (IsEmailExists(email))
            {
                lblMessage.Text = "Email is already registered";
                lblMessage.CssClass = "validation-error";
                lblMessage.Visible = true;
                return;
            }

            // Register user with plain text password
            if (RegisterUser(fullName, email, password))
            {
                ClearForm();
                lblMessage.Text = "Registration successful! You can now login.";
                lblMessage.CssClass = "success-message";
                lblMessage.Visible = true;
            }
            else
            {
                lblMessage.Text = "Registration failed. Please try again.";
                lblMessage.CssClass = "validation-error";
                lblMessage.Visible = true;
            }
        }

        private bool IsEmailExists(string email)
        {
            string connectionString = ConfigurationManager.ConnectionStrings["GymShop"].ConnectionString;

            using (SqlConnection con = new SqlConnection(connectionString))
            {
                string query = "SELECT COUNT(*) FROM Users WHERE Email = @Email";

                using (SqlCommand cmd = new SqlCommand(query, con))
                {
                    cmd.Parameters.AddWithValue("@Email", email);

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

        private bool RegisterUser(string fullName, string email, string password)
        {
            string connectionString = ConfigurationManager.ConnectionStrings["GymShop"].ConnectionString;

            using (SqlConnection con = new SqlConnection(connectionString))
            {
                string query = "INSERT INTO Users (FullName, Email, Password) VALUES (@FullName, @Email, @Password)";

                using (SqlCommand cmd = new SqlCommand(query, con))
                {
                    cmd.Parameters.AddWithValue("@FullName", fullName);
                    cmd.Parameters.AddWithValue("@Email", email);
                    cmd.Parameters.AddWithValue("@Password", password);

                    try
                    {
                        con.Open();
                        int rowsAffected = cmd.ExecuteNonQuery();
                        return rowsAffected > 0;
                    }
                    catch (SqlException sqlEx)
                    {
                        System.Diagnostics.Debug.WriteLine("SQL Error: " + sqlEx.Message);
                        return false;
                    }
                    catch (Exception ex)
                    {
                        System.Diagnostics.Debug.WriteLine("Error: " + ex.Message);
                        return false;
                    }
                }
            }
        }

        private void ClearForm()
        {
            txtFullName.Text = "";
            txtEmail.Text = "";
            txtPassword.Text = "";
            txtConfirmPassword.Text = "";
        }
    }
}