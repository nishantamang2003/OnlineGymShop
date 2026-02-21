<%@ Page Title="" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="MyOrders.aspx.cs" Inherits="OnlineGymStore.Pages.User.MyOrders" %>
<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">
  



    <div class="container mt-5">
        <div class="row">
            <div class="col-12">
                <h2>My Orders</h2>
                <hr />
            </div>
        </div>

        <asp:Panel ID="pnlNoOrders" runat="server" Visible="false" CssClass="text-center my-5">
            <div class="alert alert-info">
                <h4>No Orders Found</h4>
                <p>You haven't placed any orders yet.</p>
                <asp:HyperLink ID="lnkStartShopping" runat="server" Text="Start Shopping" NavigateUrl="~/Default.aspx" CssClass="btn btn-primary mt-3"></asp:HyperLink>
            </div>
        </asp:Panel>

        <asp:Panel ID="pnlOrders" runat="server" Visible="false">
            <div class="card mb-4">
                <div class="card-header">
                    <h4>Order History</h4>
                </div>
                <div class="card-body">
                    <asp:GridView ID="gvOrders" runat="server" AutoGenerateColumns="false" CssClass="table table-striped table-bordered"
                        OnRowCommand="gvOrders_RowCommand" DataKeyNames="OrderID">
                        <Columns>
                            <asp:BoundField DataField="OrderID" HeaderText="Order #" />
                            <asp:BoundField DataField="OrderDate" HeaderText="Date" DataFormatString="{0:MMM dd, yyyy}" />
                            <asp:BoundField DataField="Total" HeaderText="Total" DataFormatString="${0:0.00}" />
                            <asp:BoundField DataField="Status" HeaderText="Status" />
                            <asp:TemplateField HeaderText="Actions">
                                <ItemTemplate>
                                    <asp:LinkButton ID="lnkViewDetails" runat="server" Text="View Details"
                                        CommandName="ViewDetails" CommandArgument='<%# Eval("OrderID") %>'
                                        CssClass="btn btn-sm btn-outline-primary"></asp:LinkButton>
                                </ItemTemplate>
                            </asp:TemplateField>
                        </Columns>
                        <EmptyDataTemplate>
                            <div class="text-center">No orders found.</div>
                        </EmptyDataTemplate>
                    </asp:GridView>
                </div>
            </div>
        </asp:Panel>

        <!-- Order Details Modal -->
        <asp:Panel ID="pnlOrderDetails" runat="server" Visible="false" CssClass="card mb-4">
            <div class="card-header d-flex justify-content-between align-items-center">
                <h4>Order #<asp:Label ID="lblOrderId" runat="server"></asp:Label>
                    Details</h4>
                <asp:LinkButton ID="lnkBackToOrders" runat="server" Text="Back to Orders" OnClick="lnkBackToOrders_Click"
                    CssClass="btn btn-sm btn-outline-secondary"></asp:LinkButton>
            </div>
            <div class="card-body">
                <div class="row mb-4">
                    <div class="col-md-6">
                        <h5>Order Information</h5>
                        <p>
                            <strong>Order Date:</strong>
                            <asp:Label ID="lblOrderDate" runat="server"></asp:Label><br />
                            <strong>Status:</strong>
                            <asp:Label ID="lblOrderStatus" runat="server"></asp:Label><br />
                        </p>
                    </div>
                    <div class="col-md-6">
                        <h5>Order Summary</h5>
                        <p>
                            <strong>Subtotal:</strong>
                            <asp:Label ID="lblSubtotal" runat="server"></asp:Label><br />
                            <strong>Shipping:</strong>
                            <asp:Label ID="lblShipping" runat="server"></asp:Label><br />
                            <strong>Tax:</strong>
                            <asp:Label ID="lblTax" runat="server"></asp:Label><br />
                            <strong>Total:</strong>
                            <asp:Label ID="lblTotal" runat="server"></asp:Label>
                        </p>
                    </div>
                </div>

                <h5>Order Items</h5>
                <div class="table-responsive">
                    <asp:GridView ID="gvOrderItems" runat="server" AutoGenerateColumns="false" CssClass="table table-striped table-bordered">
                        <Columns>
                            <asp:BoundField DataField="ProductName" HeaderText="Product" />
                            <asp:BoundField DataField="Quantity" HeaderText="Quantity" />
                            <asp:BoundField DataField="UnitPrice" HeaderText="Price" DataFormatString="${0:0.00}" />
                            <asp:BoundField DataField="ItemTotal" HeaderText="Total" DataFormatString="${0:0.00}" />
                        </Columns>
                        <EmptyDataTemplate>
                            <div class="text-center">No items found for this order.</div>
                        </EmptyDataTemplate>
                    </asp:GridView>
                </div>
            </div>
        </asp:Panel>
    </div>
</asp:Content>


