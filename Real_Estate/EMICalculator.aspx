<%@ Page Title="EMI Calculator" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="EMICalculator.aspx.cs" Inherits="Real_Estate.EMICalculator" %>

<asp:Content ID="Content1" ContentPlaceHolderID="HeadContent" runat="server">

    <style>
        .emi-layout {
            display: grid;
            grid-template-columns: 1fr 1fr;
            gap: 2rem;
            align-items: start;
        }

        .emi-card {
            background: var(--bg-primary, #fff);
            padding: 2rem;
            border: 1px solid var(--border, #EAEAEA);
            border-radius: 6px;
        }

        .emi-card h3 {
            margin: 0 0 1.5rem 0;
            font-size: 1.25rem;
        }

        .emi-group {
            margin-bottom: 1.25rem;
        }

        .emi-label {
            display: block;
            font-size: 0.75rem;
            font-weight: bold;
            letter-spacing: 0.5px;
            text-transform: uppercase;
            color: var(--text-secondary, #555);
            margin-bottom: 0.5rem;
        }

        .emi-control {
            width: 100%;
            padding: 12px;
            border: 1px solid var(--border, #ccc);
            border-radius: 4px;
            font-size: 14px;
            box-sizing: border-box;
            background: #fff;
        }

            .emi-control:focus {
                outline: none;
                border-color: var(--accent, #a3875a);
            }

        .emi-row {
            display: grid;
            grid-template-columns: 1fr 1fr 1fr;
            gap: 1rem;
        }

        .emi-message {
            display: block;
            margin-bottom: 1.25rem;
            padding: 10px 12px;
            border-radius: 4px;
            font-size: 14px;
            background: #fbecec;
            color: #9b2c2c;
            border: 1px solid #e5bcbc;
        }

        .emi-hint {
            color: var(--text-secondary, #777);
            font-size: 0.85rem;
            margin: 0;
        }

        .emi-highlight {
            padding: 1.5rem;
            margin-bottom: 1.25rem;
            text-align: center;
            border-radius: 6px;
            background: #f7f3ec;
            border-left: 3px solid var(--accent, #a3875a);
        }

            .emi-highlight span {
                display: block;
                font-size: 0.75rem;
                letter-spacing: 0.5px;
                text-transform: uppercase;
                color: var(--text-secondary, #777);
            }

            .emi-highlight strong {
                display: block;
                margin-top: 0.4rem;
                font-size: 2.25rem;
                color: var(--accent, #a3875a);
            }

        .emi-stats {
            display: grid;
            grid-template-columns: 1fr 1fr 1fr;
            gap: 1rem;
            margin-bottom: 1.75rem;
        }

        .emi-stat {
            padding: 1rem;
            border: 1px solid var(--border, #EAEAEA);
            border-radius: 4px;
        }

            .emi-stat span {
                display: block;
                font-size: 0.7rem;
                letter-spacing: 0.5px;
                text-transform: uppercase;
                color: var(--text-secondary, #777);
            }

            .emi-stat strong {
                display: block;
                margin-top: 0.3rem;
                font-size: 1.05rem;
            }

        .emi-table {
            width: 100%;
            border-collapse: collapse;
        }

        .emi-grid-header th {
            background-color: #FAFAFA;
            color: #555;
            padding: 10px;
            text-align: left;
            font-size: 12px;
            border-bottom: 2px solid #EAEAEA;
        }

        .emi-grid-row td {
            padding: 10px;
            border-bottom: 1px solid #EAEAEA;
            font-size: 13px;
        }

        .emi-schedule {
            overflow-x: auto;
        }

        @media (max-width: 900px) {
            .emi-layout {
                grid-template-columns: 1fr;
            }

            .emi-row,
            .emi-stats {
                grid-template-columns: 1fr;
            }
        }
    </style>

</asp:Content>


<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">

    <section class="section-padding" id="emi">

        <div class="container">

            <div class="section-header reveal">
                <span>Plan Your Purchase</span>
                <h2>EMI Calculator</h2>
                <p>Choose a residence for sale or enter any price to see your monthly installment.</p>
            </div>

            <div class="emi-layout">

                <div class="emi-card">

                    <h3>Loan Details</h3>

                    <asp:Label ID="lblMessage" runat="server" Visible="false" CssClass="emi-message"></asp:Label>

                    <div class="emi-group">
                        <label class="emi-label">Residence</label>
                        <asp:DropDownList ID="ddlProperty" runat="server" CssClass="emi-control" AutoPostBack="true" OnSelectedIndexChanged="ddlProperty_SelectedIndexChanged">
                        </asp:DropDownList>
                    </div>

                    <div class="emi-group">
                        <label class="emi-label">Property Price ($)</label>
                        <asp:TextBox ID="txtPrice" runat="server" CssClass="emi-control"></asp:TextBox>
                    </div>

                    <div class="emi-row">

                        <div class="emi-group">
                            <label class="emi-label">Down Payment (%)</label>
                            <asp:TextBox ID="txtDownPayment" runat="server" CssClass="emi-control"></asp:TextBox>
                        </div>

                        <div class="emi-group">
                            <label class="emi-label">Interest (% / year)</label>
                            <asp:TextBox ID="txtRate" runat="server" CssClass="emi-control"></asp:TextBox>
                        </div>

                        <div class="emi-group">
                            <label class="emi-label">Tenure (years)</label>
                            <asp:TextBox ID="txtTenure" runat="server" CssClass="emi-control"></asp:TextBox>
                        </div>

                    </div>

                    <asp:Button ID="btnCalculate" runat="server" Text="Calculate EMI" CssClass="btn btn-primary" OnClick="btnCalculate_Click" />

                </div>


                <div class="emi-card">

                    <h3>Your Installment</h3>

                    <asp:Panel ID="pnlEmpty" runat="server">
                        <p class="emi-hint">Fill in the loan details and press Calculate EMI to see your monthly payment.</p>
                    </asp:Panel>

                    <asp:Panel ID="pnlResult" runat="server" Visible="false">

                        <div class="emi-highlight">
                            <span>Monthly EMI</span>
                            <strong><asp:Literal ID="litEmi" runat="server"></asp:Literal></strong>
                        </div>

                        <div class="emi-stats">
                            <div class="emi-stat">
                                <span>Loan Amount</span>
                                <strong><asp:Literal ID="litLoan" runat="server"></asp:Literal></strong>
                            </div>
                            <div class="emi-stat">
                                <span>Total Interest</span>
                                <strong><asp:Literal ID="litInterest" runat="server"></asp:Literal></strong>
                            </div>
                            <div class="emi-stat">
                                <span>Total Payment</span>
                                <strong><asp:Literal ID="litTotal" runat="server"></asp:Literal></strong>
                            </div>
                        </div>

                        <div class="emi-schedule">
                            <asp:GridView ID="gvSchedule" runat="server" CssClass="emi-table" AutoGenerateColumns="False" GridLines="None">
                                <HeaderStyle CssClass="emi-grid-header" />
                                <RowStyle CssClass="emi-grid-row" />
                                <Columns>

                                    <asp:TemplateField HeaderText="Year">
                                        <ItemTemplate>
                                            <asp:Label ID="lblYear" runat="server" Text='<%# Eval("Year") %>'></asp:Label>
                                        </ItemTemplate>
                                    </asp:TemplateField>

                                    <asp:TemplateField HeaderText="Principal Paid">
                                        <ItemTemplate>
                                            <asp:Label ID="lblPrincipal" runat="server" Text='<%# Eval("Principal") %>'></asp:Label>
                                        </ItemTemplate>
                                    </asp:TemplateField>

                                    <asp:TemplateField HeaderText="Interest Paid">
                                        <ItemTemplate>
                                            <asp:Label ID="lblInterestPaid" runat="server" Text='<%# Eval("Interest") %>'></asp:Label>
                                        </ItemTemplate>
                                    </asp:TemplateField>

                                    <asp:TemplateField HeaderText="Balance">
                                        <ItemTemplate>
                                            <asp:Label ID="lblBalance" runat="server" Text='<%# Eval("Balance") %>'></asp:Label>
                                        </ItemTemplate>
                                    </asp:TemplateField>

                                </Columns>
                            </asp:GridView>
                        </div>

                    </asp:Panel>

                </div>

            </div>

        </div>

    </section>

</asp:Content>
