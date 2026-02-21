<%@ Page Title="Dashboard" Language="C#" MasterPageFile="~/Pages/Admin/Admin.Master" AutoEventWireup="true" CodeBehind="Dashboard.aspx.cs" Inherits="OnlineGymStore.Pages.Admin.Dashboard" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <style>
        .dashboard-container {
            padding: 20px;
        }
        
        .summary-cards {
            display: grid;
            grid-template-columns: repeat(auto-fill, minmax(250px, 1fr));
            gap: 20px;
            margin-bottom: 30px;
        }
        
        .summary-card {
            background: white;
            border-radius: 8px;
            padding: 20px;
            box-shadow: 0 4px 6px rgba(0, 0, 0, 0.1);
            transition: transform 0.3s ease;
            position: relative;
            overflow: hidden;
            border-left: 4px solid;
        }
        
        .summary-card:hover {
            transform: translateY(-5px);
        }
        
        .card-users {
            border-left-color: #4e73df;
        }
        
        .card-products {
            border-left-color: #1cc88a;
        }
        
        .card-orders {
            border-left-color: #f6c23e;
        }
        
        .card-revenue {
            border-left-color: #e74a3b;
        }
        
        .card-title {
            color: #5a5c69;
            font-size: 0.9rem;
            font-weight: 600;
            text-transform: uppercase;
            margin-bottom: 0.5rem;
        }
        
        .card-value {
            font-size: 1.5rem;
            font-weight: 700;
            color: #2e2e2e;
        }
        
        .card-icon {
            position: absolute;
            right: 20px;
            top: 20px;
            color: #dddfeb;
            font-size: 2rem;
        }
        
        .charts-container {
            display: grid;
            grid-template-columns: 2fr 1fr;
            gap: 20px;
            margin-bottom: 30px;
        }
        
        @media (max-width: 992px) {
            .charts-container {
                grid-template-columns: 1fr;
            }
        }
        
        .chart-card {
            background: white;
            border-radius: 8px;
            padding: 20px;
            box-shadow: 0 4px 6px rgba(0, 0, 0, 0.1);
        }
        
        .chart-header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 20px;
        }
        
        .chart-title {
            font-size: 1.1rem;
            font-weight: 600;
            color: #2e2e2e;
        }
        
        .recent-orders {
            background: white;
            border-radius: 8px;
            padding: 20px;
            box-shadow: 0 4px 6px rgba(0, 0, 0, 0.1);
        }
        
        .orders-table {
            width: 100%;
            border-collapse: collapse;
        }
        
        .orders-table th {
            text-align: left;
            padding: 12px 15px;
            background-color: #f8f9fc;
            color: #5a5c69;
            font-weight: 600;
            text-transform: uppercase;
            font-size: 0.7rem;
            letter-spacing: 0.5px;
        }
        
        .orders-table td {
            padding: 12px 15px;
            border-bottom: 1px solid #e3e6f0;
            color: #5a5c69;
        }
        
        .orders-table tr:last-child td {
            border-bottom: none;
        }
        
        .status {
            padding: 5px 10px;
            border-radius: 20px;
            font-size: 0.75rem;
            font-weight: 600;
            text-transform: uppercase;
        }
        
        .status-pending {
            background-color: #fff3cd;
            color: #856404;
        }
        
        .status-completed {
            background-color: #d4edda;
            color: #155724;
        }
        
        .status-processing {
            background-color: #cce5ff;
            color: #004085;
        }
        
        .view-all {
            display: block;
            text-align: right;
            margin-top: 15px;
            color: #ff6b00;
            font-weight: 600;
            text-decoration: none;
        }
        
        .view-all:hover {
            text-decoration: underline;
        }
    </style>
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">
    <div class="dashboard-container">
        <h1 class="page-title">Dashboard Overview</h1>
        
        <!-- Summary Cards -->
        <div class="summary-cards">
            <div class="summary-card card-users">
                <div class="card-title">Total Users</div>
                <div class="card-value"><asp:Label ID="lblTotalUsers" runat="server" Text="0"></asp:Label></div>
                <i class="fas fa-users card-icon"></i>
            </div>
            
            <div class="summary-card card-products">
                <div class="card-title">Total Products</div>
                <div class="card-value"><asp:Label ID="lblTotalProducts" runat="server" Text="0"></asp:Label></div>
                <i class="fas fa-dumbbell card-icon"></i>
            </div>
            
            <div class="summary-card card-orders">
                <div class="card-title">New Orders</div>
                <div class="card-value"><asp:Label ID="lblNewOrders" runat="server" Text="0"></asp:Label></div>
                <i class="fas fa-shopping-cart card-icon"></i>
            </div>
            
            <div class="summary-card card-revenue">
                <div class="card-title">Total Revenue</div>
                <div class="card-value">$<asp:Label ID="lblTotalRevenue" runat="server" Text="0"></asp:Label></div>
                <i class="fas fa-dollar-sign card-icon"></i>
            </div>
        </div>
        
        <!-- Charts Section -->
        <div class="charts-container">
            <div class="chart-card">
                <div class="chart-header">
                    <h2 class="chart-title">Sales Overview</h2>
                    <asp:DropDownList ID="ddlTimePeriod" runat="server" CssClass="chart-select" AutoPostBack="true" OnSelectedIndexChanged="ddlTimePeriod_SelectedIndexChanged">
                        <asp:ListItem Value="7">Last 7 Days</asp:ListItem>
                        <asp:ListItem Value="30" Selected="True">Last 30 Days</asp:ListItem>
                        <asp:ListItem Value="90">Last 3 Months</asp:ListItem>
                        <asp:ListItem Value="365">Last Year</asp:ListItem>
                    </asp:DropDownList>
                </div>
                <div style="height: 300px;">
                    <!-- Chart will be rendered here -->
                    <asp:Literal ID="ltSalesChart" runat="server"></asp:Literal>
                </div>
            </div>
            
            <div class="chart-card">
                <div class="chart-header">
                    <h2 class="chart-title">Revenue Sources</h2>
                </div>
                <div style="height: 300px;">
                    <!-- Chart will be rendered here -->
                    <asp:Literal ID="ltRevenueChart" runat="server"></asp:Literal>
                </div>
            </div>
        </div>
        
        <!-- Recent Orders -->
        <div class="recent-orders">
            <h2 class="chart-title">Recent Orders</h2>
            <asp:GridView ID="gvRecentOrders" runat="server" AutoGenerateColumns="False" CssClass="orders-table" GridLines="None">
                <Columns>
                    <asp:BoundField DataField="OrderID" HeaderText="Order ID" />
                    <asp:BoundField DataField="CustomerName" HeaderText="Customer" />
                    <asp:BoundField DataField="OrderDate" HeaderText="Date" DataFormatString="{0:MMM dd, yyyy}" />
                    <asp:BoundField DataField="TotalAmount" HeaderText="Amount" DataFormatString="${0:F2}" />
                    <asp:TemplateField HeaderText="Status">
                        <ItemTemplate>
                            <span class='status status-<%# Eval("Status").ToString().ToLower() %>'><%# Eval("Status") %></span>
                        </ItemTemplate>
                    </asp:TemplateField>
                    <asp:TemplateField HeaderText="Action">
                        <ItemTemplate>
                            <a href='ManageOrder.aspx?orderId=<%# Eval("OrderID") %>' class="text-primary">View</a>
                        </ItemTemplate>
                    </asp:TemplateField>
                </Columns>
                <EmptyDataTemplate>
                    <tr><td colspan="6" style="text-align:center;">No recent orders found</td></tr>
                </EmptyDataTemplate>
            </asp:GridView>
            <a href="ManageOrder.aspx" class="view-all">View All Orders →</a>
        </div>
    </div>
</asp:Content>