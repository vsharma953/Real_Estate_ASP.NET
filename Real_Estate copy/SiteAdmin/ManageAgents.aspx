<%@ Page Title="Manage Agents" Language="C#" MasterPageFile="~/SiteAdmin/SiteAdmin.Master" AutoEventWireup="true" CodeBehind="ManageAgents.aspx.cs" Inherits="Real_Estate.SiteAdmin.ManageAgents" %>

<asp:Content ID="Content1" ContentPlaceHolderID="HeadContent" runat="server">

    <style>
        .manage-box {
            background: #fff;
            padding: 30px;
            border: 1px solid #e5e5e5;
            border-radius: 8px;
        }

        .manage-title {
            margin: 0 0 6px 0;
            font-size: 28px;
            color: #222;
        }

        .manage-subtitle {
            margin: 0 0 25px 0;
            color: #777;
        }

        .form-table {
            width: 100%;
            border-collapse: separate;
            border-spacing: 0 12px;
        }

            .form-table td {
                padding: 4px 10px 4px 0;
                color: #444;
            }

                .form-table td:nth-child(3) {
                    padding-left: 25px;
                }

        .form-control {
            height: 38px;
            padding: 7px 10px;
            border: 1px solid #ccc;
            border-radius: 4px;
            box-sizing: border-box;
        }

            .form-control:focus {
                outline: none;
                border-color: #a98750;
            }

        .action-button {
            padding: 9px 22px;
            border: none;
            border-radius: 4px;
            cursor: pointer;
            margin-right: 8px;
            font-weight: 600;
        }

        .save-button {
            background: #222;
            color: #fff;
        }

            .save-button:hover {
                background: #a98750;
            }

        .clear-button {
            background: #eee;
            color: #333;
        }

            .clear-button:hover {
                background: #ddd;
            }

        .message {
            display: block;
            padding: 10px 12px;
            background: #f7f3ec;
            border-left: 3px solid #a98750;
            color: #555;
        }

        .property-grid {
            width: 100%;
            border-collapse: collapse;
            margin-top: 15px;
        }

            .property-grid th {
                background: #222;
                color: #fff;
                padding: 12px 10px;
                text-align: left;
                font-weight: 600;
            }

            .property-grid td {
                padding: 10px;
                border-bottom: 1px solid #e5e5e5;
                vertical-align: middle;
            }

            .property-grid tr:hover td {
                background: #faf9f6;
            }

        .grid-button {
            padding: 6px 14px;
            border: 1px solid #ccc;
            background: #fff;
            border-radius: 4px;
            cursor: pointer;
        }

            .grid-button:hover {
                background: #f3f0eb;
                border-color: #a98750;
            }

        .delete-button {
            color: #a33;
        }

            .delete-button:hover {
                background: #f8eeee;
                border-color: #c99;
            }

        .section-line {
            border: 0;
            border-top: 1px solid #e5e5e5;
            margin: 28px 0;
        }

        @media (max-width: 800px) {
            .manage-box {
                padding: 20px;
            }

            .form-table,
            .form-table tbody,
            .form-table tr,
            .form-table td {
                display: block;
                width: 100%;
                box-sizing: border-box;
            }

                .form-table td:nth-child(3) {
                    padding-left: 0;
                }

                .form-table td {
                    padding-bottom: 5px;
                }

            .property-grid {
                display: block;
                overflow-x: auto;
                white-space: nowrap;
            }
        }
    </style>

