<%@ Page Title="Property Inquiry" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="Inquiry.aspx.cs" Inherits="Real_Estate.Inquiry" %>

<asp:Content ID="Content1" ContentPlaceHolderID="HeadContent" runat="server">

    <style>
        .inquiry-container {
            max-width: 550px;
            margin: 50px auto;
            padding: 35px;
            background: #fff;
            border: 1px solid #EAEAEA;
            border-radius: 4px;
        }

        .inquiry-title {
            color: #111111;
            margin-top: 0;
            margin-bottom: 5px;
            font-size: 22px;
        }

        .inquiry-desc {
            color: #777777;
            margin-bottom: 30px;
            font-size: 14px;
        }

        .form-group {
            margin-bottom: 20px;
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
            box-sizing: border-box;
        }

        .form-control-readonly {
            background-color: #f9f9f9;
            color: #777;
        }

        .btn-gold {
            width: 100%;
            background: #d4af37;
            color: #111827;
            padding: 14px;
            border: none;
            border-radius: 4px;
            cursor: pointer;
            font-size: 15px;
            font-weight: bold;
            margin-top: 15px;
        }

            .btn-gold:hover {
                background: #c19b2e;
            }

        .inquiry-message {
            display: block;
            margin-bottom: 20px;
            padding: 10px 12px;
            border-radius: 4px;
            font-size: 14px;
        }

        .success-message {
            background: #edf7ed;
            color: #2e6b2e;
            border: 1px solid #c8e6c9;
        }

        .error-message {
            background: #fbecec;
            color: #9b2c2c;
            border: 1px solid #e5bcbc;
        }

        .inquiry-change {
            display: inline-block;
            margin-top: 8px;
            font-size: 13px;
            color: #8a6d1a;
        }

        select.form-control:disabled {
            background-color: #f9f9f9;
            color: #555;
        }
    </style>

</asp:Content>


<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">

    <div class="inquiry-container">

        <h2 class="inquiry-title">Send an Inquiry
        </h2>

        <p class="inquiry-desc">
            Share your contact details and the property you like. The property's agent will call you to discuss the next steps.
        </p>


        <asp:Label ID="lblMessage" runat="server" Visible="false" CssClass="inquiry-message"></asp:Label>

        <div class="form-group">

            <label class="form-label" for="<%= txtName.ClientID %>">FULL NAME</label>

            <asp:TextBox ID="txtName" runat="server" CssClass="form-control" MaxLength="100" placeholder="Your full name"></asp:TextBox>

        </div>


        <div class="form-group">

            <label class="form-label" for="<%= txtEmail.ClientID %>">EMAIL</label>

            <asp:TextBox ID="txtEmail" runat="server" TextMode="Email" CssClass="form-control" MaxLength="150" placeholder="you@example.com"></asp:TextBox>

        </div>


        <div class="form-group">

            <label class="form-label" for="<%= txtPhone.ClientID %>">MOBILE NUMBER</label>

            <asp:TextBox ID="txtPhone" runat="server" TextMode="Phone" CssClass="form-control" MaxLength="20" placeholder="Mobile number"></asp:TextBox>

        </div>


        <div class="form-group">

            <label class="form-label" for="<%= ddlProperty.ClientID %>">PROPERTY INTERESTED IN</label>

            <asp:DropDownList ID="ddlProperty" runat="server" CssClass="form-control"></asp:DropDownList>

            <asp:HyperLink ID="hlChangeProperty" runat="server" NavigateUrl="~/Inquiry.aspx" Visible="false" CssClass="inquiry-change">Inquire about a different property</asp:HyperLink>

        </div>


        <div class="form-group">

            <label class="form-label" for="<%= txtMessage.ClientID %>">YOUR MESSAGE</label>

            <asp:TextBox ID="txtMessage" runat="server" TextMode="MultiLine" Rows="4" MaxLength="1000" CssClass="form-control" placeholder="Tell the agent what you would like to know, or when you are free for a call..."></asp:TextBox>

        </div>

        <asp:Button ID="btnSubmitInquiry" runat="server" Text="Submit Inquiry" CssClass="btn-gold" OnClick="btnSubmitInquiry_Click" />

    </div>

</asp:Content>
