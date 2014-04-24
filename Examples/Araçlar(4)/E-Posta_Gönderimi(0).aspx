<%@ Page Language="C#" %>

<%@ Import Namespace="Ext.Net.Utilities"%>
<%@ Import Namespace="System.Collections.Generic" %>
<%@ Import Namespace="System.Linq" %>
<%@ Import Namespace="System.Data.SqlClient" %>

<%@ Register Assembly="Ext.Net" Namespace="Ext.Net" TagPrefix="ext" %>
 

<script runat="server">
        
            
    protected void Page_Load(object sender, EventArgs e)
    {
        
        if (!X.IsAjaxRequest)
        {

            var store1 = this.grdPers.GetStore();
            store1.DataSource = GetData();
            store1.DataBind();

            txtGonderen.Text = Data.CFG.Cfg.EPostaAdres;                                                                      
        }              
    }

    public object[] GetData()
    {
            
        Data.vPersoneller[] List =
        new DevExpress.Xpo.XPCollection<Data.vPersoneller>
            (Data.XP.Crs).OrderBy(x => x.SiraNo).ToArray();


        object[] Lobj = new object[List.Length];

        for (int i = 0; i < List.Length; i++)
        {
            Data.vPersoneller kty = List[i];
            Lobj[i] = new object[] {                    
             kty.FIRMA,
             kty.DEPARTMAN,
             kty.ISYERI,
             kty.SICILNO,
             kty.AD,
             kty.SOYAD,
             kty.CINSIYET,
             kty.TITLE,
             kty.SSKNO,
             kty.TTFNO,
             kty.PASSWORD,
             kty.LREF,
             kty.SiraNo,
             kty.EkBilgiler.EMAIL
            };
        }     
        return Lobj;            
    }


    protected void btnOk_Click(object sender, DirectEventArgs e)
    {
        try
        {
            Data.Engine.QuickMail(txtGonderen.Text, txtKime.Text, txtKonu.Text, txtContent.Text, txtBilgi.Text);


            X.Msg.Show(new MessageBoxConfig
            {
                Title = "İşlem Sonucu",
                Message = "E-Posta Gönderildi..",
                Width = 300,
                Icon = MessageBox.Icon.INFO,
                Buttons = MessageBox.Button.OK
            });
            
            txtKime.Text = "";
            txtKonu.Text = "";
            txtContent.Text = "";
            txtBilgi.Text = "";
        }
        catch (Exception ee)
        {
            X.Msg.Show(new MessageBoxConfig
            {
                Title = "E-Posta gönderilirken hata",
                Message = ee.Message,
                Width = 300,
                Icon = MessageBox.Icon.ERROR,
                Buttons = MessageBox.Button.OK
            });
        }
        
       
    }

    protected void btnKisiSec_Click(object sender, DirectEventArgs e)
    {
        string json = e.ExtraParams["record"];

        List<Data.vPersoneller> obj = Newtonsoft.Json.JsonConvert.DeserializeObject<List<Data.vPersoneller>>(json);

        if (obj == null || obj.Count < 1)
        {
            X.Msg.Show(new MessageBoxConfig
            {
                Title = "Satır seçmelisiniz..",
                Message = "Satır seçmelisiniz..",
                Width = 300,
                Icon = MessageBox.Icon.WARNING,
                Buttons = MessageBox.Button.OK
            });

            return;
        }

        foreach (Data.vPersoneller pers in obj)
        {
            txtKime.Text += pers.EkBilgiler.EMAIL + ";";
        }
    }

    protected void btnBilgiSec_Click(object sender, DirectEventArgs e)
    {
        string json = e.ExtraParams["record"];

        List<Data.vPersoneller> obj = Newtonsoft.Json.JsonConvert.DeserializeObject<List<Data.vPersoneller>>(json);

        if (obj == null || obj.Count < 1)
        {
            X.Msg.Show(new MessageBoxConfig
            {
                Title = "Satır seçmelisiniz..",
                Message = "Satır seçmelisiniz..",
                Width = 300,
                Icon = MessageBox.Icon.WARNING,
                Buttons = MessageBox.Button.OK
            });

            return;
        }

        foreach (Data.vPersoneller pers in obj)
        {
            txtBilgi.Text += pers.EkBilgiler.EMAIL + ";";
        }
    }

    protected void btnClear_Click(object sender, DirectEventArgs e)
    {
        //txtGonderen.Text="";
        txtKime.Text = "";
        txtKonu.Text = "";
        txtContent.Text = "";
        txtBilgi.Text = "";
    }

                
