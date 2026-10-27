<%@ Page Title="My Account" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="Account.aspx.cs" Inherits="Real_Estate.Account" %>

<asp:Content ID="Content1" ContentPlaceHolderID="HeadContent" runat="server">

    <style>
        .account-page,
        .account-page *,
        .account-page *::before,
        .account-page *::after {
            box-sizing: border-box;
        }

        .account-page {
            min-height: 80vh;
            padding: 60px 20px 80px;
            background: #f4f2ef;
        }

        .account-container {
            max-width: 780px;
            margin: 0 auto;
        }

        /* ---------- Profile header strip ---------- */
        .profile-strip {
            display: flex;
            align-items: center;
            gap: 20px;
            background: #1c1c1c;
            border-radius: 14px 14px 0 0;
            padding: 32px 40px;
            color: #fff;
        }

        .profile-avatar {
            width: 64px;
            height: 64px;
            border-radius: 50%;
            background: #a98750;
            color: #1c1c1c;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 24px;
            font-weight: 700;
            flex-shrink: 0;
        }

        .profile-strip h1 {
            margin: 0;
            font-size: 24px;
            font-weight: 700;
        }

        .profile-strip .profile-email {
            margin-top: 4px;
            font-size: 14px;
            color: #c9c3b8;
        }

        /* ---------- Card body ---------- */
        .account-card {
            background: #ffffff;
            border-radius: 0 0 14px 14px;
            padding: 0;
            box-shadow: 0 10px 35px rgba(0, 0, 0, 0.08);
            overflow: hidden;
        }

        .account-section {
            padding: 36px 40px;
        }

        .account-section + .account-section {
            border-top: 1px solid #ededed;
        }

        .section-head {
            display: flex;
            align-items: flex-start;
            gap: 14px;
            margin-bottom: 26px;
        }

        .section-icon {
            width: 38px;
            height: 38px;
            border-radius: 10px;
            display: flex;
            align-items: center;
            justify-content: center;
            flex-shrink: 0;
            background: #f3efe8;
            color: #a98750;
        }

            .section-icon svg {
                width: 18px;
                height: 18px;
            }

        .section-icon.danger {
            background: #fcecec;
            color: #b40000;
        }

        .section-head h2 {
            margin: 0;
            font-size: 19px;
            font-weight: 700;
            color: #1c1c1c;
        }

        .section-head p {
            margin: 4px 0 0;
            color: #888;
            font-size: 13.5px;
        }

        /* ---------- Info grid (read-only fields) ---------- */
        .info-grid {
            display: grid;
            grid-template-columns: 1fr 1fr;
            gap: 20px;
        }

        .info-label {
            display: block;
            margin-bottom: 7px;
            font-size: 12px;
            font-weight: 700;
            color: #999;
            text-transform: uppercase;
            letter-spacing: 0.6px;
        }

        .info-value {
            display: block;
            width: 100%;
            min-height: 46px;
            padding: 12px 14px;
            border: 1px solid #e6e6e6;
            border-radius: 8px;
            background: #fafafa;
            color: #2a2a2a;
            font-size: 15px;
            font-weight: 500;
            word-break: break-word;
        }

        /* ---------- Form fields ---------- */
        .form-group {
            margin-bottom: 18px;
        }

            .form-group label {
                display: block;
                margin-bottom: 7px;
                color: #333;
                font-size: 13.5px;
                font-weight: 600;
            }

        .password-input {
            width: 100%;
            padding: 12px 14px;
            border: 1px solid #d8d8d8;
            border-radius: 8px;
            font-size: 15px;
            color: #333;
            background: #fff;
            outline: none;
            transition: border-color 0.2s ease, box-shadow 0.2s ease;
        }

            .password-input:focus {
                border-color: #a98750;
                box-shadow: 0 0 0 3px rgba(169, 135, 80, 0.15);
            }

        /* ---------- Buttons ---------- */
        .update-button,
        .delete-button,
        .confirm-delete-button,
        .cancel-delete-button {
            border-radius: 8px;
            font-family: inherit;
            font-weight: 700;
            font-size: 14px;
            letter-spacing: 0.3px;
            cursor: pointer;
            transition: background-color 0.2s ease, color 0.2s ease, transform 0.1s ease;
        }

            .update-button:active,
            .delete-button:active,
            .confirm-delete-button:active,
            .cancel-delete-button:active {
                transform: scale(0.98);
            }

            .update-button:focus-visible,
            .delete-button:focus-visible,
            .confirm-delete-button:focus-visible,
            .cancel-delete-button:focus-visible {
                outline: none;
                box-shadow: 0 0 0 3px rgba(169, 135, 80, 0.3);
            }

        .update-button {
            border: none;
            padding: 14px 26px;
            margin-top: 4px;
            background: #1c1c1c;
            color: #fff;
        }

            .update-button:hover {
                background: #a98750;
                color: #1c1c1c;
            }

        .delete-button {
            border: 1.5px solid #b40000;
            padding: 13px 26px;
            background: #ffffff;
            color: #b40000;
        }

            .delete-button:hover {
                background: #b40000;
                color: #ffffff;
            }

        .confirm-delete-button {
            border: none;
            padding: 13px 24px;
            margin-top: 4px;
            margin-right: 10px;
            background: #b40000;
            color: #ffffff;
        }

            .confirm-delete-button:hover {
                background: #8f0000;
            }

        .cancel-delete-button {
            border: 1px solid #cccccc;
            padding: 12px 22px;
            margin-top: 4px;
            background: #ffffff;
            color: #555555;
        }

            .cancel-delete-button:hover {
                background: #f1f1f1;
            }

        /* ---------- Messages ---------- */
        .message,
        .delete-message {
            display: block;
            padding: 12px 15px;
            margin-top: 16px;
            border-radius: 8px;
            font-size: 13.5px;
            font-weight: 600;
            line-height: 1.5;
        }

        .success-message,
        .success-delete-message {
            background: #eaf7ee;
            border: 1px solid #b8dfc3;
            color: #21733a;
        }

        .error-message,
        .error-delete-message {
            background: #fff0f0;
            border: 1px solid #e2aaaa;
            color: #a00000;
        }

        /* ---------- Delete confirm box ---------- */
        .delete-confirm-box {
            margin-top: 22px;
            padding: 24px;
            background: #fff7f7;
            border: 1px solid #e3b1b1;
            border-radius: 10px;
        }

        .delete-warning {
            margin-bottom: 20px;
        }

            .delete-warning h3 {
                margin: 0 0 6px 0;
                font-size: 16px;
                font-weight: 700;
                color: #9b0000;
            }

            .delete-warning p {
                margin: 0;
                color: #777;
                font-size: 13.5px;
                line-height: 1.6;
            }

        .delete-actions {
            display: flex;
            flex-wrap: wrap;
            align-items: center;
        }

        /* ---------- Responsive ---------- */
        @media (max-width: 600px) {
            .account-page {
                padding: 30px 14px 60px;
            }

            .profile-strip {
                padding: 26px 24px;
            }

            .account-section {
                padding: 26px 24px;
            }

            .info-grid {
                grid-template-columns: 1fr;
            }

            .profile-strip h1 {
                font-size: 20px;
            }

            .update-button,
            .delete-button {
                width: 100%;
            }
        }

        @media (prefers-reduced-motion: reduce) {
            .password-input,
            .update-button,
            .delete-button,
            .confirm-delete-button,
            .cancel-delete-button {
                transition: none;
            }
        }
    </style>

    <script type="text/javascript">

        function confirmDelete() {
            return window.confirm("Are you sure you want to permanently delete your account?\n\nThis action cannot be undone.");
        }

    </script>

