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
            var store1 = this.GridPanel1.GetStore();
            store1.DataSource = GetData();
            store1.DataBind();



            Window2.Show();
          
        }
    } 
    public object[] GetDataIzinDurum()
    {
        string code = Session["CODE"].ToString();
        Data.IZINLER[] List =
        new DevExpress.Xpo.XPCollection<Data.IZINLER>
        (Data.XP.Crs).Where(y=> y.CODE==code).OrderBy(x => x.YIL).ToArray();


         decimal sm =
        List.Sum(x => decimal.Parse(x.HAKEDILEN_IZIN.Replace("gün", ""))  - decimal.Parse(x.KULLANILAN_IZIN.Replace("gün", "")));
        
        decimal sm1=
        List.Sum(x => decimal.Parse(x.HAKEDILEN_IZIN.Replace("gün", "")));


        decimal sm2 =
        List.Sum(x => decimal.Parse(x.KULLANILAN_IZIN.Replace("gün", "")));



        lblHak.Text = sm1.ToString() + " gün";
        lblKul.Text = sm2.ToString() + " gün";
        lblLREF.Text = sm.ToString() + " gün";
      
   
        
        object[] Lobj = new object[List.Length];

        for (int i = 0; i < List.Length; i++)
        {
            Data.IZINLER kty = List[i];
            Lobj[i] = new object[] {                    
           kty.CODE,
           kty.NAME,
           kty.SURNAME,
           kty.YIL,
           kty.HAKEDILEN_IZIN,
           kty.KULLANILAN_IZIN,
           kty.DEVREDEN,
           kty.KULLANILMIS_IZIN,
           kty.BAKIYE,
   
           kty.LREF,
        
            };
        }
        return Lobj;
    }
      public object[] GetDataIzinler()
    {

       string code = Session["CODE"].ToString();
        Data.IZINTANIM[] List =
        new DevExpress.Xpo.XPCollection<Data.IZINTANIM>
        (Data.XP.Crs).Where(y=> y.CODE==code).OrderBy(x=> x.Expr1).ToArray();
        
         
        object[] Lobj = new object[List.Length];
        
          
          
        for (int i = 0; i < List.Length; i++)
        {
            Data.IZINTANIM kty = List[i];    
            Lobj[i] = new object[] {                    
            kty.CODE,
            kty.EXP,
            kty.Expr1,
            kty.Expr2,
            kty.Expr3,
            kty.PERIOD
            };
        }
          return Lobj;
    }

    public object[] GetData()
    {
        Session["lblLREF_Text"] = lblLREF;
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
        
        
        
        
        
        foreach (Data.vPersoneller pers in obj)
        {
            Session["CODE"] = pers.SICILNO;
            var strPers = this.grdIZIN.GetStore();
            strPers.DataSource = GetDataIzinDurum();
            strPers.DataBind();
            

           
            
            txtSicilNumarasi.Text = pers.EkBilgiler.SICILNO;
            txtAdi.Text = pers.EkBilgiler.ADI;
            txtSoyadi.Text = pers.EkBilgiler.SOYADI;
       

           
       

         


            WndIzinDurum.Hidden = false;
            WndIzinDurum.ShowModal();

            

        }
        

    }

   
