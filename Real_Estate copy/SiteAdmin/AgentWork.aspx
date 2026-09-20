<%@ Page Title="Agent Work" Language="C#" MasterPageFile="~/SiteAdmin/SiteAdmin.Master" AutoEventWireup="true" CodeBehind="AgentWork.aspx.cs" Inherits="Real_Estate.SiteAdmin.AgentWork" %>

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

        .filter-row {
            margin-bottom: 20px;
        }

            .filter-row label {
                font-weight: 600;
                color: #444;
                margin-right: 10px;
            }

        .form-control {
            height: 38px;
            padding: 7px 10px;
            border: 1px solid #ccc;
            border-radius: 4px;
            box-sizing: border-box;
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

        .delete-button {
            color: #a33;
        }

            .delete-button:hover {
                background: #f8eeee;
                border-color: #c99;
            }

        .message {
            display: block;
            padding: 10px 12px;
            background: #f7f3ec;
            border-left: 3px solid #a98750;
            color: #555;
            margin-bottom: 20px;
        }

        @media (max-width: 800px) {
            .manage-box {
                padding: 20px;
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

        <h2 class="manage-title">Agent Work</h2>

        <p class="manage-subtitle">
            Every property listed across every agent, so you can see what each agent has been working on.
        </p>

        <asp:Label ID="lblMessage" runat="server" Visible="false" CssClass="message"></asp:Label>

        <div class="filter-row">
            <label>Filter by Agent:</label>
            <asp:DropDownList ID="ddlAgentFilter" runat="server" CssClass="form-control" AutoPostBack="true" OnSelectedIndexChanged="ddlAgentFilter_SelectedIndexChanged">
                <asp:ListItem Text="All Agents" Value="0"></asp:ListItem>
            </asp:DropDownList>
        </div>

        <asp:GridView ID="gvAgentWork" runat="server" AutoGenerateColumns="False" GridLines="None" CssClass="property-grid" OnRowCommand="gvAgentWork_RowCommand" EmptyDataText="No properties have been listed yet.">
            <Columns>

                <asp:TemplateField HeaderText="ID">
                    <ItemTemplate>
                        <asp:Label ID="lblID" runat="server" Text='<%# Eval("PropertyID") %>'></asp:Label>
                    </ItemTemplate>
                </asp:TemplateField>

                <asp:TemplateField HeaderText="Title">
                    <ItemTemplate>
                        <asp:Label ID="lblTitle" runat="server" Text='<%# Eval("Title") %>'></asp:Label>
                    </ItemTemplate>
                </asp:TemplateField>

                <asp:TemplateField HeaderText="Agent">
                    <ItemTemplate>
                        <asp:Label ID="lblAgentName" runat="server" Text='<%# Eval("AgentName") %>'></asp:Label>
                    </ItemTemplate>
                </asp:TemplateField>

                <asp:TemplateField HeaderText="Type">
                    <ItemTemplate>
                        <asp:Label ID="lblType" runat="server" Text='<%# Eval("PropertyType") %>'></asp:Label>
                    </ItemTemplate>
                </asp:TemplateField>

                <asp:TemplateField HeaderText="Price">
                    <ItemTemplate>
                        <asp:Label ID="lblPrice" runat="server" Text='<%# Eval("Price") %>'></asp:Label>
                    </ItemTemplate>
                </asp:TemplateField>

                <asp:TemplateField HeaderText="Location">
                    <ItemTemplate>
                        <asp:Label ID="lblLocation" runat="server" Text='<%# Eval("Location") %>'></asp:Label>
                    </ItemTemplate>
                </asp:TemplateField>

                <asp:TemplateField HeaderText="Status">
                    <ItemTemplate>
                        <asp:Label ID="lblStatus" runat="server" Text='<%# Eval("Status") %>'></asp:Label>
                    </ItemTemplate>
                </asp:TemplateField>

                <asp:TemplateField HeaderText="Remove">
                    <ItemTemplate>
                        <asp:Button ID="btnDelete" runat="server" Text="Delete" CssClass="grid-button delete-button" CommandName="DeleteRow" CommandArgument='<%# Eval("PropertyID") %>' OnClientClick="return confirm('Remove this listing?');" />
                    </ItemTemplate>
                </asp:TemplateField>

            </Columns>
        </asp:GridView>
    </div>
</asp:Content>
