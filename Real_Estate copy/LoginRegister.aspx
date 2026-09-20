<%@ Page Title="Authentication" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="LoginRegister.aspx.cs" Inherits="Real_Estate.LoginRegister" %>

<asp:Content ID="Content1" ContentPlaceHolderID="HeadContent" runat="server">
    <style>
        .auth-wrapper {
            position: relative;
            width: 100%;
        }

        .auth-form {
            opacity: 0;
            visibility: hidden;
            transform: translateY(15px);
            transition: opacity 0.4s ease, transform 0.4s ease, visibility 0.4s;
            position: absolute;
            top: 0;
            left: 0;
            width: 100%;
            z-index: 1;
        }

            .auth-form.active {
                opacity: 1;
                visibility: visible;
                transform: translateY(0);
                position: relative;
                z-index: 2;
            }

        .auth-toggle {
            text-align: center;
            margin-top: 1.5rem;
            font-size: 0.95rem;
            color: var(--text-secondary);
        }

            .auth-toggle a {
                color: var(--accent);
                cursor: pointer;
                text-decoration: none;
                font-weight: 600;
                transition: opacity 0.2s ease;
            }

                .auth-toggle a:hover {
                    opacity: 0.8;
                    text-decoration: underline;
                }

        .auth-card {
            max-width: 600px;
            margin: 0 auto;
            background-color: var(--card-bg);
            border: 1px solid var(--border);
            border-radius: var(--radius-md);
            padding: 3rem;
            box-shadow: var(--card-shadow);
        }

        .auth-message {
            display: none;
            margin-top: 1.5rem;
            padding: 1rem 1.25rem;
            background-color: var(--bg-secondary);
            border-left: 4px solid var(--accent);
            border-radius: var(--radius-sm);
            text-align: left;
            line-height: 1.5;
        }

            .auth-message.visible {
                display: block;
            }

            .auth-message.visible {
                display: block;
            }

        @media (max-width: 600px) {
            .auth-card {
                padding: 2rem 1.25rem;
            }

            .auth-form h2 {
                font-size: 1.65rem !important;
            }
        }
    </style>
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">
    <section class="section-padding">
        <div class="container">
            <div class="reveal auth-card">

                <div class="auth-wrapper">

                    <!-- LOGIN SECTION -->
                    <div id="loginSection" class="auth-form active">
                        <div style="text-align: center; margin-bottom: 2.5rem;">
                            <h2 style="font-size: 2rem; margin-bottom: 0.5rem; color: var(--text-primary);">Welcome Back</h2>
                            <p style="color: var(--text-secondary); font-size: 0.95rem;">Log in to access your private dashboard.</p>
                        </div>

                        <div class="form-group">
                            <label>Email Address</label>
                            <asp:TextBox ID="txtLoginEmail" runat="server" CssClass="form-input" TextMode="Email" placeholder="e.g. julian@vance.com" />
                        </div>

                        <div class="form-group">
                            <label>Password</label>
                            <asp:TextBox ID="txtLoginPassword" runat="server" CssClass="form-input" TextMode="Password" placeholder="Enter your password" />
                        </div>

                        <asp:Button ID="btnLogin" runat="server" Text="Sign In" CssClass="btn btn-primary" Style="width: 100%; margin-top: 1rem; height: 46px;" OnClick="btnLogin_Click" />

                        <asp:Label ID="lblLoginMessage" runat="server" CssClass="auth-message" />

                        <div class="auth-toggle">
                            Don't have an account? <a onclick="toggleAuth('register')">Register here</a>
                        </div>
                    </div>

                    <!-- REGISTRATION SECTION -->
                    <div id="registerSection" class="auth-form">
                        <div style="text-align: center; margin-bottom: 2.5rem;">
                            <h2 style="font-size: 2rem; margin-bottom: 0.5rem; color: var(--text-primary);">Client Registration</h2>
                            <p style="color: var(--text-secondary); font-size: 0.95rem;">Create an account to access private off-market listings.</p>
                        </div>

                        <div class="form-group">
                            <label>Full Name</label>
                            <asp:TextBox ID="txtRegisterName" runat="server" CssClass="form-input" placeholder="e.g. Julian Vance" />
                        </div>

                        <div class="form-group">
                            <label>Email Address</label>
                            <asp:TextBox ID="txtRegisterEmail" runat="server" CssClass="form-input" TextMode="Email" placeholder="e.g. julian@vance.com" />
                        </div>

                        <div class="form-group">
                            <label>Phone / WhatsApp</label>
                            <asp:TextBox ID="txtRegisterPhone" runat="server" CssClass="form-input" TextMode="Phone" placeholder="e.g. +91 98765 43210" />
                        </div>

                        <div class="form-group">
                            <label>Password</label>
                            <asp:TextBox ID="txtRegisterPassword" runat="server" CssClass="form-input" TextMode="Password" placeholder="Create a strong password" />
                        </div>

                        <div class="form-group">
                            <label>Confirm Password</label>
                            <asp:TextBox ID="txtConfirmPassword" runat="server" CssClass="form-input" TextMode="Password" placeholder="Confirm your password" />
                        </div>

                        <asp:Button ID="btnRegister" runat="server" Text="Create Account" CssClass="btn btn-primary" Style="width: 100%; margin-top: 1rem; height: 46px;" OnClick="btnRegister_Click" />

                        <asp:Label ID="lblRegisterMessage" runat="server" CssClass="auth-message" />

                        <div class="auth-toggle">
                            Already have an account? <a onclick="toggleAuth('login')">Log in here</a>
                        </div>
                    </div>

                </div>
            </div>
        </div>
    </section>

    <script>
        function toggleAuth(type) {
            const loginSection = document.getElementById('loginSection');
            const registerSection = document.getElementById('registerSection');

            if (type === 'register') {
                loginSection.classList.remove('active');
                registerSection.classList.add('active');
            } else {
                registerSection.classList.remove('active');
                loginSection.classList.add('active');
            }
        }
    </script>
</asp:Content> 