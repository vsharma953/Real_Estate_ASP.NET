<%@ Page Title="Admin Login" Language="C#" AutoEventWireup="true" CodeBehind="Login.aspx.cs" Inherits="Real_Estate.Admin.Login" %>

<!DOCTYPE html>
<html lang="en">
<head runat="server">
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Secure Agent Login | realEstate</title>
    <link href="css/admin-style.css?v=3" rel="stylesheet" />
</head>
<body class="login-page">
    <form id="form1" runat="server">
        <div class="login-card">
            <div class="login-header">
                <h2>real<span>Estate</span></h2>
                <p class="login-sub">Agent Advisory Portal</p>
            </div>

            <div class="form-group">
                <label for="<%= txtEmail.ClientID %>">Agent email</label>
                <asp:TextBox ID="txtEmail" runat="server" CssClass="form-input" autocomplete="username" placeholder="agent@realestate.luxury"></asp:TextBox>
                <asp:RequiredFieldValidator ID="reqEmail" runat="server" ControlToValidate="txtEmail" ErrorMessage="Email is required." CssClass="validator-text" Display="Dynamic"></asp:RequiredFieldValidator>
                <asp:RegularExpressionValidator ID="regexEmail" runat="server" ControlToValidate="txtEmail" ValidationExpression="^[\w.+-]+@[a-zA-Z0-9-]+(\.[a-zA-Z0-9-]+)*\.[a-zA-Z]{2,20}$" ErrorMessage="Invalid email format." CssClass="validator-text" Display="Dynamic"></asp:RegularExpressionValidator>
            </div>

            <div class="form-group">
                <label for="<%= txtPassword.ClientID %>">Access key / password</label>
                <asp:TextBox ID="txtPassword" runat="server" CssClass="form-input" autocomplete="current-password" TextMode="Password" placeholder="••••••••"></asp:TextBox>
                <asp:RequiredFieldValidator ID="reqPassword" runat="server" ControlToValidate="txtPassword" ErrorMessage="Access Key is required." CssClass="validator-text" Display="Dynamic"></asp:RequiredFieldValidator>
            </div>

            <asp:Button ID="btnLogin" runat="server" Text="Authenticate" CssClass="btn-login" OnClick="btnLogin_Click" />

            <asp:Label ID="lblError" runat="server" CssClass="error-message" Visible="false" Text="Invalid credentials. Please contact IT desk."></asp:Label>
        </div>
    </form>
</body>
</html>