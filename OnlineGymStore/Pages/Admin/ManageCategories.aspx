<%@ Page Title="" Language="C#" MasterPageFile="~/Pages/Admin/Admin.Master" AutoEventWireup="true" CodeBehind="ManageCategories.aspx.cs" Inherits="OnlineGymStore.Pages.Admin.ManageCategories" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <style>
        /* Minimal Light Theme */
        body {
            background-color: #f8f9fa;
            color: #212529;
            font-family: 'Segoe UI', Arial, sans-serif;
        }

        .admin-container {
            max-width: 1200px;
            margin: 0 auto;
            padding: 20px;
        }

        .card {
            background: #ffffff;
            border: 1px solid #dee2e6;
            border-radius: 4px;
            box-shadow: 0 1px 3px rgba(0,0,0,0.05);
            margin-bottom: 20px;
        }

        .card-header {
            padding: 15px 20px;
            background: #f1f3f5;
            border-bottom: 1px solid #dee2e6;
        }

            .card-header h3 {
                margin: 0;
                color: #495057;
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
                background-color: #f1f3f5;
                color: #495057;
                font-weight: 500;
                padding: 12px 15px;
                text-align: left;
                border-bottom: 2px solid #dee2e6;
            }

            .table td {
                padding: 12px 15px;
                border-bottom: 1px solid #dee2e6;
                color: #495057;
            }

            .table tr:hover td {
                background-color: #f8f9fa;
            }

        .form-control {
            padding: 8px 12px;
            border: 1px solid #ced4da;
            border-radius: 4px;
            background-color: #ffffff;
            color: #495057;
            font-size: 14px;
            width: 100%;
        }

            .form-control:focus {
                outline: none;
                border-color: #80bdff;
                box-shadow: 0 0 0 0.2rem rgba(0,123,255,0.25);
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
            background-color: #007bff;
            color: white;
        }

            .btn-primary:hover {
                background-color: #0069d9;
            }

        .btn-outline {
            background: transparent;
            border: 1px solid #ced4da;
            color: #495057;
        }

            .btn-outline:hover {
                background-color: #f1f3f5;
            }

        .btn-danger {
            background-color: #dc3545;
            color: white;
        }

            .btn-danger:hover {
                background-color: #c82333;
            }

        .btn-success {
            background-color: black;
            color: white;
        }

            .btn-success:hover {
                background-color: grey;
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
            border: 1px solid transparent;
        }

        .alert-success {
            background-color: #d4edda;
            color: #155724;
            border-color: #c3e6cb;
        }

        .alert-danger {
            background-color: #f8d7da;
            color: #721c24;
            border-color: #f5c6cb;
        }

        .alert-warning {
            background-color: #fff3cd;
            color: #856404;
            border-color: #ffeeba;
        }

        .text-danger {
            color: #dc3545;
            font-size: 12px;
        }

        .text-success {
            color: #28a745;
        }

        .action-buttons {
            display: flex;
            gap: 5px;
        }

        .input-group {
            margin-bottom: 15px;
        }

            .input-group label {
                display: block;
                margin-bottom: 5px;
                color: #495057;
            }

        .modal-backdrop {
            background-color: #000;
            opacity: 0.5;
        }

        .modal-content {
            background-color: #ffffff;
            border: 1px solid rgba(0,0,0,0.2);
        }

        .modal-header {
            border-bottom: 1px solid #dee2e6;
            background-color: #f8f9fa;
        }

        .modal-footer {
            border-top: 1px solid #dee2e6;
        }

        .modal-title {
            color: #495057;
        }

        .close {
            color: #6c757d;
        }

        .mb-4 {
            margin-bottom: 1.5rem !important;
        }

        .mt-3 {
            margin-top: 1rem !important;
        }

        .p-3 {
            padding: 1rem !important;
        }

        .text-center {
            text-align: center !important;
        }
    </style>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">
    <div class="admin-container">
        <div class="card">
            <div class="card-header">
                <h3>Manage Categories</h3>
            </div>
            <div class="card-body">
                <!-- Alert Message -->
                <asp:Panel ID="pnlAlert" runat="server" CssClass="alert" Visible="false">
                    <asp:Literal ID="ltlAlertMessage" runat="server"></asp:Literal>
                </asp:Panel>

                <!-- Add New Category Section -->
                <div class="card mb-4">
                    <div class="card-header">
                        <h3>Add New Category</h3>
                    </div>
                    <div class="card-body">
                        <div class="row">
                            <div class="col-md-6">
                                <div class="input-group">
                                    <label for="txtCategoryName">Category Name</label>
                                    <asp:TextBox ID="txtCategoryName" runat="server" CssClass="form-control" placeholder="Enter category name"></asp:TextBox>
                                    <asp:RequiredFieldValidator ID="rfvCategoryName" runat="server"
                                        ControlToValidate="txtCategoryName"
                                        ErrorMessage="Category name is required"
                                        Display="Dynamic"
                                        CssClass="text-danger"
                                        ValidationGroup="AddCategory"></asp:RequiredFieldValidator>
                                </div>
                            </div>
                            <div class="col-md-6">
                                <div class="input-group">
                                    <label for="txtImageUrl">Image URL</label>
                                    <asp:TextBox ID="txtImageUrl" runat="server" CssClass="form-control" placeholder="Enter image URL (optional)"></asp:TextBox>
                                </div>
                            </div>
                        </div>
                        <div class="input-group">
                            <label for="txtDescription">Description</label>
                            <asp:TextBox ID="txtDescription" runat="server" CssClass="form-control" TextMode="MultiLine" Rows="3" placeholder="Enter category description (optional)"></asp:TextBox>
                        </div>
                        <div class="input-group">
                            <asp:CheckBox ID="chkIsActive" runat="server" Checked="true" />
                            <label for="chkIsActive" style="display: inline-block; margin-left: 5px;">Active</label>
                        </div>
                        <div class="mt-3">
                            <asp:Button ID="btnAddCategory" runat="server" Text="Add Category" CssClass="btn btn-success" OnClick="btnAddCategory_Click" ValidationGroup="AddCategory" />
                        </div>
                    </div>
                </div>

                <!-- Search Box -->
                <div class="search-container">
                    <asp:TextBox ID="txtSearch" runat="server" CssClass="form-control" placeholder="Search by category name"></asp:TextBox>
                    <asp:Button ID="btnSearch" runat="server" Text="Search" CssClass="btn btn-primary" OnClick="btnSearch_Click" />
                    <asp:Button ID="btnClear" runat="server" Text="Clear" CssClass="btn btn-outline" OnClick="btnClear_Click" />
                </div>

                <!-- Categories GridView -->
                <asp:GridView ID="gvCategories" runat="server" AutoGenerateColumns="false"
                    CssClass="table" DataKeyNames="CategoryID"
                    OnRowCommand="gvCategories_RowCommand"
                    OnRowEditing="gvCategories_RowEditing"
                    OnRowCancelingEdit="gvCategories_RowCancelingEdit"
                    OnRowUpdating="gvCategories_RowUpdating"
                    OnRowDeleting="gvCategories_RowDeleting">
                    <Columns>
                        <asp:BoundField DataField="CategoryID" HeaderText="ID" ReadOnly="true" />
                        <asp:TemplateField HeaderText="Category Name">
                            <ItemTemplate>
                                <asp:Label ID="lblCategoryName" runat="server" Text='<%# Eval("CategoryName") %>'></asp:Label>
                            </ItemTemplate>
                            <EditItemTemplate>
                                <asp:TextBox ID="txtEditCategoryName" runat="server" Text='<%# Bind("CategoryName") %>' CssClass="form-control"></asp:TextBox>
                                <asp:RequiredFieldValidator ID="rfvEditCategoryName" runat="server"
                                    ControlToValidate="txtEditCategoryName"
                                    ErrorMessage="Category name is required"
                                    Display="Dynamic"
                                    CssClass="text-danger"
                                    ValidationGroup="EditCategory"></asp:RequiredFieldValidator>
                            </EditItemTemplate>
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="Description">
                            <ItemTemplate>
                                <asp:Label ID="lblDescription" runat="server" Text='<%# Eval("Description") %>'></asp:Label>
                            </ItemTemplate>
                            <EditItemTemplate>
                                <asp:TextBox ID="txtEditDescription" runat="server" Text='<%# Bind("Description") %>' CssClass="form-control" TextMode="MultiLine" Rows="2"></asp:TextBox>
                            </EditItemTemplate>
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="Image URL">
                            <ItemTemplate>
                                <asp:Label ID="lblImageUrl" runat="server" Text='<%# Eval("ImageUrl") %>'></asp:Label>
                            </ItemTemplate>
                            <EditItemTemplate>
                                <asp:TextBox ID="txtEditImageUrl" runat="server" Text='<%# Bind("ImageUrl") %>' CssClass="form-control"></asp:TextBox>
                            </EditItemTemplate>
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="Status">
                            <ItemTemplate>
                                <asp:Label ID="lblStatus" runat="server" Text='<%# Convert.ToBoolean(Eval("IsActive")) ? "Active" : "Inactive" %>'
                                    CssClass='<%# Convert.ToBoolean(Eval("IsActive")) ? "text-success" : "text-danger" %>'></asp:Label>
                            </ItemTemplate>
                            <EditItemTemplate>
                                <asp:CheckBox ID="chkEditIsActive" runat="server" Checked='<%# Bind("IsActive") %>' />
                            </EditItemTemplate>
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="Created On">
                            <ItemTemplate>
                                <asp:Label ID="lblCreatedDate" runat="server" Text='<%# Eval("CreatedDate", "{0:MMM dd, yyyy}") %>'></asp:Label>
                            </ItemTemplate>
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="Actions">
                            <ItemTemplate>
                                <div class="action-buttons">
                                    <asp:LinkButton ID="lnkEdit" runat="server" CommandName="Edit" Text="Edit" CssClass="btn btn-outline" />
                                    <asp:LinkButton ID="lnkDelete" runat="server" CommandName="Delete" Text="Delete"
                                        CssClass="btn btn-danger" OnClientClick="return confirm('Are you sure you want to delete this category?');" />
                                </div>
                            </ItemTemplate>
                            <EditItemTemplate>
                                <div class="action-buttons">
                                    <asp:LinkButton ID="lnkUpdate" runat="server" CommandName="Update" Text="Update" CssClass="btn btn-primary" ValidationGroup="EditCategory" />
                                    <asp:LinkButton ID="lnkCancel" runat="server" CommandName="Cancel" Text="Cancel" CssClass="btn btn-outline" CausesValidation="false" />
                                </div>
                            </EditItemTemplate>
                        </asp:TemplateField>
                    </Columns>
                    <EmptyDataTemplate>
                        <div class="text-center p-3">No categories found.</div>
                    </EmptyDataTemplate>
                </asp:GridView>
            </div>
        </div>
    </div>
</asp:Content>
