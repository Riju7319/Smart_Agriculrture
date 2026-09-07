<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="SignUp.aspx.cs" Inherits="Smart_Agriculrture.SignUp" %>

<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>Farmer Signup — Smart Agriculture</title>
    <meta name="viewport" content="width=device-width, initial-scale=1" />
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700&display=swap" rel="stylesheet" />
    <style>
        * { box-sizing: border-box; margin: 0; padding: 0; }

        body {
            font-family: 'Inter', Arial, sans-serif;
            min-height: 100vh;
            display: flex;
            align-items: center;
            justify-content: center;
            background: linear-gradient(135deg, #0f2027 0%, #203a43 50%, #2c5364 100%);
            padding: 24px;
        }

        .signup-container {
            max-width: 540px;
            width: 100%;
            margin: auto;
            background: rgba(255, 255, 255, 0.95);
            backdrop-filter: blur(10px);
            padding: 40px 35px 35px;
            border-radius: 16px;
            box-shadow: 0 20px 60px rgba(0, 0, 0, 0.3), 0 0 0 1px rgba(255,255,255,0.1);
            animation: slideUp 0.5s ease-out;
        }

        @keyframes slideUp {
            from { opacity: 0; transform: translateY(30px); }
            to { opacity: 1; transform: translateY(0); }
        }

        .panel-icon {
            text-align: center;
            font-size: 40px;
            margin-bottom: 8px;
        }

        h2 {
            text-align: center;
            margin-bottom: 6px;
            font-size: 26px;
            font-weight: 700;
            color: #1a1a2e;
        }

        .subtitle {
            text-align: center;
            color: #6b7280;
            font-size: 14px;
            margin-bottom: 28px;
        }

        /* ===== Form Grid ===== */
        .form-grid {
            display: grid;
            grid-template-columns: 1fr 1fr;
            gap: 0 18px;
        }

        .form-grid .full-width {
            grid-column: 1 / -1;
        }

        .form-group {
            margin-bottom: 16px;
        }

        label {
            display: block;
            font-weight: 500;
            color: #374151;
            font-size: 13px;
            margin-bottom: 5px;
        }

        /* ===== Inputs ===== */
        input[type="text"],
        input[type="password"],
        input[type="email"],
        input[type="number"],
        input[type="tel"],
        textarea,
        select {
            width: 100%;
            padding: 11px 13px;
            border: 1.5px solid #d1d5db;
            border-radius: 8px;
            font-size: 14px;
            font-family: 'Inter', Arial, sans-serif;
            transition: border-color 0.2s, box-shadow 0.2s;
            outline: none;
            background: #f9fafb;
            color: #1a1a2e;
        }

        input:focus,
        textarea:focus,
        select:focus {
            border-color: #2563eb;
            box-shadow: 0 0 0 3px rgba(37, 99, 235, 0.15);
            background: #fff;
        }

        textarea {
            resize: vertical;
            min-height: 60px;
        }

        select {
            cursor: pointer;
            appearance: none;
            -webkit-appearance: none;
            background-image: url("data:image/svg+xml,%3Csvg xmlns='http://www.w3.org/2000/svg' width='12' height='12' viewBox='0 0 12 12'%3E%3Cpath fill='%236b7280' d='M6 8.825L1.175 4 2.238 2.938 6 6.7 9.763 2.938 10.825 4z'/%3E%3C/svg%3E");
            background-repeat: no-repeat;
            background-position: right 12px center;
            padding-right: 34px;
        }

        /* ===== Checkbox Group (Farming Types) ===== */
        .checkbox-group {
            display: grid;
            grid-template-columns: 1fr 1fr;
            gap: 8px;
        }

        .checkbox-group label {
            display: flex;
            align-items: center;
            gap: 8px;
            padding: 9px 12px;
            border: 1.5px solid #e5e7eb;
            border-radius: 8px;
            cursor: pointer;
            font-size: 13.5px;
            font-weight: 400;
            color: #374151;
            background: #f9fafb;
            transition: all 0.2s;
            margin-bottom: 0;
        }

        .checkbox-group label:hover {
            border-color: #2563eb;
            background: #eff6ff;
        }

        .checkbox-group input[type="checkbox"] {
            width: 16px;
            height: 16px;
            accent-color: #2563eb;
            cursor: pointer;
            flex-shrink: 0;
        }

        .checkbox-group .cb-icon {
            font-size: 16px;
        }

        /* ===== Hidden ListBox (for ASP.NET postback) ===== */
        .hidden-listbox {
            display: none;
        }

        /* ===== Divider ===== */
        .section-divider {
            grid-column: 1 / -1;
            display: flex;
            align-items: center;
            margin: 4px 0 12px;
        }

        .section-divider::before, .section-divider::after {
            content: '';
            flex: 1;
            height: 1px;
            background: #e5e7eb;
        }

        .section-divider span {
            padding: 0 12px;
            color: #9ca3af;
            font-size: 12px;
            font-weight: 600;
            text-transform: uppercase;
            letter-spacing: 0.5px;
        }

        /* ===== Button ===== */
        .btn-signup {
            background: linear-gradient(135deg, #059669, #047857);
            color: white;
            padding: 13px;
            margin-top: 8px;
            width: 100%;
            border: none;
            border-radius: 8px;
            font-size: 16px;
            font-weight: 600;
            cursor: pointer;
            transition: transform 0.15s, box-shadow 0.2s;
            font-family: 'Inter', Arial, sans-serif;
        }

        .btn-signup:hover {
            transform: translateY(-1px);
            box-shadow: 0 6px 20px rgba(5, 150, 105, 0.4);
        }

        .btn-signup:active {
            transform: translateY(0);
        }

        /* ===== Message ===== */
        .message {
            text-align: center;
            font-weight: 600;
            margin-top: 14px;
            font-size: 14px;
            padding: 10px;
            border-radius: 8px;
            color: #059669;
            background: #ecfdf5;
            border: 1px solid #a7f3d0;
        }

        .message-error {
            color: #dc2626;
            background: #fef2f2;
            border: 1px solid #fecaca;
        }

        /* ===== Links ===== */
        .link-container {
            text-align: center;
            margin-top: 20px;
            display: flex;
            justify-content: center;
            gap: 24px;
        }

        .link-container a {
            color: #6b7280;
            text-decoration: none;
            font-size: 14px;
            font-weight: 500;
            transition: color 0.2s;
        }

        .link-container a:hover {
            color: #2563eb;
            text-decoration: underline;
        }

        .link-container a.primary-link {
            color: #2563eb;
        }

        /* ===== Responsive ===== */
        @media (max-width: 520px) {
            .form-grid {
                grid-template-columns: 1fr;
            }
            .checkbox-group {
                grid-template-columns: 1fr;
            }
            .signup-container {
                padding: 28px 20px 24px;
            }
        }
    </style>
</head>
<body>
<form id="form1" runat="server">
    <div class="signup-container">
        <div class="panel-icon">🌱</div>
        <h2>Create Your Account</h2>
        <p class="subtitle">Join Smart Agriculture and start farming smarter</p>

        <div class="form-grid">

            <%-- ===== Personal Information ===== --%>
            <div class="section-divider"><span>Personal Info</span></div>

            <div class="form-group">
                <label>Full Name</label>
                <asp:TextBox ID="txtFullName" runat="server" placeholder="Enter your full name" required="true" />
            </div>

            <div class="form-group">
                <label>Phone</label>
                <asp:TextBox ID="txtPhone" runat="server" TextMode="Phone" placeholder="Enter phone number" required="true" />
            </div>

            <div class="form-group">
                <label>Email</label>
                <asp:TextBox ID="txtEmail" runat="server" TextMode="Email" placeholder="Enter your email" />
            </div>

            <div class="form-group">
                <label>Country</label>
                <asp:TextBox ID="txtCountry" runat="server" placeholder="Enter your country" required="true" />
            </div>

            <div class="form-group full-width">
                <label>Address</label>
                <asp:TextBox ID="txtAddress" runat="server" TextMode="MultiLine" Rows="2" placeholder="Enter your full address" required="true" />
            </div>

            <%-- ===== Farm Details ===== --%>
            <div class="section-divider"><span>Farm Details</span></div>

            <div class="form-group full-width">
                <label>Farming Types</label>
                <div class="checkbox-group">
                    <label><input type="checkbox" id="chkCrop" value="Crop" onclick="syncFarmingTypes()" /><span class="cb-icon">🌾</span> Crop</label>
                    <label><input type="checkbox" id="chkDairy" value="Dairy" onclick="syncFarmingTypes()" /><span class="cb-icon">🐄</span> Dairy</label>
                    <label><input type="checkbox" id="chkPoultry" value="Poultry" onclick="syncFarmingTypes()" /><span class="cb-icon">🐔</span> Poultry</label>
                    <label><input type="checkbox" id="chkFishery" value="Fishery" onclick="syncFarmingTypes()" /><span class="cb-icon">🐟</span> Fishery</label>
                </div>
                <%-- Hidden ListBox to maintain ASP.NET postback compatibility --%>
                <asp:ListBox ID="lstFarmingTypes" runat="server" SelectionMode="Multiple" CssClass="hidden-listbox">
                    <asp:ListItem Text="Crop" Value="Crop" />
                    <asp:ListItem Text="Dairy" Value="Dairy" />
                    <asp:ListItem Text="Poultry" Value="Poultry" />
                    <asp:ListItem Text="Fishery" Value="Fishery" />
                </asp:ListBox>
            </div>

            <div class="form-group">
                <label>IoT Tools Used</label>
                <asp:DropDownList ID="ddlIotTools" runat="server">
                    <asp:ListItem Text="Yes" Value="Yes" />
                    <asp:ListItem Text="No" Value="No" />
                </asp:DropDownList>
            </div>

            <div class="form-group">
                <label>Land Size (acres)</label>
                <asp:TextBox ID="txtLandSize" runat="server" TextMode="Number" placeholder="e.g. 25" />
            </div>

            <div class="form-group full-width">
                <label>Major Crops</label>
                <asp:TextBox ID="txtMajorCrops" runat="server" placeholder="e.g. Rice, Wheat, Cotton" />
            </div>

            <%-- ===== Security ===== --%>
            <div class="section-divider"><span>Security</span></div>

            <div class="form-group full-width">
                <label>Password</label>
                <asp:TextBox ID="txtPassword" runat="server" TextMode="Password" placeholder="Create a strong password" required="true" />
            </div>

            <%-- ===== Submit ===== --%>
            <div class="form-group full-width">
                <asp:Button ID="btnSubmit" runat="server" Text="🌿 Create Account" CssClass="btn-signup" OnClick="btnSubmit_Click" />
                <asp:Label ID="lblMessage" runat="server" CssClass="message" Visible="false" />
            </div>
        </div>

        <div class="link-container">
            <a href="Login.aspx" class="primary-link">Already have an account? Login</a>
            <a href="Default.aspx">Back to Home</a>
        </div>
    </div>
</form>

<script type="text/javascript">
    // Sync styled checkboxes with the hidden ASP.NET ListBox
    function syncFarmingTypes() {
        var listBox = document.getElementById('<%= lstFarmingTypes.ClientID %>');
        var mapping = {
            'chkCrop': 0,
            'chkDairy': 1,
            'chkPoultry': 2,
            'chkFishery': 3
        };
        for (var id in mapping) {
            var cb = document.getElementById(id);
            if (cb && listBox.options[mapping[id]]) {
                listBox.options[mapping[id]].selected = cb.checked;
            }
        }
    }
</script>
</body>
</html>

