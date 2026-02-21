using OnlineGymStore.Pages.User;
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
    public partial class ManageOrders : System.Web.UI.Page
   
        {
            string connStr = ConfigurationManager.ConnectionStrings["GymShop"].ConnectionString;

            protected void Page_Load(object sender, EventArgs e)
            {
                // Check if the user is logged in and is an admin
                if (Session["UserEmail"] == null || Session["UserRole"] == null || Session["UserRole"].ToString() != "Admin")
                {
                    Response.Redirect("~/Pages/User/Login.aspx");
                    return;
                }

                if (!IsPostBack)
                {
                    string orderIdParam = Request.QueryString["OrderID"];

                    if (!string.IsNullOrEmpty(orderIdParam) && int.TryParse(orderIdParam, out int orderId))
                    {
                        // Show specific order details for updating
                        LoadOrderForUpdate(orderId);
                    }
                    else
                    {
                        // Show all orders
                        LoadAllOrders();
                    }
                }
            }

            private void LoadAllOrders()
            {
                try
                {
                    using (SqlConnection conn = new SqlConnection(connStr))
                    {
                        string query = @"SELECT o.OrderID, o.OrderDate, o.Total, o.Status, u.FullName, u.Email 
                                  FROM Orders o
                                  INNER JOIN Users u ON o.UserID = u.UserID
                                  ORDER BY o.OrderDate DESC";

                        using (SqlCommand cmd = new SqlCommand(query, conn))
                        {
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

                            pnlOrderUpdate.Visible = false;
                        }
                    }
                }
                catch (Exception ex)
                {
                    ShowAlert("Error loading orders: " + ex.Message);
                }
            }

            private void LoadOrderForUpdate(int orderId)
            {
                try
                {
                    using (SqlConnection conn = new SqlConnection(connStr))
                    {
                        conn.Open();

                        // Get order details
                        string orderQuery = @"SELECT o.OrderID, o.OrderDate, o.Status, o.Total, u.FullName, u.Email 
                                      FROM Orders o
                                      INNER JOIN Users u ON o.UserID = u.UserID
                                      WHERE o.OrderID = @OrderID";

                        using (SqlCommand cmd = new SqlCommand(orderQuery, conn))
                        {
                            cmd.Parameters.AddWithValue("@OrderID", orderId);
                            using (SqlDataReader reader = cmd.ExecuteReader())
                            {
                                if (reader.Read())
                                {
                                    lblOrderId.Text = reader["OrderID"].ToString();
                                    lblCustomerName.Text = reader["FullName"].ToString();
                                    lblCustomerEmail.Text = reader["Email"].ToString();
                                    lblOrderDate.Text = Convert.ToDateTime(reader["OrderDate"]).ToString("MMMM dd, yyyy");
                                    lblTotal.Text = "$" + Convert.ToDecimal(reader["Total"]).ToString("0.00");

                                    // Set the current status in dropdown
                                    string currentStatus = reader["Status"].ToString();
                                    ddlOrderStatus.SelectedValue = currentStatus;
                                }
                                else
                                {
                                    // Order not found
                                    Response.Redirect("ManageOrders.aspx");
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

                        // Show order update panel, hide others
                        pnlOrderUpdate.Visible = true;
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
                if (e.CommandName == "UpdateOrder")
                {
                    int orderId = Convert.ToInt32(e.CommandArgument);
                    Response.Redirect($"ManageOrders.aspx?OrderID={orderId}");
                }
            }

            protected void btnUpdateStatus_Click(object sender, EventArgs e)
            {
                if (string.IsNullOrEmpty(lblOrderId.Text))
                {
                    ShowAlert("Order ID is missing.");
                    return;
                }

                int orderId = Convert.ToInt32(lblOrderId.Text);
                string newStatus = ddlOrderStatus.SelectedValue;

                try
                {
                    using (SqlConnection conn = new SqlConnection(connStr))
                    {
                        string updateQuery = "UPDATE Orders SET Status = @Status WHERE OrderID = @OrderID";
                        using (SqlCommand cmd = new SqlCommand(updateQuery, conn))
                        {
                            cmd.Parameters.AddWithValue("@Status", newStatus);
                            cmd.Parameters.AddWithValue("@OrderID", orderId);

                            conn.Open();
                            int rowsAffected = cmd.ExecuteNonQuery();

                            if (rowsAffected > 0)
                            {
                                LogStatusChange(orderId, newStatus);
                                ShowAlert("Order status updated successfully.");
                                LoadAllOrders(); // Refresh the orders list
                            }
                            else
                            {
                                ShowAlert("Failed to update order status.");
                            }
                        }
                    }
                }
                catch (Exception ex)
                {
                    ShowAlert("Error updating order status: " + ex.Message);
                }
            }

            private void LogStatusChange(int orderId, string newStatus)
            {
                // Optional: Log the status change in a separate table for audit trail
                try
                {
                    using (SqlConnection conn = new SqlConnection(connStr))
                    {
                        string logQuery = @"INSERT INTO OrderStatusLogs (OrderID, NewStatus, ChangedBy, ChangeDate) 
                                    VALUES (@OrderID, @NewStatus, @ChangedBy, GETDATE())";

                        using (SqlCommand cmd = new SqlCommand(logQuery, conn))
                        {
                            cmd.Parameters.AddWithValue("@OrderID", orderId);
                            cmd.Parameters.AddWithValue("@NewStatus", newStatus);
                            cmd.Parameters.AddWithValue("@ChangedBy", Session["UserEmail"].ToString());

                            conn.Open();
                            cmd.ExecuteNonQuery();
                        }
                    }
                }
                catch
                {
                    // Just suppress errors in logging - it's not critical
                }
            }

            protected void lnkBackToOrders_Click(object sender, EventArgs e)
            {
                Response.Redirect("ManageOrders.aspx");
            }

            private void ShowAlert(string message)
            {
                ScriptManager.RegisterStartupScript(this, GetType(), "showalert",
                    $"alert('{message.Replace("'", "\\'")}');", true);
            }
        }
    }

