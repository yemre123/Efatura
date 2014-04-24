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
            kty.PERIOD,
            kty.DURUM
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
  
    protected void tam_Click(object sender, DirectEventArgs e)
    {
        if (Radio11.Checked==true)
        {
             var strPers = this.grdIZIN.GetStore();
             strPers.DataSource = GetDataIzinler();
             strPers.DataBind();
        }
        else if (Radio10.Checked==true)
        {
            strPers.RemoveAll();
        }
        else if (Radio1.Checked==true)
        {
            strPers.RemoveAll();
        }
        else if (Radio9.Checked==true)
        {
            strPers.RemoveAll();
        }
        
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

       
            txtSicilNumarasi.Text = pers.EkBilgiler.SICILNO;
            txtAdi.Text = pers.EkBilgiler.ADI;
            txtSoyadi.Text = pers.EkBilgiler.SOYADI;

            Session["CODE"] = pers.SICILNO;
            
           

            lblLREF.Text = "  < " + obj.First().AD + " " + obj.First().SOYAD + ">";

            Radio9.Checked = true;

            WndBelgeEkle.Hidden = false;
            WndBelgeEkle.ShowModal();

            

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
             ID="WndBelgeEkle"
                        runat="server" 
                        Width="900"
                        Height="700"            
                       
                        Icon="Lightbulb"
                        Closable="true"         
                        Resizable="true"
                        Draggable="true"
                        Padding="4"
                        Hidden="true"
                        Modal="true"   
                        Layout="AbsoluteLayout">
            <Items>   
                <ext:Panel ID="Panel1" runat="server" Width="800" Height="700" >
                <Items>
                <ext:BorderLayout  runat="server">
                    <Center>
                          <ext:FormPanel ID="FormPanel1" runat="server"  Title="İzin Planlama Kaydı"  Padding="3" ButtonAlign="Right" BodyStyle="background-color: #DFE8F6"   Width="130">
                            <Items>
                          <ext:FieldSet ID="fieldset1" runat="server"   Width="325" AutoHeight="true" Title="Planlanan">
                                                               
                             <Items>
                           <ext:TriggerField 
                           ID="txtSicilNumarasi" 
                            runat="server" 
                             Width="300" 
                           Editable="false"
                             FieldLabel="Sicil Numarasi" >
                               
                          
                          
                           <Triggers>
                     
                        <ext:FieldTrigger Icon="Ellipsis" /> 
                                         
                    </Triggers>
                   <Listeners>                
                       
                <TriggerClick Handler="#{Window2}.show(); if (#{Window2}.autoComplete) {#{CellEditing1}.completeEdit();}  #{Window2}.setTitle('1');  " />
                </Listeners>
              </ext:TriggerField>

                           <ext:TriggerField 
                           ID="txtAdi" 
                            runat="server" 
                             Width="300" 
                           Editable="false"
                             FieldLabel="Adi">
                          
                           <Triggers>
                      
                        <ext:FieldTrigger Icon="Ellipsis" />
                                          
                        </Triggers>
                         <Listeners>                
                         <TriggerClick Handler="#{Window2}.show();  #{Window2}.setTitle('1');  if (#{Window2}.autoComplete) {#{CellEditing1}.completeEdit();}  " />
                       </Listeners>
                        </ext:TriggerField>

                           <ext:TriggerField 
                           ID="txtSoyadi" 
                            runat="server" 
                             Width="300" 
                           Editable="false"
                             FieldLabel="Soyadı">
                          
                           <Triggers>
                     
                         <ext:FieldTrigger Icon="Ellipsis" />
                                          
                          </Triggers>
                          <Listeners>                
                         <TriggerClick Handler="#{Window2}.show();  #{Window2}.setTitle('1'); if (#{Window2}.autoComplete) {#{CellEditing1}.completeEdit();}" />
                          </Listeners>
                               </ext:TriggerField>
                              </Items>

                          </ext:FieldSet>
                                
                                 <ext:FieldSet ID="fieldset2" runat="server"   Width="325"  AutoHeight="true" Title="Planlayan"  Style="position:absolute; top:2px;  right:35px;">
                                                               
                             <Items>
                           <ext:TriggerField 
                           ID="txtSicilNumarasi2" 
                            runat="server" 
                             Width="300" 
                           Editable="false"
                             FieldLabel="Sicil Numarasi"
                               Text="78">
                               
                          
                           <Triggers>
                     
                        <ext:FieldTrigger Icon="Ellipsis" />
                                          
                    </Triggers>
                   <Listeners>                
                <TriggerClick Handler="#{Window2}.show();  #{Window2}.setTitle('2');  if (#{Window2}.autoComplete) {#{CellEditing1}.completeEdit();}" />
                </Listeners>
              </ext:TriggerField>

                           <ext:TriggerField 
                           ID="txtAdi2" 
                            runat="server" 
                             Width="300" 
                           Editable="false"
                             FieldLabel="Adi"
                              Text="HIZIR">
                          
                           <Triggers>
                      
                        <ext:FieldTrigger Icon="Ellipsis" />
                                          
                        </Triggers>
                         <Listeners>                
                         <TriggerClick Handler="#{Window2}.show();  #{Window2}.setTitle('2'); if (#{Window2}.autoComplete) {#{CellEditing1}.completeEdit();}" />
                       </Listeners>
                        </ext:TriggerField>

                           <ext:TriggerField 
                           ID="txtSoyadi2" 
                            runat="server" 
                             Width="300" 
                           Editable="false"
                             FieldLabel="Soyadı"
                             Text="FİŞEK">
                         
                           <Triggers>
                              
                    
                         <ext:FieldTrigger Icon="Ellipsis" />
                                          
                          </Triggers>
                          <Listeners>    
                              <TriggerClick EventArgument="triger1" />             
                         <TriggerClick Handler="#{Window2}.show();  #{Window2}.setTitle('2'); if (#{Window2}.autoComplete) {#{CellEditing1}.completeEdit();}" />
                          </Listeners>
                               </ext:TriggerField>
                                 <ext:DateField ID="DateField1" runat="server" FieldLabel="Planlama Tarihi"  Width="300" AnchorHorizontal="40%" />
         
                              </Items>

                          </ext:FieldSet>
                            
                         
                           

                              


                             
                              
                                  <ext:FieldSet ID="fldDurum" runat="server"  Width="760"  Height="115" style="position:absolute; top:135px;">
                                      <Items>
                                          <ext:ComboBox ID="cmbDurum" runat="server" FieldLabel="Durum"    Width="300">
                                              <Items>
                                                  <ext:ListItem Text="Plan" />
                                                  <ext:ListItem Text="İptal" />
                                                  <ext:ListItem Text="Ertelendi" />
                                                  <ext:ListItem Text="Yürürlükte" />
                                                  <ext:ListItem Text="Tamamlandı" />
                                              </Items>
                                              <SelectedItem Value="Plan" />
                                          </ext:ComboBox>
                                          <ext:TextArea ID="txtAciklamarea" runat="server" FieldLabel="Aciklama" Width="500"  LabelStyle="position:absolute; top:6px;" Style="position:absolute; top:6px;"> </ext:TextArea>
                                      </Items>
                                  </ext:FieldSet>
                            
                              <ext:FieldSet ID="FieldListeleme" runat="server"   Width="200" Height="130"  Title="Listeleme" Style="position:absolute; top:250px;">
                                  <Items>
                                       <ext:FormLayout ID="FormLayout4" runat="server" LabelWidth="110">
                                     <Anchors> 
                                           <ext:Anchor Horizontal="100%">
                                             <ext:RadioGroup ID="RadioGroup2" 
                                                runat="server" 
                                                ColumnsNumber="1" 
                                                ItemCls="x-check-group-alt"

                                                style="position:absolute; left:5px;">
                                                <Items>
                                                    <ext:Radio ID="Radio9" runat="server" BoxLabel="Günlük" Checked="true" />
                                                        <ext:Radio ID="Radio1" runat="server" BoxLabel="Aylık" />
                                                    <ext:Radio ID="Radio10" runat="server" BoxLabel="Yıllık">
                                                       


                                                    </ext:Radio>
                                                    <ext:Radio ID="Radio11" runat="server" BoxLabel="Tamamı"> 
                                                        <DirectEvents>
                                                            <Check OnEvent="tam_Click"> 
                                                           <ExtraParams>       
                                                <ext:Parameter Name="record" Value="Ext.encode(#{grdIZIN}.getRowsValues({selectedOnly:true}))" Mode="Raw" />
                                                             </ExtraParams>


                                                            </Check>
                                                        </DirectEvents>
                                                      
                                                       
                                                    
                                                    </ext:Radio>
                                                    
                                                </Items>
                                            </ext:RadioGroup>                                              
                                        </ext:Anchor>
                                         </Anchors>                                       
                                   </ext:FormLayout>
                            

                                  </Items>
                                   
                             </ext:FieldSet>
                              
                                    

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
                            Width="700" 
                            Height="200" Y="410"                                                 
                            TrackMouseOver="true" ColumnWidth="0.07">
                                
                            
                            

                               <Store>                          
                                  <ext:Store 
                                    ID="strPers" 
                                    runat="server" >
                                                                
                                    <Reader>
                                         <ext:ArrayReader>                                         
                                           <Fields>
                                                <ext:RecordField Name="CODE" />
                                                <ext:RecordField Name="EXP" />
                                                <ext:RecordField Name="Expr1" />
                                                <ext:RecordField Name="Expr2" />
                                                <ext:RecordField Name="Expr3" />
                                                <ext:RecordField Name="PERIOD" />
                                               <ext:RecordField Name="DURUM" />
                                                
                                           </Fields>
                                        </ext:ArrayReader>
                                    </Reader>
                                </ext:Store>                                                                            
                                </Store>
                                                                                                                                                                                  
                               <ColumnModel ID="ColumnModel2" runat="server">
                                    <Columns>                                                      
                                   
                                            <ext:Column Header="İzin Kodu"  DataIndex="Expr1" />
                                            <ext:Column Header="İzin Açıklaması"  DataIndex="EXP" />
                                            <ext:Column Header="Baş. Tarihi"  DataIndex="Expr2" />
                                            <ext:Column Header="Bitiş Tarihi"  DataIndex="Expr3" />
                                            <ext:Column Header="Süre"  DataIndex="PERIOD" />
                                             <ext:Column Header="Durum" DataIndex="DURUM" />
                                          

                                            
                                    </Columns>
                                  </ColumnModel> 
                                  <SelectionModel>
                
                                            <ext:RowSelectionModel ID="RowSelectionModel1"  runat="server"  HideCheckAll="false"  AllowDeselect="true"   />
                                        </SelectionModel>
                                                                                        
                               <BottomBar>
                                    
                                             
                         
                                    </BottomBar>

                               <TopBar>
                                            <ext:Toolbar ID="Toolbar2" runat="server">
                                                <Items>
                                                 <ext:Label ID="lblCapt" runat="server" Text="İzin Listesi" Align="Center"   Style="font-size:50px; font-family:'Angsana New'; font-weight:lighter;" ></ext:Label>

                                                      
                                                    
                                                                                                  
                                                </Items>
                                            </ext:Toolbar>                                                                                                                                                                                                                                                     
                                </TopBar>  


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
                                                              <ext:Label ID="lblLREF" runat="server" Text="" Hidden="false"  />
                                                        </Items>
                                                          </ext:PagingToolbar>
                         
                                                </BottomBar>
                                  
                                              <TopBar>
                                                        <ext:Toolbar ID="Toolbar1" runat="server">
                                                            <Items>
                                                   
                                                    
                                                                          <ext:Button ID="Button2" runat="server" Icon="Accept"  Text="İncele" Width="100" >              
                                                                      <DirectEvents>     
                                                                                        
                                                                       <Click OnEvent="btnOk_Click" >     
                                                                           <ExtraParams>
                                                                                 <ext:Parameter Name="record" Value="Ext.encode(#{GridPanel1}.getRowsValues({selectedOnly:true}))" Mode="Raw" />
                                                                           </ExtraParams>
                                                                       </Click>
                                                                      </DirectEvents>
                                                                  </ext:Button>   
                                                                                                         
                                                                            <ext:Button ID="Button3" runat="server" Icon="Delete"  Text="Temizle" Width="100" >              
                                                                      <DirectEvents>                   
                                                                         
                                                                                                                                               
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
