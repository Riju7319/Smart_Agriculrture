using System;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Web.UI;

namespace Smart_Agriculrture.Companies
{
    public partial class PublicInvoice : Page
    {
        private string ConnStr => ConfigurationManager.ConnectionStrings["SmartAgriDB"].ConnectionString;

        protected void Page_Load(object sender, EventArgs e)
        {
            // NO AuthHelper.CheckLogin() — this is a public page!
            if (!IsPostBack)
            {
                string invoiceId = Request.QueryString["id"];
                if (string.IsNullOrEmpty(invoiceId))
                {
                    pnlError.Visible = true;
                    return;
                }

                LoadPublicInvoice(invoiceId);
            }
        }

        private void LoadPublicInvoice(string invoiceId)
        {
            using (SqlConnection conn = new SqlConnection(ConnStr))
            {
                conn.Open();

                // Load invoice + company + customer
                string qInv = @"SELECT i.*, 
                                       c.CompanyName, c.ContactPerson, c.Email AS CompanyEmail, c.Phone AS CompanyPhone, c.Address AS CompanyAddress, c.TaxID_GSTIN, c.PANNumber,
                                       cu.CustomerName, cu.Email AS CustomerEmail, cu.Phone AS CustomerPhone, cu.Address AS CustomerAddress, cu.GSTIN AS CustomerGSTIN
                                FROM Invoices i
                                INNER JOIN Companies c ON i.CompanyID = c.CompanyID
                                LEFT JOIN Customers cu ON i.CustomerID = cu.CustomerID
                                WHERE i.InvoiceID = @id";
                using (SqlCommand cmd = new SqlCommand(qInv, conn))
                {
                    cmd.Parameters.AddWithValue("@id", invoiceId);
                    SqlDataReader r = cmd.ExecuteReader();
                    if (!r.Read())
                    {
                        pnlError.Visible = true;
                        r.Close();
                        return;
                    }

                    pnlInvoice.Visible = true;

                    // Company info
                    lblCompanyName.Text = r["CompanyName"].ToString();
                    lblFooterCompanyName.Text = r["CompanyName"].ToString();
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
                    string invoiceNum = r["InvoiceNumber"].ToString();
                    lblInvoiceNumber.Text = invoiceNum;
                    lblInvoiceNumberTop.Text = invoiceNum;
                    lblInvoiceDate.Text = Convert.ToDateTime(r["InvoiceDate"]).ToString("dd MMM yyyy");
                    DateTime dueDate = Convert.ToDateTime(r["DueDate"]);
                    lblDueDate.Text = dueDate.ToString("dd MMM yyyy");

                    // Show due warning if pending and not past due
                    string status = r["PaymentStatus"].ToString();
                    if (status != "Paid" && dueDate >= DateTime.Today)
                    {
                        pnlDueWarning.Visible = true;
                        lblDueDateWarning.Text = dueDate.ToString("dd MMMM yyyy");
                    }

                    // Status badge
                    string statusClass = status.ToLower().Replace(" ", "");
                    lblStatusBadge.Text = status;
                    lblStatusBadge.CssClass = "inv-badge badge-" + statusClass;
                    statusBanner.Attributes["class"] = "status-banner " + statusClass;

                    // Billed To
                    string customerName = r["CustomerName"]?.ToString();
                    if (!string.IsNullOrEmpty(customerName))
                    {
                        string custAddr = r["CustomerAddress"]?.ToString() ?? "";
                        string custPhone = r["CustomerPhone"]?.ToString() ?? "";
                        string custEmail = r["CustomerEmail"]?.ToString() ?? "";
                        string custGst = r["CustomerGSTIN"]?.ToString() ?? "";
                        lblBilledTo.Text = "<strong>" + customerName + "</strong>"
                            + (!string.IsNullOrEmpty(custAddr) ? "<br/>" + custAddr : "")
                            + (!string.IsNullOrEmpty(custPhone) ? "<br/>📞 " + custPhone : "")
                            + (!string.IsNullOrEmpty(custEmail) ? " | 📧 " + custEmail : "")
                            + (!string.IsNullOrEmpty(custGst) ? "<br/>GSTIN: " + custGst : "");
                    }
                    else
                    {
                        lblBilledTo.Text = "<strong>" + r["CompanyName"].ToString() + "</strong>";
                    }

                    // Totals
                    decimal subtotal = Convert.ToDecimal(r["SubTotal"]);
                    decimal total = Convert.ToDecimal(r["TotalAmount"]);
                    decimal cgstPct = r["CGSTPercent"] != DBNull.Value ? Convert.ToDecimal(r["CGSTPercent"]) : 0;
                    decimal sgstPct = r["SGSTPercent"] != DBNull.Value ? Convert.ToDecimal(r["SGSTPercent"]) : 0;
                    decimal cgstAmt = r["CGSTAmount"] != DBNull.Value ? Convert.ToDecimal(r["CGSTAmount"]) : 0;
                    decimal sgstAmt = r["SGSTAmount"] != DBNull.Value ? Convert.ToDecimal(r["SGSTAmount"]) : 0;

                    lblSubtotal.Text = string.Format("{0:N2}", subtotal);
                    lblCGSTPct.Text = cgstPct.ToString("0.##");
                    lblSGSTPct.Text = sgstPct.ToString("0.##");
                    lblCGST.Text = string.Format("{0:N2}", cgstAmt);
                    lblSGST.Text = string.Format("{0:N2}", sgstAmt);
                    lblGrandTotal.Text = string.Format("{0:N2}", total);
                    lblTotalTop.Text = string.Format("{0:N2}", total);

                    Page.Title = "Invoice #" + invoiceNum + " — ₹" + string.Format("{0:N2}", total);

                    // Store BankAccountID
                    string bankId = r["BankAccountID"] != DBNull.Value ? r["BankAccountID"].ToString() : null;
                    r.Close();

                    // Load line items
                    string qItems = "SELECT * FROM InvoiceItems WHERE InvoiceID = @id ORDER BY ItemID";
                    using (SqlCommand cmdItems = new SqlCommand(qItems, conn))
                    {
                        cmdItems.Parameters.AddWithValue("@id", invoiceId);
                        SqlDataAdapter da = new SqlDataAdapter(cmdItems);
                        DataTable dt = new DataTable();
                        da.Fill(dt);
                        rptItems.DataSource = dt;
                        rptItems.DataBind();
                    }

                    // Load bank details
                    if (!string.IsNullOrEmpty(bankId))
                    {
                        string qBank = "SELECT * FROM BankAccounts WHERE BankAccountID = @bid";
                        using (SqlCommand cmdBank = new SqlCommand(qBank, conn))
                        {
                            cmdBank.Parameters.AddWithValue("@bid", bankId);
                            SqlDataReader br = cmdBank.ExecuteReader();
                            if (br.Read())
                            {
                                lblBankName.Text = br["AccountName"].ToString();
                                lblBankAccNum.Text = br["AccountNumber"].ToString();
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
        }
    }
}
