<%@ Page Title="Advisory Services" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" %>

<asp:Content ID="Content1" ContentPlaceHolderID="HeadContent" runat="server">
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">

    <section class="section-padding" id="services" style="background-color: var(--bg-secondary); min-height: 80vh;">
        <div class="container">
            <div class="section-header reveal">
                <span>Our Discipline</span>
                <h2>Private Advisory Services</h2>
                <p>Tailored guidance for acquiring, valuing, and managing architectural real estate worldwide.</p>
            </div>

            <div class="services-grid">
                <div class="service-card reveal">
                    <div class="service-icon">
                        <svg viewBox="0 0 24 24">
                            <path d="M3 9l9-7 9 7v11a2 2 0 0 1-2 2H5a2 2 0 0 1-2-2z"></path></svg>
                    </div>
                    <h3>Global Acquisitions</h3>
                    <p>Private representation for acquiring rare architectural works across 15+ premier international markets.</p>
                </div>

                <div class="service-card reveal">
                    <div class="service-icon">
                        <svg viewBox="0 0 24 24">
                            <rect x="3" y="3" width="18" height="18" rx="2"></rect><line x1="3" y1="9" x2="21" y2="9"></line></svg>
                    </div>
                    <h3>Editorial Marketing</h3>
                    <p>Bespoke visual campaigns showcasing spatial purity, materials craftsmanship, and architectural provenance.</p>
                </div>

                <div class="service-card reveal">
                    <div class="service-icon">
                        <svg viewBox="0 0 24 24">
                            <polygon points="12 2 2 7 12 12 22 7 12 2"></polygon><polyline points="2 17 12 22 22 17"></polyline></svg>
                    </div>
                    <h3>Private Valuation</h3>
                    <p>Data-grounded valuations capturing micro-location rarity, architectural lineage, and material quality.</p>
                </div>

                <div class="service-card reveal">
                    <div class="service-icon">
                        <svg viewBox="0 0 24 24">
                            <path d="M17 21v-2a4 4 0 0 0-4-4H5a4 4 0 0 0-4 4v2"></path><circle cx="9" cy="7" r="4"></circle></svg>
                    </div>
                    <h3>Asset Management</h3>
                    <p>Discreet family office and high-net-worth real estate asset management across global destinations.</p>
                </div>
            </div>
        </div>
    </section>

</asp:Content>
