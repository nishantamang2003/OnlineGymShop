<%@ Page Async="true" Title="" Language="C#" MasterPageFile="~/Pages/Admin/Admin.Master" AutoEventWireup="true" CodeBehind="ManageProduct.aspx.cs" Inherits="OnlineGymStore.Pages.Admin.ManageProduct" %>


<asp:Content ID="Content3" ContentPlaceHolderID="head" runat="server">
    <style>
        :root {
            --primary-color: #4f46e5;
            --primary-light: #eef2ff;
            --primary-dark: #4338ca;
            --secondary-color: #7c3aed;
            --accent-color: #6366f1;
            --success-color: #10b981;
            --warning-color: #f59e0b;
            --danger-color: #ef4444;
            --light-gray: #f9fafb;
            --medium-gray: #e5e7eb;
            --dark-gray: #4b5563;
            --text-color: #111827;
            --text-light: #6b7280;
            --shadow-sm: 0 1px 2px rgba(0,0,0,0.05);
            --shadow-md: 0 4px 6px rgba(0,0,0,0.05);
            --shadow-lg: 0 10px 15px rgba(0,0,0,0.1);
            --transition: all 0.2s ease-in-out;
        }

        body {
            background-color: #ffffff;
            color: var(--text-color);
            font-family: 'Inter', -apple-system, BlinkMacSystemFont, sans-serif;
            line-height: 1.5;
        }

        .card {
            border: 1px solid var(--medium-gray);
            border-radius: 10px;
            box-shadow: var(--shadow-sm);
            overflow: hidden;
            transition: var(--transition);
            background: white;
        }

        .card-header {
            background: white;
            color: var(--text-color);
            border-bottom: 1px solid var(--medium-gray);
            padding: 1rem 1.5rem;
            font-weight: 600;
            font-size: 1.1rem;
            display: flex;
            align-items: center;
            justify-content: space-between;
        }

        /* Search Bar */

        .search-container {
            position: relative;
            width: 100%;
            max-width: 400px;
            margin-bottom: 1.5rem;
        }

        .search-input {
            padding: 10px 40px 10px 16px; /* Changed padding to right side */
            border: 1px solid var(--medium-gray);
            border-radius: 8px;
            width: 100%;
            font-size: 0.95rem;
            background-color: white;
            transition: var(--transition);
            box-shadow: var(--shadow-sm);
        }

            .search-input:focus {
                border-color: var(--primary-color);
                box-shadow: 0 0 0 3px rgba(79, 70, 229, 0.1);
                outline: none;
            }

        /* Position the search icon on the right */
        .search-container::after {
            content: "";
            position: absolute;
            right: 16px;
            top: 50%;
            transform: translateY(-50%);
            width: 16px;
            height: 16px;
            background-image: url("data:image/svg+xml,%3Csvg xmlns='http://www.w3.org/2000/svg' width='16' height='16' fill='%236b7280' viewBox='0 0 16 16'%3E%3Cpath d='M11.742 10.344a6.5 6.5 0 1 0-1.397 1.398h-.001c.03.04.062.078.098.115l3.85 3.85a1 1 0 0 0 1.415-1.414l-3.85-3.85a1.007 1.007 0 0 0-.115-.1zM12 6.5a5.5 5.5 0 1 1-11 0 5.5 5.5 0 0 1 11 0z'/%3E%3C/svg%3E");
            background-repeat: no-repeat;
            pointer-events: none;
        }

        /* If you need to keep the original search button element */
        .search-btn {
            position: absolute;
            right: 12px;
            top: 50%;
            transform: translateY(-50%);
            background: transparent;
            border: none;
            color: var(--text-light);
            cursor: pointer;
            padding: 0;
            width: 20px;
            height: 20px;
            display: flex;
            align-items: center;
            justify-content: center;
        }


        /* Product Table */
        .product-table {
            width: 100%;
            border-collapse: separate;
            border-spacing: 0;
            background: white;
            border-radius: 10px;
            overflow: hidden;
            box-shadow: var(--shadow-sm);
        }

            .product-table th {
                background-color: var(--light-gray);
                color: var(--dark-gray);
                font-weight: 600;
                padding: 14px 16px;
                text-align: left;
                border-bottom: 1px solid var(--medium-gray);
                font-size: 0.85rem;
                text-transform: uppercase;
                letter-spacing: 0.5px;
            }

            .product-table td {
                padding: 14px 16px;
                border-bottom: 1px solid var(--medium-gray);
                vertical-align: middle;
                font-size: 0.95rem;
            }

            .product-table tr:last-child td {
                border-bottom: none;
            }

            .product-table tbody tr {
                transition: var(--transition);
            }

                .product-table tbody tr:hover {
                    background-color: var(--primary-light);
                }

        /* Image Thumbnail */
        .product-img-thumbnail {
            width: 44px;
            height: 44px;
            object-fit: cover;
            border-radius: 6px;
            border: 1px solid var(--medium-gray);
            transition: var(--transition);
        }

            .product-img-thumbnail:hover {
                transform: scale(1.8);
                z-index: 10;
                box-shadow: var(--shadow-md);
            }

        /* Status Badges */
        .status-badge {
            padding: 4px 10px;
            border-radius: 6px;
            font-size: 0.75rem;
            font-weight: 500;
            display: inline-flex;
            align-items: center;
        }

            .status-badge i {
                margin-right: 4px;
                font-size: 0.65rem;
            }

        .badge-primary {
            background-color: rgba(79, 70, 229, 0.1);
            color: var(--primary-color);
        }

        .badge-success {
            background-color: rgba(16, 185, 129, 0.1);
            color: var(--success-color);
        }

        .badge-warning {
            background-color: rgba(245, 158, 11, 0.1);
            color: var(--warning-color);
        }

        .badge-danger {
            background-color: rgba(239, 68, 68, 0.1);
            color: var(--danger-color);
        }

        /* Action Buttons */
        .action-btn {
            width: 30px;
            height: 30px;
            border-radius: 6px;
            display: inline-flex;
            align-items: center;
            justify-content: center;
            border: none;
            background: transparent;
            color: var(--text-light);
            transition: var(--transition);
            margin: 0 2px;
        }

            .action-btn:hover {
                background-color: gray;
            }

            .action-btn.edit {
                color: var(--primary-color);
            }

                .action-btn.edit:hover {
                    background-color: rgba(79, 70, 229, 0.1);
                }

            .action-btn.delete {
                color: var(--danger-color);
            }

                .action-btn.delete:hover {
                    background-color: rgba(239, 68, 68, 0.1);
                }

            .action-btn.update {
                color: var(--success-color);
            }

                .action-btn.update:hover {
                    background-color: rgba(16, 185, 129, 0.1);
                }

            .action-btn.cancel {
                color: var(--dark-gray);
            }

                .action-btn.cancel:hover {
                    background-color: rgba(75, 85, 99, 0.1);
                }

        /* Form Elements */
        .form-control, .form-select {
            border: 1px solid var(--medium-gray);
            border-radius: 8px;
            padding: 10px 14px;
            transition: var(--transition);
            font-size: 0.95rem;
            background-color: white;
        }

            .form-control:focus, .form-select:focus {
                border-color: var(--primary-color);
                box-shadow: 0 0 0 3px rgba(79, 70, 229, 0.1);
                outline: none;
            }

        .form-label {
            font-weight: 500;
            color: var(--text-color);
            font-size: 0.9rem;
            margin-bottom: 6px;
            display: block;
        }

        .input-group-text {
            background-color: var(--light-gray);
            border: 1px solid var(--medium-gray);
            color: var(--text-light);
            font-size: 0.9rem;
        }

        /* Add Product Card */
        .product-add-card {
            border: 1px solid var(--medium-gray);
            border-radius: 10px;
            height: 100%;
            display: flex;
            flex-direction: column;
            box-shadow: var(--shadow-sm);
        }

            .product-add-card .card-header {
                background: white;
                border-bottom: 1px solid var(--medium-gray);
                color: var(--text-color);
            }

            .product-add-card .card-body {
                padding: 1.5rem;
                flex: 1;
            }

        .product-add-btn {
            background-color: var(--primary-color);
            color: white;
            border: none;
            padding: 10px 20px;
            border-radius: 8px;
            font-weight: 500;
            transition: var(--transition);
            width: 100%;
        }

            .product-add-btn:hover {
                background-color: gray;
                transform: translateY(-1px);
            }

        /* Empty State */
        .empty-state {
            padding: 2.5rem 2rem;
            text-align: center;
            background: white;
            border-radius: 10px;
            border: 1px dashed var(--medium-gray);
        }

            .empty-state i {
                font-size: 2.5rem;
                color: var(--medium-gray);
                margin-bottom: 1.25rem;
                opacity: 0.7;
            }

            .empty-state h5 {
                color: var(--text-color);
                font-weight: 600;
                margin-bottom: 0.5rem;
            }

            .empty-state p {
                color: var(--text-light);
                max-width: 300px;
                margin: 0 auto 1.5rem;
                font-size: 0.95rem;
            }

        /* Animations */
        @keyframes fadeIn {
            from {
                opacity: 0;
                transform: translateY(8px);
            }

            to {
                opacity: 1;
                transform: translateY(0);
            }
        }

        .product-table tbody tr {
            animation: fadeIn 0.3s ease forwards;
        }

        /* Responsive Adjustments */
        @media (max-width: 992px) {
            .product-management-row {
                gap: 1.25rem;
            }
        }

        @media (max-width: 768px) {
            .card-header {
                padding: 0.875rem 1.25rem;
            }

            .product-table th,
            .product-table td {
                padding: 12px 14px;
            }

            .product-add-card .card-body {
                padding: 1.25rem;
            }
        }

        /* Custom Scrollbar (optional) */
        ::-webkit-scrollbar {
            width: 6px;
            height: 6px;
        }

        ::-webkit-scrollbar-track {
            background: var(--light-gray);
        }

        ::-webkit-scrollbar-thumb {
            background: var(--medium-gray);
            border-radius: 3px;
        }

            ::-webkit-scrollbar-thumb:hover {
                background: var(--dark-gray);
            }
    </style>
