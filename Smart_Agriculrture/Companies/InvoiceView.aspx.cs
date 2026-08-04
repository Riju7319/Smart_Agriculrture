using System;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Text;
using System.Web.UI;

namespace Smart_Agriculrture.Companies
{
    public partial class InvoiceView : Page
    {
        private string ConnStr => ConfigurationManager.ConnectionStrings["SmartAgriDB"].ConnectionString;

        protected void Page_Load(object sender, EventArgs e)
        {
            AuthHelper.CheckLogin();

            if (string.IsNullOrEmpty(Request.QueryString["InvoiceID"]))
            {
                Response.Redirect("Companies.aspx");
                return;
            }

            hfInvoiceID.Value = Request.QueryString["InvoiceID"];

            if (!IsPostBack)
            {
                LoadInvoice();
            }
        }

        private void LoadInvoice()
        {
            using (SqlConnection conn = new SqlConnection(ConnStr))
            {
                conn.Open();

                // Load invoice header
                string qInv = @"SELECT i.*, c.CompanyName, c.ContactPerson, c.Email AS CompanyEmail, c.Phone AS CompanyPhone, c.Address AS CompanyAddress, c.TaxID_GSTIN,
                                       cu.CustomerName, cu.Email AS CustomerEmail, cu.Phone AS CustomerPhone, cu.Address AS CustomerAddress, cu.GSTIN AS CustomerGSTIN
                                FROM Invoices i
                                INNER JOIN Companies c ON i.CompanyID = c.CompanyID
                                LEFT JOIN Customers cu ON i.CustomerID = cu.CustomerID
                                WHERE i.InvoiceID = @id";
                using (SqlCommand cmd = new SqlCommand(qInv, conn))
                {
                    cmd.Parameters.AddWithValue("@id", hfInvoiceID.Value);
                    SqlDataReader r = cmd.ExecuteReader();
                    if (r.Read())
                    {
                        hfCompanyID.Value = r["CompanyID"].ToString();
                        lnkBack.HRef = "CompanyDetails.aspx?CompanyID=" + hfCompanyID.Value;

                        // Company info
                        lblCompanyName.Text = r["CompanyName"].ToString();
                        lblCompanyAddress.Text = r["CompanyAddress"]?.ToString() ?? "";
                        lblCompanyContact.Text = "📞 " + (r["CompanyPhone"]?.ToString() ?? "") + " | 📧 " + (r["CompanyEmail"]?.ToString() ?? "");
                        string gstin = r["TaxID_GSTIN"]?.ToString();
                        if (!string.IsNullOrEmpty(gstin))
                        {
                            lblCompanyGST.Text = gstin;
                            phGST.Visible = true;
                        }
                        else
                        {
                            phGST.Visible = false;
                        }

                        string pan = r["PANNumber"]?.ToString();
                        if (!string.IsNullOrEmpty(pan))
                        {
                            lblCompanyPAN.Text = pan;
                            phPAN.Visible = true;
                        }
                        else
                        {
                            phPAN.Visible = false;
                        }

                        // Invoice info
                        lblInvoiceNumber.Text = r["InvoiceNumber"].ToString();
                        lblInvoiceDate.Text = Convert.ToDateTime(r["InvoiceDate"]).ToString("dd MMM yyyy");
                        lblDueDate.Text = Convert.ToDateTime(r["DueDate"]).ToString("dd MMM yyyy");

                        // Billed To — show customer if available, else company name
                        string customerName = r["CustomerName"]?.ToString();
                        if (!string.IsNullOrEmpty(customerName))
                        {
                            string custAddr = r["CustomerAddress"]?.ToString() ?? "";
                            string custPhone = r["CustomerPhone"]?.ToString() ?? "";
                            string custEmail = r["CustomerEmail"]?.ToString() ?? "";
                            string custGst = r["CustomerGSTIN"]?.ToString() ?? "";
                            lblBilledTo.Text = customerName
                                + (!string.IsNullOrEmpty(custAddr) ? "<br/>" + custAddr : "")
                                + (!string.IsNullOrEmpty(custPhone) ? "<br/>📞 " + custPhone : "")
                                + (!string.IsNullOrEmpty(custEmail) ? " | 📧 " + custEmail : "")
                                + (!string.IsNullOrEmpty(custGst) ? "<br/>GSTIN: " + custGst : "");
                        }
                        else
                        {
                            lblBilledTo.Text = r["CompanyName"].ToString();
                        }

                        bool isSent = Convert.ToBoolean(r["IsSent"]);
                        lblSentStatus.Text = isSent ? "✅ Sent" : "📝 Draft";

                        string status = r["PaymentStatus"].ToString();
                        lblStatusBadge.Text = status;
                        lblStatusBadge.CssClass = "inv-status-badge status-" + status.ToLower().Replace(" ", "");
                        ddlStatusUpdate.SelectedValue = status;

                        // Totals
                        decimal subtotal = Convert.ToDecimal(r["SubTotal"]);
                        decimal taxAmount = Convert.ToDecimal(r["TaxAmount"]);
                        decimal total = Convert.ToDecimal(r["TotalAmount"]);
                        decimal cgst = taxAmount / 2;
                        decimal sgst = taxAmount / 2;

                        lblSubtotal.Text = string.Format("{0:N2}", subtotal);

                        // Dynamic CGST/SGST from DB
                        decimal cgstPct = r["CGSTPercent"] != DBNull.Value ? Convert.ToDecimal(r["CGSTPercent"]) : 0;
                        decimal sgstPct = r["SGSTPercent"] != DBNull.Value ? Convert.ToDecimal(r["SGSTPercent"]) : 0;
                        decimal cgstAmt = r["CGSTAmount"] != DBNull.Value ? Convert.ToDecimal(r["CGSTAmount"]) : taxAmount / 2;
                        decimal sgstAmt = r["SGSTAmount"] != DBNull.Value ? Convert.ToDecimal(r["SGSTAmount"]) : taxAmount / 2;

                        lblCGSTPct.Text = cgstPct.ToString("0.##");
                        lblSGSTPct.Text = sgstPct.ToString("0.##");
                        lblCGST.Text = string.Format("{0:N2}", cgstAmt);
                        lblSGST.Text = string.Format("{0:N2}", sgstAmt);
                        lblGrandTotal.Text = string.Format("{0:N2}", total);

                        // Store BankAccountID for loading below
                        ViewState["BankAccountID"] = r["BankAccountID"] != DBNull.Value ? r["BankAccountID"].ToString() : null;
                    }
                    r.Close();
                }

                // Load line items
                string qItems = "SELECT * FROM InvoiceItems WHERE InvoiceID = @id ORDER BY ItemID";
                using (SqlCommand cmd = new SqlCommand(qItems, conn))
                {
                    cmd.Parameters.AddWithValue("@id", hfInvoiceID.Value);
                    SqlDataAdapter da = new SqlDataAdapter(cmd);
                    DataTable dt = new DataTable();
                    da.Fill(dt);
                    rptItems.DataSource = dt;
                    rptItems.DataBind();
                }

                // Load bank details
                string bankId = ViewState["BankAccountID"]?.ToString();
                if (!string.IsNullOrEmpty(bankId))
                {
                    string qBank = "SELECT * FROM BankAccounts WHERE BankAccountID = @bid";
                    using (SqlCommand cmd = new SqlCommand(qBank, conn))
                    {
                        cmd.Parameters.AddWithValue("@bid", bankId);
                        SqlDataReader br = cmd.ExecuteReader();
                        if (br.Read())
                        {
                            lblBankName.Text = br["AccountName"].ToString();
                            lblBankAccount.Text = br["AccountNumber"].ToString();
                            lblBankIFSC.Text = br["IFSCCode"]?.ToString() ?? "—";
                            lblBankUPI.Text = br["UPIID"]?.ToString() ?? "—";
                            string bankPan = br["PANNumber"]?.ToString();
                            if (!string.IsNullOrEmpty(bankPan))
                            {
                                lblBankPAN.Text = bankPan;
                                phBankPAN.Visible = true;
                            }
                            else
                            {
                                phBankPAN.Visible = false;
                            }
                            pnlBankDetails.Visible = true;
                        }
                        br.Close();
                    }
                }
            }
        }

