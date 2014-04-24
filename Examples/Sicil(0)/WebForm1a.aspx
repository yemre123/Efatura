<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="WebForm1a.aspx.cs" Inherits="Ext.Net.Examples.WebForm1" %>

<%@ Register assembly="CrystalDecisions.Web, Version=10.5.3700.0, Culture=neutral, PublicKeyToken=692fbea5521e1304" namespace="CrystalDecisions.Web" tagprefix="CR" %>

<%@ Import Namespace="Ext.Net.Utilities"%>
<%@ Import Namespace="System.Collections.Generic" %>
<%@ Import Namespace="Ext.Net.Examples" %>

<%@ Register Assembly="Ext.Net" Namespace="Ext.Net" TagPrefix="ext" %>

 



<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">




<html xmlns="http://www.w3.org/1999/xhtml" >

    <head id="Head1" runat="server">
    <title></title>
    <ext:ResourcePlaceHolder ID="ResourcePlaceHolder1" runat="server" Mode="Script"  />
   
 
    <style type="text/css">
        .style1
        {
            width: 100%;
        }
    </style>
    
    
    
    
</head>
<body>
    <form id="form1" runat="server">
     <div>
       <ext:ResourceManager  runat="server" />    
       
         
                <ext:Toolbar ID="Toolbar1" runat="server">
                    <Items>
                        <ext:Button ID="Button1" runat="server" Text="..Geri.. " Icon="ArrowLeft"  >
                            <DirectEvents>                   
                               <Click OnEvent="btnGeri_Click" >                                                      
                               </Click>
                              </DirectEvents>
                        </ext:Button>
                        
                         <ext:Button ID="Button2" runat="server" Text="<< Önceki Personel" Icon="ArrowLeft"  >
                            <DirectEvents>                   
                               <Click OnEvent="btnGeriPers_Click" >                                                      
                               </Click>
                              </DirectEvents>
                        </ext:Button>
                                                                        
                                                                        
                        <ext:Button ID="Button3" runat="server" Text="Sonraki Personel >>" Icon="ArrowRight" IconAlign="Right" >
                            <DirectEvents>                   
                               <Click OnEvent="btnIleriPers_Click" >                                                      
                               </Click>
                              </DirectEvents>
                        </ext:Button>
                        
                             <ext:Button ID="Button4" runat="server" Text="Yazdır..." Icon="Printer"  >
                              <Listeners>
                                <Click Handler="window.print()" />
                            </Listeners>
                        </ext:Button>
                         
                    </Items>
                </ext:Toolbar>
                
                      
                                                   
  
    
   
    
 
    
        <CR:CrystalReportSource ID="CrystalReportSource1" runat="server">
            <Report FileName="rpr3.rpt">
            </Report>
        </CR:CrystalReportSource>
    
        <CR:CrystalReportViewer ID="CrystalReportViewer1" runat="server" 
            AutoDataBind="true" />
        
    
    </div>

    </form>
</body>
</html>
