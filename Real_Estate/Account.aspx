<%@ Page Title="My Account" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="Account.aspx.cs" Inherits="Real_Estate.Account" %>

<asp:Content ID="Content1" ContentPlaceHolderID="HeadContent" runat="server">

    <style>
        .account-page {
            min-height: 75vh;
            padding: 70px 20px;
            background: #f8f8f8;
        }

        .account-container {
            max-width: 650px;
            margin: 0 auto;
        }

        .account-card {
            background: #ffffff;
            border-radius: 14px;
            padding: 40px;
            box-shadow: 0 10px 35px rgba(0, 0, 0, 0.08);
        }

        .account-header {
            text-align: center;
            margin-bottom: 35px;
        }

            .account-header h1 {
                margin: 0;
                font-size: 32px;
                font-weight: 600;
                color: #222222;
            }

            .account-header p {
                margin-top: 8px;
                color: #777777;
                font-size: 15px;
            }

        .user-info {
            margin-bottom: 30px;
        }

        .info-group {
            margin-bottom: 20px;
        }

        .info-label {
            display: block;
            margin-bottom: 8px;
            font-size: 13px;
            font-weight: 600;
            color: #777777;
            text-transform: uppercase;
            letter-spacing: 0.5px;
        }

        .info-value {
            display: block;
            width: 100%;
            min-height: 18px;
            box-sizing: border-box;
            padding: 13px 15px;
            border: 1px solid #dddddd;
            border-radius: 8px;
            background: #f7f7f7;
            color: #333333;
            font-size: 15px;
        }

        .divider {
            height: 1px;
            background: #e5e5e5;
            margin: 30px 0;
        }

        .password-title {
            margin-bottom: 22px;
        }

            .password-title h2 {
                margin: 0;
                font-size: 22px;
                font-weight: 600;
                color: #222222;
            }

            .password-title p {
                margin: 7px 0 0;
                color: #888888;
                font-size: 14px;
            }

        .form-group {
            margin-bottom: 20px;
        }

            .form-group label {
                display: block;
                margin-bottom: 8px;
                color: #333333;
                font-size: 14px;
                font-weight: 500;
            }

        .password-input {
            width: 100%;
            box-sizing: border-box;
            padding: 13px 15px;
            border: 1px solid #d8d8d8;
            border-radius: 8px;
            font-size: 15px;
            color: #333333;
            background: #ffffff;
            outline: none;
        }

            .password-input:focus {
                border-color: #b40000;
            }

        .update-button {
            width: 100%;
            border: none;
            border-radius: 8px;
            padding: 14px 20px;
            margin-top: 5px;
            background: #b40000;
            color: #ffffff;
            font-size: 15px;
            font-weight: 600;
            cursor: pointer;
        }

            .update-button:hover {
                background: #8f0000;
            }

        .message {
            display: block;
            width: 100%;
            box-sizing: border-box;
            padding: 12px 15px;
            margin-top: 18px;
            border-radius: 7px;
            text-align: center;
            font-size: 14px;
            font-weight: 500;
        }

        .success-message {
            background: #eaf7ee;
            border: 1px solid #b8dfc3;
            color: #21733a;
        }

        .error-message {
            background: #fff0f0;
            border: 1px solid #e2aaaa;
            color: #a00000;
        }

        .delete-section {
            margin-top: 5px;
        }

        .delete-title h2 {
            margin: 0;
            font-size: 22px;
            font-weight: 600;
            color: #222222;
        }

        .delete-title p {
            margin: 7px 0 20px;
            color: #888888;
            font-size: 14px;
            line-height: 1.5;
        }

        .delete-button {
            width: 100%;
            border: 1px solid #b40000;
            border-radius: 8px;
            padding: 14px 20px;
            background: #ffffff;
            color: #b40000;
            font-size: 15px;
            font-weight: 600;
            cursor: pointer;
        }

            .delete-button:hover {
                background: #b40000;
                color: #ffffff;
            }

        .delete-message {
            display: block;
            width: 100%;
            box-sizing: border-box;
            padding: 12px 15px;
            margin-top: 18px;
            border-radius: 7px;
            text-align: center;
            font-size: 14px;
        }

        @media (max-width: 600px) {

            .account-page {
                padding: 40px 15px;
            }

            .account-card {
                padding: 25px 20px;
            }

            .account-header h1 {
                font-size: 27px;
            }
        }

        .delete-confirm-box {
            margin-top: 20px;
            padding: 25px;
            background: #fff7f7;
            border: 1px solid #e3b1b1;
            border-radius: 10px;
        }

        .delete-warning {
            margin-bottom: 22px;
        }

            .delete-warning h3 {
                margin: 0 0 8px 0;
                font-size: 18px;
                font-weight: 600;
                color: #9b0000;
            }

            .delete-warning p {
                margin: 0;
                color: #777777;
                font-size: 14px;
                line-height: 1.6;
            }

        .confirm-delete-button {
            width: 100%;
            border: none;
            border-radius: 8px;
            padding: 14px 20px;
            background: #b40000;
            color: #ffffff;
            font-size: 14px;
            font-weight: 600;
            cursor: pointer;
            margin-top: 5px;
        }

            .confirm-delete-button:hover {
                background: #8f0000;
            }

        .cancel-delete-button {
            width: 100%;
            border: 1px solid #cccccc;
            border-radius: 8px;
            padding: 13px 20px;
            background: #ffffff;
            color: #555555;
            font-size: 14px;
            font-weight: 600;
            cursor: pointer;
            margin-top: 10px;
        }

            .cancel-delete-button:hover {
                background: #f1f1f1;
            }

        .delete-message {
            display: block;
            width: 100%;
            box-sizing: border-box;
            padding: 12px 15px;
            margin-top: 18px;
            border-radius: 7px;
            text-align: center;
            font-size: 14px;
            font-weight: 500;
        }

        .success-delete-message {
            background: #eaf7ee;
            border: 1px solid #b8dfc3;
            color: #21733a;
        }

        .error-delete-message {
            background: #fff0f0;
            border: 1px solid #e2aaaa;
            color: #a00000;
        }
    </style>

    <script type="text/javascript">

        function confirmDelete() {

            return window.confirm("Are you sure you want to permanently delete your account?\n\nThis action cannot be undone");
        }
    </script>

