using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data.SqlClient;
using System.Data;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace OnlineGymStore.Pages.User
{
    public partial class MyOrders : System.Web.UI.Page

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
                    string orderIdParam = Request.QueryString["OrderID"];

                    if (!string.IsNullOrEmpty(orderIdParam) && int.TryParse(orderIdParam, out int orderId))
                    {
                        // Show specific order details
                        LoadOrderDetails(orderId);
                    }
                    else
                    {
                        // Show order list
                        LoadOrders();
                    }
                }
            }

            private void LoadOrders()
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
                        string query = @"SELECT OrderID, OrderDate, Total, Status 
                                  FROM Orders 
                                  WHERE UserID = @UserID 
                                  ORDER BY OrderDate DESC";

                        using (SqlCommand cmd = new SqlCommand(query, conn))
                        {
                            cmd.Parameters.AddWithValue("@UserID", userId);
                            conn.Open();

                            DataTable dt = new DataTable();
                            dt.Load(cmd.ExecuteReader());

                            if (dt.Rows.Count > 0)
                            {
                                gvOrders.DataSource = dt;
                                gvOrders.DataBind();
                                pnlOrders.Visible = true;
                                pnlNoOrders.Visible = false;
                            }
                            else
                            {
                                pnlOrders.Visible = false;
                                pnlNoOrders.Visible = true;
                            }

                            pnlOrderDetails.Visible = false;
                        }
                    }
                }
                catch (Exception ex)
                {
                    ShowAlert("Error loading orders: " + ex.Message);
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
                        conn.Open();

                        // First, verify that this order belongs to the current user
                        string verifyQuery = "SELECT COUNT(*) FROM Orders WHERE OrderID = @OrderID AND UserID = @UserID";
                        using (SqlCommand verifyCmd = new SqlCommand(verifyQuery, conn))
                        {
                            verifyCmd.Parameters.AddWithValue("@OrderID", orderId);
                            verifyCmd.Parameters.AddWithValue("@UserID", userId);
                            int count = (int)verifyCmd.ExecuteScalar();

                            if (count == 0)
                            {
                                // Order doesn't belong to this user or doesn't exist
                                Response.Redirect("MyOrders.aspx");
                                return;
                            }
                        }

                        // Get order details
                        string orderQuery = @"SELECT OrderID, OrderDate, Status, Subtotal, Shipping, Tax, Total 
                                      FROM Orders 
                                      WHERE OrderID = @OrderID";

                        using (SqlCommand cmd = new SqlCommand(orderQuery, conn))
                        {
                            cmd.Parameters.AddWithValue("@OrderID", orderId);
                            using (SqlDataReader reader = cmd.ExecuteReader())
                            {
                                if (reader.Read())
                                {
                                    lblOrderId.Text = reader["OrderID"].ToString();
                                    lblOrderDate.Text = Convert.ToDateTime(reader["OrderDate"]).ToString("MMMM dd, yyyy");
                                    lblOrderStatus.Text = reader["Status"].ToString();
                                    lblSubtotal.Text = "$" + Convert.ToDecimal(reader["Subtotal"]).ToString("0.00");
                                    lblShipping.Text = "$" + Convert.ToDecimal(reader["Shipping"]).ToString("0.00");
                                    lblTax.Text = "$" + Convert.ToDecimal(reader["Tax"]).ToString("0.00");
                                    lblTotal.Text = "$" + Convert.ToDecimal(reader["Total"]).ToString("0.00");
                                }
                                else
                                {
                                    // Order not found (shouldn't happen since we verified above)
                                    Response.Redirect("MyOrders.aspx");
                                    return;
                                }
                            }
                        }

                        // Get order items
                        string itemsQuery = @"SELECT p.ProductName, oi.Quantity, oi.UnitPrice, 
                                       (oi.Quantity * oi.UnitPrice) AS ItemTotal 
                                       FROM OrderItems oi 
                                       INNER JOIN Products p ON oi.ProductID = p.ProductID 
                                       WHERE oi.OrderID = @OrderID";

                        using (SqlCommand cmd = new SqlCommand(itemsQuery, conn))
                        {
                            cmd.Parameters.AddWithValue("@OrderID", orderId);
                            DataTable dt = new DataTable();
                            dt.Load(cmd.ExecuteReader());

                            gvOrderItems.DataSource = dt;
                            gvOrderItems.DataBind();
                        }

                        // Show order details panel, hide others
                        pnlOrderDetails.Visible = true;
                        pnlOrders.Visible = false;
                        pnlNoOrders.Visible = false;
                    }
                }
                catch (Exception ex)
                {
                    ShowAlert("Error loading order details: " + ex.Message);
                }
            }

            protected void gvOrders_RowCommand(object sender, GridViewCommandEventArgs e)
            {
                if (e.CommandName == "ViewDetails")
                {
                    int orderId = Convert.ToInt32(e.CommandArgument);
                    Response.Redirect($"MyOrders.aspx?OrderID={orderId}");
                }
            }

            protected void lnkBackToOrders_Click(object sender, EventArgs e)
            {
                Response.Redirect("MyOrders.aspx");
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

            private void ShowAlert(string message)
            {
                ScriptManager.RegisterStartupScript(this, GetType(), "showalert",
                    $"alert('{message.Replace("'", "\\'")}');", true);
            }
        }
    }

