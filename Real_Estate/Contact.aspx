<%@ Page Title="Contact Us" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="Contact.aspx.cs" Inherits="Real_Estate.Contact" %>

<asp:Content ID="Content1" ContentPlaceHolderID="HeadContent" runat="server">
    <style>
        /* Premium Contact Page Styling */
        .contact-hero {
            max-width: 950px;
            margin: 80px auto;
            padding: 50px;
            background: #ffffff;
            border-radius: 12px;
            box-shadow: 0 10px 40px rgba(0, 0, 0, 0.04);
            text-align: center;
            font-family: 'Inter', sans-serif;
        }

        .contact-title {
            color: #111111;
            font-size: 36px;
            font-weight: 600;
            margin-bottom: 15px;
            letter-spacing: -0.5px;
        }

        .contact-desc {
            color: #666666;
            font-size: 16px;
            margin-bottom: 50px;
            font-weight: 300;
        }

        .contact-grid {
            display: flex;
            justify-content: space-between;
            gap: 25px;
            flex-wrap: wrap;
        }

        /* Individual Contact Cards */
        .contact-method {
            flex: 1;
            min-width: 240px;
            padding: 40px 20px;
            background: #FAFAFA;
            border: 1px solid #EAEAEA;
            border-radius: 8px;
            transition: all 0.3s ease;
        }

            .contact-method:hover {
                transform: translateY(-5px);
                box-shadow: 0 12px 24px rgba(0, 0, 0, 0.06);
                border-color: #d4af37; /* Gold accent on hover */
                background: #ffffff;
            }

        /* Icon Container */
        .icon-wrapper {
            width: 55px;
            height: 55px;
            margin: 0 auto 20px auto;
            background: #111827; /* Dark slate */
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            box-shadow: 0 4px 10px rgba(0,0,0,0.1);
        }

            .icon-wrapper svg {
                width: 20px;
                height: 20px;
                fill: #d4af37; /* Gold icon */
            }

        .method-title {
            font-size: 12px;
            font-weight: 700;
            color: #888888;
            text-transform: uppercase;
            letter-spacing: 1.5px;
            margin-bottom: 12px;
        }

        .method-detail {
            color: #111111;
            font-size: 16px;
            font-weight: 500;
            line-height: 1.6;
        }
    </style>
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">
    <div class="contact-hero">
        <h2 class="contact-title">Get In Touch</h2>
        <p class="contact-desc">Connect with our senior advisory desk for personalized assistance.</p>

        <div class="contact-grid">

            <!-- Phone Card -->
            <div class="contact-method">
                <div class="icon-wrapper">
                    <!-- Inline SVG guarantees the icon loads -->
                    <svg viewBox="0 0 512 512" xmlns="http://www.w3.org/2000/svg">
                        <path d="M164.9 24.6c-7.7-18.6-28-28.5-47.4-23.2l-88 24C12.1 30.2 0 46 0 64C0 311.4 200.6 512 448 512c18 0 33.8-12.1 38.6-29.5l24-88c5.3-19.4-4.6-39.7-23.2-47.4l-96-40c-16.3-6.8-35.2-2.1-46.3 11.6L304.7 368C234.3 334.7 177.3 277.7 144 207.3L193.3 167c13.7-11.2 18.4-30 11.6-46.3l-40-96z" />
                    </svg>
                </div>
                <div class="method-title">Call Us</div>
                <div class="method-detail">+1 (555) 123-4567</div>
            </div>

            <!-- Email Card -->
            <div class="contact-method">
                <div class="icon-wrapper">
                    <svg viewBox="0 0 512 512" xmlns="http://www.w3.org/2000/svg">
                        <path d="M48 64C21.5 64 0 85.5 0 112c0 15.1 7.1 29.3 19.2 38.4L236.8 313.6c11.4 8.5 27 8.5 38.4 0L492.8 150.4c12.1-9.1 19.2-23.3 19.2-38.4c0-26.5-21.5-48-48-48H48zM0 176V384c0 35.3 28.7 64 64 64H448c35.3 0 64-28.7 64-64V176L294.4 339.2c-22.8 17.1-54 17.1-76.8 0L0 176z" />
                    </svg>
                </div>
                <div class="method-title">Email Us</div>
                <div class="method-detail">admin@realestate.luxury</div>
            </div>

            <!-- Location Card -->
            <div class="contact-method">
                <div class="icon-wrapper">
                    <svg viewBox="0 0 384 512" xmlns="http://www.w3.org/2000/svg">
                        <path d="M215.7 499.2C267 435 384 279.4 384 192C384 86 298 0 192 0S0 86 0 192c0 87.4 117 243 168.3 307.2c12.3 15.3 35.1 15.3 47.4 0zM192 128a64 64 0 1 1 0 128 64 64 0 1 1 0-128z" />
                    </svg>
                </div>
                <div class="method-title">Visit Us</div>
                <div class="method-detail">123 Luxury Lane<br />
                    Metropolis, NY</div>
            </div>

        </div>
    </div>
</asp:Content>