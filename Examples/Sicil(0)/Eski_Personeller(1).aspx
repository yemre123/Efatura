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

            store1.DataSource = GetData2();
            store1.DataBind();

            //store2.DataSource = Data.Util.En.GetHataKaynaklar();
            //store2.DataBind();

            //store3.DataSource = Data.Util.En.GetDepartman();
            //store3.DataBind();

            //store4.DataSource = Data.Util.En.GetDepartman();
            //store4.DataBind();                        
        }
    }

 


    public object[] GetData2()
    {

        Data.vPersoneller[] List1 =
        new DevExpress.Xpo.XPCollection<Data.vPersoneller>
            (Data.XP.Crs, DevExpress.Data.Filtering.CriteriaOperator.Parse("TYP=2"))
            .OrderBy(x => x.SiraNo).ToArray();


        object[] Lobj3 = new object[List1.Length];

        for (int i = 0; i < List1.Length; i++)
        {
            Data.vPersoneller kty = List1[i];
            Lobj3[i] = new object[] {                    
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
            
        };
         * */
        return Lobj3;
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

        string ids = "";

        foreach (string s in obj.Select(c => c.LREF.ToString()))
            ids += s + " , ";

        Response.Redirect("WebForm1a.aspx?ID=" + ids + "&Page=Eski_Personeller(1).aspx&PersTip=2");
        
        
    }

    protected void btnClear_Click(object sender, DirectEventArgs e)
    {
        CheckboxSelectionModel sm = this.GridPanel1.SelectionModel.Primary as CheckboxSelectionModel;

        if (sm == null) return;

        sm.ClearSelections();
        sm.UpdateSelection();
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
                                            <ext:CheckboxSelectionModel ID="CheckboxSelectionModel1"  runat="server"  HideCheckAll="false"  AllowDeselect="true"   />
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
