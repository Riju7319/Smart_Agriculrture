<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="temperaturedata.aspx.cs" Inherits="Smart_Agriculrture.WeatherData.temperaturedata" %>

<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <meta charset="utf-8" />
    <title>🌡 Temperature Insights - Smart Agriculture</title>

    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet" />
    <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/jquery@3.6.4/dist/jquery.min.js"></script>

    <style>
        body {
            background: #f7f9fc;
            font-family: "Segoe UI", sans-serif;
        }

        .container {
            max-width: 900px;
        }

        .card {
            border-radius: 14px;
            border: 1px solid #dee2e6;
            box-shadow: 0 4px 10px rgba(0, 0, 0, 0.05);
        }

        #tempChart {
            height: 360px !important;
        }

        .advice-box {
            padding: 15px;
            border-radius: 10px;
            margin-top: 20px;
            font-weight: 500;
            text-align: center;
            transition: all 0.3s ease;
        }

        .btn {
            border-radius: 8px;
        }

        .fade-in {
            animation: fadeIn 0.6s ease-in;
        }

        @keyframes fadeIn {
            from { opacity: 0; transform: translateY(10px); }
            to { opacity: 1; transform: translateY(0); }
        }

        /* Toast notification */
        .toast-container {
            position: fixed;
            top: 20px;
            right: 20px;
            z-index: 1050;
        }

        @media (max-width: 600px) {
            h2 {
                font-size: 1.4rem;
            }

            .card {
                padding: 1rem !important;
            }
        }
    </style>
</head>
<body>
    <form id="form1" runat="server">
        <div class="container mt-4 fade-in">
            <div class="d-flex justify-content-between align-items-center mb-3">
                <h2 class="mb-0 text-primary">🌡 Temperature Data</h2>
                <button type="button" class="btn btn-outline-secondary btn-sm" onclick="goBack()">
                    ⬅ Back
                </button>
            </div>

            <div class="card shadow-sm p-4 mb-3">
                <canvas id="tempChart"></canvas>
            </div>

            <!-- Advice Box -->
            <div id="adviceBox" class="advice-box bg-light text-secondary">
                Fetching temperature insights...
            </div>

            <!-- Manual refresh -->
            <div class="text-center mt-3">
                <button id="refreshBtn" class="btn btn-primary px-4">
                    🔄 Refresh Data
                </button>
            </div>
        </div>

        <!-- Toast notification -->
        <div class="toast-container">
            <div id="alertToast" class="toast align-items-center text-bg-danger border-0" role="alert" aria-live="assertive" aria-atomic="true">
                <div class="d-flex">
                    <div class="toast-body" id="toastMessage">⚠ High temperature detected!</div>
                    <button type="button" class="btn-close btn-close-white me-2 m-auto" data-bs-dismiss="toast"></button>
                </div>
            </div>
        </div>

        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>

        <script>
            const apiUrl = "https://api.thingspeak.com/channels/3229994/feeds.json?api_key=W7LGD7SPBJ7YOB5O";
            let tempChart = null;

            function goBack() {
                window.location.href = "ViewSensoreData.aspx"; // redirect to dashboard
            }

            // Fetch and render temperature data
            function fetchTemperatureData() {
                $("#refreshBtn").html(`<span class='spinner-border spinner-border-sm'></span> Loading...`);

                $.get(apiUrl, function (data) {
                    const feeds = data.feeds || [];

                    const validData = feeds
                        .filter(f => f.field1 && parseFloat(f.field1) > 0)
                        .map(f => ({
                            time: new Date(f.created_at).toLocaleString(),
                            temp: parseFloat(f.field1)
                        }));

                    if (validData.length === 0) {
                        showAdvice("No valid temperature data found.", "secondary");
                        $("#refreshBtn").html("🔄 Refresh Data");
                        return;
                    }

                    const labels = validData.map(v => v.time);
                    const temps = validData.map(v => v.temp);

                    renderTemperatureChart(labels, temps);
                    const latestTemp = temps[temps.length - 1];
                    updateAdvice(latestTemp);
                    checkAbnormalTemperature(latestTemp);

                    $("#refreshBtn").html("🔄 Refresh Data");
                }).fail(() => {
                    showAdvice("Failed to fetch data. Check your connection.", "danger");
                    $("#refreshBtn").html("🔄 Refresh Data");
                });
            }

            // Render Chart.js
            function renderTemperatureChart(labels, temps) {
                const ctx = document.getElementById("tempChart").getContext("2d");
                if (tempChart) tempChart.destroy();

                tempChart = new Chart(ctx, {
                    type: "line",
                    data: {
                        labels: labels,
                        datasets: [{
                            label: "Temperature (°C)",
                            data: temps,
                            borderColor: "#007bff",
                            backgroundColor: "rgba(0,123,255,0.1)",
                            tension: 0.3,
                            fill: true,
                            pointRadius: 3,
                            borderWidth: 2
                        }]
                    },
                    options: {
                        responsive: true,
                        plugins: {
                            legend: { display: true },
                            tooltip: {
                                callbacks: {
                                    label: (context) => `${context.parsed.y} °C`
                                }
                            }
                        },
                        scales: {
                            x: { ticks: { color: "#6c757d", maxTicksLimit: 6 } },
                            y: { ticks: { color: "#6c757d" } }
                        }
                    }
                });
            }

            // Advice logic
            function updateAdvice(temp) {
                let message = "";
                let color = "";

                if (temp < 15) {
                    message = "🌬 It's quite cold — plants may need warmth!";
                    color = "info";
                } else if (temp >= 15 && temp <= 30) {
                    message = "🌿 Perfect temperature for healthy plant growth!";
                    color = "success";
                } else if (temp > 30 && temp <= 40) {
                    message = "☀ It's getting warm — ensure enough water supply!";
                    color = "warning";
                } else {
                    message = "🔥 Too hot! Risk of dehydration for crops!";
                    color = "danger";
                }

                showAdvice(message, color);
            }

            function showAdvice(message, color) {
                $("#adviceBox").removeClass().addClass(`advice-box bg-${color} text-white`).html(message);
            }

            // Alert for abnormal data
            function checkAbnormalTemperature(temp) {
                if (temp > 38 || temp < 10) {
                    showToast("⚠ Extreme temperature detected! Take precaution.");
                }
            }

            // Show Bootstrap toast
            function showToast(message) {
                $("#toastMessage").text(message);
                const toastEl = new bootstrap.Toast(document.getElementById("alertToast"));
                toastEl.show();
            }

            $("#refreshBtn").click(function (e) {
                e.preventDefault();
                fetchTemperatureData();
            });

            // Initial load
            fetchTemperatureData();
        </script>
    </form>
</body>
</html>
