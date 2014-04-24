    <%@ Page Language="C#" %>

<%@ Import Namespace="Ext.Net.Utilities"%>
<%@ Import Namespace="System.Collections.Generic" %>
<%@ Import Namespace="System.Linq" %>
<%@ Import Namespace="System.Data.SqlClient" %>

<%@ Register Assembly="Ext.Net" Namespace="Ext.Net" TagPrefix="ext" %>
 

<script runat="server">
      
    Window win;  
            
    protected void Page_Load(object sender, EventArgs e)
    {
        
        if (!X.IsAjaxRequest)
        {                  
            var store1 = this.GridPanel1.GetStore();                      
            store1.DataSource = GetData();
            store1.DataBind();

           

            StoreComboBelgeler.DataSource = new DevExpress.Xpo.XPCollection<Data.TANIMLAR>(
                Data.XP.Crs,
                DevExpress.Data.Filtering.CriteriaOperator.Parse(" TIP = (?) ", 1));
            
            StoreComboBelgeler.DataBind();                                                                     
        }


        win = new Window
        {
            ID = "wndPDF",
            Title = "Belge İçeriği",
            Width = Unit.Pixel(1000),
            Height = Unit.Pixel(600),
            Modal = true,
            Collapsible = true,
            Maximizable = true,
            Hidden = true
        };

        win.AutoLoad.Url = "../FormPDF.aspx";
        win.AutoLoad.Mode = LoadMode.IFrame;

        win.Render(this.Form);         
    }


    protected void btnClear_Click(object sender, DirectEventArgs e)
    {



    }

    protected void btnCikis_Click(object sender, DirectEventArgs e)
    {

     
        WndBelgeEkle.Hidden = true;
        

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
        return Lobj;
            
    }

    public object[] GetDataBelgler(int LREF)
    {

        Session["lblLREF_Text"] = LREF;
        
        Data.PersonalBelgeler[] List =
        new DevExpress.Xpo.XPCollection<Data.PersonalBelgeler>
            (Data.XP.Crs, DevExpress.Data.Filtering.CriteriaOperator.Parse("LREF = (?) ", LREF)).ToArray();

        object[] Lobj = new object[List.Length];

        for (int i = 0; i < List.Length; i++)
        {
            Data.PersonalBelgeler kty = List[i];
            Lobj[i] = new object[] {                    
                kty.BELGE_TURU  ,
                kty.SICIL_NUMARASI  ,
                kty.FIRMA  ,
                kty.PERSONAL_NUMARASI  ,
                kty.PERSONAL_ID  ,
                kty.LREF  ,
                kty.AD  ,
                kty.SOYAD  ,
                kty.FileName  ,
                kty.FileFullName  ,
                kty.TARIH  ,
                kty.USERID  ,
            };
        }
        return Lobj;
    }

 protected void FileUploadField_FileSelected(object sender, DirectEventArgs e)
    {
          string pth = Server.MapPath("~") + "Files";

        string fname = this.fileupload1.PostedFile.FileName;

        if (this.fileupload1.PostedFile.FileName.Trim() == "")
            return;

        this.fileupload1.PostedFile.SaveAs(pth + "\\" + fname);



        Data.PersonalBelgeler belg = new Data.PersonalBelgeler(Data.XP.Crs);
        belg.LREF = (int)Session["lblLREF_Text"];
        belg.FileFullName = pth;
        belg.FileName = fname;
        belg.FILE = System.IO.File.ReadAllBytes(pth + "\\" + fname);
        belg.TARIH = DateTime.Now;

        if (Session["cmbBelgeTurSelect"] != null)
            belg.BELGE_TURU = Session["cmbBelgeTurSelect"].ToString();

        belg.Save();

        var store2 = this.GridPanel3.GetStore();
        store2.DataSource = GetDataBelgler(belg.LREF);
        store2.DataBind();  
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

         lblLREF.Text = "  < " + obj.First().AD + " " + obj.First().SOYAD + ">";
        
        var store2 = this.GridPanel3.GetStore();
        store2.DataSource = GetDataBelgler(obj.First().LREF);
        store2.DataBind();    

        WndBelgeEkle.Hidden = false;
        WndBelgeEkle.Show();

       
    }

    protected void btnIncele_Click(object sender, DirectEventArgs e)
    {

        string json = e.ExtraParams["record"];


        List<Data.PersonalBelgeler> obj = Newtonsoft.Json.JsonConvert.DeserializeObject<List<Data.PersonalBelgeler>>(json);

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

        string fl = obj.First().FileFullName + "\\" + obj.First().FileName;
        Session["PDF_FILE"] = fl;
        win.Show();
        
    }

    protected void ProjectSelect(object sender, DirectEventArgs e)
    {
        Session["cmbBelgeTurSelect"] = cmbBelgeTur.SelectedItem.Text;
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

        var submitValue = function(form, hiddenFormat, format){
        
            hiddenFormat.setValue(format);
            form.submitData(false);
        
        }


    </script>
   
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
                
               
                 <ext:Store 
                    ID="StoreComboBelgeler" 
                    runat="server">
                    <Reader>
                            <ext:JsonReader>
                                 <Fields>                              
                                            <ext:RecordField Name="EXP1"  />    
                                            <ext:RecordField Name="OID"  />                      
                                 </Fields>
                            </ext:JsonReader>                        
                    </Reader>
                </ext:Store>  
        
        
            <ext:Window  
            ID="WndBelgeEkle"
                        runat="server" 
                        Width="750"
                        Height="450"            
                        Title="Belge Tipi"
                        Icon="Lightbulb"
                        Closable="true"         
                        Resizable="true"
                        Draggable="true"
                        Padding="4"
                        Hidden="true"
                        Modal="true"   
                        Layout="AbsoluteLayout">                                                                                          
                
             <Items>
 
               <ext:GridPanel
                            ID="GridPanel3"
                            runat="server" 
                            StripeRows="true"            
                            Width="850" 
                            Height="400" Y="1"   
                            Layout="AbsoluteLayout">                                         
                                           
                             <Store>                          
                                              <ext:Store 
                                                ID="Store2" 
                                                runat="server">
                                                 <DirectEventConfig IsUpload="true" />
                                                <Reader>
                                                     <ext:ArrayReader>                                         
                                                       <Fields>
                                                            <ext:RecordField Name="BELGE_TURU" />
                                                            <ext:RecordField Name="SICIL_NUMARASI" />
                                                            <ext:RecordField Name="FIRMA" />
                                                            <ext:RecordField Name="PERSONAL_NUMARASI" />
                                                            <ext:RecordField Name="PERSONAL_ID" Type="Int" />
                                                            <ext:RecordField Name="LREF" Type="Int"/>
                                                            <ext:RecordField Name="AD" />
                                                            <ext:RecordField Name="SOYAD" />
                                                            <ext:RecordField Name="FileName" />
                                                            <ext:RecordField Name="FileFullName" />
                                                            <ext:RecordField Name="TARIH" Type="Date" />
                                                            <ext:RecordField Name="USERID" Type="Int"  />                                                      
                                                       </Fields>
                                                    </ext:ArrayReader>
                                                </Reader>
                                            </ext:Store>                                                                            
                                            </Store>
                   
                             <ColumnModel ID="ColumnModel2" runat="server">
                                                <Columns>      
                                                    <ext:RowNumbererColumn />                                                                                                   
                                                    
                                                        <ext:Column Header="Belge Türü"  DataIndex="BELGE_TURU"  />
                                                        <ext:Column Header="Dosya Adı"  DataIndex="FileName" Width="80" />
                                                        <ext:Column Header="Dosya Yolu"  DataIndex="FileFullName" Width="120" />     
                                                        <ext:Column Header="Tarih"  DataIndex="TARIH"  />    
                                                        
                                                        <ext:Column Header="SICIL_NUMARASI"  DataIndex="SICIL_NUMARASI"  Hidden="true"/>                                                        
                                                        <ext:Column Header="PERSONAL_NUMARASI"  DataIndex="PERSONAL_NUMARASI" Hidden="true" />
                                                        <ext:Column Header="PERSONAL_ID"  DataIndex="PERSONAL_ID" Hidden="true" />
                                                        <ext:Column Header="LREF"  DataIndex="LREF"  Hidden="true" />
                                                        <ext:Column Header="AD"  DataIndex="AD"  Hidden="true"/>
                                                        <ext:Column Header="SOYAD"  DataIndex="SOYAD" Hidden="true" />                                                        
                                                        <ext:Column Header="USERID"  DataIndex="USERID" Hidden="true" /> 

                                                </Columns>
                                              </ColumnModel> 
                                              
                             <TopBar>
                                      
                                 <ext:Toolbar ID="Toolbar2" runat="server"  >
                                                <Items>
                                                 
                                                

                                                          <ext:FileUploadField ID="fileupload1" runat="server"  ButtonText="Ekle..." Text="" Icon="Add" Width="300" >                                                               
                                                           <DirectEvents>
                                                           <FileSelected OnEvent="FileUploadField_FileSelected" IsUpload="true" > 
                                                           </FileSelected>
                                                           </DirectEvents>                                                              
                                                          </ext:FileUploadField>
                                                 



                                                    
                                   <ext:ComboBox
                                      ID="cmbBelgeTur"
                                      runat="server"
                                      Editable="false"
                                      TypeAhead ="true"                                        
                                       Width="230"                                   
                                     TriggerAction="All"   FieldLabel="Belge Türü"         
                                     StoreID="StoreComboBelgeler"  DisplayField="EXP1"  ValueField="OID"  Mode="Local"  
                                       ForceSelection="true" SelectOnFocus="true"  >                                                        
                                               <DirectEvents>
                                                    <Select OnEvent="ProjectSelect">
                                                        <EventMask ShowMask="true" />
                                                    </Select>
                                                </DirectEvents>                                                                                                                                                                                         
                                   </ext:ComboBox>
                                                                                          
                                                    
                                                       <ext:Button ID="Button6" runat="server" Icon="Delete"  Text="Temizle..." Width="100">              
                                                          <DirectEvents>

                                                          </DirectEvents>                                                                          
                                                      </ext:Button>  


                                                    <ext:Button ID="btnIncele" runat="server" Text="İncele" Icon="Reload" Width="100" >
                                                      <DirectEvents>
                                                          <Click OnEvent="btnIncele_Click" >
                                                              <ExtraParams>
                                                               <ext:Parameter Name="record" Value="Ext.encode(#{GridPanel3}.getRowsValues({selectedOnly:true}))" Mode="Raw" />
                                                             </ExtraParams>  
                                                          </Click>
                                                      </DirectEvents>
                                                    </ext:Button>
                                                   
                                     
                                                    
                                                </Items>

                                 
                                            </ext:Toolbar>               
                                   </TopBar>                                                                                                         
                                        
                             <BottomBar>
                                    
                                             <ext:PagingToolbar ID="PagingToolbar2" runat="server" PageSize="20" >
                                            <Items>
                                                <ext:Label ID="Label2" runat="server" Text="Page size:" />
                                                <ext:ToolbarSpacer ID="ToolbarSpacer2" runat="server" Width="10" />
                                                <ext:ComboBox ID="ComboBox2" runat="server" Width="80">
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
                                                <ext:Label ID="lblLREF" runat="server" Text="" Hidden="false"  />
                                            </Items>
                                              </ext:PagingToolbar>
                                           
                                    </BottomBar>
               
                                  
                                   
                                                     <SelectionModel>               
                                                    <ext:RowSelectionModel ID="RowSelectionModel1" SingleSelect="true" />
                                                </SelectionModel>

                  </ext:GridPanel>
                                                                         
             </Items>
          
             </ext:Window>
         



         
        





















                                                                                                                                                
                   <ext:Window ID="Window2" 
                      Draggable="false" 
                      Resizable="false" 
                      runat="server"  
                      Width="1100" Height="900" 
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
                                                        <ext:CheckboxSelectionModel  runat="server"  HideCheckAll="false"  AllowDeselect="true"  SingleSelect="true"  />
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
                                                   
                                                    
                                                                          <ext:Button ID="Button2" runat="server" Icon="Accept"  Text="İleri..." Width="100" >              
                                                                      <DirectEvents>                   
                                                                       <Click OnEvent="btnOk_Click" >     
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
                                                                                                                                                                                                                                    
                                                       
           
                     
                          
                                             
            
    </form>





</body>
</html>
