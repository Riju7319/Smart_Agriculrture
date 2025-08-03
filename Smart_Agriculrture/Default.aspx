<%@ Page Title="Home Page" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="Default.aspx.cs" Inherits="Smart_Agriculrture._Default" %>

<asp:Content ID="BodyContent" ContentPlaceHolderID="MainContent" runat="server">
    <main class="container py-4 px-3">
        
<!-- Weather Summary Bar -->
<div id="weather-summary-bar" class="bg-light p-3 rounded shadow mb-4 text-center d-flex justify-content-center align-items-center gap-3 flex-wrap" style="font-size: 1.1rem;">
  <span>📍 <strong id="weather-location">Fetching location...</strong></span>
  <span>🌡️ <strong id="weather-temp">--°C</strong></span>
  <span>📝 <strong id="weather-comment">Loading suggestion...</strong></span>
</div>





<!-- Intro Section -->
<section class="bg-white p-4 rounded shadow mb-4 text-center">
  <h1 class="h3 h-md-1 fw-bold text-success mb-3">🌿 Smart Agriculture IoT Platform</h1>

  <p class="lead text-muted">
    We build smart solutions to transform traditional farming into data-driven, automated agriculture using affordable IoT technology.
  </p>

  <p class="text-muted">
    From monitoring soil and air conditions to automating irrigation and alerts — our IoT-based systems help farmers and gardeners increase crop yields, reduce water waste, and save time.
  </p>

  <p class="fw-bold text-primary mt-3">
    🌱 Whether you're managing a home garden, greenhouse, or small farm — we provide scalable smart agriculture tools to help you farm smarter.
  </p>
</section>



<!-- Project Overview -->
<section class="bg-light p-4 rounded shadow mb-4">
  <h3 class="mb-3 text-primary">📌 Our Mission: Smarter, Greener Farming</h3>

  <p>
    Welcome to the world of <strong>Smart Agriculture</strong> — where we combine cutting-edge technology with everyday farming to help both small and large growers become more efficient, eco-friendly, and informed. Our platform offers a variety of IoT-powered solutions that help monitor, automate, and enhance agricultural practices.
  </p>

  <h5 class="text-secondary mt-4">🌿 What We Offer</h5>
  <ul>
    <li>🌡️ <strong>Temperature-Based Alerts:</strong> Real-time monitoring that warns users when the climate becomes too hot, helping prevent crop heat damage.</li>
    <li>💧 <strong>Soil Moisture-Based Irrigation:</strong> Automatically activates a water pump when soil is too dry — reducing water waste and saving crops.</li>
    <li>🌫️ <strong>Air Quality Detection:</strong> Identifies harmful gases or bad smells, especially useful in greenhouses or enclosed areas.</li>
    <li>📶 <strong>Live Data & Mobile Access:</strong> Access real-time sensor data and alerts from your mobile or desktop device.</li>
    <li>🖥️ <strong>Custom Agriculture Tools:</strong> Our system is expanding to include pest detection tools, crop health analysis (coming soon), and weather forecasting integrations.</li>
  </ul>

  <h5 class="text-secondary mt-4">🔍 How the Core System Works</h5>
  <ul class="list-group list-group-flush mb-3">
    <li class="list-group-item">
      🧠 <strong>Arduino Uno Controller:</strong> Central controller for collecting sensor data, making decisions, and executing actions without constant user input.
    </li>
    <li class="list-group-item">
      🔔 <strong>Real-Time Decision Engine:</strong> Based on sensor inputs, the system decides whether to send alerts or activate devices like pumps or alarms.
    </li>
    <li class="list-group-item">
      🌐 <strong>IoT Integration:</strong> Enables you to view conditions remotely, receive notifications, and track history through a cloud-based dashboard.
    </li>
  </ul>

  <h5 class="text-secondary mt-4">🌾 Use Cases</h5>
  <ul>
    <li>✅ Farms wanting to automate irrigation and climate response.</li>
    <li>✅ Home gardeners or greenhouse owners aiming for low-maintenance care.</li>
    <li>✅ Institutions and universities using this platform for educational demonstrations of smart farming.</li>
    <li>✅ Agritech startups and research bodies looking to scale or experiment with IoT-based farming methods.</li>
  </ul>

  <h5 class="text-secondary mt-4">💡 Why Choose Our Solutions?</h5>
  <p>
    Our system isn't just about automation — it's about intelligence. We focus on actionable insights, remote accessibility, and scalable modules so you can start small and expand as your needs grow. Each tool is built with ease-of-use, reliability, and sustainability in mind.
  </p>

  <p class="fw-bold text-success mt-3">
    Whether you're growing tomatoes in your backyard or managing a full-scale farm, our Smart Agriculture System brings you one step closer to a smarter, more resilient way of farming.
  </p>
</section>


        <!-- Why Smart Agriculture Matters -->
<section class="container my-5">
  <h2 class="text-center mb-4">🌍 Why Smart Agriculture Matters</h2>
  <div class="row">
    <div class="col-md-6">
      <p>
        As climate change, water scarcity, and food demand increase, it's crucial to evolve farming with technology. Traditional methods can't keep up with modern challenges alone.
      </p>
      <ul>
        <li>🌱 Manual watering often leads to waste or poor crop health</li>
        <li>🌡️ Environmental conditions go unnoticed until it’s too late</li>
        <li>📉 Yield suffers due to poor timing or limited insights</li>
      </ul>
    </div>
    <div class="col-md-6">
      <p>
        Our IoT-based smart farming systems tackle these issues with:
      </p>
      <ul>
        <li>✅ Real-time data from temperature, soil, and gas sensors</li>
        <li>✅ Automated irrigation and alert systems</li>
        <li>✅ Scalable setups for farms, gardens, and greenhouses</li>
      </ul>
    </div>
  </div>
