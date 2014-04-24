using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Data;
using CrystalDecisions.CrystalReports.Engine;
using CrystalDecisions.Shared;
using System.Configuration;
using System.Data.SqlClient;

namespace Ext.Net.Examples
{
    public partial class WebForm1 : System.Web.UI.Page
    {



        protected void Page_Load(object sender, EventArgs e)
        {
            
            string pp = Server.MapPath(".") + "\\rpr4.rpt";
            CrystalReportSource1.ReportDocument.Load(pp);
            ReportDocument doc = CrystalReportSource1.ReportDocument;
            BaglantiAyarla(doc);
            CrystalReportViewer1.ReportSource = CrystalReportSource1;
            //ParamAyarla(doc.DataDefinition.ParameterFields, 0, GetCurID);

            DataTable dt = new DataTable();

            string qs = Request.QueryString["ID"];

            if (qs.IndexOf(",") < 0)
                qs += ",";

            string sqL = " Select  * From vPersRapor  ";
            sqL += " Where LREF IN ( " + qs + "0 )";

            using (SqlDataAdapter ap = new SqlDataAdapter(sqL, (SqlConnection)Data.XP.Crs.Connection))
            {
                ap.Fill(dt);
                dt.TableName = "vPersRapor";
                dt.AcceptChanges();
            }



            doc.SetDataSource(dt);
        }

        public string BaglantiAyarla(ReportDocument siparisF)
        {
            string sql = "";

            foreach (CrystalDecisions.CrystalReports.Engine.Table table in siparisF.Database.Tables)
            {
                TableLogOnInfo logOnInfo = table.LogOnInfo;
                sql = logOnInfo.TableName;

                string constr = ConfigurationManager.ConnectionStrings["CONSTR"].ConnectionString;

                //logOnInfo.ConnectionInfo = ConnectionInfo;
                //logOnInfo.ConnectionInfo.Type = ConnectionInfoType.SQL;
                //logOnInfo.ConnectionInfo.Attributes.Collection.Clear();

                logOnInfo.ConnectionInfo.ServerName =
                    ConstrParser(constr, "Data Source");
                logOnInfo.ConnectionInfo.UserID = ConstrParser(constr, "User ID");
                logOnInfo.ConnectionInfo.DatabaseName = ConstrParser(constr, "Initial Catalog");
                logOnInfo.ConnectionInfo.Password = ConstrParser(constr, "Password");


                table.ApplyLogOnInfo(logOnInfo);

            }

            //siparisF.VerifyDatabase();

            return sql;
        }

        string ConstrParser(string Constr, string section)
        {
            string ss = "";

            try
            {
                string[] sections = Constr.Split(';');
                foreach (string sx in sections)
                {
                    if (sx.IndexOf(section) > -1)
                    {
                        ss = sx.Split('=')[1].Replace(";", "");
                        break;
                    }
                }
            }
            catch
            {

            }

            return ss;
        }


        public void ParamAyarla(ParameterFieldDefinitions pfd, int pIsim, int pDeger)
        {
            ParameterFieldDefinition crPFD = pfd[pIsim];
            ParameterValues crPDeger = crPFD.CurrentValues;
            ParameterDiscreteValue crPDV = new ParameterDiscreteValue
            {
                Value = pDeger
            };
            crPDeger.Add((ParameterValue)crPDV);
            crPFD.ApplyCurrentValues(crPDeger);
        }

        protected void btnGeri_Click(object sender, EventArgs e)
        {          
            Response.Redirect(GetCurPage);
        }

        protected void btnGeriPers_Click(object sender, EventArgs e)
        {
            int sonraki = 0;
            int[] Ids = GetIDS;
            int curID = GetCurID;

            for (int i = 0; i < Ids.Length; i++)
            {
                if (curID == Ids[i] && i > 0)
                {

                    sonraki = Ids[i - 1];
                    Response.Redirect("WebForm1a.aspx?ID=" + sonraki.ToString() + "&Page=" + GetCurPage.ToString() + "&PersTip=" + GetCurPersTip.ToString());
                    return;

                }
            }         
        }

        protected void btnIleriPers_Click(object sender, EventArgs e)
        {
            int sonraki = 0;
            int[] Ids = GetIDS;
            int curID = GetCurID;

            for (int i = 0; i < Ids.Length; i++)
            {
                if (curID == Ids[i] && i < Ids.Length - 1)
                {
                    sonraki = Ids[i + 1];
                    Response.Redirect("WebForm1a.aspx?ID=" + sonraki.ToString() + "&Page=" + GetCurPage.ToString() + "&PersTip=" + GetCurPersTip.ToString());
                    return;
                }
            }         
        }

        int[] GetIDS
        {
            get
            {
                int PersTip = GetCurPersTip;
 
                int[] Ids = Session["PersIdler" + PersTip.ToString()] as int[];

                if (Ids == null || Ids.Length < 1)
                {
                    Data.vPersoneller[] List =
                        new DevExpress.Xpo.XPCollection<Data.vPersoneller>
                            (Data.XP.Crs, DevExpress.Data.Filtering.CriteriaOperator.Parse("TYP = " + PersTip.ToString()))
                            .OrderBy(x=>x.SiraNo).ToArray();

                    Session["PersIdler" + PersTip.ToString()] = List.OrderBy(x => x.SiraNo).Select(y => y.LREF).ToArray();

                    Ids = Session["PersIdler" + PersTip.ToString()] as int[];
                }

                return Ids;
            }
        }

        int GetCurID
        {
            get
            {

                int PersId = 0;

                try
                {
                    if (Request.QueryString.Count > 0)
                    {
                        string[] strs = Request.QueryString["ID"].Split(',');
                        strs = strs.Where(x => x.ToString().Trim() != "").ToArray();

                        PersId = int.Parse(strs[strs.Length - 1]);
                    }
                }
                catch
                {
                }

                return PersId;
            }
        }

        string GetCurPage
        {
            get
            {

                string pg = "";

                try
                {
                    pg = Request.QueryString["Page"];
                }
                catch
                {
                }

                return pg;
            }
        }

        int GetCurPersTip
        {
            get
            {

                int snc = 0;

                try
                {
                    snc = int.Parse(Request.QueryString["PersTip"]);
                }
                catch
                {
                }

                return snc;
            }
        }


    }
}
