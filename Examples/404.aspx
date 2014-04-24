<%@ Page Language="C#" %>

<script runat="server">
    protected void Page_Load(object sender, EventArgs e) {

        string xx = Data.Util.En.QC(this, "error");
        Response.Write(xx);
        Response.Flush();
    
    }
    </script>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" 
    "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>Hata Ekranı</title>
    <style type="text/css">
        body {
            background-color: #FFFFFF;
            background-image: url(/resource/images/404.png);
            background-repeat: no-repeat;
            background-position: top center;         
        }
    </style>  
</head>
<body>
</body>
</html>