</section>


        <!-- Use Cases & Benefits Section -->
<section class="container my-5">
    <h2 class="text-center mb-4">🧾 Use Cases & Benefits</h2>
    <div class="row text-center">
        <div class="col-md-4 mb-4">
            <div class="card h-100 shadow">
                <div class="card-body">
                    <h5 class="card-title">🌾 Smart Irrigation</h5>
                    <p class="card-text">Irrigate only when soil moisture is low—saving water and improving crop health.</p>
                </div>
            </div>
        </div>
        <div class="col-md-4 mb-4">
            <div class="card h-100 shadow">
                <div class="card-body">
                    <h5 class="card-title">🌬️ Air Quality Monitoring</h5>
                    <p class="card-text">Detect harmful gases or unpleasant smells in greenhouses or confined spaces.</p>
                </div>
            </div>
        </div>
        <div class="col-md-4 mb-4">
            <div class="card h-100 shadow">
                <div class="card-body">
                    <h5 class="card-title">🌡️ Temperature Alerts</h5>
                    <p class="card-text">Get alerts during heatwaves or extreme cold to protect crops and livestock.</p>
                </div>
            </div>
        </div>
        <div class="col-md-4 mb-4">
            <div class="card h-100 shadow">
                <div class="card-body">
                    <h5 class="card-title">💧 Smart Pump Control</h5>
                    <p class="card-text">Automatically starts the water pump when soil is dry, and alerts the user when the temperature is too hot for safe crop conditions.</p>
                </div>
            </div>
        </div>
    </div>
</section>

<!-- Contact / Suggest a Feature Section -->
<section class="container my-5">
    <h2 class="text-center mb-4">🛠️ Modular IoT Capabilities</h2>
<p class="text-center text-muted mb-4">Our smart farming platform is flexible and can grow with your needs — from a single device to a network of sensors and automation tools.</p>
    <div class="row justify-content-center">
        <div class="col-md-8">
            <form>
                <div class="mb-3">
                    <label for="name" class="form-label">Your Name</label>
                    <input type="text" class="form-control" id="name" placeholder="Enter your name" />
                </div>
                <div class="mb-3">
                    <label for="email" class="form-label">Your Email</label>
                    <input type="email" class="form-control" id="email" placeholder="Enter your email" />
                </div>
                <div class="mb-3">
                    <label for="message" class="form-label">Your Message or Feature Suggestion</label>
                    <textarea class="form-control" id="message" rows="4" placeholder="Describe your suggestion or question..."></textarea>
                </div>
                <button type="submit" class="btn btn-primary">Send Message</button>
            </form>
        </div>
    </div>
</section>



        <!-- Latest News Section -->
        <section class="bg-white p-4 rounded shadow">
            <h3 class="mb-4 text-info text-center">📡 Latest News in IoT</h3>
            <asp:Repeater ID="rptIoTNews" runat="server">
                <HeaderTemplate>
                    <div class="row g-3">
                </HeaderTemplate>
                <ItemTemplate>
                    <div class="col-12 col-sm-6 col-md-4">
                        <div class="card h-100 shadow-sm border-0">
                            <div class="card-body d-flex flex-column">
                                <h5 class="card-title text-truncate"><%# Eval("Title") %></h5>
                                <p class="card-text text-muted small"><%# Eval("PubDate") %></p>
                                <a href='<%# Eval("Link") %>' class="btn btn-outline-primary mt-auto w-100" target="_blank">Read More</a>
                            </div>
                        </div>
                    </div>
                </ItemTemplate>
                <FooterTemplate>
                    </div>
                </FooterTemplate>
            </asp:Repeater>
        </section>
        <style>
            .card-title {
    overflow: hidden;
    text-overflow: ellipsis;
    white-space: nowrap;
}

        </style>
       
<script>
    async function getCurrentWeatherSummary() {
        if ("geolocation" in navigator) {
            navigator.geolocation.getCurrentPosition(async (position) => {
                const lat = position.coords.latitude;
                const lon = position.coords.longitude;
                const apiKey = "25593c138e653f35d1f041717ccfa151";

                // Get city name
                const geoRes = await fetch(`https://api.openweathermap.org/geo/1.0/reverse?lat=${lat}&lon=${lon}&limit=1&appid=${apiKey}`);
                const geoData = await geoRes.json();
                const city = geoData[0]?.name || "Your Area";
                document.getElementById("weather-location").innerText = city;

                // Get current weather
                const weatherRes = await fetch(`https://api.openweathermap.org/data/2.5/weather?lat=${lat}&lon=${lon}&units=metric&appid=${apiKey}`);
                const weather = await weatherRes.json();

                const temp = weather.main.temp;
                const humidity = weather.main.humidity;
                const condition = weather.weather[0].main;

                document.getElementById("weather-temp").innerText = `${Math.round(temp)}°C`;

                // Decide comment based on temperature and condition
                let comment = "";
                if (condition.includes("Rain")) {
                    comment = "🌧️ Rainy – plan accordingly";
                } else if (temp >= 32) {
                    comment = "☀️ Too hot for crops – water regularly";
                } else if (temp >= 20 && temp <= 30 && humidity >= 40 && humidity <= 80) {
                    comment = "🌱 Good for planting";
                } else {
                    comment = "🧭 Check conditions before field work";
                }

                document.getElementById("weather-comment").innerText = comment;
            });
        } else {
            document.getElementById("weather-comment").innerText = "Geolocation not supported.";
        }
    }

    window.onload = function () {
        getCurrentWeatherSummary();
    };
</script>

    </main>
</asp:Content>
