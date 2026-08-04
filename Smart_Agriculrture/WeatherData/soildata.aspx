<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="soildata.aspx.cs" Inherits="Smart_Agriculrture.WeatherData.soildata" %>

<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <meta charset="utf-8" />
    <title>🌱 Soil Moisture Insights - Smart Agriculture</title>

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

        #soilChart {
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

            <h2 class="text-center mb-4">🌱 Soil Moisture Data Visualization</h2>

            <!-- Trend Chart -->
            <div class="card shadow-sm p-4 mb-3">
                <canvas id="soilChart"></canvas>
            </div>

            <!-- Donut + Info -->
            <div class="row g-3 mb-3">
                <div class="col-md-6 col-12">
                    <div class="card shadow-sm p-3 text-center">
                        <h5>💧 Current Soil Condition</h5>
                        <canvas id="donutChart"></canvas>
                    </div>
                </div>
                <div class="col-md-6 col-12">
                    <div id="adviceBox" class="advice-box bg-light text-secondary">
                        Fetching soil moisture insights...
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
            const apiUrl = "https://api.thingspeak.com/channels/3229994/feeds.json?api_key=W7LGD7SPBJ7YOB5O";
            let soilChart = null;
            let donutChart = null;

            function fetchSoilData() {
                $("#refreshBtn").html(`<span class='spinner-border spinner-border-sm'></span> Loading...`);

                $.get(apiUrl, function (data) {
                    const feeds = data.feeds || [];

                    const validData = feeds
                        .filter(f => f.field3 && parseFloat(f.field3) > 0)
                        .map(f => ({
                            time: new Date(f.created_at).toLocaleString(),
                            soil: parseFloat(f.field3)
                        }));

                    if (validData.length === 0) {
                        showAdvice("No valid soil data found.", "secondary");
                        $("#refreshBtn").html("🔄 Refresh Data");
                        return;
                    }

                    const labels = validData.map(v => v.time);
                    const soils = validData.map(v => v.soil);

                    renderSoilChart(labels, soils);

                    const latestSoil = soils[soils.length - 1];
                    renderDonutChart(latestSoil);
                    updateAdvice(latestSoil);

                    $("#refreshBtn").html("🔄 Refresh Data");
                });
            }

            // Soil Moisture Line Chart
            function renderSoilChart(labels, soils) {
                const ctx = document.getElementById("soilChart").getContext("2d");
                if (soilChart) soilChart.destroy();

                const gradient = ctx.createLinearGradient(0, 0, 0, 400);
                gradient.addColorStop(0, "rgba(40, 167, 69, 0.4)");
                gradient.addColorStop(1, "rgba(255, 255, 255, 0)");

                soilChart = new Chart(ctx, {
                    type: "line",
                    data: {
                        labels: labels,
                        datasets: [{
                            label: "Soil Moisture Level",
                            data: soils,
                            borderColor: "#198754",
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
                                    label: context => `${context.parsed.y}`
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

            // Donut Chart for current soil status
            function renderDonutChart(value) {
                const ctx = document.getElementById("donutChart").getContext("2d");
                if (donutChart) donutChart.destroy();

                const percent = Math.min(100, Math.max(0, ((1023 - value) / 1023) * 100));

                donutChart = new Chart(ctx, {
                    type: "doughnut",
                    data: {
                        labels: ["Moisture %", "Dry %"],
                        datasets: [{
                            data: [percent, 100 - percent],
                            backgroundColor: ["#198754", "#dee2e6"],
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
                                text: `${percent.toFixed(1)}% Moisture`,
                                position: "center",
                                color: "#198754"
                            }
                        }
                    }
                });
            }

            // Advice logic
            function updateAdvice(value) {
                let message = "";
                let color = "";

                if (value > 800) {
                    message = "🌾 Soil is dry — activate irrigation!";
                    color = "danger";
                } else if (value >= 300 && value <= 800) {
                    message = "🌿 Soil moisture is moderate — good for crops.";
                    color = "success";
                } else {
                    message = "💧 Soil is well-watered — no irrigation needed.";
                    color = "info";
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
                fetchSoilData();
            });

            fetchSoilData();
        </script>
    </form>
</body>
</html>
