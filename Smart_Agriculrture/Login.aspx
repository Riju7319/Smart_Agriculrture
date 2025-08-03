<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="Login.aspx.cs" Inherits="Smart_Agriculrture.Login" %>

<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
<title>Farmer Login</title>
<meta name="viewport" content="width=device-width, initial-scale=1" />
<style>
body {
    font-family: Arial, sans-serif;
    background-color: #f0f2f5;
    padding: 20px;
}
.login-container {
    max-width: 400px;
    margin: auto;
    background: white;
    padding: 30px;
    border-radius: 10px;
    box-shadow: 0px 0px 10px #ccc;
}
h2 {
    text-align: center;
    margin-bottom: 30px;
}
label {
    display: block;
    margin-top: 15px;
}
input {
    width: 100%;
    padding: 10px;
    margin-top: 6px;
    border: 1px solid #ccc;
    border-radius: 5px;
}
.btn-login {
    background-color: #007bff;
    color: white;
    padding: 12px;
    margin-top: 20px;
    width: 100%;
    border: none;
    border-radius: 5px;
    font-size: 16px;
    cursor: pointer;
}
.btn-login:hover {
    background-color: #0056b3;
}
.message {
    text-align: center;
    color: red;
    font-weight: bold;
    margin-top: 15px;
}
.link-container {
    text-align:center;
    margin-top: 20px;
}
.link-container a {
    color: #007bff;
    text-decoration: none;
    margin-right: 15px;
    font-size: 15px;
}
.link-container a:last-child {
    color: #6c757d;
    margin-right: 0;
}
</style>
</head>
<body>
<form id="form1" runat="server">
    <div class="login-container">
        <h2>Farmer Login</h2>

        <label for="txtPhone">Phone Number</label>
        <asp:TextBox ID="txtPhone" runat="server" required="true" TextMode="Phone" />

        <label for="txtPassword">Password</label>
        <asp:TextBox ID="txtPassword" runat="server" required="true" TextMode="Password" />

        <asp:Button ID="btnLogin" runat="server" Text="Login" CssClass="btn-login" OnClick="btnLogin_Click" />

        <!-- Signup and Back to Home Links -->
        <div class="link-container">
            <a href="Signup.aspx">New user? Sign up</a>
            <a href="Default.aspx">Back to Home</a>
        </div>

        <asp:Label ID="lblMessage" runat="server" CssClass="message" />
    </div>
</form>
</body>
</html>
