using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using Ext.Net.Examples;
using System.Reflection;
using Ext.Net;
using System.Data.SqlClient;
using System.Text;
using System.Configuration;
using DevExpress.Data;
using DevExpress.Xpo;
using DevExpress.Data.Filtering;
using System.IO;
using System.Net.Mail;

namespace Data
{
    public class Engine
    {
        static string Fault_ = string.Empty;
        public static string Fault
        {
            get { return Fault_; }
        }

        private string Constr_="";        

        public string ConStr
        {
            get
            {

                if (Constr_ == "")
                    return ConfigurationManager.ConnectionStrings["CONSTR"].ConnectionString;
                else
                    return Constr_;
            }
        }

        public bool Login(ref string user, string pass)
        {
            bool don = false;

            try
            {
                Data.vPersoneller[] snc = new XPCollection<Data.vPersoneller>(Data.XP.Crs,
                    CriteriaOperator.Parse(" SICILNO = ? AND PASSWORD = ? ", user, pass)).ToArray();

                don = snc.Length > 0;
            }
            catch (Exception ee)
            {
                Fault_ = ee.Message;    
            }

            return don;
        }




        public static void QuickMail(string From,string To, string Konu, string Body,string Cc)
        {
            SmtpClient client = new SmtpClient(Data.CFG.Cfg.EPOSTHOST, Data.CFG.Cfg.EPOSTPORT);
            client.EnableSsl = false;
            client.Timeout = 50000;
            client.DeliveryMethod = SmtpDeliveryMethod.Network;
            client.UseDefaultCredentials = true;
            client.Credentials = new System.Net.NetworkCredential(Data.CFG.Cfg.EPostaAdres, Data.CFG.Cfg.EPostaPwd);

            string[] Tos = To.Split(';');

            string[] Ccs = Cc.Split(';');

            MailMessage mm = new MailMessage();

            foreach (string str in Tos)
                if (str.Trim() != "") mm.To.Add(str);

            foreach (string str in Ccs)
                if (str.Trim() != "") mm.CC.Add(str);

            mm.From = new MailAddress(From);

            mm.Subject = Konu;
            mm.BodyEncoding = ASCIIEncoding.UTF8;
            mm.IsBodyHtml = true;
            mm.Body = Body;
            mm.DeliveryNotificationOptions = DeliveryNotificationOptions.OnFailure;
            client.Send(mm);

           
        }
     


  
   
        public void CookieSet(Page pg, string Name, string value)
        {
            pg.Response.Cookies[Name].Value = value;
        }

        public void CookieClear(Page pg, string Name)
        {
            pg.Response.Cookies[Name].Value = "";
            pg.Request.Cookies[Name].Value = "";
        }

        public string CookieGet(Page pg, string Name)
        {
            string don = string.Empty;

            if (
                pg.Request.Cookies == null ||
                pg.Request.Cookies[Name] == null ||
                pg.Request.Cookies[Name].Value == null ||
                pg.Request.Cookies[Name].Value.Trim() == ""
                )
            {
                don = "";
            }
            else
                don = pg.Request.Cookies[Name].Value.Trim();

            if (don != "") return don;

            if (
                pg.Response.Cookies == null ||
                pg.Response.Cookies[Name] == null ||
                pg.Response.Cookies[Name].Value == null ||
                pg.Response.Cookies[Name].Value.Trim() == ""
                )
            { don = ""; }
            else
                don = pg.Response.Cookies[Name].Value.Trim();



            return don;
        }

        public string sC( Page pg, string sessionName)
        {
            return pg.Session == null || pg.Session[sessionName] == null ? "" : pg.Session[sessionName].ToString().Trim();
        }

        public string sC(HttpContext pg, string sessionName)
        {
            return pg.Session == null || pg.Session[sessionName] == null ? "" : pg.Session[sessionName].ToString().Trim();
        }

        public string QC(Page pg, string qName)
        {
            return pg.Request.QueryString == null || pg.Request.QueryString[qName] == null ? "" : pg.Request.QueryString[qName].Trim();
        }

        public string QC(HttpContext pg, string qName)
        {
            return pg.Request.QueryString == null || pg.Request.QueryString[qName] == null ? "" : pg.Request.QueryString[qName].Trim();
        }

        public List<object> GetJsonToObj(Type t, string json)
        {
            var lis = new List<object>();

            string[] rows = json.Split('}');

            for (int j = 0; j < rows.Length; j++)
            {
                string row = rows[j].Replace("{", "").Replace("}", "").Replace("\"", "").Trim();
                if (row == "") continue;
                string[] cl = row.Split(',');

                PropertyInfo[] pr = t.GetProperties(BindingFlags.Public | BindingFlags.Instance);
                object obj = Activator.CreateInstance(t);

                for (int i = 0; i < pr.Length; i++)
                {
                    string[] values = cl[i].Split(':');

                    if (!pr[i].CanWrite) continue;
                    if (values.Length < 2) continue;


                    pr[i].SetValue(obj,
                        System.Convert.ChangeType(new object[] { values[1] }[0], pr[i].PropertyType ), null);

                }

                lis.Add(obj);
            }

            lis.TrimExcess();
            return lis;
        }

        public DateTime GetDate()
        {
            string str = "";
            DateTime dt = DateTime.Now;

            using (MSSQL db = new MSSQL())
            {
                str = db.TScaler("  select getdate()   ");
            }

            try
            {
                dt = DateTime.Parse(str);
            }
            catch { ;}

            return dt;
        }

        public long GetSikayetFormCount()
        {
            long don = -1;
            
            using (MSSQL db = new MSSQL())
            {
                don = db.TCount("");
            }
            
            return don;
        }

       
        public void BuildTree(Ext.Net.TreeNodeCollection nodes)
        {
           

            if (nodes == null)
            {
                nodes = new Ext.Net.TreeNodeCollection();
            }

            Ext.Net.TreeNode root = new Ext.Net.TreeNode();
            root.Text = "Root";
            nodes.Add(root);

            string path = HttpContext.Current.Server.MapPath("~/Examples/");
            TreeYap(path, root);
        }

        void TreeYap(string path, Ext.Net.TreeNode root)
        {



            DirectoryInfo[] ds = new DirectoryInfo(path).
                GetDirectories().OrderBy(x => int.Parse(x.Name.Substring(x.Name.Length - 2, 1))).ToArray();

            foreach (DirectoryInfo d in ds)
            {
                Ext.Net.TreeNode node = new Ext.Net.TreeNode();
                node.NodeID = "MyNodes" + d.Name;
                node.Text = d.Name.Substring(0, d.Name.IndexOf("(")); ;
                node.Icon = Icon.Application;
                root.Nodes.Add(node);

                FileInfo[] fs = new DirectoryInfo(d.FullName).GetFiles().Where(y => y.Name.IndexOf(".aspx") > -1 && y.Name.IndexOf("WebForm") < 0).ToArray();
                fs = fs.OrderBy(x => int.Parse(x.Name.Substring(x.Name.Replace(".aspx", "").Length - 2, 1))).ToArray();

                foreach (FileInfo f in fs)
                {                    
                    Ext.Net.TreeNode SonNode = new Ext.Net.TreeNode();
                    SonNode.NodeID = "/" + d.Name + "/" + f.Name;
                    SonNode.Text = f.Name.Replace(".aspx", "").Substring(0, f.Name.IndexOf("("));
                    SonNode.Icon = Icon.ApplicationFormEdit;
                    SonNode.Leaf = true;
                    node.Nodes.Add(SonNode);                
                }
                TreeYap(d.FullName,node);
            }                                                                         
        }

      
    }
}
