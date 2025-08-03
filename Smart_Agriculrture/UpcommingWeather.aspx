<%@ Page Title="Live Weather" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="UpcommingWeather.aspx.cs" Inherits="Smart_Agriculrture.WebForm1" %>
<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">


       <!-- Weather Forecast Section -->
<div class="container bg-light rounded p-4 shadow mt-4">
    <h2 class="text-center text-primary mb-3">🌤️ Weather Forecast</h2>

    <div id="location-info" class="text-center mb-4">
        <h4 id="city-name">Detecting location...</h4>
        <p id="weather-description" class="text-muted"></p>
    </div>

    <div class="row text-center mb-4">
        <div class="col-md-3">
            <h5>🌡️ Temp</h5>
            <p id="temp">--°C</p>
        </div>
        <div class="col-md-3">
            <h5>💧 Humidity</h5>
            <p id="humidity">--%</p>
        </div>
        <div class="col-md-3">
            <h5>💨 Wind</h5>
            <p id="wind-speed">-- km/h</p>
        </div>
        <div class="col-md-3">
            <h5>🌾 Agri Advice</h5>
            <p id="agri-advice">Loading...</p>
        </div>
    </div>

    <h5 class="text-secondary mb-2">📅 5-Day Forecast</h5>
    <div id="forecast-output" class="row"></div>
    <!-- Details View -->
<div id="detailsContainer"></div>
</div>
    <script>
        async function getWeatherForecast() {
            if ("geolocation" in navigator) {
                navigator.geolocation.getCurrentPosition(async (position) => {
                    const lat = position.coords.latitude;
                    const lon = position.coords.longitude;
                    const apiKey = "25593c138e653f35d1f041717ccfa151";

                    // Get City Name
                    const geoRes = await fetch(`https://api.openweathermap.org/geo/1.0/reverse?lat=${lat}&lon=${lon}&limit=1&appid=${apiKey}`);
                    const geoData = await geoRes.json();
                    const cityName = geoData[0]?.name || "Your City";
                    document.getElementById("city-name").innerText = cityName;

                    // Get Weather Forecast
                    const weatherRes = await fetch(`https://api.openweathermap.org/data/2.5/forecast?lat=${lat}&lon=${lon}&units=metric&appid=${apiKey}`);
                    const weatherData = await weatherRes.json();

                    const forecastContainer = document.getElementById("forecast-output");
                    const detailsContainer = document.getElementById("detailsContainer");
                    forecastContainer.innerHTML = "";

                    const current = weatherData.list[0]; // First data point (~current)
                    document.getElementById("temp").innerText = `${current.main.temp}°C`;
                    document.getElementById("humidity").innerText = `${current.main.humidity}%`;
                    document.getElementById("wind-speed").innerText = `${current.wind.speed} km/h`;

                    // Simple agri advice based on temperature and humidity
                    let advice = "Normal weather conditions.";
                    if (current.main.temp > 35) {
                        advice = "☀️ Too hot! Consider irrigation and shading.";
                    } else if (current.main.humidity < 30) {
                        advice = "💧 Soil might be dry. Check moisture.";
                    } else if (current.weather[0].main.toLowerCase().includes("rain")) {
                        advice = "🌧️ Rain expected. Good time for sowing.";
                    }
                    document.getElementById("agri-advice").innerText = advice;

                    // Forecast cards (5 days)
                    let shownDates = new Set();

                    for (let item of weatherData.list) {
                        const date = item.dt_txt.split(" ")[0];
                        if (!shownDates.has(date) && shownDates.size < 5) {
                            shownDates.add(date);

                            const card = document.createElement("div");
                            card.className = "col-md-2 mb-3";
                            card.innerHTML = `
                            <div class="card shadow-sm clickable-card" data-date="${date}">
                                <div class="card-body text-center">
                                    <h6>${new Date(item.dt_txt).toLocaleDateString()}</h6>
                                    <img src="https://openweathermap.org/img/wn/${item.weather[0].icon}.png" alt="icon" />
                                    <p class="mb-0">${item.main.temp}°C</p>
                                    <small>${item.weather[0].main}</small>
                                </div>
                            </div>
                        `;
                            forecastContainer.appendChild(card);
                        }
                    }

                    // Card click: Show hourly detail
                    document.querySelectorAll(".clickable-card").forEach(card => {
                        card.addEventListener("click", () => {
                            const selectedDate = card.getAttribute("data-date");
                            const selectedData = weatherData.list.filter(item => item.dt_txt.startsWith(selectedDate));

                            let detailsHTML = `
                            <div class="col-12">
                                <h5 class="text-primary text-center mb-3">Hourly Forecast for ${new Date(selectedDate).toDateString()}</h5>
                                <div class="row">
                        `;

                            for (let hour of selectedData) {
                                detailsHTML += `
                                <div class="col-md-3 mb-3">
                                    <div class="card shadow-sm">
                                        <div class="card-body text-center">
                                            <h6>${new Date(hour.dt_txt).toLocaleTimeString([], { hour: '2-digit', minute: '2-digit' })}</h6>
                                            <img src="https://openweathermap.org/img/wn/${hour.weather[0].icon}.png" width="50" />
                                            <p class="mb-1"><strong>${hour.weather[0].description}</strong></p>
                                            <p class="mb-1">🌡️ Temp: ${hour.main.temp}°C</p>
                                            <p class="mb-1">📉 Min: ${hour.main.temp_min}°C | 📈 Max: ${hour.main.temp_max}°C</p>
                                            <p class="mb-1">💧 Humidity: ${hour.main.humidity}%</p>
                                            <p class="mb-0">💨 Wind: ${hour.wind.speed} m/s</p>
                                        </div>
                                    </div>
                                </div>
                            `;
                            }

                            detailsHTML += `</div></div>`;
                            detailsContainer.innerHTML = detailsHTML;
                        });
                    });
                });
            } else {
                alert("Geolocation not supported");
            }
        }

        window.onload = getWeatherForecast;
    </script>

<style>
    .clickable-card {
    cursor: pointer;
    transition: transform 0.2s ease-in-out;
}
.clickable-card:hover {
    transform: scale(1.05);
}

</style>

</asp:Content>
