using System;
using System.Configuration;
using System.Data.SqlClient;
using System.Web.Script.Serialization;
using System.Web.UI;

namespace Smart_Agriculrture.Companies
{
    public partial class CreateInvoice : Page
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
                lnkBack.HRef = "CompanyDetails.aspx?CompanyID=" + hfCompanyID.Value;
                LoadCustomers();
                LoadBankAccounts();
                GenerateInvoiceNumber();
                txtInvoiceDate.Text = DateTime.Now.ToString("yyyy-MM-dd");
                txtDueDate.Text = DateTime.Now.AddDays(30).ToString("yyyy-MM-dd");
                
                if (!string.IsNullOrEmpty(Request.QueryString["clone"]))
                {
                    LoadInvoiceForClone(Request.QueryString["clone"]);
                }
            }
        }

        private void LoadInvoiceForClone(string cloneId)
        {
            using (SqlConnection conn = new SqlConnection(ConnStr))
            {
                // Load Invoice Details
                string qInv = "SELECT * FROM Invoices WHERE InvoiceID = @id AND CompanyID = @cid";
                using (SqlCommand cmd = new SqlCommand(qInv, conn))
                {
                    cmd.Parameters.AddWithValue("@id", cloneId);
                    cmd.Parameters.AddWithValue("@cid", hfCompanyID.Value);
                    conn.Open();
                    using (SqlDataReader r = cmd.ExecuteReader())
                    {
                        if (r.Read())
                        {
                            if (r["CustomerID"] != DBNull.Value) ddlCustomer.SelectedValue = r["CustomerID"].ToString();
                            if (r["BankAccountID"] != DBNull.Value) ddlBankAccount.SelectedValue = r["BankAccountID"].ToString();
                            
                            hfCGST.Value = r["CGSTPercent"].ToString();
                            hfSGST.Value = r["SGSTPercent"].ToString();
                        }
                    }
                }

                // Load Invoice Items
                string qItems = "SELECT * FROM InvoiceItems WHERE InvoiceID = @id";
                System.Collections.Generic.List<InvoiceItemDTO> itemsList = new System.Collections.Generic.List<InvoiceItemDTO>();
                using (SqlCommand cmd = new SqlCommand(qItems, conn))
                {
                    cmd.Parameters.AddWithValue("@id", cloneId);
                    using (SqlDataReader r = cmd.ExecuteReader())
                    {
                        while (r.Read())
                        {
                            itemsList.Add(new InvoiceItemDTO {
                                name = r["ItemName"].ToString(),
                                desc = r["ItemDescription"]?.ToString() ?? "",
                                qty = Convert.ToInt32(r["Quantity"]),
                                price = Convert.ToDecimal(r["UnitPrice"])
                            });
                        }
                    }
                }
                
                var serializer = new JavaScriptSerializer();
                hfItemsJSON.Value = serializer.Serialize(itemsList);
            }
        }

        private void LoadCustomers()
        {
            using (SqlConnection conn = new SqlConnection(ConnStr))
            {
                string q = "SELECT CustomerID, CustomerName FROM Customers WHERE CompanyID=@cid AND IsActive=1 ORDER BY CustomerName";
                using (SqlCommand cmd = new SqlCommand(q, conn))
                {
                    cmd.Parameters.AddWithValue("@cid", hfCompanyID.Value);
                    conn.Open();
                    ddlCustomer.DataSource = cmd.ExecuteReader();
                    ddlCustomer.DataTextField = "CustomerName";
                    ddlCustomer.DataValueField = "CustomerID";
                    ddlCustomer.DataBind();
                }
            }
            ddlCustomer.Items.Insert(0, new System.Web.UI.WebControls.ListItem("-- Select Customer --", ""));
        }

        private void LoadBankAccounts()
        {
            using (SqlConnection conn = new SqlConnection(ConnStr))
            {
                string q = "SELECT BankAccountID, AccountName + ' — ' + AccountNumber AS DisplayName FROM BankAccounts WHERE CompanyID=@cid ORDER BY IsDefault DESC, AccountName";
                using (SqlCommand cmd = new SqlCommand(q, conn))
                {
                    cmd.Parameters.AddWithValue("@cid", hfCompanyID.Value);
                    conn.Open();
                    ddlBankAccount.DataSource = cmd.ExecuteReader();
                    ddlBankAccount.DataTextField = "DisplayName";
                    ddlBankAccount.DataValueField = "BankAccountID";
                    ddlBankAccount.DataBind();
                }
            }
            ddlBankAccount.Items.Insert(0, new System.Web.UI.WebControls.ListItem("-- No Bank Account --", ""));
        }

        private void GenerateInvoiceNumber()
        {
            using (SqlConnection conn = new SqlConnection(ConnStr))
            {
                string q = "SELECT ISNULL(MAX(InvoiceID), 0) + 1 FROM Invoices";
                using (SqlCommand cmd = new SqlCommand(q, conn))
                {
                    conn.Open();
                    int next = Convert.ToInt32(cmd.ExecuteScalar());
                    txtInvoiceNumber.Text = "INV-" + next.ToString("D4");
                }
            }
        }

        protected void btnSaveInvoice_Click(object sender, EventArgs e)
        {
            // Validate
            if (string.IsNullOrEmpty(txtInvoiceNumber.Text) || string.IsNullOrEmpty(txtInvoiceDate.Text) || string.IsNullOrEmpty(txtDueDate.Text))
            {
                ShowMessage("Invoice Number, Date, and Due Date are required.", false);
                return;
            }

            if (string.IsNullOrEmpty(ddlCustomer.SelectedValue))
            {
                ShowMessage("Please select a customer.", false);
                return;
            }

            // Parse items JSON
            var serializer = new JavaScriptSerializer();
            var items = serializer.Deserialize<InvoiceItemDTO[]>(hfItemsJSON.Value);

            if (items == null || items.Length == 0)
            {
                ShowMessage("Add at least one line item.", false);
                return;
            }

            decimal subtotal = 0;
            foreach (var item in items)
                subtotal += item.qty * item.price;

            // Dynamic tax rates
            decimal cgstPct = decimal.TryParse(hfCGST.Value, out decimal cp) ? cp : 0;
            decimal sgstPct = decimal.TryParse(hfSGST.Value, out decimal sp) ? sp : 0;
            decimal cgstAmount = subtotal * (cgstPct / 100m);
            decimal sgstAmount = subtotal * (sgstPct / 100m);
            decimal taxAmount = cgstAmount + sgstAmount;
            decimal totalAmount = subtotal + taxAmount;

            // Bank account (nullable)
            string bankAccId = ddlBankAccount.SelectedValue;

            int invoiceId;

            using (SqlConnection conn = new SqlConnection(ConnStr))
            {
                conn.Open();

                // Insert invoice
                string qInv = @"INSERT INTO Invoices (CompanyID, CustomerID, InvoiceNumber, InvoiceDate, DueDate, SubTotal, CGSTPercent, SGSTPercent, CGSTAmount, SGSTAmount, TaxAmount, TotalAmount, BankAccountID, PaymentStatus)
                                VALUES (@cid, @custid, @num, @date, @due, @sub, @cgstPct, @sgstPct, @cgstAmt, @sgstAmt, @tax, @total, @bankId, @status);
                                SELECT SCOPE_IDENTITY();";
                using (SqlCommand cmd = new SqlCommand(qInv, conn))
                {
                    cmd.Parameters.AddWithValue("@cid", hfCompanyID.Value);
                    cmd.Parameters.AddWithValue("@custid", ddlCustomer.SelectedValue);
                    cmd.Parameters.AddWithValue("@num", txtInvoiceNumber.Text.Trim());
                    cmd.Parameters.AddWithValue("@date", txtInvoiceDate.Text);
                    cmd.Parameters.AddWithValue("@due", txtDueDate.Text);
                    cmd.Parameters.AddWithValue("@sub", subtotal);
                    cmd.Parameters.AddWithValue("@cgstPct", cgstPct);
                    cmd.Parameters.AddWithValue("@sgstPct", sgstPct);
                    cmd.Parameters.AddWithValue("@cgstAmt", cgstAmount);
                    cmd.Parameters.AddWithValue("@sgstAmt", sgstAmount);
                    cmd.Parameters.AddWithValue("@tax", taxAmount);
                    cmd.Parameters.AddWithValue("@total", totalAmount);
                    cmd.Parameters.AddWithValue("@bankId", string.IsNullOrEmpty(bankAccId) ? (object)DBNull.Value : (object)int.Parse(bankAccId));
                    cmd.Parameters.AddWithValue("@status", ddlStatus.SelectedValue);
                    invoiceId = Convert.ToInt32(cmd.ExecuteScalar());
                }

                // Insert line items
                foreach (var item in items)
                {
                    string qItem = @"INSERT INTO InvoiceItems (InvoiceID, ItemName, ItemDescription, Quantity, UnitPrice)
                                     VALUES (@iid, @name, @desc, @qty, @price)";
                    using (SqlCommand cmd = new SqlCommand(qItem, conn))
                    {
                        cmd.Parameters.AddWithValue("@iid", invoiceId);
                        cmd.Parameters.AddWithValue("@name", item.name);
                        cmd.Parameters.AddWithValue("@desc", (object)item.desc ?? DBNull.Value);
                        cmd.Parameters.AddWithValue("@qty", item.qty);
                        cmd.Parameters.AddWithValue("@price", item.price);
                        cmd.ExecuteNonQuery();
                    }
                }
            }

            // Redirect to invoice view
            Response.Redirect("InvoiceView.aspx?InvoiceID=" + invoiceId);
        }

        private void ShowMessage(string msg, bool success)
        {
            lblMessage.Text = msg;
            lblMessage.CssClass = success ? "alert-msg alert-success" : "alert-msg alert-error";
            lblMessage.Visible = true;
        }

        // DTO for JSON deserialization
        public class InvoiceItemDTO
        {
            public string name { get; set; }
            public string desc { get; set; }
            public int qty { get; set; }
            public decimal price { get; set; }
        }
    }
}
