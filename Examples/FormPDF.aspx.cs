using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace Ext.Net.Examples.Examples
{
    public partial class FormPDF : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {

            if (Session["PDF_FILE"] == null) return;

            FileInfo file = new FileInfo(Session["PDF_FILE"].ToString());

            if (file.Exists)
            {

                Response.ContentType = "application/pdf";



                Response.Clear();


                Response.TransmitFile(file.FullName);

                Response.End();

            } 
        }
    }
}