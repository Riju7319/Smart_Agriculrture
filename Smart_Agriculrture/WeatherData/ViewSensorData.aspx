<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="ViewSensorData.aspx.cs" Inherits="Smart_Agriculrture.WeatherData.ViewSensorData" %>


<!DOCTYPE html>
<html lang="en">
<head runat="server">
    <meta charset="utf-8" />
    <title>Sensor Data Logs</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet" />
</head>
<body>
    <form id="form1" runat="server">
        <div class="container mt-5">
            <h2 class="mb-4 text-center">📊 Sensor Data Logs</h2>
            
            <asp:GridView ID="GridView1" runat="server" CssClass="table table-bordered table-striped table-hover"
                AutoGenerateColumns="False">
                <Columns>
                    <asp:BoundField DataField="Id" HeaderText="ID" />
                    <asp:BoundField DataField="Temperature" HeaderText="Temperature (°C)" />
                    <asp:BoundField DataField="Humidity" HeaderText="Humidity (%)" />
                    <asp:BoundField DataField="MQ2" HeaderText="MQ2" />
                    <asp:BoundField DataField="Soil" HeaderText="Soil Moisture" />
                    <asp:BoundField DataField="LDR" HeaderText="Light (LDR)" />
                    <asp:BoundField DataField="AirPressure" HeaderText="Air Pressure" />
                    <asp:BoundField DataField="WindSpeed" HeaderText="Wind Speed" />
                    <asp:BoundField DataField="WindDirection" HeaderText="Wind Direction" />
                    <asp:BoundField DataField="Rainfall" HeaderText="Rainfall" />
                    <asp:BoundField DataField="UVIndex" HeaderText="UV Index" />
                    <asp:BoundField DataField="Latitude" HeaderText="Latitude" />
                    <asp:BoundField DataField="Longitude" HeaderText="Longitude" />
                    <asp:BoundField DataField="City" HeaderText="City" />
                    <asp:BoundField DataField="Location" HeaderText="Location" />
                    <asp:BoundField DataField="Timestamp" HeaderText="Date & Time" DataFormatString="{0:yyyy-MM-dd HH:mm:ss}" />
                </Columns>
            </asp:GridView>
        </div>
    </form>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>