<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="ViewSensoreData.aspx.cs" Inherits="Smart_Agriculrture.WeatherData.ViewSensoreData" %>

<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <meta name="viewport" content="width=device-width, initial-scale=1" />
    <title>Smart Agriculture Dashboard</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet" />
    <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>

    <style>
        body { background-color: #f8f9fa; font-family: 'Segoe UI', sans-serif; }
        .card { border: 1px solid #e2e6ea; border-radius: 12px; box-shadow: 0 2px 6px rgba(0,0,0,0.05); transition: transform 0.2s ease-in-out; }
        .card:hover { transform: translateY(-3px); }
        .status-card { text-align: center; color: white; padding: 15px; font-weight: 500; border-radius: 10px; cursor: pointer; }
        .status-on { background-color: #28a745; }
        .status-off { background-color: #dc3545; }
        .alert-card { border-left: 5px solid #dc3545; background-color: #fff3f3; }
        .sensor-card { cursor: pointer; transition: transform 0.2s ease, box-shadow 0.2s ease; border: 1px solid #e5e7eb; border-radius: 12px; }
        .sensor-card:hover { transform: translateY(-3px); box-shadow: 0 4px 10px rgba(0, 0, 0, 0.1); border-color: #007bff; }
        .chart-container { background: #ffffff; border: 1px solid #dee2e6; border-radius: 10px; padding: 15px; box-shadow: 0 2px 6px rgba(0,0,0,0.05); }
        canvas { width: 100% !important; height: 220px !important; }
        @media (max-width: 768px) { .card { margin-bottom: 15px; } }
    </style>
</head>
<body>
    <form id="form1" runat="server" class="container py-4">
        <h3 class="text-center mb-4">🌿 Smart Agriculture Live Dashboard</h3>

        <!-- Board Status -->
    <div class="card p-3 mb-3 d-flex flex-row justify-content-between align-items-center"
         style="cursor: pointer; background-color: #f1f3f5; border-radius: 10px; transition: transform 0.2s ease;"
         onclick="onStatusCardClick('status')"
         onmouseover="this.style.transform='scale(1.02)'"
         onmouseout="this.style.transform='scale(1)'">
        <h5 class="mb-0">⚙️ Checking the board status - </h5>
        <span id="boardStatus" class="badge bg-secondary fs-6 px-3 py-2">Checking...</span>
    </div>


        <!-- Control Buttons -->
        <div class="d-flex justify-content-center align-items-center mb-3 gap-2">
            <button id="refreshBtn" class="btn btn-primary" type="button" onclick="fetchData(false)">
                <span id="refreshIcon" class="spinner-border spinner-border-sm d-none"></span> Manual Refresh
            </button>
            <!-- RENAMED ID to avoid collision with function name -->
            <button id="toggleAutoBtn" class="btn btn-outline-secondary" type="button" onclick="toggleAuto()">
                Enable Auto Refresh
            </button>
        </div>

        <!-- Sensor Cards -->
        <div class="row g-3 mb-4">
            <div class="col-md-3 col-6">
                <div class="card text-center p-3 bg-light sensor-card" onclick="onCardClick('Temperature')">
                    <h6>🌡 Temperature</h6><h4 id="tempVal">-- °C</h4>
                </div>
            </div>
            <div class="col-md-3 col-6">
                <div class="card text-center p-3 bg-light sensor-card" onclick="onCardClick('Humidity')">
                    <h6>💧 Humidity</h6><h4 id="humidVal">-- %</h4>
                </div>
            </div>
            <div class="col-md-3 col-6">
                <div class="card text-center p-3 bg-light sensor-card" onclick="onCardClick('Soil Moisture')">
                    <h6>🌱 Soil Moisture</h6><h4 id="soilVal">--</h4>
                </div>
            </div>
            <div class="col-md-3 col-6">
                <div class="card text-center p-3 bg-light sensor-card" onclick="onCardClick('Light Intensity')">
                    <h6>☀ Light Intensity</h6><h4 id="lightVal">--</h4>
                </div>
            </div>
        </div>

        <!-- Gas Alert -->
        <div id="gasAlert" class="alert alert-card d-none text-center fw-semibold">
            ⚠️ Bad Gas Detected! Please Check the Environment.
        </div>

        <!-- Pump and Light Status -->
        <div class="row text-center mb-4">
            <div class="col-md-6 col-12">
                <div id="pumpStatus" class="status-card status-off" onclick="onStatusCardClick('Pump')">
                    💧 Pump: OFF
                </div>
            </div>
            <div class="col-md-6 col-12 mt-md-0 mt-3">
                <div id="lightStatus" class="status-card status-off" onclick="onStatusCardClick('Light')">
                    💡 Light: OFF
                </div>
            </div>
        </div>

        <!-- Live Graphs -->
        <div class="card mb-4 p-4">
            <h5 class="text-center mb-4">📈 Live Sensor Data Trends</h5>
            <div class="row g-4">
                <div class="col-md-6"><h6 class="text-center text-secondary mb-2">🌡 Temperature</h6><div class="chart-container"><canvas id="tempChart"></canvas></div></div>
                <div class="col-md-6"><h6 class="text-center text-secondary mb-2">💧 Humidity</h6><div class="chart-container"><canvas id="humidChart"></canvas></div></div>
                <div class="col-md-6"><h6 class="text-center text-secondary mb-2">🌱 Soil Moisture</h6><div class="chart-container"><canvas id="soilChart"></canvas></div></div>
                <div class="col-md-6"><h6 class="text-center text-secondary mb-2">☀ Light Intensity</h6><div class="chart-container"><canvas id="lightChart"></canvas></div></div>
            </div>
        </div>

        <!-- Data Table -->
        <div class="card p-3">
            <div class="d-flex justify-content-between align-items-center mb-2 flex-wrap gap-2">
                <div>Show 
                    <select id="recordsPerPage" class="form-select d-inline w-auto" onchange="renderTable(currentPage)">
                        <option>5</option><option selected>10</option><option>20</option>
                    </select> entries
                </div>
                <div class="input-group w-auto">
                    <input id="searchBox" type="text" class="form-control" placeholder="Search..." onkeyup="renderTable(1)" />
                </div>
            </div>
            <div class="table-responsive">
                <table class="table table-striped table-bordered align-middle text-center">
                    <thead class="table-light">
                        <tr><th>Time</th><th>Temperature (°C)</th><th>Humidity (%)</th><th>Soil</th><th>Light</th><th>Gas</th></tr>
                    </thead>
                    <tbody id="dataBody"></tbody>
                </table>
            </div>
            <div class="d-flex justify-content-between">
                <span id="recordInfo"></span>
                <nav><ul id="pagination" class="pagination pagination-sm mb-0"></ul></nav>
            </div>
        </div>
    </form>

    <script>
        const apiUrl = "https://api.thingspeak.com/channels/3137414/feeds.json?api_key=O24VY64WB8H3Y2XT";
        let allData = [];
        let autoUpdate = false;
        let autoInterval;
        let currentPage = 1;

        function toggleAuto() {
            autoUpdate = !autoUpdate;
            const btn = document.getElementById("toggleAutoBtn");

            clearInterval(autoInterval); // Clear any existing interval

            if (autoUpdate) {
                btn.textContent = "Disable Auto Refresh";
                btn.classList.replace("btn-outline-secondary", "btn-success");
                fetchData(true); // Fetch immediately
                autoInterval = setInterval(() => fetchData(true), 60000);
            } else {
                btn.textContent = "Enable Auto Refresh";
                btn.classList.replace("btn-success", "btn-outline-secondary");
            }
        }

        async function fetchData(auto = false) {
            const refreshIcon = document.getElementById("refreshIcon");
            if (!auto) refreshIcon.classList.remove("d-none");

            try {
                const res = await fetch(apiUrl + "&results=20");
                const data = await res.json();
                if (!data.feeds || data.feeds.length === 0) return;

                allData = data.feeds.reverse();
                updateCards(allData[0]);
                rengerLive(allData[0]);
                renderCharts(allData.slice(0, 15));
                renderTable(currentPage);
                console.log("✅ Refreshed at", new Date().toLocaleTimeString());
            } catch (err) {
                console.error("Error fetching:", err);
            }
            if (!auto) refreshIcon.classList.add("d-none");
        }

        function updateCards(latest) {
            const temp = parseFloat(latest.field1) || 0;
            const humid = parseFloat(latest.field2) || 0;
            const soil = parseFloat(latest.field3) || 0;
            const light = parseFloat(latest.field4) || 0;
            const gas = parseFloat(latest.field5) || 0;

            document.getElementById("tempVal").innerText = `${temp} °C`;
            document.getElementById("humidVal").innerText = `${humid} %`;

            document.getElementById("soilVal").innerText = soil > 800 ? "Dry (Low Moisture)" : soil > 300 ? "Moist (Good)" : "Wet";
            document.getElementById("lightVal").innerText = light > 600 ? "Dark" : light > 300 ? "Normal Light" : "Bright";

            const gasAlert = document.getElementById("gasAlert");
            if (gas > 400) gasAlert.classList.remove("d-none"); else gasAlert.classList.add("d-none");

            const pump = latest.field6 === "1";
            const lightSt = latest.field7 === "1";

            const pumpCard = document.getElementById("pumpStatus");
            pumpCard.textContent = pump ? "💧 Pump: ON" : "💧 Pump: OFF";
            pumpCard.className = pump ? "status-card status-on" : "status-card status-off";

            const lightCard = document.getElementById("lightStatus");
            lightCard.textContent = lightSt ? "💡 Light: ON" : "💡 Light: OFF";
            lightCard.className = lightSt ? "status-card status-on" : "status-card status-off";
        }

        function renderTable(page = 1) {
            currentPage = page;
            const search = document.getElementById("searchBox").value.toLowerCase();
            const perPage = parseInt(document.getElementById("recordsPerPage").value);

            let filtered = allData.filter(f =>
                (f.field1 ?? "").toString().toLowerCase().includes(search) ||
                (f.field2 ?? "").toString().toLowerCase().includes(search)
            );

            const start = (page - 1) * perPage;
            const end = start + perPage;
            const paginated = filtered.slice(start, end);

            const tbody = document.getElementById("dataBody");
            tbody.innerHTML = paginated.map(f => `
                <tr>
                    <td>${new Date(f.created_at).toLocaleString()}</td>
                    <td>${f.field1 ?? "--"}</td>
                    <td>${f.field2 ?? "--"}</td>
                    <td>${(f.field3 > 800) ? "Dry" : (f.field3 > 300 ? "Moist" : "Wet")}</td>
                    <td>${(f.field4 > 600) ? "Dark" : (f.field4 > 300 ? "Normal" : "Bright")}</td>
                    <td>${(f.field5 > 400) ? "⚠ Bad Gas" : "OK"}</td>
                </tr>
            `).join("");

            document.getElementById("recordInfo").innerText =
                `Showing ${filtered.length === 0 ? 0 : start + 1}-${Math.min(end, filtered.length)} of ${filtered.length}`;
            renderPagination(filtered.length, perPage);
        }

        function renderPagination(total, perPage) {
            const totalPages = Math.ceil(total / perPage) || 1;
            const pagination = document.getElementById("pagination");
            pagination.innerHTML = "";
            for (let i = 1; i <= totalPages; i++) {
                pagination.innerHTML += `<li class="page-item ${i === currentPage ? "active" : ""}">
                    <button class="page-link" onclick="renderTable(${i})">${i}</button>
                </li>`;
            }
        }

        function onCardClick(sensorType) {
            const pageMap = {
                "Temperature": "temperaturedata.aspx",
                "Humidity": "humiditydata.aspx",
                "Soil Moisture": "soildata.aspx",
                "Light Intensity": "lightdata.aspx"
            };
            const targetPage = pageMap[sensorType];
            if (targetPage) window.location.href = targetPage; else alert("Page for " + sensorType + " not found!");
        }

        function onStatusCardClick(type) {
            const pageMap = { "Pump": "pumpdata.aspx", "status": "DeviceStatus.aspx", "Light": "lightcontroldata.aspx" };
            const targetPage = pageMap[type];
            if (targetPage) window.location.href = targetPage;
        }

        function renderCharts(feeds) {
            const labels = feeds.map(f => new Date(f.created_at).toLocaleTimeString());
            const temps = feeds.map(f => parseFloat(f.field1) || 0);
            const humids = feeds.map(f => parseFloat(f.field2) || 0);
            const soils = feeds.map(f => parseFloat(f.field3) || 0);
            const lights = feeds.map(f => parseFloat(f.field4) || 0);

            function makeChart(ctx, label, data, color) {
                if (ctx.chartInstance) ctx.chartInstance.destroy();
                ctx.chartInstance = new Chart(ctx, {
                    type: 'line',
                    data: { labels, datasets: [{ label, data, borderColor: color, backgroundColor: color + '33', fill: true, tension: 0.3, borderWidth: 2, pointRadius: 0 }] },
                    options: { responsive: true, plugins: { legend: { display: false } }, scales: { x: { display: false }, y: { ticks: { color: '#6c757d' }, beginAtZero: true } } }
                });
            }

            makeChart(document.getElementById('tempChart').getContext('2d'), 'Temperature (°C)', temps, '#007bff');
            makeChart(document.getElementById('humidChart').getContext('2d'), 'Humidity (%)', humids, '#28a745');
            makeChart(document.getElementById('soilChart').getContext('2d'), 'Soil Moisture', soils, '#8B4513');
            makeChart(document.getElementById('lightChart').getContext('2d'), 'Light Intensity', lights, '#ffc107');
        }

        function rengerLive(latestFeed) {
            const lastTime = new Date(latestFeed.created_at);
            const now = new Date();
            const diffMinutes = (now - lastTime) / 60000;
            const boardStatus = document.getElementById("boardStatus");
            if (diffMinutes <= 1) {
                boardStatus.textContent = "🟢 Board Live";
                boardStatus.className = "badge bg-success fs-6 px-3 py-2";
            } else {
                boardStatus.textContent = "🔴 Board Offline";
                boardStatus.className = "badge bg-danger fs-6 px-3 py-2";
            }
        }

        // initial fetch
        fetchData();
    </script>
</body>
</html>