</asp:Content>


<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">

    <section class="account-page">

        <div class="account-container">

            <div class="account-card">

                <div class="account-header">

                    <h1>My Account</h1>

                    <p>
                        Manage your account information and password
                    </p>

                </div>

                <div class="user-info">

                    <div class="info-group">

                        <span class="info-label">First Name
                        </span>

                        <asp:Label
                            ID="lblFirstName"
                            runat="server"
                            CssClass="info-value">
                        </asp:Label>

                    </div>


                    <div class="info-group">

                        <span class="info-label">Email
                        </span>

                        <asp:Label
                            ID="lblEmail"
                            runat="server"
                            CssClass="info-value">
                        </asp:Label>

                    </div>

                </div>


                <div class="divider"></div>


                <!-- CHANGE PASSWORD -->

                <div class="password-section">

                    <div class="password-title">

                        <h2>Change Password</h2>

                        <p>
                            Update your password to keep your account secure.
                        </p>

                    </div>


                    <!-- CURRENT PASSWORD -->

                    <div class="form-group">

                        <label>
                            Current Password
                        </label>

                        <asp:TextBox
                            ID="txtCurrentPassword"
                            runat="server"
                            CssClass="password-input"
                            TextMode="Password">
                        </asp:TextBox>

                    </div>


                    <!-- NEW PASSWORD -->

                    <div class="form-group">

                        <label>
                            New Password
                        </label>

                        <asp:TextBox
                            ID="txtNewPassword"
                            runat="server"
                            CssClass="password-input"
                            TextMode="Password">
                        </asp:TextBox>

                    </div>


                    <!-- CONFIRM PASSWORD -->

                    <div class="form-group">

                        <label>
                            Confirm New Password
                        </label>

                        <asp:TextBox
                            ID="txtConfirmPassword"
                            runat="server"
                            CssClass="password-input"
                            TextMode="Password">
                        </asp:TextBox>

                    </div>


                    <!-- UPDATE -->

                    <asp:Button
                        ID="btnUpdatePassword"
                        runat="server"
                        Text="UPDATE PASSWORD"
                        CssClass="update-button"
                        OnClick="btnUpdatePassword_Click"
                        CausesValidation="false"
                        UseSubmitBehavior="false" />


                    <!-- PASSWORD MESSAGE -->

                    <asp:Label
                        ID="lblMessage"
                        runat="server"
                        CssClass="message"
                        Visible="false">
                    </asp:Label>

                </div>


                <!-- DELETE ACCOUNT -->

                <div class="delete-section">

                    <div class="divider"></div>

                    <div class="delete-title">

                        <h2>Delete Account</h2>

                        <p>
                            Permanently delete your account and all associated information.
            This action cannot be undone.
                        </p>

                    </div>


                    <!-- FIRST DELETE BUTTON -->

                    <asp:Button
                        ID="btnShowDelete"
                        runat="server"
                        Text="DELETE ACCOUNT"
                        CssClass="delete-button"
                        OnClick="btnShowDelete_Click"
                        CausesValidation="false" />


                    <!-- DELETE CONFIRMATION AREA -->

                    <asp:Panel
                        ID="pnlDeleteConfirm"
                        runat="server"
                        Visible="false"
                        CssClass="delete-confirm-box">

                        <div class="delete-warning">

                            <h3>Are you sure you want to delete your account?</h3>

                            <p>
                                This will permanently delete your account and your
                information from our database.
                            </p>

                        </div>


                        <!-- CURRENT PASSWORD -->

                        <div class="form-group">

                            <label>
                                Enter your current password
                            </label>

                            <asp:TextBox
                                ID="txtDeletePassword"
                                runat="server"
                                TextMode="Password"
                                CssClass="password-input">
                            </asp:TextBox>

                        </div>


                        <!-- CONFIRM DELETE -->

                        <asp:Button
                            ID="btnConfirmDelete"
                            runat="server"
                            Text="DELETE MY ACCOUNT"
                            CssClass="confirm-delete-button"
                            OnClick="btnConfirmDelete_Click"
                            CausesValidation="false" />


                        <!-- CANCEL -->

                        <asp:Button
                            ID="btnCancelDelete"
                            runat="server"
                            Text="CANCEL"
                            CssClass="cancel-delete-button"
                            OnClick="btnCancelDelete_Click"
                            CausesValidation="false" />


                        <!-- DELETE MESSAGE -->

                        <asp:Label
                            ID="lblDeleteMessage"
                            runat="server"
                            CssClass="delete-message"
                            Visible="false">
                        </asp:Label>

                    </asp:Panel>

                </div>

            </div>

        </div>

    </section>

</asp:Content>
