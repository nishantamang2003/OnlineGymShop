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
    public partial class Login : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            // If the user is already authenticated, redirect to appropriate page
            if (User.Identity.IsAuthenticated && !IsPostBack)
            {
                string returnUrl = Request.QueryString["ReturnUrl"];
                if (!string.IsNullOrEmpty(returnUrl))
                {
                    Response.Redirect(returnUrl);
                }
                else
                {
                    // Check user role and redirect accordingly
                    if (Session["UserRole"] != null && Session["UserRole"].ToString() == "Admin")
                    {
                        Response.Redirect("~/Pages/Admin/Dashboard.aspx");
                    }
                    else
                    {
                        Response.Redirect("~/Pages/User/LandingPage.aspx");
                    }
                }
            }
        }

        protected void btnLogin_Click(object sender, EventArgs e)
        {
            string email = txtEmail.Text.Trim();
            string password = txtPassword.Text.Trim();

            // Basic validation
            if (string.IsNullOrEmpty(email) || string.IsNullOrEmpty(password))
            {
                ShowMessage("Please enter both email and password", false);
                return;
            }

            try
            {
                // Check for admin credentials
                if (email.Equals("admin89@gmail.com", StringComparison.OrdinalIgnoreCase) &&
                    password.Equals("ADMIN89"))
                {
                    // Set session variables
                    Session["UserEmail"] = email;
                    Session["UserRole"] = "Admin";

                    // Set authentication cookie
                    FormsAuthentication.SetAuthCookie(email, false);

                    // Handle return URL if exists
                    string returnUrl = Request.QueryString["ReturnUrl"];
                    if (!string.IsNullOrEmpty(returnUrl))
                    {
                        Response.Redirect(returnUrl);
                    }
                    else
                    {
                        Response.Redirect("~/Pages/Admin/Dashboard.aspx");
                    }
                    return;
                }

                // Regular user authentication
                if (AuthenticateUser(email, password))
                {
                    // After successful authentication
                    FormsAuthentication.SetAuthCookie(email, false);
                    Session["UserEmail"] = email;
                    Session["UserRole"] = "User";

                    // Check for return URL from query string
                    string returnUrl = Request.QueryString["ReturnUrl"];

                    if (!string.IsNullOrEmpty(returnUrl))
                    {
                        // Redirect to the originally requested page
                        // Any stored product actions in Session will be handled there
                        Response.Redirect(returnUrl);
                    }
                    else
                    {
                        // Default redirect after login
                        Response.Redirect("~/Pages/User/LandingPage.aspx");
                    }
                }
                else
                {
                    ShowMessage("Invalid email or password", false);
                }
            }
            catch (Exception ex)
            {
                ShowMessage("An error occurred during login. Please try again.", false);
                System.Diagnostics.Debug.WriteLine("Login error: " + ex.Message);
            }
        }

        private bool AuthenticateUser(string email, string password)
        {
            string connectionString = ConfigurationManager.ConnectionStrings["GymShop"].ConnectionString;

            using (SqlConnection con = new SqlConnection(connectionString))
            {
                string query = "SELECT COUNT(*) FROM Users WHERE Email = @Email AND Password = @Password";

                using (SqlCommand cmd = new SqlCommand(query, con))
                {
                    cmd.Parameters.AddWithValue("@Email", email);
                    cmd.Parameters.AddWithValue("@Password", password); // Note: In production, use hashed passwords

                    con.Open();
                    int count = Convert.ToInt32(cmd.ExecuteScalar());
                    return count > 0;
                }
            }
        }

        private void ShowMessage(string message, bool isSuccess)
        {
            lblMessage.Text = message;
            lblMessage.CssClass = isSuccess ? "success-message" : "validation-error";
            lblMessage.Visible = true;
        }

        protected void btnLogout_Click(object sender, EventArgs e)
        {
            FormsAuthentication.SignOut();
            Session.Clear();
            Session.Abandon();

            // Clear authentication cookie
            HttpCookie cookie = new HttpCookie(FormsAuthentication.FormsCookieName, "");
            cookie.Expires = DateTime.Now.AddYears(-1);
            Response.Cookies.Add(cookie);

            Response.Redirect("~/Pages/User/Login.aspx");
        }
    }
}
