<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="DeviceStatus.aspx.cs" Inherits="Smart_Agriculrture.WeatherData.DeviceStatus" %>

<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>Smart Agriculture - Device Status Dashboard</title>
    <meta name="viewport" content="width=device-width, initial-scale=1" />

    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet" />
    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>

    <style>
        body { background-color: #f8f9fa; }
        .card { border-radius: 1rem; }
        .status-online { color: green; font-weight: bold; }
        .status-offline { color: red; font-weight: bold; }
    </style>
</head>
<body>
<form id="form1" runat="server" class="container py-4">
    <h3 class="text-center mb-4">🌾 Smart Agriculture - Device Status Dashboard</h3>

    <div id="deviceStatusCard" class="card shadow p-3 mb-4">
        <div class="card-body text-center">
            <h5 class="card-title">Device Status</h5>
            <p id="statusText" class="fs-4 text-muted">Loading...</p>
            <p id="lastUpdated" class="text-secondary"></p>
        </div>
    </div>

    <div class="row text-center">
        <div class="col-md-4">
            <div class="card shadow mb-3 p-3">
                <h6>🌡️ Temperature</h6>
                <p id="tempValue" class="fs-4">--</p>
            </div>
        </div>
        <div class="col-md-4">
            <div class="card shadow mb-3 p-3">
                <h6>💧 Humidity</h6>
                <p id="humValue" class="fs-4">--</p>
            </div>
        </div>
        <div class="col-md-4">
            <div class="card shadow mb-3 p-3">
                <h6>🌱 Soil Moisture</h6>
                <p id="soilValue" class="fs-4">--</p>
            </div>
        </div>
    </div>

    <div class="row text-center">
        <div class="col-md-6">
            <div class="card shadow mb-3 p-3">
                <h6>💡 Light Intensity</h6>
                <p id="lightValue" class="fs-4">--</p>
            </div>
        </div>
        <div class="col-md-6">
            <div class="card shadow mb-3 p-3">
                <h6>🔥 Gas</h6>
                <p id="gasValue" class="fs-4">--</p>
            </div>
        </div>
    </div>

    <div class="card shadow mt-4 p-3">
        <h5 class="text-center">📊 Device Uptime (All Time)</h5>
        <canvas id="uptimeChart" height="100"></canvas>
    </div>

    <div class="text-center mt-4">
        <button type="button" id="refreshBtn" class="btn btn-primary">🔄 Refresh Now</button>
        <button type="button" class="btn btn-outline-secondary btn-back" onclick="window.location.href='ViewSensoreData.aspx'">
    ⬅ Back
</button>
    </div>


</form>

<script>
    const API_URL = "https://api.thingspeak.com/channels/3137414/feeds.json?api_key=O24VY64WB8H3Y2XT&results=8000";
    let uptimeData = [];

    // Chart setup
    let ctx = null;
    let uptimeChart = null;
    function setupChart() {
        ctx = document.getElementById("uptimeChart").getContext("2d");
        uptimeChart = new Chart(ctx, {
            type: 'line',
            data: {
                labels: [],
                datasets: [{
                    label: "Device Uptime (1=Online, 0=Offline)",
                    data: [],
                    borderWidth: 2,
                    borderColor: "green",
                    fill: false,
                    tension: 0.1,
                    pointRadius: 1
                }]
            },
            options: {
                scales: {
                    y: {
                        beginAtZero: true,
                        max: 1,
                        ticks: { stepSize: 1 }
                    },
                    x: {
                        ticks: { maxTicksLimit: 10 }
                    }
                }
            }
        });
    }

    // Update Chart
    function updateChart() {
        uptimeChart.data.labels = uptimeData.map(e => e.time);
        uptimeChart.data.datasets[0].data = uptimeData.map(e => e.status);
        uptimeChart.update();
    }

    function loadDeviceData() {
        $("#statusText").text("⏳ Fetching data...");
        $.getJSON(API_URL, function (data) {
            if (!data || !data.feeds || data.feeds.length === 0) {
                $("#statusText").text("⚠️ No data available");
                return;
            }

            const feeds = data.feeds;
            uptimeData = [];

            // Build uptime history
            for (let i = 0; i < feeds.length; i++) {
                const currentTime = new Date(feeds[i].created_at);
                let status = 1;

                if (i > 0) {
                    const prevTime = new Date(feeds[i - 1].created_at);
                    const diff = (currentTime - prevTime) / 60000; // minutes difference
                    status = diff <= 2 ? 1 : 0; // offline if >2 minutes gap
                }

                uptimeData.push({ time: currentTime.toLocaleString(), status });
            }

            // Latest data
            const lastFeed = feeds[feeds.length - 1];
            const lastTime = new Date(lastFeed.created_at);
            const now = new Date();
            const diffMinutes = (now - lastTime) / 60000;

            if (diffMinutes <= 1) {
                $("#statusText").text("🟢 Device Online").removeClass().addClass("fs-4 status-online");
            } else {
                $("#statusText").text("🔴 Device Offline").removeClass().addClass("fs-4 status-offline");
            }

            $("#lastUpdated").text("⏰ Last Updated: " + lastTime.toLocaleString());
            $("#tempValue").text(lastFeed.field1 + " °C");
            $("#humValue").text(lastFeed.field2 + " %");
            $("#soilValue").text(lastFeed.field3);
            $("#lightValue").text(lastFeed.field4);
            $("#gasValue").text(lastFeed.field5);

            updateChart();
        }).fail(function () {
            $("#statusText").text("❌ Failed to fetch data");
        });
    }

    $(document).ready(function () {
        setupChart();
        loadDeviceData();
        $("#refreshBtn").click(loadDeviceData);
        setInterval(loadDeviceData, 120000); // refresh every 2 minutes
    });
</script>
</body>
</html>
