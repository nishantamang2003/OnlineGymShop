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
    public partial class Products : System.Web.UI.Page
    {


            string connStr = ConfigurationManager.ConnectionStrings["GymShop"].ConnectionString;

            protected void Page_Load(object sender, EventArgs e)
            {
                if (!IsPostBack)
                {
                    BindCategoriesDropdown();
                    BindProducts();
                    UpdateCartSummary();
                }
            }

            private void BindCategoriesDropdown()
            {
                try
                {
                    using (SqlConnection conn = new SqlConnection(connStr))
                    using (SqlCommand cmd = new SqlCommand("SELECT CategoryID, CategoryName FROM Categories WHERE IsActive = 1", conn))
                    {
                        conn.Open();
                        SqlDataReader reader = cmd.ExecuteReader();
                        ddlCategoryFilter.DataSource = reader;
                        ddlCategoryFilter.DataTextField = "CategoryName";
                        ddlCategoryFilter.DataValueField = "CategoryID";
                        ddlCategoryFilter.DataBind();
                        ddlCategoryFilter.Items.Insert(0, new ListItem("All Categories", "0"));
                    }
                }
                catch (Exception ex)
                {
                    ShowAlert("Error loading categories: " + ex.Message);
                }
            }

            private void BindProducts()
            {
                try
                {
                    // Get filter values
                    int categoryId = Convert.ToInt32(ddlCategoryFilter.SelectedValue);
                    decimal minPrice = string.IsNullOrEmpty(txtMinPrice.Text) ? 0 : Convert.ToDecimal(txtMinPrice.Text);
                    decimal maxPrice = string.IsNullOrEmpty(txtMaxPrice.Text) ? decimal.MaxValue : Convert.ToDecimal(txtMaxPrice.Text);

                    using (SqlConnection conn = new SqlConnection(connStr))
                    {
                        string query = @"SELECT p.ProductID, p.ProductName, p.Price, p.StockQuantity, 
                                   p.Description, p.ImagePath, p.CategoryID, c.CategoryName
                                   FROM Products p 
                                   INNER JOIN Categories c ON p.CategoryID = c.CategoryID
                                   WHERE p.IsActive = 1";

                        // Add category filter if selected
                        if (categoryId > 0)
                        {
                            query += " AND p.CategoryID = @CategoryID";
                        }

                        // Add price range filter
                        query += " AND p.Price >= @MinPrice AND p.Price <= @MaxPrice";

                        // Add sorting
                        query += " ORDER BY p.ProductName ASC";

                        using (SqlCommand cmd = new SqlCommand(query, conn))
                        {
                            if (categoryId > 0)
                            {
                                cmd.Parameters.AddWithValue("@CategoryID", categoryId);
                            }
                            cmd.Parameters.AddWithValue("@MinPrice", minPrice);
                            cmd.Parameters.AddWithValue("@MaxPrice", maxPrice);

                            using (SqlDataAdapter da = new SqlDataAdapter(cmd))
                            {
                                DataTable dt = new DataTable();
                                da.Fill(dt);

                                foreach (DataRow row in dt.Rows)
                                {
                                    if (row["ImagePath"] != DBNull.Value && !string.IsNullOrEmpty(row["ImagePath"].ToString()))
                                    {
                                        string imagePath = row["ImagePath"].ToString();
                                        if (!imagePath.StartsWith("~/"))
                                        {
                                            row["ImagePath"] = "~/" + imagePath;
                                        }
                                    }
                                }

                                rptProducts.DataSource = dt;
                                rptProducts.DataBind();

                                // Display product count or no products message
                                int productCount = dt.Rows.Count;
                                lblProductCount.Text = productCount + " products found";
                                pnlNoProducts.Visible = (productCount == 0);
                            }
                        }
                    }
                }
                catch (Exception ex)
                {
                    ShowAlert("Error loading products: " + ex.Message);
                }
            }

            protected void ApplyFilters(object sender, EventArgs e)
            {
                BindProducts();
            }

            protected void ClearFilters(object sender, EventArgs e)
            {
                ddlCategoryFilter.SelectedIndex = 0;
                txtMinPrice.Text = string.Empty;
                txtMaxPrice.Text = string.Empty;
                BindProducts();
            }

            protected void rptProducts_ItemCommand(object source, RepeaterCommandEventArgs e)
            {
                if (e.CommandName == "AddToCart")
                {
                    int productId = Convert.ToInt32(e.CommandArgument);
                    TextBox txtQuantity = (TextBox)e.Item.FindControl("txtQuantity");
                    int quantity = Convert.ToInt32(txtQuantity.Text);

                    AddToCart(productId, quantity);
                }
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

                    // Update cart display
                    UpdateCartSummary();

                    // Show success message
                    ScriptManager.RegisterStartupScript(this, GetType(), "showCartMessage",
                        $"showAddedToCartMessage('{productName.Replace("'", "\\'")}');", true);
                }
                catch (Exception ex)
                {
                    ShowAlert("Error adding product to cart: " + ex.Message);
                }
            }

            private void UpdateCartSummary()
            {
                if (Session["Cart"] == null)
                {
                    lblCartItems.Text = "0 items";
                    lblCartTotal.Text = "$0.00";
                    return;
                }

                Dictionary<int, CartItem> cart = (Dictionary<int, CartItem>)Session["Cart"];
                int totalItems = cart.Values.Sum(item => item.Quantity);
                decimal totalAmount = cart.Values.Sum(item => item.Price * item.Quantity);

                lblCartItems.Text = totalItems + (totalItems == 1 ? " item" : " items");
                lblCartTotal.Text = "$" + totalAmount.ToString("0.00");
            }

            protected void btnViewCart_Click(object sender, EventArgs e)
            {
                Response.Redirect("Cart.aspx");
            }

            protected string GetStockStatusClass(int stockQuantity)
            {
                if (stockQuantity <= 0)
                    return "bg-danger text-white";
                if (stockQuantity <= 10)
                    return "bg-warning";
                return "bg-success text-white";
            }

            protected string GetStockStatusText(int stockQuantity)
            {
                if (stockQuantity <= 0)
                    return "Out of Stock";
                if (stockQuantity <= 10)
                    return "Low Stock: " + stockQuantity;
                return "In Stock: " + stockQuantity;
            }

            private void ShowAlert(string message)
            {
                ScriptManager.RegisterStartupScript(this, GetType(), "showalert",
                    $"alert('{message.Replace("'", "\\'")}');", true);
            }
        }


        // Cart item class to store in session
        [Serializable]
        public class CartItem
        {
            public int ProductId { get; set; }
            public string ProductName { get; set; }
            public decimal Price { get; set; }
            public int Quantity { get; set; }
            public string ImagePath { get; set; }
        }
    }

