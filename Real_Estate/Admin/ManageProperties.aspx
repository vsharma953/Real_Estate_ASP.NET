<%@ Page Title="Manage Properties" Language="C#" MasterPageFile="~/Admin/Admin.Master" AutoEventWireup="true" CodeBehind="ManageProperties.aspx.cs" Inherits="Real_Estate.Admin.ManageProperties" %>

<asp:Content ID="Content1" ContentPlaceHolderID="HeadContent" runat="server">
</asp:Content>


<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">

    <div class="manage-box">

        <h2 class="manage-title">Manage Properties</h2>

        <p class="manage-subtitle">
            Add, update and delete properties from the database.
        </p>


        <asp:Label ID="lblMessage"
            runat="server"
            Visible="false"
            CssClass="message">
        </asp:Label>


        <table class="form-table">

            <tr>

                <td style="width: 20%;">Property Title
                </td>

                <td style="width: 30%;">
                    <asp:TextBox ID="txtTitle"
                        runat="server"
                        Width="95%"
                        CssClass="form-control">
                    </asp:TextBox>
                </td>

                <td style="width: 20%;">Property Type
                </td>

                <td style="width: 30%;">

                    <asp:DropDownList ID="ddlType"
                        runat="server"
                        Width="95%"
                        CssClass="form-control">

                        <asp:ListItem Text="Villa"
                            Value="villa">
                        </asp:ListItem>

                        <asp:ListItem Text="Penthouse"
                            Value="penthouse">
                        </asp:ListItem>

                        <asp:ListItem Text="Townhouse"
                            Value="townhouse">
                        </asp:ListItem>

                    </asp:DropDownList>

                </td>

            </tr>


            <tr>


                <td id="tdPriceLabel">Price / Rent
                </td>
                <td>
                    <asp:TextBox ID="txtPrice"
                        runat="server"
                        Width="95%"
                        CssClass="form-control"
                        placeholder="e.g. 2500">
                    </asp:TextBox>
                    <small id="priceHint" class="form-hint"></small>
                </td>


                <td>Location
                </td>

                <td>
                    <asp:TextBox ID="txtLocation"
                        runat="server"
                        Width="95%"
                        CssClass="form-control">
                    </asp:TextBox>
                </td>

            </tr>


            <tr>

                <td>Bedrooms
                </td>

                <td>
                    <asp:TextBox ID="txtBedrooms"
                        runat="server"
                        Width="95%"
                        CssClass="form-control">
                    </asp:TextBox>
                </td>

                <td>Bathrooms
                </td>

                <td>
                    <asp:TextBox ID="txtBathrooms"
                        runat="server"
                        Width="95%"
                        CssClass="form-control">
                    </asp:TextBox>
                </td>

            </tr>


            <tr>

                <td>Area
                </td>

                <td>
                    <asp:TextBox ID="txtArea"
                        runat="server"
                        Width="95%"
                        CssClass="form-control">
                    </asp:TextBox>
                </td>

                <td></td>

                <td></td>

            </tr>


            <tr>

                <td>Listing For
                </td>

                <td>
                    <asp:DropDownList ID="ddlListingType"
                        runat="server"
                        Width="95%"
                        CssClass="form-control">

                        <asp:ListItem Text="For Sale"
                            Value="Sale">
                        </asp:ListItem>

                        <asp:ListItem Text="For Rent"
                            Value="Rent">
                        </asp:ListItem>

                    </asp:DropDownList>
                </td>

                <td></td>

                <td></td>

            </tr>


            <tr>

                <td>Photo 1
                </td>

                <td>
                    <asp:FileUpload ID="fuPhoto1"
                        runat="server" />
                </td>

                <td>Photo 2
                </td>

                <td>
                    <asp:FileUpload ID="fuPhoto2"
                        runat="server" />
                </td>

            </tr>


            <tr>

                <td>Photo 3
                </td>

                <td>
                    <asp:FileUpload ID="fuPhoto3"
                        runat="server" />
                </td>

                <td>Description
                </td>

                <td>

                    <asp:TextBox ID="txtDescription"
                        runat="server"
                        TextMode="MultiLine"
                        Width="95%"
                        Height="80px"
                        CssClass="form-control form-description">
                    </asp:TextBox>

                </td>

            </tr>

        </table>


        <br />


        <asp:Button ID="btnSave"
            runat="server"
            Text="Save"
            CssClass="action-button save-button"
            OnClick="btnSave_Click" />


        <asp:Button ID="btnCancel"
            runat="server"
            Text="Clear"
            CausesValidation="false"
            CssClass="action-button clear-button"
            OnClick="btnCancel_Click" />

        <hr class="section-line" />

        <div class="tab-bar">
            <asp:Repeater ID="rptTabs" runat="server" OnItemCommand="rptTabs_ItemCommand">
                <ItemTemplate>
                    <asp:LinkButton ID="lnkTab" runat="server" CausesValidation="false"
                        CommandName="Tab" CommandArgument='<%# Eval("Value") %>'
                        CssClass='<%# IsActiveTab(Eval("Value")) ? "tab-link tab-active" : "tab-link" %>'>
                        <%#: Eval("Text") %><span class="tab-count"><%#: Eval("Total") %></span>
                    </asp:LinkButton>
                </ItemTemplate>
            </asp:Repeater>
        </div>

        <div class="table-scroll">
