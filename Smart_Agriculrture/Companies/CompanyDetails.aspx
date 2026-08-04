<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="CompanyDetails.aspx.cs" Inherits="Smart_Agriculrture.Companies.CompanyDetails" %>

<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>Company Dashboard — Smart Agriculture</title>
    <meta name="viewport" content="width=device-width, initial-scale=1" />
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700&display=swap" rel="stylesheet" />
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet" />
    <style>
        * { box-sizing: border-box; margin: 0; padding: 0; }
        body { font-family: 'Inter', sans-serif; background: #f0f2f5; }

        .page-header {
            background: linear-gradient(135deg, #0f172a 0%, #1e293b 100%);
            padding: 24px 32px; color: #fff;
            display: flex; justify-content: space-between; align-items: center; flex-wrap: wrap; gap: 12px;
        }
        .page-header h1 { font-size: 22px; font-weight: 700; margin: 0; }
        .page-header .subtitle { color: #94a3b8; font-size: 13px; margin-top: 2px; }
        .header-actions { display: flex; gap: 10px; flex-wrap: wrap; }
        .btn-hdr { padding: 9px 18px; border-radius: 8px; font-size: 13px; font-weight: 600; cursor: pointer; border: none; font-family: 'Inter', sans-serif; transition: all 0.2s; text-decoration: none; display: inline-flex; align-items: center; gap: 5px; }
        .btn-back { background: rgba(255,255,255,0.1); color: #cbd5e1; border: 1px solid rgba(255,255,255,0.15); }
        .btn-back:hover { background: rgba(255,255,255,0.2); color: #fff; }
        .btn-export { background: linear-gradient(135deg, #2563eb, #1d4ed8); color: #fff; }
        .btn-export:hover { box-shadow: 0 4px 14px rgba(37,99,235,0.4); color: #fff; }

        .content-area { padding: 24px 32px; max-width: 1300px; margin: 0 auto; }

        /* Metric Cards */
        .metrics-bar { display: flex; gap: 16px; margin-bottom: 24px; flex-wrap: wrap; }
        .metric-card {
            flex: 1; min-width: 200px; background: #fff; border: 1.5px solid #e5e7eb;
            border-radius: 14px; padding: 20px; text-align: center;
            transition: transform 0.2s, box-shadow 0.2s;
        }
        .metric-card:hover { transform: translateY(-3px); box-shadow: 0 6px 16px rgba(0,0,0,0.06); }
        .metric-card .mc-label { font-size: 11px; font-weight: 600; text-transform: uppercase; letter-spacing: 0.5px; color: #9ca3af; }
        .metric-card .mc-value { font-size: 26px; font-weight: 700; margin-top: 4px; }
        .mc-income { color: #059669; }
        .mc-expense { color: #dc2626; }
        .mc-balance { color: #2563eb; }

        /* Tabs */
        .tabs { display: flex; gap: 0; border-bottom: 2px solid #e5e7eb; margin-bottom: 24px; flex-wrap: wrap; }
        .tab-btn {
            padding: 12px 24px; font-size: 14px; font-weight: 600; color: #6b7280;
            cursor: pointer; border: none; background: none; border-bottom: 3px solid transparent;
            margin-bottom: -2px; font-family: 'Inter', sans-serif; transition: all 0.2s;
        }
        .tab-btn:hover { color: #2563eb; }
        .tab-btn.active { color: #2563eb; border-bottom-color: #2563eb; }
        .tab-panel { display: none; }
        .tab-panel.active { display: block; }

        /* Action bar */
        .action-bar { display: flex; justify-content: space-between; align-items: center; margin-bottom: 16px; flex-wrap: wrap; gap: 10px; }
        .btn-add-sm {
            background: linear-gradient(135deg, #059669, #047857); color: #fff; border: none;
            border-radius: 8px; padding: 9px 18px; font-size: 13px; font-weight: 600;
            cursor: pointer; font-family: 'Inter', sans-serif; transition: all 0.2s;
        }
        .btn-add-sm:hover { transform: translateY(-1px); box-shadow: 0 4px 14px rgba(5,150,105,0.4); }

        .filter-row { display: flex; gap: 8px; flex-wrap: wrap; align-items: center; }
        .filter-row select, .filter-row input {
            padding: 8px 12px; border: 1.5px solid #d1d5db; border-radius: 8px; font-size: 13px;
            font-family: 'Inter', sans-serif; outline: none; background: #fff;
        }
        .filter-row select:focus, .filter-row input:focus { border-color: #2563eb; }

        /* Table */
        .data-table { background: #fff; border: 1.5px solid #e5e7eb; border-radius: 14px; overflow: hidden; }
        .table { margin: 0; }
        .table thead th {
            background: #f8fafc; font-size: 11px; font-weight: 600; text-transform: uppercase;
            letter-spacing: 0.5px; color: #64748b; border-bottom: 2px solid #e2e8f0; padding: 12px 14px;
        }
        .table tbody td { padding: 11px 14px; font-size: 13px; color: #374151; vertical-align: middle; }
        .table-striped > tbody > tr:nth-of-type(odd) > * { background-color: #fafbfc; }

        .badge-status { padding: 4px 10px; border-radius: 20px; font-size: 11px; font-weight: 700; }
        .badge-paid { background: #ecfdf5; color: #059669; }
        .badge-pending { background: #fffbeb; color: #d97706; }
        .badge-overdue { background: #fef2f2; color: #dc2626; }
        .badge-partial { background: #eff6ff; color: #2563eb; }
        .badge-sent { background: #ecfdf5; color: #059669; }
        .badge-draft { background: #f3f4f6; color: #6b7280; }

        .btn-sm-action {
            padding: 5px 12px; border-radius: 6px; font-size: 12px; font-weight: 600;
            border: 1px solid #d1d5db; background: #fff; color: #374151; cursor: pointer;
            font-family: 'Inter', sans-serif; transition: all 0.15s; margin: 1px;
        }
        .btn-sm-action:hover { background: #f3f4f6; border-color: #9ca3af; }
        .btn-sm-action.btn-paid { background: #ecfdf5; color: #059669; border-color: #a7f3d0; }

        /* Note card */
        .note-card {
            background: #fff; border: 1.5px solid #e5e7eb; border-radius: 12px;
            padding: 16px 20px; margin-bottom: 12px;
        }
        .note-card .note-meta { font-size: 11px; color: #9ca3af; margin-bottom: 6px; }
        .note-card .note-text { font-size: 14px; color: #374151; line-height: 1.6; }

        /* Company detail form */
        .detail-form { background: #fff; border: 1.5px solid #e5e7eb; border-radius: 14px; padding: 28px; max-width: 600px; }
        .detail-form label { display: block; font-size: 13px; font-weight: 500; color: #374151; margin-bottom: 4px; margin-top: 14px; }
        .detail-form input, .detail-form textarea {
            width: 100%; padding: 10px 13px; border: 1.5px solid #d1d5db; border-radius: 8px;
            font-size: 14px; font-family: 'Inter', sans-serif; outline: none; background: #f9fafb;
        }
        .detail-form input:focus, .detail-form textarea:focus { border-color: #2563eb; background: #fff; }
        .btn-update {
            background: linear-gradient(135deg, #2563eb, #1d4ed8); color: #fff; border: none;
            border-radius: 8px; padding: 10px 24px; font-size: 14px; font-weight: 600;
            cursor: pointer; font-family: 'Inter', sans-serif; margin-top: 18px; transition: all 0.2s;
        }
        .btn-update:hover { transform: translateY(-1px); box-shadow: 0 4px 14px rgba(37,99,235,0.4); }

        /* Modal */
        .modal-overlay { display: none; position: fixed; top: 0; left: 0; width: 100%; height: 100%; background: rgba(0,0,0,0.5); z-index: 1000; justify-content: center; align-items: center; }
        .modal-overlay.active { display: flex; }
        .modal-box { background: #fff; border-radius: 16px; width: 95%; max-width: 520px; padding: 28px; box-shadow: 0 20px 60px rgba(0,0,0,0.2); animation: modalIn 0.3s ease-out; }
        @keyframes modalIn { from { opacity: 0; transform: translateY(20px); } to { opacity: 1; transform: translateY(0); } }
        .modal-box h3 { font-size: 18px; font-weight: 700; color: #1a1a2e; margin-bottom: 16px; }
        .modal-box label { display: block; font-size: 13px; font-weight: 500; color: #374151; margin-bottom: 4px; margin-top: 12px; }
        .modal-box input, .modal-box select, .modal-box textarea {
            width: 100%; padding: 9px 12px; border: 1.5px solid #d1d5db; border-radius: 8px;
            font-size: 13px; font-family: 'Inter', sans-serif; outline: none; background: #f9fafb;
        }
        .modal-box input:focus, .modal-box select:focus, .modal-box textarea:focus { border-color: #2563eb; background: #fff; }
        .modal-actions { display: flex; gap: 10px; margin-top: 18px; justify-content: flex-end; }
        .btn-save { background: linear-gradient(135deg, #2563eb, #1d4ed8); color: #fff; border: none; border-radius: 8px; padding: 9px 22px; font-size: 13px; font-weight: 600; cursor: pointer; font-family: 'Inter', sans-serif; }
        .btn-cancel { background: #f3f4f6; color: #374151; border: 1px solid #d1d5db; border-radius: 8px; padding: 9px 18px; font-size: 13px; cursor: pointer; font-family: 'Inter', sans-serif; }

        .alert-msg { padding: 10px 16px; border-radius: 8px; font-size: 13px; font-weight: 600; margin-bottom: 16px; text-align: center; }
        .alert-success { background: #ecfdf5; color: #059669; border: 1px solid #a7f3d0; }
        .alert-error { background: #fef2f2; color: #dc2626; border: 1px solid #fecaca; }

        .pagination-row { display: flex; justify-content: center; margin-top: 16px; }

        @media (max-width: 768px) {
            .page-header { padding: 18px 16px; }
            .content-area { padding: 16px; }
            .metric-card { min-width: 140px; }
        }
    </style>
</head>
<body>
<form id="form1" runat="server">
    <asp:HiddenField ID="hfCompanyID" runat="server" />
    <asp:HiddenField ID="hfActiveTab" runat="server" Value="invoices" />

    <!-- Header -->
    <div class="page-header">
        <div>
            <h1>🏢 <asp:Label ID="lblCompanyName" runat="server" /></h1>
            <div class="subtitle"><asp:Label ID="lblCompanySubtitle" runat="server" /></div>
        </div>
        <div class="header-actions">
            <a href="Companies.aspx" class="btn-hdr btn-back">← Back</a>
            <asp:Button ID="btnExportExcel" runat="server" Text="📥 Export Excel" CssClass="btn-hdr btn-export" OnClick="btnExportExcel_Click" CausesValidation="false" />
        </div>
    </div>

    <div class="content-area">
        <asp:Label ID="lblMessage" runat="server" Visible="false" />

        <!-- Metrics -->
        <div class="metrics-bar">
            <div class="metric-card">
                <div class="mc-label">Total Income</div>
                <div class="mc-value mc-income">₹<asp:Label ID="lblTotalIncome" runat="server" Text="0" /></div>
            </div>
            <div class="metric-card">
                <div class="mc-label">Total Expenses</div>
                <div class="mc-value mc-expense">₹<asp:Label ID="lblTotalExpenses" runat="server" Text="0" /></div>
            </div>
            <div class="metric-card">
                <div class="mc-label">Net Balance</div>
                <div class="mc-value mc-balance">₹<asp:Label ID="lblNetBalance" runat="server" Text="0" /></div>
            </div>
        </div>

        <!-- Tabs -->
        <div class="tabs">
            <button type="button" class="tab-btn active" onclick="switchTab('invoices')">📄 Invoices</button>
            <button type="button" class="tab-btn" onclick="switchTab('customers')">👥 Customers</button>
            <button type="button" class="tab-btn" onclick="switchTab('expenses')">💸 Expenses</button>
            <button type="button" class="tab-btn" onclick="switchTab('notes')">📝 Notes</button>
            <button type="button" class="tab-btn" onclick="switchTab('details')">🏢 Company Details</button>
        </div>

        <%-- =============== INVOICES TAB =============== --%>
        <div id="tab-invoices" class="tab-panel active">
            <div class="action-bar">
                <a href='<%# "CreateInvoice.aspx?CompanyID=" + hfCompanyID.Value %>' class="btn-add-sm" id="lnkCreateInvoice">➕ Create Invoice</a>
                <div class="filter-row">
                    <asp:TextBox ID="txtInvSearch" runat="server" placeholder="🔍 Search..." AutoPostBack="true" OnTextChanged="FilterInvoices" />
                    <asp:DropDownList ID="ddlPaymentStatus" runat="server" AutoPostBack="true" OnSelectedIndexChanged="FilterInvoices">
                        <asp:ListItem Text="All Status" Value="" />
                        <asp:ListItem Text="Paid" Value="Paid" />
                        <asp:ListItem Text="Pending" Value="Pending" />
                        <asp:ListItem Text="Partially Paid" Value="Partially Paid" />
                        <asp:ListItem Text="Overdue" Value="Overdue" />
                    </asp:DropDownList>
                </div>
            </div>
            <div class="data-table">
                <asp:GridView ID="gvInvoices" runat="server" AutoGenerateColumns="false"
                    CssClass="table table-striped" GridLines="None" AllowPaging="true" PageSize="10"
                    OnPageIndexChanging="gvInvoices_PageIndexChanging"
                    OnRowCommand="gvInvoices_RowCommand" EmptyDataText="No invoices found.">
                    <Columns>
                        <asp:BoundField DataField="InvoiceNumber" HeaderText="Invoice #" />
                        <asp:BoundField DataField="InvoiceDate" HeaderText="Date" DataFormatString="{0:dd MMM yyyy}" />
                        <asp:BoundField DataField="DueDate" HeaderText="Due Date" DataFormatString="{0:dd MMM yyyy}" />
                        <asp:BoundField DataField="TotalAmount" HeaderText="Amount (₹)" DataFormatString="{0:N2}" />
                        <asp:TemplateField HeaderText="Sent">
                            <ItemTemplate>
                                <span class='<%# Convert.ToBoolean(Eval("IsSent")) ? "badge-status badge-sent" : "badge-status badge-draft" %>'>
                                    <%# Convert.ToBoolean(Eval("IsSent")) ? "Sent" : "Draft" %>
                                </span>
                            </ItemTemplate>
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="Status">
                            <ItemTemplate>
                                <span class='<%# "badge-status badge-" + Eval("PaymentStatus").ToString().ToLower().Replace(" ","").Replace("partiallypaid","partial") %>'>
                                    <%# Eval("PaymentStatus") %>
                                </span>
                            </ItemTemplate>
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="Actions">
                            <ItemTemplate>
                                <a href='<%# "InvoiceView.aspx?InvoiceID=" + Eval("InvoiceID") %>' class="btn-sm-action">👁 View</a>
                                <asp:LinkButton ID="btnMarkPaid" runat="server" CommandName="MarkPaid" CommandArgument='<%# Eval("InvoiceID") %>' CssClass="btn-sm-action btn-paid" CausesValidation="false">✓ Paid</asp:LinkButton>
                                <a href='<%# "CreateInvoice.aspx?clone=" + Eval("InvoiceID") %>' class="btn-sm-action">📋 Clone</a>
                                <asp:LinkButton ID="btnDeleteInv" runat="server" CommandName="DeleteInv" CommandArgument='<%# Eval("InvoiceID") %>' CssClass="btn-sm-action" ForeColor="Red" OnClientClick="return confirm('Delete this invoice?');" CausesValidation="false">🗑 Delete</asp:LinkButton>
                            </ItemTemplate>
                        </asp:TemplateField>
                    </Columns>
                    <PagerStyle CssClass="pagination-row" />
                </asp:GridView>
            </div>
        </div>

        <%-- =============== CUSTOMERS TAB =============== --%>
        <div id="tab-customers" class="tab-panel">
            <div class="action-bar">
                <button type="button" class="btn-add-sm" onclick="openCustomerModal()">➕ Add Customer</button>
            </div>
            <div class="data-table">
                <asp:GridView ID="gvCustomers" runat="server" AutoGenerateColumns="false"
                    CssClass="table table-striped" GridLines="None" AllowPaging="true" PageSize="10"
                    OnPageIndexChanging="gvCustomers_PageIndexChanging" 
                    OnRowCommand="gvCustomers_RowCommand" EmptyDataText="No customers found.">
                    <Columns>
                        <asp:BoundField DataField="CustomerID" HeaderText="ID" />
                        <asp:BoundField DataField="CustomerName" HeaderText="Customer Name" />
                        <asp:BoundField DataField="Email" HeaderText="Email" />
                        <asp:BoundField DataField="Phone" HeaderText="Phone" />
                        <asp:BoundField DataField="Address" HeaderText="Address" />
                        <asp:BoundField DataField="GSTIN" HeaderText="GSTIN" />
                        <asp:TemplateField HeaderText="Actions">
                            <ItemTemplate>
                                <asp:LinkButton ID="btnEditCust" runat="server" CommandName="EditCust" CommandArgument='<%# Eval("CustomerID") %>' CssClass="btn-sm-action" CausesValidation="false">✏️ Edit</asp:LinkButton>
                                <asp:LinkButton ID="btnDeleteCust" runat="server" CommandName="DeleteCust" CommandArgument='<%# Eval("CustomerID") %>' CssClass="btn-sm-action" ForeColor="Red" OnClientClick="return confirm('Delete this customer?');" CausesValidation="false">🗑 Delete</asp:LinkButton>
                            </ItemTemplate>
                        </asp:TemplateField>
                    </Columns>
                    <PagerStyle CssClass="pagination-row" />
                </asp:GridView>
            </div>
        </div>

        <%-- =============== EXPENSES TAB =============== --%>
        <div id="tab-expenses" class="tab-panel">
            <div class="action-bar">
                <button type="button" class="btn-add-sm" onclick="openExpenseModal()">➕ Add Expense</button>
            </div>
            <div class="data-table">
                <asp:GridView ID="gvExpenses" runat="server" AutoGenerateColumns="false"
                    CssClass="table table-striped" GridLines="None" AllowPaging="true" PageSize="10"
                    OnPageIndexChanging="gvExpenses_PageIndexChanging" 
                    OnRowCommand="gvExpenses_RowCommand" EmptyDataText="No expenses found.">
                    <Columns>
                        <asp:BoundField DataField="ExpenseID" HeaderText="ID" />
                        <asp:BoundField DataField="ExpenseDate" HeaderText="Date" DataFormatString="{0:dd MMM yyyy}" />
                        <asp:BoundField DataField="Category" HeaderText="Category" />
                        <asp:BoundField DataField="Amount" HeaderText="Amount (₹)" DataFormatString="{0:N2}" />
                        <asp:BoundField DataField="PaymentMethod" HeaderText="Payment" />
                        <asp:BoundField DataField="Description" HeaderText="Description" />
                        <asp:TemplateField HeaderText="Actions">
                            <ItemTemplate>
                                <asp:LinkButton ID="btnEditExp" runat="server" CommandName="EditExp" CommandArgument='<%# Eval("ExpenseID") %>' CssClass="btn-sm-action" CausesValidation="false">✏️ Edit</asp:LinkButton>
                                <asp:LinkButton ID="btnDeleteExp" runat="server" CommandName="DeleteExp" CommandArgument='<%# Eval("ExpenseID") %>' CssClass="btn-sm-action" ForeColor="Red" OnClientClick="return confirm('Delete this expense?');" CausesValidation="false">🗑 Delete</asp:LinkButton>
                            </ItemTemplate>
                        </asp:TemplateField>
                    </Columns>
                    <PagerStyle CssClass="pagination-row" />
                </asp:GridView>
            </div>
        </div>

        <%-- =============== NOTES TAB =============== --%>
        <div id="tab-notes" class="tab-panel">
            <div class="action-bar">
                <button type="button" class="btn-add-sm" onclick="openNoteModal()">➕ Add Note</button>
            </div>
            <asp:Repeater ID="rptNotes" runat="server" OnItemCommand="rptNotes_ItemCommand">
                <ItemTemplate>
                    <div class="note-card">
                        <div class="note-meta">
                            📅 <%# Eval("CreatedDate", "{0:dd MMM yyyy, hh:mm tt}") %> — <%# Eval("CreatedBy") %>
                            <div style="float:right;">
                                <asp:LinkButton ID="btnEditNote" runat="server" CommandName="EditNote" CommandArgument='<%# Eval("NoteID") %>' CssClass="btn-sm-action" CausesValidation="false">✏️</asp:LinkButton>
                                <asp:LinkButton ID="btnDeleteNote" runat="server" CommandName="DeleteNote" CommandArgument='<%# Eval("NoteID") %>' CssClass="btn-sm-action" ForeColor="Red" OnClientClick="return confirm('Delete this note?');" CausesValidation="false">🗑</asp:LinkButton>
                            </div>
                        </div>
                        <div class="note-text"><%# Eval("NoteText") %></div>
                    </div>
                </ItemTemplate>
            </asp:Repeater>
            <asp:Label ID="lblNoNotes" runat="server" Text="No notes yet." CssClass="text-muted" Visible="false" style="display:block;text-align:center;padding:40px;" />
        </div>

        <%-- =============== COMPANY DETAILS TAB =============== --%>
        <div id="tab-details" class="tab-panel">
            <div class="detail-form">
                <label>Company Name</label>
                <asp:TextBox ID="txtEditName" runat="server" />
                <label>Contact Person</label>
                <asp:TextBox ID="txtEditContact" runat="server" />
                <label>Email</label>
                <asp:TextBox ID="txtEditEmail" runat="server" TextMode="Email" />
                <label>Phone</label>
                <asp:TextBox ID="txtEditPhone" runat="server" />
                <label>GSTIN / Tax ID</label>
                <asp:TextBox ID="txtEditGSTIN" runat="server" />
                <label>PAN Number</label>
                <asp:TextBox ID="txtEditPAN" runat="server" />
                <label>Address</label>
                <asp:TextBox ID="txtEditAddress" runat="server" TextMode="MultiLine" Rows="3" />
                <asp:Button ID="btnUpdateCompany" runat="server" Text="✏️ Update Details" CssClass="btn-update" OnClick="btnUpdateCompany_Click" />
            </div>

            <hr style="margin: 28px 0; border-color: #e5e7eb;" />

            <!-- Bank Accounts Section -->
            <h4 style="font-size:16px;font-weight:700;margin-bottom:14px;">🏦 Bank Accounts</h4>
            <div class="data-table" style="margin-bottom:20px;">
                <asp:GridView ID="gvBankAccounts" runat="server" AutoGenerateColumns="false"
                    CssClass="table table-striped" GridLines="None" EmptyDataText="No bank accounts yet."
                    OnRowCommand="gvBankAccounts_RowCommand">
                    <Columns>
                        <asp:BoundField DataField="AccountName" HeaderText="Account Name" />
                        <asp:BoundField DataField="AccountNumber" HeaderText="Account #" />
                        <asp:BoundField DataField="IFSCCode" HeaderText="IFSC" />
                        <asp:BoundField DataField="UPIID" HeaderText="UPI ID" />
                        <asp:BoundField DataField="BankName" HeaderText="Bank" />
                        <asp:BoundField DataField="PANNumber" HeaderText="PAN" />
                        <asp:TemplateField HeaderText="Default">
                            <ItemTemplate>
                                <span class='<%# Convert.ToBoolean(Eval("IsDefault")) ? "badge-status badge-sent" : "" %>'>
                                    <%# Convert.ToBoolean(Eval("IsDefault")) ? "✅ Default" : "" %>
                                </span>
                            </ItemTemplate>
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="Actions">
                            <ItemTemplate>
                                <asp:LinkButton ID="btnEditBank" runat="server" CommandName="EditBank" CommandArgument='<%# Eval("BankAccountID") %>' CssClass="btn-sm-action" CausesValidation="false">✏️ Edit</asp:LinkButton>
                                <asp:LinkButton ID="btnDeleteBank" runat="server" CommandName="DeleteBank" CommandArgument='<%# Eval("BankAccountID") %>' CssClass="btn-sm-action" ForeColor="Red" OnClientClick="return confirm('Delete this bank account?');" CausesValidation="false">🗑 Delete</asp:LinkButton>
                            </ItemTemplate>
                        </asp:TemplateField>
                    </Columns>
                </asp:GridView>
            </div>

            <div class="detail-form" style="background:#f8fafc;border:1.5px dashed #d1d5db;border-radius:12px;padding:20px;margin-top:8px;">
                <h5 style="font-size:14px;font-weight:600;margin-bottom:12px;">➕ Add/Edit Bank Account</h5>
                <asp:HiddenField ID="hfEditBankID" runat="server" />
                <div style="display:grid;grid-template-columns:1fr 1fr;gap:12px;">
                    <div>
                        <label>Account Name *</label>
                        <asp:TextBox ID="txtBankAccName" runat="server" placeholder="e.g. Smart Agriculture" />
                    </div>
                    <div>
                        <label>Account Number *</label>
                        <asp:TextBox ID="txtBankAccNumber" runat="server" placeholder="e.g. 1234567890" />
                    </div>
                    <div>
                        <label>IFSC Code</label>
                        <asp:TextBox ID="txtBankIFSC" runat="server" placeholder="e.g. SBIN0000123" />
                    </div>
                    <div>
                        <label>UPI ID</label>
                        <asp:TextBox ID="txtBankUPI" runat="server" placeholder="e.g. name@upi" />
                    </div>
                    <div>
                        <label>Bank Name</label>
                        <asp:TextBox ID="txtBankNameInput" runat="server" placeholder="e.g. State Bank of India" />
                    </div>
                    <div>
                        <label>PAN Number</label>
                        <asp:TextBox ID="txtBankPAN" runat="server" placeholder="e.g. ABCDE1234F" />
                    </div>
                    <div style="display:flex;align-items:flex-end;padding-bottom:4px;">
                        <asp:CheckBox ID="chkDefaultBank" runat="server" Text=" Set as Default" />
                    </div>
                </div>
                <asp:Button ID="btnSaveBankAccount" runat="server" Text="Save Bank Account" CssClass="btn-save" style="margin-top:12px;" OnClick="btnSaveBankAccount_Click" />
            </div>
        </div>
    </div>

    <%-- =============== ADD/EDIT EXPENSE MODAL =============== --%>
    <div class="modal-overlay" id="expenseModal">
        <div class="modal-box">
            <h3 id="expenseModalTitle">➕ Add Expense</h3>
            <asp:HiddenField ID="hfEditExpenseID" runat="server" />
            <label>Date *</label>
            <asp:TextBox ID="txtExpDate" runat="server" TextMode="Date" />
            <label>Category *</label>
            <asp:DropDownList ID="ddlExpCategory" runat="server">
                <asp:ListItem Text="Fuel" Value="Fuel" />
                <asp:ListItem Text="Seeds" Value="Seeds" />
                <asp:ListItem Text="Equipment" Value="Equipment" />
                <asp:ListItem Text="Labour" Value="Labour" />
                <asp:ListItem Text="Fertilizer" Value="Fertilizer" />
                <asp:ListItem Text="Transport" Value="Transport" />
                <asp:ListItem Text="Office" Value="Office" />
                <asp:ListItem Text="Other" Value="Other" />
            </asp:DropDownList>
            <label>Amount (₹) *</label>
            <asp:TextBox ID="txtExpAmount" runat="server" TextMode="Number" placeholder="0.00" />
            <label>Payment Method</label>
            <asp:DropDownList ID="ddlExpPayment" runat="server">
                <asp:ListItem Text="Cash" Value="Cash" />
                <asp:ListItem Text="UPI" Value="UPI" />
                <asp:ListItem Text="Bank Transfer" Value="Bank Transfer" />
                <asp:ListItem Text="Card" Value="Card" />
            </asp:DropDownList>
            <label>Description</label>
            <asp:TextBox ID="txtExpDesc" runat="server" TextMode="MultiLine" Rows="2" placeholder="Brief description" />
            <div class="modal-actions">
                <button type="button" class="btn-cancel" onclick="closeExpenseModal()">Cancel</button>
                <asp:Button ID="btnSaveExpense" runat="server" Text="Save Expense" CssClass="btn-save" OnClick="btnSaveExpense_Click" />
            </div>
        </div>
    </div>

    <%-- =============== ADD/EDIT NOTE MODAL =============== --%>
    <div class="modal-overlay" id="noteModal">
        <div class="modal-box">
            <h3 id="noteModalTitle">📝 Add Note</h3>
            <asp:HiddenField ID="hfEditNoteID" runat="server" />
            <label>Note *</label>
            <asp:TextBox ID="txtNoteText" runat="server" TextMode="MultiLine" Rows="4" placeholder="Write your note here..." />
            <div class="modal-actions">
                <button type="button" class="btn-cancel" onclick="closeNoteModal()">Cancel</button>
                <asp:Button ID="btnSaveNote" runat="server" Text="Save Note" CssClass="btn-save" OnClick="btnSaveNote_Click" />
            </div>
        </div>
    </div>

    <%-- =============== ADD/EDIT CUSTOMER MODAL =============== --%>
    <div class="modal-overlay" id="customerModal">
        <div class="modal-box">
            <h3 id="customerModalTitle">👥 Add Customer</h3>
            <asp:HiddenField ID="hfEditCustomerID" runat="server" />
            <label>Customer Name *</label>
            <asp:TextBox ID="txtCustName" runat="server" placeholder="Customer / Business name" />
            <label>Email</label>
            <asp:TextBox ID="txtCustEmail" runat="server" TextMode="Email" placeholder="customer@example.com" />
            <label>Phone</label>
            <asp:TextBox ID="txtCustPhone" runat="server" placeholder="Phone number" />
            <label>Address</label>
            <asp:TextBox ID="txtCustAddress" runat="server" TextMode="MultiLine" Rows="2" placeholder="Full address" />
            <label>GSTIN</label>
            <asp:TextBox ID="txtCustGSTIN" runat="server" placeholder="e.g. 22AAAAA0000A1Z5" />
            <div class="modal-actions">
                <button type="button" class="btn-cancel" onclick="closeCustomerModal()">Cancel</button>
                <asp:Button ID="btnSaveCustomer" runat="server" Text="Save Customer" CssClass="btn-save" OnClick="btnSaveCustomer_Click" />
            </div>
        </div>
    </div>

</form>
<script>
    // Fix create invoice link
    document.getElementById('lnkCreateInvoice').href = 'CreateInvoice.aspx?CompanyID=' + document.getElementById('<%= hfCompanyID.ClientID %>').value;

    // Tabs
    function switchTab(name) {
        document.querySelectorAll('.tab-panel').forEach(p => p.classList.remove('active'));
        document.querySelectorAll('.tab-btn').forEach(b => b.classList.remove('active'));
        document.getElementById('tab-' + name).classList.add('active');
        event.target.classList.add('active');
        document.getElementById('<%= hfActiveTab.ClientID %>').value = name;
    }

    // Restore active tab on postback
    (function() {
        var active = document.getElementById('<%= hfActiveTab.ClientID %>').value || 'invoices';
        document.querySelectorAll('.tab-panel').forEach(p => p.classList.remove('active'));
        document.querySelectorAll('.tab-btn').forEach(b => b.classList.remove('active'));
        document.getElementById('tab-' + active).classList.add('active');
        var btns = document.querySelectorAll('.tab-btn');
        var map = {'invoices':0,'customers':1,'expenses':2,'notes':3,'details':4};
        if (btns[map[active]]) btns[map[active]].classList.add('active');
    })();

    function openCustomerModal() { document.getElementById('customerModal').classList.add('active'); }
    function closeCustomerModal() { document.getElementById('customerModal').classList.remove('active'); }
    function openExpenseModal() { document.getElementById('expenseModal').classList.add('active'); }
    function closeExpenseModal() { document.getElementById('expenseModal').classList.remove('active'); }
    function openNoteModal() { document.getElementById('noteModal').classList.add('active'); }
    function closeNoteModal() { document.getElementById('noteModal').classList.remove('active'); }
    document.getElementById('customerModal').addEventListener('click', function(e) { if (e.target === this) closeCustomerModal(); });
    document.getElementById('expenseModal').addEventListener('click', function(e) { if (e.target === this) closeExpenseModal(); });
    document.getElementById('noteModal').addEventListener('click', function(e) { if (e.target === this) closeNoteModal(); });
</script>
</body>
</html>
