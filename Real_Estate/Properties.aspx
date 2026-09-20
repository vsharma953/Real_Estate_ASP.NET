<%@ Page Title="Residences" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="Properties.aspx.cs" Inherits="Real_Estate.Properties" MaintainScrollPositionOnPostBack="true" %>

<asp:Content ID="Content1" ContentPlaceHolderID="HeadContent" runat="server">
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">

    <section class="section-padding" id="properties">

        <div class="container">

            <div class="section-header reveal">
                <span>International Portfolio</span>
                <h2>Distinctive Global Sanctuaries</h2>
                <p>Featuring Villas, Penthouses, and Townhouses across unique countries.</p>
            </div>

            <div class="properties-filter reveal">

                <asp:LinkButton ID="lnkAll" runat="server" CssClass="filter-btn active"
                    CommandName="Filter" CommandArgument="all" OnCommand="Filter_Command"
                    CausesValidation="false">All Residences</asp:LinkButton>

                <asp:LinkButton ID="lnkVilla" runat="server" CssClass="filter-btn"
                    CommandName="Filter" CommandArgument="villa" OnCommand="Filter_Command"
                    CausesValidation="false">Villas</asp:LinkButton>

                <asp:LinkButton ID="lnkPenthouse" runat="server" CssClass="filter-btn"
                    CommandName="Filter" CommandArgument="penthouse" OnCommand="Filter_Command"
                    CausesValidation="false">Penthouses</asp:LinkButton>

                <asp:LinkButton ID="lnkTownhouse" runat="server" CssClass="filter-btn"
                    CommandName="Filter" CommandArgument="townhouse" OnCommand="Filter_Command"
                    CausesValidation="false">Townhouses</asp:LinkButton>

            </div>

            <%-- DataList has no EmptyDataTemplate (that belongs to GridView/ListView),
                 so the "nothing listed" message is a normal Label shown from code-behind. --%>
            <asp:Panel ID="pnlEmpty" runat="server" Visible="false" CssClass="properties-empty">
                <p>
                    <asp:Label ID="lblEmpty" runat="server" Text="No residences have been listed yet. Please check back soon."></asp:Label>
                </p>
            </asp:Panel>

            <asp:DataList ID="dlProperties" runat="server" RepeatLayout="Flow" CssClass="properties-grid">

                <ItemTemplate>

                    <div class="property-card"
                        data-type='<%#: Eval("PropertyType") %>'
                        data-title='<%#: Eval("Title") %>'
                        data-location='<%#: Eval("Location") %>'
                        data-price='<%#: FormatPrice(Eval("Price")) %>'
                        data-bedrooms='<%#: Eval("Bedrooms") %>'
                        data-bathrooms='<%#: Eval("Bathrooms") %>'
                        data-area='<%#: FormatArea(Eval("Area")) %>'
                        data-description='<%#: Eval("Description") %>'
                        data-photo1='<%#: Photo(Eval("Photo1")) %>'
                        data-photo2='<%#: Photo(Eval("Photo2")) %>'
                        data-photo3='<%#: Photo(Eval("Photo3")) %>'>

                        <div class="property-image-wrapper">

                            <div class="property-badge-row">
                                <span class="property-tag"><%#: TypeLabel(Eval("PropertyType"), Eval("Status")) %></span>
                                <span class="photo-count-badge">
                                    <svg viewBox="0 0 24 24"><path d="M23 19a2 2 0 0 1-2 2H3a2 2 0 0 1-2-2V8a2 2 0 0 1 2-2h4l2-3h6l2 3h4a2 2 0 0 1 2 2z" /><circle cx="12" cy="13" r="4" /></svg>
                                    <%#: PhotoCount(Eval("Photo1"), Eval("Photo2"), Eval("Photo3")) %>
                                </span>
                            </div>

                            <img src='<%#: MainPhoto(Eval("Photo1"), Eval("Photo2"), Eval("Photo3")) %>'
                                alt='<%#: Eval("Title") %>'
                                class="property-img card-main-img"
                                loading="lazy" />

                            <div class="property-price"><%#: FormatPrice(Eval("Price")) %></div>

                        </div>

                        <div class="property-body">

                            <h3 class="property-title"><%#: Eval("Title") %></h3>

                            <div class="property-location">
                                <svg viewBox="0 0 24 24"><path d="M21 10c0 7-9 13-9 13s-9-6-9-13a9 9 0 0 1 18 0z"></path><circle cx="12" cy="10" r="3"></circle></svg>
                                <span><%#: Eval("Location") %></span>
                            </div>

                            <div class="property-gallery-thumbs">
                                <%# Thumbs(Eval("Photo1"), Eval("Photo2"), Eval("Photo3")) %>
                            </div>

                            <div class="property-features">
                                <div class="feature-item">
                                    <svg viewBox="0 0 24 24" fill="none" stroke="var(--accent)" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><path d="M3 7v11"></path><path d="M3 14h18"></path><path d="M21 18v-8a2 2 0 0 0-2-2H8a2 2 0 0 0-2 2v6"></path><circle cx="7" cy="10" r="1"></circle></svg>
                                    <span><%#: Eval("Bedrooms") %> Beds</span>
                                </div>
                                <div class="feature-item">
                                    <svg viewBox="0 0 24 24" fill="none" stroke="var(--accent)" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><path d="M4 11h16v5a4 4 0 0 1-4 4H8a4 4 0 0 1-4-4v-5z"></path><path d="M9 11V6a2 2 0 0 1 2-2h2a2 2 0 0 1 2 2v5"></path><circle cx="12" cy="7" r="1"></circle></svg>
                                    <span><%#: Eval("Bathrooms") %> Baths</span>
                                </div>
                            </div>

                            <button type="button" class="btn btn-outline property-cta view-details-btn">Explore Residence</button>

                        </div>

                    </div>

                </ItemTemplate>

            </asp:DataList>

        </div>

    </section>

    <div class="modal-overlay" id="details-modal">

        <div class="modal-container">

            <button type="button" class="modal-close-btn" id="modal-close-btn">

                <svg viewBox="0 0 24 24" width="20" height="20" stroke="currentColor" stroke-width="2" fill="none">

                    <line x1="18" y1="6" x2="6" y2="18"></line>
                    <line x1="6" y1="6" x2="18" y2="18"></line>

                </svg>

            </button>

            <div class="modal-hero">

                <img id="modal-hero-img" src="data:image/gif;base64,R0lGODlhAQABAAAAACH5BAEKAAEALAAAAAABAAEAAAICTAEAOw==" alt="Property" class="modal-hero-img" />

            </div>

            <div class="modal-gallery-bar" id="modal-gallery-bar">
            </div>

            <div class="modal-content">

                <div class="modal-info-header"
                    style="display: flex; justify-content: space-between; margin-bottom: 1.5rem;">

                    <div>

                        <h3 id="modal-title" style="font-size: 1.85rem; font-weight: 700;"></h3>

                        <div class="property-location">
                            <span id="modal-loc"></span>
                        </div>

                    </div>

                    <div id="modal-price" style="font-size: 1.75rem; font-weight: 700; color: var(--accent);">
                    </div>

                </div>

                <div class="modal-specs" style="display: flex; gap: 2.5rem; padding: 1.25rem 0; border-top: 1px solid var(--border); border-bottom: 1px solid var(--border); margin-bottom: 1.75rem;">

                    <div>
                        <span id="modal-beds"></span>
                    </div>

                    <div>
                        <span id="modal-baths"></span>
                    </div>

                    <div id="modal-area-wrap">
                        <span id="modal-area"></span>
                    </div>

                </div>

                <div class="modal-description">

                    <p id="modal-desc" style="color: var(--text-secondary); line-height: 1.65;"></p>

                </div>

                <div style="margin-top: 1.5rem;">

                    <a href="Inquiry.aspx" class="btn btn-primary" id="modal-inquire-direct-btn">Inquire About This Residence</a>

                </div>

            </div>

        </div>

    </div>


    <script>

        document.addEventListener("DOMContentLoaded", function () {

            var modal = document.getElementById("details-modal");
            var closeBtn = document.getElementById("modal-close-btn");
            var modalImage = document.getElementById("modal-hero-img");
            var gallery = document.getElementById("modal-gallery-bar");

            function setText(id, value) {
                document.getElementById(id).innerText = value || "";
            }

            function openModal(card) {

                var d = card.dataset;

                setText("modal-title", d.title);
                setText("modal-loc", d.location);
                setText("modal-price", d.price);
                setText("modal-beds", d.bedrooms ? d.bedrooms + " Beds" : "");
                setText("modal-baths", d.bathrooms ? d.bathrooms + " Baths" : "");
                setText("modal-area", d.area);
                setText("modal-desc", d.description);

                document.getElementById("modal-area-wrap").style.display = d.area ? "" : "none";

                var photos = [d.photo1, d.photo2, d.photo3].filter(function (p) {
                    return p && p.length > 0;
                });

                if (photos.length === 0) {
                    photos = [card.querySelector(".card-main-img").src];
                }

                modalImage.src = photos[0];
                modalImage.alt = d.title || "Property";

                gallery.innerHTML = "";

                photos.forEach(function (photo, index) {

                    var img = document.createElement("img");

                    img.src = photo;
                    img.className = "modal-gallery-thumb";

                    if (index === 0) {
                        img.classList.add("active");
                    }

                    img.onclick = function () {

                        modalImage.src = photo;

                        gallery.querySelectorAll("img").forEach(function (item) {
                            item.classList.remove("active");
                        });

                        img.classList.add("active");

                    };

                    gallery.appendChild(img);

                });

                document.getElementById("modal-inquire-direct-btn").href =
                    "Inquiry.aspx?Property=" + encodeURIComponent(d.title || "");

                modal.classList.add("active");
                document.body.style.overflow = "hidden";
            }

            function closeModal() {
                modal.classList.remove("active");
                document.body.style.overflow = "";
            }

            document.querySelectorAll(".property-card").forEach(function (card) {

                var mainImage = card.querySelector(".card-main-img");
                var thumbnails = card.querySelectorAll(".thumb-preview");
                var detailsBtn = card.querySelector(".view-details-btn");

                thumbnails.forEach(function (thumb) {

                    thumb.addEventListener("click", function () {

                        mainImage.src = thumb.src;

                        thumbnails.forEach(function (item) {
                            item.classList.remove("active");
                        });

                        thumb.classList.add("active");

                    });

                });

                mainImage.addEventListener("click", function () {
                    openModal(card);
                });

                if (detailsBtn) {
                    detailsBtn.addEventListener("click", function () {
                        openModal(card);
                    });
                }

            });

            closeBtn.onclick = closeModal;

            modal.onclick = function (e) {
                if (e.target === modal) {
                    closeModal();
                }
            };

            document.addEventListener("keydown", function (e) {
                if (e.key === "Escape") {
                    closeModal();
                }
            });

        });

    </script>

    <style>
        /* DataList (Flow layout) puts a <br /> after each item - hide it so the CSS grid stays clean */
        .properties-grid br {
            display: none;
        }

        .properties-grid {
            display: grid;
            width: 100%;
        }

        a.filter-btn {
            display: inline-block;
            text-decoration: none;
            cursor: pointer;
        }

        .properties-empty p {
            text-align: center;
            color: var(--text-muted, #777);
            padding: 3rem 0;
        }

        .property-cta {
            margin-top: 1.25rem;
            text-align: center;
        }

        .card-main-img {
            cursor: pointer;
        }

        .modal-overlay {
            display: none;
            position: fixed;
            inset: 0;
            background: rgba(0,0,0,.75);
            z-index: 9999;
            align-items: center;
            justify-content: center;
            padding: 20px;
        }

            .modal-overlay.active {
                display: flex;
            }

        .modal-container {
            width: 90%;
            max-width: 900px;
            max-height: 90vh;
            overflow-y: auto;
            background: var(--bg-primary,#fff);
            border-radius: 10px;
            position: relative;
        }

        .modal-hero {
            height: 450px;
            overflow: hidden;
        }

        .modal-hero-img {
            width: 100%;
            height: 100%;
            object-fit: cover;
        }

        .modal-gallery-bar {
            display: flex;
            gap: 10px;
            padding: 12px;
        }

        .modal-gallery-thumb {
            width: 80px;
            height: 60px;
            object-fit: cover;
            cursor: pointer;
            opacity: .6;
            border: 2px solid transparent;
        }

            .modal-gallery-thumb.active {
                opacity: 1;
                border-color: var(--accent);
            }

        .modal-close-btn {
            position: absolute;
            right: 15px;
            top: 15px;
            z-index: 2;
            width: 40px;
            height: 40px;
            border: 0;
            border-radius: 50%;
            background: rgba(0,0,0,.7);
            color: white;
            cursor: pointer;
        }
    </style>

</asp:Content>
