<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="InvoiceView.aspx.cs" Inherits="Smart_Agriculrture.Companies.InvoiceView" %>

<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>Invoice View — Smart Agriculture</title>
    <meta name="viewport" content="width=device-width, initial-scale=1" />
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700&display=swap" rel="stylesheet" />
    <style>
        * { box-sizing: border-box; margin: 0; padding: 0; }
        body { font-family: 'Inter', sans-serif; background: #f0f2f5; }

        /* ===== Action Bar ===== */
        .action-bar {
            background: linear-gradient(135deg, #0f172a 0%, #1e293b 100%);
            padding: 16px 32px; display: flex; justify-content: space-between; align-items: center;
            flex-wrap: wrap; gap: 12px;
        }
        .action-left { display: flex; gap: 10px; align-items: center; flex-wrap: wrap; }
        .action-right { display: flex; gap: 10px; flex-wrap: wrap; }

        .btn-act {
            padding: 9px 16px; border-radius: 8px; font-size: 13px; font-weight: 600;
            cursor: pointer; border: none; font-family: 'Inter', sans-serif; transition: all 0.2s;
            text-decoration: none; display: inline-flex; align-items: center; gap: 5px;
        }
        .btn-back { background: rgba(255,255,255,0.1); color: #cbd5e1; border: 1px solid rgba(255,255,255,0.15); }
        .btn-back:hover { background: rgba(255,255,255,0.2); color: #fff; }
        .btn-print { background: linear-gradient(135deg, #7c3aed, #6d28d9); color: #fff; }
        .btn-print:hover { box-shadow: 0 4px 14px rgba(124,58,237,0.4); }
        .btn-email { background: linear-gradient(135deg, #2563eb, #1d4ed8); color: #fff; }
        .btn-email:hover { box-shadow: 0 4px 14px rgba(37,99,235,0.4); }
        .btn-status-update { background: linear-gradient(135deg, #d97706, #b45309); color: #fff; }

        select.status-select {
            padding: 9px 12px; border-radius: 8px; font-size: 13px; font-family: 'Inter', sans-serif;
            border: 1px solid rgba(255,255,255,0.2); background: rgba(255,255,255,0.1); color: #fff;
            outline: none; cursor: pointer;
        }
        select.status-select option { color: #1a1a2e; background: #fff; }

        .alert-msg { padding: 10px 16px; border-radius: 8px; font-size: 13px; font-weight: 600; margin: 12px 32px; text-align: center; }
        .alert-success { background: #ecfdf5; color: #059669; border: 1px solid #a7f3d0; }
        .alert-error { background: #fef2f2; color: #dc2626; border: 1px solid #fecaca; }

        /* ===== Invoice Canvas ===== */
        .invoice-wrapper {
            max-width: 800px; margin: 24px auto; padding: 0 20px;
        }
        .invoice-paper {
            background: #fff; border: 1px solid #e5e7eb; border-radius: 4px;
            padding: 48px; box-shadow: 0 4px 20px rgba(0,0,0,0.08);
        }

        /* Brand header */
        .inv-header { display: flex; justify-content: space-between; align-items: flex-start; margin-bottom: 32px; padding-bottom: 20px; border-bottom: 2px solid #e5e7eb; }
        .inv-brand h2 { font-size: 22px; font-weight: 700; color: #0f172a; margin: 0; }
        .inv-brand p { font-size: 12px; color: #6b7280; margin-top: 4px; line-height: 1.6; }
        .inv-title-block { text-align: right; }
        .inv-title-block h1 { font-size: 28px; font-weight: 800; color: #2563eb; letter-spacing: 2px; margin: 0; }
        .inv-status-badge {
            display: inline-block; padding: 4px 14px; border-radius: 20px; font-size: 12px;
            font-weight: 700; margin-top: 6px;
        }
        .status-paid { background: #ecfdf5; color: #059669; }
        .status-pending { background: #fffbeb; color: #d97706; }
        .status-overdue { background: #fef2f2; color: #dc2626; }
        .status-partiallypaid { background: #eff6ff; color: #2563eb; }

        /* Billing cards */
        .billing-row { display: flex; gap: 20px; margin-bottom: 28px; }
        .billing-card { flex: 1; background: #f8fafc; border: 1px solid #f1f5f9; border-radius: 10px; padding: 16px; }
        .billing-card h5 { font-size: 10px; font-weight: 700; text-transform: uppercase; letter-spacing: 1px; color: #9ca3af; margin-bottom: 8px; }
        .billing-card p { font-size: 13px; color: #374151; margin: 2px 0; line-height: 1.5; }
        .billing-card strong { color: #1a1a2e; }

        /* Line items table */
        .inv-table { width: 100%; border-collapse: collapse; margin-bottom: 24px; }
        .inv-table th {
            background: #0f172a; color: #fff; font-size: 11px; font-weight: 600;
            text-transform: uppercase; letter-spacing: 0.5px; padding: 12px 14px; text-align: left;
        }
        .inv-table th:last-child, .inv-table td:last-child { text-align: right; }
        .inv-table td { padding: 12px 14px; font-size: 13px; color: #374151; border-bottom: 1px solid #f1f5f9; }
        .inv-table tbody tr:nth-child(even) td { background: #fafbfc; }

        /* Totals */
        .inv-totals { display: flex; justify-content: flex-end; }
        .inv-totals table { width: 280px; }
        .inv-totals td { padding: 6px 14px; font-size: 14px; }
        .inv-totals .t-label { text-align: right; color: #6b7280; }
        .inv-totals .t-value { text-align: right; font-weight: 600; color: #1a1a2e; }
        .inv-totals .t-grand td { font-size: 18px; font-weight: 700; color: #2563eb; border-top: 2px solid #e5e7eb; padding-top: 10px; }

        /* Bank details */
        .bank-section { margin-top: 32px; padding-top: 20px; border-top: 1px dashed #d1d5db; }
        .bank-section h5 { font-size: 11px; font-weight: 700; text-transform: uppercase; letter-spacing: 1px; color: #9ca3af; margin-bottom: 8px; }
        .bank-section p { font-size: 12px; color: #6b7280; margin: 2px 0; }

        /* Print styles */
        @media print {
            .action-bar, .alert-msg { display: none !important; }
            body { background: #fff; }
            .invoice-wrapper { margin: 0; padding: 0; max-width: 100%; }
            .invoice-paper { border: none; box-shadow: none; padding: 20px; }
        }
    </style>
</head>
<body>
<form id="form1" runat="server">
    <asp:HiddenField ID="hfInvoiceID" runat="server" />
    <asp:HiddenField ID="hfCompanyID" runat="server" />

    <!-- Action Bar -->
    <div class="action-bar">
        <div class="action-left">
            <a id="lnkBack" runat="server" class="btn-act btn-back">← Back</a>
            <asp:DropDownList ID="ddlStatusUpdate" runat="server" CssClass="status-select">
                <asp:ListItem Text="Pending" Value="Pending" />
                <asp:ListItem Text="Paid" Value="Paid" />
                <asp:ListItem Text="Partially Paid" Value="Partially Paid" />
                <asp:ListItem Text="Overdue" Value="Overdue" />
            </asp:DropDownList>
            <asp:Button ID="btnUpdateStatus" runat="server" Text="Update Status" CssClass="btn-act btn-status-update" OnClick="btnUpdateStatus_Click" CausesValidation="false" />
        </div>
        <div class="action-right">
            <button type="button" class="btn-act btn-print" onclick="copyInvoiceLink()">🔗 Copy Link</button>
            <button type="button" class="btn-act btn-print" onclick="window.print()">🖨️ Print / PDF</button>
            <asp:Button ID="btnSendEmail" runat="server" Text="✉️ Send Email" CssClass="btn-act btn-email" OnClick="btnSendEmail_Click" CausesValidation="false" />
        </div>
    </div>

    <script>
        function copyInvoiceLink() {
            var invoiceId = document.getElementById('<%= hfInvoiceID.ClientID %>').value;
            var url = window.location.origin + window.location.pathname.replace('InvoiceView.aspx', 'PublicInvoice.aspx?id=' + invoiceId);
            navigator.clipboard.writeText(url).then(function() {
                alert('Public invoice link copied to clipboard:\n' + url);
            }, function(err) {
                alert('Failed to copy link: ' + err);
            });
        }
    </script>

    <asp:Label ID="lblMessage" runat="server" Visible="false" />

    <!-- Invoice Paper -->
    <div class="invoice-wrapper">
        <div class="invoice-paper">

            <!-- Header -->
            <div class="inv-header">
                <div class="inv-brand">
                    <h2><asp:Label ID="lblCompanyName" runat="server" /></h2>
                    <p>
                        <asp:Label ID="lblCompanyAddress" runat="server" /><br />
                        <asp:Label ID="lblCompanyContact" runat="server" /><br />
                        <asp:PlaceHolder ID="phGST" runat="server">
                            GSTIN: <asp:Label ID="lblCompanyGST" runat="server" /><br />
                        </asp:PlaceHolder>
                        <asp:PlaceHolder ID="phPAN" runat="server">
                            PAN: <asp:Label ID="lblCompanyPAN" runat="server" />
                        </asp:PlaceHolder>
                    </p>
                </div>
                <div class="inv-title-block">
                    <h1>INVOICE</h1>
                    <asp:Label ID="lblStatusBadge" runat="server" CssClass="inv-status-badge" />
                </div>
            </div>

            <!-- Billing Row -->
            <div class="billing-row">
                <div class="billing-card">
                    <h5>Billed To</h5>
                    <p><strong><asp:Label ID="lblBilledTo" runat="server" /></strong></p>
                </div>
                <div class="billing-card">
                    <h5>Invoice Details</h5>
                    <p><strong>Invoice #:</strong> <asp:Label ID="lblInvoiceNumber" runat="server" /></p>
                    <p><strong>Date:</strong> <asp:Label ID="lblInvoiceDate" runat="server" /></p>
                    <p><strong>Due Date:</strong> <asp:Label ID="lblDueDate" runat="server" /></p>
                    <p><strong>Delivery:</strong> <asp:Label ID="lblSentStatus" runat="server" /></p>
                </div>
            </div>

            <!-- Line Items -->
            <asp:Repeater ID="rptItems" runat="server">
                <HeaderTemplate>
                    <table class="inv-table">
                        <thead>
                            <tr>
                                <th>#</th>
                                <th>Item & Description</th>
                                <th>Qty</th>
                                <th>Unit Price (₹)</th>
                                <th>Total (₹)</th>
                            </tr>
                        </thead>
                        <tbody>
                </HeaderTemplate>
                <ItemTemplate>
                    <tr>
                        <td><%# Container.ItemIndex + 1 %></td>
                        <td>
                            <strong><%# Eval("ItemName") %></strong>
                            <%# !string.IsNullOrEmpty(Eval("ItemDescription")?.ToString()) ? "<br/><span style='color:#6b7280;font-size:12px;'>" + Eval("ItemDescription") + "</span>" : "" %>
                        </td>
                        <td><%# Eval("Quantity") %></td>
                        <td>₹<%# string.Format("{0:N2}", Eval("UnitPrice")) %></td>
                        <td>₹<%# string.Format("{0:N2}", Eval("TotalPrice")) %></td>
                    </tr>
                </ItemTemplate>
                <FooterTemplate>
                        </tbody>
                    </table>
                </FooterTemplate>
            </asp:Repeater>

            <!-- Totals -->
            <div class="inv-totals">
                <table>
                    <tr>
                        <td class="t-label">Subtotal:</td>
                        <td class="t-value">₹<asp:Label ID="lblSubtotal" runat="server" /></td>
                    </tr>
                    <tr>
                        <td class="t-label">CGST (<asp:Label ID="lblCGSTPct" runat="server" Text="0" />%):</td>
                        <td class="t-value">₹<asp:Label ID="lblCGST" runat="server" /></td>
                    </tr>
                    <tr>
                        <td class="t-label">SGST (<asp:Label ID="lblSGSTPct" runat="server" Text="0" />%):</td>
                        <td class="t-value">₹<asp:Label ID="lblSGST" runat="server" /></td>
                    </tr>
                    <tr class="t-grand">
                        <td class="t-label">Grand Total:</td>
                        <td class="t-value">₹<asp:Label ID="lblGrandTotal" runat="server" /></td>
                    </tr>
                </table>
            </div>

            <!-- Bank Details -->
            <asp:Panel ID="pnlBankDetails" runat="server" Visible="false">
                <div class="bank-section">
                    <h5>Bank Details</h5>
                    <p><strong>Account Name:</strong> <asp:Label ID="lblBankName" runat="server" /></p>
                    <p><strong>Account #:</strong> <asp:Label ID="lblBankAccount" runat="server" /></p>
                    <p><strong>IFSC:</strong> <asp:Label ID="lblBankIFSC" runat="server" /></p>
                    <p><strong>UPI ID:</strong> <asp:Label ID="lblBankUPI" runat="server" /></p>
                    <asp:PlaceHolder ID="phBankPAN" runat="server">
                        <p><strong>PAN:</strong> <asp:Label ID="lblBankPAN" runat="server" /></p>
                    </asp:PlaceHolder>
                </div>
            </asp:Panel>

        </div>
    </div>

</form>
</body>
</html>
