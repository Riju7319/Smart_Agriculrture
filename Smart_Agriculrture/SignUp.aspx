<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="SignUp.aspx.cs" Inherits="Smart_Agriculrture.SignUp" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>Farmer Signup</title>
    <meta name="viewport" content="width=device-width, initial-scale=1" />
    <style>
        body {
            font-family: Arial, sans-serif;
            background-color: #f9f9f9;
            padding: 20px;
        }
        .container {
            max-width: 480px;
            margin: auto;
            background: #fff;
            padding: 25px;
            border-radius: 10px;
            box-shadow: 0 0 10px #ccc;
        }
        h2 {
            text-align: center;
        }
        label {
            display: block;
            margin-top: 15px;
        }
        input, select, textarea {
            width: 100%;
            padding: 10px;
            margin-top: 6px;
            border: 1px solid #ccc;
            border-radius: 5px;
        }
        .btn {
            background-color: #28a745;
            color: white;
            margin-top: 20px;
            padding: 12px;
            border: none;
            width: 100%;
            border-radius: 5px;
            font-size: 16px;
            cursor: pointer;
        }
        .btn:hover {
            background-color: #218838;
        }
        .message {
            text-align: center;
            color: green;
            font-weight: bold;
            margin-top: 15px;
        }
    </style>
</head>
<body>
     <form id="form1" runat="server">
        <div class="container">
            <h2>Farmer Signup</h2>

            <label>Full Name</label>
            <asp:TextBox ID="txtFullName" runat="server" required="true" />

            <label>Phone</label>
            <asp:TextBox ID="txtPhone" runat="server" TextMode="Phone" required="true" />

            <label>Address</label>
            <asp:TextBox ID="txtAddress" runat="server" TextMode="MultiLine" required="true" />

            <label>Country</label>
            <asp:TextBox ID="txtCountry" runat="server" required="true" />

           <label>Farming Types (select one or more)</label>
            <asp:ListBox ID="lstFarmingTypes" runat="server" SelectionMode="Multiple">
                <asp:ListItem Text="Crop" Value="Crop" />
                <asp:ListItem Text="Dairy" Value="Dairy" />
                <asp:ListItem Text="Poultry" Value="Poultry" />
                <asp:ListItem Text="Fishery" Value="Fishery" />
            </asp:ListBox>

            <label>IoT Tools Used</label>
            <asp:DropDownList ID="ddlIotTools" runat="server" required="true">
                <asp:ListItem Text="Yes" Value="Yes" />
                <asp:ListItem Text="No" Value="No" />
            </asp:DropDownList>

            <label>Email</label>
            <asp:TextBox ID="txtEmail" runat="server" TextMode="Email" />

            <label>Land Size (in acres)</label>
            <asp:TextBox ID="txtLandSize" runat="server" TextMode="Number" />

            <label>Major Crops</label>
            <asp:TextBox ID="txtMajorCrops" runat="server" />

            <label>Password</label>
            <asp:TextBox ID="txtPassword" runat="server" TextMode="Password" required="true" />

            <asp:Button ID="btnSubmit" runat="server" Text="Sign Up" CssClass="btn" OnClick="btnSubmit_Click" />
            <asp:Label ID="lblMessage" runat="server" CssClass="message" />
            <!-- Hyperlinks below signup button -->
<div style="text-align:center; margin-top: 18px;">
    <a href="Default.aspx" style="color:#6c757d; text-decoration:none; margin-right:15px;">Back to Dashboard</a>
    <a href="Login.aspx" style="color:#007bff; text-decoration:none;">Go to Login</a>
</div>

        </div>
    </form>
</body>
</html>
