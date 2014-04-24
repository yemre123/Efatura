using System;
using System.Data.SqlClient;
using System.Collections.Generic;
using System.Reflection;
using System.Data;
using System.Configuration;

namespace Data
{
    public class MSSQL:IDisposable
    {
        
        SqlConnection conn;
        SqlCommand comm;

        string Fault_=string.Empty;    

        public string Fault
        {
            get { return Fault_; }            
        }

        public MSSQL()
        {
            string x = ConfigurationManager.ConnectionStrings["CONSTR"].ConnectionString;

            conn = new SqlConnection(x);
            comm = new SqlCommand();
            comm.Connection = conn;
        }

        private bool Reconnect()
        {
            try
            {
                if (conn.State == System.Data.ConnectionState.Broken || conn.State == System.Data.ConnectionState.Closed)
                    conn.Open();
            }
            catch (Exception ex)
            {
                Fault_ = ex.Message;
                return false;
            }

            return true;
        }

        public bool TInsert(string sql)
        {
            bool don = false;

            if (!Reconnect())
                return don;

            try
            {
                comm.CommandText = sql;
                don = comm.ExecuteNonQuery() > 0;
            }
            catch (SqlException ex)
            { Fault_ = ex.Message; }
            catch (Exception ei)
            { Fault_ = ei.Message; }

            return don;
        }

        public string TScaler(string sql)
        {
            object don = null;

            if (!Reconnect())
                return "";

            try
            {
                comm.CommandText = sql;
                don = comm.ExecuteScalar();
            }
            catch (SqlException ex)
            { Fault_ = ex.Message; }
            catch (Exception ei)
            { Fault_ = ei.Message; }

            return don == null ? "" : don.ToString();
        }

        public long TCount(string sql)
        {
            long l = -1;

            try
            {
                l = long.Parse(TScaler(sql));
            }
            catch
            {
                ;
            }

            return l;
        }


        public List<object> DbToList(Type t, string Sql)
        {
            var List_ = new List<object>();

            if (!Reconnect())
                return List_;

            comm.CommandText = Sql;

            using (SqlDataReader Dr = comm.ExecuteReader())
            {
                while (Dr.Read())
                {
                    PropertyInfo[] pr = t.GetProperties(BindingFlags.Public | BindingFlags.Instance);
                    object obj = Activator.CreateInstance(t);
                    for (int i = 0; i < pr.Length; i++)
                    {
                        if (!pr[i].CanWrite) continue;

                        object objValue = Dr.GetValue(Dr.GetOrdinal(pr[i].Name));

                        try
                        {
                            pr[i].SetValue(obj,
                                 System.Convert.ChangeType(new object[] { objValue }[0], pr[i].PropertyType), null);
                        }
                        catch { ;}

                    }

                    List_.Add(obj);
                }

                Dr.Close();
            }
             

            return List_;
        }
        

        public DataSet TableDon(string sql)
        {
            DataSet dt = new DataSet();

            if (!Reconnect())
                return dt;

            try
            {
                using (SqlDataAdapter ap = new SqlDataAdapter(sql, conn))
                {
                    ap.Fill(dt);
                    dt.AcceptChanges();
                }
            }
            catch (SqlException ex)
            { Fault_ = ex.Message; }
            catch (Exception ei)
            { Fault_ = ei.Message; }

            return dt;
        }

        ~MSSQL()
        {
            kapa();

        }

        void kapa()
        {
            try
            {
                conn.Close();

                comm.Dispose();
                comm = null;

                conn.Dispose();
                conn = null;
            }
            catch
            {
                ;
            }
        }

        #region IDisposable Members

        public void Dispose()
        {
            kapa();
        }

        #endregion

    }
}
