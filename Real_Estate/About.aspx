<%@ Page Title="About Us" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" %>

<asp:Content ID="Content1" ContentPlaceHolderID="HeadContent" runat="server">
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">

    <section class="section-padding" id="about">
        <div class="container">
            <div class="about-wrapper">
                <div class="about-img-box reveal">

                    <img src="https://images.unsplash.com/photo-1600607686527-6fb886090705?auto=format&fit=crop&w=800&q=80" alt="Architectural detail" class="about-img" loading="lazy">
                </div>

                <div class="about-content reveal">
                    <div class="section-header" style="text-align: left; margin-bottom: 2rem;">
                        <span>Our Philosophy</span>
                        <h2>Pioneers in Architectural Curation</h2>
                    </div>
                    <p>We view homes not merely as real estate assets, but as living sculptures framing peace and clarity. Every property in our catalog is vetted for spatial harmony, structural integrity, and peaceful living.</p>

                    <div class="values-accordion">
                        <div class="accordion-item active">
                            <button type="button" class="accordion-header">
                                <span>Absolute Confidentiality</span>
                                <svg class="accordion-icon" viewBox="0 0 24 24">
                                    <polyline points="6 9 12 15 18 9"></polyline></svg>
                            </button>
                            <div class="accordion-content">
                                <div class="accordion-content-inner">
                                    Off-market transactions conducted under strict non-disclosure safeguards to protect client identity and financial privacy.
                                </div>
                            </div>
                        </div>

                        <div class="accordion-item">
                            <button type="button" class="accordion-header">
                                <span>Architectural Distinction</span>
                                <svg class="accordion-icon" viewBox="0 0 24 24">
                                    <polyline points="6 9 12 15 18 9"></polyline></svg>
                            </button>
                            <div class="accordion-content">
                                <div class="accordion-content-inner">
                                    We exclusively represent properties that exhibit timeless design principles, natural materials, and seamless environmental integration.
                                </div>
                            </div>
                        </div>

                        <div class="accordion-item">
                            <button type="button" class="accordion-header">
                                <span>Bespoke Global Advisory</span>
                                <svg class="accordion-icon" viewBox="0 0 24 24">
                                    <polyline points="6 9 12 15 18 9"></polyline></svg>
                            </button>
                            <div class="accordion-content">
                                <div class="accordion-content-inner">
                                    Dedicated real estate advisors available globally to manage viewings, legal due diligence, and white-glove closing.
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </section>

</asp:Content>