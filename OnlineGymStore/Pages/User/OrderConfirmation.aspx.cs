using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data.SqlClient;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace OnlineGymStore.Pages.User
{
    public partial class OrderConfirmation : System.Web.UI.Page
  
        {
            string connStr = ConfigurationManager.ConnectionStrings["GymShop"].ConnectionString;

            protected void Page_Load(object sender, EventArgs e)
            {
                if (Session["UserEmail"] == null)
                {
                    Response.Redirect("Login.aspx");
                    return;
                }

                if (!IsPostBack)
                {
                    string orderId = Request.QueryString["OrderID"];
                    if (string.IsNullOrEmpty(orderId))
                    {
                        Response.Redirect("Cart.aspx");
                        return;
                    }

                    LoadOrderDetails(Convert.ToInt32(orderId));
                }
            }

            private void LoadOrderDetails(int orderId)
            {
                int userId = GetUserId();
                if (userId == 0)
                {
                    Response.Redirect("Login.aspx");
                    return;
                }

                try
                {
                    using (SqlConnection conn = new SqlConnection(connStr))
                    {
                        string query = @"SELECT OrderID, OrderDate, Total 
                                  FROM Orders 
                                  WHERE OrderID = @OrderID AND UserID = @UserID";

                        using (SqlCommand cmd = new SqlCommand(query, conn))
                        {
                            cmd.Parameters.AddWithValue("@OrderID", orderId);
                            cmd.Parameters.AddWithValue("@UserID", userId);
                            conn.Open();

                            using (SqlDataReader reader = cmd.ExecuteReader())
                            {
                                if (reader.Read())
                                {
                                    lblOrderId.Text = reader["OrderID"].ToString();
                                    lblOrderDate.Text = Convert.ToDateTime(reader["OrderDate"]).ToString("MMMM dd, yyyy");
                                    lblOrderTotal.Text = "$" + Convert.ToDecimal(reader["Total"]).ToString("0.00");
                                }
                                else
                                {
                                    // Order not found or doesn't belong to user
                                    Response.Redirect("Cart.aspx");
                                }
                            }
                        }
                    }
                }
                catch (Exception ex)
                {
                    ScriptManager.RegisterStartupScript(this, GetType(), "showalert",
                        $"alert('Error loading order details: {ex.Message.Replace("'", "\\'")}');", true);
                }
            }

            private int GetUserId()
            {
                if (Session["UserEmail"] == null) return 0;

                string email = Session["UserEmail"].ToString();
                using (SqlConnection conn = new SqlConnection(connStr))
                {
                    string query = "SELECT UserID FROM Users WHERE Email = @Email";
                    using (SqlCommand cmd = new SqlCommand(query, conn))
                    {
                        cmd.Parameters.AddWithValue("@Email", email);
                        conn.Open();
                        object result = cmd.ExecuteScalar();
                        return result != null ? Convert.ToInt32(result) : 0;
                    }
                }
            }
        }
    }

