<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="humiditydata.aspx.cs" Inherits="Smart_Agriculrture.WeatherData.humiditydata" %>

<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <meta charset="utf-8" />
    <title>💧 Humidity Insights - Smart Agriculture</title>

    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet" />
    <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/jquery@3.6.4/dist/jquery.min.js"></script>

    <style>
        body {
            background-color: #f8f9fa;
            font-family: 'Segoe UI', sans-serif;
        }

        .card {
            border-radius: 12px;
            border: 1px solid #dee2e6;
            box-shadow: 0 2px 10px rgba(0,0,0,0.05);
        }

        #humidChart {
            height: 350px !important;
        }

        .advice-box {
            padding: 15px;
            border-radius: 10px;
            margin-top: 20px;
            font-weight: 500;
            text-align: center;
            transition: 0.3s ease;
        }

        .btn-back {
            position: absolute;
            top: 20px;
            left: 20px;
        }

        @media (max-width: 768px) {
            .btn-back {
                position: relative;
                display: block;
                margin-bottom: 10px;
                left: 0;
            }
        }
    </style>
</head>

<body>
    <form id="form1" runat="server">
        <div class="container mt-4">

            <button type="button" class="btn btn-outline-secondary btn-back" onclick="window.location.href='ViewSensoreData.aspx'">
                ⬅ Back
            </button>

            <h2 class="text-center mb-4">💧 Humidity Data Visualization</h2>

            <div class="card shadow-sm p-4">
                <canvas id="humidChart"></canvas>
            </div>

            <div id="adviceBox" class="advice-box bg-light text-secondary">
                Fetching humidity insights...
            </div>

            <div class="text-center mt-3">
                <button id="refreshBtn" class="btn btn-primary">
                    🔄 Refresh Data
                </button>
            </div>
        </div>

        <script>
            const apiUrl = "https://api.thingspeak.com/channels/3229994/feeds.json?api_key=W7LGD7SPBJ7YOB5O";
            let humidChart = null;

            function fetchHumidityData() {
                $("#refreshBtn").html(`<span class='spinner-border spinner-border-sm'></span> Loading...`);

                $.get(apiUrl, function (data) {
                    const feeds = data.feeds || [];

                    const validData = feeds
                        .filter(f => f.field2 && parseFloat(f.field2) > 0)
                        .map(f => ({
                            time: new Date(f.created_at).toLocaleString(),
                            humidity: parseFloat(f.field2)
                        }));

                    if (validData.length === 0) {
                        showAdvice("No valid humidity data found.", "secondary");
                        $("#refreshBtn").html("🔄 Refresh Data");
                        return;
                    }

                    const labels = validData.map(v => v.time);
                    const humids = validData.map(v => v.humidity);

                    renderHumidityChart(labels, humids);

                    const latestHumid = humids[humids.length - 1];
                    updateAdvice(latestHumid);

                    $("#refreshBtn").html("🔄 Refresh Data");
                });
            }

            function renderHumidityChart(labels, humids) {
                const ctx = document.getElementById("humidChart").getContext("2d");
                if (humidChart) humidChart.destroy();

                const gradient = ctx.createLinearGradient(0, 0, 0, 400);
                gradient.addColorStop(0, "rgba(0, 191, 255, 0.4)");
                gradient.addColorStop(1, "rgba(255, 255, 255, 0)");

                humidChart = new Chart(ctx, {
                    type: "line",
                    data: {
                        labels: labels,
                        datasets: [{
                            label: "Humidity (%)",
                            data: humids,
                            borderColor: "#0d6efd",
                            backgroundColor: gradient,
                            fill: true,
                            tension: 0.4,
                            borderWidth: 2,
                            pointRadius: 3
                        }]
                    },
                    options: {
                        responsive: true,
                        plugins: {
                            legend: { display: true },
                            tooltip: {
                                callbacks: {
                                    label: context => `${context.parsed.y}%`
                                }
                            }
                        },
                        scales: {
                            x: {
                                ticks: { color: "#6c757d", autoSkip: true, maxTicksLimit: 6 }
                            },
                            y: {
                                beginAtZero: true,
                                ticks: { color: "#6c757d" }
                            }
                        }
                    }
                });
            }

            function updateAdvice(humidity) {
                let message = "";
                let color = "";

                if (humidity < 30) {
                    message = "🌵 Air is too dry — plants may lose moisture!";
                    color = "warning";
                } else if (humidity >= 30 && humidity <= 60) {
                    message = "🌿 Humidity is ideal for plant growth!";
                    color = "success";
                } else if (humidity > 60 && humidity <= 80) {
                    message = "💦 High humidity — monitor for mold and fungus!";
                    color = "info";
                } else {
                    message = "🌧 Too humid! Air circulation needed!";
                    color = "danger";
                }

                showAdvice(message, color);
            }

            function showAdvice(message, color) {
                $("#adviceBox")
                    .removeClass()
                    .addClass(`advice-box bg-${color} text-white shadow-sm`)
                    .html(message);
            }

            $("#refreshBtn").click(function (e) {
                e.preventDefault();
                fetchHumidityData();
            });

            fetchHumidityData();
        </script>
    </form>
</body>
</html>
