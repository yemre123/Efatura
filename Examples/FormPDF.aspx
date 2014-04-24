<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="FormPDF.aspx.cs" Inherits="Ext.Net.Examples.Examples.FormPDF" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title></title>
</head>
<body>
    <form id="form1" runat="server">
    <div>
    <iframe runat="server" id="frm_docs" src="FormPDF.aspx" style="display:inline; border:solid 1px black; width:100%; height:800px;"></iframe>
    </div>
    </form>
</body>
</html>
