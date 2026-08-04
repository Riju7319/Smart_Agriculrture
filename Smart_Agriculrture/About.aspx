<%@ Page Title="About" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="About.aspx.cs"
    Inherits="Smart_Agriculrture.About" %>

    <asp:Content ID="BodyContent" ContentPlaceHolderID="MainContent" runat="server">
        <!-- Hero Section -->
        <div class="row align-items-center mb-5 py-5 rounded-3 bg-light shadow-sm">
            <div class="col-lg-6 p-5">
                <h1 class="display-4 fw-bold">About Smart Agriculture</h1>
                <p class="lead text-muted">Innovating the future of farming with IoT and Data Analytics.</p>
                <p>We are a passionate team of engineering students dedicated to solving real-world agricultural
                    challenges. Our mission is to empower farmers with affordable, intelligent tools.</p>
            </div>
            <div class="col-lg-6">
                <img src="/Projects/Irrigation_System/Images/about-banner.jpg"
                    class="d-block mx-lg-auto img-fluid rounded shadow" alt="Smart Farming" width="700" height="500"
                    loading="lazy">
            </div>
        </div>

        <!-- Vision Section -->
        <div class="row g-4 py-5 row-cols-1 row-cols-lg-3">
            <div class="col d-flex align-items-start">
                <div class="icon-square bg-light text-dark flex-shrink-0 me-3">
                    <i class="bi bi-cpu fs-2"></i>
                    <!-- Assuming Bootstrap Icons are available, or placeholders if not -->
                </div>
                <div>
                    <h3 class="fs-2">Smart IoT</h3>
                    <p>Automated irrigation systems that monitor real-time soil moisture and temperature to optimize
                        water usage.</p>
                </div>
            </div>
            <div class="col d-flex align-items-start">
                <div class="icon-square bg-light text-dark flex-shrink-0 me-3">
                    <i class="bi bi-graph-up fs-2"></i>
                </div>
                <div>
                    <h3 class="fs-2">Data Driven</h3>
                    <p>Advanced analytics and reporting tools to help NGOs and farmers make informed decisions for
                        better yields.</p>
                </div>
            </div>
            <div class="col d-flex align-items-start">
                <div class="icon-square bg-light text-dark flex-shrink-0 me-3">
                    <i class="bi bi-people fs-2"></i>
                </div>
                <div>
                    <h3 class="fs-2">Sustainability</h3>
                    <p>Promoting eco-friendly farming practices that reduce waste and conserve environmental resources.
                    </p>
                </div>
            </div>
        </div>

        <!-- Developer Section -->
        <div class="pricing-header p-3 pb-md-4 mx-auto text-center mt-4">
            <h2 class="display-5 fw-normal">Meet the Developer</h2>
            <p class="fs-5 text-muted">The mind behind the innovation.</p>
        </div>

        <div class="row justify-content-center mb-5">
            <div class="col-md-6 col-lg-4">
                <div class="card rounded-3 shadow-sm border-0">
                    <div class="card-body text-center p-4">
                        <img src="Portfolio/heroiamge.png" class="rounded-circle mb-3 shadow-sm" width="150"
                            height="150" style="object-fit: cover;" alt="Riju Karmakar">
                        <h3 class="card-title mb-1">Riju Karmakar</h3>
                        <p class="text-primary fw-bold mb-3">Full Stack Developer & IoT Engineer</p>
                        <p class="card-text text-muted">A passionate software engineer building scalable web
                            applications and smart IoT solutions. I designed and developed this entire platform to
                            transform rural agriculture.</p>
                        <a href="Portfolio/index.html" class="btn btn-outline-primary mt-3">View Portfolio</a>
                    </div>
                </div>
            </div>
        </div>

        <!-- CTA Section -->
        <div class="bg-dark text-secondary px-4 py-5 text-center mt-5 rounded-3">
            <div class="py-5">
                <h1 class="display-5 fw-bold text-white">Interested in our work?</h1>
                <div class="col-lg-6 mx-auto">
                    <p class="fs-5 mb-4">We are always looking for collaboration opportunities. Check out our latest
                        projects or get in touch for a demo.</p>
                    <div class="d-grid gap-2 d-sm-flex justify-content-sm-center">
                        <a href="Contact.aspx" class="btn btn-outline-info btn-lg px-4 me-sm-3 fw-bold">Contact Us</a>
                        <a href="~/" runat="server" class="btn btn-outline-light btn-lg px-4">View Projects</a>
                    </div>
                </div>
            </div>
        </div>

    </asp:Content>