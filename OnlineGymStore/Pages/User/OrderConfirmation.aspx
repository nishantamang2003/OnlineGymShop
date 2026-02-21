<%@ Page Title="" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="OrderConfirmation.aspx.cs" Inherits="OnlineGymStore.Pages.User.OrderConfirmation" %>
<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">
  
    <div class="container mt-5">
        <div class="row justify-content-center">
            <div class="col-md-8">
                <div class="card">
                    <div class="card-header bg-success text-white">
                        <h3><i class="fa fa-check-circle"></i>Order Confirmation</h3>
                    </div>
                    <div class="card-body text-center">
                        <h4 class="mb-4">Thank you for your order!</h4>
                        <p class="lead">Your order has been successfully placed and is being processed.</p>
                        <div class="alert alert-light mt-4">
                            <div class="row">
                                <div class="col-md-6 text-md-right">Order Number:</div>
                                <div class="col-md-6 text-md-left font-weight-bold">
                                    <asp:Label ID="lblOrderId" runat="server"></asp:Label>
                                </div>
                            </div>
                            <div class="row">
                                <div class="col-md-6 text-md-right">Order Date:</div>
                                <div class="col-md-6 text-md-left font-weight-bold">
                                    <asp:Label ID="lblOrderDate" runat="server"></asp:Label>
                                </div>
                            </div>
                            <div class="row">
                                <div class="col-md-6 text-md-right">Order Total:</div>
                                <div class="col-md-6 text-md-left font-weight-bold">
                                    <asp:Label ID="lblOrderTotal" runat="server"></asp:Label>
                                </div>
                            </div>
                        </div>

                        <p class="mt-4">A confirmation email has been sent to your email address.</p>

                        <div class="mt-5">
                            <asp:HyperLink ID="lnkContinueShopping" runat="server" Text="Continue Shopping"
                                NavigateUrl="LandingPage.aspx" CssClass="btn btn-primary mx-2"></asp:HyperLink>
                            <asp:HyperLink ID="lnkMyOrders" runat="server" Text="View My Orders"
                                NavigateUrl="~/Pages/User/MyOrders.aspx" CssClass="btn btn-outline-secondary mx-2"></asp:HyperLink>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
</asp:Content>
