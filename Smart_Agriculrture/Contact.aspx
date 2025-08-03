<%@ Page Title="Contact" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="Contact.aspx.cs" Inherits="Smart_Agriculrture.Contact" %>

<asp:Content ID="BodyContent" ContentPlaceHolderID="MainContent" runat="server">
<div class="container mt-5">
    
    <!-- Page Title -->
    <div class="text-center mb-4">
        <h2>Contact Us</h2>
        <p class="text-muted">We'd love to hear from you! Send us your questions, feedback, or suggestions.</p>
    </div>

    <!-- Contact Form -->
    <div class="row">
        <div class="col-md-7 mb-4">
            <div class="card shadow">
                <div class="card-body">
                    <form method="post" action="#">
                        <div class="mb-3">
                            <label for="name" class="form-label">Your Name</label>
                            <input type="text" class="form-control" id="name" required />
                        </div>
                        <div class="mb-3">
                            <label for="email" class="form-label">Your Email</label>
                            <input type="email" class="form-control" id="email" required />
                        </div>
                        <div class="mb-3">
                            <label for="subject" class="form-label">Subject</label>
                            <input type="text" class="form-control" id="subject" required />
                        </div>
                        <div class="mb-3">
                            <label for="message" class="form-label">Message</label>
                            <textarea class="form-control" id="message" rows="5" required></textarea>
                        </div>
                        <button type="submit" class="btn btn-primary">Send Message</button>
                    </form>
                </div>
            </div>
        </div>

        <!-- Contact Info -->
        <div class="col-md-5">
            <div class="card shadow mb-4">
                <div class="card-body">
                    <h5>Our Contact Information</h5>
                    <p><strong>Email:</strong> support@smartirrigation.com</p>
                    <p><strong>Phone:</strong> +91-9876543210</p>
                    <p><strong>Address:</strong> Department of Electronics, Your College Name, Your City</p>
                </div>
            </div>

            <!-- Optional Map -->
            <div class="card shadow">
                <div class="card-body p-2">
                    <iframe 
                    
                    <iframe src="https://www.google.com/maps/embed?pb=!1m18!1m12!1m3!1d2360.036089204804!2d87.32535380140635!3d22.422905701394264!2m3!1f0!2f0!3f0!3m2!1i1024!2i768!4f13.1!3m3!1m2!1s0x3a1d5b3a26a2a285%3A0x3a0f069d18ed36ce!2sCollege%20Rd%2C%20Midnapore%2C%20West%20Bengal%20721101!5e1!3m2!1sen!2sin!4v1754253314366!5m2!1sen!2sin" 
                        width="100%" height="250" style="border:0;" allowfullscreen="" loading="lazy"referrerpolicy="no-referrer-when-downgrade"></iframe>
                </div>
            </div>
        </div>
    </div>
</div>

</asp:Content>
