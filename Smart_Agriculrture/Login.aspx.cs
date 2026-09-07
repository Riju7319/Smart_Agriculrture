using System;
using System.Configuration;
using System.Data.SqlClient;
using System.Net;
using System.Net.Mail;
using System.Security.Cryptography;
using System.Text;

namespace Smart_Agriculrture
{
    public partial class Login : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e) { }

        // ==================== LOGIN ====================
        protected void btnLogin_Click(object sender, EventArgs e)
        {
            string email = txtEmail.Text.Trim();
            string password = txtPassword.Text.Trim();
            string hashedPassword = HashPassword(password);

            string connStr = ConfigurationManager.ConnectionStrings["SmartAgriDB"].ConnectionString;
            using (SqlConnection conn = new SqlConnection(connStr))
            {
                string query = "SELECT id, full_name FROM farmers WHERE email = @email AND password_hash = @passwordHash";

                using (SqlCommand cmd = new SqlCommand(query, conn))
                {
                    cmd.Parameters.AddWithValue("@email", email);
                    cmd.Parameters.AddWithValue("@passwordHash", hashedPassword);

                    conn.Open();
                    SqlDataReader reader = cmd.ExecuteReader();

                    if (reader.Read())
                    {
                        Session["FarmerID"] = reader["id"];
                        Session["FarmerName"] = reader["full_name"];
                        Response.Redirect("WeatherData/ViewSensoreData.aspx");
                    }
                    else
                    {
                        lblMessage.Text = "Invalid email or password.";
                        lblMessage.CssClass = "message message-error";
                        lblMessage.Visible = true;
                    }
                }
            }
        }

        // ==================== FORGOT PASSWORD NAVIGATION ====================
        protected void lnkForgotPassword_Click(object sender, EventArgs e)
        {
            ShowPanel("ForgotEmail");
        }

        protected void lnkBackToLogin_Click(object sender, EventArgs e)
        {
            // Clear session data related to forgot password
            Session.Remove("ResetOTP");
            Session.Remove("ResetEmail");
            Session.Remove("OtpExpiry");
            ShowPanel("Login");
        }

        // ==================== STEP 1: SEND OTP ====================
        protected void btnSendOtp_Click(object sender, EventArgs e)
        {
            string email = txtForgotEmail.Text.Trim();

            if (string.IsNullOrEmpty(email))
            {
                ShowForgotEmailMessage("Please enter your email address.", false);
                return;
            }

            // Check if email exists in database
            string connStr = ConfigurationManager.ConnectionStrings["SmartAgriDB"].ConnectionString;
            bool emailExists = false;

            using (SqlConnection conn = new SqlConnection(connStr))
            {
                string query = "SELECT COUNT(*) FROM farmers WHERE email = @email";
                using (SqlCommand cmd = new SqlCommand(query, conn))
                {
                    cmd.Parameters.AddWithValue("@email", email);
                    conn.Open();
                    int count = (int)cmd.ExecuteScalar();
                    emailExists = count > 0;
                }
            }

            if (!emailExists)
            {
                ShowForgotEmailMessage("No account found with this email address.", false);
                return;
            }

            // Generate and send OTP
            string otp = GenerateOtp();
            Session["ResetOTP"] = otp;
            Session["ResetEmail"] = email;
            Session["OtpExpiry"] = DateTime.Now.AddMinutes(10);

            try
            {
                string subject = "🔐 Smart Agriculture - Password Reset Code";
                string body = $@"
                    <div style='font-family: Inter, Arial, sans-serif; max-width: 500px; margin: auto; padding: 30px; background: #f9fafb; border-radius: 12px;'>
                        <h2 style='color: #1a1a2e; text-align: center;'>Password Reset</h2>
                        <p style='color: #374151; font-size: 15px;'>You requested a password reset for your Smart Agriculture account. Use the verification code below:</p>
                        <div style='text-align: center; margin: 25px 0;'>
                            <span style='display: inline-block; background: linear-gradient(135deg, #2563eb, #1d4ed8); color: white; font-size: 32px; font-weight: 700; letter-spacing: 8px; padding: 15px 30px; border-radius: 10px;'>{otp}</span>
                        </div>
                        <p style='color: #6b7280; font-size: 13px; text-align: center;'>This code expires in <strong>10 minutes</strong>. Do not share it with anyone.</p>
                        <hr style='border: none; border-top: 1px solid #e5e7eb; margin: 20px 0;' />
                        <p style='color: #9ca3af; font-size: 12px; text-align: center;'>If you didn't request this, please ignore this email.</p>
                    </div>";

                SendEmail(email, subject, body);

                // Move to OTP verification panel
                lblMaskedEmail.Text = MaskEmail(email);
                ShowPanel("VerifyOtp");
            }
            catch (Exception)
            {
                ShowForgotEmailMessage("Failed to send verification code. Please try again.", false);
            }
        }

        // ==================== STEP 2: VERIFY OTP ====================
        protected void btnVerifyOtp_Click(object sender, EventArgs e)
        {
            string enteredOtp = txtOtp.Text.Trim();

            if (string.IsNullOrEmpty(enteredOtp))
            {
                ShowOtpMessage("Please enter the verification code.", false);
                return;
            }

            // Check expiry
            if (Session["OtpExpiry"] != null)
            {
                DateTime expiry = (DateTime)Session["OtpExpiry"];
                if (DateTime.Now > expiry)
                {
                    ShowOtpMessage("Verification code has expired. Please request a new one.", false);
                    return;
                }
            }

            string storedOtp = Session["ResetOTP"]?.ToString();

            if (enteredOtp == storedOtp)
            {
                ShowPanel("ResetPassword");
            }
            else
            {
                ShowOtpMessage("Invalid verification code. Please try again.", false);
            }
        }

        // ==================== RESEND OTP ====================
        protected void btnResendOtp_Click(object sender, EventArgs e)
        {
            string email = Session["ResetEmail"]?.ToString();

            if (string.IsNullOrEmpty(email))
            {
                ShowPanel("ForgotEmail");
                return;
            }

            // Generate new OTP
            string otp = GenerateOtp();
            Session["ResetOTP"] = otp;
            Session["OtpExpiry"] = DateTime.Now.AddMinutes(10);

            try
            {
                string subject = "🔐 Smart Agriculture - New Verification Code";
                string body = $@"
                    <div style='font-family: Inter, Arial, sans-serif; max-width: 500px; margin: auto; padding: 30px; background: #f9fafb; border-radius: 12px;'>
                        <h2 style='color: #1a1a2e; text-align: center;'>New Verification Code</h2>
                        <p style='color: #374151; font-size: 15px;'>Here is your new verification code:</p>
                        <div style='text-align: center; margin: 25px 0;'>
                            <span style='display: inline-block; background: linear-gradient(135deg, #2563eb, #1d4ed8); color: white; font-size: 32px; font-weight: 700; letter-spacing: 8px; padding: 15px 30px; border-radius: 10px;'>{otp}</span>
                        </div>
                        <p style='color: #6b7280; font-size: 13px; text-align: center;'>This code expires in <strong>10 minutes</strong>.</p>
                    </div>";

                SendEmail(email, subject, body);

                lblMaskedEmail.Text = MaskEmail(email);
                ShowOtpMessage("A new verification code has been sent!", true);
            }
            catch (Exception)
            {
                ShowOtpMessage("Failed to resend code. Please try again.", false);
            }
        }

        // ==================== STEP 3: RESET PASSWORD ====================
        protected void btnResetPassword_Click(object sender, EventArgs e)
        {
            string newPassword = txtNewPassword.Text.Trim();
            string confirmPassword = txtConfirmPassword.Text.Trim();

            if (string.IsNullOrEmpty(newPassword) || string.IsNullOrEmpty(confirmPassword))
            {
                ShowResetMessage("Please fill in both password fields.", false);
                return;
            }

            if (newPassword.Length < 6)
            {
                ShowResetMessage("Password must be at least 6 characters long.", false);
                return;
            }

            if (newPassword != confirmPassword)
            {
                ShowResetMessage("Passwords do not match.", false);
                return;
            }

            string email = Session["ResetEmail"]?.ToString();
            if (string.IsNullOrEmpty(email))
            {
                ShowResetMessage("Session expired. Please start over.", false);
                return;
            }

            string hashedPassword = HashPassword(newPassword);

            try
            {
                string connStr = ConfigurationManager.ConnectionStrings["SmartAgriDB"].ConnectionString;
                using (SqlConnection conn = new SqlConnection(connStr))
                {
                    string query = "UPDATE farmers SET password_hash = @passwordHash WHERE email = @email";
                    using (SqlCommand cmd = new SqlCommand(query, conn))
                    {
                        cmd.Parameters.AddWithValue("@passwordHash", hashedPassword);
                        cmd.Parameters.AddWithValue("@email", email);
                        conn.Open();
                        int rowsAffected = cmd.ExecuteNonQuery();

                        if (rowsAffected > 0)
                        {
                            // Clear session data
                            Session.Remove("ResetOTP");
                            Session.Remove("ResetEmail");
                            Session.Remove("OtpExpiry");

                            // Show success on login panel
                            ShowPanel("Login");
                            lblMessage.Text = "✅ Password reset successfully! Please login with your new password.";
                            lblMessage.CssClass = "message message-success";
                            lblMessage.Visible = true;
                        }
                        else
                        {
                            ShowResetMessage("Failed to reset password. Please try again.", false);
                        }
                    }
                }
            }
            catch (Exception)
            {
                ShowResetMessage("An error occurred. Please try again.", false);
            }
        }

        // ==================== HELPER METHODS ====================

        private string HashPassword(string password)
        {
            using (SHA256 sha256 = SHA256.Create())
            {
                byte[] bytes = sha256.ComputeHash(Encoding.UTF8.GetBytes(password));
                StringBuilder builder = new StringBuilder();
                foreach (byte b in bytes)
                    builder.Append(b.ToString("x2"));
                return builder.ToString();
            }
        }

        // Email Configuration Layer
        private void SendEmail(string toEmail, string subject, string bodyHtml)
        {
            MailMessage mail = new MailMessage();
            mail.From = new MailAddress("cherrysoftwerestore@gmail.com");
            mail.To.Add(toEmail);
            mail.Subject = subject;
            mail.Body = bodyHtml;
            mail.IsBodyHtml = true;

            SmtpClient smtp = new SmtpClient("smtp.gmail.com", 587);
            smtp.Credentials = new NetworkCredential("cherrysoftwerestore@gmail.com", "pzez vgdp wvhs uxmj");
            smtp.EnableSsl = true;

            smtp.Send(mail);
        }

        private string GenerateOtp()
        {
            Random random = new Random();
            return random.Next(100000, 999999).ToString();
        }

        private string MaskEmail(string email)
        {
            if (string.IsNullOrEmpty(email) || !email.Contains("@"))
                return email;

            string[] parts = email.Split('@');
            string name = parts[0];
            string domain = parts[1];

            if (name.Length <= 2)
                return name + "***@" + domain;

            return name.Substring(0, 2) + new string('*', Math.Min(name.Length - 2, 5)) + "@" + domain;
        }

        private void ShowPanel(string panelName)
        {
            pnlLogin.Visible = panelName == "Login";
            pnlForgotEmail.Visible = panelName == "ForgotEmail";
            pnlVerifyOtp.Visible = panelName == "VerifyOtp";
            pnlResetPassword.Visible = panelName == "ResetPassword";

            // Reset messages
            lblMessage.Visible = false;
            lblForgotEmailMsg.Visible = false;
            lblOtpMsg.Visible = false;
            lblResetMsg.Visible = false;
        }

        private void ShowForgotEmailMessage(string message, bool isSuccess)
        {
            lblForgotEmailMsg.Text = message;
            lblForgotEmailMsg.CssClass = isSuccess ? "message message-success" : "message message-error";
            lblForgotEmailMsg.Visible = true;
        }

        private void ShowOtpMessage(string message, bool isSuccess)
        {
            lblOtpMsg.Text = message;
            lblOtpMsg.CssClass = isSuccess ? "message message-success" : "message message-error";
            lblOtpMsg.Visible = true;
        }

        private void ShowResetMessage(string message, bool isSuccess)
        {
            lblResetMsg.Text = message;
            lblResetMsg.CssClass = isSuccess ? "message message-success" : "message message-error";
            lblResetMsg.Visible = true;
        }
    }
}
