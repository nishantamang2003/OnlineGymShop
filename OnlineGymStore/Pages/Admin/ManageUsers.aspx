<%@ Page Title="" Language="C#" MasterPageFile="~/Pages/Admin/Admin.Master" AutoEventWireup="true" CodeBehind="ManageUsers.aspx.cs" Inherits="OnlineGymStore.Pages.Admin.ManageUsers" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <style>
        /* Minimal Black & White Theme */
        body {
            background-color: #f8f9fa;
            color: #495057;
            font-family: 'Segoe UI', Arial, sans-serif;
        }

        .admin-container {
            max-width: 1200px;
            margin: 0 auto;
            padding: 20px;
        }

        .card {
            background: white;
            border: 1px solid #e0e0e0;
            border-radius: 4px;
            box-shadow: 0 1px 3px rgba(0,0,0,0.05);
            margin-bottom: 20px;
        }

        .card-header {
            padding: 15px 20px;
            background: #ffffff;
            border-bottom: 1px solid #e0e0e0;
        }

            .card-header h3 {
                margin: 0;
                color: #212529;
                font-weight: 500;
            }

        .card-body {
            padding: 20px;
        }

        .table {
            width: 100%;
            border-collapse: collapse;
        }

            .table th {
                background-color: #f8f9fa;
                color: #495057;
                font-weight: 500;
                padding: 12px 15px;
                text-align: left;
                border-bottom: 2px solid #e0e0e0;
            }

            .table td {
                padding: 12px 15px;
                border-bottom: 1px solid #e0e0e0;
                color: #6c757d;
            }

            .table tr:hover td {
                background-color: #f8f9fa;
            }

        .form-control {
            padding: 8px 12px;
            border: 1px solid #e0e0e0;
            border-radius: 4px;
            background-color: #fff;
            color: #495057;
            font-size: 14px;
            width: 100%;
        }

        .btn {
            padding: 8px 16px;
            border: none;
            border-radius: 4px;
            font-size: 14px;
            cursor: pointer;
            transition: all 0.2s;
        }

        .btn-primary {
            background-color: #212529;
            color: white;
        }

            .btn-primary:hover {
                background-color: #343a40;
            }

        .btn-outline {
            background: transparent;
            border: 1px solid #e0e0e0;
            color: #495057;
        }

            .btn-outline:hover {
                background-color: #f8f9fa;
            }

        .btn-danger {
            background-color: #dc3545;
            color: white;
        }

            .btn-danger:hover {
                background-color: #c82333;
            }

        .search-container {
            display: flex;
            gap: 10px;
            margin-bottom: 20px;
        }

        .alert {
            padding: 12px 15px;
            border-radius: 4px;
            margin-bottom: 20px;
        }

        .alert-success {
            background-color: #e6f7ee;
            color: #28a745;
            border: 1px solid #c3e6cb;
        }

        .alert-danger {
            background-color: #fdecea;
            color: #dc3545;
            border: 1px solid #f5c6cb;
        }

        .alert-warning {
            background-color: #fff3cd;
            color: #856404;
            border: 1px solid #ffeeba;
        }

        .text-danger {
            color: #dc3545;
            font-size: 12px;
        }

        .action-buttons {
            display: flex;
            gap: 5px;
        }
    </style>
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">
    <div class="admin-container">
        <div class="card">
            <div class="card-header">
                <h3>Manage Users</h3>
            </div>
            <div class="card-body">
                <!-- Alert Message -->
                <asp:Panel ID="pnlAlert" runat="server" CssClass="alert" Visible="false">
                    <asp:Literal ID="ltlAlertMessage" runat="server"></asp:Literal>
                </asp:Panel>

                <!-- Search Box -->
                <div class="search-container">
                    <asp:TextBox ID="txtSearch" runat="server" CssClass="form-control" placeholder="Search by name or email"></asp:TextBox>
                    <asp:Button ID="btnSearch" runat="server" Text="Search" CssClass="btn btn-primary" OnClick="btnSearch_Click" />
                    <asp:Button ID="btnClear" runat="server" Text="Clear" CssClass="btn btn-outline" OnClick="btnClear_Click" />
                </div>

                <!-- Users GridView -->
                <asp:GridView ID="gvUsers" runat="server" AutoGenerateColumns="false"
                    CssClass="table" DataKeyNames="UserID"
                    OnRowCommand="gvUsers_RowCommand"
                    OnRowEditing="gvUsers_RowEditing"
                    OnRowCancelingEdit="gvUsers_RowCancelingEdit"
                    OnRowUpdating="gvUsers_RowUpdating"
                    OnRowDeleting="gvUsers_RowDeleting">
                    <Columns>
                        <asp:BoundField DataField="UserID" HeaderText="ID" ReadOnly="true" />
                        <asp:TemplateField HeaderText="Full Name">
                            <ItemTemplate>
                                <asp:Label ID="lblFullName" runat="server" Text='<%# Eval("FullName") %>'></asp:Label>
                            </ItemTemplate>
                            <EditItemTemplate>
                                <asp:TextBox ID="txtEditFullName" runat="server" Text='<%# Bind("FullName") %>' CssClass="form-control"></asp:TextBox>
                            </EditItemTemplate>
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="Email">
                            <ItemTemplate>
                                <asp:Label ID="lblEmail" runat="server" Text='<%# Eval("Email") %>'></asp:Label>
                            </ItemTemplate>
                            <EditItemTemplate>
                                <asp:TextBox ID="txtEditEmail" runat="server" Text='<%# Bind("Email") %>' CssClass="form-control"></asp:TextBox>
                            </EditItemTemplate>
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="Actions">
                            <ItemTemplate>
                                <div class="action-buttons">
                                    <asp:LinkButton ID="lnkEdit" runat="server" CommandName="Edit" Text="Edit" CssClass="btn btn-outline" />
                                    <asp:LinkButton ID="lnkDelete" runat="server" CommandName="Delete" Text="Delete"
                                        CssClass="btn btn-danger" OnClientClick="return confirm('Are you sure you want to delete this user?');" />

                                </div>
                            </ItemTemplate>
                            <EditItemTemplate>
                                <div class="action-buttons">
                                    <asp:LinkButton ID="lnkUpdate" runat="server" CommandName="Update" Text="Update" CssClass="btn btn-primary" />
                                    <asp:LinkButton ID="lnkCancel" runat="server" CommandName="Cancel" Text="Cancel" CssClass="btn btn-outline" />
                                </div>
                            </EditItemTemplate>
                        </asp:TemplateField>
                    </Columns>
                    <EmptyDataTemplate>
                        <div class="text-center">No users found.</div>
                    </EmptyDataTemplate>
                </asp:GridView>
            </div>
        </div>
    </div>
</asp:Content>


