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
    public partial class VenueSlot : System.Web.UI.Page
    {
        public static string strcon = ConfigurationManager.ConnectionStrings["conStr"].ConnectionString;
        protected void Page_Load(object sender, EventArgs e)
        {
            Label1.Text = Request.QueryString["venueid"];
            BindCategory();
            BindSlot();
        }
        public void BindCategory()
        {
            using (SqlConnection con = new SqlConnection(ConfigurationManager.ConnectionStrings["conStr"].ConnectionString))
            {
                using (SqlCommand cmd = new SqlCommand("SELECT Category_ID,Category_Name FROM Category", con))
                {
                    con.Open();
                    ddlCategory.DataSource = cmd.ExecuteReader();
                    ddlCategory.DataTextField = "Category_Name";
                    ddlCategory.DataValueField = "Category_ID";
                    ddlCategory.DataBind();
                    ddlCategory.Items.Insert(0, new ListItem("Select Category", "0"));
                    con.Close();
                }
            }
        }

        public void BindSlot()
        {
            using (SqlConnection con = new SqlConnection(ConfigurationManager.ConnectionStrings["conStr"].ConnectionString))
            {
                using (SqlCommand cmd = new SqlCommand("SELECT Slot_ID,Slot_Time FROM Slots", con))
                {
                    con.Open();
                    ddlSlotTiming.DataSource = cmd.ExecuteReader();
                    ddlSlotTiming.DataTextField = "Slot_Time";
                    ddlSlotTiming.DataValueField = "Slot_ID";
                    ddlSlotTiming.DataBind();
                    ddlSlotTiming.Items.Insert(0, new ListItem("Select Slot Timing", "0"));
                    con.Close();
                }
            }
        }
        //protected void BindSlot()
        //{
        //    try
        //    {
        //        using (SqlConnection con = new SqlConnection(ConfigurationManager.ConnectionStrings["conStr"].ConnectionString))
        //        {
        //            using (SqlCommand cmd = new SqlCommand("GET_VenueSlotTimings", con))
        //            {
        //                int venueid = Convert.ToInt32(Label1.Text);
        //                cmd.CommandType = CommandType.StoredProcedure;

        //                cmd.Parameters.AddWithValue("@VenueId ", venueid);
        //                cmd.Parameters.AddWithValue("@SlotDate ", null);
        //                // or cmd.Parameters.AddWithValue("@fname", ddlEmployees.SelectedText.ToString()); 
        //                // according to your query at the backend
        //                SqlDataAdapter adr = new SqlDataAdapter(cmd);
        //                DataTable dt = new DataTable();
        //                adr.Fill(dt);
        //                ddlSlotTiming.DataSource = dt;
        //                ddlSlotTiming.DataTextField = "Slot_Time";
        //                ddlSlotTiming.DataValueField = "Slot_ID";
        //                ddlSlotTiming.DataBind();
        //                ddlSlotTiming.Items.Insert(0, new ListItem("Select Slot Timing", "0"));
        //                //con.Close();
        //                //con.Close();
        //            }
        //        }
        //    }
        //    catch (Exception ex)
        //    {
        //        Response.Write("Error:" + ex.Message.ToString());
        //    }
        //}
        [WebMethod]
        public static string BindStore(int categoryid, int venueid)
        {
            StringWriter builder = new StringWriter();
            String strQuery = "Select Store_ID,Store_Name from Store where Category_ID=@CategoryId and Venue_Id=@VenueId";
            DataSet ds = new DataSet();
            using (SqlConnection con = new SqlConnection(strcon))
            {
                using (SqlCommand cmd = new SqlCommand())
                {
                    cmd.CommandType = CommandType.Text;
                    cmd.CommandText = strQuery;
                    cmd.Parameters.AddWithValue("@CategoryId", categoryid);
                    cmd.Parameters.AddWithValue("@VenueId", venueid);
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
                builder.WriteLine("{\"optionDisplay\":\"Select Store\",");
                builder.WriteLine("\"optionValue\":\"0\"},");
                for (int i = 0; i <= dt.Rows.Count - 1; i++)
                {
                    builder.WriteLine("{\"optionDisplay\":\"" + dt.Rows[i]["Store_Name"] + "\",");
                    builder.WriteLine("\"optionValue\":\"" + dt.Rows[i]["Store_ID"] + "\"},");
                }
            }
            else
            {
                builder.WriteLine("{\"optionDisplay\":\"Select Store\",");
                builder.WriteLine("\"optionValue\":\"0\"},");
            }
            string returnjson = builder.ToString().Substring(0, builder.ToString().Length - 3);
            returnjson = returnjson + "]";
            return returnjson.Replace("\r", "").Replace("\n", "");
        }
        [System.Web.Services.WebMethod]
        public static string BindSlotDetails(int venueid)
        {
            string constr = ConfigurationManager.ConnectionStrings["constr"].ConnectionString;

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
                            cmd.CommandText = "[dbo].[GET_Store]";
                            cmd.Parameters.AddWithValue("@VenueId", venueid);
                            cmd.Parameters.AddWithValue("@SlotTiming", null);
                            cmd.Parameters.AddWithValue("@CategoryId", null);
                            cmd.Parameters.AddWithValue("@Storeid", null);
                            cmd.Parameters.AddWithValue("@Slotdate", null);
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

        [System.Web.Services.WebMethod]
        public static string BookSlot(string data3)
        {

            string venue_name = data3.Split('|')[0].ToString();
            string store_name = data3.Split('|')[1].ToString();
            string category_name = data3.Split('|')[2].ToString();
            string slotdate = data3.Split('|')[3].ToString();
            string slot = data3.Split('|')[4].ToString();
            string noofpeople = data3.Split('|')[5].ToString();
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
                        cmd.CommandText = "[dbo].[sp_BookingSlot]";
                        cmd.Parameters.AddWithValue("@VenueName", venue_name);
                        cmd.Parameters.AddWithValue("@StoreName", store_name);
                        cmd.Parameters.AddWithValue("@CategoryName", category_name);
                        cmd.Parameters.AddWithValue("@SlotDate", slotdate);
                        cmd.Parameters.AddWithValue("@Slot", slot);
                        cmd.Parameters.AddWithValue("@NoofPeople", noofpeople);
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