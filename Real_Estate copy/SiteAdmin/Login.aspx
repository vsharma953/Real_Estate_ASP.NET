<%@ Page Title="Site Admin Login" Language="C#" AutoEventWireup="true" CodeBehind="Login.aspx.cs" Inherits="Real_Estate.SiteAdmin.Login" %>

<!DOCTYPE html>
<html lang="en">
<head runat="server">
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Secure Site Admin Login | realEstate</title>
    <style>
        @import url('https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700;800&display=swap');

        body {
            font-family: 'Inter', sans-serif;
            background: linear-gradient(rgba(10, 12, 15, 0.75), rgba(10, 12, 15, 0.85)), url('https://images.unsplash.com/photo-1600607687920-4e2a09cf159d?auto=format&fit=crop&w=1920&q=80') no-repeat center center fixed;
            background-size: cover;
            color: #1a1a1a;
            display: flex;
            align-items: center;
            justify-content: center;
            height: 100vh;
            margin: 0;
        }

        .login-card {
            background-color: rgba(236, 234, 227, 0.95);
            backdrop-filter: blur(12px);
            padding: 3rem;
            border-radius: 10px;
            width: 100%;
            max-width: 400px;
            box-shadow: 0 20px 40px rgba(0,0,0,0.6);
            border-top: 4px solid #9c7f50;
        }

        .login-header {
            text-align: center;
            margin-bottom: 2rem;
        }

            .login-header h2 {
                font-size: 1.75rem;
                margin-bottom: 0.5rem;
                font-weight: 800;
            }

                .login-header h2 span {
                    font-weight: 400;
                    color: #9c7f50;
                }

        .form-group {
            margin-bottom: 1.25rem;
            display: flex;
            flex-direction: column;
        }

            .form-group label {
                font-size: 0.75rem;
                font-weight: 700;
                text-transform: uppercase;
                letter-spacing: 0.1em;
                color: #525252;
                margin-bottom: 0.5rem;
            }

        .form-input {
            padding: 0.8rem 1rem;
            border: 1px solid #cdcaca;
            border-radius: 6px;
            font-family: inherit;
            font-size: 0.9rem;
            outline: none;
            transition: 0.3s;
            background-color: #ffffff;
        }

            .form-input:focus {
                border-color: #9c7f50;
            }

        .btn-login {
            width: 100%;
            padding: 0.8rem;
            background-color: #1a1a1a;
            color: #ffffff;
            border: none;
            border-radius: 6px;
            font-weight: 600;
            text-transform: uppercase;
            letter-spacing: 0.05em;
            cursor: pointer;
            transition: 0.3s;
            margin-top: 1rem;
        }

            .btn-login:hover {
                background-color: #9c7f50;
            }

        .error-message {
            color: #ef4444;
            font-size: 0.85rem;
            margin-top: 1rem;
            text-align: center;
            font-weight: 600;
        }

        .validator-text {
            color: #ef4444;
            font-size: 0.75rem;
            margin-top: 0.3rem;
            font-weight: 600;
        }
    </style>
</head>
<body>
    <form id="form1" runat="server">
        <div class="login-card">
            <div class="login-header">
                <h2>real<span>Estate</span></h2>
                <p style="color: #7a7a7a; font-size: 0.9rem; margin: 0;">Site Administrator Portal</p>
            </div>

            <div class="form-group">
                <label>Admin Email</label>
                <asp:TextBox ID="txtEmail" runat="server" CssClass="form-input" placeholder="siteadmin@realestate.luxury"></asp:TextBox>
                <asp:RequiredFieldValidator ID="reqEmail" runat="server" ControlToValidate="txtEmail" ErrorMessage="Email is required." CssClass="validator-text" Display="Dynamic"></asp:RequiredFieldValidator>
                <asp:RegularExpressionValidator ID="regexEmail" runat="server" ControlToValidate="txtEmail" ValidationExpression="^[\w.+-]+@[a-zA-Z0-9-]+(\.[a-zA-Z0-9-]+)*\.[a-zA-Z]{2,20}$" ErrorMessage="Invalid email format." CssClass="validator-text" Display="Dynamic"></asp:RegularExpressionValidator>
            </div>

            <div class="form-group">
                <label>Access Key / Password</label>
                <asp:TextBox ID="txtPassword" runat="server" CssClass="form-input" TextMode="Password" placeholder="••••••••"></asp:TextBox>
                <asp:RequiredFieldValidator ID="reqPassword" runat="server" ControlToValidate="txtPassword" ErrorMessage="Access Key is required." CssClass="validator-text" Display="Dynamic"></asp:RequiredFieldValidator>
            </div>

            <asp:Button ID="btnLogin" runat="server" Text="Authenticate" CssClass="btn-login" OnClick="btnLogin_Click" />

            <asp:Label ID="lblError" runat="server" CssClass="error-message" Visible="false" Text="Invalid credentials. Please contact IT desk."></asp:Label>
        </div>
    </form>
</body>
</html>