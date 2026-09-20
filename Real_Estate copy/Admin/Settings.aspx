<%@ Page Title="System Settings" Language="C#" MasterPageFile="~/Admin/Admin.Master" AutoEventWireup="true" CodeBehind="Settings.aspx.cs" Inherits="Real_Estate.Admin.Settings" %>

<asp:Content ID="Content1" ContentPlaceHolderID="HeadContent" runat="server">
    <style>
        .settings-row {
            display: flex;
            gap: 40px;
            flex-wrap: wrap;
        }

        .settings-card {
            flex: 1;
            min-width: 300px;
            background: #fff;
            padding: 35px;
            border: 1px solid #ddd;
            border-radius: 4px;
            box-shadow: 0 1px 3px rgba(0,0,0,0.05);
        }

        .settings-title {
            color: #111827;
            margin-top: 0;
            margin-bottom: 30px;
            font-size: 20px;
        }

        .form-group {
            margin-bottom: 25px;
        }

        .form-label {
            display: block;
            font-size: 12px;
            font-weight: bold;
            color: #555;
            margin-bottom: 8px;
            letter-spacing: 0.5px;
        }
 
        .form-control {
            width: 100%;
            padding: 12px;
            border: 1px solid #ccc;
            border-radius: 4px;
            font-size: 14px;
        }

        .form-control-bg {
            background: #f0f4f8;
        }

        .checkbox-group {
            display: flex;
            align-items: center;
            margin-bottom: 30px;
        }

        .checkbox-control {
            margin-right: 12px;
            transform: scale(1.2);
        }

        .checkbox-label {
            color: #333;
            font-size: 15px;
        }

        .btn-light {
            padding: 12px 24px;
            background: #f4f4f4;
            color: #111827;
            border: 1px solid #ccc;
            border-radius: 4px;
            cursor: pointer;
            font-weight: 500;
        }
    </style>
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">
    <div class="settings-row">

        <!-- Profile Configuration -->
        <div class="settings-card">
            <h3 class="settings-title">Profile Configuration</h3>

            <div class="form-group">
                <label class="form-label">FULL NAME</label>
                <asp:TextBox ID="txtFullName" runat="server" CssClass="form-control" Text="Julian Vance"></asp:TextBox>
            </div>

            <div class="form-group" style="margin-bottom: 30px;">
                <label class="form-label">OFFICIAL EMAIL</label>
                <asp:TextBox ID="txtEmail" runat="server" CssClass="form-control" Text="admin@realestate.luxury"></asp:TextBox>
            </div>

            <asp:Button ID="btnUpdateProfile" runat="server" Text="Update Profile" CssClass="btn-light" OnClientClick="alert('Profile saving will be connected in the database phase.'); return false;" />
        </div>

        <!-- Security & Preferences -->
        <div class="settings-card">
            <h3 class="settings-title">Security & Preferences</h3>

            <div class="form-group">
                <label class="form-label">NEW ACCESS KEY</label>
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
