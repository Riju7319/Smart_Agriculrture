using Newtonsoft.Json;
using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data.SqlClient;
using System.Linq;
using System.Web;

namespace Smart_Agriculrture.API
{
    /// <summary>
    /// Summary description for SensorDataGetHandler
    /// </summary>
    public class SensorDataGetHandler : IHttpHandler {

        public void ProcessRequest (HttpContext context) {
            context.Response.ContentType = "application/json";

            try
            {
                string connStr = ConfigurationManager.ConnectionStrings["SmartAgriDB"].ConnectionString;
                var results = new List<SensorData>();

                using (SqlConnection conn = new SqlConnection(connStr))
                {
                    // Example: get last 50 records, ordered by latest first
                    string query = @"SELECT TOP 50 
                                        Temperature, Humidity, MQ2, Soil, LDR, 
                                        AirPressure, WindSpeed, WindDirection, 
                                        Rainfall, UVIndex, Latitude, Longitude, 
                                        City, Location, Timestamp
                                     FROM SensorLogs
                                     ORDER BY Id DESC";

                    SqlCommand cmd = new SqlCommand(query, conn);
                    conn.Open();

                    using (var reader = cmd.ExecuteReader())
                    {
                        while (reader.Read())
                        {
                            results.Add(new SensorData
                            {
                                Temperature = reader["Temperature"] as double?,
                                Humidity = reader["Humidity"] as double?,
                                MQ2 = reader["MQ2"] as int?,
                                SoilMoisture = reader["Soil"] as int?,
                                LightIntensity = reader["LDR"] as int?,
                                AirPressure = reader["AirPressure"] as double?,
                                WindSpeed = reader["WindSpeed"] as double?,
                                WindDirection = reader["WindDirection"].ToString(),
                                Rainfall = reader["Rainfall"] as double?,
                                UVIndex = reader["UVIndex"] as double?,
                                Latitude = reader["Latitude"] as decimal?,
                                Longitude = reader["Longitude"] as decimal?,
                                City = reader["City"].ToString(),
                                Location = reader["Location"].ToString()
                            });
                        }
                    }
                }

                // Return as JSON
                context.Response.Write(JsonConvert.SerializeObject(new
                {
                    status = "success",
                    count = results.Count,
                    data = results
                }));
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
}