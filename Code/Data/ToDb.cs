using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Data.SqlClient;

namespace Data
{
    public  class ToDb
    {
        public string DbName = "GknIK";

        public string GetLastError { get; set; }

        public bool IsTable(string TableName)
        {
            bool don = false;

            try
            {
                string sql = "select  Count(*)   from sys.objects where ( type='U' ) and name='{0}'";
                string endSql = string.Format(sql, TableName);

                object snc = XP.Crs.ExecuteScalar(endSql);

                if (snc != null && snc.ToString().Trim() != "")
                    don = int.Parse(snc.ToString()) > 0;
            }
            catch (SqlException ee)
            {
                GetLastError = ee.Message;
                don = false;
            }
         
            return don;
        }

        public bool IsDBTable(string TableName,string DB_)
        {
            bool don = false;

            try
            {
                string sql = "select  Count(*)   from " + DB_ + ".sys.objects where ( type='U' ) and name='{0}'";
                string endSql = string.Format(sql, TableName);

                object snc = Data.XP.Crs.ExecuteScalar(endSql);

                if (snc != null && snc.ToString().Trim() != "")
                    don = int.Parse(snc.ToString()) > 0;
            }
            catch (SqlException ee)
            {
                GetLastError = ee.Message;
                don = false;
            }

            return don;
        }

        public bool IsView(string TableName)
        {
            bool don = false;

            try
            {
                string sql = "select  Count(*)   from sys.objects where ( type='V' ) and name='{0}'";
                string endSql = string.Format(sql, TableName);

                object snc = Data.XP.Crs.ExecuteScalar(endSql);

                if (snc != null && snc.ToString().Trim() != "")
                    don = int.Parse(snc.ToString()) > 0;
            }
            catch (SqlException ee)
            {
                GetLastError = ee.Message;
                don = false;
            }

            return don;
        }

        public bool IsColumn(string TableName,string colName)
        {
            bool don = false;

            try
            {
                string sql = @"select  COUNT(*)   from sys.columns where object_id=(
                            select  Top 1 object_id  from sys.objects where type='U' and name='{0}')and name='{1}'";

                object snc = Data.XP.Crs.ExecuteScalar(string.Format(sql, TableName, colName));

                if (snc != null && snc.ToString().Trim() != "")
                    don = int.Parse(snc.ToString()) > 0;
            }
            catch (SqlException ee)
            {
                GetLastError = ee.Message;
                don = false;
            }

            return don;
        }
     
        public bool CreateTable(string TableName,  string[] colNames)
        {
            bool don = true;
            string Cols = " ";


            for (int i = 0; i < colNames.Length; i++)
                Cols += " " + colNames[i] + " ,";
            

            try
            {
                string sql = @"
                CREATE TABLE [dbo].[{0}](
	                [OID] [int] IDENTITY(1,1) NOT FOR REPLICATION NOT NULL,
                    {1}
                    TARIH datetime NULL , STOKID int NULL , DEPOID int NULL , BOLGE_ID int
                 CONSTRAINT [PK_{0}] PRIMARY KEY CLUSTERED 
                (
	                [OID] ASC
                )WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
                ) ON [PRIMARY]";

                string sSql = string.Format(sql, TableName, Cols);

                Data.XP.Crs.ExecuteNonQuery(sSql);
                 
            }
            catch (SqlException ee)
            {
                GetLastError = ee.Message;
                don = false;
            }

            return don;
        }

        public bool CreateView(string TableName, string SQL)
        {
            bool don = true;
                        
            try
            {
                string endSql = @"
                 CREATE VIEW [dbo].["+TableName+"]  as  " + SQL;

                Data.XP.Crs.ExecuteNonQuery(endSql);
            }
            catch (SqlException ee)
            {
                GetLastError = ee.Message;
                don = false;
            }

            return don;
        }

        public bool AddCol(string TableName, string colName)
        {
            bool don = false;
 
            try
            {
                Data.XP.Crs.ExecuteNonQuery(" alter table [" + TableName + "] add [" + colName + "] ");
            
            }
            catch (SqlException ee)
            {
                GetLastError = ee.Message;
                don = false;
            }

            return don;
        }

