<%@ Page Title="Settings" Language="C#" MasterPageFile="~/SiteAdmin/SiteAdmin.Master" AutoEventWireup="true" CodeBehind="Settings.aspx.cs" Inherits="Real_Estate.SiteAdmin.Settings" %>

<asp:Content ID="Content1" ContentPlaceHolderID="HeadContent" runat="server">
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">

    <asp:Label ID="lblMessage" runat="server" Visible="false"></asp:Label>

    <div class="manage-box">

        <h2 class="manage-title">Money settings</h2>
        <p class="manage-subtitle">The currency shown next to amounts, and the commission an agent earns on every approved sale. Rentals earn no commission.</p>

        <div class="grid-2">
            <div class="field">
                <label for="<%= txtCurrency.ClientID %>">Currency symbol</label>
                <asp:TextBox ID="txtCurrency" runat="server" CssClass="form-control" MaxLength="10"></asp:TextBox>
            </div>
            <div class="field">
                <label for="<%= txtDefaultRate.ClientID %>">Default commission (%)</label>
                <asp:TextBox ID="txtDefaultRate" runat="server" CssClass="form-control" MaxLength="6"></asp:TextBox>
                <div class="hint">Used for every agent without their own rate below.</div>
            </div>
        </div>

        <asp:Button ID="btnSaveSettings" runat="server" Text="Save settings" CssClass="btn" OnClick="btnSaveSettings_Click" />

    </div>

    <div class="manage-box">

        <h2 class="manage-title">Commission per agent</h2>
        <p class="manage-subtitle">Leave an agent's rate empty to use the default. A new rate applies to deals approved from now on; approved deals keep the rate they were approved with.</p>

        <div class="table-scroll">
<asp:GridView ID="gvAgents" runat="server" AutoGenerateColumns="False" GridLines="None" CssClass="property-grid"
            DataKeyNames="AgentID" EmptyDataText="No agents yet.">
            <Columns>
                <asp:TemplateField HeaderText="Agent">
                    <ItemTemplate><%#: Eval("FullName") %></ItemTemplate>
                </asp:TemplateField>
                <asp:TemplateField HeaderText="Status">
                    <ItemTemplate><%#: Eval("Status") %></ItemTemplate>
                </asp:TemplateField>
                <asp:TemplateField HeaderText="Own commission (%)">
                    <ItemTemplate>
                        <asp:TextBox ID="txtAgentRate" runat="server" CssClass="form-control rate-input" MaxLength="6"
                            Text='<%# RateText(Eval("CommissionPercent")) %>' placeholder="Default"></asp:TextBox>
                    </ItemTemplate>
                </asp:TemplateField>
            </Columns>
        </asp:GridView>
</div>

        <asp:Button ID="btnSaveRates" runat="server" Text="Save agent rates" CssClass="btn" OnClick="btnSaveRates_Click" />

    </div>

</asp:Content>
