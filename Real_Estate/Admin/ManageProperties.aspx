<%@ Page Title="Manage Properties" Language="C#" MasterPageFile="~/Admin/Admin.Master" AutoEventWireup="true" CodeBehind="ManageProperties.aspx.cs" Inherits="Real_Estate.Admin.ManageProperties" %>

<asp:Content ID="Content1" ContentPlaceHolderID="HeadContent" runat="server">

    <style>
        .manage-box {
            background: #fff;
            padding: 30px;
            border: 1px solid #e5e5e5;
            border-radius: 8px;
        }

        .manage-title {
            margin: 0 0 6px 0;
            font-size: 28px;
            color: #222;
        }

        .manage-subtitle {
            margin: 0 0 25px 0;
            color: #777;
        }

        .form-table {
            width: 100%;
            border-collapse: separate;
            border-spacing: 0 12px;
        }

            .form-table td {
                padding: 4px 10px 4px 0;
                color: #444;
            }

                .form-table td:nth-child(3) {
                    padding-left: 25px;
                }

        .form-control {
            height: 38px;
            padding: 7px 10px;
            border: 1px solid #ccc;
            border-radius: 4px;
            box-sizing: border-box;
        }

            .form-control:focus {
                outline: none;
                border-color: #a98750;
            }

        .form-description {
            resize: vertical;
        }

        .action-button {
            padding: 9px 22px;
            border: none;
            border-radius: 4px;
            cursor: pointer;
            margin-right: 8px;
            font-weight: 600;
        }

        .save-button {
            background: #222;
            color: #fff;
        }

            .save-button:hover {
                background: #a98750;
            }

        .clear-button {
            background: #eee;
            color: #333;
        }

            .clear-button:hover {
                background: #ddd;
            }

        .message {
            display: block;
            padding: 10px 12px;
            background: #f7f3ec;
            border-left: 3px solid #a98750;
            color: #555;
        }

        .property-grid {
            width: 100%;
            border-collapse: collapse;
            margin-top: 15px;
        }

            .property-grid th {
                background: #222;
                color: #fff;
                padding: 12px 10px;
                text-align: left;
                font-weight: 600;
            }

            .property-grid td {
                padding: 10px;
                border-bottom: 1px solid #e5e5e5;
                vertical-align: middle;
            }

            .property-grid tr:hover td {
                background: #faf9f6;
            }

        .property-image {
            object-fit: cover;
            border-radius: 4px;
        }

        .grid-button {
            padding: 6px 14px;
            border: 1px solid #ccc;
            background: #fff;
            border-radius: 4px;
            cursor: pointer;
        }

            .grid-button:hover {
                background: #f3f0eb;
                border-color: #a98750;
            }

        .delete-button {
            color: #a33;
        }

            .delete-button:hover {
                background: #f8eeee;
                border-color: #c99;
            }

        .section-line {
            border: 0;
            border-top: 1px solid #e5e5e5;
            margin: 28px 0;
        }

        @media (max-width: 800px) {
            .manage-box {
                padding: 20px;
            }

            .form-table,
            .form-table tbody,
            .form-table tr,
            .form-table td {
                display: block;
                width: 100%;
                box-sizing: border-box;
            }

                .form-table td:nth-child(3) {
                    padding-left: 0;
                }

                .form-table td {
                    padding-bottom: 5px;
                }

            .property-grid {
                display: block;
                overflow-x: auto;
                white-space: nowrap;
            }
        }
    </style>

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

                <td>Price
                </td>

                <td>
                    <asp:TextBox ID="txtPrice"
                        runat="server"
                        Width="95%"
                        CssClass="form-control">
                    </asp:TextBox>
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

                <td>Status
                </td>

                <td>
                    <asp:TextBox ID="txtStatus"
                        runat="server"
                        Width="95%"
                        CssClass="form-control">
                    </asp:TextBox>
                </td>

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
</asp:Content>