</asp:Content>


<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">

    <section class="account-page" aria-labelledby="accountHeading">

        <div class="account-container">

            <div class="profile-strip">
                <div class="profile-avatar" id="profileAvatar">?</div>
                <div>
                    <h1 id="accountHeading">My Account</h1>
                    <div class="profile-email">Manage your information and password</div>
                </div>
            </div>

            <div class="account-card">

                <!-- USER INFO -->
                <div class="account-section">

                    <div class="section-head">
                        <div class="section-icon">
                            <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><path d="M20 21v-2a4 4 0 0 0-4-4H8a4 4 0 0 0-4 4v2"></path><circle cx="12" cy="7" r="4"></circle></svg>
                        </div>
                        <div>
                            <h2>Profile Information</h2>
                            <p>Your account details on file</p>
                        </div>
                    </div>

                    <div class="info-grid">
                        <div class="info-group">
                            <span class="info-label">Full Name</span>
                            <asp:Label ID="lblFirstName" runat="server" CssClass="info-value"></asp:Label>
                        </div>

                        <div class="info-group">
                            <span class="info-label">Email</span>
                            <asp:Label ID="lblEmail" runat="server" CssClass="info-value"></asp:Label>
                        </div>
                    </div>

                </div>

                <!-- CHANGE PASSWORD -->
                <div class="account-section">

                    <div class="section-head">
                        <div class="section-icon">
                            <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><rect x="3" y="11" width="18" height="11" rx="2"></rect><path d="M7 11V7a5 5 0 0 1 10 0v4"></path></svg>
                        </div>
                        <div>
                            <h2>Change Password</h2>
                            <p>Update your password to keep your account secure</p>
                        </div>
                    </div>

                    <div class="form-group">
                        <label for="<%= txtCurrentPassword.ClientID %>">Current Password</label>
                        <asp:TextBox
                            ID="txtCurrentPassword"
                            runat="server"
                            CssClass="password-input"
                            TextMode="Password"
                            MaxLength="100"
                            autocomplete="current-password">
                        </asp:TextBox>
                    </div>

                    <div class="form-group">
                        <label for="<%= txtNewPassword.ClientID %>">New Password</label>
                        <asp:TextBox
                            ID="txtNewPassword"
                            runat="server"
                            CssClass="password-input"
                            TextMode="Password"
                            MaxLength="100"
                            autocomplete="new-password">
                        </asp:TextBox>
                    </div>

                    <div class="form-group">
                        <label for="<%= txtConfirmPassword.ClientID %>">Confirm New Password</label>
                        <asp:TextBox
                            ID="txtConfirmPassword"
                            runat="server"
                            CssClass="password-input"
                            TextMode="Password"
                            MaxLength="100"
                            autocomplete="new-password">
                        </asp:TextBox>
                    </div>

                    <asp:Button
                        ID="btnUpdatePassword"
                        runat="server"
                        Text="UPDATE PASSWORD"
                        CssClass="update-button"
                        OnClick="btnUpdatePassword_Click"
                        CausesValidation="false"
                        UseSubmitBehavior="false" />

                    <asp:Label
                        ID="lblMessage"
                        runat="server"
                        CssClass="message"
                        Visible="false"
                        role="alert"
                        aria-live="polite">
                    </asp:Label>

                </div>

                <!-- DELETE ACCOUNT -->
                <div class="account-section">

                    <div class="section-head">
                        <div class="section-icon danger">
                            <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><polyline points="3 6 5 6 21 6"></polyline><path d="M19 6l-1 14a2 2 0 0 1-2 2H8a2 2 0 0 1-2-2L5 6"></path><path d="M10 11v6"></path><path d="M14 11v6"></path><path d="M9 6V4a1 1 0 0 1 1-1h4a1 1 0 0 1 1 1v2"></path></svg>
                        </div>
                        <div>
                            <h2>Delete Account</h2>
                            <p>Permanently delete your account and all associated information</p>
                        </div>
                    </div>

                    <asp:Button
                        ID="btnShowDelete"
                        runat="server"
                        Text="DELETE ACCOUNT"
                        CssClass="delete-button"
                        OnClick="btnShowDelete_Click"
                        CausesValidation="false" />

                    <asp:Panel
                        ID="pnlDeleteConfirm"
                        runat="server"
                        Visible="false"
                        CssClass="delete-confirm-box">

                        <div class="delete-warning">
                            <h3>This cannot be undone</h3>
                            <p>
                                Deleting your account permanently removes your profile
                                and all associated information from our database.
                            </p>
                        </div>

                        <div class="form-group">
                            <label for="<%= txtDeletePassword.ClientID %>">Enter your current password to confirm</label>
                            <asp:TextBox
                                ID="txtDeletePassword"
                                runat="server"
                                TextMode="Password"
                                CssClass="password-input"
                                MaxLength="100"
                                autocomplete="current-password">
                            </asp:TextBox>
                        </div>

                        <div class="delete-actions">
                            <asp:Button
                                ID="btnConfirmDelete"
                                runat="server"
                                Text="DELETE MY ACCOUNT"
                                CssClass="confirm-delete-button"
                                OnClick="btnConfirmDelete_Click"
                                CausesValidation="false"
                                OnClientClick="return confirmDelete();" />

                            <asp:Button
                                ID="btnCancelDelete"
                                runat="server"
                                Text="CANCEL"
                                CssClass="cancel-delete-button"
                                OnClick="btnCancelDelete_Click"
                                CausesValidation="false" />
                        </div>

                        <asp:Label
                            ID="lblDeleteMessage"
                            runat="server"
                            CssClass="delete-message"
                            Visible="false"
                            role="alert"
                            aria-live="polite">
                        </asp:Label>

                    </asp:Panel>

                </div>

            </div>

        </div>

    </section>

    <script type="text/javascript">
        (function () {
            var nameLabel = document.getElementById('<%= lblFirstName.ClientID %>');
            var avatar = document.getElementById('profileAvatar');
            if (nameLabel && avatar) {
                var name = nameLabel.innerText.trim();
                avatar.innerText = name.length > 0 ? name.charAt(0).toUpperCase() : "?";
            }
        })();
    </script>

</asp:Content>