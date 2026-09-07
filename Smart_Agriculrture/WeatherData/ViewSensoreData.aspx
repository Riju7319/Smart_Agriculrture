<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="ViewSensoreData.aspx.cs"
    Inherits="Smart_Agriculrture.WeatherData.ViewSensoreData" ResponseEncoding="utf-8"%>

<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml">

<head runat="server">
    <meta name="viewport" content="width=device-width, initial-scale=1" />
    <title>Smart Agriculture Dashboard</title>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700&display=swap" rel="stylesheet" />
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet" />
    <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>

    <style>
        * { box-sizing: border-box; margin: 0; padding: 0; }

        body {
            font-family: 'Inter', 'Segoe UI', sans-serif;
            background: #f0f2f5;
            overflow-x: hidden;
        }

        /* ===== SIDEBAR ===== */
        .sidebar {
            position: fixed;
            top: 0;
            left: 0;
            width: 260px;
            height: 100vh;
            background: linear-gradient(180deg, #0f172a 0%, #1e293b 100%);
            color: #cbd5e1;
            padding: 0;
            z-index: 1000;
            transition: transform 0.3s cubic-bezier(0.4, 0, 0.2, 1);
            display: flex;
            flex-direction: column;
            box-shadow: 4px 0 20px rgba(0, 0, 0, 0.15);
        }

        .sidebar-brand {
            padding: 24px 20px 20px;
            border-bottom: 1px solid rgba(255,255,255,0.08);
            text-align: center;
        }

        .sidebar-brand .brand-icon {
            font-size: 32px;
            display: block;
            margin-bottom: 6px;
        }

        .sidebar-brand h4 {
            color: #f8fafc;
            font-size: 16px;
            font-weight: 700;
            margin: 0;
            letter-spacing: 0.3px;
        }

        .sidebar-brand small {
            color: #64748b;
            font-size: 11px;
            font-weight: 500;
            text-transform: uppercase;
            letter-spacing: 1px;
        }

        .sidebar-nav {
            flex: 1;
            overflow-y: auto;
            padding: 16px 0;
        }

        .nav-section {
            padding: 0 16px;
            margin-bottom: 6px;
        }

        .nav-section-title {
            font-size: 10px;
            font-weight: 700;
            text-transform: uppercase;
            letter-spacing: 1.5px;
            color: #475569;
            padding: 12px 12px 6px;
        }

        .nav-item {
            display: flex;
            align-items: center;
            gap: 12px;
            padding: 11px 16px;
            color: #94a3b8;
            text-decoration: none;
            border-radius: 10px;
            margin: 2px 0;
            font-size: 13.5px;
            font-weight: 500;
            transition: all 0.2s;
            cursor: pointer;
        }

        .nav-item:hover {
            background: rgba(255, 255, 255, 0.06);
            color: #e2e8f0;
        }

        .nav-item.active {
            background: linear-gradient(135deg, #2563eb, #1d4ed8);
            color: #fff;
            box-shadow: 0 4px 12px rgba(37, 99, 235, 0.3);
        }

        .nav-item .nav-icon {
            font-size: 18px;
            width: 24px;
            text-align: center;
            flex-shrink: 0;
        }

        .sidebar-footer {
            padding: 16px 20px;
            border-top: 1px solid rgba(255,255,255,0.08);
        }

        .sidebar-footer .user-info {
            display: flex;
            align-items: center;
            gap: 10px;
            margin-bottom: 12px;
        }

        .user-avatar {
            width: 36px;
            height: 36px;
            border-radius: 50%;
            background: linear-gradient(135deg, #059669, #047857);
            display: flex;
            align-items: center;
            justify-content: center;
            color: #fff;
            font-weight: 700;
            font-size: 14px;
            flex-shrink: 0;
        }

        .user-name {
            color: #e2e8f0;
            font-size: 13px;
            font-weight: 600;
            line-height: 1.2;
        }

        .user-role {
            color: #64748b;
            font-size: 11px;
        }

        /* ===== TOP HEADER ===== */
        .top-header {
            position: fixed;
            top: 0;
            left: 260px;
            right: 0;
            height: 64px;
            background: rgba(255, 255, 255, 0.95);
            backdrop-filter: blur(10px);
            border-bottom: 1px solid #e5e7eb;
            display: flex;
            align-items: center;
            justify-content: space-between;
            padding: 0 28px;
            z-index: 999;
            transition: left 0.3s cubic-bezier(0.4, 0, 0.2, 1);
        }

        .header-left {
            display: flex;
            align-items: center;
            gap: 16px;
        }

        .hamburger {
            display: none;
            background: none;
            border: none;
            font-size: 22px;
            cursor: pointer;
            padding: 6px;
            border-radius: 8px;
            color: #374151;
            transition: background 0.2s;
        }

        .hamburger:hover {
            background: #f3f4f6;
        }

        .header-title {
            font-size: 18px;
            font-weight: 700;
            color: #1a1a2e;
        }

        .header-right {
            display: flex;
            align-items: center;
            gap: 16px;
        }

        .header-greeting {
            font-size: 13px;
            color: #6b7280;
        }

        .header-greeting strong {
            color: #1a1a2e;
        }

        .btn-logout {
            display: flex;
            align-items: center;
            gap: 6px;
            padding: 8px 18px;
            background: linear-gradient(135deg, #ef4444, #dc2626);
            color: #fff;
            border: none;
            border-radius: 8px;
            font-size: 13px;
            font-weight: 600;
            cursor: pointer;
            transition: transform 0.15s, box-shadow 0.2s;
            font-family: 'Inter', sans-serif;
            text-decoration: none;
        }

        .btn-logout:hover {
            transform: translateY(-1px);
            box-shadow: 0 4px 14px rgba(239, 68, 68, 0.4);
            color: #fff;
        }

        /* ===== MAIN CONTENT ===== */
        .main-content {
            margin-left: 260px;
            margin-top: 64px;
            padding: 28px;
            min-height: calc(100vh - 64px);
            transition: margin-left 0.3s cubic-bezier(0.4, 0, 0.2, 1);
        }

        /* ===== OVERLAY for mobile ===== */
        .sidebar-overlay {
            display: none;
            position: fixed;
            top: 0;
            left: 0;
            width: 100%;
            height: 100%;
            background: rgba(0, 0, 0, 0.5);
            z-index: 999;
        }

        /* ===== Dashboard Cards ===== */
        .card {
            border: 1px solid #e2e6ea;
            border-radius: 14px;
            box-shadow: 0 2px 8px rgba(0, 0, 0, 0.04);
            transition: transform 0.2s ease-in-out, box-shadow 0.2s;
            background: #fff;
        }

        .card:hover {
            transform: translateY(-3px);
            box-shadow: 0 6px 16px rgba(0, 0, 0, 0.08);
        }

        .status-card {
            text-align: center;
            color: white;
            padding: 18px;
            font-weight: 600;
            border-radius: 12px;
            cursor: pointer;
            font-size: 15px;
            transition: transform 0.2s, box-shadow 0.2s;
        }

        .status-card:hover {
            transform: translateY(-2px);
        }

        .status-on {
            background: linear-gradient(135deg, #059669, #047857);
            box-shadow: 0 4px 14px rgba(5, 150, 105, 0.3);
        }

        .status-off {
            background: linear-gradient(135deg, #ef4444, #dc2626);
            box-shadow: 0 4px 14px rgba(239, 68, 68, 0.3);
        }

        .alert-card {
            border-left: 5px solid #dc3545;
            background-color: #fff3f3;
        }

        .sensor-card {
            cursor: pointer;
            transition: transform 0.2s ease, box-shadow 0.2s ease;
            border: 1.5px solid #e5e7eb;
            border-radius: 14px;
            background: #fff;
        }

        .sensor-card:hover {
            transform: translateY(-4px);
            box-shadow: 0 8px 20px rgba(0, 0, 0, 0.08);
            border-color: #2563eb;
        }

        .sensor-card h6 {
            font-size: 13px;
            font-weight: 600;
            color: #6b7280;
            margin-bottom: 8px;
        }

        .sensor-card h4 {
            font-size: 20px;
            font-weight: 700;
            color: #1a1a2e;
            margin: 0;
        }

        .chart-container {
            background: #ffffff;
            border: 1px solid #e5e7eb;
            border-radius: 12px;
            padding: 16px;
            box-shadow: 0 2px 6px rgba(0, 0, 0, 0.03);
        }

        canvas {
            width: 100% !important;
            height: 220px !important;
        }

        /* ===== Board Status Bar ===== */
        .board-status-bar {
            cursor: pointer;
            background: linear-gradient(135deg, #f8fafc, #f1f5f9);
            border: 1.5px solid #e2e8f0;
            border-radius: 12px;
            padding: 16px 20px;
            transition: transform 0.2s ease, box-shadow 0.2s;
        }

        .board-status-bar:hover {
            transform: scale(1.01);
            box-shadow: 0 4px 12px rgba(0, 0, 0, 0.06);
        }

        /* ===== Refresh Buttons ===== */
        .btn-refresh {
            background: linear-gradient(135deg, #2563eb, #1d4ed8);
            color: #fff;
            border: none;
            border-radius: 8px;
            padding: 9px 20px;
            font-size: 14px;
            font-weight: 600;
            transition: transform 0.15s, box-shadow 0.2s;
            font-family: 'Inter', sans-serif;
        }

        .btn-refresh:hover {
            transform: translateY(-1px);
            box-shadow: 0 4px 14px rgba(37, 99, 235, 0.4);
            color: #fff;
        }

        .btn-auto {
            border: 1.5px solid #d1d5db;
            background: #fff;
            color: #374151;
            border-radius: 8px;
            padding: 9px 20px;
            font-size: 14px;
            font-weight: 600;
            transition: all 0.2s;
            font-family: 'Inter', sans-serif;
        }

        .btn-auto.active {
            background: linear-gradient(135deg, #059669, #047857);
            color: #fff;
            border-color: #059669;
        }

        /* ===== Section Titles ===== */
        .section-title {
            font-size: 17px;
            font-weight: 700;
            color: #1a1a2e;
            margin-bottom: 16px;
        }

        /* ===== Table Styling ===== */
        .data-table {
            border-radius: 12px;
            overflow: hidden;
        }

        .table thead th {
            background: #f8fafc;
            font-size: 12px;
            font-weight: 600;
            text-transform: uppercase;
            letter-spacing: 0.5px;
            color: #64748b;
            border-bottom: 2px solid #e2e8f0;
            padding: 12px;
        }

        .table tbody td {
            padding: 11px 12px;
            font-size: 13.5px;
            color: #374151;
            vertical-align: middle;
        }

        .table-striped > tbody > tr:nth-of-type(odd) > * {
            background-color: #fafbfc;
        }

        /* ===== Footer ===== */
        .dashboard-footer {
            text-align: center;
            padding: 20px;
            color: #9ca3af;
            font-size: 12px;
            border-top: 1px solid #e5e7eb;
            margin-top: 32px;
        }

        /* ===== Responsive ===== */
        @media (max-width: 992px) {
            .sidebar {
                transform: translateX(-100%);
            }

            .sidebar.open {
                transform: translateX(0);
            }

            .sidebar-overlay.show {
                display: block;
            }

            .top-header {
                left: 0;
            }

            .main-content {
                margin-left: 0;
            }

            .hamburger {
                display: block;
            }
        }

        @media (max-width: 768px) {
            .main-content {
                padding: 16px;
            }

            .header-greeting {
                display: none;
            }
        }

        /* ===== Nav Button ===== */
        .btn-nav-company {
            display: flex;
            align-items: center;
            gap: 6px;
            padding: 8px 16px;
            background: linear-gradient(135deg, #7c3aed, #6d28d9);
            color: #fff;
            border: none;
            border-radius: 8px;
            font-size: 13px;
            font-weight: 600;
            cursor: pointer;
            transition: transform 0.15s, box-shadow 0.2s;
            font-family: 'Inter', sans-serif;
            text-decoration: none;
        }

        .btn-nav-company:hover {
            transform: translateY(-1px);
            box-shadow: 0 4px 14px rgba(124, 58, 237, 0.4);
            color: #fff;
        }

        /* ===== Animations ===== */
        @keyframes fadeInUp {
            from { opacity: 0; transform: translateY(15px); }
            to { opacity: 1; transform: translateY(0); }
        }

        .fade-in-up {
            animation: fadeInUp 0.4s ease-out;
        }
    </style>
</head>

<body>
<form id="form1" runat="server">

    <!-- Sidebar Overlay (Mobile) -->
    <div class="sidebar-overlay" id="sidebarOverlay" onclick="closeSidebar()"></div>

    <!-- Sidebar -->
    <nav class="sidebar" id="sidebar">
        <div class="sidebar-brand">
            <span class="brand-icon">🌿</span>
            <h4>Smart Agriculture</h4>
            <small>IoT Dashboard</small>
        </div>

        <div class="sidebar-nav">
            <div class="nav-section">
                <div class="nav-section-title">Main</div>
                <a class="nav-item active" href="ViewSensoreData.aspx">
                    <span class="nav-icon">📊</span> Dashboard
                </a>
                <a class="nav-item" href="DeviceStatus.aspx">
                    <span class="nav-icon">⚙️</span> Device Status
                </a>
            </div>

            <div class="nav-section">
                <div class="nav-section-title">Sensors</div>
                <a class="nav-item" href="temperaturedata.aspx">
                    <span class="nav-icon">🌡️</span> Temperature
                </a>
                <a class="nav-item" href="humiditydata.aspx">
                    <span class="nav-icon">💧</span> Humidity
                </a>
                <a class="nav-item" href="soildata.aspx">
                    <span class="nav-icon">🌱</span> Soil Moisture
                </a>
                <a class="nav-item" href="lightdata.aspx">
                    <span class="nav-icon">☀️</span> Light Intensity
                </a>
            </div>

            <div class="nav-section">
                <div class="nav-section-title">Controls</div>
                <a class="nav-item" href="pumpdata.aspx">
                    <span class="nav-icon">🚿</span> Pump Analytics
                </a>
                <a class="nav-item" href="lightcontroldata.aspx">
                    <span class="nav-icon">💡</span> Light Control
                </a>
            </div>

            <div class="nav-section">
                <div class="nav-section-title">Business</div>
                <a class="nav-item" href="../Companies/Companies.aspx">
                    <span class="nav-icon">🏢</span> Companies
                </a>
            </div>

            <div class="nav-section">
                <div class="nav-section-title">Other</div>
                <a class="nav-item" href="../Default.aspx">
                    <span class="nav-icon">🏠</span> Home Page
                </a>
            </div>
        </div>

        <div class="sidebar-footer">
            <div class="user-info">
                <div class="user-avatar" id="sidebarAvatar">F</div>
                <div>
                    <div class="user-name" id="sidebarUserName">Farmer</div>
                    <div class="user-role">Farmer Account</div>
                </div>
            </div>
        </div>
    </nav>

    <!-- Top Header -->
    <header class="top-header">
        <div class="header-left">
            <button class="hamburger" id="hamburgerBtn" type="button" onclick="toggleSidebar()">☰</button>
            <span class="header-title">📊 Live Dashboard</span>
        </div>
        <div class="header-right">
            <span class="header-greeting">Welcome, <strong><%= Session["FarmerName"] ?? "Farmer" %></strong></span>
            <a href="../Companies/Companies.aspx" class="btn-nav-company">🏢 Companies</a>
            <asp:Button ID="btnLogout" runat="server" Text="🚪 Logout" CssClass="btn-logout" OnClick="btnLogout_Click" CausesValidation="false" />
        </div>
    </header>

    <!-- Main Content -->
    <div class="main-content fade-in-up">

        <!-- Board Status -->
        <div class="board-status-bar d-flex flex-row justify-content-between align-items-center mb-4"
            onclick="onStatusCardClick('status')">
            <h5 class="mb-0" style="font-size: 15px; font-weight: 600; color: #374151;">⚙️ Board Connection Status</h5>
            <span id="boardStatus" class="badge bg-secondary fs-6 px-3 py-2" style="border-radius: 8px;">Checking...</span>
        </div>

        <!-- Control Buttons -->
        <div class="d-flex justify-content-center align-items-center mb-4 gap-2 flex-wrap">
            <button id="refreshBtn" class="btn-refresh" type="button" onclick="fetchData(false)">
                <span id="refreshIcon" class="spinner-border spinner-border-sm d-none"></span> 🔄 Manual Refresh
            </button>
            <button id="toggleAutoBtn" class="btn-auto" type="button" onclick="toggleAuto()">
                Enable Auto Refresh
            </button>
        </div>

        <!-- Sensor Cards -->
        <h5 class="section-title">📡 Live Sensor Readings</h5>
        <div class="row g-3 mb-4">
            <div class="col-lg-3 col-md-6 col-6">
                <div class="card text-center p-3 sensor-card" onclick="onCardClick('Temperature')">
                    <h6>🌡 Temperature</h6>
                    <h4 id="tempVal">-- °C</h4>
                </div>
            </div>
            <div class="col-lg-3 col-md-6 col-6">
                <div class="card text-center p-3 sensor-card" onclick="onCardClick('Humidity')">
                    <h6>💧 Humidity</h6>
                    <h4 id="humidVal">-- %</h4>
                </div>
            </div>
            <div class="col-lg-3 col-md-6 col-6">
                <div class="card text-center p-3 sensor-card" onclick="onCardClick('Soil Moisture')">
                    <h6>🌱 Soil Moisture</h6>
                    <h4 id="soilVal">--</h4>
                </div>
            </div>
            <div class="col-lg-3 col-md-6 col-6">
                <div class="card text-center p-3 sensor-card" onclick="onCardClick('Light Intensity')">
                    <h6>☀ Light Intensity</h6>
                    <h4 id="lightVal">--</h4>
                </div>
            </div>
        </div>

        <!-- Gas Alert -->
        <div id="gasAlert" class="alert alert-card d-none text-center fw-semibold" style="border-radius: 10px;">
            ⚠️ Bad Gas Detected! Please Check the Environment.
        </div>

        <!-- Pump and Light Status -->
        <h5 class="section-title">🎛️ Device Controls</h5>
        <div class="row text-center mb-4 g-3">
            <div class="col-md-6 col-12">
                <div id="pumpStatus" class="status-card status-off" onclick="onStatusCardClick('Pump')">
                    💧 Pump: OFF
                </div>
            </div>
            <div class="col-md-6 col-12">
                <div id="lightStatus" class="status-card status-off" onclick="onStatusCardClick('Light')">
                    💡 Light: OFF
                </div>
            </div>
        </div>

        <!-- Live Graphs -->
        <div class="card mb-4 p-4">
            <h5 class="section-title text-center mb-4">📈 Live Sensor Data Trends</h5>
            <div class="row g-4">
                <div class="col-md-6">
                    <h6 class="text-center" style="font-size: 13px; font-weight: 600; color: #6b7280;">🌡 Temperature</h6>
                    <div class="chart-container"><canvas id="tempChart"></canvas></div>
                </div>
                <div class="col-md-6">
                    <h6 class="text-center" style="font-size: 13px; font-weight: 600; color: #6b7280;">💧 Humidity</h6>
                    <div class="chart-container"><canvas id="humidChart"></canvas></div>
                </div>
                <div class="col-md-6">
                    <h6 class="text-center" style="font-size: 13px; font-weight: 600; color: #6b7280;">🌱 Soil Moisture</h6>
                    <div class="chart-container"><canvas id="soilChart"></canvas></div>
                </div>
                <div class="col-md-6">
                    <h6 class="text-center" style="font-size: 13px; font-weight: 600; color: #6b7280;">☀ Light Intensity</h6>
                    <div class="chart-container"><canvas id="lightChart"></canvas></div>
                </div>
            </div>
        </div>

        <!-- Data Table -->
        <div class="card p-3 data-table">
            <h5 class="section-title mb-3">📋 Sensor Data Log</h5>
            <div class="d-flex justify-content-between align-items-center mb-3 flex-wrap gap-2">
                <div style="font-size: 13px; color: #6b7280;">Show
                    <select id="recordsPerPage" class="form-select d-inline w-auto" style="font-size: 13px; border-radius: 8px;"
                        onchange="renderTable(currentPage)">
                        <option>5</option>
                        <option selected>10</option>
                        <option>20</option>
                    </select> entries
                </div>
                <div class="input-group w-auto">
                    <input id="searchBox" type="text" class="form-control" placeholder="🔍 Search..."
                        style="font-size: 13px; border-radius: 8px;" onkeyup="renderTable(1)" />
                </div>
            </div>
            <div class="table-responsive">
                <table class="table table-striped table-bordered align-middle text-center">
                    <thead>
                        <tr>
                            <th>Time</th>
                            <th>Temperature (°C)</th>
                            <th>Humidity (%)</th>
                            <th>Soil</th>
                            <th>Light</th>
                            <th>Gas</th>
                        </tr>
                    </thead>
                    <tbody id="dataBody"></tbody>
                </table>
            </div>
            <div class="d-flex justify-content-between align-items-center">
                <span id="recordInfo" style="font-size: 13px; color: #6b7280;"></span>
                <nav>
                    <ul id="pagination" class="pagination pagination-sm mb-0"></ul>
                </nav>
            </div>
        </div>

        <!-- Footer -->
        <div class="dashboard-footer">
            Smart Agriculture IoT Dashboard &copy; <%= DateTime.Now.Year %> — All rights reserved
        </div>
    </div>

    <!-- Sidebar Toggle Script -->
    <script>
        // Sidebar
        function toggleSidebar() {
            document.getElementById('sidebar').classList.toggle('open');
            document.getElementById('sidebarOverlay').classList.toggle('show');
        }
        function closeSidebar() {
            document.getElementById('sidebar').classList.remove('open');
            document.getElementById('sidebarOverlay').classList.remove('show');
        }

        // Set user initials in sidebar avatar
        (function () {
            const nameEl = document.getElementById('sidebarUserName');
            const avatarEl = document.getElementById('sidebarAvatar');
            const farmerName = '<%= Session["FarmerName"] ?? "Farmer" %>';
            nameEl.textContent = farmerName;
            const initials = farmerName.split(' ').map(w => w[0]).join('').toUpperCase().substring(0, 2);
            avatarEl.textContent = initials;
        })();
    </script>

    <!-- Dashboard Data Scripts (preserved from original) -->
    <script>
        const apiUrl = "https://api.thingspeak.com/channels/3229994/feeds.json?api_key=W7LGD7SPBJ7YOB5O";
        let allData = [];
        let autoUpdate = false;
        let autoInterval;
        let currentPage = 1;

        function toggleAuto() {
            autoUpdate = !autoUpdate;
            const btn = document.getElementById("toggleAutoBtn");

            clearInterval(autoInterval);

            if (autoUpdate) {
                btn.textContent = "⏸ Disable Auto Refresh";
                btn.classList.add("active");
                fetchData(true);
                autoInterval = setInterval(() => fetchData(true), 60000);
            } else {
                btn.textContent = "Enable Auto Refresh";
                btn.classList.remove("active");
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

            makeChart(document.getElementById('tempChart').getContext('2d'), 'Temperature (°C)', temps, '#2563eb');
            makeChart(document.getElementById('humidChart').getContext('2d'), 'Humidity (%)', humids, '#059669');
            makeChart(document.getElementById('soilChart').getContext('2d'), 'Soil Moisture', soils, '#92400e');
            makeChart(document.getElementById('lightChart').getContext('2d'), 'Light Intensity', lights, '#d97706');
        }

        function rengerLive(latestFeed) {
            const lastTime = new Date(latestFeed.created_at);
            const now = new Date();
            const diffMinutes = (now - lastTime) / 60000;
            const boardStatus = document.getElementById("boardStatus");
            if (diffMinutes <= 1) {
                boardStatus.textContent = "✔ Board Live";
                boardStatus.className = "badge bg-success fs-6 px-3 py-2";
                boardStatus.style.borderRadius = "8px";
            } else {
                boardStatus.textContent = "🔴 Board Offline";
                boardStatus.className = "badge bg-danger fs-6 px-3 py-2";
                boardStatus.style.borderRadius = "8px";
            }
        }

        // initial fetch
        fetchData();
    </script>
</form>
</body>
</html>