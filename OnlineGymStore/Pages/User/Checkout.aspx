<%@ Page Title="" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="Checkout.aspx.cs" Inherits="OnlineGymStore.Pages.User.Checkout" %>
<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">
 


    <div class="container mt-5">
        <div class="row">
            <div class="col-12">
                <h2>Checkout</h2>
                <hr />
            </div>
        </div>

        <div class="row">
            <!-- Shipping and Billing Form -->
            <div class="col-md-8">
                <div class="card mb-4">
                    <div class="card-header">
                        <h4>Shipping Information</h4>
                    </div>
                    <div class="card-body">
                        <div class="row">
                            <div class="col-md-6 mb-3">
                                <label for="txtFirstName">First Name</label>
                                <asp:TextBox ID="txtFirstName" runat="server" CssClass="form-control" placeholder="First Name"></asp:TextBox>
                                <asp:RequiredFieldValidator ID="rfvFirstName" runat="server" ControlToValidate="txtFirstName"
                                    CssClass="text-danger" ErrorMessage="First name is required" Display="Dynamic"></asp:RequiredFieldValidator>
                            </div>
                            <div class="col-md-6 mb-3">
                                <label for="txtLastName">Last Name</label>
                                <asp:TextBox ID="txtLastName" runat="server" CssClass="form-control" placeholder="Last Name"></asp:TextBox>
                                <asp:RequiredFieldValidator ID="rfvLastName" runat="server" ControlToValidate="txtLastName"
                                    CssClass="text-danger" ErrorMessage="Last name is required" Display="Dynamic"></asp:RequiredFieldValidator>
                            </div>
                        </div>

                        <div class="mb-3">
                            <label for="txtEmail">Email</label>
                            <asp:TextBox ID="txtEmail" runat="server" CssClass="form-control" placeholder="Email" TextMode="Email"></asp:TextBox>
                            <asp:RequiredFieldValidator ID="rfvEmail" runat="server" ControlToValidate="txtEmail"
                                CssClass="text-danger" ErrorMessage="Email is required" Display="Dynamic"></asp:RequiredFieldValidator>
                            <asp:RegularExpressionValidator ID="revEmail" runat="server" ControlToValidate="txtEmail"
                                CssClass="text-danger" ErrorMessage="Invalid email format"
                                ValidationExpression="^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$" Display="Dynamic"></asp:RegularExpressionValidator>
                        </div>

                        <div class="mb-3">
                            <label for="txtPhone">Phone Number</label>
                            <asp:TextBox ID="txtPhone" runat="server" CssClass="form-control" placeholder="Phone Number"></asp:TextBox>
                            <asp:RequiredFieldValidator ID="rfvPhone" runat="server" ControlToValidate="txtPhone"
                                CssClass="text-danger" ErrorMessage="Phone number is required" Display="Dynamic"></asp:RequiredFieldValidator>
                        </div>

                        <div class="mb-3">
                            <label for="txtAddress">Address</label>
                            <asp:TextBox ID="txtAddress" runat="server" CssClass="form-control" placeholder="Street Address"></asp:TextBox>
                            <asp:RequiredFieldValidator ID="rfvAddress" runat="server" ControlToValidate="txtAddress"
                                CssClass="text-danger" ErrorMessage="Address is required" Display="Dynamic"></asp:RequiredFieldValidator>
                        </div>

                        <div class="row">
                            <div class="col-md-4 mb-3">
                                <label for="txtCity">City</label>
                                <asp:TextBox ID="txtCity" runat="server" CssClass="form-control" placeholder="City"></asp:TextBox>
                                <asp:RequiredFieldValidator ID="rfvCity" runat="server" ControlToValidate="txtCity"
                                    CssClass="text-danger" ErrorMessage="City is required" Display="Dynamic"></asp:RequiredFieldValidator>
                            </div>
                            <div class="col-md-4 mb-3">
                                <label for="txtState">State</label>
                                <asp:TextBox ID="txtState" runat="server" CssClass="form-control" placeholder="State"></asp:TextBox>
                                <asp:RequiredFieldValidator ID="rfvState" runat="server" ControlToValidate="txtState"
                                    CssClass="text-danger" ErrorMessage="State is required" Display="Dynamic"></asp:RequiredFieldValidator>
                            </div>
                            <div class="col-md-4 mb-3">
                                <label for="txtZip">ZIP Code</label>
                                <asp:TextBox ID="txtZip" runat="server" CssClass="form-control" placeholder="ZIP Code"></asp:TextBox>
                                <asp:RequiredFieldValidator ID="rfvZip" runat="server" ControlToValidate="txtZip"
                                    CssClass="text-danger" ErrorMessage="ZIP code is required" Display="Dynamic"></asp:RequiredFieldValidator>
                            </div>
                        </div>
                    </div>
                </div>

                <div class="card mb-4">
                    <div class="card-header">
                        <h4>Payment Information</h4>
                    </div>
                    <div class="card-body">
                        <div class="mb-3">
                            <label for="ddlCardType">Card Type</label>
                            <asp:DropDownList ID="ddlCardType" runat="server" CssClass="form-control">
                                <asp:ListItem Text="Visa" Value="Visa"></asp:ListItem>
                                <asp:ListItem Text="MasterCard" Value="MasterCard"></asp:ListItem>
                                <asp:ListItem Text="American Express" Value="AmEx"></asp:ListItem>
                                <asp:ListItem Text="Discover" Value="Discover"></asp:ListItem>
                            </asp:DropDownList>
                        </div>

                        <div class="mb-3">
                            <label for="txtCardNumber">Card Number</label>
                            <asp:TextBox ID="txtCardNumber" runat="server" CssClass="form-control" placeholder="Card Number"></asp:TextBox>
                            <asp:RequiredFieldValidator ID="rfvCardNumber" runat="server" ControlToValidate="txtCardNumber"
                                CssClass="text-danger" ErrorMessage="Card number is required" Display="Dynamic"></asp:RequiredFieldValidator>
                        </div>

                        <div class="row">
                            <div class="col-md-6 mb-3">
                                <label for="txtExpiration">Expiration Date (MM/YY)</label>
                                <asp:TextBox ID="txtExpiration" runat="server" CssClass="form-control" placeholder="MM/YY"></asp:TextBox>
                                <asp:RequiredFieldValidator ID="rfvExpiration" runat="server" ControlToValidate="txtExpiration"
                                    CssClass="text-danger" ErrorMessage="Expiration date is required" Display="Dynamic"></asp:RequiredFieldValidator>
                            </div>
                            <div class="col-md-6 mb-3">
                                <label for="txtCVV">CVV</label>
                                <asp:TextBox ID="txtCVV" runat="server" CssClass="form-control" placeholder="CVV" TextMode="Password"></asp:TextBox>
                                <asp:RequiredFieldValidator ID="rfvCVV" runat="server" ControlToValidate="txtCVV"
                                    CssClass="text-danger" ErrorMessage="CVV is required" Display="Dynamic"></asp:RequiredFieldValidator>
                            </div>
                        </div>

                        <div class="mb-3">
                            <label for="txtNameOnCard">Name on Card</label>
                            <asp:TextBox ID="txtNameOnCard" runat="server" CssClass="form-control" placeholder="Name on Card"></asp:TextBox>
                            <asp:RequiredFieldValidator ID="rfvNameOnCard" runat="server" ControlToValidate="txtNameOnCard"
                                CssClass="text-danger" ErrorMessage="Name on card is required" Display="Dynamic"></asp:RequiredFieldValidator>
                        </div>
                    </div>
                </div>
            </div>

            <!-- Order Summary -->
            <div class="col-md-4">
                <div class="card mb-4">
                    <div class="card-header">
                        <h4>Order Summary</h4>
                    </div>
                    <div class="card-body">
                        <asp:Repeater ID="rptOrderSummary" runat="server">
                            <HeaderTemplate>
                                <div class="table-responsive">
                                    <table class="table table-striped">
                                        <thead>
                                            <tr>
                                                <th>Product</th>
                                                <th>Qty</th>
                                                <th class="text-right">Price</th>
                                            </tr>
                                        </thead>
                                        <tbody>
                            </HeaderTemplate>
                            <ItemTemplate>
                                <tr>
                                    <td><%# Eval("ProductName") %></td>
                                    <td><%# Eval("Quantity") %></td>
                                    <td class="text-right">$<%# Eval("ItemTotal", "{0:0.00}") %></td>
                                </tr>
                            </ItemTemplate>
                            <FooterTemplate>
                                </tbody>
                                    </table>
                                </div>
                            </FooterTemplate>
                        </asp:Repeater>

                        <hr />

                        <div class="d-flex justify-content-between mb-2">
                            <span>Subtotal:</span>
                            <asp:Label ID="lblSubtotal" runat="server" CssClass="font-weight-bold"></asp:Label>
                        </div>
                        <div class="d-flex justify-content-between mb-2">
                            <span>Shipping:</span>
                            <asp:Label ID="lblShipping" runat="server" CssClass="font-weight-bold"></asp:Label>
                        </div>
                        <div class="d-flex justify-content-between mb-2">
                            <span>Tax:</span>
                            <asp:Label ID="lblTax" runat="server" CssClass="font-weight-bold"></asp:Label>
                        </div>
                        <hr />
                        <div class="d-flex justify-content-between mb-4">
                            <span class="font-weight-bold">Total:</span>
                            <asp:Label ID="lblTotal" runat="server" CssClass="font-weight-bold"></asp:Label>
                        </div>

                        <asp:Button ID="btnPlaceOrder" runat="server" Text="Place Order" CssClass="btn btn-success btn-lg btn-block"
                            OnClick="btnPlaceOrder_Click" />

                        <div class="mt-3">
                            <asp:HyperLink ID="lnkBackToCart" runat="server" Text="Back to Cart" NavigateUrl="~/Pages/User/Cart.aspx"
                                CssClass="btn btn-outline-secondary btn-block"></asp:HyperLink>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
</asp:Content>


