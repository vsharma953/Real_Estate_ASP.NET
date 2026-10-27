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
                <div class="search-bar" role="search">
                    <svg viewBox="0 0 24 24" class="search-icon"><circle cx="11" cy="11" r="7"></circle><line x1="21" y1="21" x2="16.65" y2="16.65"></line></svg>
                    <input type="text" id="home-search" class="search-input" maxlength="100" autocomplete="off"
                        placeholder="Search by city, country, villa, penthouse..." aria-label="Search residences" />
                    <button type="button" id="home-search-btn" class="btn btn-accent search-btn">Search</button>
                </div>
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

<script>
        // Enter key or Search button sends the query to the Properties page
        (function () {
            var box = document.getElementById("home-search");
            var btn = document.getElementById("home-search-btn");

            function go() {
                var q = box.value.trim();
                window.location.href = "Properties.aspx" + (q ? "?Search=" + encodeURIComponent(q) : "");
            }

            btn.addEventListener("click", go);
            box.addEventListener("keydown", function (e) {
                if (e.key === "Enter") { e.preventDefault(); go(); }
            });
        })();
    </script>

    <style>
        .search-bar { display: flex; align-items: center; gap: .5rem; max-width: 640px; margin: 0 auto 1.5rem; padding: .4rem .4rem .4rem 1rem; background: #fff; border: 1px solid var(--border, #ddd); border-radius: 999px; box-shadow: 0 6px 24px rgba(0,0,0,.12); }
        .search-bar .search-icon { width: 20px; height: 20px; flex: none; fill: none; stroke: #888; stroke-width: 2; stroke-linecap: round; }
        .search-bar .search-input { flex: 1; min-width: 0; border: 0; outline: 0; background: transparent; font: inherit; font-size: 1rem; padding: .6rem .25rem; color: #222; }
        .search-bar .search-btn { flex: none; border-radius: 999px; padding: .65rem 1.5rem; margin: 0; text-decoration: none; cursor: pointer; }
        .search-bar:focus-within { border-color: var(--accent, #b08d57); }
        .search-results-line { text-align: center; margin: 0 0 1.25rem; color: var(--text-secondary, #666); }
        .search-results-line:empty { display: none; }
        .search-clear { margin-left: .75rem; color: var(--accent, #b08d57); font-weight: 600; text-decoration: underline; cursor: pointer; }
        @media (max-width: 480px) { .search-bar { padding-left: .75rem; } .search-bar .search-btn { padding: .6rem 1rem; } }
    </style>

</asp:Content>