</script>

    

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN"  "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head id="Head1" runat="server">
     <title> İzin Yönetimi </title>
    <ext:ResourcePlaceHolder ID="ResourcePlaceHolder1" runat="server" Mode="Script" />   
    <link rel="StyleSheet1.css" type="text/css" href="../../../../resources/css/main.css" />
      <link href="../../../../resources/css/examples.css" rel="stylesheet" type="text/css" />  
 
    <style type="text/css">
        .mytext-field input x-form-text
        {
            text-align: right;
        }



    </style>
        
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
    
    <form id="Form1" runat="server">
        <ext:ResourceManager ID="ResourceManager1" runat="server"> </ext:ResourceManager>
        
        <ext:Store ID="Store1" runat="server">
           
        </ext:Store>
        <ext:Window
             ID="WndIzinDurum"
                        runat="server" 
                        Width="890"
                        Height="380"            
                          
                         X="1400"
                        Closable="true"         
                        Resizable="true"
                        Draggable="true"
                        Padding="4"
                        Hidden="true"
                        Modal="true"   
                        Layout="AbsoluteLayout">
            <Items>   
                <ext:Panel ID="Panel1" runat="server" Width="1000" Height="700"  >
                <Items>
                <ext:BorderLayout  runat="server">
                    <Center>
                          <ext:FormPanel ID="FormPanel1" runat="server"  Title="İzin Durumu"  Padding="3" ButtonAlign="Right" BodyStyle="background-color: #DFE8F6"   Width="820">
                            <Items>
                              <ext:fieldset ID="compositefield3" runat="server"  Title="TOPLAM"  Width="300" AutoHeight="true" Style="position:absolute; left:500px;">
                                  <Items>
                           <ext:Label ID="lblHak" runat="server"  FieldLabel="Hakedilen İzin"   Hidden="false" style="position:absolute; top:3px;" />
                           <ext:Label ID="lblKul" runat="server"  FieldLabel=" Kullanılan İzin"   Hidden="false" Style="position:absolute; top:20px; " />
                            <ext:Label ID="lblLREF" runat="server"  FieldLabel="Kalan İzin"   Hidden="false" Style="position:absolute; top:42px; "/>
                                       
                                      </Items>
                                  </ext:fieldset>
                           <ext:TriggerField 
                           ID="txtSicilNumarasi" 
                            runat="server" 
                             Width="300" 
                           Editable="false"
                             FieldLabel="Sicil Numarasi" 
                             LabelStyle="position:absolute; top:13px;"
                                Y="6"
                                X="40">
                               
                          
                          
                           <Triggers>
                     
                        <ext:FieldTrigger Icon="Ellipsis" /> 
                                         
                    </Triggers>
                   <Listeners>                
                       
                <TriggerClick Handler="#{Window2}.show(); if (#{Window2}.autoComplete) {#{CellEditing1}.completeEdit();}   " />
                </Listeners>
              </ext:TriggerField>
                               
                           <ext:TriggerField 
                           ID="txtAdi" 
                            runat="server" 
                             Width="300" 
                           Editable="false"
                             FieldLabel="Adi"
                               LabelStyle="position:absolute; top:39px;"
                                Y="6"
                                X="40">
                          
                           <Triggers>
                      
                        <ext:FieldTrigger Icon="Ellipsis" />
                                          
                        </Triggers>
                         <Listeners>                
                         <TriggerClick Handler="#{Window2}.show();   if (#{Window2}.autoComplete) {#{CellEditing1}.completeEdit();}  " />
                       </Listeners>
                        </ext:TriggerField>

                           <ext:TriggerField 
                           ID="txtSoyadi" 
                            runat="server" 
                             Width="300" 
                           Editable="false"
                             FieldLabel="Soyadı"
                               LabelStyle="position:absolute; top:63px;"
                               X="40"
                             Y="6">
                           
                           <Triggers>
                     
                         <ext:FieldTrigger Icon="Ellipsis" />
                                          
                          </Triggers>
                          <Listeners>                
                         <TriggerClick Handler="#{Window2}.show();  if (#{Window2}.autoComplete) {#{CellEditing1}.completeEdit();}" />
                          </Listeners>
                               </ext:TriggerField>
                              </Items>
                            
                                </ext:FormPanel>
                  
                            
                              </Center>
                        </ext:BorderLayout>
                                        
               
                      </Items>
          
         
            
            </ext:Panel>
                                               
                            <ext:GridPanel
                            ID="grdIZIN"
                            runat="server" 
                            StripeRows="true"            
                            Width="960" 
                            Height="200" Y="140"                                         
                            TrackMouseOver="true" ColumnWidth="0.01">
                                
                            
                            

                               <Store>                          
                                  <ext:Store 
                                    ID="strPers" 
                                    runat="server" >
                                                                
                                    <Reader>
                                         <ext:ArrayReader>                                         
                                           <Fields>
                                                <ext:RecordField Name="CODE" />
                                                <ext:RecordField Name="NAME" />
                                                <ext:RecordField Name="SURNAME" />
                                                <ext:RecordField Name="YIL" />
                                                <ext:RecordField Name="HAKEDILEN_IZIN" />
                                                <ext:RecordField Name="KULLANILAN_IZIN" />
                                               <ext:RecordField Name="DEVREDEN" />
                                               <ext:RecordField Name="KULLANILMIS_IZIN" />
                                               <ext:RecordField Name="BAKIYE" />                                              
                                        
                                                
                                           </Fields>
                                        </ext:ArrayReader>
                                    </Reader>
                                </ext:Store>                                                                            
                                </Store>
                                                                                                                                                                                  
                               <ColumnModel ID="ColumnModel2" runat="server">
                                    <Columns>                                                      
                                   
                                            <ext:Column Header="SİCİL NO"  DataIndex="CODE" />
                                            <ext:Column Header="ADI"  DataIndex="NAME" />
                                            <ext:Column Header="SOYADI"  DataIndex="SURNAME" />
                                            <ext:Column Header="YIL"  DataIndex="YIL" />
                                            <ext:Column Header="HAKEDİLEN İZİN"  DataIndex="HAKEDILEN_IZIN" />
                                             <ext:Column Header="KULLANILAN İZİN"  DataIndex="KULLANILAN_IZIN" />
                                            <ext:Column Header="DEVREDEN"  DataIndex="DEVREDEN" />
                                              <ext:Column Header="KULLANILMIS İZİN"  DataIndex="KULLANILMIS_IZIN" />
                                       <ext:Column Header="BAKİYE"  DataIndex="BAKIYE" />
                                          

                                            
                                    </Columns>
                                  </ColumnModel> 
                                  <SelectionModel>
                
                                            <ext:RowSelectionModel ID="RowSelectionModel1"  runat="server"  HideCheckAll="false"  AllowDeselect="true"   />
                                        </SelectionModel>
                                                                                        
                               <BottomBar>
                                    
                                             
                         
                                    </BottomBar>

                               
                                           


                           </ext:GridPanel>     
                      
            </Items>
      

            </ext:Window>


           <ext:Window ID="Window2" 
                      Draggable="false" 
                      Resizable="false" 
                      runat="server"  
                      Width="1100" Height="900" 
                      Padding="1" X="1" Y="1" Closable="false"  Hidden="true">                    
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
                                                ID="Store2" 
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
                                                        <ext:CheckboxSelectionModel ID="CheckboxSelectionModel1"  runat="server"  HideCheckAll="false"  AllowDeselect="true"  SingleSelect="true"  />
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
                                                   
                                                    
                                                                          <ext:Button ID="Button2" runat="server" Icon="Accept"  Text="incele" Width="100" >              
                                                                      <DirectEvents>     
                                                                                        
                                                                       <Click OnEvent="btnOk_Click" >     
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
