<%@ Page Title="" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="Cart.aspx.cs" Inherits="OnlineGymStore.Pages.User.Cart" %>
<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">
   



    <div class="container">
        <h2>Your Shopping Cart</h2>

        <asp:Panel ID="pnlEmptyCart" runat="server" CssClass="alert alert-info" Visible="false">
            Your cart is empty.
            <asp:HyperLink ID="lnkContinueShopping" runat="server" NavigateUrl="~/Pages/Products.aspx">Continue shopping</asp:HyperLink>
        </asp:Panel>

        <asp:Panel ID="pnlCart" runat="server">
            <div class="table-responsive">
                <asp:GridView ID="gvCart" runat="server" CssClass="table table-striped table-hover" AutoGenerateColumns="false"
                    OnRowCommand="gvCart_RowCommand" DataKeyNames="ProductId">
                    <Columns>
                        <asp:TemplateField HeaderText="Product">
                            <ItemTemplate>
                                <div class="d-flex align-items-center">
                                    <img src='<%# Eval("ImagePath") %>' class="cart-thumbnail me-3" alt='<%# Eval("ProductName") %>' style="width: 60px; height: 60px; object-fit: cover;">
                                    <strong><%# Eval("ProductName") %></strong>
                                </div>
                            </ItemTemplate>
                        </asp:TemplateField>
                        <asp:BoundField DataField="Price" HeaderText="Price" DataFormatString="${0:0.00}" />
                        <asp:TemplateField HeaderText="Quantity">
                            <ItemTemplate>
                                <div class="d-flex align-items-center">
                                    <asp:Button ID="btnDecrease" runat="server" CssClass="btn btn-outline-secondary btn-sm" Text="-"
                                        CommandName="DecreaseQty" CommandArgument='<%# Eval("ProductId") %>' />
                                    <asp:Label ID="lblQuantity" runat="server" CssClass="mx-2" Text='<%# Eval("Quantity") %>'></asp:Label>
                                    <asp:Button ID="btnIncrease" runat="server" CssClass="btn btn-outline-secondary btn-sm" Text="+"
                                        CommandName="IncreaseQty" CommandArgument='<%# Eval("ProductId") %>' />
                                </div>
                            </ItemTemplate>
                        </asp:TemplateField>
                        <asp:BoundField DataField="ItemTotal" HeaderText="Total" DataFormatString="${0:0.00}" />
                        <asp:TemplateField HeaderText="Action">
                            <ItemTemplate>
                                <asp:Button ID="btnRemove" runat="server" CssClass="btn btn-danger btn-sm" Text="Remove"
                                    CommandName="RemoveItem" CommandArgument='<%# Eval("ProductId") %>' />
                            </ItemTemplate>
                        </asp:TemplateField>
                    </Columns>
                </asp:GridView>
            </div>

            <div class="row mt-4">
                <div class="col-md-6">
                    <asp:HyperLink ID="lnkContinueShoppingWithItems" runat="server" NavigateUrl="Products.aspx" CssClass="btn btn-outline-primary">
                        Continue Shopping
                    </asp:HyperLink>
                    <asp:Button ID="btnClearCart" runat="server" Text="Clear Cart" CssClass="btn btn-outline-danger ms-2" OnClick="btnClearCart_Click" />
                </div>
                <div class="col-md-6">
                    <div class="card">
                        <div class="card-body">
                            <div class="d-flex justify-content-between mb-2">
                                <span>Subtotal:</span>
                                <asp:Label ID="lblSubtotal" runat="server" CssClass="text-end"></asp:Label>
                            </div>
                            <div class="d-flex justify-content-between mb-2">
                                <span>Shipping:</span>
                                <asp:Label ID="lblShipping" runat="server" CssClass="text-end">$5.00</asp:Label>
                            </div>
                            <hr />
                            <div class="d-flex justify-content-between mb-3">
                                <strong>Total:</strong>
                                <asp:Label ID="lblTotal" runat="server" CssClass="text-end fw-bold"></asp:Label>
                            </div>
                            <asp:Button ID="btnCheckout" runat="server" Text="Proceed to Checkout" CssClass="btn btn-success w-100" OnClick="btnCheckout_Click" />
                        </div>
                    </div>
                </div>
            </div>
        </asp:Panel>
    </div>
</asp:Content>


