<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="lightdata.aspx.cs" Inherits="Smart_Agriculrture.WeatherData.lightdata" %>

<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <meta charset="utf-8" />
    <title>☀ Light Intensity Insights - Smart Agriculture</title>

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

        #lightChart {
            height: 320px !important;
        }

        #donutChart {
            max-height: 240px;
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

            <!-- Back Button -->
            <button type="button" class="btn btn-outline-secondary btn-back" onclick="window.location.href='ViewSensoreData.aspx'">
                ⬅ Back
            </button>

            <h2 class="text-center mb-4">☀ Light Intensity Data Visualization</h2>

            <!-- Line Chart -->
            <div class="card shadow-sm p-4 mb-3">
                <canvas id="lightChart"></canvas>
            </div>

            <!-- Donut + Info -->
            <div class="row g-3 mb-3">
                <div class="col-md-6 col-12">
                    <div class="card shadow-sm p-3 text-center">
                        <h5>🌤 Current Light Level</h5>
                        <canvas id="donutChart"></canvas>
                    </div>
                </div>
                <div class="col-md-6 col-12">
                    <div id="adviceBox" class="advice-box bg-light text-secondary">
                        Fetching light intensity insights...
                    </div>
                </div>
            </div>

            <!-- Refresh Button -->
            <div class="text-center mt-3">
                <button id="refreshBtn" class="btn btn-primary">
                    🔄 Refresh Data
                </button>
            </div>

        </div>

        <script>
            const apiUrl = "https://api.thingspeak.com/channels/3137414/feeds.json?api_key=O24VY64WB8H3Y2XT";
            let lightChart = null;
            let donutChart = null;

            function fetchLightData() {
                $("#refreshBtn").html(`<span class='spinner-border spinner-border-sm'></span> Loading...`);

                $.get(apiUrl, function (data) {
                    const feeds = data.feeds || [];

                    const validData = feeds
                        .filter(f => f.field4 && parseFloat(f.field4) >= 0)
                        .map(f => ({
                            time: new Date(f.created_at).toLocaleString(),
                            light: parseFloat(f.field4)
                        }));

                    if (validData.length === 0) {
                        showAdvice("No valid light data found.", "secondary");
                        $("#refreshBtn").html("🔄 Refresh Data");
                        return;
                    }

                    const labels = validData.map(v => v.time);
                    const lights = validData.map(v => v.light);

                    renderLightChart(labels, lights);

                    const latestLight = lights[lights.length - 1];
                    renderDonutChart(latestLight);
                    updateAdvice(latestLight);

                    $("#refreshBtn").html("🔄 Refresh Data");
                });
            }

            // Light Intensity Line Chart
            function renderLightChart(labels, lights) {
                const ctx = document.getElementById("lightChart").getContext("2d");
                if (lightChart) lightChart.destroy();

                const gradient = ctx.createLinearGradient(0, 0, 0, 400);
                gradient.addColorStop(0, "rgba(255, 193, 7, 0.4)");
                gradient.addColorStop(1, "rgba(255, 255, 255, 0)");

                lightChart = new Chart(ctx, {
                    type: "line",
                    data: {
                        labels: labels,
                        datasets: [{
                            label: "Light Intensity (LUX)",
                            data: lights,
                            borderColor: "#ffc107",
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
                                    label: context => `${context.parsed.y} LUX`
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

            // Donut Chart for light percentage
            function renderDonutChart(value) {
                const ctx = document.getElementById("donutChart").getContext("2d");
                if (donutChart) donutChart.destroy();

                const percent = Math.min(100, Math.max(0, (value / 1023) * 100));

                donutChart = new Chart(ctx, {
                    type: "doughnut",
                    data: {
                        labels: ["Light %", "Dark %"],
                        datasets: [{
                            data: [percent, 100 - percent],
                            backgroundColor: ["#ffc107", "#dee2e6"],
                            borderWidth: 1
                        }]
                    },
                    options: {
                        cutout: "70%",
                        plugins: {
                            tooltip: { enabled: false },
                            legend: { display: false },
                            title: {
                                display: true,
                                text: `${percent.toFixed(1)}% Light`,
                                position: "center",
                                color: "#ffc107"
                            }
                        }
                    }
                });
            }

            // Light advice based on value
            function updateAdvice(value) {
                let message = "";
                let color = "";

                if (value < 200) {
                    message = "🌙 It's quite dark — possibly night time.";
                    color = "secondary";
                } else if (value >= 200 && value < 600) {
                    message = "🌥 Moderate light — cloudy or indoor condition.";
                    color = "info";
                } else if (value >= 600 && value < 900) {
                    message = "☀ Bright daylight — perfect for photosynthesis!";
                    color = "success";
                } else {
                    message = "🔥 Very intense light — consider shading plants!";
                    color = "warning";
                }

                showAdvice(message, color);
            }

            // Update advice UI
            function showAdvice(message, color) {
                $("#adviceBox")
                    .removeClass()
                    .addClass(`advice-box bg-${color} text-white shadow-sm`)
                    .html(message);
            }

            // Refresh event
            $("#refreshBtn").click(function (e) {
                e.preventDefault();
                fetchLightData();
            });

            // Initial load
            fetchLightData();
        </script>
    </form>
</body>
</html>
