using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data.SqlClient;
using System.Linq;
using System.Security.Cryptography;
using System.Text;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace Smart_Agriculrture
{
	public partial class SignUp : System.Web.UI.Page
	{
		protected void Page_Load(object sender, EventArgs e)
		{

		}
        protected void btnSubmit_Click(object sender, EventArgs e)
        {
            string connStr = ConfigurationManager.ConnectionStrings["SmartAgriDB"].ConnectionString;

            string fullName = txtFullName.Text.Trim();
            string phone = txtPhone.Text.Trim();
            string address = txtAddress.Text.Trim();
            string country = txtCountry.Text.Trim();
            string farmingType = GetSelectedFarmingTypes();
            string iotTools = ddlIotTools.SelectedValue;
            string email = txtEmail.Text.Trim();
            string landSize = txtLandSize.Text.Trim();
            string majorCrops = txtMajorCrops.Text.Trim();
            string password = txtPassword.Text.Trim();
            string hashedPassword = HashPassword(password);

            using (SqlConnection conn = new SqlConnection(connStr))
            {
                string query = @"INSERT INTO farmers (full_name, phone, address, country, farming_type, iot_tools_used, email, land_size, major_crops, password_hash)
                                 VALUES (@fullName, @phone, @address, @country, @farmingType, @iotTools, @email, @landSize, @majorCrops, @passwordHash)";

                using (SqlCommand cmd = new SqlCommand(query, conn))
                {
                    cmd.Parameters.AddWithValue("@fullName", fullName);
                    cmd.Parameters.AddWithValue("@phone", phone);
                    cmd.Parameters.AddWithValue("@address", address);
                    cmd.Parameters.AddWithValue("@country", country);
                    cmd.Parameters.AddWithValue("@farmingType", farmingType);
                    cmd.Parameters.AddWithValue("@iotTools", iotTools);
                    cmd.Parameters.AddWithValue("@email", string.IsNullOrEmpty(email) ? (object)DBNull.Value : email);
                    cmd.Parameters.AddWithValue("@landSize", string.IsNullOrEmpty(landSize) ? (object)DBNull.Value : Convert.ToDecimal(landSize));
                    cmd.Parameters.AddWithValue("@majorCrops", string.IsNullOrEmpty(majorCrops) ? (object)DBNull.Value : majorCrops);
                    cmd.Parameters.AddWithValue("@passwordHash", hashedPassword);

                    conn.Open();
                    cmd.ExecuteNonQuery();
                    conn.Close();

                    lblMessage.Text = "Signup successful!";
                    ClearForm();
                }
            }
        }
        private string GetSelectedFarmingTypes()
        {
            var selectedTypes = new List<string>();
            foreach (ListItem item in lstFarmingTypes.Items)
            {
                if (item.Selected)
                {
                    selectedTypes.Add(item.Value);
                }
            }
            return string.Join(",", selectedTypes);
        }


        private string HashPassword(string password)
        {
            using (SHA256 sha256 = SHA256.Create())
            {
                byte[] bytes = sha256.ComputeHash(Encoding.UTF8.GetBytes(password));
                StringBuilder builder = new StringBuilder();
                foreach (byte b in bytes)
                {
                    builder.Append(b.ToString("x2"));
                }
                return builder.ToString();
            }
        }

        private void ClearForm()
        {
            txtFullName.Text = "";
            txtPhone.Text = "";
            txtAddress.Text = "";
            txtCountry.Text = "";
            foreach (ListItem item in lstFarmingTypes.Items)
            {
                item.Selected = false;
            }
            ddlIotTools.SelectedIndex = 0;
            txtEmail.Text = "";
            txtLandSize.Text = "";
            txtMajorCrops.Text = "";
            txtPassword.Text = "";
        }
    }
}