<%@ Page Language="C#" %>

<%@ Import Namespace="Ext.Net.Utilities"%>
<%@ Import Namespace="System.Collections.Generic" %>
<%@ Import Namespace="Ext.Net.Examples" %>

<%@ Register Assembly="Ext.Net" Namespace="Ext.Net" TagPrefix="ext" %>

<script runat="server">
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!X.IsAjaxRequest)
        {
            //string usr=Data.Util.En.CookieGet(this, "curuser").Trim();

            //if (usr == "")
            //{
            //    Response.Redirect("login.aspx");
            //    return;
            //}
                                    
            this.ResourceManager1.DirectEventUrl = this.Request.Url.AbsoluteUri;                                    

            this.Session["Ext.Net.Theme"] = Ext.Net.Theme.Default;

            Data.Util.En.BuildTree(exampleTree.Root);
        }
    }
              
    [DirectMethod]
    public string GetThemeUrl(string theme)
    {
        Theme temp = (Theme)Enum.Parse(typeof(Theme), theme);

        this.Session["Ext.Net.Theme"] = temp;

        return temp == Ext.Net.Theme.Default ? "Default" : this.ResourceManager1.GetThemeUrl(temp);
    }
    
    [DirectMethod]
    public static int GetHashCode(string s)
    {
        return Math.Abs("/Examples".ConcatWith(s).ToLower().GetHashCode());
    }
    
</script>



<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" 
    "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html>
<head runat="server">
    <title>Göknil Bilşim</title>
    <ext:ResourcePlaceHolder runat="server" Mode="Script" />
    <ext:ResourcePlaceHolder runat="server" Mode="Style" />
    <link rel="stylesheet" type="text/css" href="resources/css/main.css" />
    <script type="text/javascript" src="resources/js/main.js"></script>
