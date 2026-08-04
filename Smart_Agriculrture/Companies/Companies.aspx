<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="Companies.aspx.cs" Inherits="Smart_Agriculrture.Companies.Companies" %>

<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>Companies — Smart Agriculture</title>
    <meta name="viewport" content="width=device-width, initial-scale=1" />
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700&display=swap" rel="stylesheet" />
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet" />
    <style>
        * { box-sizing: border-box; margin: 0; padding: 0; }
        body { font-family: 'Inter', sans-serif; background: #f0f2f5; min-height: 100vh; }

        .page-header {
            background: linear-gradient(135deg, #0f172a 0%, #1e293b 100%);
            padding: 28px 32px;
            color: #fff;
            display: flex;
            justify-content: space-between;
            align-items: center;
            flex-wrap: wrap;
            gap: 16px;
        }
        .page-header h1 { font-size: 24px; font-weight: 700; margin: 0; }
        .page-header .subtitle { color: #94a3b8; font-size: 13px; margin-top: 4px; }
        .header-actions { display: flex; gap: 10px; align-items: center; }

        .btn-add {
            background: linear-gradient(135deg, #059669, #047857);
            color: #fff; border: none; border-radius: 10px;
            padding: 10px 22px; font-size: 14px; font-weight: 600;
            cursor: pointer; transition: all 0.2s; font-family: 'Inter', sans-serif;
            text-decoration: none; display: inline-flex; align-items: center; gap: 6px;
        }
        .btn-add:hover { transform: translateY(-1px); box-shadow: 0 6px 20px rgba(5,150,105,0.4); color: #fff; }

        .btn-back {
            background: rgba(255,255,255,0.1); color: #cbd5e1; border: 1px solid rgba(255,255,255,0.15);
            border-radius: 10px; padding: 10px 18px; font-size: 13px; font-weight: 500;
            cursor: pointer; transition: all 0.2s; text-decoration: none;
            font-family: 'Inter', sans-serif; display: inline-flex; align-items: center; gap: 6px;
        }
        .btn-back:hover { background: rgba(255,255,255,0.2); color: #fff; }

        .content-area { padding: 28px 32px; max-width: 1400px; margin: 0 auto; }

        /* Search */
        .search-bar {
            margin-bottom: 24px; display: flex; gap: 12px; flex-wrap: wrap;
        }
        .search-bar input {
            flex: 1; min-width: 250px; padding: 10px 16px; border: 1.5px solid #d1d5db;
            border-radius: 10px; font-size: 14px; font-family: 'Inter', sans-serif;
            outline: none; background: #fff; transition: border-color 0.2s;
        }
        .search-bar input:focus { border-color: #2563eb; box-shadow: 0 0 0 3px rgba(37,99,235,0.12); }

        /* Company Cards Grid */
        .company-grid {
            display: flex; flex-wrap: wrap; gap: 20px;
        }
        .company-card {
            flex: 1 1 320px; max-width: 420px;
            background: #fff; border: 1.5px solid #e5e7eb; border-radius: 14px;
            padding: 24px; cursor: pointer;
            transition: transform 0.2s, box-shadow 0.2s, border-color 0.2s;
            text-decoration: none; color: inherit; display: block;
        }
        .company-card:hover {
            transform: translateY(-4px); box-shadow: 0 10px 30px rgba(0,0,0,0.08);
            border-color: #7c3aed; color: inherit;
        }
        .card-header-row { display: flex; justify-content: space-between; align-items: flex-start; margin-bottom: 14px; }
        .company-name { font-size: 17px; font-weight: 700; color: #1a1a2e; margin: 0; }
        .contact-person { font-size: 12px; color: #6b7280; margin-top: 2px; }
        .unpaid-badge {
            background: #fef2f2; color: #dc2626; font-size: 11px; font-weight: 700;
            padding: 4px 10px; border-radius: 20px; border: 1px solid #fecaca; white-space: nowrap;
        }
        .paid-badge {
            background: #ecfdf5; color: #059669; font-size: 11px; font-weight: 700;
            padding: 4px 10px; border-radius: 20px; border: 1px solid #a7f3d0; white-space: nowrap;
        }
        .contact-row { display: flex; gap: 16px; font-size: 12px; color: #6b7280; margin-bottom: 16px; flex-wrap: wrap; }
        .contact-row span { display: flex; align-items: center; gap: 4px; }

        .metrics-row { display: flex; gap: 8px; }
        .metric-box {
            flex: 1; text-align: center; padding: 10px 8px;
            border-radius: 10px; background: #f8fafc; border: 1px solid #f1f5f9;
        }
        .metric-box .metric-label { font-size: 10px; font-weight: 600; text-transform: uppercase; letter-spacing: 0.5px; color: #9ca3af; }
        .metric-box .metric-value { font-size: 16px; font-weight: 700; margin-top: 2px; }
        .metric-income { color: #059669; }
        .metric-expense { color: #dc2626; }
        .metric-profit { color: #2563eb; }
        .metric-loss { color: #dc2626; }

        .empty-state {
            text-align: center; padding: 80px 20px; color: #9ca3af;
        }
        .empty-state .empty-icon { font-size: 56px; margin-bottom: 16px; }
        .empty-state h3 { font-size: 20px; color: #374151; font-weight: 600; }
        .empty-state p { font-size: 14px; margin-top: 6px; }

        /* Modal */
        .modal-overlay {
            display: none; position: fixed; top: 0; left: 0; width: 100%; height: 100%;
            background: rgba(0,0,0,0.5); z-index: 1000; justify-content: center; align-items: center;
        }
        .modal-overlay.active { display: flex; }
        .modal-box {
            background: #fff; border-radius: 16px; width: 95%; max-width: 520px;
            padding: 32px; box-shadow: 0 20px 60px rgba(0,0,0,0.2);
            animation: modalSlideUp 0.3s ease-out;
        }
        @keyframes modalSlideUp {
            from { opacity: 0; transform: translateY(30px); }
            to { opacity: 1; transform: translateY(0); }
        }
        .modal-box h3 { font-size: 20px; font-weight: 700; color: #1a1a2e; margin-bottom: 20px; }
        .modal-box label { display: block; font-size: 13px; font-weight: 500; color: #374151; margin-bottom: 4px; margin-top: 14px; }
        .modal-box input, .modal-box textarea {
            width: 100%; padding: 10px 13px; border: 1.5px solid #d1d5db; border-radius: 8px;
            font-size: 14px; font-family: 'Inter', sans-serif; outline: none; background: #f9fafb;
            transition: border-color 0.2s;
        }
        .modal-box input:focus, .modal-box textarea:focus { border-color: #2563eb; background: #fff; }
        .modal-box textarea { resize: vertical; min-height: 60px; }
        .modal-actions { display: flex; gap: 10px; margin-top: 22px; justify-content: flex-end; }
        .btn-save {
            background: linear-gradient(135deg, #2563eb, #1d4ed8); color: #fff; border: none;
            border-radius: 8px; padding: 10px 24px; font-size: 14px; font-weight: 600;
            cursor: pointer; font-family: 'Inter', sans-serif; transition: all 0.2s;
        }
        .btn-save:hover { transform: translateY(-1px); box-shadow: 0 4px 14px rgba(37,99,235,0.4); }
        .btn-cancel {
            background: #f3f4f6; color: #374151; border: 1px solid #d1d5db;
            border-radius: 8px; padding: 10px 20px; font-size: 14px; font-weight: 500;
            cursor: pointer; font-family: 'Inter', sans-serif; transition: all 0.2s;
        }
        .btn-cancel:hover { background: #e5e7eb; }

        .alert-msg {
            padding: 12px 16px; border-radius: 10px; font-size: 14px; font-weight: 600;
            margin-bottom: 20px; text-align: center;
        }
        .alert-success { background: #ecfdf5; color: #059669; border: 1px solid #a7f3d0; }
        .alert-error { background: #fef2f2; color: #dc2626; border: 1px solid #fecaca; }

        @media (max-width: 768px) {
            .page-header { padding: 20px 16px; }
            .content-area { padding: 16px; }
            .company-card { max-width: 100%; }
        }
    </style>
</head>
<body>
<form id="form1" runat="server">

    <!-- Header -->
    <div class="page-header">
        <div>
            <h1>🏢 Companies</h1>
            <div class="subtitle">Manage your companies, invoices, and finances</div>
        </div>
        <div class="header-actions">
            <a href="../WeatherData/ViewSensoreData.aspx" class="btn-back">← Dashboard</a>
            <button type="button" class="btn-add" onclick="openModal()">➕ Add Company</button>
        </div>
    </div>

    <div class="content-area">
        <!-- Message -->
        <asp:Label ID="lblMessage" runat="server" Visible="false" />

        <!-- Search -->
        <div class="search-bar">
            <asp:TextBox ID="txtSearch" runat="server" placeholder="🔍 Search companies..." AutoPostBack="true" OnTextChanged="txtSearch_TextChanged" />
        </div>

        <!-- Company Grid -->
        <div class="company-grid">
            <asp:Repeater ID="rptCompanies" runat="server" OnItemCommand="rptCompanies_ItemCommand">
                <ItemTemplate>
                    <div class="company-card" style="position:relative;">
                        <div style="position:absolute; top:12px; right:12px; z-index:10;">
                            <asp:LinkButton ID="btnDeleteCompany" runat="server" CommandName="DeleteCompany" CommandArgument='<%# Eval("CompanyID") %>' OnClientClick="return confirm('WARNING: This will permanently delete this company and ALL associated invoices, customers, expenses, bank accounts, and notes. Are you sure?');" CssClass="btn-sm-action" ForeColor="Red" style="background:#fee2e2; border-radius:4px; padding:4px 8px; font-size:12px; text-decoration:none;">🗑 Delete</asp:LinkButton>
                        </div>
                        <a href='<%# "CompanyDetails.aspx?CompanyID=" + Eval("CompanyID") %>' style="text-decoration:none; color:inherit; display:block; margin-top:20px;">
                        <div class="card-header-row">
                            <div>
                                <h4 class="company-name"><%# Eval("CompanyName") %></h4>
                                <div class="contact-person"><%# Eval("ContactPerson") %></div>
                            </div>
                            <span class='<%# Convert.ToInt32(Eval("UnpaidInvoiceCount")) > 0 ? "unpaid-badge" : "paid-badge" %>'>
                                <%# Convert.ToInt32(Eval("UnpaidInvoiceCount")) > 0 ? Eval("UnpaidInvoiceCount") + " Unpaid" : "✓ Clear" %>
                            </span>
                        </div>
                        <div class="contact-row">
                            <span>📧 <%# Eval("Email") != DBNull.Value && !string.IsNullOrEmpty(Eval("Email")?.ToString()) ? Eval("Email") : "—" %></span>
                            <span>📞 <%# Eval("Phone") != DBNull.Value && !string.IsNullOrEmpty(Eval("Phone")?.ToString()) ? Eval("Phone") : "—" %></span>
                        </div>
                        <div class="metrics-row">
                            <div class="metric-box">
                                <div class="metric-label">Income</div>
                                <div class="metric-value metric-income">₹<%# string.Format("{0:N0}", Eval("TotalIncome")) %></div>
                            </div>
                            <div class="metric-box">
                                <div class="metric-label">Expenses</div>
                                <div class="metric-value metric-expense">₹<%# string.Format("{0:N0}", Eval("TotalExpenses")) %></div>
                            </div>
                            <div class="metric-box">
                                <div class="metric-label">Profit/Loss</div>
                                <div class='<%# Convert.ToDecimal(Eval("NetProfitLoss")) >= 0 ? "metric-value metric-profit" : "metric-value metric-loss" %>'>
                                    ₹<%# string.Format("{0:N0}", Eval("NetProfitLoss")) %>
                                </div>
                            </div>
                        </div>
                        </a>
                    </div>
                </ItemTemplate>
            </asp:Repeater>
        </div>

        <!-- Empty State -->
        <asp:Panel ID="pnlEmpty" runat="server" Visible="false">
            <div class="empty-state">
                <div class="empty-icon">🏢</div>
                <h3>No companies yet</h3>
                <p>Click "Add Company" to create your first company</p>
            </div>
        </asp:Panel>
    </div>

    <!-- Add Company Modal -->
    <div class="modal-overlay" id="addModal">
        <div class="modal-box">
            <h3>➕ Add New Company</h3>
            <label>Company Name *</label>
            <asp:TextBox ID="txtCompanyName" runat="server" placeholder="Enter company name" />
            <label>Contact Person</label>
            <asp:TextBox ID="txtContactPerson" runat="server" placeholder="Primary contact name" />
            <label>Email</label>
            <asp:TextBox ID="txtEmail" runat="server" TextMode="Email" placeholder="company@example.com" />
            <label>Phone</label>
            <asp:TextBox ID="txtPhone" runat="server" placeholder="Phone number" />
            <label>GSTIN / Tax ID</label>
            <asp:TextBox ID="txtGSTIN" runat="server" placeholder="e.g. 22AAAAA0000A1Z5" />
            <label>PAN Number</label>
            <asp:TextBox ID="txtPAN" runat="server" placeholder="e.g. ABCDE1234F" />
            <label>Address</label>
            <asp:TextBox ID="txtAddress" runat="server" TextMode="MultiLine" Rows="2" placeholder="Full address" />
            <div class="modal-actions">
                <button type="button" class="btn-cancel" onclick="closeModal()">Cancel</button>
                <asp:Button ID="btnSaveCompany" runat="server" Text="Save Company" CssClass="btn-save" OnClick="btnSaveCompany_Click" />
            </div>
        </div>
    </div>

</form>
<script>
    function openModal() { document.getElementById('addModal').classList.add('active'); }
    function closeModal() { document.getElementById('addModal').classList.remove('active'); }
    document.getElementById('addModal').addEventListener('click', function(e) { if (e.target === this) closeModal(); });
</script>
</body>
</html>
