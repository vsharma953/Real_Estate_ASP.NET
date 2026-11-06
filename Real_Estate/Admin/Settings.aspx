<%@ Page Title="System Settings" Language="C#" MasterPageFile="~/Admin/Admin.Master" AutoEventWireup="true" CodeBehind="Settings.aspx.cs" Inherits="Real_Estate.Admin.Settings" %>

<asp:Content ID="Content1" ContentPlaceHolderID="HeadContent" runat="server">
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">
    <div class="settings-row">

        <!-- Profile Configuration -->
        <div class="settings-card">
            <h3 class="settings-title">Profile Configuration</h3>

            <div class="form-group">
                <label class="form-label">Full name</label>
                <asp:TextBox ID="txtFullName" runat="server" CssClass="form-control" Text="Julian Vance"></asp:TextBox>
            </div>

            <div class="form-group" style="margin-bottom: 30px;">
                <label class="form-label">Official email</label>
                <asp:TextBox ID="txtEmail" runat="server" CssClass="form-control" Text="admin@realestate.luxury"></asp:TextBox>
            </div>

            <asp:Button ID="btnUpdateProfile" runat="server" Text="Update Profile" CssClass="btn-light" OnClientClick="alert('Profile saving will be connected in the database phase.'); return false;" />
        </div>

        <!-- Security & Preferences -->
        <div class="settings-card">
            <h3 class="settings-title">Security & Preferences</h3>

            <div class="form-group">
                <label class="form-label">New access key</label>
                <asp:TextBox ID="txtPassword" runat="server" TextMode="Password" CssClass="form-control form-control-bg" Text="........"></asp:TextBox>
            </div>

            <div class="checkbox-group">
                <asp:CheckBox ID="chkEmailAlerts" runat="server" Checked="true" CssClass="checkbox-control" />
                <label class="checkbox-label">Receive Email Alerts for New Inquiries</label>
            </div>

            <asp:Button ID="btnSavePreferences" runat="server" Text="Save Preferences" CssClass="btn-light" OnClientClick="alert('Preference saving will be connected in the database phase.'); return false;" />
        </div>

    </div>
</asp:Content>
