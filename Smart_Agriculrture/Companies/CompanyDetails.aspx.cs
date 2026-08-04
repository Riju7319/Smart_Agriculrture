using System;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.IO;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace Smart_Agriculrture.Companies
{
    public partial class CompanyDetails : Page
    {
        private string ConnStr => ConfigurationManager.ConnectionStrings["SmartAgriDB"].ConnectionString;

        protected void Page_Load(object sender, EventArgs e)
        {
            AuthHelper.CheckLogin();

            if (string.IsNullOrEmpty(Request.QueryString["CompanyID"]))
            {
                Response.Redirect("Companies.aspx");
                return;
            }

            hfCompanyID.Value = Request.QueryString["CompanyID"];

            if (!IsPostBack)
            {
                LoadCompanyInfo();
                LoadMetrics();
                LoadInvoices();
                LoadCustomers();
                LoadExpenses();
                LoadNotes();
                LoadBankAccounts();
            }
        }

        // ==================== COMPANY INFO ====================
        private void LoadCompanyInfo()
        {
            using (SqlConnection conn = new SqlConnection(ConnStr))
            {
                string q = "SELECT * FROM Companies WHERE CompanyID = @id";
                using (SqlCommand cmd = new SqlCommand(q, conn))
                {
                    cmd.Parameters.AddWithValue("@id", hfCompanyID.Value);
                    conn.Open();
                    SqlDataReader r = cmd.ExecuteReader();
                    if (r.Read())
                    {
                        lblCompanyName.Text = r["CompanyName"].ToString();
                        lblCompanySubtitle.Text = r["ContactPerson"].ToString() + " • " + r["Email"].ToString();

                        txtEditName.Text = r["CompanyName"].ToString();
                        txtEditContact.Text = r["ContactPerson"].ToString();
                        txtEditEmail.Text = r["Email"].ToString();
                        txtEditPhone.Text = r["Phone"].ToString();
                        txtEditGSTIN.Text = r["TaxID_GSTIN"].ToString();
                        txtEditPAN.Text = r["PANNumber"] != DBNull.Value ? r["PANNumber"].ToString() : "";
                        txtEditAddress.Text = r["Address"].ToString();
                    }
                }
            }
        }

        // ==================== METRICS ====================
        private void LoadMetrics()
        {
            using (SqlConnection conn = new SqlConnection(ConnStr))
            {
                conn.Open();
                // Total income (all invoices total)
                string qInc = "SELECT ISNULL(SUM(TotalAmount),0) FROM Invoices WHERE CompanyID=@id AND PaymentStatus='Paid'";
                using (SqlCommand cmd = new SqlCommand(qInc, conn))
                {
                    cmd.Parameters.AddWithValue("@id", hfCompanyID.Value);
                    lblTotalIncome.Text = string.Format("{0:N2}", cmd.ExecuteScalar());
                }
                // Total expenses
                string qExp = "SELECT ISNULL(SUM(Amount),0) FROM Expenses WHERE CompanyID=@id";
                using (SqlCommand cmd = new SqlCommand(qExp, conn))
                {
                    cmd.Parameters.AddWithValue("@id", hfCompanyID.Value);
                    lblTotalExpenses.Text = string.Format("{0:N2}", cmd.ExecuteScalar());
                }
                // Net balance
                decimal inc = decimal.Parse(lblTotalIncome.Text.Replace(",", ""));
                decimal exp = decimal.Parse(lblTotalExpenses.Text.Replace(",", ""));
                lblNetBalance.Text = string.Format("{0:N2}", inc - exp);
            }
        }

        // ==================== INVOICES ====================
        private void LoadInvoices(string search = "", string statusFilter = "")
        {
            using (SqlConnection conn = new SqlConnection(ConnStr))
            {
                string q = @"SELECT InvoiceID, InvoiceNumber, InvoiceDate, DueDate, TotalAmount, IsSent, PaymentStatus
                             FROM Invoices WHERE CompanyID=@id
                             AND (@search='' OR InvoiceNumber LIKE '%'+@search+'%')
                             AND (@status='' OR PaymentStatus=@status)
                             ORDER BY InvoiceDate DESC";
                using (SqlCommand cmd = new SqlCommand(q, conn))
                {
                    cmd.Parameters.AddWithValue("@id", hfCompanyID.Value);
                    cmd.Parameters.AddWithValue("@search", search);
                    cmd.Parameters.AddWithValue("@status", statusFilter);
                    conn.Open();
                    SqlDataAdapter da = new SqlDataAdapter(cmd);
                    DataTable dt = new DataTable();
                    da.Fill(dt);
                    gvInvoices.DataSource = dt;
                    gvInvoices.DataBind();
                }
            }
        }

        protected void FilterInvoices(object sender, EventArgs e)
        {
            hfActiveTab.Value = "invoices";
            LoadInvoices(txtInvSearch.Text.Trim(), ddlPaymentStatus.SelectedValue);
        }

        protected void gvInvoices_PageIndexChanging(object sender, GridViewPageEventArgs e)
        {
            gvInvoices.PageIndex = e.NewPageIndex;
            hfActiveTab.Value = "invoices";
            LoadInvoices(txtInvSearch.Text.Trim(), ddlPaymentStatus.SelectedValue);
        }

        protected void gvInvoices_RowCommand(object sender, GridViewCommandEventArgs e)
        {
            if (e.CommandName == "MarkPaid")
            {
                int invoiceId = int.Parse(e.CommandArgument.ToString());
                using (SqlConnection conn = new SqlConnection(ConnStr))
                {
                    string q = "UPDATE Invoices SET PaymentStatus='Paid' WHERE InvoiceID=@id";
                    using (SqlCommand cmd = new SqlCommand(q, conn))
                    {
                        cmd.Parameters.AddWithValue("@id", invoiceId);
                        conn.Open();
                        cmd.ExecuteNonQuery();
                    }
                }
                hfActiveTab.Value = "invoices";
                ShowMessage("✅ Invoice marked as Paid!", true);
                LoadInvoices();
                LoadMetrics();
            }
            else if (e.CommandName == "DeleteInv")
            {
                int invoiceId = int.Parse(e.CommandArgument.ToString());
                using (SqlConnection conn = new SqlConnection(ConnStr))
                {
                    // Due to foreign keys, delete items first, then invoice
                    conn.Open();
                    string qItems = "DELETE FROM InvoiceItems WHERE InvoiceID=@id";
                    using (SqlCommand cmd = new SqlCommand(qItems, conn))
                    {
                        cmd.Parameters.AddWithValue("@id", invoiceId);
                        cmd.ExecuteNonQuery();
                    }
                    string q = "DELETE FROM Invoices WHERE InvoiceID=@id";
                    using (SqlCommand cmd = new SqlCommand(q, conn))
                    {
                        cmd.Parameters.AddWithValue("@id", invoiceId);
                        cmd.ExecuteNonQuery();
                    }
                }
                hfActiveTab.Value = "invoices";
                ShowMessage("🗑 Invoice deleted.", true);
                LoadInvoices();
                LoadMetrics();
            }
        }

        // ==================== CUSTOMERS ====================
        private void LoadCustomers()
        {
            using (SqlConnection conn = new SqlConnection(ConnStr))
            {
                string q = "SELECT * FROM Customers WHERE CompanyID=@id AND IsActive=1 ORDER BY CustomerName";
                using (SqlCommand cmd = new SqlCommand(q, conn))
                {
                    cmd.Parameters.AddWithValue("@id", hfCompanyID.Value);
                    conn.Open();
                    SqlDataAdapter da = new SqlDataAdapter(cmd);
                    DataTable dt = new DataTable();
                    da.Fill(dt);
                    gvCustomers.DataSource = dt;
                    gvCustomers.DataBind();
                }
            }
        }

        protected void gvCustomers_PageIndexChanging(object sender, GridViewPageEventArgs e)
        {
            gvCustomers.PageIndex = e.NewPageIndex;
            hfActiveTab.Value = "customers";
            LoadCustomers();
        }

        protected void gvCustomers_RowCommand(object sender, GridViewCommandEventArgs e)
        {
            if (e.CommandName == "DeleteCust")
            {
                using (SqlConnection conn = new SqlConnection(ConnStr))
                {
                    string q = "DELETE FROM Customers WHERE CustomerID = @id";
                    using (SqlCommand cmd = new SqlCommand(q, conn))
                    {
                        cmd.Parameters.AddWithValue("@id", e.CommandArgument);
                        conn.Open();
                        cmd.ExecuteNonQuery();
                    }
                }
                hfActiveTab.Value = "customers";
                ShowMessage("🗑 Customer deleted.", true);
                LoadCustomers();
            }
            else if (e.CommandName == "EditCust")
            {
                using (SqlConnection conn = new SqlConnection(ConnStr))
                {
                    string q = "SELECT * FROM Customers WHERE CustomerID = @id";
                    using (SqlCommand cmd = new SqlCommand(q, conn))
                    {
                        cmd.Parameters.AddWithValue("@id", e.CommandArgument);
                        conn.Open();
                        SqlDataReader r = cmd.ExecuteReader();
                        if (r.Read())
                        {
                            hfEditCustomerID.Value = r["CustomerID"].ToString();
                            txtCustName.Text = r["CustomerName"].ToString();
                            txtCustEmail.Text = r["Email"]?.ToString() ?? "";
                            txtCustPhone.Text = r["Phone"]?.ToString() ?? "";
                            txtCustAddress.Text = r["Address"]?.ToString() ?? "";
                            txtCustGSTIN.Text = r["GSTIN"]?.ToString() ?? "";
                            
                            ScriptManager.RegisterStartupScript(this, GetType(), "openEditCust", "document.getElementById('customerModalTitle').innerText = '✏️ Edit Customer'; document.getElementById('customerModal').style.display = 'flex';", true);
                        }
                    }
                }
                hfActiveTab.Value = "customers";
            }
        }

        protected void btnSaveCustomer_Click(object sender, EventArgs e)
        {
            string custName = txtCustName.Text.Trim();
            if (string.IsNullOrEmpty(custName))
            {
                ShowMessage("Customer name is required.", false);
                hfActiveTab.Value = "customers";
                return;
            }

            using (SqlConnection conn = new SqlConnection(ConnStr))
            {
                if (string.IsNullOrEmpty(hfEditCustomerID.Value))
                {
                    string q = @"INSERT INTO Customers (CompanyID, CustomerName, Email, Phone, Address, GSTIN)
                                 VALUES (@cid, @name, @email, @phone, @addr, @gstin)";
                    using (SqlCommand cmd = new SqlCommand(q, conn))
                    {
                        cmd.Parameters.AddWithValue("@cid", hfCompanyID.Value);
                        cmd.Parameters.AddWithValue("@name", custName);
                        cmd.Parameters.AddWithValue("@email", txtCustEmail.Text.Trim());
                        cmd.Parameters.AddWithValue("@phone", txtCustPhone.Text.Trim());
                        cmd.Parameters.AddWithValue("@addr", txtCustAddress.Text.Trim());
                        cmd.Parameters.AddWithValue("@gstin", txtCustGSTIN.Text.Trim());
                        conn.Open();
                        cmd.ExecuteNonQuery();
                    }
                    ShowMessage("✅ Customer added!", true);
                }
                else
                {
                    string q = @"UPDATE Customers SET CustomerName=@name, Email=@email, Phone=@phone, Address=@addr, GSTIN=@gstin WHERE CustomerID=@id";
                    using (SqlCommand cmd = new SqlCommand(q, conn))
                    {
                        cmd.Parameters.AddWithValue("@id", hfEditCustomerID.Value);
                        cmd.Parameters.AddWithValue("@name", custName);
                        cmd.Parameters.AddWithValue("@email", txtCustEmail.Text.Trim());
                        cmd.Parameters.AddWithValue("@phone", txtCustPhone.Text.Trim());
                        cmd.Parameters.AddWithValue("@addr", txtCustAddress.Text.Trim());
                        cmd.Parameters.AddWithValue("@gstin", txtCustGSTIN.Text.Trim());
                        conn.Open();
                        cmd.ExecuteNonQuery();
                    }
                    ShowMessage("✅ Customer updated!", true);
                }
            }

            hfEditCustomerID.Value = "";
            txtCustName.Text = "";
            txtCustEmail.Text = "";
            txtCustPhone.Text = "";
            txtCustAddress.Text = "";
            txtCustGSTIN.Text = "";
            hfActiveTab.Value = "customers";
            LoadCustomers();
        }

        // ==================== EXPENSES ====================
        private void LoadExpenses()
        {
            using (SqlConnection conn = new SqlConnection(ConnStr))
            {
                string q = "SELECT * FROM Expenses WHERE CompanyID=@id ORDER BY ExpenseDate DESC";
                using (SqlCommand cmd = new SqlCommand(q, conn))
                {
                    cmd.Parameters.AddWithValue("@id", hfCompanyID.Value);
                    conn.Open();
                    SqlDataAdapter da = new SqlDataAdapter(cmd);
                    DataTable dt = new DataTable();
                    da.Fill(dt);
                    gvExpenses.DataSource = dt;
                    gvExpenses.DataBind();
                }
            }
        }

        protected void gvExpenses_PageIndexChanging(object sender, GridViewPageEventArgs e)
        {
            gvExpenses.PageIndex = e.NewPageIndex;
            hfActiveTab.Value = "expenses";
            LoadExpenses();
        }

        protected void gvExpenses_RowCommand(object sender, GridViewCommandEventArgs e)
        {
            if (e.CommandName == "DeleteExp")
            {
                using (SqlConnection conn = new SqlConnection(ConnStr))
                {
                    string q = "DELETE FROM Expenses WHERE ExpenseID = @id";
                    using (SqlCommand cmd = new SqlCommand(q, conn))
                    {
                        cmd.Parameters.AddWithValue("@id", e.CommandArgument);
                        conn.Open();
                        cmd.ExecuteNonQuery();
                    }
                }
                hfActiveTab.Value = "expenses";
                ShowMessage("🗑 Expense deleted.", true);
                LoadExpenses();
                LoadMetrics(); // update totals
            }
            else if (e.CommandName == "EditExp")
            {
                using (SqlConnection conn = new SqlConnection(ConnStr))
                {
                    string q = "SELECT * FROM Expenses WHERE ExpenseID = @id";
                    using (SqlCommand cmd = new SqlCommand(q, conn))
                    {
                        cmd.Parameters.AddWithValue("@id", e.CommandArgument);
                        conn.Open();
                        SqlDataReader r = cmd.ExecuteReader();
                        if (r.Read())
                        {
                            hfEditExpenseID.Value = r["ExpenseID"].ToString();
                            txtExpDate.Text = Convert.ToDateTime(r["ExpenseDate"]).ToString("yyyy-MM-dd");
                            ddlExpCategory.SelectedValue = r["Category"].ToString();
                            txtExpAmount.Text = r["Amount"].ToString();
                            ddlExpPayment.SelectedValue = r["PaymentMethod"].ToString();
                            txtExpDesc.Text = r["Description"].ToString();
                            
                            ScriptManager.RegisterStartupScript(this, GetType(), "openEditExp", "document.getElementById('expenseModalTitle').innerText = '✏️ Edit Expense'; document.getElementById('expenseModal').style.display = 'flex';", true);
                        }
                    }
                }
                hfActiveTab.Value = "expenses";
            }
        }

        protected void btnSaveExpense_Click(object sender, EventArgs e)
        {
            if (string.IsNullOrEmpty(txtExpDate.Text) || string.IsNullOrEmpty(txtExpAmount.Text))
            {
                ShowMessage("Date and Amount are required.", false);
                hfActiveTab.Value = "expenses";
                return;
            }

            using (SqlConnection conn = new SqlConnection(ConnStr))
            {
                if (string.IsNullOrEmpty(hfEditExpenseID.Value))
                {
                    string q = @"INSERT INTO Expenses (CompanyID, ExpenseDate, Category, Amount, PaymentMethod, Description)
                                 VALUES (@cid, @dt, @cat, @amt, @pm, @desc)";
                    using (SqlCommand cmd = new SqlCommand(q, conn))
                    {
                        cmd.Parameters.AddWithValue("@cid", hfCompanyID.Value);
                        cmd.Parameters.AddWithValue("@dt", txtExpDate.Text);
                        cmd.Parameters.AddWithValue("@cat", ddlExpCategory.SelectedValue);
                        cmd.Parameters.AddWithValue("@amt", Convert.ToDecimal(txtExpAmount.Text));
                        cmd.Parameters.AddWithValue("@pm", ddlExpPayment.SelectedValue);
                        cmd.Parameters.AddWithValue("@desc", txtExpDesc.Text.Trim());
                        conn.Open();
                        cmd.ExecuteNonQuery();
                    }
                    ShowMessage("✅ Expense logged!", true);
                }
                else
                {
                    string q = @"UPDATE Expenses SET ExpenseDate=@dt, Category=@cat, Amount=@amt, PaymentMethod=@pm, Description=@desc WHERE ExpenseID=@id";
                    using (SqlCommand cmd = new SqlCommand(q, conn))
                    {
                        cmd.Parameters.AddWithValue("@id", hfEditExpenseID.Value);
                        cmd.Parameters.AddWithValue("@dt", txtExpDate.Text);
                        cmd.Parameters.AddWithValue("@cat", ddlExpCategory.SelectedValue);
                        cmd.Parameters.AddWithValue("@amt", Convert.ToDecimal(txtExpAmount.Text));
                        cmd.Parameters.AddWithValue("@pm", ddlExpPayment.SelectedValue);
                        cmd.Parameters.AddWithValue("@desc", txtExpDesc.Text.Trim());
                        conn.Open();
                        cmd.ExecuteNonQuery();
                    }
                    ShowMessage("✅ Expense updated!", true);
                }
            }

            hfEditExpenseID.Value = "";
            txtExpDate.Text = "";
            txtExpAmount.Text = "";
            txtExpDesc.Text = "";
            hfActiveTab.Value = "expenses";
            LoadExpenses();
            LoadMetrics(); // update totals
        }

        // ==================== NOTES ====================
        private void LoadNotes()
        {
            using (SqlConnection conn = new SqlConnection(ConnStr))
            {
                string q = "SELECT * FROM CompanyNotes WHERE CompanyID=@id ORDER BY CreatedDate DESC";
                using (SqlCommand cmd = new SqlCommand(q, conn))
                {
                    cmd.Parameters.AddWithValue("@id", hfCompanyID.Value);
                    conn.Open();
                    SqlDataAdapter da = new SqlDataAdapter(cmd);
                    DataTable dt = new DataTable();
                    da.Fill(dt);
                    if (dt.Rows.Count > 0)
                    {
                        rptNotes.DataSource = dt;
                        rptNotes.DataBind();
                        lblNoNotes.Visible = false;
                    }
                    else
                    {
                        rptNotes.DataSource = null;
                        rptNotes.DataBind();
                        lblNoNotes.Visible = true;
                    }
                }
            }
        }
        protected void rptNotes_ItemCommand(object source, RepeaterCommandEventArgs e)
        {
            if (e.CommandName == "DeleteNote")
            {
                using (SqlConnection conn = new SqlConnection(ConnStr))
                {
                    string q = "DELETE FROM CompanyNotes WHERE NoteID = @id";
                    using (SqlCommand cmd = new SqlCommand(q, conn))
                    {
                        cmd.Parameters.AddWithValue("@id", e.CommandArgument);
                        conn.Open();
                        cmd.ExecuteNonQuery();
                    }
                }
                hfActiveTab.Value = "notes";
                ShowMessage("🗑 Note deleted.", true);
                LoadNotes();
            }
            else if (e.CommandName == "EditNote")
            {
                using (SqlConnection conn = new SqlConnection(ConnStr))
                {
                    string q = "SELECT * FROM CompanyNotes WHERE NoteID = @id";
                    using (SqlCommand cmd = new SqlCommand(q, conn))
                    {
                        cmd.Parameters.AddWithValue("@id", e.CommandArgument);
                        conn.Open();
                        SqlDataReader r = cmd.ExecuteReader();
                        if (r.Read())
                        {
                            hfEditNoteID.Value = r["NoteID"].ToString();
                            txtNoteText.Text = r["NoteText"].ToString();
                            
                            ScriptManager.RegisterStartupScript(this, GetType(), "openEditNote", "document.getElementById('noteModalTitle').innerText = '✏️ Edit Note'; document.getElementById('noteModal').style.display = 'flex';", true);
                        }
                    }
                }
                hfActiveTab.Value = "notes";
            }
        }

        protected void btnSaveNote_Click(object sender, EventArgs e)
        {
            if (string.IsNullOrEmpty(txtNoteText.Text.Trim()))
            {
                ShowMessage("Note text cannot be empty.", false);
                hfActiveTab.Value = "notes";
                return;
            }

            using (SqlConnection conn = new SqlConnection(ConnStr))
            {
                if (string.IsNullOrEmpty(hfEditNoteID.Value))
                {
                    string q = @"INSERT INTO CompanyNotes (CompanyID, NoteText, CreatedBy)
                                 VALUES (@cid, @txt, @by)";
                    using (SqlCommand cmd = new SqlCommand(q, conn))
                    {
                        cmd.Parameters.AddWithValue("@cid", hfCompanyID.Value);
                        cmd.Parameters.AddWithValue("@txt", txtNoteText.Text.Trim());
                        cmd.Parameters.AddWithValue("@by", Session["FarmerName"]?.ToString() ?? "System");
                        conn.Open();
                        cmd.ExecuteNonQuery();
                    }
                    ShowMessage("✅ Note added!", true);
                }
                else
                {
                    string q = @"UPDATE CompanyNotes SET NoteText=@txt WHERE NoteID=@id";
                    using (SqlCommand cmd = new SqlCommand(q, conn))
                    {
                        cmd.Parameters.AddWithValue("@id", hfEditNoteID.Value);
                        cmd.Parameters.AddWithValue("@txt", txtNoteText.Text.Trim());
                        conn.Open();
                        cmd.ExecuteNonQuery();
                    }
                    ShowMessage("✅ Note updated!", true);
                }
            }

            hfEditNoteID.Value = "";
            txtNoteText.Text = "";
            hfActiveTab.Value = "notes";
            LoadNotes();
        }

        // ==================== UPDATE COMPANY ====================
        protected void btnUpdateCompany_Click(object sender, EventArgs e)
        {
            using (SqlConnection conn = new SqlConnection(ConnStr))
            {
                string q = @"UPDATE Companies SET CompanyName=@name, ContactPerson=@contact, Email=@email,
                             Phone=@phone, TaxID_GSTIN=@gstin, PANNumber=@pan, Address=@addr WHERE CompanyID=@id";
                using (SqlCommand cmd = new SqlCommand(q, conn))
                {
                    cmd.Parameters.AddWithValue("@id", hfCompanyID.Value);
                    cmd.Parameters.AddWithValue("@name", txtEditName.Text.Trim());
                    cmd.Parameters.AddWithValue("@contact", txtEditContact.Text.Trim());
                    cmd.Parameters.AddWithValue("@email", txtEditEmail.Text.Trim());
                    cmd.Parameters.AddWithValue("@phone", txtEditPhone.Text.Trim());
                    cmd.Parameters.AddWithValue("@gstin", txtEditGSTIN.Text.Trim());
                    cmd.Parameters.AddWithValue("@pan", txtEditPAN.Text.Trim());
                    cmd.Parameters.AddWithValue("@addr", txtEditAddress.Text.Trim());
                    conn.Open();
                    cmd.ExecuteNonQuery();
                }
            }

            hfActiveTab.Value = "details";
            ShowMessage("✅ Company updated!", true);
            LoadCompanyInfo();
        }

        // ==================== BANK ACCOUNTS ====================
        private void LoadBankAccounts()
        {
            using (SqlConnection conn = new SqlConnection(ConnStr))
            {
                string q = "SELECT * FROM BankAccounts WHERE CompanyID=@id ORDER BY IsDefault DESC, AccountName";
                using (SqlCommand cmd = new SqlCommand(q, conn))
                {
                    cmd.Parameters.AddWithValue("@id", hfCompanyID.Value);
                    conn.Open();
                    SqlDataAdapter da = new SqlDataAdapter(cmd);
                    DataTable dt = new DataTable();
                    da.Fill(dt);
                    gvBankAccounts.DataSource = dt;
                    gvBankAccounts.DataBind();
                }
            }
        }
        protected void gvBankAccounts_RowCommand(object sender, GridViewCommandEventArgs e)
        {
            if (e.CommandName == "DeleteBank")
            {
                using (SqlConnection conn = new SqlConnection(ConnStr))
                {
                    string q = "DELETE FROM BankAccounts WHERE BankAccountID = @id";
                    using (SqlCommand cmd = new SqlCommand(q, conn))
                    {
                        cmd.Parameters.AddWithValue("@id", e.CommandArgument);
                        conn.Open();
                        cmd.ExecuteNonQuery();
                    }
                }
                hfActiveTab.Value = "details";
                ShowMessage("🗑 Bank Account deleted.", true);
                LoadBankAccounts();
            }
            else if (e.CommandName == "EditBank")
            {
                using (SqlConnection conn = new SqlConnection(ConnStr))
                {
                    string q = "SELECT * FROM BankAccounts WHERE BankAccountID = @id";
                    using (SqlCommand cmd = new SqlCommand(q, conn))
                    {
                        cmd.Parameters.AddWithValue("@id", e.CommandArgument);
                        conn.Open();
                        SqlDataReader r = cmd.ExecuteReader();
                        if (r.Read())
                        {
                            hfEditBankID.Value = r["BankAccountID"].ToString();
                            txtBankAccName.Text = r["AccountName"].ToString();
                            txtBankAccNumber.Text = r["AccountNumber"].ToString();
                            txtBankIFSC.Text = r["IFSCCode"]?.ToString() ?? "";
                            txtBankUPI.Text = r["UPIID"]?.ToString() ?? "";
                            txtBankNameInput.Text = r["BankName"]?.ToString() ?? "";
                            txtBankPAN.Text = r["PANNumber"]?.ToString() ?? "";
                            chkDefaultBank.Checked = Convert.ToBoolean(r["IsDefault"]);
                        }
                    }
                }
                hfActiveTab.Value = "details";
            }
        }

        protected void btnSaveBankAccount_Click(object sender, EventArgs e)
        {
            if (string.IsNullOrEmpty(txtBankAccName.Text.Trim()) || string.IsNullOrEmpty(txtBankAccNumber.Text.Trim()))
            {
                ShowMessage("Account Name and Number are required.", false);
                hfActiveTab.Value = "details";
                return;
            }

            using (SqlConnection conn = new SqlConnection(ConnStr))
            {
                conn.Open();
                if (chkDefaultBank.Checked)
                {
                    string clearQ = "UPDATE BankAccounts SET IsDefault = 0 WHERE CompanyID = @cid";
                    using (SqlCommand cCmd = new SqlCommand(clearQ, conn))
                    {
                        cCmd.Parameters.AddWithValue("@cid", hfCompanyID.Value);
                        cCmd.ExecuteNonQuery();
                    }
                }

                if (string.IsNullOrEmpty(hfEditBankID.Value))
                {
                    string q = @"INSERT INTO BankAccounts (CompanyID, AccountName, AccountNumber, IFSCCode, UPIID, BankName, PANNumber, IsDefault)
                                 VALUES (@cid, @name, @num, @ifsc, @upi, @bank, @pan, @def)";
                    using (SqlCommand cmd = new SqlCommand(q, conn))
                    {
                        cmd.Parameters.AddWithValue("@cid", hfCompanyID.Value);
                        cmd.Parameters.AddWithValue("@name", txtBankAccName.Text.Trim());
                        cmd.Parameters.AddWithValue("@num", txtBankAccNumber.Text.Trim());
                        cmd.Parameters.AddWithValue("@ifsc", txtBankIFSC.Text.Trim());
                        cmd.Parameters.AddWithValue("@upi", txtBankUPI.Text.Trim());
                        cmd.Parameters.AddWithValue("@bank", txtBankNameInput.Text.Trim());
                        cmd.Parameters.AddWithValue("@pan", string.IsNullOrEmpty(txtBankPAN.Text.Trim()) ? (object)DBNull.Value : txtBankPAN.Text.Trim());
                        cmd.Parameters.AddWithValue("@def", chkDefaultBank.Checked);
                        cmd.ExecuteNonQuery();
                    }
                    ShowMessage("✅ Bank Account Added!", true);
                }
                else
                {
                    string q = @"UPDATE BankAccounts SET AccountName=@name, AccountNumber=@num, IFSCCode=@ifsc, UPIID=@upi, BankName=@bank, PANNumber=@pan, IsDefault=@def WHERE BankAccountID=@id";
                    using (SqlCommand cmd = new SqlCommand(q, conn))
                    {
                        cmd.Parameters.AddWithValue("@id", hfEditBankID.Value);
                        cmd.Parameters.AddWithValue("@name", txtBankAccName.Text.Trim());
                        cmd.Parameters.AddWithValue("@num", txtBankAccNumber.Text.Trim());
                        cmd.Parameters.AddWithValue("@ifsc", txtBankIFSC.Text.Trim());
                        cmd.Parameters.AddWithValue("@upi", txtBankUPI.Text.Trim());
                        cmd.Parameters.AddWithValue("@bank", txtBankNameInput.Text.Trim());
                        cmd.Parameters.AddWithValue("@pan", string.IsNullOrEmpty(txtBankPAN.Text.Trim()) ? (object)DBNull.Value : txtBankPAN.Text.Trim());
                        cmd.Parameters.AddWithValue("@def", chkDefaultBank.Checked);
                        cmd.ExecuteNonQuery();
                    }
                    ShowMessage("✅ Bank Account Updated!", true);
                }
            }

            hfEditBankID.Value = "";
            txtBankAccName.Text = "";
            txtBankAccNumber.Text = "";
            txtBankIFSC.Text = "";
            txtBankUPI.Text = "";
            txtBankNameInput.Text = "";
            txtBankPAN.Text = "";
            chkDefaultBank.Checked = false;
            hfActiveTab.Value = "details";
            LoadBankAccounts();
        }

        // ==================== EXPORT EXCEL ====================
        protected void btnExportExcel_Click(object sender, EventArgs e)
        {
            DataTable dtInv, dtExp;
            using (SqlConnection conn = new SqlConnection(ConnStr))
            {
                conn.Open();
                // Invoices
                using (SqlCommand cmd = new SqlCommand("SELECT InvoiceNumber,InvoiceDate,DueDate,SubTotal,TaxAmount,TotalAmount,PaymentStatus FROM Invoices WHERE CompanyID=@id ORDER BY InvoiceDate DESC", conn))
                {
                    cmd.Parameters.AddWithValue("@id", hfCompanyID.Value);
                    SqlDataAdapter da = new SqlDataAdapter(cmd);
                    dtInv = new DataTable();
                    da.Fill(dtInv);
                }
                // Expenses
                using (SqlCommand cmd = new SqlCommand("SELECT ExpenseDate,Category,Amount,PaymentMethod,Description FROM Expenses WHERE CompanyID=@id ORDER BY ExpenseDate DESC", conn))
                {
                    cmd.Parameters.AddWithValue("@id", hfCompanyID.Value);
                    SqlDataAdapter da = new SqlDataAdapter(cmd);
                    dtExp = new DataTable();
                    da.Fill(dtExp);
                }
            }

            Response.Clear();
            Response.ContentType = "application/vnd.ms-excel";
            Response.AddHeader("Content-Disposition", "attachment; filename=Company_" + hfCompanyID.Value + "_Data.xls");

            StringWriter sw = new StringWriter();
            sw.Write("<html><head><meta charset='utf-8'/></head><body>");

            // Invoices sheet
            sw.Write("<h2>Invoices</h2>");
            sw.Write("<table border='1' cellpadding='5' cellspacing='0' style='border-collapse:collapse;font-family:Arial;'>");
            sw.Write("<tr style='background:#2563eb;color:#fff;font-weight:bold;'>");
            foreach (DataColumn col in dtInv.Columns)
                sw.Write("<td>" + col.ColumnName + "</td>");
            sw.Write("</tr>");
            foreach (DataRow row in dtInv.Rows)
            {
                sw.Write("<tr>");
                foreach (DataColumn col in dtInv.Columns)
                    sw.Write("<td>" + row[col].ToString() + "</td>");
                sw.Write("</tr>");
            }
            sw.Write("</table><br/><br/>");

            // Expenses sheet
            sw.Write("<h2>Expenses</h2>");
            sw.Write("<table border='1' cellpadding='5' cellspacing='0' style='border-collapse:collapse;font-family:Arial;'>");
            sw.Write("<tr style='background:#dc2626;color:#fff;font-weight:bold;'>");
            foreach (DataColumn col in dtExp.Columns)
                sw.Write("<td>" + col.ColumnName + "</td>");
            sw.Write("</tr>");
            foreach (DataRow row in dtExp.Rows)
            {
                sw.Write("<tr>");
                foreach (DataColumn col in dtExp.Columns)
                    sw.Write("<td>" + row[col].ToString() + "</td>");
                sw.Write("</tr>");
            }
            sw.Write("</table>");

            sw.Write("</body></html>");
            Response.Write(sw.ToString());
            Response.End();
        }

        private void ShowMessage(string msg, bool success)
        {
            lblMessage.Text = msg;
            lblMessage.CssClass = success ? "alert-msg alert-success" : "alert-msg alert-error";
            lblMessage.Visible = true;
        }
    }
}
