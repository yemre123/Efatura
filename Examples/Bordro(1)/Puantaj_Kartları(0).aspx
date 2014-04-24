<%@ Page Language="C#" %>

<%@ Import Namespace="Ext.Net.Utilities" %>
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

            store1.DataSource = GetDataPUANTAJKARTI();
            store1.DataBind();



            //var store4 = this.GridPanel.GetStore();
            //store4.DataSource = GetDataPUANTAJKARTDETAY("0,1,2");
            //store4.DataBind();
        
        }
                      

    }
    public object[] GetDataPUANTAJKARTDETAY(string scl,string TURU)
    {



        Data.PUANTAJKARTDETAY[] xq = new DevExpress.Xpo.XPCollection<Data.PUANTAJKARTDETAY>(
            Data.XP.Crs,
            new DevExpress.Data.Filtering.InOperator("TURU", TURU.Split(','))
            ).Where(c => c.SICILNO == scl).ToArray();


 
        object[] Lobj = new object[xq.Count()];

       for (int i = 0; i < Lobj.Length; i++)
        {
            Data.PUANTAJKARTDETAY kty = xq[i];
           
            Lobj[i] = new object[] {                    
            kty.SICILNO,
            kty.ADI,
            kty.SOYADI,
            kty.KURUM,
            kty.BOLUM,
            kty.IS_YERI,
            kty.BIRIM,
            kty.DONEM_BASI,
            kty.SATIRNO,
            kty.ACIKLAMA,
            kty.TURU,
            kty.NR,
            kty.GUN,
            kty.SAAT,
            kty.KATSAYI,
            kty.SATIR_TIPI,
            kty.HESAPLAMA_SEKLI,
            kty.ODEME_TIPI,  
            kty.ODEME_SEKLI,     
            kty.BIRIM_TUTAR,
            kty.DOVIZ_TURU,
            kty.TOPLAM_TUTAR,
            kty.NET_TUTAR,
            kty.ISVEREN_PAYI,
            kty.SIGN,
            kty.DUZENLEME_TABANI,
            kty.NAKIT_KISMI,
            kty.ISLEM_TARIHI,
            kty.VERGI_ISTISNA_TUTARI,
            kty.PERDEND,
            kty.MESAILER_TOPLAMI,
            kty.SSKSTATUS,
            kty.EKSIK_CALISMA_NEDENI,
            kty.DONEMDEKI_SAKATLIK_DERECESI,
            kty.SGKNO,
            kty.ISEGIRIS_TARIHI,
         
         
            
            kty.LREF
            
            
            };
        }
        return Lobj;
    }
    public object[] GetDataPUANTAJKARTI()
    {
        
        Data.PUANTAJKARTI[] List =
        new DevExpress.Xpo.XPCollection<Data.PUANTAJKARTI>
           (Data.XP.Crs).OrderBy(x => x.LREF).ToArray();


        object[] Lobj = new object[List.Length];

        for (int i = 0; i < List.Length; i++)
        {
            Data.PUANTAJKARTI kty = List[i];
            Lobj[i] = new object[] {                    
            kty.SICILNO,
            kty.ADI,
            kty.SOYADI,
            kty.KURUM,
            kty.BOLUM,
            kty.IS_YERI,
            kty.BIRIM,
            kty.DONEM_BASI,
            kty.SATIRNO,
            kty.ACIKLAMA,
            kty.TURU,
            kty.NR,
            kty.GUN,
            kty.SAAT,
            kty.KATSAYI,
            kty.SATIR_TIPI,
            kty.HESAPLAMA_SEKLI,
            kty.ODEME_TIPI,
            kty.ODEME_SEKLI,
            kty.BIRIM_TUTAR,
            kty.DOVIZ_TURU,
            kty.TOPLAM_TUTAR,
            kty.NET_TUTAR,
            kty.BOSSAM,
            kty.SIGN,
            kty.TRDATE,
            kty.PERDEND,
            kty.MESAILER_TOPLAMI,
            kty.SSKSTATUS,
            kty.EKSIK_CALISMA_NEDENI,
            kty.DONEMDEKI_SAKATLIK_DERECESI,
            kty.SGKNO,  
            kty.ISEGIRIS_TARIHI
            
           
            
         
            };
        }
        return Lobj;
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
   
        List<Data.PUANTAJKARTI> obj = Newtonsoft.Json.JsonConvert.DeserializeObject<List<Data.PUANTAJKARTI>>(json);

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

        string sclno = "";
        string saat = "";
        
        foreach (Data.PUANTAJKARTI pers in obj)
        {

       
            txtEKADI.Text = pers.ADI + " " + pers.SOYADI;
            txtEKKURUM.Text = pers.KURUM;
            txtEKBOLUM.Text = pers.BOLUM;
            txtEKISEGIRISTARIHI.Value = pers.ISEGIRIS_TARIHI;
            txtEKSGKNO.Text = pers.SGKNO;
            txtEKISYERI.Text = pers.IS_YERI;
            txtEKSICILNO.Text = pers.SICILNO;
            txtEKSTATUS.Text = pers.SSKSTATUS;
            sclno = pers.SICILNO;
            saat = pers.SAAT;

          
                                   
        }


        var store3 = this.GridPanel3.GetStore();
        store3.DataSource = GetDataPUANTAJKARTDETAY(sclno,"0,1,2");
        store3.DataBind();

        var store4 = this.GridPanel4.GetStore();
        store4.DataSource = GetDataPUANTAJKARTDETAY(sclno, "3");
        store4.DataBind();

        var store5= this.GridPanel5.GetStore();
        store5.DataSource = GetDataPUANTAJKARTDETAY(sclno, "4");
        store5.DataBind();

        var store6 = this.GridPanel6.GetStore();
        store6.DataSource = GetDataPUANTAJKARTDETAY(sclno, "5");
        store6.DataBind();


        WndSicil.Show();
    }
    protected void btnOk_Click(object sender, DirectEventArgs e)
    {
        WndPuantajBilgileri.Hidden = false;
        WndPuantajBilgileri.ShowModal();
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


        <ext:ResourceManager runat="server" />


        <ext:Hidden ID="FormatType" runat="server" />

        <ext:Window ID="Window2"
            Draggable="false"
            Resizable="true"
            runat="server"
            Width="1100" Height="560"
            Padding="1" X="1" Y="1" Closable="true">
            <Items>
                
               
                <ext:GridPanel
                    ID="GridPanel1"
                    runat="server"
                    StripeRows="true"
                    Width="1100"
                    Height="545" Y="1"
                    TrackMouseOver="true"
                     
                    Title="Puantaj Kartları">

                    <Store>
                        <ext:Store
                            ID="Store1"
                            runat="server">
                          
                            <DirectEventConfig IsUpload="true" />
                           
                            <Reader>
                                <ext:ArrayReader>
                                    <Fields>
                                        <ext:RecordField Name="SICILNO" />
                                        <ext:RecordField Name="ADI" />
                                        <ext:RecordField Name="SOYADI" />
                                        <ext:RecordField Name="KURUM" />
                                        <ext:RecordField Name="BOLUM" />
                                        <ext:RecordField Name="IS_YERI" />
                                        <ext:RecordField Name="BIRIM" />
                                        <ext:RecordField Name="DONEM_BASI" Type="Date"  />
                                        <ext:RecordField Name="SATIRNO" />
                                        <ext:RecordField Name="ACIKLAMA" />
                                       <ext:RecordField Name="TURU" />  
                                        <ext:RecordField Name="NR" />
                                        <ext:RecordField Name="GUN" />
                                        <ext:RecordField Name="SAAT" />
                                        <ext:RecordField Name="KATSAYI" />
                                         <ext:RecordField Name="SATIR_TIPI" />
                                         <ext:RecordField Name="HESAPLAMA_SEKLI" />
                                         <ext:RecordField Name="ODEME_TIPI" />
                                          <ext:RecordField Name="ODEME_SEKLI" />
                                          <ext:RecordField Name="BIRIM_TUTAR" />
                                          <ext:RecordField Name="DOVIZ_TURU" />
                                          <ext:RecordField Name="TOPLAM_TUTAR" />
                                          <ext:RecordField Name="NET_TUTAR" />
                                          <ext:RecordField Name="BOSSAM" />
                                          <ext:RecordField Name="SIGN" />
                                          <ext:RecordField Name="TRDATE" Type="Date" />
                                          <ext:RecordField Name="PERDEND" Type="Date" />
                                          <ext:RecordField Name="MESAILER_TOPLAMI" />
                                        <ext:RecordField Name="SSKSTATUS" />
                                          <ext:RecordField Name="EKSIK_CALISMA_NEDENI" />
                                          <ext:RecordField Name="DONEMDEKI_SAKATLIK_DERECESI" />
                                        <ext:RecordField Name="SGKNO" />
                                        <ext:RecordField Name="ISEGIRIS_TARIHI" Type="Date"  />


                                    </Fields>
                                </ext:ArrayReader>
                            </Reader>
                        </ext:Store>
                    </Store>

                    <ColumnModel ID="ColumnModel1" runat="server">
                        <Columns>
                            <ext:RowNumbererColumn />


                            <ext:Column Header="Sicil Numarası" DataIndex="SICILNO" />
                            <ext:Column Header="Adı" DataIndex="ADI" />
                            <ext:Column Header="Soyadı" DataIndex="SOYADI" />
                            <ext:DateColumn Header="Dönem Başı" DataIndex="DONEM_BASI" Format="dd.MM.yyyy" />
                            <ext:Column Header="Kurum" DataIndex="KURUM" />
                            <ext:Column Header="Bölüm" DataIndex="BOLUM" />
                            <ext:Column Header="İş Yeri" DataIndex="IS_YERI" />
                            <ext:Column Header="Birim" DataIndex="BIRIM" />





                        </Columns>
                    </ColumnModel>

                    <SelectionModel>
                        <ext:CheckboxSelectionModel runat="server" HideCheckAll="false" AllowDeselect="true" SingleSelect="true" />
                    </SelectionModel>



                    <BottomBar>
                    </BottomBar>

                    <TopBar>
                        <ext:Toolbar ID="Toolbar1" runat="server">
                            <Items>

                                <ext:Button ID="Button4" runat="server"  Icon="Accept" Text="İncele" Width="100">
                                    <DirectEvents>
                                        <Click OnEvent="btnDetay_Click">
                                            <ExtraParams>
                                                <ext:Parameter Name="record" Value="Ext.encode(#{GridPanel1}.getRowsValues({selectedOnly:true}))" Mode="Raw" />
                                            </ExtraParams>
                                        </Click>

                                    </DirectEvents>
                                </ext:Button>


                                


                            </Items>
                        </ext:Toolbar>





                    </TopBar>


                </ext:GridPanel>

            </Items>




        </ext:Window>

        <ext:Window
            ID="WndSicil"
            runat="server"
            Width="1200"
            Height="800"
            Title=""
            X="1" Y="1"
            Closable="true"
            Resizable="true"
            Draggable="true"
            Padding="4"
            Hidden="true"
            Modal="true"
            Layout="AbsoluteLayout">
            <Items>
                <ext:Panel ID="Panel7" runat="server" Width="800" Height="500" Border="false" HideBorders="true" Style="opacity: initial">
                    <Items>
                        <ext:BorderLayout ID="BorderLayout2" runat="server">
                            <Center>
                                <ext:FormPanel ID="FormPanel4" runat="server" Padding="10" ButtonAlign="Right" BodyStyle="background-color: #DFE8F6" Style="position: absolute; height: 40px;">
                                    <Items>
                                          <ext:Label ID="lblLREF" runat="server" Text="" Hidden="false"  />
                                        <ext:TextField ID="txtEKADI" runat="server" Width="150" FieldLabel="Adı Soyadı" Disabled="true" Style="position: absolute; right: 550px;"></ext:TextField>

                                        <ext:TextField ID="txtEKKURUM" runat="server" Width="150" FieldLabel="Kurum" Disabled="true" Style="position: absolute; right: 550px;"></ext:TextField>
                                        <ext:TextField ID="txtEKBOLUM" runat="server" Width="150" FieldLabel="Tanım Tipi" Disabled="true" Style="position: absolute; right: 550px;"></ext:TextField>
                                        <ext:TextField ID="txtEKISYERI" runat="server" Width="150" FieldLabel="Tanım Tipi" Disabled="true" Style="position: absolute; right: 550px;"></ext:TextField>
                                        <ext:TextField ID="txtEKSICILNO" runat="server" FieldLabel="Sicil Numarası" Disabled="true" LabelStyle="position:absolute; top:20px; left:270px;" Style="position: absolute; top: -104px; left: 410px;"></ext:TextField>
                                        <ext:TextField ID="txtEKSGKNO" runat="server" FieldLabel="Sosyal Güvenlik Numarası" Disabled="true" LabelStyle="position:absolute; top:45px; left:270px; width:500px;" Style="position: absolute; top: -78px; left: 410px;"></ext:TextField>
                                        <ext:TextField ID="txtEKSTATUS" runat="server" FieldLabel="Sosyal Güvenlik Statüsü" Disabled="true" LabelStyle="position:absolute; top:72px; left:270px; width:500px;" Style="position: absolute; top: -52px; left: 410px;"></ext:TextField>
                                        <ext:DateField ID="txtEKISEGIRISTARIHI" runat="server" Vtype="daterange" Width="100" FieldLabel="İşe Giriş Tarihi" Disabled="true" LabelStyle="position:absolute; top:95px; left:270px;" Y="-26" X="306"></ext:DateField>
                                    </Items>
                                </ext:FormPanel>
                            </Center>
                            
                        </ext:BorderLayout>
                    </Items>
                </ext:Panel>


                <ext:TabPanel
                    ID="TabPanel1"
                    runat="server"
                    ActiveTabIndex="0"
                    Width="1300"
                    Height="500"
                    Plain="true"
                    Y="150"
                    X="10">
                    <Items>

                        <ext:Panel
                            ID="Tab1"
                            runat="server"
                            Title="Mesailer"
                            Padding="2"
                            AutoScroll="true">
                            <Items>
                                <ext:GridPanel
                                    ID="GridPanel3"
                                    runat="server"
                                    StripeRows="true"
                                    Width="1300"
                                    Height="545" Y="1"
                                    TrackMouseOver="true"

                                     >
                                  
                                    <Store>
                                        <ext:Store
                                            ID="Store3"
                                            runat="server">
                                        
                                            <Reader>
                                              <ext:ArrayReader>
                                                    <Fields>
                                       <ext:RecordField Name="SICILNO" />
                                        <ext:RecordField Name="ADI" />
                                        <ext:RecordField Name="SOYADI" />
                                           <ext:RecordField Name="KURUM" />
                                           <ext:RecordField Name="BOLUM" />
                                           <ext:RecordField Name="IS_YERI" />
                                          <ext:RecordField Name="BIRIM" />
                                         <ext:RecordField Name="DONEM_BASI" Type="Date" />
                                        <ext:RecordField Name="SATIRNO" />
                                        <ext:RecordField Name="ACIKLAMA" />
                                        <ext:RecordField Name="TURU" />
                                        <ext:RecordField Name="NR"  />
                                        <ext:RecordField Name="GUN" />
                                        <ext:RecordField Name="SAAT" />
                                       <ext:RecordField Name="KATSAYI" />
                                        <ext:RecordField Name="SATIR_TIPI" />
                                        <ext:RecordField Name="HESAPLAMA_SEKLI" />
                                        <ext:RecordField Name="ODEME_TIPI" />
                                        <ext:RecordField Name="ODEME_SEKLI" />
                                        <ext:RecordField Name="BIRIM_TUTAR"   />
                                        <ext:RecordField Name="DOVIZ_TURU" />
                                        <ext:RecordField Name="TOPLAM_TUTAR"  Type="Float" />
                                        <ext:RecordField Name="NET_TUTAR"   Type="Float" />
                                        <ext:RecordField Name="ISVEREN_PAYI" />    
                                        <ext:RecordField Name="SIGN" />
                                        <ext:RecordField Name="DUZENLEME_TABANI" />
                                        <ext:RecordField Name="NAKIT_KISMI" />
                                         <ext:RecordField Name="ISLEM_TARIHI"  Type="Date"/>
                                        <ext:RecordField Name="VERGI_TUTARI" />
                                        <ext:RecordField Name="PERDEND"  Type="Date"/>
                                         <ext:RecordField Name="MESAILER_TOPLAMI" />
                                        <ext:RecordField Name="SSKSTATUS" />
                                        <ext:RecordField Name="EKSIK_CALISMA_NEDENI" />
                                        <ext:RecordField Name="DONEMDEKI_SAKATLIK_DERECESI" />
                                        <ext:RecordField Name="SGKNO" /> 
                                        <ext:RecordField Name="ISEGIRIS_TARIHI" />



                                                        </Fields>
                                              </ext:ArrayReader>
                                                
                                               
                                               
                                            </Reader>
                                        </ext:Store>
                                    </Store>

                                    <ColumnModel ID="ColumnModel4" runat="server">
                                        <Columns>
                                             <ext:Column Header="" DataIndex="ACIKLAMA"   Editable="false" Sortable="false" Resizable="false" Groupable="false" Hideable="false" MenuDisabled="true" />
                                            <ext:Column Header="Gün" DataIndex="GUN"  Editable="false" Sortable="false" Resizable="false" Groupable="false" Hideable="false" MenuDisabled="true" />
                                            <ext:Column Header="Saat" DataIndex="SAAT"  Editable="false" Sortable="false" Resizable="false" Groupable="false" Hideable="false" MenuDisabled="true" />
                                            <ext:Column Header="Katsayı" DataIndex="KATSAYI"  Editable="false" Sortable="false" Resizable="false" Groupable="false" Hideable="false" MenuDisabled="true"  />
                                            <ext:NumberColumn Header="Tutar" DataIndex="BIRIM_TUTAR"  Editable="false" Sortable="false" Resizable="false" Groupable="false" Hideable="false" MenuDisabled="true" />
                                            <ext:NumberColumn Header="Brüt Tutar" DataIndex="TOPLAM_TUTAR"  Editable="false" Sortable="false" Resizable="false" Groupable="false" Hideable="false" MenuDisabled="true"   />                
                                            <ext:NumberColumn   Header="Net Tutar" DataIndex="NET_TUTAR"  Editable="false" Sortable="false" Resizable="false" Groupable="false" Hideable="false" MenuDisabled="true" /> 


                                        </Columns>
                                    </ColumnModel>
                                    
                                </ext:GridPanel>

                            </Items>
                        </ext:Panel>

                        <ext:Panel
                            ID="Tab2"
                            runat="server"
                            Title="Sosyal Yardımlar"
                            Padding="2">
                               <Items>
                         
                                <ext:GridPanel
                                    ID="GridPanel4"
                                    runat="server"
                                    StripeRows="true"
                                    Width="1300"
                                    Height="545" Y="1"
                                    TrackMouseOver="true">
                                    <Store>
                                        <ext:Store
                                            ID="Store4"
                                            runat="server">
                                        
                                            <Reader>
                                              <ext:ArrayReader>
                                                    <Fields>
                                       <ext:RecordField Name="SICILNO" />
                                        <ext:RecordField Name="ADI" />
                                        <ext:RecordField Name="SOYADI" />
                                           <ext:RecordField Name="KURUM" />
                                           <ext:RecordField Name="BOLUM" />
                                           <ext:RecordField Name="IS_YERI" />
                                          <ext:RecordField Name="BIRIM" />
                                         <ext:RecordField Name="DONEM_BASI" Type="Date" />
                                        <ext:RecordField Name="SATIRNO" />
                                        <ext:RecordField Name="ACIKLAMA" />
                                        <ext:RecordField Name="TURU" />
                                        <ext:RecordField Name="NR"  />
                                        <ext:RecordField Name="GUN" />
                                        <ext:RecordField Name="SAAT" />
                                       <ext:RecordField Name="KATSAYI" />
                                        <ext:RecordField Name="SATIR_TIPI" />
                                        <ext:RecordField Name="HESAPLAMA_SEKLI" />
                                        <ext:RecordField Name="ODEME_TIPI" />
                                        <ext:RecordField Name="ODEME_SEKLI" />
                                        <ext:RecordField Name="BIRIM_TUTAR" />
                                        <ext:RecordField Name="DOVIZ_TURU" />
                                        <ext:RecordField Name="TOPLAM_TUTAR" />
                                        <ext:RecordField Name="NET_TUTAR" />
                                        <ext:RecordField Name="ISVEREN_PAYI" />    
                                        <ext:RecordField Name="SIGN" />
                                        <ext:RecordField Name="DUZENLEME_TABANI" />
                                        <ext:RecordField Name="NAKIT_KISMI" />
                                         <ext:RecordField Name="ISLEM_TARIHI"  Type="Date"/>
                                        <ext:RecordField Name="VERGI_TUTARI" />
                                        <ext:RecordField Name="PERDEND"  Type="Date"/>
                                         <ext:RecordField Name="MESAILER_TOPLAMI" />
                                        <ext:RecordField Name="SSKSTATUS" />
                                        <ext:RecordField Name="EKSIK_CALISMA_NEDENI" />
                                        <ext:RecordField Name="DONEMDEKI_SAKATLIK_DERECESI" />
                                        <ext:RecordField Name="SGKNO" /> 
                                        <ext:RecordField Name="ISEGIRIS_TARIHI" />



                                                        </Fields>
                                              </ext:ArrayReader>
                                                
                                               
                                               
                                            </Reader>
                                        </ext:Store>
                                    </Store>
                                    <Items>
                                      
                                   

                                    </Items>
                                    <ColumnModel ID="ColumnModel5" runat="server">
                                        <Columns>
                                           
                                             <ext:Column Header="" DataIndex="ACIKLAMA" />
                                             <ext:Column Header="Hesaplama Şekli"  DataIndex="HESAPLAMA_SEKLI"  >
                                             <Editor>
                                                 <ext:ComboBox ID="ComboBox1" runat="server" >
                                                   <Items>
                                                       <ext:ListItem  Text="Brüt"  />
                                                       <ext:ListItem  Text="Net"  />
                                                   </Items>
                                                 </ext:ComboBox>
                                             </Editor>
                                          </ext:Column>
                                           <ext:Column Header="Ödeme Tipi"  DataIndex="ODEME_TIPI"  >
                                             <Editor>
                                                 <ext:ComboBox ID="ComboBox2" runat="server" >
                                                   <Items>
                                                       <ext:ListItem  Text="Ay"  />
                                                       <ext:ListItem  Text="Gün"  />
                                                        <ext:ListItem  Text="Saat"  />
                                                      
                                                   </Items>
                                                 </ext:ComboBox>
                                             </Editor>
                                          </ext:Column>
                                            <ext:Column Header="Ödeme Şekli" DataIndex="ODEME_SEKLI" />
                                            <ext:Column Header="Tutar"  DataIndex="" />
                                            <ext:Column Header="Döviz" DataIndex="DOVIZ_TURU" />
                                              <ext:Column Header="Katsayı" DataIndex="KATSAYI" />
                                              <ext:Column Header="Süre" DataIndex="SAAT" />
                                              <ext:Column Header="YPB Tutar" DataIndex=""  />
                                            <ext:Column Header="Brüt Tutar" DataIndex="" />                
                                            <ext:Column Header="Net Tutar" DataIndex="" /> 
                                       


                                        </Columns>
                                    </ColumnModel>
                                    
                                </ext:GridPanel>

                            </Items>

                        </ext:Panel>

                        <ext:Panel
                            ID="Tab3"
                            runat="server"
                            Title="Ek Ödemeler"
                            Padding="2"
                            AutoScroll="true">
                            
                               <Items>
                         
                                <ext:GridPanel
                                    ID="GridPanel5"
                                    runat="server"
                                    StripeRows="true"
                                    Width="1300"
                                    Height="545" Y="1"
                                    TrackMouseOver="true">
                                    <Store>
                                        <ext:Store
                                            ID="Store5"
                                            runat="server">
                                        
                                            <Reader>
                                              <ext:ArrayReader>
                                                    <Fields>
                                       <ext:RecordField Name="SICILNO" />
                                        <ext:RecordField Name="ADI" />
                                        <ext:RecordField Name="SOYADI" />
                                           <ext:RecordField Name="KURUM" />
                                           <ext:RecordField Name="BOLUM" />
                                           <ext:RecordField Name="IS_YERI" />
                                          <ext:RecordField Name="BIRIM" />
                                         <ext:RecordField Name="DONEM_BASI" Type="Date" />
                                        <ext:RecordField Name="SATIRNO" />
                                        <ext:RecordField Name="ACIKLAMA" />
                                        <ext:RecordField Name="TURU" />
                                        <ext:RecordField Name="NR"  />
                                        <ext:RecordField Name="GUN" />
                                        <ext:RecordField Name="SAAT" />
                                       <ext:RecordField Name="KATSAYI" />
                                        <ext:RecordField Name="SATIR_TIPI" />
                                        <ext:RecordField Name="HESAPLAMA_SEKLI" />
                                        <ext:RecordField Name="ODEME_TIPI" />
                                        <ext:RecordField Name="ODEME_SEKLI" />
                                        <ext:RecordField Name="BIRIM_TUTAR" />
                                        <ext:RecordField Name="DOVIZ_TURU" />
                                        <ext:RecordField Name="TOPLAM_TUTAR" />
                                        <ext:RecordField Name="NET_TUTAR" />
                                        <ext:RecordField Name="ISVEREN_PAYI" />    
                                        <ext:RecordField Name="SIGN" />
                                        <ext:RecordField Name="DUZENLEME_TABANI" />
                                        <ext:RecordField Name="NAKIT_KISMI" />
                                         <ext:RecordField Name="ISLEM_TARIHI"  Type="Date"/>
                                        <ext:RecordField Name="VERGI_TUTARI" />
                                        <ext:RecordField Name="PERDEND"  Type="Date"/>
                                         <ext:RecordField Name="MESAILER_TOPLAMI" />
                                        <ext:RecordField Name="SSKSTATUS" />
                                        <ext:RecordField Name="EKSIK_CALISMA_NEDENI" />
                                        <ext:RecordField Name="DONEMDEKI_SAKATLIK_DERECESI" />
                                        <ext:RecordField Name="SGKNO" /> 
                                        <ext:RecordField Name="ISEGIRIS_TARIHI" />



                                                        </Fields>
                                              </ext:ArrayReader>
                                                
                                               
                                               
                                            </Reader>
                                        </ext:Store>
                                    </Store>
                                    <Items>
                                      
                                   

                                    </Items>
                                    <ColumnModel ID="ColumnModel6" runat="server">
                                        <Columns>
                                           
                                             <ext:Column Header="" DataIndex="ACIKLAMA" />
                                             <ext:Column Header="Hesaplama Şekli"  DataIndex="HESAPLAMA_SEKLI"  >
                                             <Editor>
                                                 <ext:ComboBox ID="ComboBox3" runat="server" >
                                                   <Items>
                                                       <ext:ListItem  Text="Brüt"  />
                                                       <ext:ListItem  Text="Net"  />
                                                   </Items>
                                                 </ext:ComboBox>
                                             </Editor>
                                          </ext:Column>
                                           <ext:Column Header="Ödeme Tipi"  DataIndex="ODEME_TIPI"  >
                                             <Editor>
                                                 <ext:ComboBox ID="ComboBox4" runat="server" >
                                                   <Items>
                                                       <ext:ListItem  Text="Ay"  />
                                                       <ext:ListItem  Text="Gün"  />
                                                        <ext:ListItem  Text="Saat"  />
                                                      
                                                   </Items>
                                                 </ext:ComboBox>
                                             </Editor>
                                          </ext:Column>
                                            <ext:Column Header="Ödeme Şekli" DataIndex="ODEME_SEKLI" />
                                            <ext:Column Header="Tutar"  DataIndex="" />
                                            <ext:Column Header="Döviz" DataIndex="DOVIZ_TURU" />
                                              <ext:Column Header="Katsayı" DataIndex="KATSAYI" />
                                              <ext:Column Header="Süre" DataIndex="SAAT" />
                                              <ext:Column Header="YPB Tutar" DataIndex=""  />
                                            <ext:Column Header="Brüt Tutar" DataIndex="" />                
                                            <ext:Column Header="Net Tutar" DataIndex="" /> 
                                       


                                        </Columns>
                                    </ColumnModel>
                                    
                                </ext:GridPanel>

                            </Items>

                        </ext:Panel>

                        <ext:Panel
                            ID="Tab4"
                            runat="server"
                            Title="Ek Kesintiler"
                            Padding="2"
                            AutoScroll="true">
                              <Items>
                         
                                <ext:GridPanel
                                    ID="GridPanel6"
                                    runat="server"
                                    StripeRows="true"
                                    Width="1300"
                                    Height="545" Y="1"
                                    TrackMouseOver="true">
                                    <Store>
                                        <ext:Store
                                            ID="Store6"
                                            runat="server">
                                        
                                            <Reader>
                                              <ext:ArrayReader>
                                                    <Fields>
                                       <ext:RecordField Name="SICILNO" />
                                        <ext:RecordField Name="ADI" />
                                        <ext:RecordField Name="SOYADI" />
                                           <ext:RecordField Name="KURUM" />
                                           <ext:RecordField Name="BOLUM" />
                                           <ext:RecordField Name="IS_YERI" />
                                          <ext:RecordField Name="BIRIM" />
                                         <ext:RecordField Name="DONEM_BASI" Type="Date" />
                                        <ext:RecordField Name="SATIRNO" />
                                        <ext:RecordField Name="ACIKLAMA" />
                                        <ext:RecordField Name="TURU" />
                                        <ext:RecordField Name="NR"  />
                                        <ext:RecordField Name="GUN" />
                                        <ext:RecordField Name="SAAT" />
                                       <ext:RecordField Name="KATSAYI" />
                                        <ext:RecordField Name="SATIR_TIPI" />
                                        <ext:RecordField Name="HESAPLAMA_SEKLI" />
                                        <ext:RecordField Name="ODEME_TIPI" />
                                        <ext:RecordField Name="ODEME_SEKLI" />
                                        <ext:RecordField Name="BIRIM_TUTAR" />
                                        <ext:RecordField Name="DOVIZ_TURU" />
                                        <ext:RecordField Name="TOPLAM_TUTAR" />
                                        <ext:RecordField Name="NET_TUTAR" />
                                        <ext:RecordField Name="ISVEREN_PAYI" />    
                                        <ext:RecordField Name="SIGN" />
                                        <ext:RecordField Name="DUZENLEME_TABANI" />
                                        <ext:RecordField Name="NAKIT_KISMI" />
                                         <ext:RecordField Name="ISLEM_TARIHI"  Type="Date"/>
                                        <ext:RecordField Name="VERGI_TUTARI" />
                                        <ext:RecordField Name="PERDEND"  Type="Date"/>
                                         <ext:RecordField Name="MESAILER_TOPLAMI" />
                                        <ext:RecordField Name="SSKSTATUS" />
                                        <ext:RecordField Name="EKSIK_CALISMA_NEDENI" />
                                        <ext:RecordField Name="DONEMDEKI_SAKATLIK_DERECESI" />
                                        <ext:RecordField Name="SGKNO" /> 
                                        <ext:RecordField Name="ISEGIRIS_TARIHI" />



                                                        </Fields>
                                              </ext:ArrayReader>
                                                
                                               
                                               
                                            </Reader>
                                        </ext:Store>
                                    </Store>
                                    <Items>
                                      
                                   

                                    </Items>
                                    <ColumnModel ID="ColumnModel7" runat="server">
                                        <Columns>
                                           
                                             <ext:Column Header="" DataIndex="ACIKLAMA" />
                                             
                                              
                                         
                                       
                                           <ext:Column Header="Ödeme Tipi"  DataIndex="ODEME_TIPI"  >
                                             <Editor>
                                                 <ext:ComboBox ID="ComboBox6" runat="server" >
                                                   <Items>
                                                       <ext:ListItem  Text="Ay"  />
                                                       <ext:ListItem  Text="Gün"  />
                                                        <ext:ListItem  Text="Saat"  />
                                                      
                                                   </Items>
                                                 </ext:ComboBox>
                                             </Editor>
                                          </ext:Column>
                                         
                                            <ext:Column Header="Tutar"  DataIndex="" />
                                            <ext:Column Header="Döviz" DataIndex="DOVIZ_TURU" />
                                              <ext:Column Header="Katsayı" DataIndex="KATSAYI" />
                                              <ext:Column Header="Süre" DataIndex="SAAT" />
                                              <ext:Column Header="YPB Tutar" DataIndex=""  />
                                            <ext:Column Header="Toplam Tutar" DataIndex="" />                
                                            <ext:Column Header="İş Veren Payı" DataIndex="ISVEREN_PAYI" /> 
                                       


                                        </Columns>
                                    </ColumnModel>
                                    
                                </ext:GridPanel>

                            </Items>



                        </ext:Panel>
                        <ext:Panel
                            ID="Panel8"
                            runat="server"
                            Title="Borç İşlemleri"
                            Padding="2"
                            AutoScroll="true">

                                     <Items>
                         
                                <ext:GridPanel
                                    ID="GridPanel7"
                                    runat="server"
                                    StripeRows="true"
                                    Width="1300"
                                    Height="545" Y="1"
                                    TrackMouseOver="true">
                                    <Store>
                                        <ext:Store
                                            ID="Store7"
                                            runat="server">
                                        
                                            <Reader>
                                              <ext:ArrayReader>
                                                    <Fields>
                                       <ext:RecordField Name="SICILNO" />
                                        <ext:RecordField Name="ADI" />
                                        <ext:RecordField Name="SOYADI" />
                                           <ext:RecordField Name="KURUM" />
                                           <ext:RecordField Name="BOLUM" />
                                           <ext:RecordField Name="IS_YERI" />
                                          <ext:RecordField Name="BIRIM" />
                                         <ext:RecordField Name="DONEM_BASI" Type="Date" />
                                        <ext:RecordField Name="SATIRNO" />
                                        <ext:RecordField Name="ACIKLAMA" />
                                        <ext:RecordField Name="TURU" />
                                        <ext:RecordField Name="NR"  />
                                        <ext:RecordField Name="GUN" />
                                        <ext:RecordField Name="SAAT" />
                                       <ext:RecordField Name="KATSAYI" />
                                        <ext:RecordField Name="SATIR_TIPI" />
                                        <ext:RecordField Name="HESAPLAMA_SEKLI" />
                                        <ext:RecordField Name="ODEME_TIPI" />
                                        <ext:RecordField Name="ODEME_SEKLI" />
                                        <ext:RecordField Name="BIRIM_TUTAR" />
                                        <ext:RecordField Name="DOVIZ_TURU" />
                                        <ext:RecordField Name="TOPLAM_TUTAR" />
                                        <ext:RecordField Name="NET_TUTAR" />
                                        <ext:RecordField Name="ISVEREN_PAYI" />    
                                        <ext:RecordField Name="SIGN" />
                                        <ext:RecordField Name="DUZENLEME_TABANI" />
                                        <ext:RecordField Name="NAKIT_KISMI" />
                                         <ext:RecordField Name="ISLEM_TARIHI"  Type="Date"/>
                                        <ext:RecordField Name="VERGI_TUTARI" />
                                        <ext:RecordField Name="PERDEND"  Type="Date"/>
                                         <ext:RecordField Name="MESAILER_TOPLAMI" />
                                        <ext:RecordField Name="SSKSTATUS" />
                                        <ext:RecordField Name="EKSIK_CALISMA_NEDENI" />
                                        <ext:RecordField Name="DONEMDEKI_SAKATLIK_DERECESI" />
                                        <ext:RecordField Name="SGKNO" /> 
                                        <ext:RecordField Name="ISEGIRIS_TARIHI" />



                                                        </Fields>
                                              </ext:ArrayReader>
                                                
                                               
                                               
                                            </Reader>
                                        </ext:Store>
                                    </Store>
                                    <Items>
                                      
                                   

                                    </Items>
                                    <ColumnModel ID="ColumnModel8" runat="server">
                                        <Columns>
                                           
                                             <ext:Column Header="Borç Tanımı" DataIndex="" />
                                             <ext:Column Header="Ödeme Tipi"  DataIndex=""  />
                                             <ext:Column Header="Tutar"  DataIndex=""  />
                                             <ext:Column Header="Döviz"  DataIndex=""  />
                                         
                                           </Columns>
                                    </ColumnModel>
                                    
                                </ext:GridPanel>

                            </Items>
                        </ext:Panel>
                        <ext:Panel
                            ID="Panel6"
                            runat="server"
                            Title="Sicil Bilgileri"
                            Padding="2"
                            AutoScroll="true">
                            <Items>
                                <ext:GridPanel
                                    ID="GridPanel2"
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


                                                        <ext:RecordField Name="MESAILER" />
                                                    </Fields>
                                                </ext:ArrayReader>
                                            </Reader>
                                        </ext:Store>
                                    </Store>

                                    <ColumnModel ID="ColumnModel3" runat="server">
                                        <Columns>

                                            <ext:Column Header="İzin Kodu" DataIndex="MESAILER" />




                                        </Columns>
                                    </ColumnModel>

                                </ext:GridPanel>

                            </Items>
                        </ext:Panel>
                    </Items>
                </ext:TabPanel>

            </Items>

        </ext:Window>

        <ext:Window
            ID="wndPuantaj"
            runat="server"
            Width="1200"
            Height="720"
            Title="Puantaj Kartları"
            Closable="true"
            Resizable="true"
            Draggable="true"
            Padding="2"
            Hidden="true"
            Modal="true"
            Layout="AbsoluteLayout">
            <Items>
                <ext:Panel ID="Panel2" runat="server" Width="1200" Height="800">
                    <Items>
                        <ext:BorderLayout ID="BorderLayout1" runat="server">
                            <Center>
                                <ext:FormPanel ID="frmPuantaj" runat="server" Padding="15" ButtonAlign="Right" BodyStyle="background-color: #DFE8F6" Style="position: absolute; height: 40px;">
                                    <Items>

                                        <ext:TextField ID="txtPuantajAd" runat="server" FieldLabel="Adı Soyadı" Width="220" Disabled="true"></ext:TextField>
                                        <ext:TextField ID="txtPuantajKurum" runat="server" FieldLabel="Kurum" Width="220" Disabled="true"></ext:TextField>
                                        <ext:TextField ID="txtPuantajBolum" runat="server" FieldLabel="Bölüm" Width="220" Disabled="true"></ext:TextField>
                                        <ext:TextField ID="txtPuantajIsYeri" runat="server" FieldLabel="İş Yeri" Width="220" Disabled="true"></ext:TextField>
                                        <ext:TextField ID="txtPuantajSicilNo" runat="server" FieldLabel="Sicil Numarası" Width="220" Disabled="true" LabelStyle="position:absolute; top:14px; left:350px;" Style="position: absolute; top: -104px; left: 480px;"></ext:TextField>
                                        <ext:TextField ID="txtPuantajGüvenlikNo" runat="server" FieldLabel="Sosyal Güvenlik Numarası" LabelWidth="1200" Width="220" Disabled="true" LabelStyle="position:absolute; top:38px; left:350px; width:500px;" Style="position: absolute; top: -78px; left: 480px;"></ext:TextField>
                                        <ext:TextField ID="txtPuantajGüvenlikStatu" runat="server" FieldLabel="Sosyal Güvenlik Statüsü" LabelWidth="600" Width="220" Disabled="true" LabelStyle="position:absolute; top:65px; left:350px; width:500px;" Style="position: absolute; top: -52px; left: 480px;"></ext:TextField>
                                        <ext:DateField ID="txtIseGiris" runat="server" FieldLabel="İşe Giriş Tarihi" LabelStyle="position:absolute; top:93px; left:350px;" Y="-25" X="375"></ext:DateField>



                                    </Items>
                                    <Items>
                                        <ext:FieldSet ID="frmPuantaj1" runat="server" Padding="15" ButtonAlign="Right" Width="1200" BodyStyle="background-color: #DFE8F6" Style="position: absolute; left: -5px; width: 400px; height: 300px;">
                                            <Items>
                                                <ext:TabPanel
                                                    ID="TabPanel2"
                                                    runat="server"
                                                    ActiveTabIndex="0"
                                                    BodyStyle=""
                                                    Width="700"
                                                    Height="300"
                                                    Plain="true">
                                                    <Items>

                                                        <ext:Panel
                                                            ID="Panel1"
                                                            runat="server"
                                                            Title="Bilgiler 1"
                                                            Padding="6"
                                                            AutoScroll="true">
                                                            <Items>


                                                                <ext:TextField ID="TextField1" runat="server" FieldLabel="Tc No" LabelWidth="100" Width="400" />
                                                                <ext:TextArea ID="TextArea1" runat="server" FieldLabel="Adres" LabelWidth="100" Width="600" Height="100" />
                                                                <ext:TextField ID="TextField2" runat="server" FieldLabel="İlçe" LabelWidth="100" Width="400" />

                                                                <ext:TextField ID="TextField3" runat="server" FieldLabel="Ev Tel" LabelWidth="100" Width="400" />

                                                                <ext:TextField ID="TextField4" runat="server" FieldLabel="Cep Tel1" LabelWidth="100" Width="400" />
                                                                <ext:TextField ID="TextField5" runat="server" FieldLabel="Cep Tel2 " LabelWidth="100" Width="400" />



                                                            </Items>

                                                        </ext:Panel>

                                                        <ext:Panel
                                                            ID="Panel3"
                                                            runat="server"
                                                            Title="Bilgiler 2"
                                                            Padding="6">
                                                            <Items>

                                                                <ext:TextField ID="TextField6" runat="server" FieldLabel="E-Posta " LabelWidth="100" Width="400" />

                                                                <ext:TextField ID="TextField7" runat="server" FieldLabel="Baba Adı" LabelWidth="100" Width="400" />
                                                                <ext:TextField ID="TextField8" runat="server" FieldLabel="Anne Adı" LabelWidth="100" Width="400" />

                                                                <ext:DateField ID="DateField1" runat="server" Vtype="daterange" FieldLabel="Doğum Tarihi" LabelWidth="100" Width="400" />

                                                            </Items>

                                                        </ext:Panel>

                                                        <ext:Panel
                                                            ID="Panel4"
                                                            runat="server"
                                                            Title="Bilgiler 3"
                                                            Padding="6"
                                                            AutoScroll="true">

                                                            <Items>

                                                                <ext:TextField ID="TextField9" runat="server" FieldLabel="Doğum Yeri" LabelWidth="100" Width="400" />
                                                                <ext:TextField ID="TextField10" runat="server" FieldLabel="Mededni Hak" LabelWidth="100" Width="400" />
                                                                <ext:TextField ID="TextField11" runat="server" FieldLabel="Kan Grubu" LabelWidth="100" Width="400" />

                                                                <ext:TextField ID="TextField12" runat="server" FieldLabel="SSk Durumu" LabelWidth="100" Width="400" />
                                                                <ext:TextField ID="TextField13" runat="server" FieldLabel="Personel" LabelWidth="100" Width="400" />

                                                            </Items>

                                                        </ext:Panel>

                                                        <ext:Panel
                                                            ID="Panel5"
                                                            runat="server"
                                                            Title="Bilgiler 4"
                                                            Padding="6"
                                                            AutoScroll="true">
                                                        </ext:Panel>

                                                    </Items>
                                                </ext:TabPanel>
                                            </Items>
                                        </ext:FieldSet>
                                    </Items>
                                </ext:FormPanel>

                            </Center>
                        </ext:BorderLayout>


                    </Items>
                    <Items>
                    </Items>
                </ext:Panel>

            </Items>
        </ext:Window>

        <ext:Window
            ID="WndPuantajBilgileri"
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
                            runat="server">

                            <Reader>
                                <ext:ArrayReader>
                                    <Fields>
                                        <ext:RecordField Name="CODE" />
                                        <ext:RecordField Name="EXP" />
                                        <ext:RecordField Name="Expr1" />
                                        <ext:RecordField Name="Expr2" />
                                        <ext:RecordField Name="Expr3" />
                                        <ext:RecordField Name="PERIOD" />

                                    </Fields>
                                </ext:ArrayReader>
                            </Reader>
                        </ext:Store>
                    </Store>

                    <ColumnModel ID="ColumnModel2" runat="server">
                        <Columns>

                            <ext:Column Header="İzin Kodu" DataIndex="Expr1" />
                            <ext:Column Header="İzin Açıklaması" DataIndex="EXP" />
                            <ext:Column Header="Baş. Tarihi" DataIndex="Expr2" />
                            <ext:Column Header="Bitiş Tarihi" DataIndex="Expr3" />
                            <ext:Column Header="Süre" DataIndex="PERIOD" />
                           



                        </Columns>
                    </ColumnModel>
                    <SelectionModel>

                        <ext:RowSelectionModel ID="RowSelectionModel1" runat="server" HideCheckAll="false" AllowDeselect="true" />
                    </SelectionModel>

                    <BottomBar>
                    </BottomBar>




                </ext:GridPanel>

            </Items>

        </ext:Window>


    </form>
</body>
</html>
