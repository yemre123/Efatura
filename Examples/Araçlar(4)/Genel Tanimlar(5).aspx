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

            this.StoreCombo.DataSource = TANIMTIP.GetAll();
            this.StoreCombo.DataBind();

           // txtGonderen.Text = Data.CFG.Cfg.EPostaAdres;                                                                      
        }              
    }

    public object[] GetData()
    {
            
        Data.TANIMLAR[] List =
        new DevExpress.Xpo.XPCollection<Data.TANIMLAR>
            (Data.XP.Crs).OrderBy(x => x.TIP).ToArray();


        object[] Lobj = new object[List.Length];

        for (int i = 0; i < List.Length; i++)
        {
            Data.TANIMLAR kty = List[i];
            Lobj[i] = new object[] {                    
             kty.TIP,             
             kty.EXP1,
             kty.EXP2,
             kty.TIPAD,
             kty.Oid                       
            };
        }     
        return Lobj;            
    }


    protected void btnOk_Click(object sender, DirectEventArgs e)
    {
        
        try
        {
            
            //Data.Engine.QuickMail(txtGonderen.Text, txtKime.Text, txtKonu.Text, txtContent.Text, txtBilgi.Text);


            //X.Msg.Show(new MessageBoxConfig
            //{
            //    Title = "İşlem Sonucu",
            //    Message = "E-Posta Gönderildi..",
            //    Width = 300,
            //    Icon = MessageBox.Icon.INFO,
            //    Buttons = MessageBox.Button.OK
            //});
            
            //txtKime.Text = "";
            //txtKonu.Text = "";
            //txtContent.Text = "";
            //txtBilgi.Text = "";
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

        //foreach (Data.vPersoneller pers in obj)
        //{
        //    txtKime.Text += pers.EkBilgiler.EMAIL + ";";
        //}
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

        //foreach (Data.vPersoneller pers in obj)
        //{
        //    txtBilgi.Text += pers.EkBilgiler.EMAIL + ";";
        //}
    }

    protected void btnClear_Click(object sender, DirectEventArgs e)
    {
        //txtGonderen.Text="";
        //txtKime.Text = "";
        //txtKonu.Text = "";
        //txtContent.Text = "";
        //txtBilgi.Text = "";
    }


    protected void HandleChanges(object sender, BeforeStoreChangedEventArgs e)
    {
        ChangeRecords<Data.TANIMLAR> persons = e.DataHandler.ObjectData<Data.TANIMLAR>();

       
        
        foreach (Data.TANIMLAR created in persons.Created)
        {
            var tnmTips = TANIMTIP.GetAll().Where(x => x.Id == created.TIP);
            
            Data.TANIMLAR dbTnm = new Data.TANIMLAR(Data.XP.Crs);
            dbTnm.TIP = created.TIP;
            dbTnm.TIPAD = tnmTips.Count() > 0 ? tnmTips.First().Name : "";
            dbTnm.EXP1 = created.EXP1;
            dbTnm.EXP2 = created.EXP2;
            dbTnm.Save();
        }

        foreach (Data.TANIMLAR upd in persons.Updated)
        {
            var tnmTips1 = TANIMTIP.GetAll().Where(x => x.Id == upd.TIP);
            
            Data.TANIMLAR t =
            Data.XP.Crs.GetObjectByKey<Data.TANIMLAR>(upd.Oid);

            t.TIP = upd.TIP;
            t.TIPAD = tnmTips1.Count() > 0 ? tnmTips1.First().Name : "";
            t.EXP1 = upd.EXP1;
            t.EXP2 = upd.EXP2;
            
            t.Save();               
        }

        var store1 = this.grdPers.GetStore();
        store1.DataSource = GetData();
        store1.DataBind();
    }
    
    
    public class TANIMTIP{
        public int Id { get; set; }
        public string Name { get; set; }

        public static List<TANIMTIP> GetAll()
        {
            return new List<TANIMTIP>
                       {
                           new TANIMTIP {Id = 1, Name = "BELGE TÜRLERİ"},
                           new TANIMTIP {Id = 2, Name = ".."},
                           new TANIMTIP {Id = 3, Name = "..."}
                       };
        }
    }

                
</script>

    

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN"  "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
     <title></title>
    <ext:ResourcePlaceHolder ID="ResourcePlaceHolder1" runat="server" Mode="Script" />   
    <link rel="stylesheet" type="text/css" href="../../../../resources/css/main.css" />
      <link href="../../../../resources/css/examples.css" rel="stylesheet" type="text/css" />  
    
        <script type="text/javascript">
            var departmentRenderer = function (value) {
                var r = StoreCombo.getById(value);

                if (Ext.isEmpty(r)) {
                    return "";
                }

                return r.data.Name;
            };


            var updateRecord = function (form) {
                if (form.record == null) {
                    return;
                }

             

                form.getForm().updateRecord(form.record);
            };

            var addRecord = function (form, grid) {
               

                grid.insertRecord(0,-1);
              
            };

    </script>
 

    
 

</head>
<body>

    
       
    

    <form runat="server">                 
        
        
        <ext:ResourceManager  runat="server" />    
                                  
        
              <ext:Store ID="StoreCombo" runat="server">
            <Reader>
                <ext:JsonReader IDProperty="Id">
                    <Fields>
                        <ext:RecordField Name="Id" />
                        <ext:RecordField Name="Name" />
                    </Fields>
                </ext:JsonReader>
            </Reader>
        </ext:Store>
                                                                                                                                                     
                   <ext:Window ID="Window2" 
                      Draggable="false" 
                      Resizable="false" 
                      runat="server"  
                      Width="1024" Height="600" 
                      Padding="1" X="1" Y="1" Closable="false">                      
                        <Items>
                              
                            
                                                                                     
                                 
                
                         <ext:GridPanel
                            ID="grdPers"
                            runat="server" 
                            StripeRows="true"            
                            Width="1085" 
                            Height="545" Y="1"                                                 
                            TrackMouseOver="true">    

                               <Store>                          
                                  <ext:Store  ID="strPers" runat="server"  OnBeforeStoreChanged="HandleChanges"  >                                     
                                    <Reader>
                                         <ext:ArrayReader>                                         
                                           <Fields>
                                                <ext:RecordField Name="TIP"  DefaultValue="0"/>                                                
                                                <ext:RecordField Name="EXP1" />
                                                <ext:RecordField Name="EXP2" /> 
                                                <ext:RecordField Name="TIPAD" />                                            
                                                <ext:RecordField Name="OID" DefaultValue="-1" />     
                                           </Fields>
                                        </ext:ArrayReader>
                                    </Reader>
                                </ext:Store>                                                                            
                                </Store>
                                                                                                                                                                                               
                               <ColumnModel ID="ColumnModel1" runat="server">
                                    <Columns>                                                      
                                   
                                            <ext:Column Header="Tanım Adı"  DataIndex="TIP" >
                                                  <Renderer Fn="departmentRenderer" />
                                                <Editor>
                                                     <ext:ComboBox
                                                              ID="cmbBelgeTur"
                                                                    runat="server" 
                                                                    Shadow="Drop" 
                                                                    Mode="Local" 
                                                                    TriggerAction="All" 
                                                                    ForceSelection="true"
                                                                    StoreID="StoreCombo" 
                                                                    DisplayField="Name" 
                                                                    ValueField="Id">
                                                           </ext:ComboBox>
                                                </Editor>
                                            </ext:Column>                                            
                                            <ext:Column Header="Açıklama1"  DataIndex="EXP1" >
                                                    <Editor>
                                                        <ext:TextField ID="colTxtAck1" runat="server" />
                                                    </Editor>
                                            </ext:Column>
                                            <ext:Column Header="Açıklama2"  DataIndex="EXP2" >

                                                <Editor>
                                                        <ext:TextField ID="colTxtAck2" runat="server" />
                                                    </Editor>

                                            </ext:Column>    
                                            <ext:Column Header="Tanım No"  DataIndex="TIPAD" Hidden="true" />                                        
                                            <ext:Column Header="OID"  DataIndex="OID" Hidden="true" />
                                    

                                            
                                    </Columns>
                                  </ColumnModel> 
                                  
                               <SelectionModel>
                                            <ext:RowSelectionModel  runat="server"  HideCheckAll="false"  AllowDeselect="true"   />
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

                                                       <ext:Button ID="btnKisiSec" runat="server" Icon="Add"  Text="Ekle.." Width="100">                                                                
                                                                  <Listeners>
                                                                    <Click Handler="addRecord(#{Window2}, #{grdPers});" />
                                                                </Listeners>
                                                      </ext:Button>  

                                                          <ext:Button ID="Button1" 
                            runat="server" 
                            Text="Auto Save"
                            EnableToggle="true"
                            Pressed="true"
                            ToolTip="When enabled, Store will execute Ajax requests as soon as a Record becomes dirty.">
                            <Listeners>
                                <Toggle Handler="#{strPers}.autoSave = true;" />
                            </Listeners>
                        </ext:Button>

                                     
                                                        
                                                                <ext:Button ID="Button3" runat="server" Icon="Delete"  Text="Temizle..." Width="100" >              
                                                          <DirectEvents>                   
                                                           <Click OnEvent="btnClear_Click" >                                                                
                                                           </Click>
                                                          </DirectEvents>
                                                      </ext:Button>   
                                                    

                                                           <ext:Button ID="Button2" runat="server" Text="Save" Icon="Disk">
                                                            <Listeners>
                                                                <Click Handler="#{grdPers}.save();" />
                                                            </Listeners>
                                                        </ext:Button>
                                                                                                  
                                                </Items>
                                            </ext:Toolbar>                                                                                                                                                                                                                                                     
                                </TopBar>  

                             

                           </ext:GridPanel>       
                            
                            
                            
                                                                                                                                                
                       </Items>                                      
                 </ext:Window>                                                                                                                 
                                                                                                                                                                                                                                    
                                              
           
                     
                          
                                             
            
    </form>



</body>
</html>
