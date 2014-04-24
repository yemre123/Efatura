<%@ Page Language="C#" %>

<%@ Import Namespace="Ext.Net.Utilities"%>
<%@ Import Namespace="System.Collections.Generic" %>
<%@ Import Namespace="System.Linq" %>
<%@ Import Namespace="System.Data.SqlClient" %>
<%@ Import Namespace="System.Data" %>

<%@ Register Assembly="Ext.Net" Namespace="Ext.Net" TagPrefix="ext" %>
 

<script runat="server">
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!X.IsAjaxRequest)
        {
            var store3 = this.GridPanel3.GetStore();
            store3.DataSource = GetDataBORCLAR();
            store3.DataBind();

            var store1 = this.GridPanel1.GetStore();
            store1.DataSource = GetData();
            store1.DataBind();

            var store2 = this.GridPanel2.GetStore();
            store2.DataSource = GetDataBORCTANIMLARI();
            store2.DataBind();

            
          

          
           


          
        }
    }
    public object[] GetDataBORCTANIMLARI()
    {

      
        Data.BORCTANIMLARI[] List =
        new DevExpress.Xpo.XPCollection<Data.BORCTANIMLARI>
        (Data.XP.Crs).OrderBy(x => x.CODE).ToArray();


        object[] Lobj = new object[List.Length];

        for (int i = 0; i < List.Length; i++)
        {
            Data.BORCTANIMLARI kty = List[i];
            Lobj[i] = new object[] {                    
            kty.CODE,
            kty.DEFINITION_
            };
        } 
        return Lobj;
    }
         public object[] GetDataBORCLAR()
    {
        
        Data.BORCLAR[] List =
        new DevExpress.Xpo.XPCollection<Data.BORCLAR>
       (Data.XP.Crs).OrderBy(x => x.LREF).ToArray();


        object[] Lobj = new object[List.Length];

        for (int i = 0; i < List.Length; i++)
        {
            Data.BORCLAR kty = List[i];
            Lobj[i] = new object[] {                    
           kty.TARIH,
           kty.SICILNO,
           kty.NAME,
           kty.SURNAME,
           kty.KURUM,
           kty.BOLUM,
           kty.IS_YERI,
           kty.BORC_KODU,
           kty.BORC_TANIMI,
           kty.BORC_TUTARI,
           kty.DOVIZ_TURU,
           kty.ISLEM_TURU,
           kty.ODEME_SEKLI,
           kty.TAKSIT_SAYISI,
           kty.ODEME_TARIHI,
           kty.TAKSIT_TUTARI
           
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
    protected void btnborcIncele_Click(object sender, DirectEventArgs e) 
    {
        string json = e.ExtraParams["record"];


        List<Data.BORCLAR> obj = Newtonsoft.Json.JsonConvert.DeserializeObject<List<Data.BORCLAR>>(json);

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
        foreach (Data.BORCLAR pers in obj)
        {
    
            txtSicilNumarasi.Text = pers.SICILNO;
            txtAdi.Text = pers.NAME;
            txtSoyadi.Text = pers.SURNAME;
            txtKurum.Text = pers.KURUM;
            txtBolum.Text = pers.BOLUM;
            txtIsYeri1.Text = pers.IS_YERI;
            txtTaksitSayisi.Text = pers.TAKSIT_SAYISI;
            txtIslemTarihi.Text = pers.TARIH.ToString();
            txtOdemeTarihi.Text = pers.ODEME_TARIHI.ToString();
            txtKayitNumarasi.Text = pers.LREF.ToString();
            txtTaksitTutari.Text = pers.BORC_TUTARI;
            txtTutar.Text = pers.TAKSIT_TUTARI;
            txtBorcTanimi.Text = pers.BORC_KODU;
            txtBorcTanimi1.Text = pers.BORC_TANIMI;
            txtBorcTur.Text = pers.BORC_TANIMI;

      
            lblLREF.Text = "  < " + obj.First().NAME + " " + obj.First().SURNAME + ">";
            
            WndBelgeEkle.Hidden = false;
            WndBelgeEkle.ShowModal();
        }
    }
    protected void btnVazgec_Click(object sender, DirectEventArgs e)
    {
        WndBelgeEkle.Hidden = true;
    
    }
    protected void btnEkle_Click(object sender, DirectEventArgs e) 
    {
      
        
        
        
        
          string json = e.ExtraParams["record"];


        List<Data.BORCTANIMLARI> obj = Newtonsoft.Json.JsonConvert.DeserializeObject<List<Data.BORCTANIMLARI>>(json);

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
        foreach (Data.BORCTANIMLARI pers in obj)
        {

            txtSicilNumarasi.Text = "";
            txtAdi.Text = "";
            txtSoyadi.Text = "";
            txtKurum.Text = "";
            txtBolum.Text = "";
            txtIsYeri1.Text = "";
            txtTaksitSayisi.Text = "";
            txtIslemTarihi.Text = "";
            txtOdemeTarihi.Text = "";
            txtKayitNumarasi.Text = "";
            txtTaksitTutari.Text = "";
            txtBorcTanimi.Text= "";
            txtBorcTanimi1.Text = "";
            txtBorcTur.Text = "";
            txtTutar.Text = "";
            
         
            WndBelgeEkle.Hidden = false;
            WndBelgeEkle.ShowModal();
        }
        
    }
    protected void btnKapat_Click(object sender, DirectEventArgs e) 
    {

    
    }
    protected void btnKaydet_Click(object sender, DirectEventArgs e) 
    {


       
     
    
    }
    protected void btnIncele_Click(object sender, DirectEventArgs e)
    {
        string json = e.ExtraParams["record"];


        List<Data.BORCTANIMLARI> obj = Newtonsoft.Json.JsonConvert.DeserializeObject<List<Data.BORCTANIMLARI>>(json);

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
        foreach (Data.BORCTANIMLARI pers in obj)
        {
         
            txtKod.Text = pers.CODE;
            txtBorcAciklama.Text = pers.DEFINITION_;
            txtTanimTipi.Text = pers.DEFINITION_;

         

            wndBorcTanimi.Hidden = false;
            wndBorcTanimi.ShowModal();
        }
    }
    protected void btnSec_Click(object sender, DirectEventArgs e) 
    {
     string json = e.ExtraParams["record"];

        
        List<Data.BORCTANIMLARI> obj = Newtonsoft.Json.JsonConvert.DeserializeObject<List<Data.BORCTANIMLARI>>(json);

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
        foreach (Data.BORCTANIMLARI pers in obj)
        {

            txtBorcTanimi.Text = pers.CODE;
            txtBorcTanimi1.Text = pers.DEFINITION_;
            txtBorcTur.Text = pers.DEFINITION_;
            



          


            WndBelgeEkle.Hidden = false;
            WndBelgeEkle.ShowModal();
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
            txtKurum.Text = pers.EkBilgiler.KURUM;
            txtBolum.Text = pers.EkBilgiler.BOLUM;
            txtIsYeri1.Text = pers.EkBilgiler.ISYERI;


            
            lblLREF.Text = "  < " + obj.First().AD + " " + obj.First().SOYAD + ">";

          
            WndBelgeEkle.Hidden = false;
            WndBelgeEkle.ShowModal();



        }
    }
        
    
</script>

    

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN"  "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head id="Head1" runat="server">
     <title></title>
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
                        Height="500"            
                       
                        
                        Closable="true"         
                        Resizable="true"
                        Draggable="true"
                        Padding="4"
                        Hidden="false"
                        Modal="true"   
                        Layout="AbsoluteLayout"> 
            <Items>   
        <ext:Panel ID="Panel1" runat="server" Width="900" Height="500"  >
            <Items>
                <ext:BorderLayout  runat="server">
                    <Center>
                          <ext:FormPanel ID="FormPanel1" runat="server" Title="Borçlandırma" Padding="3" ButtonAlign="Right" BodyStyle="background-color: #DFE8F6" Height="100px" >
                            <Items>
                                <ext:FieldSet ID="fieldsetPanel1" runat="server"> 
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
                <TriggerClick Handler="#{Window2}.show(); #{Window2}.layout.activeItem.saveValue(#{Window2}); if (#{Window2}.autoComplete) {#{CellEditing1}.completeEdit();}" />
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
                         <TriggerClick Handler="#{Window2}.show(); #{Window2}.layout.activeItem.saveValue(#{Window2}); if (#{Window2}.autoComplete) {#{CellEditing1}.completeEdit();}" />
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
                         <TriggerClick Handler="#{Window2}.show(); #{Window2}.layout.activeItem.saveValue(#{Window2}); if (#{Window2}.autoComplete) {#{CellEditing1}.completeEdit();}" />
                          </Listeners>
                               </ext:TriggerField>
                              </Items>
                             </ext:FieldSet>
                         <ext:TextField ID="txtKurum" runat="server"  FieldLabel="Kurum"  AnchorHorizontal="50%" Disabled="true" LabelStyle="position:absolute; top:4px; left:380px;" Style="position:absolute; top:-100px; left:450px;"> </ext:TextField>
                         <ext:TextField ID="txtBolum" runat="server"  FieldLabel="Bölüm" AnchorHorizontal="50%" Disabled="true" LabelStyle="position:absolute; top:27px; left:380px;" Style="position:absolute; top:-75px; left:450px;"> </ext:TextField>
                          <ext:TextField ID="txtIsYeri1" runat="server"  FieldLabel="İş Yeri" AnchorHorizontal="50%" Disabled="true" LabelStyle="position:absolute; top:52px; left:380px;" Style="position:absolute; top:-50px; left:450px;"> </ext:TextField>
                                   </Items>
                             
                              <items>
                               <ext:FormPanel ID="FormPanel2" runat="server"  Padding="3" ButtonAlign="Right" BodyStyle="background-color: #DFE8F6" Height="200px"> 
                            <Items>
                                 
                               
                               <ext:DateField ID="txtIslemTarihi" runat="server" FieldLabel="İşlem Tarihi"  AnchorHorizontal="40%" />
                                <ext:DateField ID="txtOdemeTarihi"  runat="server"  FieldLabel="Ödeme Başlangıcı" AnchorHorizontal="40%" > </ext:DateField>
                             
                               <ext:CompositeField ID="CompositeField4"  runat="server"   AnchorHorizontal="-100"    MsgTarget="Side"  FieldLabel="Ödemeler">
                
                                <Items>
                                  
                                             
                              <ext:ComboBox ID="ComboBox2" 
                                runat="server"
                                Width="150"
                                Editable="false">
                                
                                <Items>
                                    <ext:ListItem Text="Taksit Sayısına Göre"  />
                                 
                                </Items>
                                <SelectedItem Value="Taksit Sayısına Göre" />
                            </ext:ComboBox>
                         
                                 </Items>
                               </ext:CompositeField>
                                  <ext:CompositeField ID="CompositeField1" runat="server" AnchorHorizontal="-50" MsgTarget="Side" FieldLabel="Tutar">
                                      <Items>

                                          <ext:TextField ID="txtTutar" runat="server"  AnchorHorizontal="60%"  Text="0" Region="Center"> </ext:TextField>
                                          
                                          <ext:ComboBox 
                                             
                                               ID="Combobox3" 
                                              runat="server"
                                               Width="80"
                                               Editable="true"> 
                                              <Items>
                                                  <ext:ListItem Text="TL" />
                                                  <ext:ListItem Text="Euro" />
                                                  <ext:ListItem Text="Dolar" />
                                              </Items>
                                              <SelectedItem  Value="TL" />
                                              </ext:ComboBox>
                                     

                                      </Items>

                                  </ext:CompositeField>
                                  
                                         <ext:TriggerField 
                           ID="txtBorcTanimi" 
                            runat="server" 
                             Width="110" 
                           Editable="false"
                             FieldLabel="Borç Tanımı"
                               X="340"
                              Y="-103"
                               LabelStyle="position:absolute; top:6px; left:376px;">
                           <Triggers>
                      
                        <ext:FieldTrigger Icon="Ellipsis" />
                                          
                        </Triggers>
                         <Listeners>                
                         <TriggerClick Handler="#{Window1}.show(); #{Window1}.layout.activeItem.saveValue(#{Window}); if (#{Window2}.autoComplete) {#{CellEditing1}.completeEdit();}" />
                       </Listeners>
                        </ext:TriggerField>
                          <ext:TextField ID="txtBorcTanimi1" runat="server" AnchorHorizontal="30%" Style="position:absolute; top:-130px; left:560px;"> </ext:TextField>              
                               <ext:TextField ID="txtTaksitSayisi"  runat="server" FieldLabel="Taksit Sayısı" AnchorHorizontal="20%"  EmptyText="0" LabelStyle="position:absolute; top:107px;" Style="position:absolute; top:-33px;"> </ext:TextField>
                               <ext:TextField ID="txtTaksitTutari" runat="server"  FieldLabel="Taksit Tutarı" AnchorHorizontal="30%"  Text="0" Y="45"> </ext:TextField>
                      
                          
                             <ext:TextField ID="txtBorcTur" runat="server"  FieldLabel="Borç Türü" AnchorHorizontal="30%" LabelStyle="position:absoulute; top:-139px; left: 373px;"  Style="position:absolute; top: -139px; right: 277px;"/>


                            <ext:CompositeField ID="CompositeField6" runat="server" AnchorHorizontal="-50" MsgTarget="Side" FieldLabel="Ödeme Şekli" LabelStyle="position:absoulute; top:-115px; left: 369px;"  Style="position:absolute; top: -116px; right: -300px;">
                                <Items> 
                                   
                                       <ext:ComboBox 
                                             
                                               ID="Combobox4" 
                                              runat="server"
                                               Width="110"
                                               Editable="true">
                                                                    
                                              <Items>
                                                  <ext:ListItem Text="Elden" />
                                                 <ext:ListItem Text="Kasadan" />
                                                  <ext:ListItem Text="Bankadan" />
                                                  <ext:ListItem Text="Puantajdan" />
                                                  <ext:ListItem Text="Belge ile" />

                                              </Items>
                                              <SelectedItem  Value="Elden" />
                                              </ext:ComboBox>
                                    </Items>
                                </ext:CompositeField>
                            <ext:Checkbox ID="checkbox2" runat="server" Fieldlabel="İşlem Tamamlandı" LabelStyle="position:absoulute; top:-114px; left: 470px;"  Style="position:absolute; top: -110px; right: 415px;"> </ext:Checkbox>
                              <ext:TextField ID="TxtOncelikSirasi" runat="server"  FieldLabel="Öncelik Sırası"  Text="0" AnchorHorizontal="20%" LabelStyle="position:absoulute; top:-115px; left: 370px;"  Style="position:absolute; top: -115px; right: 363px"/>
                              <ext:TextField ID="txtOdemeSiniri" runat="server"  FieldLabel="Ödeme Üst Sınırı" AnchorHorizontal="25%" LabelStyle="position:absoulute; top:-113px; left: 370px;"  Disabled="true"  Style="position:absolute; top: -113px; right: 297px;"></ext:TextField>
                                     
                           
                            </Items>
                    
                              
                                
                                
                                </ext:FormPanel>
                               
                                <ext:FormPanel ID="FormPanel3" runat="server" Padding="5" ButtonAlign="Right"   BodyStyle="background-color: #DFE8F6"  Height="200px">
                       <Items> 

                            <ext:TextField ID="txtKayitNumarasi" runat="server"  FieldLabel="Kayıt Numarası" AnchorHorizontal="35%" />
                            <ext:TextField ID="txtAciklama" runat="server"  FieldLabel="Açıklama" AnchorHorizontal="45%" />     
                            <ext:TextField ID="txtSablon" runat="server"  LabelStyle="Width:110px;"  FieldLabel="Muhasebe Şablonu" />
                           <ext:Button ID="btnKaydet"   runat="server"  Text="Kaydet"  Width="70" Height="25" Style="position:absolute; top: 55px; right: 210px">
                               <DirectEvents>
                                  <Click  OnEvent="btnKaydet_Click"> </Click>

                               </DirectEvents>
                           </ext:Button>
                           <ext:Button ID="btnVazgec"   runat="server"  Text="Vazgeç"  Width="70" Height="25" Style="position:absolute; top: 55px; right: 120px" >
                               <DirectEvents>
                                   <Click OnEvent="btnVazgec_Click"> </Click>

                               </DirectEvents>

                           </ext:Button>


                      
                       </Items>

                                    </ext:FormPanel>
                                
                                   </items>
                              
                              </ext:FormPanel>
                        
                          
                              </Center>
                        </ext:BorderLayout>
              
                
                      </Items>
          
          
            
            </ext:Panel>
                
            </Items>

            </ext:Window>
         

           <ext:Window ID="Window2" 
                      Draggable="true" 
                      Resizable="true" 
                      runat="server"  
                      Width="1140"
                     Height="600" 
                      Padding="1" X="1" Y="1" Closable="true" Hidden="true" >                      
                        <Items>
                                                                                                          
                           <ext:GridPanel
                                        ID="GridPanel1"
                                        runat="server" 
                                        StripeRows="true"            
                                        Width="1160" 
                                        Height="530" Y="1"                                                 
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
             ID="wndBorcTanimi"
                        runat="server" 
                        Width="650"
                        Height="380"            
                       
                       
                        Closable="true"         
                        Resizable="true"
                        Draggable="true"
                        Padding="4"
                        Hidden="true"
                        Modal="true"   
                        Layout="AbsoluteLayout"> 
            <Items>   
        <ext:Panel ID="Panel2" runat="server" Width="800" Height="700"  >
            <Items>
                <ext:BorderLayout ID="BorderLayout1"  runat="server">
                    <Center>
                          <ext:FormPanel ID="FormPanel4" runat="server" Title="Borç Tanımı" Padding="3" ButtonAlign="Right" BodyStyle="background-color: #DFE8F6" Style="position:absolute; height:40px;">
                            <Items>
                                
                            <ext:TextField ID="txtKod" runat="server" FieldLabel="Kodu" Disabled="true"> </ext:TextField>
                            <ext:TextField ID="txtBorcAciklama" runat="server" FieldLabel="Açıklama" Width="350"  Disabled="true"> </ext:TextField>
                            <ext:TextField ID="txtTanimTipi" runat="server"  FieldLabel="Tanım Tipi"  Disabled="true"> </ext:TextField>
                            <ext:Checkbox ID="checkAktif" runat="server"  Style="position:absolute; top:60px; left:260px;" Checked="true" Disabled="true"> </ext:Checkbox>
                            <ext:Label ID="lblAktif" runat="server" Text="Aktif" Style="position:absolute; top:60px; left:280px;" Disabled="true"> </ext:Label>
                           
                         
                            </Items>
                             
                              <items>
                               <ext:FormPanel ID="FormPanel5" runat="server"  Padding="3" ButtonAlign="Right" BodyStyle="background-color: #DFE8F6" Height="160px"> 
                            <Items>
                                 
                               <ext:TextField ID="txtBorcTaksitSayisi" runat="server"  Width="40" FieldLabel="Taksit Sayısı"  Text="1" Disabled="true" Style="position:absolute; left:170px;"> </ext:TextField>
                               <ext:TextField ID="txtBorcOncelikSirasi" runat="server"  Width="40" FieldLabel="Öncelik Sırası"  Text="0" Disabled="true" Style="position:absolute; left:170px;"> </ext:TextField>
                               <ext:TextField ID="txtGrupSirasi" runat="server"  Width="40" FieldLabel="Taksit Sayısı"  Text="0" Disabled="true" Style="position:absolute; left:170px;"> </ext:TextField>
                               <ext:TextField ID="txtBorcSiraNumarasi" runat="server"  Width="40" FieldLabel="Sıra Numarası"  Text="0" Disabled="true" Style="position:absolute; left:170px;"> </ext:TextField>
                                <ext:TextField ID="txtKota" runat="server"  Width="65" FieldLabel="Kota" Text="Sabit" Disabled="true" LabelStyle="position:absolute; top:5px; left:230px;" Style="position:absolute; top:-102px; left:400px;"> </ext:TextField>
                                <ext:TextField ID="TextField1" runat="server"  Width="120"  Text="0" Disabled="true"  Style="position:absolute; top:-102px; left:475px;"> </ext:TextField>
                                <ext:TriggerField ID="txtOdemeUstSiniri" runat="server" FieldLabel="Ödeme Üst Sınırı" Width="200" Disabled="true" LabelStyle="position:absolute; top:38px; left:230px;" Y="-80" X="297">    </ext:TriggerField>
                                 <ext:TriggerField ID="TriggerField1" runat="server" FieldLabel="Döviz Türü" Text="TL" Width="50" Disabled="true" LabelStyle="position:absolute; top: 68px; left:230px;" Y="-75" X="297">    </ext:TriggerField>
                                <ext:TextField  ID="txtGelirVergisi" runat="server" FieldLabel="Gelir Vergisine Tabi Oran (%)" LabelWidth="1500"  Text="0" Width="50" Disabled="true" LabelStyle="position:absolute; width:1000px; top:99px; left:230px;" Y="-70" X="402"  Style="position:absolute; top:-50px; left:35px;"> </ext:TextField> 
                               <ext:TriggerField ID="TriggerField2" runat="server"  Text="Matrahtan Düşülecek" Width="140" Y="-70" X="349" Disabled="true"> </ext:TriggerField> 
                                <ext:TextField  ID="TextField3" runat="server" FieldLabel="Damga Vergisine Tabi Oran (%)" LabelWidth="1500"  Text="0" Width="50" Disabled="true" LabelStyle="position:absolute; width:1000px; top:130px; left:230px;" Y="-65" X="402"  Style="position:absolute; top:-50px; left:35px;"> </ext:TextField>
                             </Items>

                              
                          
                    
                              
                                
                                
                                </ext:FormPanel>
                                      <ext:Button ID="btnKapat" runat="server" Width="80"  Text="Kapat" Style="position:absolute; left:520px; top:290px;">
                                          <DirectEvents>
                                              <Click OnEvent="btnKapat_Click"> </Click>
                                          </DirectEvents>
                                      </ext:Button>
                            
                                
                                   </items>
                              
                              </ext:FormPanel>
                     
                          
                              </Center>
                        </ext:BorderLayout>
              
                 
                      </Items>
            <Items>
               
           
            </Items>
            </ext:Panel>
                
            </Items>
      


            </ext:Window>             
        
                            <ext:Window ID="Window1" 
                              
                      Draggable="true"
                       Hidden="true" 
                      Resizable="true" 
                      runat="server"  
                      Width="500"  AutoHeight="true"
                      Padding="1" X="400" Y="200" Closable="true" >                      
            <Items>
                                                                                                           
               <ext:GridPanel
                            ID="GridPanel2"
                            runat="server" 
                            StripeRows="true"            
                            Width="1085" 
                            Height="300" Y="1"                                                 
                            TrackMouseOver="true">
                            
                               <Store>                          
                                  <ext:Store 
                                    ID="Store3" 
                                    runat="server" 
                                    OnSubmitData="Store1_Submit">
                                     <DirectEventConfig IsUpload="true" />
                                    <Reader>
                                         <ext:ArrayReader>                                         
                                           <Fields>
                                                <ext:RecordField Name="CODE" />
                                                <ext:RecordField Name="DEFINITION_" />
                                                
                                           </Fields>
                                        </ext:ArrayReader>
                                    </Reader>
                                </ext:Store>                                                                            
                                </Store>
                            
                                 <ColumnModel ID="ColumnModel2" runat="server">
                                    <Columns>      
                                        <ext:RowNumbererColumn />              
                                                    
                                   
                                            <ext:Column Header="Kodu"  DataIndex="CODE" />
                                            <ext:Column Header="Açıklama"  DataIndex="DEFINITION_" />
                                            <ext:Column Header="Tip"  DataIndex="DEFINITION_" />
                                          

                                          
                                    </Columns>
                                  </ColumnModel> 
                                  
                                       <SelectionModel>
                                           
                                           <ext:RowSelectionModel ID="RowSelectionModel3" runat="server"  SingleSelect="true"> </ext:RowSelectionModel>
                                        </SelectionModel>
                                        
              
                                
                                  
                                  <TopBar>
                                            <ext:Toolbar ID="Toolbar2" runat="server">
                                                <Items>
                                                 
                                                    
                                                              <ext:Button ID="Button4" runat="server" Icon="Accept"  Text="_Seç..." Width="100" >              
                                                          <DirectEvents>                   
                                                           <Click OnEvent="btnSec_Click" >     
                                                               <ExtraParams>
                                                                     <ext:Parameter Name="record" Value="Ext.encode(#{GridPanel2}.getRowsValues({selectedOnly:true}))" Mode="Raw" />
                                                               </ExtraParams>
                                                           </Click>
                                                          </DirectEvents>
                                                      </ext:Button>   
                                                        <ext:Button ID="Button1" runat="server" Icon="Reload"  Text="İncele" Width="100" >              
                                                          <DirectEvents>                   
                                                           <Click OnEvent="btnIncele_Click" >     
                                                               <ExtraParams>
                                                                     <ext:Parameter Name="record" Value="Ext.encode(#{GridPanel2}.getRowsValues({selectedOnly:true}))" Mode="Raw" />
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
                                                                                                             
             <ext:Window ID="Window3" 
                      Draggable="false" 
                      Resizable="true" 
                      runat="server"  
                      Width="1400"  Height="630"
                      Padding="1" X="1" Y="1"  Closable="true" >                      
                        <Items>
                                                                                                          
                           <ext:GridPanel
                                        ID="GridPanel3"
                                        runat="server" 
                                        StripeRows="true"            
                                        Width="1400" 
                                        Height="630"                                                 
                                        TrackMouseOver="true" >
                                         
                                                                
                                           <Store>                          
                                              <ext:Store 
                                                ID="Store4" 
                                                runat="server" 
                                                OnSubmitData="Store1_Submit">
                                                 <DirectEventConfig IsUpload="true" />
                                                <Reader>
                                                     <ext:ArrayReader>                                         
                                                       <Fields>
                                                            <ext:RecordField Name="TARIH" />
                                                            <ext:RecordField Name="SICILNO" />
                                                            <ext:RecordField Name="NAME" />
                                                            <ext:RecordField Name="SURNAME" />
                                                            <ext:RecordField Name="KURUM" />
                                                            <ext:RecordField Name="BOLUM" />
                                                            <ext:RecordField Name="IS_YERI" />
                                                           <ext:RecordField Name="BORC_KODU" />
                                                            <ext:RecordField Name="BORC_TANIMI" />
                                                            <ext:RecordField Name="BORC_TUTARI" />
                                                            <ext:RecordField Name="DOVIZ_TURU" />
                                                            <ext:RecordField Name="ISLEM_TURU" />
                                                            <ext:RecordField Name="ODEME_SEKLI" />
                                                           <ext:RecordField Name="TAKSIT_SAYISI" />
                                                           <ext:RecordField Name="ODEME_TARIHI" />
                                                           <ext:RecordField Name="TAKSIT_TUTARI" />
                                                  
                                                       </Fields>
                                                    </ext:ArrayReader>
                                                </Reader>
                                            </ext:Store>                                                                            
                                            </Store>
                            
                                             <ColumnModel ID="ColumnModel3" runat="server">
                                                <Columns>      
                                                    <ext:RowNumbererColumn />              
                                                    
                                   
                                                        <ext:DateColumn Header="Tarih"  DataIndex="TARIH"  Width="82" Format="dd.MM.yyyy" />
                                                        <ext:Column Header="Sicil Numarası"  DataIndex="SICILNO"  Width="83" />
                                                        <ext:Column Header="Adı"  DataIndex="NAME"  Width="120" />
                                                         <ext:Column Header="Soyadı"  DataIndex="SURNAME"  Width="120" />
                                                        <ext:Column Header="Kurum"  DataIndex="KURUM" Width="120" />
                                                        <ext:Column Header="Bölüm"  DataIndex="BOLUM"  Width="140" />
                                                        <ext:Column Header="İş Yeri"  DataIndex="IS_YERI" Width="150" />
                                                        <ext:Column Header="Borç Tanımı"  DataIndex="BORC_TANIMI" />
                                                        <ext:Column Header="Borç Tutarı"  DataIndex="BORC_TUTARI" />
                                                        <ext:Column Header="Döviz Türü"  DataIndex="DOVIZ_TURU" />
                                                        <ext:Column Header="İşlem Türü"  DataIndex="ISLEM_TURU" />                                            
                                                        <ext:Column Header="Ödeme Şekli"  DataIndex="ODEME_SEKLI" />
                                                 
                                                        

                                            
                                                </Columns>
                                              </ColumnModel> 
                                  
                                                   <SelectionModel>
                                                        <ext:CheckboxSelectionModel ID="CheckboxSelectionModel2"  runat="server"  HideCheckAll="false"  AllowDeselect="true"  SingleSelect="true"  />
                                                    </SelectionModel>
                                        
       
                                  
                                              <TopBar>
                                                        <ext:Toolbar ID="Toolbar3" runat="server">
                                                            <Items>
                                                   
                                                    
                                                                          <ext:Button ID="Button5" runat="server" Icon="Accept"  Text="İncele" Width="100" >              
                                                                      <DirectEvents>                   
                                                                       <Click OnEvent="btnborcIncele_Click" >     
                                                                           <ExtraParams>
                                                                                 <ext:Parameter Name="record" Value="Ext.encode(#{GridPanel3}.getRowsValues({selectedOnly:true}))" Mode="Raw" />
                                                                           </ExtraParams>
                                                                       </Click>
                                                                      </DirectEvents>
                                                                  </ext:Button>   
                                                                
                                                                          <ext:Button ID="Button6" runat="server" Icon="ADD"  Text="Ekle" Width="100" >              
                                                                      <DirectEvents>                   
                                                                       <Click OnEvent="btnEkle_Click" >     
                                                                           <ExtraParams>
                                                                                 <ext:Parameter Name="record" Value="Ext.encode(#{GridPanel3}.getRowsValues({selectedOnly:true}))" Mode="Raw" />
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
           
                     
                          
                                             
        </form>



     
   

</body>
</html>
