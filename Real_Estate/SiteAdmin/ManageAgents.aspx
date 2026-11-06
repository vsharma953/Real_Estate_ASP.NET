<%@ Page Title="Manage Agents" Language="C#" MasterPageFile="~/SiteAdmin/SiteAdmin.Master" AutoEventWireup="true" CodeBehind="ManageAgents.aspx.cs" Inherits="Real_Estate.SiteAdmin.ManageAgents" %>

<asp:Content ID="Content1" ContentPlaceHolderID="HeadContent" runat="server">
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
                <td>Commission %</td>
                <td>
                    <asp:TextBox ID="txtCommission" runat="server" Width="95%" CssClass="form-control" Text="2"></asp:TextBox>
                </td>
            </tr>

        </table>

        <p class="form-hint form-hint-gap">
            Password is required when adding a new agent. Leave it blank when updating an agent to keep their current password unchanged.
        </p>

        <br />

        <asp:Button ID="btnSave" runat="server" Text="Save" CssClass="action-button save-button" OnClick="btnSave_Click" />
        <asp:Button ID="btnCancel" runat="server" Text="Clear" CausesValidation="false" CssClass="action-button clear-button" OnClick="btnCancel_Click" />

        <hr class="section-line" />

        <div class="table-scroll">
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

                <asp:TemplateField HeaderText="Commission %">
                    <ItemTemplate>
                        <asp:Label ID="lblCommission" runat="server" Text='<%# Eval("CommissionPercent") %>'></asp:Label>
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
    </div>
</asp:Content>