<asp:GridView ID="gvProperties" runat="server" AutoGenerateColumns="False" GridLines="None" CssClass="property-grid" OnRowCommand="gvProperties_RowCommand" EmptyDataText="No properties found.">

            <Columns>

                <asp:TemplateField HeaderText="ID">
                    <ItemTemplate>
                        <asp:Label ID="lblID" runat="server" Text='<%# Eval("PropertyID") %>'></asp:Label>
                    </ItemTemplate>
                </asp:TemplateField>

                <asp:TemplateField HeaderText="Photo">
                    <ItemTemplate>
                        <asp:Image ID="imgProperty" runat="server" Height="60" Width="80" CssClass="property-image" ImageUrl='<%# Eval("Photo1") %>' />
                    </ItemTemplate>
                </asp:TemplateField>

                <asp:TemplateField HeaderText="Title">
                    <ItemTemplate>
                        <asp:Label ID="lblTitle" runat="server" Text='<%# Eval("Title") %>'></asp:Label>
                    </ItemTemplate>
                </asp:TemplateField>

                <asp:TemplateField HeaderText="Type">
                    <ItemTemplate>
                        <asp:Label ID="lblType" runat="server" Text='<%# Eval("PropertyType") %>'></asp:Label>
                    </ItemTemplate>
                </asp:TemplateField>

                <asp:TemplateField HeaderText="Listing">
                    <ItemTemplate>
                        <asp:Label ID="lblListing" runat="server" Text='<%# Eval("ListingType") %>'></asp:Label>
                    </ItemTemplate>
                </asp:TemplateField>

                <asp:TemplateField HeaderText="Price">
                    <ItemTemplate>
                        <asp:Label ID="lblPrice" runat="server" Text='<%# Eval("Price") %>'></asp:Label>
                    </ItemTemplate>
                </asp:TemplateField>

                <asp:TemplateField HeaderText="Location">
                    <ItemTemplate>
                        <asp:Label ID="lblLocation" runat="server" Text='<%# Eval("Location") %>'></asp:Label>
                    </ItemTemplate>
                </asp:TemplateField>

                <asp:TemplateField HeaderText="Status">
                    <ItemTemplate>
                        <asp:Label ID="lblStatus" runat="server" Text='<%# Eval("Status") %>'></asp:Label>
                    </ItemTemplate>
                </asp:TemplateField>

                <asp:TemplateField HeaderText="Deal">
                    <ItemTemplate>
                        <asp:HyperLink ID="hlCloseDeal" runat="server" Text="Close Deal" CssClass="grid-button"
                            NavigateUrl='<%# "CloseDeal.aspx?PropertyID=" + Eval("PropertyID") %>'
                            Visible='<%# Convert.ToInt32(Eval("IsOpen")) == 1 %>'></asp:HyperLink>
                    </ItemTemplate>
                </asp:TemplateField>

                <asp:TemplateField HeaderText="Edit">
                    <ItemTemplate>
                        <asp:Button ID="btnEdit" runat="server" Text="Edit" CssClass="grid-button" CommandName="EditRow" CommandArgument='<%# Eval("PropertyID") %>' />
                    </ItemTemplate>
                </asp:TemplateField>

                <asp:TemplateField HeaderText="Delete">
                    <ItemTemplate>
                        <asp:Button ID="btnDelete" runat="server" Text="Delete" CssClass="grid-button delete-button" CommandName="DeleteRow" CommandArgument='<%# Eval("PropertyID") %>' OnClientClick="return confirm('Are you sure you want to delete this property?');" />
                    </ItemTemplate>
                </asp:TemplateField>

            </Columns>

        </asp:GridView>
</div>
    </div>
    
<script>
    (function () {
        var listingDdl = document.getElementById('<%= ddlListingType.ClientID %>');
        var hint = document.getElementById('priceHint');
        var label = document.getElementById('tdPriceLabel');

        function updateHint() {
            if (listingDdl.value === "Rent") {
                label.innerText = "Monthly Rent";
                hint.innerText = "Enter the amount per month (e.g. 2500)";
            } else {
                label.innerText = "Sale Price";
                hint.innerText = "Enter the full sale price (e.g. 450000)";
            }
        }

        listingDdl.addEventListener("change", updateHint);
        updateHint();
    })();
</script>
</asp:Content>
