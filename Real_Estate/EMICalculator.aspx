<%@ Page Title="EMI Calculator" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="EMICalculator.aspx.cs" Inherits="Real_Estate.EMICalculator" %>

<asp:Content ID="Content1" ContentPlaceHolderID="HeadContent" runat="server">

    <style>
        .emi-layout {
            display: grid;
            grid-template-columns: 1fr 1.15fr;
            gap: 2rem;
            align-items: start;
        }

        .emi-card {
            background: var(--bg-primary, #fff);
            padding: 2.25rem;
            border: 1px solid var(--border, #EAEAEA);
            border-radius: 10px;
            box-shadow: 0 4px 18px rgba(0, 0, 0, 0.04);
        }

        .emi-card-head {
            display: flex;
            align-items: center;
            gap: 12px;
            margin-bottom: 1.75rem;
        }

        .emi-card-icon {
            width: 38px;
            height: 38px;
            border-radius: 9px;
            background: #f3efe8;
            color: var(--accent, #a3875a);
            display: flex;
            align-items: center;
            justify-content: center;
            flex-shrink: 0;
        }

            .emi-card-icon svg {
                width: 19px;
                height: 19px;
            }

        .emi-card-head h3 {
            margin: 0;
            font-size: 1.2rem;
            font-weight: 700;
            color: #222;
        }

        .emi-group {
            margin-bottom: 1.4rem;
        }

        .emi-label {
            display: block;
            font-size: 0.72rem;
            font-weight: 700;
            letter-spacing: 0.6px;
            text-transform: uppercase;
            color: var(--text-secondary, #888);
            margin-bottom: 0.55rem;
        }

        .emi-control {
            width: 100%;
            padding: 13px 14px;
            border: 1px solid var(--border, #ddd);
            border-radius: 7px;
            font-size: 14.5px;
            box-sizing: border-box;
            background: #fff;
            transition: border-color 0.18s ease, box-shadow 0.18s ease;
        }

            .emi-control:focus {
                outline: none;
                border-color: var(--accent, #a3875a);
                box-shadow: 0 0 0 3px rgba(163, 135, 90, 0.14);
            }

        .emi-input-wrap {
            position: relative;
        }

            .emi-input-wrap .emi-suffix {
                position: absolute;
                right: 14px;
                top: 50%;
                transform: translateY(-50%);
                font-size: 13px;
                color: #999;
                pointer-events: none;
            }

            .emi-input-wrap .emi-control {
                padding-right: 42px;
            }

        .emi-row {
            display: grid;
            grid-template-columns: 1fr 1fr 1fr;
            gap: 1rem;
        }

        .emi-message {
            display: flex;
            align-items: center;
            gap: 8px;
            margin-bottom: 1.4rem;
            padding: 12px 14px;
            border-radius: 7px;
            font-size: 13.5px;
            font-weight: 500;
            background: #fbecec;
            color: #9b2c2c;
            border: 1px solid #e5bcbc;
        }

        .emi-hint {
            display: flex;
            flex-direction: column;
            align-items: center;
            text-align: center;
            gap: 14px;
            color: var(--text-secondary, #888);
            font-size: 0.9rem;
            padding: 3rem 1rem;
        }

            .emi-hint svg {
                width: 40px;
                height: 40px;
                color: #d8d2c6;
            }

        .emi-submit-btn {
            width: 100%;
            padding: 14px;
            font-size: 14px;
            letter-spacing: 0.4px;
        }

        .emi-highlight {
            padding: 1.75rem;
            margin-bottom: 1.5rem;
            text-align: center;
            border-radius: 10px;
            background: linear-gradient(135deg, #1c1c1c, #2a2a2a);
        }

            .emi-highlight span {
                display: block;
                font-size: 0.72rem;
                letter-spacing: 0.7px;
                text-transform: uppercase;
                color: #bdb6a8;
            }

            .emi-highlight strong {
                display: block;
                margin-top: 0.5rem;
                font-size: 2.5rem;
                font-weight: 700;
                color: #d8bc8a;
            }

            .emi-highlight small {
                display: block;
                margin-top: 0.3rem;
                font-size: 0.78rem;
                color: #8d887c;
            }

        .emi-stats {
            display: grid;
            grid-template-columns: 1fr 1fr 1fr;
            gap: 0.85rem;
            margin-bottom: 2rem;
        }

        .emi-stat {
            padding: 1rem 0.85rem;
            border: 1px solid var(--border, #EAEAEA);
            border-radius: 8px;
            background: #fafaf8;
        }

            .emi-stat span {
                display: block;
                font-size: 0.66rem;
                font-weight: 700;
                letter-spacing: 0.5px;
                text-transform: uppercase;
                color: var(--text-secondary, #999);
            }

            .emi-stat strong {
                display: block;
                margin-top: 0.4rem;
                font-size: 1.1rem;
                color: #222;
            }

        .emi-schedule-title {
            display: flex;
            align-items: center;
            gap: 8px;
            margin: 0 0 1rem;
            font-size: 0.95rem;
            font-weight: 700;
            color: #333;
        }

        .emi-table {
            width: 100%;
            border-collapse: collapse;
        }

        .emi-grid-header th {
            background-color: #FAFAFA;
            color: #555;
            padding: 11px 10px;
            text-align: left;
            font-size: 11.5px;
            font-weight: 700;
            letter-spacing: 0.3px;
            text-transform: uppercase;
            border-bottom: 2px solid #EAEAEA;
        }

        .emi-grid-row td {
            padding: 11px 10px;
            border-bottom: 1px solid #EEEEEE;
            font-size: 13px;
            color: #333;
        }

            .emi-grid-row:hover td {
                background: #fafaf7;
            }

        .emi-schedule {
            overflow-x: auto;
            border: 1px solid var(--border, #EAEAEA);
            border-radius: 8px;
        }

            .emi-schedule .emi-table {
                border: none;
            }

        @media (max-width: 900px) {
            .emi-layout {
                grid-template-columns: 1fr;
            }

            .emi-row,
            .emi-stats {
                grid-template-columns: 1fr;
            }

            .emi-card {
                padding: 1.5rem;
            }

            .emi-highlight strong {
                font-size: 2rem;
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

                    <div class="emi-card-head">
                        <div class="emi-card-icon">
                            <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><rect x="2" y="5" width="20" height="14" rx="2"></rect><line x1="2" y1="10" x2="22" y2="10"></line></svg>
                        </div>
                        <h3>Loan Details</h3>
                    </div>

                    <asp:Label ID="lblMessage" runat="server" Visible="false" CssClass="emi-message"></asp:Label>

                    <div class="emi-group">
                        <label class="emi-label">Residence</label>
                        <asp:DropDownList ID="ddlProperty" runat="server" CssClass="emi-control" AutoPostBack="true" OnSelectedIndexChanged="ddlProperty_SelectedIndexChanged">
                        </asp:DropDownList>
                    </div>

                    <div class="emi-group">
                        <label class="emi-label">Property Price</label>
                        <div class="emi-input-wrap">
                            <asp:TextBox ID="txtPrice" runat="server" CssClass="emi-control"></asp:TextBox>
                            <span class="emi-suffix">USD</span>
                        </div>
                    </div>

                    <div class="emi-row">

                        <div class="emi-group">
                            <label class="emi-label">Down Payment</label>
                            <div class="emi-input-wrap">
                                <asp:TextBox ID="txtDownPayment" runat="server" CssClass="emi-control"></asp:TextBox>
                                <span class="emi-suffix">%</span>
                            </div>
                        </div>

                        <div class="emi-group">
                            <label class="emi-label">Interest / Year</label>
                            <div class="emi-input-wrap">
                                <asp:TextBox ID="txtRate" runat="server" CssClass="emi-control"></asp:TextBox>
                                <span class="emi-suffix">%</span>
                            </div>
                        </div>

                        <div class="emi-group">
                            <label class="emi-label">Tenure</label>
                            <div class="emi-input-wrap">
                                <asp:TextBox ID="txtTenure" runat="server" CssClass="emi-control"></asp:TextBox>
                                <span class="emi-suffix">yrs</span>
                            </div>
                        </div>

                    </div>

                    <asp:Button ID="btnCalculate" runat="server" Text="Calculate EMI" CssClass="btn btn-primary emi-submit-btn" OnClick="btnCalculate_Click" />

                </div>


                <div class="emi-card">

                    <div class="emi-card-head">
                        <div class="emi-card-icon">
                            <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><line x1="12" y1="1" x2="12" y2="23"></line><path d="M17 5H9.5a3.5 3.5 0 0 0 0 7h5a3.5 3.5 0 0 1 0 7H6"></path></svg>
                        </div>
                        <h3>Your Installment</h3>
                    </div>

                    <asp:Panel ID="pnlEmpty" runat="server">
                        <div class="emi-hint">
                            <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.5" stroke-linecap="round" stroke-linejoin="round"><rect x="3" y="4" width="18" height="18" rx="2"></rect><line x1="16" y1="2" x2="16" y2="6"></line><line x1="8" y1="2" x2="8" y2="6"></line><line x1="3" y1="10" x2="21" y2="10"></line></svg>
                            <span>Fill in the loan details and press Calculate EMI to see your monthly payment and full amortization schedule.</span>
                        </div>
                    </asp:Panel>

                    <asp:Panel ID="pnlResult" runat="server" Visible="false">

                        <div class="emi-highlight">
                            <span>Monthly EMI</span>
                            <strong><asp:Literal ID="litEmi" runat="server"></asp:Literal></strong>
                            <small>Principal + Interest, every month</small>
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

                        <h4 class="emi-schedule-title">
                            <svg width="15" height="15" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><line x1="8" y1="6" x2="21" y2="6"></line><line x1="8" y1="12" x2="21" y2="12"></line><line x1="8" y1="18" x2="21" y2="18"></line><line x1="3" y1="6" x2="3.01" y2="6"></line><line x1="3" y1="12" x2="3.01" y2="12"></line><line x1="3" y1="18" x2="3.01" y2="18"></line></svg>
                            Year-by-Year Breakdown
                        </h4>

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