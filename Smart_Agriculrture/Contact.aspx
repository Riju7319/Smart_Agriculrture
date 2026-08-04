<%@ Page Title="Contact" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true"
    CodeBehind="Contact.aspx.cs" Inherits="Smart_Agriculrture.Contact" %>

    <asp:Content ID="BodyContent" ContentPlaceHolderID="MainContent" runat="server">
        <div class="container py-5">

            <!-- Header -->
            <div class="text-center mb-5">
                <h1 class="display-4 fw-bold">Get In Touch</h1>
                <p class="lead text-muted">Have a question or want to collaborate? We'd love to hear from you.</p>
            </div>

            <div class="row g-5">
                <!-- Contact Form -->
                <div class="col-lg-7">
                    <div class="card border-0 shadow-sm rounded-3 h-100">
                        <div class="card-body p-4 p-md-5">
                            <h3 class="mb-4">Send us a Message</h3>
                            <form>
                                <div class="row g-3">
                                    <div class="col-md-6">
                                        <label for="name" class="form-label">Values Name</label>
                                        <input type="text" class="form-control bg-light border-0 py-3" id="name"
                                            placeholder="Your Name" required>
                                    </div>
                                    <div class="col-md-6">
                                        <label for="email" class="form-label">Email</label>
                                        <input type="email" class="form-control bg-light border-0 py-3" id="email"
                                            placeholder="name@example.com" required>
                                    </div>
                                    <div class="col-12">
                                        <label for="subject" class="form-label">Subject</label>
                                        <input type="text" class="form-control bg-light border-0 py-3" id="subject"
                                            placeholder="Project Inquiry" required>
                                    </div>
                                    <div class="col-12">
                                        <label for="message" class="form-label">Message</label>
                                        <textarea class="form-control bg-light border-0 py-3" id="message" rows="5"
                                            placeholder="How can we help you?" required></textarea>
                                    </div>
                                    <div class="col-12 mt-4">
                                        <button type="submit" class="btn btn-primary btn-lg w-100 fw-bold">Send Message
                                            <i class="bi bi-send-fill ms-2"></i></button>
                                    </div>
                                </div>
                            </form>
                        </div>
                    </div>
                </div>

                <!-- Contact Info & Map -->
                <div class="col-lg-5">
                    <div class="d-flex flex-column gap-4 h-100">

                        <!-- Contact Details -->
                        <div class="card border-0 shadow-sm rounded-3">
                            <div class="card-body p-4">
                                <div class="d-flex align-items-center mb-4">
                                    <div class="bg-primary bg-opacity-10 p-3 rounded-circle text-primary me-3">
                                        <i class="bi bi-geo-alt-fill fs-4"></i>
                                    </div>
                                    <div>
                                        <h5 class="mb-1">Our Location</h5>
                                        <p class="mb-0 text-muted">Silda, West Bengal 721515, India</p>
                                    </div>
                                </div>
                                <div class="d-flex align-items-center mb-4">
                                    <div class="bg-primary bg-opacity-10 p-3 rounded-circle text-primary me-3">
                                        <i class="bi bi-envelope-fill fs-4"></i>
                                    </div>
                                    <div>
                                        <h5 class="mb-1">Email Us</h5>
                                        <p class="mb-0 text-muted">rijukarmakar7319@gmail.com</p>
                                    </div>
                                </div>
                                <div class="d-flex align-items-center">
                                    <div class="bg-primary bg-opacity-10 p-3 rounded-circle text-primary me-3">
                                        <i class="bi bi-telephone-fill fs-4"></i>
                                    </div>
                                    <div>
                                        <h5 class="mb-1">Call Us</h5>
                                        <p class="mb-0 text-muted">+91 (Your Number)</p>
                                    </div>
                                </div>
                            </div>
                        </div>

                        <!-- Google Map -->
                        <div class="card border-0 shadow-sm rounded-3 flex-grow-1 overflow-hidden">
                            <iframe
                                src="https://www.google.com/maps/embed?pb=!1m18!1m12!1m3!1d14690.66266367504!2d86.81220459345704!3d22.610582234057635!2m3!1f0!2f0!3f0!3m2!1i1024!2i768!4f13.1!3m3!1m2!1s0x39f60443422634cd%3A0xe62e81112678f244!2sSilda%2C%20West%20Bengal!5e0!3m2!1sen!2sin!4v1705257960000!5m2!1sen!2sin"
                                width="100%" height="100%" style="border:0; min-height: 250px;" allowfullscreen=""
                                loading="lazy" referrerpolicy="no-referrer-when-downgrade">
                            </iframe>
                        </div>

                    </div>
                </div>
            </div>
        </div>

    </asp:Content>