</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">

    <div class="manage-box">

        <h2 class="manage-title">Manage Agents</h2>

        <p class="manage-subtitle">
            Add, update and delete agent accounts. Agents log in at /Admin/Login.aspx with the email and password set here.
        </p>

        <asp:Label ID="lblMessage" runat="server" Visible="false" CssClass="message"></asp:Label>

        <table class="form-table">

            <tr>
                <td style="width: 20%;">Full Name</td>
                <td style="width: 30%;">
                    <asp:TextBox ID="txtFullName" runat="server" Width="95%" CssClass="form-control"></asp:TextBox>
                </td>
                <td style="width: 20%;">Email</td>
                <td style="width: 30%;">
                    <asp:TextBox ID="txtEmail" runat="server" Width="95%" CssClass="form-control"></asp:TextBox>
                </td>
            </tr>

            <tr>
                <td>Phone</td>
                <td>
                    <asp:TextBox ID="txtPhone" runat="server" Width="95%" CssClass="form-control"></asp:TextBox>
                </td>
                <td>Password</td>
                <td>
                    <asp:TextBox ID="txtPassword" runat="server" Width="95%" CssClass="form-control" TextMode="Password"></asp:TextBox>
                </td>
            </tr>

            <tr>
                <td>Status</td>
                <td>
                    <asp:DropDownList ID="ddlStatus" runat="server" Width="95%" CssClass="form-control">
                        <asp:ListItem Text="Active" Value="Active"></asp:ListItem>
                        <asp:ListItem Text="Inactive" Value="Inactive"></asp:ListItem>
                    </asp:DropDownList>
                </td>
                <td></td>
                <td></td>
            </tr>

        </table>

        <p style="color: #999; font-size: 13px; margin-top: -5px;">
            Password is required when adding a new agent. Leave it blank when updating an agent to keep their current password unchanged.
        </p>

        <br />

        <asp:Button ID="btnSave" runat="server" Text="Save" CssClass="action-button save-button" OnClick="btnSave_Click" />
        <asp:Button ID="btnCancel" runat="server" Text="Clear" CausesValidation="false" CssClass="action-button clear-button" OnClick="btnCancel_Click" />

        <hr class="section-line" />

        <asp:GridView ID="gvAgents" runat="server" AutoGenerateColumns="False" GridLines="None" CssClass="property-grid" OnRowCommand="gvAgents_RowCommand" EmptyDataText="No agents found.">
            <Columns>

                <asp:TemplateField HeaderText="ID">
                    <ItemTemplate>
                        <asp:Label ID="lblID" runat="server" Text='<%# Eval("AgentID") %>'></asp:Label>
                    </ItemTemplate>
                </asp:TemplateField>

                <asp:TemplateField HeaderText="Full Name">
                    <ItemTemplate>
                        <asp:Label ID="lblFullName" runat="server" Text='<%# Eval("FullName") %>'></asp:Label>
                    </ItemTemplate>
                </asp:TemplateField>

                <asp:TemplateField HeaderText="Email">
                    <ItemTemplate>
                        <asp:Label ID="lblEmail" runat="server" Text='<%# Eval("Email") %>'></asp:Label>
                    </ItemTemplate>
                </asp:TemplateField>

                <asp:TemplateField HeaderText="Phone">
                    <ItemTemplate>
                        <asp:Label ID="lblPhone" runat="server" Text='<%# Eval("Phone") %>'></asp:Label>
                    </ItemTemplate>
                </asp:TemplateField>

                <asp:TemplateField HeaderText="Status">
                    <ItemTemplate>
                        <asp:Label ID="lblStatus" runat="server" Text='<%# Eval("Status") %>'></asp:Label>
                    </ItemTemplate>
                </asp:TemplateField>

                <asp:TemplateField HeaderText="Listings">
                    <ItemTemplate>
                        <asp:Label ID="lblListings" runat="server" Text='<%# Eval("Listings") %>'></asp:Label>
                    </ItemTemplate>
                </asp:TemplateField>

                <asp:TemplateField HeaderText="Edit">
                    <ItemTemplate>
                        <asp:Button ID="btnEdit" runat="server" Text="Edit" CssClass="grid-button" CommandName="EditRow" CommandArgument='<%# Eval("AgentID") %>' />
                    </ItemTemplate>
                </asp:TemplateField>

                <asp:TemplateField HeaderText="Delete">
                    <ItemTemplate>
                        <asp:Button ID="btnDelete" runat="server" Text="Delete" CssClass="grid-button delete-button" CommandName="DeleteRow" CommandArgument='<%# Eval("AgentID") %>' OnClientClick="return confirm('Are you sure you want to delete this agent?');" />
                    </ItemTemplate>
                </asp:TemplateField>

            </Columns>
        </asp:GridView>
    </div>
</asp:Content>
