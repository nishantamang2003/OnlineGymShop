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
    public partial class Cart : System.Web.UI.Page
    {

        
            string connStr = ConfigurationManager.ConnectionStrings["Gymshop"].ConnectionString;

            protected void Page_Load(object sender, EventArgs e)
            {
                if (Session["UserEmail"] == null)
                {
                    Response.Redirect("Login.aspx");
                    return;
                }

                if (!IsPostBack)
                {
                    // Check if there are items in the session cart that need to be synced to database
                    SyncSessionCartToDatabase();

                    // Now load cart from database
                    LoadCart();
                }
            }

            private void LoadCart()
            {
                try
                {
                    int userId = GetUserId();
                    if (userId == 0)
                    {
                        Response.Redirect("Login.aspx");
                        return;
                    }

                    // Check if cart exists in the database
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
                        // No cart items in database
                        pnlEmptyCart.Visible = true;
                        pnlCart.Visible = false;

                        // Ensure session cart is empty or initialized
                        Session["Cart"] = new Dictionary<int, CartItem>();
                        return;
                    }

                    // Cart exists, load from database
                    using (SqlConnection conn = new SqlConnection(connStr))
                    {
                        string query = @"SELECT p.ProductID, p.ProductName, ci.PriceAtAddition AS Price, 
                          ci.Quantity, (ci.PriceAtAddition * ci.Quantity) AS ItemTotal,
                          p.ImagePath, p.StockQuantity
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

                            // Update session cart
                            Dictionary<int, CartItem> cart = new Dictionary<int, CartItem>();
                            foreach (DataRow row in dt.Rows)
                            {
                                int productId = Convert.ToInt32(row["ProductID"]);
                                cart[productId] = new CartItem
                                {
                                    ProductId = productId,
                                    ProductName = row["ProductName"].ToString(),
                                    Price = Convert.ToDecimal(row["Price"]),
                                    Quantity = Convert.ToInt32(row["Quantity"]),
                                    ImagePath = row["ImagePath"] != DBNull.Value ?
                                              row["ImagePath"].ToString() : string.Empty
                                };
                            }
                            Session["Cart"] = cart;

                            pnlEmptyCart.Visible = false;
                            pnlCart.Visible = true;

                            gvCart.DataSource = dt;
                            gvCart.DataBind();

                            // Calculate totals
                            decimal subtotal = dt.AsEnumerable()
                                               .Sum(row => Convert.ToDecimal(row["ItemTotal"]));
                            decimal shipping = 5.00m; // Fixed shipping cost
                            decimal total = subtotal + shipping;

                            lblSubtotal.Text = "$" + subtotal.ToString("0.00");
                            lblShipping.Text = "$" + shipping.ToString("0.00");
                            lblTotal.Text = "$" + total.ToString("0.00");
                        }
                    }
                }
                catch (Exception ex)
                {
                    // Show error and initialize empty cart
                    ScriptManager.RegisterStartupScript(this, GetType(), "showalert",
                        $"alert('Error loading cart: {ex.Message.Replace("'", "\\'")}');", true);

                    pnlEmptyCart.Visible = true;
                    pnlCart.Visible = false;
                    Session["Cart"] = new Dictionary<int, CartItem>();
                }
            }

            protected void gvCart_RowCommand(object sender, GridViewCommandEventArgs e)
            {
                int productId = Convert.ToInt32(e.CommandArgument);
                int userId = GetUserId();

                using (SqlConnection conn = new SqlConnection(connStr))
                {
                    conn.Open();

                    // Get the active cart ID for this user
                    string query = "SELECT CartID FROM Carts WHERE UserID = @UserID AND IsActive = 1";
                    int cartId;
                    using (SqlCommand cmd = new SqlCommand(query, conn))
                    {
                        cmd.Parameters.AddWithValue("@UserID", userId);
                        cartId = Convert.ToInt32(cmd.ExecuteScalar());
                    }

                    if (e.CommandName == "RemoveItem")
                    {
                        query = "DELETE FROM CartItems WHERE CartID = @CartID AND ProductID = @ProductID";
                        using (SqlCommand cmd = new SqlCommand(query, conn))
                        {
                            cmd.Parameters.AddWithValue("@CartID", cartId);
                            cmd.Parameters.AddWithValue("@ProductID", productId);
                            cmd.ExecuteNonQuery();
                        }
                    }
                    else if (e.CommandName == "IncreaseQty")
                    {
                        query = @"UPDATE CartItems SET Quantity = Quantity + 1 
                            WHERE CartID = @CartID AND ProductID = @ProductID";
                        using (SqlCommand cmd = new SqlCommand(query, conn))
                        {
                            cmd.Parameters.AddWithValue("@CartID", cartId);
                            cmd.Parameters.AddWithValue("@ProductID", productId);
                            cmd.ExecuteNonQuery();
                        }
                    }
                    else if (e.CommandName == "DecreaseQty")
                    {
                        // First get current quantity
                        int currentQty;
                        query = "SELECT Quantity FROM CartItems WHERE CartID = @CartID AND ProductID = @ProductID";
                        using (SqlCommand cmd = new SqlCommand(query, conn))
                        {
                            cmd.Parameters.AddWithValue("@CartID", cartId);
                            cmd.Parameters.AddWithValue("@ProductID", productId);
                            currentQty = Convert.ToInt32(cmd.ExecuteScalar());
                        }

                        if (currentQty > 1)
                        {
                            query = @"UPDATE CartItems SET Quantity = Quantity - 1 
                                WHERE CartID = @CartID AND ProductID = @ProductID";
                            using (SqlCommand cmd = new SqlCommand(query, conn))
                            {
                                cmd.Parameters.AddWithValue("@CartID", cartId);
                                cmd.Parameters.AddWithValue("@ProductID", productId);
                                cmd.ExecuteNonQuery();
                            }
                        }
                        else
                        {
                            query = "DELETE FROM CartItems WHERE CartID = @CartID AND ProductID = @ProductID";
                            using (SqlCommand cmd = new SqlCommand(query, conn))
                            {
                                cmd.Parameters.AddWithValue("@CartID", cartId);
                                cmd.Parameters.AddWithValue("@ProductID", productId);
                                cmd.ExecuteNonQuery();
                            }
                        }
                    }

                    // Update session cart
                    UpdateSessionCart(userId);
                    LoadCart();
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

            private void UpdateSessionCart(int userId)
            {
                using (SqlConnection conn = new SqlConnection(connStr))
                {
                    string query = @"SELECT p.ProductID, p.ProductName, ci.PriceAtAddition AS Price, 
                              ci.Quantity, p.ImagePath
                              FROM CartItems ci
                              INNER JOIN Carts c ON ci.CartID = c.CartID
                              INNER JOIN Products p ON ci.ProductID = p.ProductID
                              WHERE c.UserID = @UserID AND c.IsActive = 1";

                    using (SqlCommand cmd = new SqlCommand(query, conn))
                    {
                        cmd.Parameters.AddWithValue("@UserID", userId);
                        conn.Open();
                        using (SqlDataReader reader = cmd.ExecuteReader())
                        {
                            Dictionary<int, CartItem> cart = new Dictionary<int, CartItem>();
                            while (reader.Read())
                            {
                                int productId = Convert.ToInt32(reader["ProductID"]);
                                cart[productId] = new CartItem
                                {
                                    ProductId = productId,
                                    ProductName = reader["ProductName"].ToString(),
                                    Price = Convert.ToDecimal(reader["Price"]),
                                    Quantity = Convert.ToInt32(reader["Quantity"]),
                                    ImagePath = reader["ImagePath"] != DBNull.Value ?
                                              reader["ImagePath"].ToString() : string.Empty
                                };
                            }
                            Session["Cart"] = cart;
                        }
                    }
                }
            }

            protected void btnCheckout_Click(object sender, EventArgs e)
            {
                int userId = GetUserId();
                if (userId == 0)
                {
                    Response.Redirect("Login.aspx");
                    return;
                }

                // Here you would typically:
                // 1. Create an order record
                // 2. Move cart items to order items
                // 3. Mark cart as inactive
                // 4. Update product stock quantities
                // 5. Redirect to order confirmation

                Response.Redirect("Checkout.aspx");
            }

            protected void btnClearCart_Click(object sender, EventArgs e)
            {
                int userId = GetUserId();
                if (userId == 0)
                {
                    Response.Redirect("~/Login.aspx");
                    return;
                }

                using (SqlConnection conn = new SqlConnection(connStr))
                {
                    string query = @"DELETE ci
                               FROM CartItems ci
                               INNER JOIN Carts c ON ci.CartID = c.CartID
                               WHERE c.UserID = @UserID AND c.IsActive = 1";

                    using (SqlCommand cmd = new SqlCommand(query, conn))
                    {
                        conn.Open();
                        cmd.Parameters.AddWithValue("@UserID", userId);
                        cmd.ExecuteNonQuery();
                    }
                }

                Session["Cart"] = new Dictionary<int, CartItem>();
                LoadCart();
            }
            private void AddToCart(int productId, int quantity)
            {
                try
                {
                    // Get product information
                    string productName = string.Empty;
                    decimal productPrice = 0;
                    string imagePath = string.Empty;

                    using (SqlConnection conn = new SqlConnection(connStr))
                    {
                        string query = "SELECT ProductName, Price, ImagePath FROM Products WHERE ProductID = @ProductID";
                        using (SqlCommand cmd = new SqlCommand(query, conn))
                        {
                            cmd.Parameters.AddWithValue("@ProductID", productId);
                            conn.Open();
                            using (SqlDataReader reader = cmd.ExecuteReader())
                            {
                                if (reader.Read())
                                {
                                    productName = reader["ProductName"].ToString();
                                    productPrice = Convert.ToDecimal(reader["Price"]);
                                    imagePath = reader["ImagePath"] != DBNull.Value ? reader["ImagePath"].ToString() : string.Empty;
                                }
                            }
                        }
                    }

                    // Initialize cart if needed
                    if (Session["Cart"] == null)
                    {
                        Session["Cart"] = new Dictionary<int, CartItem>();
                    }

                    Dictionary<int, CartItem> cart = (Dictionary<int, CartItem>)Session["Cart"];

                    // Add or update item in cart
                    if (cart.ContainsKey(productId))
                    {
                        cart[productId].Quantity += quantity;
                    }
                    else
                    {
                        cart[productId] = new CartItem
                        {
                            ProductId = productId,
                            ProductName = productName,
                            Price = productPrice,
                            Quantity = quantity,
                            ImagePath = imagePath
                        };
                    }

                    // If user is logged in, also save cart to database
                    if (Session["UserEmail"] != null)
                    {
                        SaveCartToDatabase(productId, quantity, productPrice);
                    }



                    // Show success message
                    ScriptManager.RegisterStartupScript(this, GetType(), "showCartMessage",
                        $"showAddedToCartMessage('{productName.Replace("'", "\\'")}');", true);
                }
                catch (Exception ex)
                {
                    ShowAlert("Error adding product to cart: " + ex.Message);
                }
            }
            private void ShowAlert(string message)
            {
                ScriptManager.RegisterStartupScript(this, GetType(), "showalert",
                    $"alert('{message.Replace("'", "\\'")}');", true);
            }

            private void SaveCartToDatabase(int productId, int quantity, decimal price)
            {
                int userId = GetUserId();
                if (userId == 0) return;

                using (SqlConnection conn = new SqlConnection(connStr))
                {
                    conn.Open();
                    SqlTransaction transaction = conn.BeginTransaction();

                    try
                    {
                        // Check if user has an active cart
                        int cartId = 0;
                        string cartQuery = "SELECT CartID FROM Carts WHERE UserID = @UserID AND IsActive = 1";
                        using (SqlCommand cmd = new SqlCommand(cartQuery, conn, transaction))
                        {
                            cmd.Parameters.AddWithValue("@UserID", userId);
                            object result = cmd.ExecuteScalar();
                            cartId = result != null ? Convert.ToInt32(result) : 0;
                        }

                        // If no active cart, create one
                        if (cartId == 0)
                        {
                            string createCartQuery = "INSERT INTO Carts (UserID, DateCreated, DateModified, IsActive) VALUES (@UserID, GETDATE(), GETDATE(), 1); SELECT SCOPE_IDENTITY();";
                            using (SqlCommand cmd = new SqlCommand(createCartQuery, conn, transaction))
                            {
                                cmd.Parameters.AddWithValue("@UserID", userId);
                                cartId = Convert.ToInt32(cmd.ExecuteScalar());
                            }
                        }

                        // Check if item already exists in cart
                        bool itemExists = false;
                        int currentQuantity = 0;
                        string checkItemQuery = "SELECT COUNT(*), Quantity FROM CartItems WHERE CartID = @CartID AND ProductID = @ProductID GROUP BY Quantity";
                        using (SqlCommand cmd = new SqlCommand(checkItemQuery, conn, transaction))
                        {
                            cmd.Parameters.AddWithValue("@CartID", cartId);
                            cmd.Parameters.AddWithValue("@ProductID", productId);
                            using (SqlDataReader reader = cmd.ExecuteReader())
                            {
                                if (reader.Read())
                                {
                                    itemExists = true;
                                    currentQuantity = Convert.ToInt32(reader["Quantity"]);
                                }
                            }
                        }

                        // Update or insert cart item
                        if (itemExists)
                        {
                            string updateItemQuery = "UPDATE CartItems SET Quantity = @Quantity, DateAdded = GETDATE() WHERE CartID = @CartID AND ProductID = @ProductID";
                            using (SqlCommand cmd = new SqlCommand(updateItemQuery, conn, transaction))
                            {
                                cmd.Parameters.AddWithValue("@CartID", cartId);
                                cmd.Parameters.AddWithValue("@ProductID", productId);
                                cmd.Parameters.AddWithValue("@Quantity", currentQuantity + quantity);
                                cmd.ExecuteNonQuery();
                            }
                        }
                        else
                        {
                            string insertItemQuery = "INSERT INTO CartItems (CartID, ProductID, Quantity, PriceAtAddition, DateAdded) VALUES (@CartID, @ProductID, @Quantity, @Price, GETDATE())";
                            using (SqlCommand cmd = new SqlCommand(insertItemQuery, conn, transaction))
                            {
                                cmd.Parameters.AddWithValue("@CartID", cartId);
                                cmd.Parameters.AddWithValue("@ProductID", productId);
                                cmd.Parameters.AddWithValue("@Quantity", quantity);
                                cmd.Parameters.AddWithValue("@Price", price);
                                cmd.ExecuteNonQuery();
                            }
                        }

                        // Update cart's modified date
                        string updateCartQuery = "UPDATE Carts SET DateModified = GETDATE() WHERE CartID = @CartID";
                        using (SqlCommand cmd = new SqlCommand(updateCartQuery, conn, transaction))
                        {
                            cmd.Parameters.AddWithValue("@CartID", cartId);
                            cmd.ExecuteNonQuery();
                        }

                        transaction.Commit();
                    }
                    catch (Exception ex)
                    {
                        transaction.Rollback();
                        ShowAlert("Error saving cart to database: " + ex.Message);
                    }
                }
            }
            private void SyncSessionCartToDatabase()
            {
                if (Session["Cart"] == null) return;

                Dictionary<int, CartItem> sessionCart = (Dictionary<int, CartItem>)Session["Cart"];
                if (sessionCart.Count == 0) return;

                int userId = GetUserId();
                if (userId == 0) return;

                using (SqlConnection conn = new SqlConnection(connStr))
                {
                    conn.Open();
                    SqlTransaction transaction = conn.BeginTransaction();

                    try
                    {
                        // Get or create active cart
                        int cartId = 0;
                        string cartQuery = "SELECT CartID FROM Carts WHERE UserID = @UserID AND IsActive = 1";
                        using (SqlCommand cmd = new SqlCommand(cartQuery, conn, transaction))
                        {
                            cmd.Parameters.AddWithValue("@UserID", userId);
                            object result = cmd.ExecuteScalar();
                            cartId = result != null ? Convert.ToInt32(result) : 0;
                        }

                        if (cartId == 0)
                        {
                            string createCartQuery = "INSERT INTO Carts (UserID, DateCreated, DateModified, IsActive) VALUES (@UserID, GETDATE(), GETDATE(), 1); SELECT SCOPE_IDENTITY();";
                            using (SqlCommand cmd = new SqlCommand(createCartQuery, conn, transaction))
                            {
                                cmd.Parameters.AddWithValue("@UserID", userId);
                                cartId = Convert.ToInt32(cmd.ExecuteScalar());
                            }
                        }

                        // For each item in session cart, update or insert in database
                        foreach (var item in sessionCart)
                        {
                            int productId = item.Key;
                            CartItem cartItem = item.Value;

                            // Check if item exists in database cart
                            bool itemExists = false;
                            int currentQuantity = 0;
                            string checkItemQuery = "SELECT COUNT(*) AS ItemCount, Quantity FROM CartItems WHERE CartID = @CartID AND ProductID = @ProductID GROUP BY Quantity";
                            using (SqlCommand cmd = new SqlCommand(checkItemQuery, conn, transaction))
                            {
                                cmd.Parameters.AddWithValue("@CartID", cartId);
                                cmd.Parameters.AddWithValue("@ProductID", productId);
                                using (SqlDataReader reader = cmd.ExecuteReader())
                                {
                                    if (reader.Read())
                                    {
                                        itemExists = true;
                                        currentQuantity = Convert.ToInt32(reader["Quantity"]);
                                    }
                                }
                            }

                            // Update or insert cart item
                            if (itemExists)
                            {
                                // For simplicity, we'll use the greater of the two quantities
                                int newQuantity = Math.Max(currentQuantity, cartItem.Quantity);

                                string updateItemQuery = "UPDATE CartItems SET Quantity = @Quantity, DateAdded = GETDATE() WHERE CartID = @CartID AND ProductID = @ProductID";
                                using (SqlCommand cmd = new SqlCommand(updateItemQuery, conn, transaction))
                                {
                                    cmd.Parameters.AddWithValue("@CartID", cartId);
                                    cmd.Parameters.AddWithValue("@ProductID", productId);
                                    cmd.Parameters.AddWithValue("@Quantity", newQuantity);
                                    cmd.ExecuteNonQuery();
                                }
                            }
                            else
                            {
                                string insertItemQuery = "INSERT INTO CartItems (CartID, ProductID, Quantity, PriceAtAddition, DateAdded) VALUES (@CartID, @ProductID, @Quantity, @Price, GETDATE())";
                                using (SqlCommand cmd = new SqlCommand(insertItemQuery, conn, transaction))
                                {
                                    cmd.Parameters.AddWithValue("@CartID", cartId);
                                    cmd.Parameters.AddWithValue("@ProductID", productId);
                                    cmd.Parameters.AddWithValue("@Quantity", cartItem.Quantity);
                                    cmd.Parameters.AddWithValue("@Price", cartItem.Price);
                                    cmd.ExecuteNonQuery();
                                }
                            }
                        }

                        // Update cart's modified date
                        string updateCartQuery = "UPDATE Carts SET DateModified = GETDATE() WHERE CartID = @CartID";
                        using (SqlCommand cmd = new SqlCommand(updateCartQuery, conn, transaction))
                        {
                            cmd.Parameters.AddWithValue("@CartID", cartId);
                            cmd.ExecuteNonQuery();
                        }

                        transaction.Commit();

                        // Now clear the session cart as all items are in the database
                        // Session["Cart"] = new Dictionary<int, CartItem>();
                        // NOTE: We don't clear session cart here because we'll repopulate it in LoadCart()
                    }
                    catch (Exception ex)
                    {
                        transaction.Rollback();
                        ScriptManager.RegisterStartupScript(this, GetType(), "showalert",
                            $"alert('Error syncing cart: {ex.Message.Replace("'", "\\'")}');", true);
                    }
                }
            }
        }
    }

