using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data.SqlClient;
using System.Data;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using Newtonsoft.Json;
using System.Net.Http;
using System.Threading.Tasks;

namespace Smart_Agriculrture.WeatherData
{
	public partial class ViewSensorData : System.Web.UI.Page
	{
        private static readonly HttpClient client = new HttpClient();

        protected async void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                await LoadSensorData();
            }
        }

        private async Task LoadSensorData()
        {
            try
            {
                // Call your GET API
                string apiUrl = "http://localhost:5000/api/SensorData"; // Update with your API URL
                var response = await client.GetStringAsync(apiUrl);

                // Deserialize JSON into objects
                var data = JsonConvert.DeserializeObject<List<SensorLog>>(response);

                // Bind to GridView
                GridView1.DataSource = data;
                GridView1.DataBind();
            }
            catch (Exception ex)
            {
                Response.Write("<script>alert('Error fetching data: " + ex.Message + "');</script>");
            }
        }
    }

    // Model (same as SensorLogs table)
    public class SensorLog
    {
        public int Id { get; set; }
        public double? Temperature { get; set; }
        public double? Humidity { get; set; }
        public int? MQ2 { get; set; }
        public int? Soil { get; set; }
        public int? LDR { get; set; }
        public double? AirPressure { get; set; }
        public double? WindSpeed { get; set; }
        public string WindDirection { get; set; }
        public double? Rainfall { get; set; }
        public double? UVIndex { get; set; }
        public decimal? Latitude { get; set; }
        public decimal? Longitude { get; set; }
        public string City { get; set; }
        public string Location { get; set; }
        public DateTime Timestamp { get; set; }
    }
}
