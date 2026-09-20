<%@ Page Title="Reviews" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" %>

<asp:Content ID="Content1" ContentPlaceHolderID="HeadContent" runat="server">
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">

    <section class="section-padding" id="testimonials" style="min-height: 80vh;">
        <div class="container">
            <div class="section-header reveal">
                <span>Client Stories</span>
                <h2>Endorsements from Discerning Clients</h2>
            </div>

            <div class="testimonials-grid">
                <div class="testimonial-card reveal">
                    <p class="testimonial-text">"Acquiring our cliffside sanctuary in Positano was an exercise in effortless discretion. Their international coverage across 15 countries is truly impressive."</p>
                    <div class="testimonial-author">
                        <div class="author-avatar">LD</div>
                        <div class="author-info">
                            <h5 style="font-size: 0.95rem; font-weight: 600; margin-bottom: 0.1rem;">Lars Davidson</h5>
                            <p style="font-size: 0.775rem; color: var(--text-muted); margin: 0;">Technology Founder & Collector</p>
                        </div>
                    </div>
                </div>

                <div class="testimonial-card reveal">
                    <p class="testimonial-text">"As an architect, spatial purity is non-negotiable. RealEstate presented townhouses and penthouses that respected material integrity and modern minimalism."</p>
                    <div class="testimonial-author">
                        <div class="author-avatar">AK</div>
                        <div class="author-info">
                            <h5 style="font-size: 0.95rem; font-weight: 600; margin-bottom: 0.1rem;">Aria Kozlov</h5>
                            <p style="font-size: 0.775rem; color: var(--text-muted); margin: 0;">Principal Interior Designer</p>
                        </div>
                    </div>
                </div>

                <div class="testimonial-card reveal">
                    <p class="testimonial-text">"From the Kyoto viewing to escrow completion, the process felt more like working with an international high-end art gallery than a typical broker."</p>
                    <div class="testimonial-author">
                        <div class="author-avatar">RB</div>
                        <div class="author-info">
                            <h5 style="font-size: 0.95rem; font-weight: 600; margin-bottom: 0.1rem;">Rachel Bennett</h5>
                            <p style="font-size: 0.775rem; color: var(--text-muted); margin: 0;">Portfolio Manager</p>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </section>

</asp:Content>
