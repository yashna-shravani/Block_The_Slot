using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Configuration;
using System.Data.SqlClient;
using System.Data;

namespace BlockTheSlot
{
    public partial class Login : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {

        }
        [System.Web.Services.WebMethod]
        public static bool ValidateUser(string userid, string password)
        {
            string constr = ConfigurationManager.ConnectionStrings["constr"].ConnectionString;

            // string MSID = data3;
            bool IsValidUser = false;
            DataTable dt = new DataTable();
            using (SqlConnection con = new SqlConnection(constr))
            {
                using (SqlCommand cmd = new SqlCommand(constr))
                {
                    using (SqlDataAdapter sda = new SqlDataAdapter())
                    {

                        try
                        {
                            con.Open();
                            cmd.CommandType = CommandType.StoredProcedure;
                            cmd.CommandText = "[dbo].[sp_Get_Login_Cust_Details]";
                            // cmd.CommandText = "[dbo].[sp_test2]";
                            cmd.Parameters.AddWithValue("@UserId", userid);
                            cmd.Parameters.AddWithValue("@Password", password);
                            cmd.Connection = con;
                            SqlDataAdapter da = new SqlDataAdapter(cmd);
                            da.Fill(dt);
                            con.Close();
                        }
                        catch (SqlException ex)
                        {

                        }
                        finally
                        {
                            con.Close();
                        }
                    }
                }


                DataSet ds = new DataSet();
                ds.Tables.Add(dt);

                if (ds.Tables.Count > 0)
                {
                    if (ds.Tables[0].Rows.Count == 1)
                    {
                        IsValidUser = true;
                    }
                }
            }
            return IsValidUser;
        }
        public class Users
        {
            public string Username { get; set; }
            public string Password { get; set; }
        }
    }
}