</head>
<body>
    <div id="center" style="padding-top:30px; padding-left:40px;">

    </div>
  
    <ext:ResourceManager 
        ID="ResourceManager1" 
        runat="server" 
        DirectMethodNamespace="X"
        IDMode="Explicit" 
        />
    
    <ext:History ID="History1" runat="server">

        <Listeners>
            <Change Fn="change" />
        </Listeners>
    </ext:History>
    
    <ext:Viewport runat="server" Layout="border">
        <Items>
            <ext:Panel 
                runat="server" 
                Header="false"
                Region="North"
                Border="false"
                Html="<div id='header' style='height:32px;'><a style='float:right;margin-right:10px;' href='login.aspx'><img style='margin-top: 4px;' src='resources/images/ext_net_badge.gif'/></a><div class='api-title'>Otobüs A.ş</div></div>"
                />
                                
            <ext:Panel 
                runat="server"
                Region="West" 
                Layout="Fit" 
                Width="180" 
                Header="false"
                Collapsible="true" 
                Split="true" 
                CollapseMode="Mini" 
                Margins="0 0 4 4"
                Border="false">
                <Items>
                    <ext:TreePanel 
                         ID="exampleTree" 
                        runat="server" 
                        Header="false"
                        AutoScroll="true"
                        Lines="false"
                        UseArrows="true"
                        CollapseFirst="false" 
                        ContainerScroll="true"
                        RootVisible="false">
                        <TopBar>
                            <ext:Toolbar runat="server">
                                <Items>
                                    <ext:TriggerField 
                                        ID="TriggerField1" 
                                        runat="server" 
                                        EnableKeyEvents="true" 
                                        Width="150"
                                        EmptyText="Filter Examples...">
                                        <Triggers>
                                            <ext:FieldTrigger Icon="Clear" HideTrigger="true" />
                                        </Triggers>
                                        <Listeners>
                                            <KeyUp Fn="keyUp" Buffer="100" />
                                            <TriggerClick Fn="clearFilter" />
                                            <SpecialKey Fn="filterSpecialKey" />
                                        </Listeners>
                                    </ext:TriggerField>
                                            
                                    <ext:ToolbarFill runat="server" />
                                            
                                    <ext:Button ID="Button1" runat="server" Icon="Cog" ToolTip="Options">
                                        <Menu>
                                            <ext:Menu runat="server">
                                                <Items>
                                                    <ext:MenuItem runat="server" Text="Expand All" IconCls="icon-expand-all">
                                                        <Listeners>
                                                            <Click Handler="#{exampleTree}.root.expand(true);" />
                                                        </Listeners>
                                                    </ext:MenuItem>
                                                            
                                                    <ext:MenuItem runat="server" Text="Collapse All" IconCls="icon-collapse-all">
                                                        <Listeners>
                                                            <Click Handler="#{exampleTree}.root.collapse(true);" />
                                                        </Listeners>
                                                    </ext:MenuItem>
                                                    <ext:MenuSeparator runat="server" />
                                                    <ext:MenuItem runat="server" Text="Theme" Icon="Paintcan">
                                                        <Menu>
                                                            <ext:Menu runat="server">
                                                                <Items>
                                                                    <ext:CheckMenuItem ID="MenuItem1" runat="server" Text="Default" Group="theme" Checked="true" />
                                                                    <ext:CheckMenuItem ID="MenuItem2" runat="server" Text="Gray" Group="theme" />
                                                                    <ext:CheckMenuItem ID="MenuItem4" runat="server" Text="Slate" Group="theme" />
                                                                    <ext:CheckMenuItem ID="MenuItem3" runat="server" Text="Access" Group="theme" />
                                                                </Items>
                                                                <Listeners>
                                                                    <ItemClick Handler="X.GetThemeUrl(menuItem.text,{
                                                                        success : function (result) {
                                                                            Ext.net.ResourceMgr.setTheme(result);
                                                                            ExampleTabs.items.each(function (el) {
                                                                                if (!Ext.isEmpty(el.iframe)) {
                                                                                    if (el.getBody().Ext) {
                                                                                        el.getBody().Ext.net.ResourceMgr.setTheme(result, menuItem.text.toLowerCase());
                                                                                    }
                                                                                }
                                                                            });
                                                                        }
                                                                    });" />
                                                                </Listeners>
                                                            </ext:Menu>
                                                        </Menu>
                                                    </ext:MenuItem>
                                                </Items>
                                            </ext:Menu>
                                        </Menu>
                                    </ext:Button>
                                </Items>
                            </ext:Toolbar>
                        </TopBar>      
                           <Listeners>
                            <Click Handler="if (node.isLeaf()) { e.stopEvent();   loadExample(node.id,node.id,node.text); }" />
                        </Listeners>                                                                                          
                    </ext:TreePanel>
                </Items>
            </ext:Panel>
            
            
            
            
            
            
            
            
            
            
            
            
            
                               
            <ext:TabPanel 
                ID="ExampleTabs" 
                runat="server" 
                Region="Center" 
                Margins="0 4 4 0" 
                EnableTabScroll="true"
                MinTabWidth="85">  
                   <Items>
                    <ext:Panel 
                        ID="tabHome" 
                        runat="server" 
                        Title="Home"
                        IconCls="icon-application">
                        <AutoLoad Mode="IFrame" Url="Home/" ShowMask="false" />
                    </ext:Panel>
                </Items>              
                <Listeners>
                    <TabChange Fn="addToken" />
                </Listeners>
                <Plugins>
                    <ext:TabCloseMenu runat="server" />
                </Plugins>
            </ext:TabPanel>
        </Items>
    </ext:Viewport>
    
    <ext:Window 
        ID="LinkWindow" 
        runat="server"
        Modal="true"
        Hidden="true"
        Icon="Link"
        Layout="absolute"
        DefaultButton="exampleLink"
        Width="400"
        Height="110"
        Title="Direct Link"
        Closable="false"
        Resizable="false">
        <Items>
            <ext:TextField 
                ID="exampleLink" 
                runat="server"
                Width="364"
                Cls="dlText"
                X="10"
                Y="10"
                SelectOnFocus="true"
                ReadOnly="true"
                />            
        </Items>
        <Listeners>
            <Show Handler="exampleLink.setValue(this.exampleName);" />
        </Listeners>
        <Buttons>
            <ext:Button 
                runat="server"
                Text=" Open"
                Icon="ApplicationDouble">
                <Listeners>
                    <Click Handler="window.open(LinkWindow.exampleName);" />
                </Listeners>
                <ToolTips>
                    <ext:ToolTip runat="server" Title="Open Example in the separate window" />
                </ToolTips>
            </ext:Button>
            <ext:Button 
                runat="server"
                Text=" Open (Direct)"
                Icon="ApplicationGo">
                <Listeners>
                    <Click Handler="window.open(LinkWindow.exampleUrl, '_blank');" />
                </Listeners>
                <ToolTips>
                    <ext:ToolTip runat="server" Title="Open Example in the separate window using a direct link" />
                </ToolTips>
            </ext:Button>
            <ext:Button runat="server" Text="Close">
                <Listeners>
                    <Click Handler="this.findParentByType('window').hide(null);" />
                </Listeners>
            </ext:Button>
        </Buttons>
    </ext:Window>


      
   
</body>
</html>