        // ==================== UPDATE STATUS ====================
        protected void btnUpdateStatus_Click(object sender, EventArgs e)
        {
            using (SqlConnection conn = new SqlConnection(ConnStr))
            {
                string q = "UPDATE Invoices SET PaymentStatus = @status WHERE InvoiceID = @id";
                using (SqlCommand cmd = new SqlCommand(q, conn))
                {
                    cmd.Parameters.AddWithValue("@status", ddlStatusUpdate.SelectedValue);
                    cmd.Parameters.AddWithValue("@id", hfInvoiceID.Value);
                    conn.Open();
                    cmd.ExecuteNonQuery();
                }
            }

            ShowMessage("✅ Status updated to " + ddlStatusUpdate.SelectedValue, true);
            LoadInvoice();
        }

        // ==================== SEND EMAIL ====================
        protected void btnSendEmail_Click(object sender, EventArgs e)
        {
            try
            {
                string recipientEmail = "";
                using (SqlConnection conn = new SqlConnection(ConnStr))
                {
                    string q = @"SELECT COALESCE(cu.Email, c.Email, '') AS RecipientEmail
                                 FROM Invoices i
                                 INNER JOIN Companies c ON i.CompanyID = c.CompanyID
                                 LEFT JOIN Customers cu ON i.CustomerID = cu.CustomerID
                                 WHERE i.InvoiceID = @id";
                    using (SqlCommand cmd = new SqlCommand(q, conn))
                    {
                        cmd.Parameters.AddWithValue("@id", hfInvoiceID.Value);
                        conn.Open();
                        var result = cmd.ExecuteScalar();
                        recipientEmail = result?.ToString() ?? "";
                    }
                }

                if (string.IsNullOrEmpty(recipientEmail))
                {
                    ShowMessage("❌ No email address found for this customer or company.", false);
                    return;
                }

                // Build HTML email body
                StringBuilder body = new StringBuilder();
                body.Append("<div style='font-family:Inter,Arial,sans-serif;max-width:600px;margin:0 auto;'>");
                body.Append("<div style='background:#0f172a;color:#fff;padding:24px;border-radius:10px 10px 0 0;text-align:center;'>");
                body.Append("<h2 style='margin:0;'>📄 Invoice Notification</h2>");
                body.Append("</div>");
                body.Append("<div style='background:#fff;padding:28px;border:1px solid #e5e7eb;border-radius:0 0 10px 10px;'>");
                body.AppendFormat("<p style='font-size:15px;'>Dear Customer,</p>");
                body.AppendFormat("<p>Your invoice <strong>#{0}</strong> dated <strong>{1}</strong> has been generated.</p>", lblInvoiceNumber.Text, lblInvoiceDate.Text);
                body.AppendFormat("<div style='background:#f8fafc;border:1px solid #e5e7eb;border-radius:8px;padding:16px;margin:16px 0;text-align:center;'>");
                body.AppendFormat("<div style='color:#6b7280;font-size:12px;'>Grand Total</div>");
                body.AppendFormat("<div style='color:#2563eb;font-size:28px;font-weight:700;'>₹{0}</div>", lblGrandTotal.Text);
                body.AppendFormat("<div style='color:#6b7280;font-size:12px;margin-top:4px;'>Due by {0}</div>", lblDueDate.Text);
                body.Append("</div>");
                string publicUrl = Request.Url.GetLeftPart(UriPartial.Authority) + Request.ApplicationPath.TrimEnd('/') + "/Companies/PublicInvoice.aspx?id=" + hfInvoiceID.Value;

                body.Append("<p style='color:#6b7280;font-size:13px;'>Please process the payment at your earliest convenience.</p>");
                body.AppendFormat("<div style='text-align:center;margin-top:20px;'><a href='{0}' style='background:#2563eb;color:#fff;padding:12px 24px;text-decoration:none;border-radius:6px;font-weight:600;display:inline-block;'>View Invoice Online</a></div>", publicUrl);
                body.AppendFormat("<p style='color:#6b7280;font-size:12px;margin-top:20px;'>— {0}</p>", lblCompanyName.Text);
                body.Append("</div></div>");

                EmailHelper.SendEmail(recipientEmail, "Invoice #" + lblInvoiceNumber.Text + " — " + lblCompanyName.Text, body.ToString());

                // Mark as sent
                using (SqlConnection conn = new SqlConnection(ConnStr))
                {
                    string q = "UPDATE Invoices SET IsSent = 1 WHERE InvoiceID = @id";
                    using (SqlCommand cmd = new SqlCommand(q, conn))
                    {
                        cmd.Parameters.AddWithValue("@id", hfInvoiceID.Value);
                        conn.Open();
                        cmd.ExecuteNonQuery();
                    }
                }

                ShowMessage("✅ Invoice emailed to " + recipientEmail + " successfully!", true);
                LoadInvoice();
            }
            catch (Exception ex)
            {
                ShowMessage("❌ Email failed: " + ex.Message, false);
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
