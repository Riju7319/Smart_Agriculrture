using Newtonsoft.Json;
using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data.SqlClient;
using System.IO;
using System.Linq;
using System.Web;

namespace Smart_Agriculrture.API
{
    /// <summary>
    /// Summary description for SensorDataHandler
    /// </summary>
    public class SensorDataHandler : IHttpHandler {

        public void ProcessRequest(HttpContext context)
        {
            context.Response.ContentType = "application/json";
            try
            {
                // Read body as JSON
                string body;
                using (var reader = new StreamReader(context.Request.InputStream))
                {
                    body = reader.ReadToEnd();
                }

                // Deserialize JSON into object
                var data = JsonConvert.DeserializeObject<SensorData>(body);

                // Save to database
                string connStr = ConfigurationManager.ConnectionStrings["SmartAgriDB"].ConnectionString;
                using (SqlConnection conn = new SqlConnection(connStr))
                {
                    string query = @"
                INSERT INTO SensorLogs 
                (Temperature, Humidity, MQ2, Soil, LDR, AirPressure, WindSpeed, WindDirection, 
                 Rainfall, UVIndex, Latitude, Longitude, City, Location, Timestamp) 
                VALUES 
                (@Temp, @Hum, @MQ2, @Soil, @LDR, @AirPressure, @WindSpeed, @WindDirection, 
                 @Rainfall, @UVIndex, @Lat, @Lng, @City, @Location, GETDATE())";

                    SqlCommand cmd = new SqlCommand(query, conn);

                    cmd.Parameters.AddWithValue("@Temp", (object)data.Temperature ?? DBNull.Value);
                    cmd.Parameters.AddWithValue("@Hum", (object)data.Humidity ?? DBNull.Value);
                    cmd.Parameters.AddWithValue("@MQ2", (object)data.MQ2 ?? DBNull.Value);
                    cmd.Parameters.AddWithValue("@Soil", (object)data.SoilMoisture ?? DBNull.Value);
                    cmd.Parameters.AddWithValue("@LDR", (object)data.LightIntensity ?? DBNull.Value);
                    cmd.Parameters.AddWithValue("@AirPressure", (object)data.AirPressure ?? DBNull.Value);
                    cmd.Parameters.AddWithValue("@WindSpeed", (object)data.WindSpeed ?? DBNull.Value);
                    cmd.Parameters.AddWithValue("@WindDirection", (object)data.WindDirection ?? DBNull.Value);
                    cmd.Parameters.AddWithValue("@Rainfall", (object)data.Rainfall ?? DBNull.Value);
                    cmd.Parameters.AddWithValue("@UVIndex", (object)data.UVIndex ?? DBNull.Value);
                    cmd.Parameters.AddWithValue("@Lat", (object)data.Latitude ?? DBNull.Value);
                    cmd.Parameters.AddWithValue("@Lng", (object)data.Longitude ?? DBNull.Value);
                    cmd.Parameters.AddWithValue("@City", (object)data.City ?? DBNull.Value);
                    cmd.Parameters.AddWithValue("@Location", (object)data.Location ?? DBNull.Value);

                    conn.Open();
                    cmd.ExecuteNonQuery();
                }

                context.Response.Write(JsonConvert.SerializeObject(new { status = "success" }));
            }
            catch (Exception ex)
            {
                context.Response.StatusCode = 500;
                context.Response.Write(JsonConvert.SerializeObject(new { status = "error", message = ex.Message }));
            }
        }

        public bool IsReusable {
            get {
                return false;
            }
        }
    }

    public class SensorData
    {
        // Core
        public double? Temperature { get; set; }
        public double? Humidity { get; set; }
        public int? MQ2 { get; set; }
        public int? SoilMoisture { get; set; }
        public int? LightIntensity { get; set; }

        // Extra weather params
        public double? AirPressure { get; set; }
        public double? WindSpeed { get; set; }
        public string WindDirection { get; set; }
        public double? Rainfall { get; set; }
        public double? UVIndex { get; set; }

        // Location
        public decimal? Latitude { get; set; }
        public decimal? Longitude { get; set; }
        public string City { get; set; }
        public string Location { get; set; }
    }
}