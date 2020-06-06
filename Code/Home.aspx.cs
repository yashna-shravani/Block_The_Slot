using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.IO;
using System.Data;
using System.Drawing;
using System.Data.SqlClient;
using System.Configuration;
using System.Web.Services;
using Newtonsoft.Json;


namespace BlockTheSlot
{
    public partial class Home : System.Web.UI.Page
    {


        public static string strcon = ConfigurationManager.ConnectionStrings["conStr"].ConnectionString;

        protected void Page_Load(object sender, EventArgs e)
        {
            BindCity();            
        }
        public class City
        {
            public int CityId { get; set; }
            public string CityName { get; set; }
        }

        public void BindCity()
        {
            using (SqlConnection con = new SqlConnection(ConfigurationManager.ConnectionStrings["conStr"].ConnectionString))
            {
                using (SqlCommand cmd = new SqlCommand("SELECT City_ID,City_Name FROM City", con))
                {
                    con.Open();
                    ddlCity.DataSource = cmd.ExecuteReader();
                    ddlCity.DataTextField = "City_Name";
                    ddlCity.DataValueField = "City_ID";
                    ddlCity.DataBind();
                    ddlCity.Items.Insert(0, new ListItem("Select City", "0"));
                    con.Close();
                }
            }
        }

           
        [WebMethod]
        public static string BindVenue(int cityid)
        {
            StringWriter builder = new StringWriter();
            String strQuery = "SELECT Venue_ID,Venue_Name FROM Venue where City_ID=@CityId";
            DataSet ds = new DataSet();
            using (SqlConnection con = new SqlConnection(strcon))
            {
                using (SqlCommand cmd = new SqlCommand())
                {
                    cmd.CommandType = CommandType.Text;
                    cmd.CommandText = strQuery;
                    cmd.Parameters.AddWithValue("@CityId", cityid);
                    cmd.Connection = con;
                    con.Open();
                    SqlDataAdapter da = new SqlDataAdapter(cmd);
                    da.Fill(ds);
                    con.Close();
                }
            }

            DataTable dt = ds.Tables[0];
            builder.WriteLine("[");
            if (dt.Rows.Count > 0)
            {
                builder.WriteLine("{\"optionDisplay\":\"Select Venue\",");
                builder.WriteLine("\"optionValue\":\"0\"},");
                for (int i = 0; i <= dt.Rows.Count - 1; i++)
                {
                    builder.WriteLine("{\"optionDisplay\":\"" + dt.Rows[i]["Venue_Name"] + "\",");
                    builder.WriteLine("\"optionValue\":\"" + dt.Rows[i]["Venue_ID"] + "\"},");
                }
            }
            else
            {
                builder.WriteLine("{\"optionDisplay\":\"Select Venue\",");
                builder.WriteLine("\"optionValue\":\"0\"},");
            }
            string returnjson = builder.ToString().Substring(0, builder.ToString().Length - 3);
            returnjson = returnjson + "]";
            return returnjson.Replace("\r", "").Replace("\n", "");
        }

        [System.Web.Services.WebMethod]
        public static string Get_Venue()
        {
            string constr = ConfigurationManager.ConnectionStrings["constr"].ConnectionString;

            // string MSID = data3;

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
                            cmd.CommandText = "[dbo].[GET_VENUEBYCITY]";
                            cmd.Parameters.AddWithValue("@CITYID", null);
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

                // int Totalvol = dt.Rows.Count;
                return JsonConvert.SerializeObject(ds, Formatting.Indented, new JsonSerializerSettings
                {
                    ReferenceLoopHandling = ReferenceLoopHandling.Ignore
                });
            }
        }

        [System.Web.Services.WebMethod]
        public static string Get_Offers()
        {
            string constr = ConfigurationManager.ConnectionStrings["constr"].ConnectionString;

            // string MSID = data3;

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
                            cmd.CommandText = "[dbo].[GET_StoreOffers]";
                            cmd.Parameters.AddWithValue("@VenueId", null);
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

                return JsonConvert.SerializeObject(ds, Formatting.Indented, new JsonSerializerSettings
                {
                    ReferenceLoopHandling = ReferenceLoopHandling.Ignore
                });
            }
        }
    }
}