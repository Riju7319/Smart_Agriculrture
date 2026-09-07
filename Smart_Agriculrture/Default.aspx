<%@ Page Title="Home Page" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true"
    CodeBehind="Default.aspx.cs" Inherits="Smart_Agriculrture._Default" %>

    <asp:Content ID="BodyContent" ContentPlaceHolderID="MainContent" runat="server">
        <!-- Weather Summary Bar (Preserved) -->
        <div id="weather-summary-bar"
            class="d-flex justify-content-center align-items-center gap-4 bg-primary bg-opacity-10 py-3 mb-5 border-bottom border-primary border-opacity-25"
            style="font-size: 1.1rem;">
            <span class="badge bg-primary rounded-pill px-3 py-2"><i class="bi bi-geo-alt-fill me-1"></i> <strong
                    id="weather-location">Locating...</strong></span>
            <span class="text-dark"><i class="bi bi-thermometer-half text-danger"></i> <strong
                    id="weather-temp">--°C</strong></span>
            <span class="text-dark fst-italic"><i class="bi bi-info-circle text-primary"></i> <strong
                    id="weather-comment">Loading suggestions...</strong></span>
        </div>

        <main class="container">

            <!-- Hero Section -->
            <div
                class="p-5 mb-5 bg-light rounded-3 shadow-sm text-center border-start border-5 border-success position-relative overflow-hidden">
                <div class="position-relative z-1">
                    <h1 class="display-4 fw-bold text-success mb-3">🌿 Smart Agriculture IoT Platform</h1>
                    <p class="col-lg-8 mx-auto lead text-muted mb-4">
                        Transforming traditional farming with data-driven automation. Monitor, analyze, and optimize
                        your crops with affordable IoT technology.
                    </p>
                    <div class="d-flex gap-3 justify-content-center">
                        <a href="Contact.aspx" class="btn btn-success btn-lg px-4 gap-3">Get Started</a>
                        <a href="About.aspx" class="btn btn-outline-secondary btn-lg px-4">Learn More</a>
                    </div>
                </div>
                <i class="bi bi-flower1 position-absolute top-0 end-0 text-success opacity-10"
                    style="font-size: 15rem; transform: translate(30%, -30%);"></i>
            </div>

            <!-- Project Overview & Mission -->
            <div class="row align-items-center mb-5">
                <div class="col-lg-6 mb-4 mb-lg-0">
                    <h2 class="fw-bold mb-3 border-bottom pb-2 d-inline-block border-primary">🚀 Our Mission</h2>
                    <p class="lead text-secondary">Smarter, Greener, More Efficient Farming.</p>
                    <p class="text-muted">
                        Welcome to the future of agriculture. We combine cutting-edge sensors with automation to help
                        farmers and gardeners save water, increase yields, and reduce manual labor.
                    </p>
                    <ul class="list-unstyled mt-4 d-grid gap-2">
                        <li class="d-flex align-items-start"><i
                                class="bi bi-check-circle-fill text-success me-2 mt-1"></i>
                            <div><strong>Eco-Friendly:</strong> Optimized water usage reduces waste.</div>
                        </li>
                        <li class="d-flex align-items-start"><i
                                class="bi bi-check-circle-fill text-success me-2 mt-1"></i>
                            <div><strong>Real-Time Data:</strong> Instant access to soil and air metrics.</div>
                        </li>
                        <li class="d-flex align-items-start"><i
                                class="bi bi-check-circle-fill text-success me-2 mt-1"></i>
                            <div><strong>Scalable:</strong> Perfect for backyards or commercial farms.</div>
                        </li>
                    </ul>
                </div>
                <div class="col-lg-6">
                    <div class="row g-3">
                        <div class="col-6">
                            <div class="p-4 bg-white shadow-sm rounded-3 text-center border h-100">
                                <i class="bi bi-moisture fs-1 text-info mb-3 d-block"></i>
                                <h5 class="fw-bold">Soil Moisture</h5>
                                <small class="text-muted">Automated Pump triggers</small>
                            </div>
                        </div>
                        <div class="col-6">
                            <div class="p-4 bg-white shadow-sm rounded-3 text-center border h-100">
                                <i class="bi bi-thermometer-sun fs-1 text-warning mb-3 d-block"></i>
                                <h5 class="fw-bold">Temp Alerts</h5>
                                <small class="text-muted">Prevent heat damage</small>
                            </div>
                        </div>
                        <div class="col-6">
                            <div class="p-4 bg-white shadow-sm rounded-3 text-center border h-100">
                                <i class="bi bi-wind fs-1 text-secondary mb-3 d-block"></i>
                                <h5 class="fw-bold">Air Quality</h5>
                                <small class="text-muted">Greenhouse safety</small>
                            </div>
                        </div>
                        <div class="col-6">
                            <div class="p-4 bg-white shadow-sm rounded-3 text-center border h-100">
                                <i class="bi bi-phone fs-1 text-primary mb-3 d-block"></i>
                                <h5 class="fw-bold">Mobile View</h5>
                                <small class="text-muted">Monitor from anywhere</small>
                            </div>
                        </div>
                    </div>
                </div>
            </div>

            <!-- How It Works & Use Cases -->
            <div class="row g-5 mb-5">
                <div class="col-md-6">
                    <div class="card shadow-sm h-100 border-0 bg-light">
                        <div class="card-body p-4">
                            <h3 class="card-title fw-bold mb-4"><i
                                    class="bi bi-gear-wide-connected text-secondary me-2"></i> How It Works</h3>
                            <div class="d-flex flex-column gap-3">
                                <div class="d-flex align-items-center bg-white p-3 rounded shadow-sm">
                                    <span class="badge bg-dark rounded-circle p-3 me-3 fs-5">1</span>
                                    <div><strong>Sensors Collect Data:</strong> Soil, temp, and air readings.</div>
                                </div>
                                <div class="d-flex align-items-center bg-white p-3 rounded shadow-sm">
                                    <span class="badge bg-primary rounded-circle p-3 me-3 fs-5">2</span>
                                    <div><strong>Arduino Processes:</strong> Analyzes data in real-time.</div>
                                </div>
                                <div class="d-flex align-items-center bg-white p-3 rounded shadow-sm">
                                    <span class="badge bg-success rounded-circle p-3 me-3 fs-5">3</span>
                                    <div><strong>Action Taken:</strong> Pumps start, or alerts are sent.</div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
                <div class="col-md-6">
                    <div class="card shadow-sm h-100 border-0 bg-light">
                        <div class="card-body p-4">
                            <h3 class="card-title fw-bold mb-4"><i class="bi bi-people-fill text-secondary me-2"></i>
                                Who Is This For?</h3>
                            <ul class="list-group list-group-flush bg-transparent">
                                <li class="list-group-item bg-transparent border-bottom"><i
                                        class="bi bi-house-door text-success me-2"></i> <strong>Home Gardeners</strong>
                                    wanting automation.</li>
                                <li class="list-group-item bg-transparent border-bottom"><i
                                        class="bi bi-shop text-success me-2"></i> <strong>Greenhouse Owners</strong>
                                    needing climate control.</li>
                                <li class="list-group-item bg-transparent border-bottom"><i
                                        class="bi bi-building text-success me-2"></i> <strong>Institutions</strong> for
                                    educational demos.</li>
                                <li class="list-group-item bg-transparent"><i
                                        class="bi bi-rocket text-success me-2"></i> <strong>Startups</strong> scaling
                                    IoT solutions.</li>
                            </ul>
                        </div>
                    </div>
                </div>
            </div>

            <!-- Latest News Section -->
            <section class="mb-5">
                <div class="d-flex justify-content-between align-items-center mb-4">
                    <h3 class="fw-bold m-0 border-start border-4 border-info ps-3">📡 Latest IoT News</h3>
                    <a href="#" class="btn btn-sm btn-outline-info">View All Updates</a>
                </div>
                <asp:Repeater ID="rptIoTNews" runat="server">
                    <HeaderTemplate>
                        <div class="row g-4">
                    </HeaderTemplate>
                    <ItemTemplate>
                        <div class="col-md-4">
                            <div class="card h-100 border-0 shadow-sm hover-shadow transition-all">
                                <div class="card-body">
                                    <h5 class="card-title fw-bold text-dark text-truncate">
                                        <%# Eval("Title") %>
                                    </h5>
                                    <h6 class="card-subtitle mb-2 text-muted small">
                                        <%# Eval("PubDate") %>
                                    </h6>
                                    <p class="card-text text-truncate">Stay updated with the latest trends in smart
                                        agriculture and IoT technology.</p>
                                    <a href='<%# Eval("Link") %>'
                                        class="btn btn-link text-decoration-none p-0 stretched-link"
                                        target="_blank">Read Article <i class="bi bi-arrow-right"></i></a>
                                </div>
                            </div>
                        </div>
                    </ItemTemplate>
                    <FooterTemplate>
                        </div>
                    </FooterTemplate>
                </asp:Repeater>
            </section>

            <!-- Feedback Form -->
            <div class="bg-primary bg-opacity-10 rounded-3 p-5 mb-5 text-center position-relative overflow-hidden">
                <div class="position-relative z-1">
                    <h2 class="fw-bold">Have a Suggestion?</h2>
                    <p class="mb-4 text-muted">We are constantly improving. Let us know what modular feature you'd like
                        to see next!</p>
                    <div class="row justify-content-center">
                        <div class="col-md-6">
                            <form class="bg-white p-4 rounded shadow-sm text-start">
                                <div class="mb-3">
                                    <label class="form-label small text-uppercase text-muted fw-bold">Name</label>
                                    <input type="text" class="form-control" placeholder="John Doe">
                                </div>
                                <div class="mb-3">
                                    <label class="form-label small text-uppercase text-muted fw-bold">Feedback</label>
                                    <textarea class="form-control" rows="3"
                                        placeholder="I'd like to suggest..."></textarea>
                                </div>
                                <button type="submit" class="btn btn-primary w-100">Submit Suggestion</button>
                            </form>
                        </div>
                    </div>
                </div>
                <i class="bi bi-lightbulb position-absolute top-0 start-0 text-warning opacity-25"
                    style="font-size: 10rem; transform: translate(-30%, -30%);"></i>
            </div>

        </main>

        <!-- Weather Script (Preserved) -->
        <script>
            async function getCurrentWeatherSummary() {
                if ("geolocation" in navigator) {
                    navigator.geolocation.getCurrentPosition(async (position) => {
                        const lat = position.coords.latitude;
                        const lon = position.coords.longitude;
                        const apiKey = "25593c138e653f35d1f041717ccfa151";

                        try {
                            const geoRes = await fetch(`https://api.openweathermap.org/geo/1.0/reverse?lat=${lat}&lon=${lon}&limit=1&appid=${apiKey}`);
                            const geoData = await geoRes.json();
                            const city = geoData[0]?.name || "Local Area";
                            document.getElementById("weather-location").innerText = city;

                            const weatherRes = await fetch(`https://api.openweathermap.org/data/2.5/weather?lat=${lat}&lon=${lon}&units=metric&appid=${apiKey}`);
                            const weather = await weatherRes.json();

                            const temp = weather.main.temp;
                            const humidity = weather.main.humidity;
                            const condition = weather.weather[0].main;

                            document.getElementById("weather-temp").innerText = `${Math.round(temp)}°C`;

                            let comment = "";
                            if (condition.includes("Rain")) {
                                comment = "🌧️ Rainy – Monitor sensitive crops.";
                            } else if (temp >= 32) {
                                comment = "☀️ High Temp – Ensure adequate watering.";
                            } else if (temp >= 20 && temp <= 30 && humidity >= 40 && humidity <= 80) {
                                comment = "🌱 Ideal Growing Conditions.";
                            } else {
                                comment = "🧭 Check detailed metrics.";
                            }
                            document.getElementById("weather-comment").innerText = comment;
                        } catch (e) {
                            document.getElementById("weather-comment").innerText = "Data unavailable";
                        }
                    }, () => {
                        document.getElementById("weather-comment").innerText = "Location access denied";
                    });
                } else {
                    document.getElementById("weather-comment").innerText = "Geolocation not supported";
                }
            }

            window.onload = function () {
                getCurrentWeatherSummary();
            };
        </script>

        <style>
            .hover-shadow:hover {
                transform: translateY(-5px);
                box-shadow: 0 .5rem 1rem rgba(0, 0, 0, .15) !important;
                transition: all 0.3s ease;
            }

            .transition-all {
                transition: all 0.3s ease;
            }
        </style>
    </asp:Content>