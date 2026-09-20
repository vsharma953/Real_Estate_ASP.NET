<%@ Page Title="Home" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" %>

<asp:Content ID="Content1" ContentPlaceHolderID="HeadContent" runat="server">

</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">
    
    <section class="hero" id="home">
        <div class="hero-overlay"></div>
        <div class="container" style="width: 100%;">
            <div class="hero-content reveal" style="margin: 0 auto; text-align: center;">
                <span class="hero-tagline">International Sanctuaries</span>
                <h1 style="font-size: 3.5rem; margin-bottom: 1.5rem; color: #ffffff;">Architectural Living Across <span>Unique Countries</span></h1>
                <p style="font-size: 1.15rem; margin-bottom: 2.5rem; color: rgba(255, 255, 255, 0.88); max-width: 640px; margin-left: auto; margin-right: auto;">
                    Explore Luxury Villas, Skyline Penthouses, and Zen Townhouses spanning iconic global destinations. Each listing features and architectural gallery.
                </p>
                <div class="hero-buttons" style="display: flex; gap: 1.25rem; justify-content: center;">
                    <a href="Properties.aspx" class="btn btn-accent">Explore Residences</a>
                    <a href="About.aspx" class="btn btn-outline" style="color: #ffffff; border-color: rgba(255,255,255,0.4);">Our Philosophy</a>
                </div>
            </div>
        </div>
    </section>

    <section class="stats-strip" id="stats-strip">
        <div class="container">
            <div class="stats-grid">
                <div class="stat-item reveal">
                    <h3 class="stat-number" data-target="15">0</h3>
                    <p>Unique International Homes</p>
                </div>
                <div class="stat-item reveal">
                    <h3 class="stat-number" data-target="15">0</h3>
                    <p>Global Destinations</p>
                </div>
                <div class="stat-item reveal">
                    <h3 class="stat-number" data-target="45">0</h3>
                    <p>Photos Per Listing</p>
                </div>
                <div class="stat-item reveal">
                    <h3 class="stat-number" data-target="100" data-suffix="%">0</h3>
                    <p>Off-Market Discretion</p>
                </div>
            </div>
        </div>
    </section>

</asp:Content>