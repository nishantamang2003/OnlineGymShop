<%@ Page Title="" Language="C#" MasterPageFile="~/Pages/Admin/Admin.Master" AutoEventWireup="true" CodeBehind="ManageOrders.aspx.cs" Inherits="OnlineGymStore.Pages.Admin.ManageOrders" %>
   <asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <style>
        /* Enhanced Base Styles */
        .order-list {
            margin-bottom: 35px;
            box-shadow: 0 5px 25px rgba(0, 0, 0, 0.08);
            border-radius: 12px;
            overflow: hidden;
            border: 1px solid rgba(0,0,0,0.03);
            background: white;
        }

        /* Premium Status Badges */
        .status-badge {
            display: inline-flex;
            align-items: center;
            padding: 6px 14px;
            border-radius: 24px;
            font-size: 12px;
            font-weight: 600;
            text-transform: uppercase;
            letter-spacing: 0.5px;
            box-shadow: 0 2px 6px rgba(0,0,0,0.08);
            line-height: 1;
        }

        .status-Pending {
            background: linear-gradient(135deg, #FFD166 0%, #FFA800 100%);
            color: #5E4200;
        }

        .status-Processing {
            background: linear-gradient(135deg, #06D6A0 0%, #1B9AAA 100%);
            color: white;
        }

        .status-Shipped {
            background: linear-gradient(135deg, #118AB2 0%, #073B4C 100%);
            color: white;
        }

        .status-Delivered {
            background: linear-gradient(135deg, #2EC4B6 0%, #0A8754 100%);
            color: white;
        }

        .status-Cancelled {
            background: linear-gradient(135deg, #EF476F 0%, #D00000 100%);
            color: white;
        }

        /* Elevated Card Design */
        .card {
            border: none;
            border-radius: 12px;
            overflow: hidden;
            transition: all 0.3s cubic-bezier(0.25, 0.8, 0.25, 1);
            background: white;
        }

        .card-header {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
            border-bottom: none;
            padding: 18px 25px;
            position: relative;
        }

        .card-header:after {
            content: '';
            position: absolute;
            bottom: 0;
            left: 0;
            width: 100%;
            height: 4px;
            background: linear-gradient(90deg, rgba(255,255,255,0.3) 0%, rgba(255,255,255,0) 100%);
        }

        /* Premium Table Styles */
        .table {
            width: 100%;
            border-collapse: separate;
            border-spacing: 0;
            font-size: 14px;
        }

        .table thead th {
            background: linear-gradient(to bottom, #f8f9fa 0%, #e9ecef 100%);
            color: #495057;
            font-weight: 600;
            border: none;
            padding: 14px 18px;
            position: sticky;
            top: 0;
            border-bottom: 2px solid #dee2e6;
        }

        .table tbody tr {
            transition: all 0.2s ease;
        }

        .table tbody tr:nth-child(even) {
            background-color: #fcfcfc;
        }

        .table tbody tr:hover {
            background-color: #f5f7ff;
            transform: translateX(2px);
        }

        .table td {
            padding: 14px 18px;
            vertical-align: middle;
            border-top: 1px solid #f0f0f0;
        }

        /* Premium Buttons */
        .action-btn {
            border-radius: 24px;
            padding: 7px 18px;
            font-size: 13px;
            font-weight: 500;
            transition: all 0.3s cubic-bezier(0.25, 0.8, 0.25, 1);
            box-shadow: 0 2px 8px rgba(0,0,0,0.1);
            border: none;
            display: inline-flex;
            align-items: center;
            justify-content: center;
        }

        .action-btn i {
            margin-right: 6px;
            font-size: 14px;
        }

        .btn-primary {
            background: linear-gradient(135deg, #4facfe 0%, #00f2fe 100%);
            border: none;
            position: relative;
            overflow: hidden;
        }

        .btn-primary:hover {
            transform: translateY(-2px);
            box-shadow: 0 6px 12px rgba(0,0,0,0.15);
        }

        .btn-primary:active {
            transform: translateY(0);
        }

        /* Enhanced Section Titles */
        .section-title {
            border-bottom: none;
            padding-bottom: 12px;
            margin-bottom: 28px;
            color: #3a3a3a;
            font-weight: 600;
            font-size: 1.2rem;
            position: relative;
            display: inline-block;
        }

        .section-title:after {
            content: '';
            position: absolute;
            left: 0;
            bottom: 0;
            width: 100%;
            height: 3px;
            background: linear-gradient(90deg, #667eea 0%, #764ba2 100%);
            border-radius: 3px;
        }

        /* Order Details Panel Animation */
        .order-details {
            margin-top: 35px;
            animation: slideUp 0.4s cubic-bezier(0.25, 0.8, 0.25, 1);
        }

        @keyframes slideUp {
            from { 
                opacity: 0;
                transform: translateY(20px);
            }
            to { 
                opacity: 1;
                transform: translateY(0);
            }
        }

        /* Form Elements */
        .form-control {
            border-radius: 24px;
            padding: 11px 18px;
            border: 1px solid #e0e0e0;
            box-shadow: 0 2px 6px rgba(0,0,0,0.03);
            transition: all 0.3s ease;
            height: auto;
        }

        .form-control:focus {
            border-color: #667eea;
            box-shadow: 0 0 0 0.2rem rgba(102, 126, 234, 0.25);
        }

        /* Premium Alert */
        .alert-info {
            background: linear-gradient(135deg, #e3f2fd 0%, #bbdefb 100%);
            color: #0d47a1;
            border-radius: 10px;
            border: none;
            padding: 18px 25px;
            box-shadow: 0 3px 12px rgba(0,0,0,0.06);
            border-left: 4px solid #2196F3;
        }

        /* Back Button Enhancement */
        .btn-back {
            background: white;
            color: #495057;
            border: 1px solid #e0e0e0;
            transition: all 0.3s ease;
            box-shadow: 0 2px 6px rgba(0,0,0,0.05);
            padding: 8px 20px;
            border-radius: 24px;
        }

        .btn-back:hover {
            background: #f8f9fa;
            color: #212529;
            transform: translateX(-3px);
            box-shadow: 0 4px 8px rgba(0,0,0,0.08);
        }

        /* Responsive Refinements */
        @media (max-width: 768px) {
            .card-header {
                padding: 15px 20px;
            }
            
            .table td, .table th {
                padding: 10px 12px;
                font-size: 13px;
            }
            
            .action-btn {
                padding: 6px 12px;
                font-size: 12px;
            }
            
            .section-title {
                font-size: 1.1rem;
            }
        }

        /* Micro-interactions */
        .table-hover tbody tr {
            transition: all 0.25s ease;
        }

        .table-hover tbody tr:hover {
            box-shadow: 0 3px 10px rgba(0,0,0,0.08);
        }

        /* Loading Animation (can be triggered when updating status) */
        @keyframes spin {
            0% { transform: rotate(0deg); }
            100% { transform: rotate(360deg); }
        }

        .loading-spinner {
            display: inline-block;
            width: 16px;
            height: 16px;
            border: 2px solid rgba(255,255,255,0.3);
            border-radius: 50%;
            border-top-color: white;
            animation: spin 1s ease-in-out infinite;
            margin-left: 8px;
            vertical-align: middle;
        }
    </style>


</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">
    <div class="container">
        <h1 class="mt-4 mb-3">Manage Orders</h1>

        <!-- Order List Panel -->
        <asp:Panel ID="pnlOrders" runat="server" CssClass="order-list">
            <div class="card">
                <div class="card-header">
                    <h3 class="card-title">All Orders</h3>
                </div>
                <div class="card-body">
                    <asp:GridView ID="gvOrders" runat="server" AutoGenerateColumns="False"
                        CssClass="table table-striped table-bordered"
                        OnRowCommand="gvOrders_RowCommand">
                        <Columns>
                            <asp:BoundField DataField="OrderID" HeaderText="Order ID" />
                            <asp:BoundField DataField="OrderDate" HeaderText="Order Date" DataFormatString="{0:MMM dd, yyyy}" />
                            <asp:BoundField DataField="FullName" HeaderText="Customer" />
                            <asp:BoundField DataField="Email" HeaderText="Email" />
                            <asp:BoundField DataField="Total" HeaderText="Total" DataFormatString="{0:C}" />
                            <asp:TemplateField HeaderText="Status">
                                <ItemTemplate>
                                    <span class="status-badge status-<%# Eval("Status") %>"><%# Eval("Status") %></span>
                                </ItemTemplate>
                            </asp:TemplateField>
                            <asp:TemplateField HeaderText="Actions">
                                <ItemTemplate>
                                    <asp:Button ID="btnUpdate" runat="server"
                                        CommandName="UpdateOrder"
                                        CommandArgument='<%# Eval("OrderID") %>'
                                        Text="Update Status"
                                        CssClass="btn btn-primary btn-sm action-btn" />
                                </ItemTemplate>
                            </asp:TemplateField>
                        </Columns>
                    </asp:GridView>
                </div>
            </div>
        </asp:Panel>

        <!-- No Orders Panel -->
        <asp:Panel ID="pnlNoOrders" runat="server" Visible="false">
            <div class="alert alert-info">
                There are no orders in the system.
            </div>
        </asp:Panel>

        <!-- Order Update Panel -->
        <asp:Panel ID="pnlOrderUpdate" runat="server" Visible="false" CssClass="order-details">
            <div class="card">
                <div class="card-header">
                    <h3 class="card-title">Update Order Status</h3>
                </div>
                <div class="card-body">
                    <div class="row mb-3">
                        <div class="col-md-6">
                            <h4 class="section-title">Order Information</h4>
                            <table class="table">
                                <tr>
                                    <th style="width: 150px;">Order ID:</th>
                                    <td>
                                        <asp:Label ID="lblOrderId" runat="server"></asp:Label></td>
                                </tr>
                                <tr>
                                    <th>Order Date:</th>
                                    <td>
                                        <asp:Label ID="lblOrderDate" runat="server"></asp:Label></td>
                                </tr>
                                <tr>
                                    <th>Customer:</th>
                                    <td>
                                        <asp:Label ID="lblCustomerName" runat="server"></asp:Label></td>
                                </tr>
                                <tr>
                                    <th>Email:</th>
                                    <td>
                                        <asp:Label ID="lblCustomerEmail" runat="server"></asp:Label></td>
                                </tr>
                                <tr>
                                    <th>Total:</th>
                                    <td>
                                        <asp:Label ID="lblTotal" runat="server"></asp:Label></td>
                                </tr>
                            </table>
                        </div>
                        <div class="col-md-6">
                            <h4 class="section-title">Update Status</h4>
                            <div class="form-group">
                                <label for="ddlOrderStatus">Order Status:</label>
                                <asp:DropDownList ID="ddlOrderStatus" runat="server" CssClass="form-control">
                                    <asp:ListItem Text="Pending" Value="Pending"></asp:ListItem>
                                    <asp:ListItem Text="Processing" Value="Processing"></asp:ListItem>
                                    <asp:ListItem Text="Shipped" Value="Shipped"></asp:ListItem>
                                    <asp:ListItem Text="Delivered" Value="Delivered"></asp:ListItem>
                                    <asp:ListItem Text="Cancelled" Value="Cancelled"></asp:ListItem>
                                </asp:DropDownList>
                            </div>
                            <asp:Button ID="btnUpdateStatus" runat="server" Text="Update Status"
                                CssClass="btn btn-primary mt-3" OnClick="btnUpdateStatus_Click" />
                        </div>
                    </div>

                    <h4 class="section-title">Order Items</h4>
                    <asp:GridView ID="gvOrderItems" runat="server" AutoGenerateColumns="False"
                        CssClass="table table-striped table-bordered">
                        <Columns>
                            <asp:BoundField DataField="ProductName" HeaderText="Product" />
                            <asp:BoundField DataField="Quantity" HeaderText="Quantity" />
                            <asp:BoundField DataField="UnitPrice" HeaderText="Unit Price" DataFormatString="{0:C}" />
                            <asp:BoundField DataField="ItemTotal" HeaderText="Total" DataFormatString="{0:C}" />
                        </Columns>
                    </asp:GridView>

                    <div class="mt-3">
                        <asp:LinkButton ID="lnkBackToOrders" runat="server" CssClass="btn btn-secondary"
                            OnClick="lnkBackToOrders_Click">
                            <i class="fa fa-arrow-left"></i> Back to Orders
                        </asp:LinkButton>
                    </div>
                </div>
            </div>
        </asp:Panel>
    </div>
</asp:Content>
