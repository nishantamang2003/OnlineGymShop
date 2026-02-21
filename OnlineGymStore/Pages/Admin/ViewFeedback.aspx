<%@ Page Title="" Language="C#" MasterPageFile="~/Pages/Admin/Admin.Master" AutoEventWireup="true" CodeBehind="ViewFeedback.aspx.cs" Inherits="OnlineGymStore.Pages.Admin.ViewFeedback" %>

<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">
    <style>
    body {
        font-family: 'Segoe UI', sans-serif;
        background-color: #f4f6fa;
        color: #333;
        margin: 0;
        padding: 0;
    }

    /* Container and Card Styling */
    .container {
        padding: 40px 20px;
    }

    .card {
        border: none;
        border-radius: 12px;
        box-shadow: 0 8px 20px rgba(0, 0, 0, 0.03);
        background-color: #ffffff;
        margin-bottom: 30px; /* Added margin between cards */
    }

    .card-header {
        background-color: #f0f2f5;
        border-bottom: 1px solid #dee2e6;
        color: #6c757d;
        font-weight: 600;
        font-size: 1.3rem;
        padding: 20px;
        border-top-left-radius: 12px;
        border-top-right-radius: 12px;
        margin-bottom: 15px; /* Added spacing below card header */
    }

    /* Input Fields */
    .form-control {
        border-radius: 8px;
        border: 1px solid #d1d5db;
        padding: 12px;
        font-size: 0.95rem;
        background-color: #ffffff;
        transition: border-color 0.3s ease-in-out;
        margin-bottom: 15px; /* Added bottom margin between input fields */
    }

    .form-control:focus {
        border-color: #3b82f6;
        box-shadow: 0 0 0 2px rgba(59, 130, 246, 0.2);
        outline: none;
    }

    /* Buttons */
    .btn {
        border-radius: 8px;
        font-weight: 600;
        padding: 10px 20px;
        font-size: 0.95rem;
        transition: all 0.3s ease;
        margin-right: 10px; /* Added spacing between buttons */
        margin-bottom: 15px; /* Added margin below buttons */
    }

    .btn:hover {
        opacity: 0.9;
    }

    .btn-primary,
    .btn-dark {
        background-color: #6c757d;
        border: none;
        color: #ffffff;
    }

    .btn-primary:hover,
    .btn-dark:hover {
        background-color: #5c636a;
    }

    .btn-danger {
        background-color: #ef4444;
        color: #fff;
        border: none;
    }

    .btn-danger:hover {
        background-color: #dc2626;
    }

    /* Table Styles */
    .table {
        margin-top: 25px;
        border-radius: 10px;
        overflow: hidden;
        margin-bottom: 30px; /* Added margin at bottom of table */
    }

    .table th,
    .table td {
        vertical-align: middle !important;
        text-align: center;
        font-size: 0.95rem;
        padding: 15px; /* Added padding to table cells */
    }

    .table th {
        background-color: #f3f4f6;
        font-weight: 600;
        padding-top: 12px;
        padding-bottom: 12px;
    }

    .table td {
        background-color: #ffffff;
    }

    .table-striped tbody tr:nth-of-type(odd) {
        background-color: #f9fafb;
    }

    .table-bordered th,
    .table-bordered td {
        border: 1px solid #e5e7eb;
    }

    /* Modal Styling */
    .modal-content {
        border-radius: 12px;
        border: none;
        padding: 20px;
    }

    .modal-header,
    .modal-footer {
        background-color: #f9fafb;
        border: none;
        color: #6c757d;
        padding: 15px; /* Added padding to modal header and footer */
    }

    /* Pagination */
    .pagination-container {
        margin-top: 20px;
        text-align: center;
        margin-bottom: 30px; /* Added bottom margin to pagination */
    }

    /* Link Buttons */
    a.btn-sm {
        padding: 6px 12px;
        border-radius: 6px;
        font-size: 0.85rem;
        text-decoration: none;
    }

    a.btn-sm.edit {
        background-color: #3b82f6;
        color: white;
    }

    a.btn-sm.edit:hover {
        background-color: #2563eb;
    }

    a.btn-sm.delete {
        background-color: #ef4444;
        color: white;
    }

    a.btn-sm.delete:hover {
        background-color: #dc2626;
    }

    /* Checkbox and Filter Buttons */
    input[type="checkbox"] {
        transform: scale(1.2);
        accent-color: #2563eb;
        margin-right: 10px; /* Added margin to checkbox */
    }

    /* Responsive Adjustments */
    @media (max-width: 768px) {
        .input-group {
            flex-direction: column;
        }

        .input-group .form-control {
            border-radius: 6px !important;
            margin-bottom: 10px;
        }

        .input-group .btn {
            border-radius: 6px !important;
            margin-bottom: 10px; /* Added margin below buttons in input group */
        }

        .card-header {
            padding: 15px;
        }

        .container {
            padding: 20px;
        }
    }

