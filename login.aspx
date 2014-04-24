<%@ Page Language="C#" %>


<%@ Import Namespace="Ext.Net.Utilities"%>
<%@ Import Namespace="System.Collections.Generic" %>
<%@ Register Assembly="Ext.Net" Namespace="Ext.Net" TagPrefix="ext" %>

<script runat="server">
                              
    protected void Button_Click(object sender, DirectEventArgs e)
    {
        string user = txtUser.Text;
        string pass = txtPass.Text;

        string x = ConfigurationManager.ConnectionStrings["CONSTR"].ConnectionString;
        Data.XP.Connect(x);
        
       StatusBar statusBar = ControlUtils.FindControl(this.ResourceManager1, "StatusBar1") as StatusBar;
        
        if (!Data.Util.En.Login(ref user, pass))
        {
            Window1.Hidden = false;
            
            X.Msg.Show(new MessageBoxConfig
            {
                Title = "Giriş Bilgisi..",
                Message = "Giriş bilgileri hatalı..",
                Width = 300,
                Icon = MessageBox.Icon.WARNING,
                Buttons = MessageBox.Button.OK
            });

            statusBar.SetStatus(new StatusBarStatusConfig("Giriş Başarısız.", "Icon.Error"));
        }
        else
        {
            
            //Data.Util.En.CookieSet(this, "cari", Data.Util.En.GetCari(txtUser.Text));
            //Data.Util.En.CookieSet(this, "curuser", txtUser.Text);           
            Response.Redirect("Default.aspx");
            statusBar.SetStatus(new StatusBarStatusConfig("Giriş Başarılı"));
        }



        statusBar.SetStatus(new StatusBarStatusConfig("Giriş Başarısız."));
        
    }


    protected void Page_Load(object sender, EventArgs e)
    {
        if (!X.IsAjaxRequest)
        {
            //Data.Util.En.CookieClear(this, "curuser");
            //Data.Util.En.CookieClear(this, "cari");
            //Data.Util.En.CookieClear(this, "belge_no");            
        }
    }
</script>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" 
    "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html>
<head runat="server">
    <title>Göknil Bilgisayar</title>
    <ext:ResourcePlaceHolder ID="ResourcePlaceHolder1" runat="server" Mode="Script" />
    <ext:ResourcePlaceHolder ID="ResourcePlaceHolder2" runat="server" Mode="Style" />
      <link rel="stylesheet" type="text/css" href="resources/css/main.css" />
    
</head>
<body>
    <form id="form1" runat="server">
    <ext:ResourceManager 
        ID="ResourceManager1" 
        runat="server" 
        DirectMethodNamespace="X"
        IDMode="Explicit"
        />
    
  <div id="loading">
    <div class="loading-indicator">
    <img alt="" src="resources/images/loading.gif" width="32" height="32" style="margin-right:8px;float:left;vertical-align:top;"/>Göknil Bilişim - <a href="http://www.goknil.com">http://www.goknil.com</a><br /><span id="loading-msg">Loading styles and images...</span>   </div>
   
      <img alt="" src="resources/images/a4yatay.png"  style="margin-right:8px;float:left;vertical-align:top;"/>
  
 </div>
 
 


<!-- Personel Seçim Ekranı -->
     <ext:Window ID="Window1" 
            runat="server" 
            Width="370"
            Height="130"            
            Title="Kullanıcı Girişi.."
            Icon="Lock"
            Closable="false"         
            Resizable="false"
            Draggable="false" 
            Padding="8"           
            Hidden="true">
            <Items>
         
                <ext:TextField 
                    ID="txtUser" 
                    runat="server"                    
                    FieldLabel="Kullanıcı Id"                    
                    Width="300"                    
                    InputType="Text" />
                    
                <ext:TextField ID="txtPass" 
                    runat="server"                     
                    Vtype="password"
                    FieldLabel="Şifre"
                    InputType="Password"
                    MsgTarget="Side"
                    Width="300">                                           
                  </ext:TextField>      
                                            
                  
         </Items>
     
          
     
            
                  <BottomBar>
                <ext:StatusBar 
                    ID="StatusBar1" 
                    runat="server"
                    DefaultText="">
                    <Items>
                                 
                         <ext:Button runat="server" ID="btnOk"  Text="Giriş" Icon="Accept"   >                
                  <DirectEvents>
                    <Click OnEvent="Button_Click" Before="#{StatusBar1}.showBusy();"  />
                   </DirectEvents>                
                </ext:Button>
                
                <ext:Button runat="server"  ID="btnCancel"  Text="Çıkış"   Icon="Cancel"          >
                 <Listeners>
                    <Click Handler="window.close();" />
                 </Listeners> 
                   </ext:Button>   
                    </Items>
                </ext:StatusBar>
            </BottomBar>  
        </ext:Window> 
        
        <ext:KeyNav ID="KeyNav1" runat="server" Target="={txtPass}">
        <Enter Handler="Ext.getCmp('btnOk').fireEvent('click');#{StatusBar1}.showBusy();  "  />
        </ext:KeyNav>
            
<!-- Personel Seçim Ekranı -->    
 
<script type="text/javascript">
        
    var xTimer;

    function asd() {
                
        try {
            clearTimeout(xTimer);
            document.getElementById('loading').style.visibility = 'hidden';
            Window1.show();
        }
        catch (e) {
            Ext.Msg.alert('Hata oluştu.', e);
        }
    }

        

    xTimer= setTimeout("asd();", 2000);
    
    
</script>
   
    </form>
   
</body>
</html>