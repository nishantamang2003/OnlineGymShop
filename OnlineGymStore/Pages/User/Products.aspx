<%@ Page Title="" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="Products.aspx.cs" Inherits="OnlineGymStore.Pages.User.Products" %>
<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">
  



    <div class="container">
        <h2>Our Products</h2>

        <div class="row mb-4">
            <div class="col-md-3">
                <div class="card">
                    <div class="card-header">
                        <h4>Filter Products</h4>
                    </div>
                    <div class="card-body">
                        <div class="form-group mb-3">
                            <label for="ddlCategoryFilter">Category:</label>
                            <asp:DropDownList ID="ddlCategoryFilter" runat="server" CssClass="form-control" AutoPostBack="true" OnSelectedIndexChanged="ApplyFilters"></asp:DropDownList>
                        </div>

                        <div class="form-group mb-3">
                            <label>Price Range:</label>
                            <div class="d-flex">
                                <asp:TextBox ID="txtMinPrice" runat="server" CssClass="form-control me-2" placeholder="Min" TextMode="Number"></asp:TextBox>
                                <asp:TextBox ID="txtMaxPrice" runat="server" CssClass="form-control" placeholder="Max" TextMode="Number"></asp:TextBox>
                            </div>
                        </div>

                        <asp:Button ID="btnApplyPriceFilter" runat="server" Text="Apply Price Filter" CssClass="btn btn-primary" OnClick="ApplyFilters" />
                        <asp:Button ID="btnClearFilters" runat="server" Text="Clear All Filters" CssClass="btn btn-outline-secondary mt-2" OnClick="ClearFilters" />
                    </div>
                </div>

                <div class="card mt-3">
                    <div class="card-header">
                        <h4>Your Cart</h4>
                    </div>
                    <div class="card-body">
                        <asp:Label ID="lblCartItems" runat="server" Text="0 items"></asp:Label>
                        <asp:Label ID="lblCartTotal" runat="server" Text="$0.00" CssClass="d-block mb-2"></asp:Label>
                        <asp:Button ID="btnViewCart" runat="server" Text="View Cart" CssClass="btn btn-success" OnClick="btnViewCart_Click" />
                    </div>
                </div>
            </div>

            <div class="col-md-9">
                <div class="mb-3">
                    <asp:Label ID="lblProductCount" runat="server" CssClass="text-muted"></asp:Label>
                </div>

                <asp:Repeater ID="rptProducts" runat="server" OnItemCommand="rptProducts_ItemCommand">
                    <ItemTemplate>
                        <div class="card mb-3 product-card">
                            <div class="row g-0">
                                <div class="col-md-3">
                                   <img src='<%# ResolveUrl(Eval("ImagePath").ToString()) %>' class="img-fluid rounded-start product-image" alt='<%# Eval("ProductName") %>'>

                                </div>
                                <div class="col-md-9">
                                    <div class="card-body">
                                        <div class="d-flex justify-content-between">
                                            <h5 class="card-title"><%# Eval("ProductName") %></h5>
                                            <span class="badge <%# GetStockStatusClass(Convert.ToInt32(Eval("StockQuantity"))) %>">
                                                <%# GetStockStatusText(Convert.ToInt32(Eval("StockQuantity"))) %>
                                            </span>
                                        </div>
                                        <p class="card-text"><%# Eval("Description") %></p>
                                        <div class="d-flex justify-content-between align-items-center">
                                            <div>
                                                <strong class="text-primary">$<%# Eval("Price", "{0:0.00}") %></strong>
                                                <span class="text-muted ms-2"><%# Eval("CategoryName") %></span>
                                            </div>
                                            <div class="d-flex align-items-center">
                                                <asp:TextBox ID="txtQuantity" runat="server" CssClass="form-control form-control-sm me-2" TextMode="Number" Text="1" Width="60px" min="1" max='<%# Eval("StockQuantity") %>' Enabled='<%# Convert.ToInt32(Eval("StockQuantity")) > 0 %>'></asp:TextBox>
                                                <asp:Button ID="btnAddToCart" CommandName="AddToCart" CommandArgument='<%# Eval("ProductID") %>' runat="server" CssClass="btn btn-primary btn-sm" Text="Add to Cart" Enabled='<%# Convert.ToInt32(Eval("StockQuantity")) > 0 %>' />
                                            </div>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </ItemTemplate>
                </asp:Repeater>

                <asp:Panel ID="pnlNoProducts" runat="server" CssClass="alert alert-info" Visible="false">
                    No products match your filter criteria. Please try different filters.
                </asp:Panel>
            </div>
        </div>
    </div>

    <script type="text/javascript">
        function showAddedToCartMessage(productName) {
            var Toast = Swal.mixin({
                toast: true,
                position: 'top-end',
                showConfirmButton: false,
                timer: 3000,
                timerProgressBar: true
            });

            Toast.fire({
                icon: 'success',
                title: productName + ' added to your cart!'
            });
        }
    </script>
</asp:Content>


