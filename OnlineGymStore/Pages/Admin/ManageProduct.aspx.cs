using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data.SqlClient;
using System.Data;
using System.IO;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace OnlineGymStore.Pages.Admin
{
    public partial class ManageProduct : System.Web.UI.Page
    {
        string connStr = ConfigurationManager.ConnectionStrings["Gymshop"].ConnectionString;

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                BindCategoriesDropdown();
                BindProducts();
            }
        }

        protected string GetStockStatusClass(int stockQuantity)
        {
            if (stockQuantity <= 0)
                return "out-of-stock";
            if (stockQuantity <= 10)
                return "low-stock";
            return "in-stock";
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
                    ddlCategory.DataSource = reader;
                    ddlCategory.DataTextField = "CategoryName";
                    ddlCategory.DataValueField = "CategoryID";
                    ddlCategory.DataBind();
                    ddlCategory.Items.Insert(0, new ListItem("-- Select Category --", "0"));
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
                using (SqlConnection conn = new SqlConnection(connStr))
                {
                    string query = @"SELECT p.ProductID, p.ProductName, p.Price, p.StockQuantity, 
                                   p.Description, p.ImagePath, p.CategoryID, c.CategoryName
                                   FROM Products p 
                                   INNER JOIN Categories c ON p.CategoryID = c.CategoryID
                                   WHERE p.IsActive = 1";

                    using (SqlDataAdapter da = new SqlDataAdapter(query, conn))
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

                        gvProducts.DataSource = dt;
                        gvProducts.DataBind();
                    }
                }
            }
            catch (Exception ex)
            {
                ShowAlert("Error loading products: " + ex.Message);
            }
        }

        protected void AddProduct_Click(object sender, EventArgs e)
        {
            if (!ValidateProductInputs())
                return;

            string imagePath = string.Empty;
            if (fuProductImage.HasFile)
            {
                string uploadsFolder = Server.MapPath("~/images/");
                if (!Directory.Exists(uploadsFolder))
                {
                    Directory.CreateDirectory(uploadsFolder);
                }

                string uniqueFileName = Guid.NewGuid().ToString() + "_" + fuProductImage.FileName;
                string filePath = Path.Combine(uploadsFolder, uniqueFileName);
                fuProductImage.SaveAs(filePath);

                imagePath = "images/" + uniqueFileName;
            }

            using (SqlConnection conn = new SqlConnection(connStr))
            {
                string query = @"INSERT INTO Products 
                               (ProductName, CategoryID, Price, StockQuantity, Description, ImagePath, IsActive) 
                               VALUES (@Name, @CategoryID, @Price, @Stock, @Desc, @Image, 1)";

                SqlCommand cmd = new SqlCommand(query, conn);
                cmd.Parameters.AddWithValue("@Name", txtProductName.Text.Trim());
                cmd.Parameters.AddWithValue("@CategoryID", Convert.ToInt32(ddlCategory.SelectedValue));
                cmd.Parameters.AddWithValue("@Price", Convert.ToDecimal(txtPrice.Text));
                cmd.Parameters.AddWithValue("@Stock", Convert.ToInt32(txtStockQuantity.Text));
                cmd.Parameters.AddWithValue("@Desc", txtDescription.Text.Trim());
                cmd.Parameters.AddWithValue("@Image", imagePath);

                conn.Open();
                cmd.ExecuteNonQuery();
            }

            txtProductName.Text = string.Empty;
            ddlCategory.SelectedIndex = 0;
            txtPrice.Text = string.Empty;
            txtStockQuantity.Text = string.Empty;
            txtDescription.Text = string.Empty;
            fuProductImage.Attributes.Clear();

            BindProducts();
            ShowAlert("Product added successfully.");
        }
        protected void gvProducts_RowEditing(object sender, GridViewEditEventArgs e)
        {
            try
            {
                gvProducts.EditIndex = e.NewEditIndex;
                BindProducts();

                // Get the GridViewRow being edited
                GridViewRow row = gvProducts.Rows[e.NewEditIndex];

                // Find controls
                DropDownList ddlEditCategory = (DropDownList)row.FindControl("ddlEditCategory");
                HiddenField hfCategoryID = (HiddenField)row.FindControl("hfCategoryID");

                if (ddlEditCategory != null && hfCategoryID != null)
                {
                    // Bind categories dropdown
                    using (SqlConnection conn = new SqlConnection(connStr))
                    using (SqlCommand cmd = new SqlCommand("SELECT CategoryID, CategoryName FROM Categories WHERE IsActive = 1", conn))
                    {
                        conn.Open();
                        SqlDataReader reader = cmd.ExecuteReader();
                        ddlEditCategory.DataSource = reader;
                        ddlEditCategory.DataTextField = "CategoryName";
                        ddlEditCategory.DataValueField = "CategoryID";
                        ddlEditCategory.DataBind();

                        // Set the currently selected category
                        if (!string.IsNullOrEmpty(hfCategoryID.Value))
                        {
                            ddlEditCategory.SelectedValue = hfCategoryID.Value;
                        }
                    }
                }
            }
            catch (Exception ex)
            {
                ShowAlert("Error entering edit mode: " + ex.Message);
                gvProducts.EditIndex = -1;
                BindProducts();
            }
        }

        protected async void gvProducts_RowUpdating(object sender, GridViewUpdateEventArgs e)
        {
            try
            {
                GridViewRow row = gvProducts.Rows[e.RowIndex];
                int productId = Convert.ToInt32(gvProducts.DataKeys[e.RowIndex].Value);

                // Get all the form control values
                TextBox txtEditProductName = row.FindControl("txtEditProductName") as TextBox;
                string productName = txtEditProductName?.Text.Trim() ?? "";

                DropDownList ddlEditCategory = row.FindControl("ddlEditCategory") as DropDownList;
                int categoryId = ddlEditCategory != null ? Convert.ToInt32(ddlEditCategory.SelectedValue) : 0;

                TextBox txtEditPrice = row.FindControl("txtEditPrice") as TextBox;
                decimal price = txtEditPrice != null && decimal.TryParse(txtEditPrice.Text.Trim(), out decimal parsedPrice) ? parsedPrice : 0;

                TextBox txtEditStock = row.FindControl("txtEditStock") as TextBox;
                int stock = txtEditStock != null && int.TryParse(txtEditStock.Text.Trim(), out int parsedStock) ? parsedStock : 0;

                FileUpload fuImage = (FileUpload)row.FindControl("fuEditImage");
                HiddenField hfCurrentImagePath = (HiddenField)row.FindControl("hfCurrentImagePath");

                // Clean up the current image path by removing the ~/ if present
                string currentImagePath = hfCurrentImagePath.Value;
                if (currentImagePath.StartsWith("~/"))
                {
                    currentImagePath = currentImagePath.Substring(2);
                }

                string imagePath = currentImagePath; // Default to keeping current image

                // Process new image if uploaded
                if (fuImage.HasFile)
                {
                    string uploadsFolder = Server.MapPath("~/images/");
                    if (!Directory.Exists(uploadsFolder))
                    {
                        Directory.CreateDirectory(uploadsFolder);
                    }

                    string uniqueFileName = Guid.NewGuid().ToString() + "_" + fuImage.FileName;
                    string filePath = Path.Combine(uploadsFolder, uniqueFileName);
                    fuImage.SaveAs(filePath);

                    // Store consistent path format in database
                    imagePath = "images/" + uniqueFileName;

                    // Optionally delete old image file if it exists
                    if (!string.IsNullOrEmpty(currentImagePath))
                    {
                        string oldFilePath = Server.MapPath("~/" + currentImagePath);
                        if (File.Exists(oldFilePath))
                        {
                            try { File.Delete(oldFilePath); } catch { /* Ignore deletion errors */ }
                        }
                    }
                }

                // Update product in the database
                using (SqlConnection conn = new SqlConnection(connStr))
                using (SqlCommand cmd = new SqlCommand(@"UPDATE Products 
                              SET ProductName = @Name, 
                                  CategoryID = @CategoryID, 
                                  Price = @Price, 
                                  StockQuantity = @Stock,
                                  ImagePath = @Image
                              WHERE ProductID = @ID", conn))
                {
                    cmd.Parameters.AddWithValue("@Name", productName);
                    cmd.Parameters.AddWithValue("@CategoryID", categoryId);
                    cmd.Parameters.AddWithValue("@Price", price);
                    cmd.Parameters.AddWithValue("@Stock", stock);
                    cmd.Parameters.AddWithValue("@Image", imagePath);
                    cmd.Parameters.AddWithValue("@ID", productId);
                    await conn.OpenAsync();
                    await cmd.ExecuteNonQueryAsync();
                }

                gvProducts.EditIndex = -1;
                BindProducts();
                ShowAlert("Product updated successfully.");
            }
            catch (Exception ex)
            {
                ShowAlert("Error updating product: " + ex.Message);
            }
        }




        protected void gvProducts_RowCancelingEdit(object sender, GridViewCancelEditEventArgs e)
        {
            gvProducts.EditIndex = -1;
            BindProducts();
        }

        protected void gvProducts_RowDeleting(object sender, GridViewDeleteEventArgs e)
        {
            try
            {
                int productId = Convert.ToInt32(gvProducts.DataKeys[e.RowIndex].Value);

                // Get the image path before deleting
                string imagePath = string.Empty;
                using (SqlConnection conn = new SqlConnection(connStr))
                {
                    string query = "SELECT ImagePath FROM Products WHERE ProductID = @ID";
                    SqlCommand cmd = new SqlCommand(query, conn);
                    cmd.Parameters.AddWithValue("@ID", productId);

                    conn.Open();
                    object result = cmd.ExecuteScalar();
                    if (result != null && result != DBNull.Value)
                    {
                        imagePath = result.ToString();
                        if (imagePath.StartsWith("~/"))
                        {
                            imagePath = imagePath.Substring(2);
                        }
                    }
                }

                // Soft delete the product
                using (SqlConnection conn = new SqlConnection(connStr))
                using (SqlCommand cmd = new SqlCommand("UPDATE Products SET IsActive = 0 WHERE ProductID = @ID", conn))
                {
                    cmd.Parameters.AddWithValue("@ID", productId);
                    conn.Open();
                    cmd.ExecuteNonQuery();
                }

                // Delete the image file if it exists
                if (!string.IsNullOrEmpty(imagePath))
                {
                    string filePath = Server.MapPath("~/" + imagePath);
                    if (File.Exists(filePath))
                    {
                        try { File.Delete(filePath); } catch { /* Ignore deletion errors */ }
                    }
                }

                BindProducts();
                ShowAlert("Product deleted successfully.");
            }
            catch (Exception ex)
            {
                ShowAlert("Error deleting product: " + ex.Message);
            }
        }

        protected void txtSearch_TextChanged(object sender, EventArgs e)
        {
            string searchTerm = txtSearch.Text.Trim();
            try
            {
                using (SqlConnection conn = new SqlConnection(connStr))
                {
                    string query = @"SELECT p.ProductID, p.ProductName, p.Price, p.StockQuantity, p.Description, 
                                   p.ImagePath, p.CategoryID, c.CategoryName
                                   FROM Products p 
                                   INNER JOIN Categories c ON p.CategoryID = c.CategoryID
                                   WHERE p.ProductName LIKE @Search AND p.IsActive = 1";

                    SqlCommand cmd = new SqlCommand(query, conn);
                    cmd.Parameters.AddWithValue("@Search", "%" + searchTerm + "%");

                    SqlDataAdapter da = new SqlDataAdapter(cmd);
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

                    gvProducts.DataSource = dt;
                    gvProducts.DataBind();
                }
            }
            catch (Exception ex)
            {
                ShowAlert("Error searching products: " + ex.Message);
            }
        }

        private bool ValidateProductInputs()
        {
            if (string.IsNullOrWhiteSpace(txtProductName.Text))
            {
                ShowAlert("Product name is required");
                return false;
            }

            if (ddlCategory.SelectedValue == "0")
            {
                ShowAlert("Please select a category");
                return false;
            }

            if (!decimal.TryParse(txtPrice.Text, out decimal price) || price <= 0)
            {
                ShowAlert("Please enter a valid price");
                return false;
            }

            if (!int.TryParse(txtStockQuantity.Text, out int stock) || stock < 0)
            {
                ShowAlert("Please enter a valid stock quantity");
                return false;
            }

            return true;
        }

        private void ShowAlert(string message)
        {
            ScriptManager.RegisterStartupScript(this, GetType(), "showalert",
                $"alert('{message.Replace("'", "\\'")}');", true);
        }

        // Add this method to your existing ManageProduct class
        public static DataTable GetFeaturedProducts(int count, string connectionString)
        {
            DataTable dt = new DataTable();

            try
            {
                using (SqlConnection conn = new SqlConnection(connectionString))
                {
                    string query = @"SELECT TOP (@Count) p.ProductID, p.ProductName, p.Price, 
                           p.StockQuantity, p.Description, p.ImagePath, 
                           c.CategoryName
                           FROM Products p 
                           INNER JOIN Categories c ON p.CategoryID = c.CategoryID
                           WHERE p.IsActive = 1
                           ORDER BY ProductID DESC"; // Gets most recent products

                    SqlCommand cmd = new SqlCommand(query, conn);
                    cmd.Parameters.AddWithValue("@Count", count);

                    SqlDataAdapter da = new SqlDataAdapter(cmd);
                    da.Fill(dt);

                    // Format image paths
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
                }
            }
            catch (Exception ex)
            {
                // Handle error (log if needed)
            }

            return dt;
        }
    }
}