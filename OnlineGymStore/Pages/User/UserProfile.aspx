<%@ Page Title="" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="UserProfile.aspx.cs" Inherits="OnlineGymStore.Pages.User.UserProfile" %>


<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">
    <div class="container my-5">
        <div class="row">
            <div class="col-md-8 offset-md-2">
                <div class="card border-dark">
                    <div class="card-header bg-dark text-white">
                        <h3 class="mb-0">My Profile</h3>
                    </div>
                    <div class="card-body">
                        <!-- Profile Information Section -->
                        <div class="profile-section mb-5">
                            <h4 class="mb-4 text-dark">Personal Information</h4>
                            <hr class="bg-dark" />

                            <asp:Label ID="lblProfileMessage" runat="server" Visible="false" CssClass="d-block mb-3"></asp:Label>

                            <div class="form-group row mb-3">
                                <label for="txtFullName" class="col-sm-3 col-form-label">Full Name</label>
                                <div class="col-sm-9">
                                    <asp:TextBox ID="txtFullName" runat="server" CssClass="form-control border-dark" placeholder="Your Full Name"></asp:TextBox>
                                    <asp:RequiredFieldValidator ID="rfvFullName" runat="server"
                                        ControlToValidate="txtFullName"
                                        ValidationGroup="ProfileGroup"
                                        CssClass="text-danger"
                                        ErrorMessage="Full name is required."
                                        Display="Dynamic">
                                    </asp:RequiredFieldValidator>
                                </div>
                            </div>

                            <div class="form-group row mb-3">
                                <label for="txtEmail" class="col-sm-3 col-form-label">Email</label>
                                <div class="col-sm-9">
                                    <asp:TextBox ID="txtEmail" runat="server" CssClass="form-control border-dark" placeholder="Your Email" ReadOnly="true"></asp:TextBox>
                                </div>
                            </div>



                            <div class="form-group row mt-4">
                                <div class="col-sm-9 offset-sm-3">
                                    <asp:Button ID="btnUpdateProfile" runat="server" Text="Update Profile"
                                        CssClass="btn btn-dark"
                                        ValidationGroup="ProfileGroup"
                                        OnClick="btnUpdateProfile_Click" />
                                </div>
                            </div>
                        </div>

                        <!-- Password Change Section -->
                        <div class="password-section">
                            <h4 class="mb-4 text-dark">Change Password</h4>
                            <hr class="bg-dark" />

                            <asp:Label ID="lblPasswordMessage" runat="server" Visible="false" CssClass="d-block mb-3"></asp:Label>

                            <div class="form-group row mb-3">
                                <label for="txtCurrentPassword" class="col-sm-3 col-form-label">Current Password</label>
                                <div class="col-sm-9">
                                    <asp:TextBox ID="txtCurrentPassword" runat="server" TextMode="Password" CssClass="form-control border-dark" placeholder="Enter Current Password"></asp:TextBox>
                                    <asp:RequiredFieldValidator ID="rfvCurrentPassword" runat="server"
                                        ControlToValidate="txtCurrentPassword"
                                        ValidationGroup="PasswordGroup"
                                        CssClass="text-danger"
                                        ErrorMessage="Current password is required."
                                        Display="Dynamic">
                                    </asp:RequiredFieldValidator>
                                </div>
                            </div>

                            <div class="form-group row mb-3">
                                <label for="txtNewPassword" class="col-sm-3 col-form-label">New Password</label>
                                <div class="col-sm-9">
                                    <asp:TextBox ID="txtNewPassword" runat="server" TextMode="Password" CssClass="form-control border-dark" placeholder="Enter New Password"></asp:TextBox>
                                    <asp:RequiredFieldValidator ID="rfvNewPassword" runat="server"
                                        ControlToValidate="txtNewPassword"
                                        ValidationGroup="PasswordGroup"
                                        CssClass="text-danger"
                                        ErrorMessage="New password is required."
                                        Display="Dynamic">
                                    </asp:RequiredFieldValidator>
                                </div>
                            </div>

                            <div class="form-group row mb-3">
                                <label for="txtConfirmNewPassword" class="col-sm-3 col-form-label">Confirm Password</label>
                                <div class="col-sm-9">
                                    <asp:TextBox ID="txtConfirmNewPassword" runat="server" TextMode="Password" CssClass="form-control border-dark" placeholder="Confirm New Password"></asp:TextBox>
                                    <asp:RequiredFieldValidator ID="rfvConfirmNewPassword" runat="server"
                                        ControlToValidate="txtConfirmNewPassword"
                                        ValidationGroup="PasswordGroup"
                                        CssClass="text-danger"
                                        ErrorMessage="Confirm password is required."
                                        Display="Dynamic">
                                    </asp:RequiredFieldValidator>
                                    <asp:CompareValidator ID="cvPasswords" runat="server"
                                        ControlToValidate="txtConfirmNewPassword"
                                        ControlToCompare="txtNewPassword"
                                        ValidationGroup="PasswordGroup"
                                        CssClass="text-danger"
                                        ErrorMessage="Passwords do not match."
                                        Display="Dynamic">
                                    </asp:CompareValidator>
                                </div>
                            </div>

                            <div class="form-group row mt-4">
                                <div class="col-sm-9 offset-sm-3">
                                    <asp:Button ID="btnChangePassword" runat="server" Text="Change Password"
                                        CssClass="btn btn-dark"
                                        ValidationGroup="PasswordGroup"
                                        OnClick="btnChangePassword_Click" />
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
</asp:Content>
