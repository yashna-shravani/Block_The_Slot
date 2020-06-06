using Newtonsoft.Json;
using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;

namespace BlockTheSlot
{
    public partial class Registration : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {

        }
        [System.Web.Services.WebMethod]
        public static string Save_User_Registration(string data3)
        {
            string firstname = data3.Split('|')[0].ToString();
            string lastname = data3.Split('|')[1].ToString();
            string email = data3.Split('|')[2].ToString();
            string password = data3.Split('|')[3].ToString();
            string mobileno = data3.Split('|')[4].ToString();
            string secquestion = data3.Split('|')[5].ToString();
            string secanswer = data3.Split('|')[6].ToString();
            long PhoneNo = long.Parse(mobileno);
            string constr = ConfigurationManager.ConnectionStrings["constr"].ConnectionString;
            DataTable dt = new DataTable();
            using (SqlConnection con = new SqlConnection(constr))
            {
                using (SqlCommand cmd = new SqlCommand(constr))
                {
                    try
                    {
                        con.Open();
                        cmd.CommandType = CommandType.StoredProcedure;
                        cmd.CommandText = "[dbo].[sp_Insert_Customer_Registration]";
                        cmd.Parameters.AddWithValue("@FirstName", firstname);
                        cmd.Parameters.AddWithValue("@LastName", lastname);
                        cmd.Parameters.AddWithValue("@Email", email);
                        cmd.Parameters.AddWithValue("@Password", password);
                        cmd.Parameters.AddWithValue("@PhoneNo", PhoneNo);
                        cmd.Parameters.AddWithValue("@SecurityQuestion", secquestion);
                        cmd.Parameters.AddWithValue("@SecurityAnswer", secanswer);
                        cmd.Connection = con;
                        //cmd.ExecuteNonQuery();
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
            return JsonConvert.SerializeObject(ds, Formatting.Indented, new JsonSerializerSettings
            {
                ReferenceLoopHandling = ReferenceLoopHandling.Ignore
            });
        }
    }
}