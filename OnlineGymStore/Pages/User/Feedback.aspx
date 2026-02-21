<%@ Page Title="" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="Feedback.aspx.cs" Inherits="OnlineGymStore.Pages.User.Feedback" %>

<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">
    <div class="container" style="margin-top: 20px; margin-bottom: 20px;">
        <div class="row">
            <div class="col-md-8 offset-md-2">
                <div class="card" style="background-color: #f8f9fa; border: 1px solid #212529;">
                    <div class="card-header" style="background-color: #212529; color: #ffffff;">
                        <h3>Submit Your Feedback</h3>
                    </div>
                    <div class="card-body">
                        <div class="form-group">
                            <asp:Label ID="lblSubject" runat="server" Text="Subject:" AssociatedControlID="txtSubject" CssClass="form-label" />
                            <asp:TextBox ID="txtSubject" runat="server" CssClass="form-control" placeholder="Enter subject" required="required" />
                        </div>
                        <div class="form-group mt-3">
                            <asp:Label ID="lblFeedbackType" runat="server" Text="Feedback Type:" AssociatedControlID="ddlFeedbackType" CssClass="form-label" />
                            <asp:DropDownList ID="ddlFeedbackType" runat="server" CssClass="form-control">
                                <asp:ListItem Text="Suggestion" Value="Suggestion" />
                                <asp:ListItem Text="Complaint" Value="Complaint" />
                                <asp:ListItem Text="Question" Value="Question" />
                                <asp:ListItem Text="Compliment" Value="Compliment" />
                                <asp:ListItem Text="Other" Value="Other" />
                            </asp:DropDownList>
                        </div>
                        <div class="form-group mt-3">
                            <asp:Label ID="lblRating" runat="server" Text="Rating:" AssociatedControlID="rblRating" CssClass="form-label" />
                            <asp:RadioButtonList ID="rblRating" runat="server" RepeatDirection="Horizontal" CssClass="form-check-inline d-flex align-items-center">
                                <asp:ListItem Text="1" Value="1" />
                                <asp:ListItem Text="2" Value="2" />
                                <asp:ListItem Text="3" Value="3" />
                                <asp:ListItem Text="4" Value="4" />
                                <asp:ListItem Text="5" Value="5" />
                            </asp:RadioButtonList>
                        </div>
                        <div class="form-group mt-3">
                            <asp:Label ID="lblMessage" runat="server" Text="Message:" AssociatedControlID="txtMessage" CssClass="form-label" />
                            <asp:TextBox ID="txtMessage" runat="server" TextMode="MultiLine" Rows="5" CssClass="form-control" placeholder="Please enter your feedback here" required="required" />
                        </div>
                        <div class="form-group mt-4">
                            <asp:Button ID="btnSubmitFeedback" runat="server" Text="Submit Feedback" CssClass="btn" Style="background-color: #212529; color: #ffffff;" OnClick="btnSubmitFeedback_Click" />
                        </div>
                        <asp:Label ID="Label1" runat="server" CssClass="alert alert-success mt-3" Visible="false"></asp:Label>
                    </div>
                </div>
            </div>
        </div>
    </div>
</asp:Content>