</style>

    <div class="container" style="margin-top: 20px; margin-bottom: 20px;">
        <div class="row">
            <div class="col-md-12">
                <div class="card" style="background-color: #f8f9fa; border: 1px solid #212529;">
                    <div class="card-header" style="background-color: #212529; color: #ffffff;">
                        <h3>Feedback Management</h3>
                    </div>
                    <div class="card-body">
                        <div class="mb-3">
                            <div class="row">
                                <div class="col-md-3">
                                    <asp:DropDownList ID="ddlFilterType" runat="server" CssClass="form-control" AutoPostBack="true" OnSelectedIndexChanged="ApplyFilters">
                                        <asp:ListItem Text="All Types" Value="" />
                                        <asp:ListItem Text="Suggestion" Value="Suggestion" />
                                        <asp:ListItem Text="Complaint" Value="Complaint" />
                                        <asp:ListItem Text="Question" Value="Question" />
                                        <asp:ListItem Text="Compliment" Value="Compliment" />
                                        <asp:ListItem Text="Other" Value="Other" />
                                    </asp:DropDownList>
                                </div>
                                <div class="col-md-3">
                                    <asp:DropDownList ID="ddlFilterRating" runat="server" CssClass="form-control" AutoPostBack="true" OnSelectedIndexChanged="ApplyFilters">
                                        <asp:ListItem Text="All Ratings" Value="0" />
                                        <asp:ListItem Text="1 Star" Value="1" />
                                        <asp:ListItem Text="2 Stars" Value="2" />
                                        <asp:ListItem Text="3 Stars" Value="3" />
                                        <asp:ListItem Text="4 Stars" Value="4" />
                                        <asp:ListItem Text="5 Stars" Value="5" />
                                    </asp:DropDownList>
                                </div>
                                <div class="col-md-4">
                                    <div class="input-group">
                                        <asp:TextBox ID="txtSearch" runat="server" CssClass="form-control" placeholder="Search by subject or content..." />
                                        <asp:Button ID="btnSearch" runat="server" Text="Search" CssClass="btn" Style="background-color: #212529; color: #ffffff;" OnClick="btnSearch_Click" />
                                    </div>
                                </div>
                                <div class="col-md-2">
                                    <asp:Button ID="btnClearFilters" runat="server" Text="Clear Filters" CssClass="btn" Style="background-color: #212529; color: #ffffff;" OnClick="btnClearFilters_Click" />
                                </div>
                            </div>
                        </div>

                        <asp:GridView ID="gvFeedback" runat="server" AutoGenerateColumns="False"
                            CssClass="table table-striped table-bordered" AllowPaging="True"
                            PageSize="10" OnPageIndexChanging="gvFeedback_PageIndexChanging"
                            OnRowCommand="gvFeedback_RowCommand" DataKeyNames="FeedbackID">
                            <Columns>
                                <asp:BoundField DataField="FeedbackID" HeaderText="ID" />
                                <asp:BoundField DataField="UserName" HeaderText="User" />
                                <asp:BoundField DataField="Subject" HeaderText="Subject" />
                                <asp:BoundField DataField="FeedbackType" HeaderText="Type" />
                                <asp:BoundField DataField="Rating" HeaderText="Rating" />
                                <asp:BoundField DataField="SubmissionDate" HeaderText="Date" DataFormatString="{0:MM/dd/yyyy}" />
                                <asp:TemplateField HeaderText="Message">
                                    <ItemTemplate>
                                        <asp:LinkButton ID="lnkViewMessage" runat="server" CommandName="ViewMessage" CommandArgument='<%# Eval("FeedbackID") %>' Text="View" />
                                    </ItemTemplate>
                                </asp:TemplateField>
                                <asp:TemplateField HeaderText="Actions">
                                    <ItemTemplate>
                                        <asp:LinkButton ID="lnkDelete" runat="server" CommandName="DeleteFeedback" CommandArgument='<%# Eval("FeedbackID") %>'
                                            OnClientClick="return confirm('Are you sure you want to delete this feedback?');"
                                            CssClass="btn btn-sm" Style="background-color: #212529; color: #ffffff;">
                                            Delete
                                        </asp:LinkButton>
                                    </ItemTemplate>
                                </asp:TemplateField>
                            </Columns>
                            <PagerStyle CssClass="pagination-container" HorizontalAlign="Center" />
                        </asp:GridView>

                        <!-- Feedback Details Modal -->
                        <div class="modal fade" id="feedbackModal" tabindex="-1" role="dialog" aria-labelledby="feedbackModalLabel" aria-hidden="true">
                            <div class="modal-dialog" role="document">
                                <div class="modal-content">
                                    <div class="modal-header" style="background-color: #212529; color: #ffffff;">
                                        <h5 class="modal-title" id="feedbackModalLabel">Feedback Details</h5>
                                        <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                                            <span aria-hidden="true">&times;</span>
                                        </button>
                                    </div>
                                    <div class="modal-body">
                                        <asp:Literal ID="litFeedbackDetails" runat="server"></asp:Literal>
                                    </div>
                                    <div class="modal-footer">
                                        <button type="button" class="btn" style="background-color: #212529; color: #ffffff;" data-dismiss="modal">Close</button>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <script type="text/javascript">
        function showFeedbackModal() {
            $('#feedbackModal').modal('show');
        }
    </script>
</asp:Content>
