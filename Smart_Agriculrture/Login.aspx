<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="Login.aspx.cs" Inherits="Smart_Agriculrture.Login" %>

<!DOCTYPE html>
    <html xmlns="http://www.w3.org/1999/xhtml">

    <head runat="server">
        <title>Farmer Login</title>
        <meta name="viewport" content="width=device-width, initial-scale=1" />
        <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700&display=swap"
            rel="stylesheet" />
        <style>
            * {
                box-sizing: border-box;
                margin: 0;
                padding: 0;
            }

            body {
                font-family: 'Inter', Arial, sans-serif;
                min-height: 100vh;
                display: flex;
                align-items: center;
                justify-content: center;
                background: linear-gradient(135deg, #0f2027 0%, #203a43 50%, #2c5364 100%);
                padding: 20px;
            }

            .login-container {
                max-width: 440px;
                width: 100%;
                margin: auto;
                background: rgba(255, 255, 255, 0.95);
                backdrop-filter: blur(10px);
                padding: 40px 35px;
                border-radius: 16px;
                box-shadow: 0 20px 60px rgba(0, 0, 0, 0.3), 0 0 0 1px rgba(255, 255, 255, 0.1);
                animation: slideUp 0.5s ease-out;
            }

            @keyframes slideUp {
                from {
                    opacity: 0;
                    transform: translateY(30px);
                }

                to {
                    opacity: 1;
                    transform: translateY(0);
                }
            }

            h2 {
                text-align: center;
                margin-bottom: 8px;
                font-size: 26px;
                font-weight: 700;
                color: #1a1a2e;
            }

            .subtitle {
                text-align: center;
                color: #6b7280;
                font-size: 14px;
                margin-bottom: 30px;
            }

            label {
                display: block;
                margin-top: 18px;
                font-weight: 500;
                color: #374151;
                font-size: 14px;
            }

            input[type="text"],
            input[type="password"],
            input[type="email"] {
                width: 100%;
                padding: 12px 14px;
                margin-top: 6px;
                border: 1.5px solid #d1d5db;
                border-radius: 8px;
                font-size: 15px;
                font-family: 'Inter', Arial, sans-serif;
                transition: border-color 0.2s, box-shadow 0.2s;
                outline: none;
                background: #f9fafb;
            }

            input[type="text"]:focus,
            input[type="password"]:focus,
            input[type="email"]:focus {
                border-color: #2563eb;
                box-shadow: 0 0 0 3px rgba(37, 99, 235, 0.15);
                background: #fff;
            }

            .btn-login {
                background: linear-gradient(135deg, #2563eb, #1d4ed8);
                color: white;
                padding: 13px;
                margin-top: 24px;
                width: 100%;
                border: none;
                border-radius: 8px;
                font-size: 16px;
                font-weight: 600;
                cursor: pointer;
                transition: transform 0.15s, box-shadow 0.2s;
                font-family: 'Inter', Arial, sans-serif;
            }

            .btn-login:hover {
                transform: translateY(-1px);
                box-shadow: 0 6px 20px rgba(37, 99, 235, 0.4);
            }

            .btn-login:active {
                transform: translateY(0);
            }

            .btn-secondary {
                background: linear-gradient(135deg, #6b7280, #4b5563);
                color: white;
                padding: 13px;
                margin-top: 12px;
                width: 100%;
                border: none;
                border-radius: 8px;
                font-size: 15px;
                font-weight: 600;
                cursor: pointer;
                transition: transform 0.15s, box-shadow 0.2s;
                font-family: 'Inter', Arial, sans-serif;
            }

            .btn-secondary:hover {
                transform: translateY(-1px);
                box-shadow: 0 4px 14px rgba(107, 114, 128, 0.4);
            }

            .btn-success {
                background: linear-gradient(135deg, #059669, #047857);
                color: white;
                padding: 13px;
                margin-top: 24px;
                width: 100%;
                border: none;
                border-radius: 8px;
                font-size: 16px;
                font-weight: 600;
                cursor: pointer;
                transition: transform 0.15s, box-shadow 0.2s;
                font-family: 'Inter', Arial, sans-serif;
            }

            .btn-success:hover {
                transform: translateY(-1px);
                box-shadow: 0 6px 20px rgba(5, 150, 105, 0.4);
            }

            .message {
                text-align: center;
                font-weight: 600;
                margin-top: 16px;
                font-size: 14px;
                padding: 10px;
                border-radius: 8px;
            }

            .message-error {
                color: #dc2626;
                background: #fef2f2;
                border: 1px solid #fecaca;
            }

            .message-success {
                color: #059669;
                background: #ecfdf5;
                border: 1px solid #a7f3d0;
            }

            .link-container {
                text-align: center;
                margin-top: 24px;
                display: flex;
                flex-direction: column;
                gap: 10px;
            }

            .link-container a,
            .link-container .forgot-link {
                color: #2563eb;
                text-decoration: none;
                font-size: 14px;
                font-weight: 500;
                transition: color 0.2s;
                cursor: pointer;
            }

            .link-container a:hover,
            .link-container .forgot-link:hover {
                color: #1d4ed8;
                text-decoration: underline;
            }

            .link-row {
                display: flex;
                justify-content: center;
                gap: 20px;
            }

            .link-row a {
                color: #6b7280;
            }

            .link-row a:hover {
                color: #2563eb;
            }

            /* Divider */
            .divider {
                display: flex;
                align-items: center;
                margin: 20px 0 0 0;
            }

            .divider::before,
            .divider::after {
                content: '';
                flex: 1;
                height: 1px;
                background: #e5e7eb;
            }

            .divider span {
                padding: 0 12px;
                color: #9ca3af;
                font-size: 13px;
                font-weight: 500;
            }

            /* Step Indicator */
            .step-indicator {
                display: flex;
                justify-content: center;
                gap: 8px;
                margin-bottom: 28px;
            }

            .step-dot {
                width: 10px;
                height: 10px;
                border-radius: 50%;
                background: #d1d5db;
                transition: background 0.3s, transform 0.3s;
            }

            .step-dot.active {
                background: #2563eb;
                transform: scale(1.3);
            }

            .step-dot.done {
                background: #059669;
            }

            /* Back link */
            .back-link {
                display: inline-block;
                margin-bottom: 16px;
                color: #6b7280;
                font-size: 13px;
                font-weight: 500;
                cursor: pointer;
                text-decoration: none;
                transition: color 0.2s;
            }

            .back-link:hover {
                color: #2563eb;
            }

            /* Icon */
            .panel-icon {
                text-align: center;
                font-size: 40px;
                margin-bottom: 10px;
            }

            /* OTP Input */
            .otp-note {
                text-align: center;
                font-size: 13px;
                color: #6b7280;
                margin-top: 8px;
                line-height: 1.5;
            }

            .otp-note strong {
                color: #1a1a2e;
            }

            /* Timer */
            .timer-text {
                text-align: center;
                font-size: 13px;
                color: #9ca3af;
                margin-top: 10px;
            }
        </style>
    </head>

    <body>
        <form id="form1" runat="server">
            <div class="login-container">

                <%--====================LOGIN PANEL====================--%>
                    <asp:Panel ID="pnlLogin" runat="server" Visible="true">
                        <div class="panel-icon">🌾</div>
                        <h2>Welcome Back</h2>
                        <p class="subtitle">Sign in to your Smart Agriculture account</p>

                        <label>Email</label>
                        <asp:TextBox ID="txtEmail" runat="server" TextMode="Email" placeholder="Enter your email" />

                        <label>Password</label>
                        <asp:TextBox ID="txtPassword" runat="server" TextMode="Password"
                            placeholder="Enter your password" />

                        <asp:Button ID="btnLogin" runat="server" Text="Login" CssClass="btn-login"
                            OnClick="btnLogin_Click" />

                        <div class="link-container">
                            <asp:LinkButton ID="lnkForgotPassword" runat="server" CssClass="forgot-link"
                                OnClick="lnkForgotPassword_Click" CausesValidation="false">
                                🔒 Forgot Password?
                            </asp:LinkButton>
                            <div class="divider"><span>or</span></div>
                            <div class="link-row">
                                <a href="Signup.aspx">New user? Sign up</a>
                                <a href="Default.aspx">Back to Home</a>
                            </div>
                        </div>

                        <asp:Label ID="lblMessage" runat="server" CssClass="message message-error" Visible="false" />
                    </asp:Panel>

                    <!-- <%-- ============ STEP 1: ENTER EMAIL FOR OTP ============ --%> -->
                    <asp:Panel ID="pnlForgotEmail" runat="server" Visible="false">
                        <div class="step-indicator">
                            <div class="step-dot active"></div>
                            <div class="step-dot"></div>
                            <div class="step-dot"></div>
                        </div>
                        <asp:LinkButton ID="lnkBackToLogin" runat="server" CssClass="back-link"
                            OnClick="lnkBackToLogin_Click" CausesValidation="false">
                            ← Back to Login
                        </asp:LinkButton>
                        <div class="panel-icon">📧</div>
                        <h2>Forgot Password</h2>
                        <p class="subtitle">Enter your registered email address and we'll send you a verification code
                        </p>

                        <label>Email Address</label>
                        <asp:TextBox ID="txtForgotEmail" runat="server" TextMode="Email"
                            placeholder="Enter your registered email" />

                        <asp:Button ID="btnSendOtp" runat="server" Text="Send Verification Code" CssClass="btn-login"
                            OnClick="btnSendOtp_Click" />

                        <asp:Label ID="lblForgotEmailMsg" runat="server" CssClass="message" Visible="false" />
                    </asp:Panel>

                    <!-- <%-- ============ STEP 2: VERIFY OTP ============ --%> -->
                    <asp:Panel ID="pnlVerifyOtp" runat="server" Visible="false">
                        <div class="step-indicator">
                            <div class="step-dot done"></div>
                            <div class="step-dot active"></div>
                            <div class="step-dot"></div>
                        </div>
                        <asp:LinkButton ID="lnkBackToEmail" runat="server" CssClass="back-link"
                            OnClick="lnkForgotPassword_Click" CausesValidation="false">
                            ← Back
                        </asp:LinkButton>
                        <div class="panel-icon">🔑</div>
                        <h2>Verify Code</h2>
                        <p class="subtitle">Enter the 6-digit verification code sent to your email</p>
                        <p class="otp-note">Code sent to <strong>
                                <asp:Label ID="lblMaskedEmail" runat="server" />
                            </strong></p>

                        <label>Verification Code</label>
                        <asp:TextBox ID="txtOtp" runat="server" placeholder="Enter 6-digit code" MaxLength="6" />

                        <asp:Button ID="btnVerifyOtp" runat="server" Text="Verify Code" CssClass="btn-login"
                            OnClick="btnVerifyOtp_Click" />
                        <asp:Button ID="btnResendOtp" runat="server" Text="Resend Code" CssClass="btn-secondary"
                            OnClick="btnResendOtp_Click" CausesValidation="false" />

                        <asp:Label ID="lblOtpMsg" runat="server" CssClass="message" Visible="false" />
                    </asp:Panel>

                    <!-- <%-- ============ STEP 3: RESET PASSWORD ============ --%> -->
                    <asp:Panel ID="pnlResetPassword" runat="server" Visible="false">
                        <div class="step-indicator">
                            <div class="step-dot done"></div>
                            <div class="step-dot done"></div>
                            <div class="step-dot active"></div>
                        </div>
                        <div class="panel-icon">🔐</div>
                        <h2>Reset Password</h2>
                        <p class="subtitle">Create a new password for your account</p>

                        <label>New Password</label>
                        <asp:TextBox ID="txtNewPassword" runat="server" TextMode="Password"
                            placeholder="Enter new password" />

                        <label>Confirm Password</label>
                        <asp:TextBox ID="txtConfirmPassword" runat="server" TextMode="Password"
                            placeholder="Confirm new password" />

                        <asp:Button ID="btnResetPassword" runat="server" Text="Reset Password" CssClass="btn-success"
                            OnClick="btnResetPassword_Click" />

                        <asp:Label ID="lblResetMsg" runat="server" CssClass="message" Visible="false" />
                    </asp:Panel>

            </div>
        </form>
    </body>

    </html>