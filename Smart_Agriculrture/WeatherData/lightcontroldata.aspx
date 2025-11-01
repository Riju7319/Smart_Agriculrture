<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="lightcontroldata.aspx.cs" Inherits="Smart_Agriculrture.WeatherData.lightcontroldata" %>

<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <meta charset="utf-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1" />
    <title>💡 Light Usage Analytics</title>

    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet" />
    <script src="https://cdn.jsdelivr.net/npm/jquery@3.6.4/dist/jquery.min.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
    <script src="https://cdn.datatables.net/1.13.6/js/jquery.dataTables.min.js"></script>
    <link href="https://cdn.datatables.net/1.13.6/css/jquery.dataTables.min.css" rel="stylesheet" />

    <style>
        body { background-color: #f8f9fa; }
        .card { border-radius: 12px; border: 1px solid #dee2e6; }
        .chart-container { height: 350px; }
        .summary-box {
            background-color: #fff7e6;
            border-radius: 10px;
            padding: 15px;
            margin-top: 15px;
        }
        table.dataTable tbody tr:hover {
            background-color: #f1f1f1;
        }
    </style>
</head>
<body>
<form id="form1" runat="server" class="container py-4">
    <h3 class="text-center mb-4">💡 Light Usage Analytics</h3>

    <!-- Usage Table -->
<div class="card p-4 ">
    <h5 class="text-center mb-3">📅 Daily Light Usage (Hours)</h5>
    <div class="table-responsive">
        <table id="usageTable" class="display table table-striped" style="width:100%">
            <thead>
                <tr>
                    <th>Date</th>
                    <th>Total Hours (ON)</th>
                </tr>
            </thead>
            <tbody></tbody>
        </table>
    </div>
</div>

    <!-- Filter Section -->
    <div class="card p-3 mb-4 mt-4">
        <div class="row g-3 align-items-end">
            <div class="col-md-3">
                <label class="form-label">Select Range</label>
                <select id="rangeSelect" class="form-select">
                    <option value="1">Today</option>
                    <option value="7">Last 7 Days</option>
                    <option value="30">Last 30 Days</option>
                    <option value="60">Last 2 Months</option>
                    <option value="90">Last 3 Months</option>
                    <option value="365">This Year</option>
                    <option value="all" selected>All Time</option>
                </select>
            </div>

            <div class="col-md-3">
                <label class="form-label">Light Wattage (W)</label>
                <input type="number" id="wattInput" class="form-control" value="60" />
            </div>

            <div class="col-md-3">
                <label class="form-label">Cost per Unit (₹)</label>
                <input type="number" id="unitCost" class="form-control" value="8" />
            </div>

            <div class="col-md-3">
                <button id="analyzeBtn" class="btn btn-warning w-100">Analyze</button>
            </div>
        </div>
    </div>

    <!-- Chart -->
    <div class="card p-4 mb-4">
        <h5 class="text-center">Light ON/OFF Timeline</h5>
        <div class="chart-container">
            <canvas id="lightChart"></canvas>
        </div>
    </div>

    <!-- Summary -->
    <div class="summary-box">
        <h6>Summary Report</h6>
        <p id="summaryText">No data analyzed yet.</p>
    </div>

    

    <!-- Back Button -->
    <div class="text-center mt-4">
        <a href="ViewSensoreData.aspx" class="btn btn-outline-secondary">⬅ Back to Dashboard</a>
    </div>

<script>
    const apiUrl = "https://api.thingspeak.com/channels/3137414/feeds.json?api_key=O24VY64WB8H3Y2XT";
    let lightChart = null;

    $(document).ready(function () {
        $("#analyzeBtn").click(function (e) {
            e.preventDefault();
            fetchAndAnalyze();
        });

        // Auto-load all-time data
        fetchAndAnalyze();
    });

    async function fetchAndAnalyze() {
        const range = $("#rangeSelect").val();
        const watt = parseFloat($("#wattInput").val()) || 60;
        const costPerUnit = parseFloat($("#unitCost").val()) || 8;

        $("#summaryText").html("⏳ Fetching and analyzing data...");

        try {
            const res = await fetch(apiUrl);
            const data = await res.json();
            let feeds = data.feeds || [];

            if (range !== "all") {
                const days = parseInt(range);
                const cutoff = new Date();
                cutoff.setDate(cutoff.getDate() - days);
                feeds = feeds.filter(f => new Date(f.created_at) >= cutoff);
            }

            const timeline = feeds
                .filter(f => f.field7 !== null)
                .map(f => ({
                    time: new Date(f.created_at),
                    state: f.field7 === "1" ? 1 : 0
                }));

            if (timeline.length === 0) {
                $("#summaryText").html("⚠ No valid light data found.");
                return;
            }

            // Calculate daily usage hours
            let dailyUsage = {};
            let lastOn = null;

            for (let i = 0; i < timeline.length; i++) {
                const entry = timeline[i];
                const dateKey = entry.time.toISOString().split("T")[0];

                if (entry.state === 1 && lastOn === null) {
                    lastOn = entry.time;
                } else if (entry.state === 0 && lastOn) {
                    const durationHrs = (entry.time - lastOn) / (1000 * 60 * 60);
                    dailyUsage[dateKey] = (dailyUsage[dateKey] || 0) + durationHrs;
                    lastOn = null;
                }
            }

            // Calculate totals
            const totalHours = Object.values(dailyUsage).reduce((a, b) => a + b, 0).toFixed(2);
            const kWhUsed = ((watt * totalHours) / 1000).toFixed(2);
            const totalCost = (kWhUsed * costPerUnit).toFixed(2);

            renderLightChart(timeline);
            renderUsageTable(dailyUsage);

            $("#summaryText").html(`
                ✅ <b>Total Light Runtime:</b> ${totalHours} hours<br/>
                ⚡ <b>Power Used:</b> ${kWhUsed} kWh<br/>
                💰 <b>Total Cost:</b> ₹${totalCost}
            `);
        } catch (err) {
            console.error(err);
            $("#summaryText").html("❌ Error fetching data.");
        }
    }

    function renderLightChart(timeline) {
        const ctx = document.getElementById("lightChart").getContext("2d");
        if (lightChart) lightChart.destroy();

        const labels = timeline.map(t => t.time.toLocaleString());
        const states = timeline.map(t => t.state);

        lightChart = new Chart(ctx, {
            type: "line",
            data: {
                labels,
                datasets: [{
                    label: "Light Status (1=ON, 0=OFF)",
                    data: states,
                    borderColor: "#ffc107",
                    backgroundColor: "rgba(255,193,7,0.2)",
                    fill: true,
                    tension: 0.3,
                    borderWidth: 2,
                    pointRadius: 2
                }]
            },
            options: {
                responsive: true,
                scales: {
                    y: {
                        beginAtZero: true,
                        ticks: { callback: v => v === 1 ? "ON" : "OFF" }
                    },
                    x: { ticks: { autoSkip: true, maxTicksLimit: 10 } }
                },
                plugins: { legend: { display: false } }
            }
        });
    }

    function renderUsageTable(dailyUsage) {
        const table = $("#usageTable").DataTable();
        table.clear();

        Object.entries(dailyUsage).forEach(([date, hours]) => {
            table.row.add([date, hours.toFixed(2)]);
        });

        table.draw();
    }

    // Initialize empty DataTable on load
    $(document).ready(() => {
        $("#usageTable").DataTable({
            paging: true,
            searching: true,
            ordering: true
        });
    });
</script>
</form>
</body>
</html>
