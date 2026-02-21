using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data.SqlClient;
using System.Linq;
using System.Web;
using System.Web.Security;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace OnlineGymStore
{
    public partial class SiteMaster : MasterPage
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            // Page load
        }

        // Method to determine active navigation link
        public string GetActiveClass(string currentPath, string linkPath)
        {
            return currentPath.EndsWith(linkPath, StringComparison.OrdinalIgnoreCase) ? "active" : "";
        }

        protected string GetUserFullName()
        {
            if (Session["UserEmail"] != null)
            {
                string email = Session["UserEmail"].ToString();
                string connectionString = ConfigurationManager.ConnectionStrings["GymShop"].ConnectionString;

                using (SqlConnection connection = new SqlConnection(connectionString))
                {
                    string query = "SELECT FullName FROM Users WHERE Email = @Email";
                    SqlCommand command = new SqlCommand(query, connection);
                    command.Parameters.AddWithValue("@Email", email);

                    try
                    {
                        connection.Open();
                        object result = command.ExecuteScalar();

                        if (result != null)
                        {
                            return result.ToString();
                        }
                    }
                    catch (Exception ex)
                    {
                        // Log the exception if needed
                        System.Diagnostics.Debug.WriteLine("Error getting user name: " + ex.Message);
                    }
                }

                // Return email if name not found
                return email;
            }

            return "User";
        }

        // Logout functionality
        protected void btnLogout_Click(object sender, EventArgs e)
        {
            // Clear session variables
            Session.Clear();
            Session.Abandon();

            // Clear authentication cookie
            FormsAuthentication.SignOut();

            // Redirect to login page
            Response.Redirect("~/Pages/User/LandingPage.aspx");
        }
    }
}