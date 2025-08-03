<%@ Page Title="Irrigation System" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="IrrigationSystem.aspx.cs" Inherits="Smart_Agriculrture.WebForm2" %>

<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">
    <div class="container py-5">
        <h2 class="text-center mb-4">Smart IoT-Based Irrigation System</h2>

      <!-- Introduction Section -->
<div class="card mb-4 shadow">
    <div class="card-body">
        <h4 class="mb-3">Project Overview</h4>
        <p>
            This innovative IoT-based Smart Agriculture System is a prototype developed to revolutionize traditional farming by leveraging the power of sensor technology and automation. 
            The system is built around the <strong>Arduino UNO microcontroller</strong> and is designed to help farmers remotely monitor and manage crucial agricultural parameters in real-time.
        </p>
        <p>
            The device is equipped with a series of sensors that measure <strong>soil moisture, air temperature, humidity, light intensity,</strong> and the presence of <strong>harmful gases or smoke</strong>. 
            These parameters are vital for ensuring healthy crop growth and preventing damage from adverse environmental conditions.
        </p>
        <p>
            One of the key advantages of this system is its ability to make smart decisions without manual intervention. 
            For example, if the soil moisture drops below a specific threshold, the system can automatically <strong>activate a water pump</strong> for irrigation. 
            Similarly, it can turn on a fan if the temperature or humidity crosses safe limits, or trigger alerts in the presence of dangerous gases.
        </p>
        <p>
            The data collected by the sensors is sent to a central system or cloud platform, allowing farmers to access and analyze the environmental conditions of their farmland through a web or mobile interface. 
            This improves decision-making, saves water and energy, and significantly boosts crop productivity.
        </p>
        <p>
            With its low-cost hardware and scalability, this prototype is ideal for both small and large-scale farms. 
            It also serves as an educational model for students and researchers interested in smart agriculture, embedded systems, or environmental automation.
        </p>
    </div>
</div>


        <!-- PDF Download Button -->
        <div class="mb-5 d-flex flex-column flex-sm-row align-items-sm-center gap-2">
            <h5 class="mb-0">System Documentation:</h5>
            <a href="/Projects/Irrigation_System/Project estimate .pdf" target="_blank" class="btn btn-success">
                📥 Download Project Estimate PDF
            </a>
        </div>

        <!-- Use Case Section -->
        <h4 class="mb-3">Use Cases</h4>
        <ul class="list-group mb-4">
            <li class="list-group-item">✅ Smart irrigation without manual effort</li>
            <li class="list-group-item">✅ Maintains temperature for sensitive crops</li>
            <li class="list-group-item">✅ Real-time alerts to the farmer via software</li>
            <li class="list-group-item">✅ Predictive weather updates from external API</li>
            <li class="list-group-item">✅ No human needed for soil/water/pump checks</li>
            <li class="list-group-item">✅ Detects rotting crops via gas sensor</li>
        </ul>

        <!-- Prototype Diagram -->
        <h4 class="mb-3">Prototype Diagram</h4>
        <div class="text-center mb-4">
            <img src="/Projects/Irrigation_System/diagram arduino ino.png" alt="System Diagram" class="img-fluid rounded shadow w-100" style="max-width: 600px;" />
        </div>

        <!-- Project Video -->
        <h4 class="mb-3">Project Demonstration Video</h4>
        <div class="ratio ratio-16x9 mb-4">
            <video controls class="w-100 rounded shadow">
                <source src="/Projects/Irrigation_System/pv.mp4" type="video/mp4">
                Your browser does not support the video tag.
            </video>
        </div>

        <!-- Project Screenshots -->
        <h4 class="mb-3">Software Screenshots</h4>
        <div class="row mb-4">
            <div class="col-12 col-md-6 col-lg-4 mb-3">
                <img src="/Projects/Irrigation_System/soft.png" class="img-fluid img-thumbnail" alt="Screenshot 1">
            </div>
            <div class="col-12 col-md-6 col-lg-4 mb-3">
                <img src="/Projects/Irrigation_System/newsoft.png" class="img-fluid img-thumbnail" alt="Screenshot 2">
            </div>
        </div>

        <!-- Software Download -->
        <h4 class="mb-3">Software Link</h4>
        <div class="mb-4">
            <a href="https://drive.google.com/drive/u/1/folders/1Gg_i6pazMhoAl57XQrS_KSt54jsAkhPs" target="_blank" class="btn btn-success">📦 View or Download Software</a>
        </div>

        <!-- Source Code Button -->
        <h4 class="mb-3">Source Code</h4>
        <div class="mb-5">
            <a href="/Projects/Irrigation_System/final project code.txt" class="btn btn-primary">👨‍💻 View Source Code</a>
        </div>

        <!-- Conclusion -->
        <h4 class="mb-3">Conclusion</h4>
        <div class="card shadow mb-5">
            <div class="card-body">
                <p>
                    This prototype demonstrates how IoT can revolutionize traditional farming. With smart monitoring and automation, 
                    farmers can save water, improve crop quality, and reduce dependency on manual labor. This solution is scalable and adaptable for all types of farms.
                </p>
            </div>
        </div>
    </div>
</asp:Content>
