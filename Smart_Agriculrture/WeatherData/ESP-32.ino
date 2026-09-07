#include <WiFi.h>
#include <ThingSpeak.h>
#include "DHT.h"

// ================= WIFI =================
const char* ssid = "X-Pro";
const char* password = "rksh95934455";

// ================= THINGSPEAK =================
unsigned long channelID = 3229994;
const char* writeAPIKey = "4RUF2KR7PHPILKZF";

// ================= DHT22 =================
#define DHTPIN 4
#define DHTTYPE DHT22
DHT dht(DHTPIN, DHTTYPE);

// ================= MQ-2 =================
#define MQ2_PIN 34
#define GAS_THRESHOLD 1500

// ================= BUZZER =================
#define BUZZER_PIN 26

// ================= OBJECTS =================
WiFiClient client;

// ================= BUZZER (FIXED – PASSIVE) =================
void playTone(uint32_t freq, uint32_t duration) {
  ledcAttach(BUZZER_PIN, freq, 8);   // new ESP32 core API
  ledcWriteTone(BUZZER_PIN, freq);   // start tone
  delay(duration);
  ledcWriteTone(BUZZER_PIN, 0);      // stop tone
  delay(50);
}

// Futuristic startup sound
void futuristicStartupSound() {
  playTone(1200, 80);
  playTone(1500, 80);
  playTone(1800, 120);
  delay(100);
  playTone(2200, 100);
}

// API / error beep
void errorBeep() {
  playTone(900, 300);
}

// ================= SETUP =================
void setup() {
  Serial.begin(115200);

  // 🔊 Startup sound
  futuristicStartupSound();

  dht.begin();

  // -------- WIFI CONNECT --------
  Serial.print("Connecting to WiFi");
  WiFi.begin(ssid, password);

  int retry = 0;
  while (WiFi.status() != WL_CONNECTED) {
    delay(500);
    Serial.print(".");
    retry++;

    // Wi-Fi failure alert
    if (retry > 20) {
      Serial.println("\nWiFi connection failed!");
      errorBeep();
      retry = 0;
    }
  }

  Serial.println("\nWiFi connected");
  Serial.print("IP Address: ");
  Serial.println(WiFi.localIP());

  // Wi-Fi OK sound
  playTone(1800, 100);
  playTone(1800, 100);

  ThingSpeak.begin(client);

  Serial.println("MQ-2 warming up...");
  delay(30000);
}

// ================= LOOP =================
void loop() {

  float temperature = dht.readTemperature();
  float humidity = dht.readHumidity();
  int gasValue = analogRead(MQ2_PIN);

  if (isnan(temperature) || isnan(humidity)) {
    Serial.println("❌ DHT22 error");
    errorBeep();
    return;
  }

  // 🔥 GAS / SMOKE ALERT
  if (gasValue > GAS_THRESHOLD) {
    Serial.println("🔥 GAS / SMOKE DETECTED!");
    playTone(2500, 500);   // loud alarm tone
    playTone(2500, 500);
  }

  // -------- SEND TO THINGSPEAK --------
  ThingSpeak.setField(1, temperature);
  ThingSpeak.setField(2, humidity);
  ThingSpeak.setField(3, 65);
  ThingSpeak.setField(4, 720);
  ThingSpeak.setField(5, gasValue);
  ThingSpeak.setField(6, 0);
  ThingSpeak.setField(7, 1);

  int response = ThingSpeak.writeFields(channelID, writeAPIKey);

  if (response == 200) {
    Serial.println("✅ Data sent to ThingSpeak");
  } else {
    Serial.print("❌ ThingSpeak API error: ");
    Serial.println(response);

    // API error alert
    for (int i = 0; i < 3; i++) {
      errorBeep();
      delay(200);
    }
  }

  // -------- SERIAL LOG --------
  Serial.println("----- DEVICE DATA -----");
  Serial.print("Temp: "); Serial.println(temperature);
  Serial.print("Humidity: "); Serial.println(humidity);
  Serial.print("Gas: "); Serial.println(gasValue);
  Serial.println("-----------------------");

  delay(20000); // ThingSpeak rule
}