</script>

    

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN"  "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
     <title></title>
    <ext:ResourcePlaceHolder ID="ResourcePlaceHolder1" runat="server" Mode="Script" />   
    <link rel="stylesheet" type="text/css" href="../../../../resources/css/main.css" />
      <link href="../../../../resources/css/examples.css" rel="stylesheet" type="text/css" />  
    

   <ext:XScript ID="XScript1" runat="server">
        <script type="text/javascript">
                         
                  
            var applyFilter = function (field) {                
                var store = #{grdPers}.getStore();
                store.suspendEvents();
                store.filterBy(getRecordFilter());                                
                store.resumeEvents();
                #{grdPers}.getView().refresh(false);
            };
             
            var clearFilter = function () {
                #{FtxtFIRMA}.reset();                                
                #{FtxtDEPARTMAN}.reset(); 
                #{FtxtISYERI}.reset();                                
                #{FtxtSICILNO}.reset(); 
                #{FtxtAD}.reset(); 
                #{FtxtSOYAD}.reset(); 
                #{FtxtCINSIYET}.reset(); 
                #{FtxtTITLE}.reset(); 
                #{FtxtSSKNO}.reset(); 
                #{FtxtTTFNO}.reset(); 
                #{Store1}.clearFilter();                                
            }
 
            var filterString = function (value, dataIndex, record) {
                var val = record.get(dataIndex);
                
                if (typeof val != "string") {
                    return value.length == 0;
                }
                
                return val.toLowerCase().indexOf(value.toLowerCase()) > -1;
            };
 
       
            var filterNumber = function (value, dataIndex, record) {
                var val = record.get(dataIndex);                
 
                if (!Ext.isEmpty(value, false) && val != value) {
                    return false;
                }
                
                return true;
            };
 
            var getRecordFilter = function () {
                var f = [];
 
                
                f.push({
                    filter: function (record) {                         
                        return filterString(#{FtxtFIRMA}.getValue(), "FIRMA", record);
                    }
                });
                
                f.push({
                    filter: function (record) {                         
                        return filterString(#{FtxtDEPARTMAN}.getValue(), "DEPARTMAN", record);
                    }
                });
                
                f.push({
                    filter: function (record) {                         
                        return filterString(#{FtxtISYERI}.getValue(), "ISYERI", record);
                    }
                });
                
                
                f.push({
                    filter: function (record) {                         
                        return filterString(#{FtxtSICILNO}.getValue(), "SICILNO", record);
                    }
                });
                
                f.push({
                    filter: function (record) {                         
                        return filterString(#{FtxtAD}.getValue(), "AD", record);
                    }
                });
                
                f.push({
                    filter: function (record) {                         
                        return filterString(#{FtxtSOYAD}.getValue(), "SOYAD", record);
                    }
                });
                
                f.push({
                    filter: function (record) {                         
                        return filterString(#{FtxtCINSIYET}.getValue(), "CINSIYET", record);
                    }
                });
                
                f.push({
                    filter: function (record) {                         
                        return filterString(#{FtxtTITLE}.getValue(), "TITLE", record);
                    }
                });
                
                f.push({
                    filter: function (record) {                         
                        return filterString(#{FtxtSSKNO}.getValue(), "SSKNO", record);
                    }
                });
                 
                f.push({
                    filter: function (record) {                         
                        return filterString(#{FtxtTTFNO}.getValue(), "TTFNO", record);
                    }
                });
                                                                                                           
 
                var len = f.length;
                 
                return function (record) {
                    for (var i = 0; i < len; i++) {
                        if (!f[i].filter(record)) {
                            return false;
                        }
                    }
                    return true;
                };
            };
        </script>
    </ext:XScript>

    
 

</head>
<body>

    
       
    

    <form runat="server">                 
        
        
        <ext:ResourceManager  runat="server" />    
                                                                                                                                                                               
                   <ext:Window ID="Window2" 
                      Draggable="false" 
                      Resizable="false" 
                      runat="server"  
                      Width="1024" Height="384" 
                      Padding="1" X="1" Y="1" Closable="false" Layout="column">                      
                        <Items>
                              
                            
                            <ext:Panel ID="Panel4" 
                           runat="server"                   
                           Height="180"
                           Padding="5"
                           Title="E-Posta" 
                           ColumnWidth="0.30" >                                                                                 
                           <Items>
                           
                                   
                                 <ext:TextField ID="txtGonderen" runat="server" FieldLabel="Gönderen" LabelWidth="60" Width="280"/>
                               <ext:TextField ID="txtKime" runat="server" FieldLabel="Kime" LabelWidth="60" Width="280" />  
                               <ext:TextField ID="txtBilgi" runat="server" FieldLabel="Bilgi" LabelWidth="60" Width="280" />  
                               <ext:TextField ID="txtKonu" runat="server" FieldLabel="Konu" LabelWidth="60" Width="220" />  

                               <ext:TextArea ID="txtContent" runat="server"  FieldLabel="İçerik" LabelWidth="60" Width="280" Height="200"  />


                                              <ext:Button ID="btnGonder" runat="server" Icon="Accept"  Text="E-Postayı Gönder.." Width="280" >              
                                                          <DirectEvents>                   
                                                           <Click OnEvent="btnOk_Click" >     
                                                      
                                                           </Click>
                                                          </DirectEvents>
                                                      </ext:Button>  

                                            
                           </Items>                                                      
                           </ext:Panel>                                                                         
                                 
                
                            <ext:GridPanel
                            ID="grdPers"
                            runat="server" 
                            StripeRows="true"            
                            Width="1085" 
                            Height="545" Y="1"                                                 
                            TrackMouseOver="true" ColumnWidth="0.35">    

                               <Store>                          
                                  <ext:Store 
                                    ID="strPers" 
                                    runat="server" >                                     
                                    <Reader>
                                         <ext:ArrayReader>                                         
                                           <Fields>
                                                <ext:RecordField Name="FIRMA" />
                                                <ext:RecordField Name="DEPARTMAN" />
                                                <ext:RecordField Name="ISYERI" />
                                                <ext:RecordField Name="SICILNO" />
                                                <ext:RecordField Name="AD" />
                                                <ext:RecordField Name="SOYAD" />
                                                <ext:RecordField Name="CINSIYET" />
                                                <ext:RecordField Name="TITLE" />
                                                <ext:RecordField Name="SSKNO" />
                                                <ext:RecordField Name="TTFNO" />
                                                <ext:RecordField Name="PASSWORD" />
                                                <ext:RecordField Name="LREF" Type="Int"  />
                                                <ext:RecordField Name="SiraNo" Type="Int"  />
                                               <ext:RecordField Name="EMAIL"   />
                                           </Fields>
                                        </ext:ArrayReader>
                                    </Reader>
                                </ext:Store>                                                                            
                                </Store>
                                                                                                                                                                                               
                               <ColumnModel ID="ColumnModel1" runat="server">
                                    <Columns>                                                      
                                   
                                            <ext:Column Header="FIRMA"  DataIndex="FIRMA" />
                                            <ext:Column Header="DEPARTMAN"  DataIndex="DEPARTMAN" />
                                            <ext:Column Header="ISYERI"  DataIndex="ISYERI" />
                                            <ext:Column Header="SICILNO"  DataIndex="SICILNO" />
                                            <ext:Column Header="AD"  DataIndex="AD" />
                                            <ext:Column Header="SOYAD"  DataIndex="SOYAD" />
                                            <ext:Column Header="CINSIYET"  DataIndex="CINSIYET" />
                                            <ext:Column Header="TITLE"  DataIndex="TITLE" />
                                            <ext:Column Header="SSKNO"  DataIndex="SSKNO" />
                                            <ext:Column Header="TTFNO"  DataIndex="TTFNO" />                                            
                                            <ext:Column Header="LREF"  DataIndex="LREF" Hidden="true" />
                                            <ext:Column Header="PASSWORD"  DataIndex="PASSWORD" Hidden="true" />
                                            
                                            <ext:Column Header="Sıra No"  DataIndex="SiraNo" />   

                                        <ext:Column Header="E-Posta"  DataIndex="EMAIL" />   

                                            
                                    </Columns>
                                  </ColumnModel> 
                                  
                               <SelectionModel>
                                            <ext:CheckboxSelectionModel  runat="server"  HideCheckAll="false"  AllowDeselect="true"   />
                                        </SelectionModel>
                                                                                        
                               <BottomBar>
                                    
                                             <ext:PagingToolbar ID="PagingToolbar1" runat="server" PageSize="20">
                                            <Items>
                                                <ext:Label ID="Label1" runat="server" Text="Page size:" />
                                                <ext:ToolbarSpacer ID="ToolbarSpacer1" runat="server" Width="10" />
                                                <ext:ComboBox ID="ComboBox1" runat="server" Width="80">
                                                    <Items>
                                                        <ext:ListItem Text="1" />
                                                        <ext:ListItem Text="2" />
                                                        <ext:ListItem Text="10" />
                                                        <ext:ListItem Text="20" />
                                                        <ext:ListItem Text="50" />
                                                    </Items>
                                                    <SelectedItem Value="20" />
                                                    <Listeners>
                                                        <Select Handler="#{PagingToolbar1}.pageSize = parseInt(this.getValue()); #{PagingToolbar1}.doLoad();" />
                                                    </Listeners>
                                                </ext:ComboBox>
                                            </Items>
                                              </ext:PagingToolbar>
                         
                                    </BottomBar>

                               <TopBar>
                                            <ext:Toolbar ID="Toolbar1" runat="server">
                                                <Items>
                                                 <ext:Label ID="lblCapt" runat="server" Text="...: Personeller :.." Align="center"  />      

                                                       <ext:Button ID="btnKisiSec" runat="server" Icon="Server"  Text=".. SEÇİLENLERİ KİŞİLERE EKLE ..." Width="100">              
                                                         <DirectEvents>
                                                               <Click OnEvent="btnKisiSec_Click">
                                                                    <ExtraParams>
                                                                         <ext:Parameter Name="record" Value="Ext.encode(#{grdPers}.getRowsValues({selectedOnly:true}))" Mode="Raw" />
                                                                    </ExtraParams>
                                                                </Click>
                                                         </DirectEvents>
                                                      </ext:Button>  

                                                     <ext:Button ID="btnBilgiSec" runat="server" Icon="Server"  Text=".. SEÇİLENLERİ BİLGİYE EKLE ..." Width="100">              
                                                         <DirectEvents>
                                                               <Click OnEvent="btnBilgiSec_Click">
                                                                    <ExtraParams>
                                                                         <ext:Parameter Name="record" Value="Ext.encode(#{grdPers}.getRowsValues({selectedOnly:true}))" Mode="Raw" />
                                                                    </ExtraParams>
                                                                </Click>
                                                         </DirectEvents>
                                                      </ext:Button>  


                                                        
                                                                <ext:Button ID="Button3" runat="server" Icon="Delete"  Text="Temizle..." Width="100" >              
                                                          <DirectEvents>                   
                                                           <Click OnEvent="btnClear_Click" >                                                                
                                                           </Click>
                                                          </DirectEvents>
                                                      </ext:Button>   
                                                    
                                                                                                  
                                                </Items>
                                            </ext:Toolbar>                                                                                                                                                                                                                                                     
                                </TopBar>  

                               <View>
                                <ext:GridView ID="GridView1" runat="server">
                                    <HeaderRows>
                                        <ext:HeaderRow>
                                            <Columns>
                           
                                            <ext:HeaderColumn />
                           
                           
                                                  <ext:HeaderColumn Cls="x-small-editor">
                                                    <Component>
                                                        <ext:TextField ID="FtxtFIRMA" runat="server" EnableKeyEvents="true">
                                                            <Listeners>
                                                                <KeyUp Handler="applyFilter(this);" Buffer="250" />                                                
                                                            </Listeners>
                                                        </ext:TextField>
                                                    </Component>
                                                </ext:HeaderColumn>
                                
                                                      <ext:HeaderColumn Cls="x-small-editor">
                                                    <Component>
                                                        <ext:TextField ID="FtxtDEPARTMAN" runat="server" EnableKeyEvents="true">
                                                            <Listeners>
                                                                <KeyUp Handler="applyFilter(this);" Buffer="250" />                                                
                                                            </Listeners>
                                                        </ext:TextField>
                                                    </Component>
                                                </ext:HeaderColumn>
                                
                                
                                                       <ext:HeaderColumn Cls="x-small-editor">
                                                    <Component>
                                                        <ext:TextField ID="FtxtISYERI" runat="server" EnableKeyEvents="true">
                                                            <Listeners>
                                                                <KeyUp Handler="applyFilter(this);" Buffer="250" />                                                
                                                            </Listeners>
                                                        </ext:TextField>
                                                    </Component>
                                                </ext:HeaderColumn>
                                
                                
                                
                                                        <ext:HeaderColumn Cls="x-small-editor">
                                                    <Component>
                                                        <ext:TextField ID="FtxtSICILNO" runat="server" EnableKeyEvents="true">
                                                            <Listeners>
                                                                <KeyUp Handler="applyFilter(this);" Buffer="250" />                                                
                                                            </Listeners>
                                                        </ext:TextField>
                                                    </Component>
                                                </ext:HeaderColumn>
                                
                                            
                                
                                                  <ext:HeaderColumn Cls="x-small-editor">
                                                    <Component>
                                                        <ext:TextField ID="FtxtAD" runat="server" EnableKeyEvents="true">
                                                            <Listeners>
                                                                <KeyUp Handler="applyFilter(this);" Buffer="250" />                                                
                                                            </Listeners>
                                                        </ext:TextField>
                                                    </Component>
                                                </ext:HeaderColumn>
                                
                                                  <ext:HeaderColumn Cls="x-small-editor">
                                                    <Component>
                                                        <ext:TextField ID="FtxtSOYAD" runat="server" EnableKeyEvents="true">
                                                            <Listeners>
                                                                <KeyUp Handler="applyFilter(this);" Buffer="250" />                                                
                                                            </Listeners>
                                                        </ext:TextField>
                                                    </Component>
                                                </ext:HeaderColumn>
                                           
                                               <ext:HeaderColumn Cls="x-small-editor">
                                                    <Component>
                                                        <ext:TextField ID="FtxtCINSIYET" runat="server" EnableKeyEvents="true">
                                                            <Listeners>
                                                                <KeyUp Handler="applyFilter(this);" Buffer="250" />                                                
                                                            </Listeners>
                                                        </ext:TextField>
                                                    </Component>
                                                </ext:HeaderColumn>
                                           
                                           
                                           
                                                     <ext:HeaderColumn Cls="x-small-editor">
                                                    <Component>
                                                        <ext:TextField ID="FtxtTITLE" runat="server" EnableKeyEvents="true">
                                                            <Listeners>
                                                                <KeyUp Handler="applyFilter(this);" Buffer="250" />                                                
                                                            </Listeners>
                                                        </ext:TextField>
                                                    </Component>
                                                </ext:HeaderColumn>
                                
                                                     <ext:HeaderColumn Cls="x-small-editor">
                                                    <Component>
                                                        <ext:TextField ID="FtxtSSKNO" runat="server" EnableKeyEvents="true">
                                                            <Listeners>
                                                                <KeyUp Handler="applyFilter(this);" Buffer="250" />                                                
                                                            </Listeners>
                                                        </ext:TextField>
                                                    </Component>
                                                </ext:HeaderColumn>
                                
                                                     <ext:HeaderColumn Cls="x-small-editor">
                                                    <Component>
                                                        <ext:TextField ID="FtxtTTFNO" runat="server" EnableKeyEvents="true">
                                                            <Listeners>
                                                                <KeyUp Handler="applyFilter(this);" Buffer="250" />                                                
                                                            </Listeners>
                                                        </ext:TextField>
                                                    </Component>
                                                </ext:HeaderColumn>
                                
                                
                                                   <ext:HeaderColumn AutoWidthElement="false">
                                                    <Component>
                                                        <ext:Button ID="ClearFilterButton" runat="server" Icon="Cancel">
                                                            <ToolTips>
                                                                <ext:ToolTip ID="ToolTip1" runat="server" Html="Clear filter" />
                                                            </ToolTips>
                                             
                                                            <Listeners>
                                                                <Click Handler="clearFilter(null);" />
                                                            </Listeners>                                            
                                                        </ext:Button>
                                                    </Component>
                                                </ext:HeaderColumn>                                                                                                                                                                                                                                                        
                                
                                
                                            </Columns>
                                        </ext:HeaderRow>
                                    </HeaderRows>
                                </ext:GridView>
                             </View>

                           </ext:GridPanel>       
                            
                            
                            
                                                                                                                                                
                       </Items>                                      
                 </ext:Window>                                                                                                                 
                                                                                                                                                                                                                                    
                 <ext:Window ID="Window1" 
                      Draggable="false" 
                      Resizable="false" 
                      runat="server"  
                      Width="1024" Height="300" 
                      Padding="1" X="1" Y="386" Closable="false">                      
                        <Items>
                              
                                                                                             
                                                                                                                    
                       </Items>                                      
                 </ext:Window>                                    
           
                     
                          
                                             
            
    </form>



</body>
</html>
