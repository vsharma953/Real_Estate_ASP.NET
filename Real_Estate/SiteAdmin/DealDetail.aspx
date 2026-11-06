<%@ Page Title="Deal" Language="C#" MasterPageFile="~/SiteAdmin/SiteAdmin.Master" AutoEventWireup="true" CodeBehind="DealDetail.aspx.cs" Inherits="Real_Estate.SiteAdmin.DealDetail" %>

<asp:Content ID="Content1" ContentPlaceHolderID="HeadContent" runat="server">
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">

    <div class="manage-box">

        <a href="Deals.aspx" class="back-link">&larr; All deals</a>

        <asp:Label ID="lblMessage" runat="server" Visible="false" CssClass="message"></asp:Label>

        <asp:Panel ID="pnlDeal" runat="server">

            <h2 class="manage-title">
                <asp:Literal ID="litTitle" runat="server"></asp:Literal>
                <span class="pill"><asp:Literal ID="litStatus" runat="server"></asp:Literal></span>
            </h2>
            <div class="muted"><asp:Literal ID="litSubtitle" runat="server"></asp:Literal></div>

            <div class="sections">
                <div class="section">
                    <h4>Agent</h4>
                    <asp:Literal ID="litAgent" runat="server"></asp:Literal>
                </div>
                <div class="section">
                    <h4>Client</h4>
                    <asp:Literal ID="litClient" runat="server"></asp:Literal>
                </div>
                <div class="section">
                    <h4>Property</h4>
                    <asp:Literal ID="litProperty" runat="server"></asp:Literal>
                </div>
                <div class="section">
                    <h4>Deal terms</h4>
                    <asp:Literal ID="litTerms" runat="server"></asp:Literal>
                </div>
                <div class="section">
                    <h4>Money</h4>
                    <asp:Literal ID="litMoney" runat="server"></asp:Literal>
                </div>
                <div class="section">
                    <h4>Commission</h4>
                    <asp:Literal ID="litCommission" runat="server"></asp:Literal>
                </div>
                <div class="section full">
                    <h4>Original inquiry and agent notes</h4>
                    <asp:Literal ID="litNotes" runat="server"></asp:Literal>
                </div>
            </div>

            <asp:Panel ID="pnlReview" runat="server" CssClass="actions" Visible="false">
                <h4>Review this deal</h4>
                <p class="muted">Approving a sale calculates the agent's commission from the final price and the agent's rate. Rejecting puts the property back on the website.</p>
                <asp:Button ID="btnApprove" runat="server" Text="Approve deal" CssClass="btn btn-approve" OnClick="btnApprove_Click" OnClientClick="return confirm('Approve this deal and calculate the commission?');" />
                <br /><br />
                <asp:TextBox ID="txtReason" runat="server" CssClass="form-control" MaxLength="500" placeholder="Reason for rejecting (required to reject)"></asp:TextBox>
                <br /><br />
                <asp:Button ID="btnReject" runat="server" Text="Reject deal" CssClass="btn btn-reject" OnClick="btnReject_Click" OnClientClick="return confirm('Reject this deal and put the property back on the website?');" />
            </asp:Panel>

            <asp:Panel ID="pnlPaid" runat="server" CssClass="actions" Visible="false">
                <h4>Commission payment</h4>
                <p class="muted">Use this after you have paid the agent their commission.</p>
                <asp:Button ID="btnMarkPaid" runat="server" Text="Mark commission as paid" CssClass="btn" OnClick="btnMarkPaid_Click" OnClientClick="return confirm('Mark this commission as paid?');" />
            </asp:Panel>

            <h3>Payments received</h3>
            <div class="table-scroll">
<asp:GridView ID="gvPayments" runat="server" AutoGenerateColumns="False" GridLines="None" CssClass="property-grid" EmptyDataText="No payments have been recorded for this deal yet.">
                <Columns>
                    <asp:TemplateField HeaderText="Date">
                        <ItemTemplate><%#: Eval("PaymentDate", "{0:dd/MM/yyyy}") %></ItemTemplate>
                    </asp:TemplateField>
                    <asp:TemplateField HeaderText="Amount">
                        <ItemTemplate><%# Money(Eval("Amount")) %></ItemTemplate>
                    </asp:TemplateField>
                    <asp:TemplateField HeaderText="Mode">
                        <ItemTemplate><%#: Eval("ModeName") %></ItemTemplate>
                    </asp:TemplateField>
                    <asp:TemplateField HeaderText="Reference">
                        <ItemTemplate><%#: Eval("Reference") %></ItemTemplate>
                    </asp:TemplateField>
                </Columns>
            </asp:GridView>
</div>

        </asp:Panel>

    </div>
</asp:Content>
