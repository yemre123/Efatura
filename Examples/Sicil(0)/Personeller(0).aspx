<%@ Page Language="C#" %>

<%@ Import Namespace="Ext.Net.Utilities"%>
<%@ Import Namespace="System.Collections.Generic" %>
<%@ Import Namespace="System.Linq" %>

<%@ Register Assembly="Ext.Net" Namespace="Ext.Net" TagPrefix="ext" %>
 

<script runat="server">
        
            
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!X.IsAjaxRequest)
        {
                                      
            var store1 = this.GridPanel1.GetStore();
          
            //var store2 = this.ComboBox2.GetStore();
            //var store3 = this.ComboBox3.GetStore();
            //var store4 = this.ComboBox4.GetStore();

            store1.DataSource = GetData();
            store1.DataBind();

            //store2.DataSource = Data.Util.En.GetHataKaynaklar();
            //store2.DataBind();

            //store3.DataSource = Data.Util.En.GetDepartman();
            //store3.DataBind();

            //store4.DataSource = Data.Util.En.GetDepartman();
            //store4.DataBind();                        
        }
    }
 


    public object[] GetData()
    {

        Data.vPersoneller[] List =
        new DevExpress.Xpo.XPCollection<Data.vPersoneller>
            (Data.XP.Crs, DevExpress.Data.Filtering.CriteriaOperator.Parse("TYP=1")).OrderBy(x => x.SiraNo).ToArray();


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
             kty.SiraNo
            };
        }
        
        

        /*
        return new object[] {
            
            new object[] { "3m Co","stkad","stkod", 71.72,"tnm","musteri","user","htkaynak","dept","hkod","had","2001-01-01 12:11:01",2,1234 }                        
            e
        };
         * */
        return Lobj;
    }


    protected void Store1_Submit(object sender, StoreSubmitDataEventArgs e)
    {
        System.Xml.XmlNode xml = e.Xml;

        this.Response.Clear();

        this.Response.ContentType = "application/vnd.ms-excel";
        this.Response.AddHeader("Content-Disposition", "attachment; filename=submittedData.xls");
        System.Xml.Xsl.XslCompiledTransform xtExcel = new System.Xml.Xsl.XslCompiledTransform();
        xtExcel.Load(Server.MapPath("Excel.xsl"));
        xtExcel.Transform(xml, null, Response.OutputStream);

        this.Response.End();
    }


    protected void btnDetay_Click(object sender, DirectEventArgs e)
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

        string tit = "Personel Detayları  <" + obj.First().AD + " " + obj.First().SOYAD + ">";


        Data.vPersoneller mPers = obj.First();

        txtEK_Personel.Text = mPers.AD + " " + mPers.SOYAD;
        WndSicil.Title = tit;


        txtEKSicilNo.Text = mPers.SICILNO;
        txEkAdi.Text = mPers.AD;
        txtEkSoyad.Text = mPers.SOYAD;

        txtEkKurum.Text = "";
        txtEkBolum.Text = "";
        txtEkIsYeri.Text = mPers.ISYERI;

        


        var snc = new DevExpress.Xpo.XPCollection<Data.vPersonelEkBilgiler>(
            Data.XP.Crs,
            DevExpress.Data.Filtering.CriteriaOperator.Parse("LREF = (?) ", obj.First().LREF));


        if (snc.Count() > 0)
        {
            Data.vPersonelEkBilgiler pers = snc.First();

            txtEK_Adres.Text = pers.ADRES;
            txtEK_AnneAdi.Text = pers.ANNEADI;
            txtEK_BabaAdi.Text = pers.BABAADI;
            txtEK_CepTel1.Text = pers.CEPTEL1;
            txtEK_CepTel2.Text = pers.CEPTEL2;
            txtEK_DogumYeri.Text = pers.DOGUMYERI;
            txtEK_EK_Birim.Text = pers.BIRIM;
            txtEK_Email.Text = pers.EMAIL;
            txtEK_EvTel.Text = pers.EVTEL;
            txtEK_Ilce.Text = pers.ILCE;
            txtEK_KanGrubu.Text = pers.KANGRUBU;
            txtEK_MedeniHal.Text = pers.MEDENIHAL;
            txtEK_SSKStatu.Text = pers.SSKSTATUS;
            txtEK_TcNo.Text = pers.TCKIMLIK;

            dtDogumTarihi.Value = pers.DOGUMTARIHI;
        }

        WndSicil.Show();
    }
    
    protected void btnOk_Click(object sender, DirectEventArgs e)
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

        string ids = "";

        foreach (string s in obj.Select(c => c.LREF.ToString()))
            ids += s + " , ";        

        Response.Redirect("WebForm1a.aspx?ID=" + ids + "&Page=Personeller(0).aspx&PersTip=1");                     
    }

    protected void btnClear_Click(object sender, DirectEventArgs e)
    {
            
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
       var submitValue = function(grid, hiddenFormat, format) {
           hiddenFormat.setValue(format);
           
           grid.submitData(false);           
       };
            
    </script>
    
<ext:XScript ID="XScript1" runat="server">
        <script type="text/javascript">
                         
                  
            var applyFilter = function (field) {                
                var store = #{GridPanel1}.getStore();
                store.suspendEvents();
                store.filterBy(getRecordFilter());                                
                store.resumeEvents();
                #{GridPanel1}.getView().refresh(false);
            };
             
            var clearFilter = function () {
                #{txtFIRMA}.reset();                                
                #{txtDEPARTMAN}.reset(); 
                #{txtISYERI}.reset();                                
                #{txtSICILNO}.reset(); 
                #{txtAD}.reset(); 
                #{txtSOYAD}.reset(); 
                #{txtCINSIYET}.reset(); 
                #{txtTITLE}.reset(); 
                #{txtSSKNO}.reset(); 
                #{txtTTFNO}.reset(); 
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
                        return filterString(#{txtFIRMA}.getValue(), "FIRMA", record);
                    }
                });
                
                f.push({
                    filter: function (record) {                         
                        return filterString(#{txtDEPARTMAN}.getValue(), "DEPARTMAN", record);
                    }
                });
                
                  f.push({
                    filter: function (record) {                         
                        return filterString(#{txtISYERI}.getValue(), "ISYERI", record);
                    }
                });
                
                
                   f.push({
                    filter: function (record) {                         
                        return filterString(#{txtSICILNO}.getValue(), "SICILNO", record);
                    }
                });
                
                   f.push({
                    filter: function (record) {                         
                        return filterString(#{txtAD}.getValue(), "AD", record);
                    }
                });
                
                   f.push({
                    filter: function (record) {                         
                        return filterString(#{txtSOYAD}.getValue(), "SOYAD", record);
                    }
                });
                
                   f.push({
                    filter: function (record) {                         
                        return filterString(#{txtCINSIYET}.getValue(), "CINSIYET", record);
                    }
                });
                
                      f.push({
                    filter: function (record) {                         
                        return filterString(#{txtTITLE}.getValue(), "TITLE", record);
                    }
                });
                
                      f.push({
                    filter: function (record) {                         
                        return filterString(#{txtSSKNO}.getValue(), "SSKNO", record);
                    }
                });
                 
                         f.push({
                    filter: function (record) {                         
                        return filterString(#{txtTTFNO}.getValue(), "TTFNO", record);
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
                    
                    
                    <ext:Hidden ID="FormatType" runat="server" />
                                                                                                                                                            
                   <ext:Window ID="Window2" 
                      Draggable="false" 
                      Resizable="false" 
                      runat="server"  
                      Width="1100" Height="560" 
                      Padding="1" X="1" Y="1" Closable="false" >                      
            <Items>
                                                                                                           
               <ext:GridPanel
                            ID="GridPanel1"
                            runat="server" 
                            StripeRows="true"            
                            Width="1085" 
                            Height="545" Y="1"                                                 
                            TrackMouseOver="true">
                            
                               <Store>                          
                                  <ext:Store 
                                    ID="Store1" 
                                    runat="server" 
                                    OnSubmitData="Store1_Submit">
                                     <DirectEventConfig IsUpload="true" />
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
                                           </Fields>
                                        </ext:ArrayReader>
                                    </Reader>
                                </ext:Store>                                                                            
                                </Store>
                            
                                 <ColumnModel ID="ColumnModel1" runat="server">
                                    <Columns>      
                                        <ext:RowNumbererColumn />              
                                                    
                                   
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
                                                    <ext:Button ID="Button1" runat="server" Text="To Xls" Icon="PageExcel"  >
                                                          <Listeners>
                                                            <Click Handler="submitValue(#{GridPanel1}, #{FormatType}, 'xls');" />
                                                        </Listeners>
                                                    </ext:Button>
                                                    
                                                              <ext:Button ID="Button2" runat="server" Icon="Accept"  Text="İncele" Width="100" >              
                                                          <DirectEvents>                   
                                                           <Click OnEvent="btnOk_Click" >     
                                                               <ExtraParams>
                                                                     <ext:Parameter Name="record" Value="Ext.encode(#{GridPanel1}.getRowsValues({selectedOnly:true}))" Mode="Raw" />
                                                               </ExtraParams>
                                                           </Click>
                                                          </DirectEvents>
                                                      </ext:Button>   

                                                    <ext:Button ID="Button4" runat="server" Icon="ApplicationForm" Text="Detay" Width="100"> 
                                                        <DirectEvents>
                                                            <Click OnEvent="btnDetay_Click">
                                                                <ExtraParams>
                                                                    <ext:Parameter Name="record" Value="Ext.encode(#{GridPanel1}.getRowsValues({selectedOnly:true}))" Mode="Raw" />                                                               
                                                                </ExtraParams>                                                            
                                                           </Click>
                                                            
                                                        </DirectEvents>
                                                    </ext:Button>
                                                      
                                                   
                                                                <ext:Button ID="Button3" runat="server" Icon="Delete"  Text="Temizle..." Width="100" >              
                                                          <DirectEvents>                   
                                                           <Click OnEvent="btnClear_Click" >     
                                                               <ExtraParams>
                                                                     <ext:Parameter Name="record" Value="Ext.encode(#{GridPanel1}.getRowsValues({selectedOnly:true}))" Mode="Raw" />
                                                               </ExtraParams>
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
                                        <ext:TextField ID="txtFIRMA" runat="server" EnableKeyEvents="true">
                                            <Listeners>
                                                <KeyUp Handler="applyFilter(this);" Buffer="250" />                                                
                                            </Listeners>
                                        </ext:TextField>
                                    </Component>
                                </ext:HeaderColumn>
                                
                                      <ext:HeaderColumn Cls="x-small-editor">
                                    <Component>
                                        <ext:TextField ID="txtDEPARTMAN" runat="server" EnableKeyEvents="true">
                                            <Listeners>
                                                <KeyUp Handler="applyFilter(this);" Buffer="250" />                                                
                                            </Listeners>
                                        </ext:TextField>
                                    </Component>
                                </ext:HeaderColumn>
                                
                                
                                       <ext:HeaderColumn Cls="x-small-editor">
                                    <Component>
                                        <ext:TextField ID="txtISYERI" runat="server" EnableKeyEvents="true">
                                            <Listeners>
                                                <KeyUp Handler="applyFilter(this);" Buffer="250" />                                                
                                            </Listeners>
                                        </ext:TextField>
                                    </Component>
                                </ext:HeaderColumn>
                                
                                
                                
                                        <ext:HeaderColumn Cls="x-small-editor">
                                    <Component>
                                        <ext:TextField ID="txtSICILNO" runat="server" EnableKeyEvents="true">
                                            <Listeners>
                                                <KeyUp Handler="applyFilter(this);" Buffer="250" />                                                
                                            </Listeners>
                                        </ext:TextField>
                                    </Component>
                                </ext:HeaderColumn>
                                
                          
                                
                                  <ext:HeaderColumn Cls="x-small-editor">
                                    <Component>
                                        <ext:TextField ID="txtAD" runat="server" EnableKeyEvents="true">
                                            <Listeners>
                                                <KeyUp Handler="applyFilter(this);" Buffer="250" />                                                
                                            </Listeners>
                                        </ext:TextField>
                                    </Component>
                                </ext:HeaderColumn>
                                
                                  <ext:HeaderColumn Cls="x-small-editor">
                                    <Component>
                                        <ext:TextField ID="txtSOYAD" runat="server" EnableKeyEvents="true">
                                            <Listeners>
                                                <KeyUp Handler="applyFilter(this);" Buffer="250" />                                                
                                            </Listeners>
                                        </ext:TextField>
                                    </Component>
                                </ext:HeaderColumn>
                                           
                               <ext:HeaderColumn Cls="x-small-editor">
                                    <Component>
                                        <ext:TextField ID="txtCINSIYET" runat="server" EnableKeyEvents="true">
                                            <Listeners>
                                                <KeyUp Handler="applyFilter(this);" Buffer="250" />                                                
                                            </Listeners>
                                        </ext:TextField>
                                    </Component>
                                </ext:HeaderColumn>
                                           
                                           
                                           
                                     <ext:HeaderColumn Cls="x-small-editor">
                                    <Component>
                                        <ext:TextField ID="txtTITLE" runat="server" EnableKeyEvents="true">
                                            <Listeners>
                                                <KeyUp Handler="applyFilter(this);" Buffer="250" />                                                
                                            </Listeners>
                                        </ext:TextField>
                                    </Component>
                                </ext:HeaderColumn>
                                
                                     <ext:HeaderColumn Cls="x-small-editor">
                                    <Component>
                                        <ext:TextField ID="txtSSKNO" runat="server" EnableKeyEvents="true">
                                            <Listeners>
                                                <KeyUp Handler="applyFilter(this);" Buffer="250" />                                                
                                            </Listeners>
                                        </ext:TextField>
                                    </Component>
                                </ext:HeaderColumn>
                                
                                     <ext:HeaderColumn Cls="x-small-editor">
                                    <Component>
                                        <ext:TextField ID="txtTTFNO" runat="server" EnableKeyEvents="true">
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
                                  
            <ext:Window  
             ID="WndSicil"
                        runat="server" 
                        Width="750"
                        Height="550"            
                        Title=""
                        Icon="Lightbulb"
                        Closable="true"         
                        Resizable="true"
                        Draggable="true"
                        Padding="20"
                        Hidden="true"                     
                        Modal="true"  >                                                                                          
                
             <Items>
                                    
                 
             
                                  <ext:TextField ID="txtEKSicilNo" runat="server" FieldLabel="Sicil No" LabelWidth="100" Width="400" />
                                 <ext:TextField ID="txEkAdi" runat="server" FieldLabel="Adı" LabelWidth="100" Width="400"/>                                 
                                 <ext:TextField ID="txtEkSoyad" runat="server" FieldLabel="Soyadı" LabelWidth="100" Width="400" />

                                 <ext:TextField ID="txtEkKurum" runat="server" FieldLabel="Kurum" LabelWidth="100" Width="400" />
                                 <ext:TextField ID="txtEkBolum" runat="server" FieldLabel="Bölüm" LabelWidth="100" Width="400"/>                                 
                                 <ext:TextField ID="txtEkIsYeri" runat="server" FieldLabel="İş Yeri" LabelWidth="100" Width="400" />
                                 <ext:TextField ID="txtEK_EK_Birim" runat="server" FieldLabel="Birim" LabelWidth="100" Width="400" />
                                
                                                                                    

                   <ext:TabPanel 
                ID="TabPanel1" 
                runat="server" 
                ActiveTabIndex="0" 
                Width="700" 
                Height="300" 
                Plain="true">
                <Items>

                    <ext:Panel 
                        ID="Tab1" 
                        runat="server" 
                        Title="Bilgiler 1"                         
                        Padding="6" 
                        AutoScroll="true" 
                        >
                        <Items>

                                 
                                 <ext:TextField ID="txtEK_TcNo" runat="server" FieldLabel="Tc No" LabelWidth="100" Width="400"/>
                                 <ext:TextArea ID="txtEK_Adres" runat="server"  FieldLabel="Adres" LabelWidth="100" Width="600" Height="100"  />
                                 <ext:TextField ID="txtEK_Ilce" runat="server" FieldLabel="İlçe" LabelWidth="100" Width="400" />

                                 <ext:TextField ID="txtEK_EvTel" runat="server" FieldLabel="Ev Tel" LabelWidth="100" Width="400" />

                                <ext:TextField ID="txtEK_CepTel1" runat="server" FieldLabel="Cep Tel1" LabelWidth="100" Width="400" />
                                <ext:TextField ID="txtEK_CepTel2" runat="server" FieldLabel="Cep Tel2 " LabelWidth="100" Width="400" />

                            

                        </Items>

                    </ext:Panel>

                    <ext:Panel 
                        ID="Tab2" 
                        runat="server" 
                        Title="Bilgiler 2"                         
                        Padding="6"                       
                        >
                        <Items>

                            <ext:TextField ID="txtEK_Email" runat="server" FieldLabel="E-Posta " LabelWidth="100" Width="400" />

                                <ext:TextField ID="txtEK_BabaAdi" runat="server" FieldLabel="Baba Adı" LabelWidth="100" Width="400" />
                                <ext:TextField ID="txtEK_AnneAdi" runat="server" FieldLabel="Anne Adı" LabelWidth="100" Width="400" />

                                <ext:DateField ID="dtDogumTarihi" runat="server" Vtype="daterange"  FieldLabel="Doğum Tarihi" LabelWidth="100" Width="400"   />                                                                               

                        </Items>

                    </ext:Panel>

                    <ext:Panel 
                        ID="Tab3" 
                        runat="server" 
                        Title="Bilgiler 3"                         
                        Padding="6"
                        AutoScroll="true">
                        
                        <Items>

                                <ext:TextField ID="txtEK_DogumYeri" runat="server" FieldLabel="Doğum Yeri" LabelWidth="100" Width="400" />
                                <ext:TextField ID="txtEK_MedeniHal" runat="server" FieldLabel="Mededni Hak" LabelWidth="100" Width="400" />
                                <ext:TextField ID="txtEK_KanGrubu" runat="server" FieldLabel="Kan Grubu" LabelWidth="100" Width="400" />

                                <ext:TextField ID="txtEK_SSKStatu" runat="server" FieldLabel="SSk Durumu" LabelWidth="100" Width="400" />
                                <ext:TextField ID="txtEK_Personel" runat="server" FieldLabel="Personel" LabelWidth="100" Width="400" />

                        </Items>
                                                
                    </ext:Panel>

                    <ext:Panel 
                        ID="Tab4" 
                        runat="server" 
                        Title="Bilgiler 4"                         
                        Padding="6" 
                        AutoScroll="true">
                       
                    </ext:Panel>
                    
                </Items>
            </ext:TabPanel>

             </Items>    
                      
             </ext:Window>                                                                                                                                                                                                                                                                    
    </form>
</body>
</html>