</asp:Content>

<asp:Content ID="Content4" ContentPlaceHolderID="MainContent" runat="server">
    <div class="container-fluid">
        <!-- Floating Action Button (Mobile) -->
        <button class="fab-btn d-md-none" data-bs-toggle="modal" data-bs-target="#addProductModal">
            <i class="fas fa-plus"></i>
        </button>

        <div class="card">
            <div class="card-header">
                <div>
                    <i class="fas fa-cubes me-2"></i>
                    <span>Product Management</span>
                </div>
                <span class="badge bg-white text-primary">
                    <i class="fas fa-box-open me-1"></i>
                    <asp:Label ID="lblProductCount" runat="server" Text="0" />
                    Products
                </span>
            </div>

            <div class="card-body">
                <div class="row product-management-row">
                    <div class="col-lg-8">
                        <!-- Search and Filter Bar -->
                        <div class="d-flex flex-column flex-md-row align-items-md-center justify-content-between mb-4">
                            <div class="search-container mb-3 mb-md-0">
                                <asp:TextBox ID="txtSearch" runat="server" CssClass="form-control search-input"
                                    placeholder="Search products..." AutoPostBack="true" OnTextChanged="txtSearch_TextChanged"></asp:TextBox>
                            </div>
                            <div class="d-flex gap-2">
                                <asp:DropDownList ID="ddlCategoryFilter" runat="server" CssClass="form-select" AutoPostBack="true">
                                    <asp:ListItem Text="All Categories" Value="" Selected="True" />
                                </asp:DropDownList>
                                <asp:DropDownList ID="ddlStockFilter" runat="server" CssClass="form-select" AutoPostBack="true">
                                    <asp:ListItem Text="All Stock" Value="" Selected="True" />
                                    <asp:ListItem Text="In Stock" Value="in" />
                                    <asp:ListItem Text="Low Stock" Value="low" />
                                    <asp:ListItem Text="Out of Stock" Value="out" />
                                </asp:DropDownList>
                            </div>
                        </div>

                        <!-- Products Table -->
                        <div class="table-responsive rounded-3">
                            <asp:GridView ID="gvProducts" runat="server" CssClass="table product-table"
                                AutoGenerateColumns="False" DataKeyNames="ProductID"
                                OnRowEditing="gvProducts_RowEditing"
                                OnRowUpdating="gvProducts_RowUpdating"
                                OnRowDeleting="gvProducts_RowDeleting"
                                OnRowCancelingEdit="gvProducts_RowCancelingEdit">
                                <Columns>
                                    <asp:BoundField DataField="ProductID" HeaderText="ID" ReadOnly="True" ItemStyle-CssClass="fw-semibold" ItemStyle-Width="80px" />
                                    <asp:TemplateField HeaderText="Product">
                                        <ItemTemplate>
                                            <div class="d-flex align-items-center">
                                                <asp:Image ID="imgProduct" runat="server" ImageUrl='<%# Eval("ImagePath") %>' CssClass="product-img-thumbnail me-3" />
                                                <div>
                                                    <div class="fw-semibold"><%# Eval("ProductName") %></div>
                                                    <div class="small text-muted"><%# Eval("CategoryName") %></div>
                                                </div>
                                            </div>
                                        </ItemTemplate>
                                        <EditItemTemplate>
                                            <div class="d-flex align-items-center gap-3">
                                                <div>
                                                    <asp:Image ID="imgCurrentProduct" runat="server" ImageUrl='<%# Eval("ImagePath") %>' CssClass="product-img-thumbnail" />
                                                    <asp:FileUpload ID="fuEditImage" runat="server" CssClass="form-control form-control-sm mt-2" />
                                                    <asp:HiddenField ID="hfCurrentImagePath" runat="server" Value='<%# Eval("ImagePath") %>' />
                                                    <asp:HiddenField ID="hfCategoryID" runat="server" Value='<%# Eval("CategoryID") %>' />
                                                </div>
                                                <div class="d-flex flex-column gap-2 w-100">
                                                    <asp:TextBox ID="txtEditProductName" runat="server" Text='<%# Bind("ProductName") %>' CssClass="form-control" placeholder="Product Name" />
                                                    <asp:DropDownList ID="ddlEditCategory" runat="server" CssClass="form-select form-select-sm" />
                                                </div>
                                            </div>
                                        </EditItemTemplate>
                                    </asp:TemplateField>
                                    <asp:TemplateField HeaderText="Price" ItemStyle-Width="120px">
                                        <ItemTemplate>
                                            <div class="fw-bold text-primary">$<%# Eval("Price", "{0:n2}") %></div>
                                        </ItemTemplate>
                                        <EditItemTemplate>
                                            <div class="input-group input-group-sm">
                                                <span class="input-group-text">$</span>
                                                <asp:TextBox ID="txtEditPrice" runat="server" Text='<%# Bind("Price") %>' CssClass="form-control" TextMode="Number" step="0.01" />
                                            </div>
                                        </EditItemTemplate>
                                    </asp:TemplateField>
                                    <asp:TemplateField HeaderText="Stock" ItemStyle-Width="120px">
                                        <ItemTemplate>
                                            <span class='status-badge <%# GetStockStatusClass(Convert.ToInt32(Eval("StockQuantity"))) %>'>
                                                <%# Eval("StockQuantity") %>
                                            </span>
                                        </ItemTemplate>
                                        <EditItemTemplate>
                                            <asp:TextBox ID="txtEditStock" runat="server" Text='<%# Bind("StockQuantity") %>' CssClass="form-control form-control-sm" TextMode="Number" />
                                        </EditItemTemplate>
                                    </asp:TemplateField>
                                    <asp:TemplateField HeaderText="Status" ItemStyle-Width="100px">
                                        <ItemTemplate>
                                            <span class="badge bg-success-light text-success">Active</span>
                                        </ItemTemplate>
                                    </asp:TemplateField>
                                    <asp:TemplateField HeaderText="Actions" ItemStyle-Width="120px">
                                        <ItemTemplate>
                                            <div class="d-flex">
                                                <asp:LinkButton ID="btnEdit" runat="server" CommandName="Edit" CssClass="action-btn edit" ToolTip="Edit">
                                                    <i class="fas fa-pencil-alt"></i>
                                                </asp:LinkButton>
                                                <asp:LinkButton ID="btnDelete" runat="server" CommandName="Delete" CssClass="action-btn delete" ToolTip="Delete"
                                                    OnClientClick="return confirm('Are you sure you want to delete this product?');">
                                                    <i class="fas fa-trash-alt"></i>
                                                </asp:LinkButton>
                                            </div>
                                        </ItemTemplate>
                                        <EditItemTemplate>
                                            <div class="d-flex">
                                                <asp:LinkButton ID="btnUpdate" runat="server" CommandName="Update" CssClass="action-btn update" ToolTip="Save">
                                                    <i class="fas fa-check"></i>
                                                </asp:LinkButton>
                                                <asp:LinkButton ID="btnCancel" runat="server" CommandName="Cancel" CssClass="action-btn cancel" ToolTip="Cancel">
                                                    <i class="fas fa-times"></i>
                                                </asp:LinkButton>
                                            </div>
                                        </EditItemTemplate>
                                    </asp:TemplateField>
                                </Columns>
                                <EmptyDataTemplate>
                                    <div class="empty-state">
                                        <i class="fas fa-box-open"></i>
                                        <h5>No Products Found</h5>
                                        <p>Add your first product to start managing your inventory</p>
                                        <asp:Button runat="server" Text="Add Product" CssClass="btn btn-primary" OnClick="AddProduct_Click" />
                                    </div>
                                </EmptyDataTemplate>
                            </asp:GridView>
                        </div>
                    </div>

                    <!-- Add Product Card -->
                    <div class="col-lg-4">
                        <div class="card product-add-card sticky-top" style="top: 20px;">
                            <div class="card-header">
                                <i class="fas fa-plus-circle me-2"></i>
                                Add New Product
                            </div>
                            <div class="card-body">
                                <div class="mb-3">
                                    <label for="txtProductName" class="form-label">Product Name</label>
                                    <asp:TextBox runat="server" ID="txtProductName" CssClass="form-control" placeholder="Enter product name" />
                                </div>
                                <div class="mb-3">
                                    <label for="ddlCategory" class="form-label">Category</label>
                                    <asp:DropDownList runat="server" ID="ddlCategory" CssClass="form-select">
                                        <asp:ListItem Text="Select a category" Value="" Selected="True" />
                                    </asp:DropDownList>
                                </div>
                                <div class="mb-3">
                                    <label for="txtPrice" class="form-label">Price</label>
                                    <div class="input-group">
                                        <span class="input-group-text">$</span>
                                        <asp:TextBox runat="server" ID="txtPrice" CssClass="form-control" TextMode="Number" step="0.01" placeholder="0.00" />
                                    </div>
                                    <asp:RangeValidator runat="server" ControlToValidate="txtPrice" Type="Double"
                                        MinimumValue="0.01" MaximumValue="999999" ErrorMessage="Please enter a valid price"
                                        CssClass="small text-danger mt-1 d-block" Display="Dynamic" />
                                </div>
                                <div class="mb-3">
                                    <label for="txtStockQuantity" class="form-label">Stock Quantity</label>
                                    <asp:TextBox runat="server" ID="txtStockQuantity" CssClass="form-control" TextMode="Number" placeholder="0" />
                                    <asp:RangeValidator runat="server" ControlToValidate="txtStockQuantity" Type="Integer"
                                        MinimumValue="0" MaximumValue="999999" ErrorMessage="Please enter a valid quantity"
                                        CssClass="small text-danger mt-1 d-block" Display="Dynamic" />
                                </div>
                                <div class="mb-3">
                                    <label for="txtDescription" class="form-label">Description (Optional)</label>
                                    <asp:TextBox runat="server" ID="txtDescription" CssClass="form-control" TextMode="MultiLine" Rows="3" placeholder="Product description..." />
                                </div>
                                <div class="mb-4">
                                    <label for="fuProductImage" class="form-label">Product Image</label>
                                    <asp:FileUpload runat="server" ID="fuProductImage" CssClass="form-control" />
                                    <small class="text-muted">JPG, PNG or GIF (Max 2MB)</small>
                                </div>
                                <asp:Button runat="server" Text="Add Product"
                                    CssClass="btn product-add-btn mt-2"
                                    OnClick="AddProduct_Click"
                                    ID="btnAddProduct" />
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <script type="text/javascript">
        function searchProducts() {
            var searchTextBox = document.getElementById('<%= txtSearch.ClientID %>');
            if (searchTextBox && searchTextBox.value.trim() !== '') {
                var event = new Event('change');
                searchTextBox.dispatchEvent(event);
                __doPostBack('<%= txtSearch.UniqueID %>', '');
            }
        }

        // Add smooth animations
        document.addEventListener('DOMContentLoaded', function () {
            // Animate table rows
            const rows = document.querySelectorAll('#<%= gvProducts.ClientID %> tbody tr');
            rows.forEach((row, index) => {
                setTimeout(() => {
                    row.style.opacity = '0';
                    row.style.transform = 'translateY(20px)';
                    row.style.transition = 'all 0.4s ease';
                    setTimeout(() => {
                        row.style.opacity = '1';
                        row.style.transform = 'translateY(0)';
                    }, 50);
                }, index * 50);
            });

            // Add floating animation to action buttons on hover
            const actionBtns = document.querySelectorAll('.action-btn');
            actionBtns.forEach(btn => {
                btn.addEventListener('mouseenter', () => {
                    btn.style.transform = 'translateY(-3px)';
                });
                btn.addEventListener('mouseleave', () => {
                    btn.style.transform = 'translateY(0)';
                });
            });
        });

        // Show toast notification when product is added/updated
        function showToast(message, type) {
            // Implement your toast notification here
            console.log(`${type}: ${message}`);
        }
    </script>
</asp:Content>
