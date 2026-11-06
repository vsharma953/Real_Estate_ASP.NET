<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="CrystalReport.aspx.cs" Inherits="Real_Estate.SiteAdmin.CrystalReport" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title></title>
</head>
<body>
    <form id="form1" runat="server">
        <div>
            <center>
                <h1>XML File Generator For Reports</h1>
                <asp:Button ID="btnGenerateXML" runat="server" Text="Generate XML" OnClick="btnGenerateXML_Click" />
            </center>
        </div>
    </form>
</body>
</html>
