<%@ Page Title="Close Deal" Language="C#" MasterPageFile="~/Admin/Admin.Master" AutoEventWireup="true" CodeBehind="CloseDeal.aspx.cs" Inherits="Real_Estate.Admin.CloseDeal" %>

<asp:Content ID="Content1" ContentPlaceHolderID="HeadContent" runat="server">
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">

    <div class="deal-wrap">

        <asp:Label ID="lblMessage" runat="server" Visible="false" CssClass="message"></asp:Label>

        <asp:HyperLink ID="hlBackOnly" runat="server" NavigateUrl="~/Admin/Inquiries.aspx" Visible="false" CssClass="btn-back">Back to inquiries</asp:HyperLink>

        <asp:Panel ID="pnlForm" runat="server">

            <div class="deal-card">
                <h3>Property</h3>
                <div class="property-box">
                    <strong><asp:Label ID="lblProperty" runat="server"></asp:Label></strong><br />
                    <asp:Label ID="lblMeta" runat="server"></asp:Label><br />
                    Listed price: <strong><asp:Label ID="lblListed" runat="server"></asp:Label></strong>
                </div>
            </div>

            <div class="deal-card">
                <h3>Client</h3>
                <div class="grid-2">
                    <div class="field">
                        <label for="<%= txtClientName.ClientID %>">Full name</label>
                        <asp:TextBox ID="txtClientName" runat="server" CssClass="form-control" MaxLength="100"></asp:TextBox>
                    </div>
                    <div class="field">
                        <label for="<%= txtClientPhone.ClientID %>">Mobile number</label>
                        <asp:TextBox ID="txtClientPhone" runat="server" TextMode="Phone" CssClass="form-control" MaxLength="20"></asp:TextBox>
                    </div>
                    <div class="field">
                        <label for="<%= txtClientEmail.ClientID %>">Email</label>
                        <asp:TextBox ID="txtClientEmail" runat="server" TextMode="Email" CssClass="form-control" MaxLength="150"></asp:TextBox>
                    </div>
                    <div class="field">
                        <label for="<%= txtClientAddress.ClientID %>">Address (optional)</label>
                        <asp:TextBox ID="txtClientAddress" runat="server" CssClass="form-control" MaxLength="300"></asp:TextBox>
                    </div>
                </div>
            </div>

            <div>

                <asp:Panel ID="pnlSale" runat="server" CssClass="deal-card">
                    <h3>Sale details</h3>
                    <div class="grid-2">
                        <div class="field">
                            <label for="<%= txtFinalPrice.ClientID %>">Final agreed price (<%: Cur %>)</label>
                            <asp:TextBox ID="txtFinalPrice" runat="server" CssClass="form-control" MaxLength="20"></asp:TextBox>
                            <div class="hint">The price actually agreed with the buyer.</div>
                        </div>
                        <div class="field">
                            <label for="<%= txtClosingDate.ClientID %>">Closing date</label>
                            <asp:TextBox ID="txtClosingDate" runat="server" TextMode="Date" CssClass="form-control"></asp:TextBox>
                        </div>
                        <div class="field">
                            <label for="<%= txtAgreementDate.ClientID %>">Agreement date (optional)</label>
                            <asp:TextBox ID="txtAgreementDate" runat="server" TextMode="Date" CssClass="form-control"></asp:TextBox>
                        </div>
                    </div>
                </asp:Panel>

                <asp:Panel ID="pnlRent" runat="server" CssClass="deal-card">
                    <h3>Rental details</h3>
                    <div class="grid-2">
                        <div class="field">
                            <label for="<%= txtMonthlyRent.ClientID %>">Monthly rent (<%: Cur %>)</label>
                            <asp:TextBox ID="txtMonthlyRent" runat="server" CssClass="form-control" MaxLength="20"></asp:TextBox>
                        </div>
                        <div class="field">
                            <label for="<%= txtDeposit.ClientID %>">Security deposit (<%: Cur %>)</label>
                            <asp:TextBox ID="txtDeposit" runat="server" CssClass="form-control" MaxLength="20"></asp:TextBox>
                        </div>
                        <div class="field">
                            <label for="<%= txtLeaseStart.ClientID %>">Lease start</label>
                            <asp:TextBox ID="txtLeaseStart" runat="server" TextMode="Date" CssClass="form-control"></asp:TextBox>
                        </div>
                        <div class="field">
                            <label for="<%= txtLeaseEnd.ClientID %>">Lease end</label>
                            <asp:TextBox ID="txtLeaseEnd" runat="server" TextMode="Date" CssClass="form-control"></asp:TextBox>
                        </div>
                    </div>
                    <div class="hint hint-gap">Rentals do not earn commission and are recorded straight away.</div>
                </asp:Panel>

            </div>

            <div class="deal-card">
                <h3>First payment received (optional)</h3>
                <div class="grid-2">
                    <div class="field">
                        <label for="<%= txtPayAmount.ClientID %>">Amount (<%: Cur %>)</label>
                        <asp:TextBox ID="txtPayAmount" runat="server" CssClass="form-control" MaxLength="20"></asp:TextBox>
                        <div class="hint">Advance, token amount or deposit. Later payments are added from My Deals.</div>
                    </div>
                    <div class="field">
                        <label for="<%= ddlPayMode.ClientID %>">Payment mode</label>
                        <asp:DropDownList ID="ddlPayMode" runat="server" CssClass="form-control">
                            <asp:ListItem Text="Select mode" Value=""></asp:ListItem>
                            <asp:ListItem Text="Cash"></asp:ListItem>
                            <asp:ListItem Text="Bank Transfer"></asp:ListItem>
                            <asp:ListItem Text="Cheque"></asp:ListItem>
                            <asp:ListItem Text="UPI"></asp:ListItem>
                            <asp:ListItem Text="Card"></asp:ListItem>
                        </asp:DropDownList>
                    </div>
                    <div class="field">
                        <label for="<%= txtPayRef.ClientID %>">Reference (cheque no. / transaction id)</label>
                        <asp:TextBox ID="txtPayRef" runat="server" CssClass="form-control" MaxLength="100"></asp:TextBox>
                    </div>
                    <div class="field">
                        <label for="<%= txtPayDate.ClientID %>">Payment date</label>
                        <asp:TextBox ID="txtPayDate" runat="server" TextMode="Date" CssClass="form-control"></asp:TextBox>
                    </div>
                </div>
            </div>

            <div class="deal-card">
                <h3>Notes</h3>
                <asp:TextBox ID="txtNotes" runat="server" TextMode="MultiLine" Rows="3" MaxLength="1000" CssClass="form-control" placeholder="Anything the site administrator should know about this deal..."></asp:TextBox>
            </div>

            <asp:Button ID="btnSubmit" runat="server" Text="Submit Deal" CssClass="btn-main" OnClick="btnSubmit_Click" OnClientClick="return confirm('Submit this deal? The property will be taken off the website.');" />
            <asp:HyperLink ID="hlCancel" runat="server" NavigateUrl="~/Admin/Inquiries.aspx" CssClass="btn-back">Cancel</asp:HyperLink>

        </asp:Panel>

    </div>

</asp:Content>
