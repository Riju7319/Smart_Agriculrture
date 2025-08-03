<%@ Page Title="About" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="About.aspx.cs" Inherits="Smart_Agriculrture.About" %>

<asp:Content ID="BodyContent" ContentPlaceHolderID="MainContent" runat="server">
    <div class="container mt-5">

    <!-- Hero / Banner -->
    <div class="mb-4">
        <img src="/Projects/Irrigation_System/Images/about-banner.jpg" class="img-fluid rounded shadow" alt="About Us Banner">
    </div>

    <!-- About Project -->
    <div class="card shadow mb-4">
        <div class="card-body">
            <h2 class="mb-3">About Us</h2>
            <p>
                We are a passionate team of engineering students and innovators dedicated to solving real-world agricultural challenges through technology.
                Our IoT-based Smart Irrigation System was built to help farmers monitor crops, automate watering, and make better decisions using real-time data.
            </p>
            <img src="/Projects/Irrigation_System/Images/system-overview.jpg" class="img-fluid rounded mt-3 mb-2" alt="System Overview">
        </div>
    </div>

    <!-- Vision -->
    <div class="card shadow mb-4">
        <div class="card-body">
            <h4 class="mb-2">Our Vision</h4>
            <p>
                To empower farmers with intelligent, data-driven tools that enhance crop productivity, reduce water usage, and promote sustainable farming using affordable IoT solutions.
            </p>
            <img src="/Projects/Irrigation_System/Images/future-farming.jpg" class="img-fluid rounded mt-2" alt="Future Farming Vision">
        </div>
    </div>

    <!-- Team -->
    <div class="card shadow mb-4">
        <div class="card-body">
            <h4 class="mb-2">Our Team</h4>
            <div class="row">
                <div class="col-md-3 text-center">
                    <img src="/Projects/Irrigation_System/Images/team1.jpg" class="img-thumbnail mb-2" alt="Team Member">
                    <p><strong>[Your Name]</strong><br>Project Lead</p>
                </div>
                <div class="col-md-3 text-center">
                    <img src="/Projects/Irrigation_System/Images/team2.jpg" class="img-thumbnail mb-2" alt="Team Member">
                    <p><strong>[Name]</strong><br>Hardware Designer</p>
                </div>
                <div class="col-md-3 text-center">
                    <img src="/Projects/Irrigation_System/Images/team3.jpg" class="img-thumbnail mb-2" alt="Team Member">
                    <p><strong>[Name]</strong><br>Software Developer</p>
                </div>
                <div class="col-md-3 text-center">
                    <img src="/Projects/Irrigation_System/Images/team4.jpg" class="img-thumbnail mb-2" alt="Team Member">
                    <p><strong>[Name]</strong><br>Documentation & Testing</p>
                </div>
            </div>
        </div>
    </div>

    <!-- Get in Touch -->
    <div class="card shadow">
        <div class="card-body">
            <h4 class="mb-2">Get in Touch</h4>
            <p>Want to know more or try a demo? <a href="Contact.aspx">Reach out to us here</a>.</p>
        </div>
    </div>

</div>

</asp:Content>
