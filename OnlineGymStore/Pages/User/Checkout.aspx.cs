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
    public partial class Checkout : System.Web.UI.Page
    

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
                    LoadCartSummary();
                }
            }

            private void LoadCartSummary()
            {
                try
                {
                    int userId = GetUserId();
                    if (userId == 0)
                    {
                        Response.Redirect("Login.aspx");
                        return;
                    }

                    // Check if cart exists and has items
                    bool hasCart = false;
                    using (SqlConnection conn = new SqlConnection(connStr))
                    {
                        string checkCartQuery = @"SELECT COUNT(*) FROM CartItems ci 
                                    INNER JOIN Carts c ON ci.CartID = c.CartID 
                                    WHERE c.UserID = @UserID AND c.IsActive = 1";

                        using (SqlCommand checkCmd = new SqlCommand(checkCartQuery, conn))
                        {
                            checkCmd.Parameters.AddWithValue("@UserID", userId);
                            conn.Open();
                            int itemCount = (int)checkCmd.ExecuteScalar();
                            hasCart = (itemCount > 0);
                        }
                    }

                    if (!hasCart)
                    {
                        // Redirect to cart page if cart is empty
                        Response.Redirect("Cart.aspx");
                        return;
                    }

                    // Load cart summary
                    using (SqlConnection conn = new SqlConnection(connStr))
                    {
                        string query = @"SELECT p.ProductName, ci.Quantity, ci.PriceAtAddition AS Price, 
                                  (ci.PriceAtAddition * ci.Quantity) AS ItemTotal
                                  FROM CartItems ci
                                  INNER JOIN Carts c ON ci.CartID = c.CartID
                                  INNER JOIN Products p ON ci.ProductID = p.ProductID
                                  WHERE c.UserID = @UserID AND c.IsActive = 1";

                        using (SqlCommand cmd = new SqlCommand(query, conn))
                        {
                            cmd.Parameters.AddWithValue("@UserID", userId);
                            conn.Open();

                            DataTable dt = new DataTable();
                            dt.Load(cmd.ExecuteReader());

                            rptOrderSummary.DataSource = dt;
                            rptOrderSummary.DataBind();

                            // Calculate totals
                            decimal subtotal = dt.AsEnumerable()
                                               .Sum(row => Convert.ToDecimal(row["ItemTotal"]));
                            decimal shipping = 5.00m; // Fixed shipping cost
                            decimal tax = Math.Round(subtotal * 0.08m, 2); // 8% tax
                            decimal total = subtotal + shipping + tax;

                            lblSubtotal.Text = "$" + subtotal.ToString("0.00");
                            lblShipping.Text = "$" + shipping.ToString("0.00");
                            lblTax.Text = "$" + tax.ToString("0.00");
                            lblTotal.Text = "$" + total.ToString("0.00");

                            // Store values in ViewState for use during order placement
                            ViewState["Subtotal"] = subtotal;
                            ViewState["Shipping"] = shipping;
                            ViewState["Tax"] = tax;
                            ViewState["Total"] = total;
                        }
                    }

                    // Pre-fill form with user information
                    FillUserInformation(userId);
                }
                catch (Exception ex)
                {
                    ShowAlert("Error loading checkout details: " + ex.Message);
                }
            }

            private void FillUserInformation(int userId)
            {
                using (SqlConnection conn = new SqlConnection(connStr))
                {
                    string query = "SELECT FullName, Email FROM Users WHERE UserID = @UserID";
                    using (SqlCommand cmd = new SqlCommand(query, conn))
                    {
                        cmd.Parameters.AddWithValue("@UserID", userId);
                        conn.Open();
                        using (SqlDataReader reader = cmd.ExecuteReader())
                        {
                            if (reader.Read())
                            {
                                string fullName = reader["FullName"].ToString();
                                string email = reader["Email"].ToString();

                                // Split full name into first and last name (simple approach)
                                string[] nameParts = fullName.Split(' ');
                                if (nameParts.Length > 0)
                                {
                                    txtFirstName.Text = nameParts[0];
                                    if (nameParts.Length > 1)
                                    {
                                        txtLastName.Text = string.Join(" ", nameParts.Skip(1));
                                    }
                                }

                                txtEmail.Text = email;
                            }
                        }
                    }
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

            protected void btnPlaceOrder_Click(object sender, EventArgs e)
            {
                if (!Page.IsValid)
                {
                    ShowAlert("Please fill all required fields correctly.");
                    return;
                }

                int userId = GetUserId();
                if (userId == 0)
                {
                    Response.Redirect("Login.aspx");
                    return;
                }

                // Get cart ID
                int cartId = 0;
                using (SqlConnection conn = new SqlConnection(connStr))
                {
                    string query = "SELECT CartID FROM Carts WHERE UserID = @UserID AND IsActive = 1";
                    using (SqlCommand cmd = new SqlCommand(query, conn))
                    {
                        cmd.Parameters.AddWithValue("@UserID", userId);
                        conn.Open();
                        object result = cmd.ExecuteScalar();
                        cartId = result != null ? Convert.ToInt32(result) : 0;
                    }
                }

                if (cartId == 0)
                {
                    ShowAlert("Your cart is empty.");
                    return;
                }

                using (SqlConnection conn = new SqlConnection(connStr))
                {
                    conn.Open();
                    SqlTransaction transaction = conn.BeginTransaction();

                    try
                    {
                        // 1. Create order record
                        decimal subtotal = (decimal)ViewState["Subtotal"];
                        decimal shipping = (decimal)ViewState["Shipping"];
                        decimal tax = (decimal)ViewState["Tax"];
                        decimal total = (decimal)ViewState["Total"];

                        string insertOrderQuery = @"INSERT INTO Orders 
                                      (UserID, OrderDate, Subtotal, Shipping, Tax, Total, Status) 
                                      VALUES 
                                      (@UserID, GETDATE(), @Subtotal, @Shipping, @Tax, @Total, 'Pending');
                                      SELECT SCOPE_IDENTITY();";

                        int orderId;
                        using (SqlCommand cmd = new SqlCommand(insertOrderQuery, conn, transaction))
                        {
                            cmd.Parameters.AddWithValue("@UserID", userId);
                            cmd.Parameters.AddWithValue("@Subtotal", subtotal);
                            cmd.Parameters.AddWithValue("@Shipping", shipping);
                            cmd.Parameters.AddWithValue("@Tax", tax);
                            cmd.Parameters.AddWithValue("@Total", total);
                            orderId = Convert.ToInt32(cmd.ExecuteScalar());
                        }

                        // 2. Save shipping/billing information
                        // In a real application, you would save this information to a ShippingAddresses table
                        // For simplicity, we'll skip this step in this example

                        // 3. Get cart items and add to order items
                        DataTable cartItems = new DataTable();
                        string getCartItemsQuery = @"SELECT ProductID, Quantity, PriceAtAddition 
                                       FROM CartItems 
                                       WHERE CartID = @CartID";

                        using (SqlCommand cmd = new SqlCommand(getCartItemsQuery, conn, transaction))
                        {
                            cmd.Parameters.AddWithValue("@CartID", cartId);
                            using (SqlDataAdapter adapter = new SqlDataAdapter(cmd))
                            {
                                adapter.Fill(cartItems);
                            }
                        }

                        // 4. Insert order items and update product stock
                        foreach (DataRow row in cartItems.Rows)
                        {
                            int productId = Convert.ToInt32(row["ProductID"]);
                            int quantity = Convert.ToInt32(row["Quantity"]);
                            decimal price = Convert.ToDecimal(row["PriceAtAddition"]);

                            // Insert order item
                            string insertOrderItemQuery = @"INSERT INTO OrderItems 
                                             (OrderID, ProductID, Quantity, UnitPrice) 
                                             VALUES 
                                             (@OrderID, @ProductID, @Quantity, @UnitPrice)";

                            using (SqlCommand cmd = new SqlCommand(insertOrderItemQuery, conn, transaction))
                            {
                                cmd.Parameters.AddWithValue("@OrderID", orderId);
                                cmd.Parameters.AddWithValue("@ProductID", productId);
                                cmd.Parameters.AddWithValue("@Quantity", quantity);
                                cmd.Parameters.AddWithValue("@UnitPrice", price);
                                cmd.ExecuteNonQuery();
                            }

                            // Update product stock
                            string updateStockQuery = @"UPDATE Products 
                                         SET StockQuantity = StockQuantity - @Quantity 
                                         WHERE ProductID = @ProductID";

                            using (SqlCommand cmd = new SqlCommand(updateStockQuery, conn, transaction))
                            {
                                cmd.Parameters.AddWithValue("@ProductID", productId);
                                cmd.Parameters.AddWithValue("@Quantity", quantity);
                                cmd.ExecuteNonQuery();
                            }
                        }

                        // 5. Mark cart as inactive
                        string updateCartQuery = "UPDATE Carts SET IsActive = 0 WHERE CartID = @CartID";
                        using (SqlCommand cmd = new SqlCommand(updateCartQuery, conn, transaction))
                        {
                            cmd.Parameters.AddWithValue("@CartID", cartId);
                            cmd.ExecuteNonQuery();
                        }

                        transaction.Commit();

                        // Clear session cart
                        Session["Cart"] = new Dictionary<int, CartItem>();

                        // Redirect to order confirmation page
                        Response.Redirect($"OrderConfirmation.aspx?OrderID={orderId}");
                    }
                    catch (Exception ex)
                    {
                        transaction.Rollback();
                        ShowAlert("Error processing order: " + ex.Message);
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