        public bool RemoveCol(string TableName, string colName)
        {
            bool don = false;

            try
            {
                Data.XP.Crs.ExecuteNonQuery(" alter table [" + TableName + "] drop column [" + colName + "] ");
            }
            catch (SqlException ee)
            {
                GetLastError = ee.Message;
                don = false;
            }

            return don;
        }

        public string[] GetViews()
        {
            string[] don = new string[] { "" };

            try
            {
                string sql = @"
                declare  @str nvarchar(3500)
                select @str=''

                select @str=@str+';'+name  from sys.objects 
                where ( type='V' ) 

                select @str ";

                object snc = XP.Crs.ExecuteScalar(sql);

                if (snc != null && snc.ToString().Trim() != "")
                    don = snc.ToString().Split(';');
            }
            catch (SqlException ee)
            {
                GetLastError = ee.Message;
            }

            return don;
        }

        public string[] GetTables()
        {
            string[] don = new string[] { "" };

            try
            {
                string sql = @"
                declare  @str nvarchar(3500)
                select @str=''

                select @str=@str+';'+name  from sys.objects 
                where ( type='U' ) 

                select @str ";

                object snc = XP.Crs.ExecuteScalar(sql);

                if (snc != null && snc.ToString().Trim() != "")
                    don = snc.ToString().Split(';');
            }
            catch (SqlException ee)
            {
                GetLastError = ee.Message;                
            }

            return don;
        }

        public string[] GetTables(string likeCond,string notLikeCond)
        {
            string[] don = new string[] { "" };

            try
            {
                string sql = @"
                declare  @str nvarchar(3500)
                select @str=''

                select @str=@str+';'+name  from sys.objects 
                where ( type='U' ) and name like '%" + likeCond + "%' and name not like '%"+notLikeCond+"%'  select @str ";

                object snc = XP.Crs.ExecuteScalar(sql);

                if (snc != null && snc.ToString().Trim() != "")
                    don = snc.ToString().Split(';');
            }
            catch (SqlException ee)
            {
                GetLastError = ee.Message;
            }

            return don;
        }

        public bool ALTERCol(string TableName, string colName,string typeInf)
        {
            bool don = false;

            try
            {
                Data.XP.Crs.ExecuteNonQuery(
                @" alter table [" + TableName + "] alter column " + colName + " " + typeInf);
            }
            catch (SqlException ee)
            {
                GetLastError = ee.Message;
                don = false;
            }

            return don;
        }

        public bool RemoveView(string Name)
        {
            bool don = false;

            try
            {
                Data.XP.Crs.ExecuteNonQuery(@" DROP VIEW " + Name);
            }
            catch (SqlException ee)
            {
                GetLastError = ee.Message;
                don = false;
            }

            return don;
        }

        public bool RemoveIsIndex(string TableName, string colName)
        {
            bool don = false;

            try
            {
                object snc =
                Data.XP.Crs.ExecuteScalar(
                string.Format(@"
                select ind.name from sys.indexes ind
                INNER JOIN 
                     sys.tables t ON ind.object_id = t.object_id 
                 where t.name='{0}' and ind.name like '%{1}%' ", TableName, colName));

                if (snc != null && snc.ToString().Trim() != "")
                    don = Data.XP.Crs.ExecuteNonQuery("DROP INDEX [" + snc.ToString() + "] ON [dbo].[" + TableName + "]") > 0;
            }
            catch (SqlException ee)
            {
                GetLastError = ee.Message;
                don = false;
            }



            return don;
        }

        public System.Data.DataTable GetDataTable(string sql)
        {
            System.Data.DataTable dt = new System.Data.DataTable();

            try
            {
                SqlDataAdapter ap = new SqlDataAdapter(sql,(SqlConnection)Data.XP.Crs.Connection);
                ap.Fill(dt);
                dt.AcceptChanges();
            }
            catch (Exception ee)
            {
                GetLastError = ee.Message;
            }

            return dt;
        }
    }

    public class KolonBilgi
    {

        public string ExceldekiHali { get; set; }
        public string Duzeltilmis { get; set; }
        public bool KayitEdilcek { get; set; }
        public bool TutarsalKolon { get; set; }
        public bool StokKodKolonAdi { get; set; }

        public string KolCreate { get; set; }
    }


    public class TabloAdi
    {
        public string ExceldekiHali { get; set; }
        public string Duzeltilmis { get; set; }        
    }
}
