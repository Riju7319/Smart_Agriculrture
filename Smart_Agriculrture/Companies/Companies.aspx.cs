using System;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace Smart_Agriculrture.Companies
{
    public partial class Companies : Page
    {
        private string ConnStr => ConfigurationManager.ConnectionStrings["SmartAgriDB"].ConnectionString;

        protected void Page_Load(object sender, EventArgs e)
        {
            AuthHelper.CheckLogin();
            if (!IsPostBack)
            {
                LoadCompanies();
            }
        }

        private void LoadCompanies(string search = "")
        {
            string connStr = ConfigurationManager.ConnectionStrings["SmartAgriDB"].ConnectionString;
            using (SqlConnection conn = new SqlConnection(connStr))
            {
                string query = @"SELECT CompanyID, CompanyName, ContactPerson, Email, Phone,
                                    TotalIncome, TotalExpenses, NetProfitLoss, UnpaidInvoiceCount
                                 FROM vw_CompanyFinancialSummary
                                 WHERE (@search = '' OR CompanyName LIKE '%' + @search + '%' 
                                        OR ContactPerson LIKE '%' + @search + '%')
                                 ORDER BY CompanyName";

                using (SqlCommand cmd = new SqlCommand(query, conn))
                {
                    cmd.Parameters.AddWithValue("@search", search);
                    conn.Open();

                    SqlDataAdapter da = new SqlDataAdapter(cmd);
                    DataTable dt = new DataTable();
                    da.Fill(dt);

                    if (dt.Rows.Count > 0)
                    {
                        rptCompanies.DataSource = dt;
                        rptCompanies.DataBind();
                        pnlEmpty.Visible = false;
                    }
                    else
                    {
                        rptCompanies.DataSource = null;
                        rptCompanies.DataBind();
                        pnlEmpty.Visible = true;
                    }
                }
            }
        }

        protected void txtSearch_TextChanged(object sender, EventArgs e)
        {
            LoadCompanies(txtSearch.Text.Trim());
        }

        protected void btnSaveCompany_Click(object sender, EventArgs e)
        {
            string companyName = txtCompanyName.Text.Trim();
            if (string.IsNullOrEmpty(companyName))
            {
                ShowMessage("Company name is required.", false);
                return;
            }

            string connStr = ConfigurationManager.ConnectionStrings["SmartAgriDB"].ConnectionString;
            using (SqlConnection conn = new SqlConnection(connStr))
            {
                string query = @"INSERT INTO Companies (CompanyName, ContactPerson, Email, Phone, TaxID_GSTIN, PANNumber, Address)
                                 VALUES (@name, @contact, @email, @phone, @gstin, @pan, @address)";

                using (SqlCommand cmd = new SqlCommand(query, conn))
                {
                    cmd.Parameters.AddWithValue("@name", companyName);
                    cmd.Parameters.AddWithValue("@contact", (object)txtContactPerson.Text.Trim() ?? DBNull.Value);
                    cmd.Parameters.AddWithValue("@email", (object)txtEmail.Text.Trim() ?? DBNull.Value);
                    cmd.Parameters.AddWithValue("@phone", (object)txtPhone.Text.Trim() ?? DBNull.Value);
                    cmd.Parameters.AddWithValue("@gstin", (object)txtGSTIN.Text.Trim() ?? DBNull.Value);
                    cmd.Parameters.AddWithValue("@pan", (object)txtPAN.Text.Trim() ?? DBNull.Value);
                    cmd.Parameters.AddWithValue("@address", (object)txtAddress.Text.Trim() ?? DBNull.Value);

                    conn.Open();
                    cmd.ExecuteNonQuery();
                }
            }

            // Clear form
            txtCompanyName.Text = "";
            txtContactPerson.Text = "";
            txtEmail.Text = "";
            txtPhone.Text = "";
            txtGSTIN.Text = "";
            txtPAN.Text = "";
            txtAddress.Text = "";

            ShowMessage("✅ Company created successfully!", true);
            LoadCompanies();
        }

        protected void rptCompanies_ItemCommand(object source, RepeaterCommandEventArgs e)
        {
            if (e.CommandName == "DeleteCompany")
            {
                int companyId = Convert.ToInt32(e.CommandArgument);
                using (SqlConnection conn = new SqlConnection(ConnStr))
                {
                    conn.Open();
                    // Hard Delete Cascade
                    // 1. InvoiceItems (due to Invoices fk)
                    string q1 = "DELETE ii FROM InvoiceItems ii INNER JOIN Invoices i ON ii.InvoiceID = i.InvoiceID WHERE i.CompanyID = @cid";
                    using (SqlCommand cmd = new SqlCommand(q1, conn)) { cmd.Parameters.AddWithValue("@cid", companyId); cmd.ExecuteNonQuery(); }
                    
                    // 2. Invoices
                    string q2 = "DELETE FROM Invoices WHERE CompanyID = @cid";
                    using (SqlCommand cmd = new SqlCommand(q2, conn)) { cmd.Parameters.AddWithValue("@cid", companyId); cmd.ExecuteNonQuery(); }

                    // 3. Expenses
                    string q3 = "DELETE FROM Expenses WHERE CompanyID = @cid";
                    using (SqlCommand cmd = new SqlCommand(q3, conn)) { cmd.Parameters.AddWithValue("@cid", companyId); cmd.ExecuteNonQuery(); }

                    // 4. BankAccounts
                    string q4 = "DELETE FROM BankAccounts WHERE CompanyID = @cid";
                    using (SqlCommand cmd = new SqlCommand(q4, conn)) { cmd.Parameters.AddWithValue("@cid", companyId); cmd.ExecuteNonQuery(); }

                    // 5. CompanyNotes
                    string q5 = "DELETE FROM CompanyNotes WHERE CompanyID = @cid";
                    using (SqlCommand cmd = new SqlCommand(q5, conn)) { cmd.Parameters.AddWithValue("@cid", companyId); cmd.ExecuteNonQuery(); }

                    // 6. Customers
                    string q6 = "DELETE FROM Customers WHERE CompanyID = @cid";
                    using (SqlCommand cmd = new SqlCommand(q6, conn)) { cmd.Parameters.AddWithValue("@cid", companyId); cmd.ExecuteNonQuery(); }

                    // 7. Companies
                    string q7 = "DELETE FROM Companies WHERE CompanyID = @cid";
                    using (SqlCommand cmd = new SqlCommand(q7, conn)) { cmd.Parameters.AddWithValue("@cid", companyId); cmd.ExecuteNonQuery(); }
                }

                ShowMessage("🗑 Company permanently deleted.", true);
                LoadCompanies();
            }
        }

        private void ShowMessage(string msg, bool success)
        {
            lblMessage.Text = msg;
            lblMessage.CssClass = success ? "alert-msg alert-success" : "alert-msg alert-error";
            lblMessage.Visible = true;
        }
    }
}
