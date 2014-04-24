<%@ Page Language="C#" %>

<%@ Import Namespace="System.Collections.Generic" %>

<%@ Register Assembly="Ext.Net" Namespace="Ext.Net" TagPrefix="ext" %>


<script runat="server">
    
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!X.IsAjaxRequest)
        {
          
        }
    }   
    
</script>
  
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" 
    "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title></title>
    <link href="../resources/css/examples.css" rel="stylesheet" type="text/css" />    
    <link rel="stylesheet" type="text/css" href="../resources/css/main.css" />
</head>
<body>
<form id="Form1" runat="server">
    <ext:ResourceManager runat="server" />
      
            <h1>İstanbul Otobüs İşletmeleri A.Ş.</h1>        
        <p>İstanbul Otobüs İşletmeleri A.Ş., toplu taşıma otobüs hizmetleri</p>
                
         <img src="../resources/images/motherbanner7.jpg" alt="" />  
         
    <br />
          <p> <h2> <a href="http://www.istanbulotobus.com.tr/">http://www.istanbulotobus.com.tr...</a>
              </h2> </p>

        </form>
</body>
</html>
