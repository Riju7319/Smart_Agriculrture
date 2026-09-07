<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="PublicInvoice.aspx.cs"
    Inherits="Smart_Agriculrture.Companies.PublicInvoice" %>

    <!DOCTYPE html>
    <html xmlns="http://www.w3.org/1999/xhtml">

    <head runat="server">
        <title>Invoice — Smart Agriculture</title>
        <meta name="viewport" content="width=device-width, initial-scale=1" />
        <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700;800&display=swap"
            rel="stylesheet" />
        <style>
            * {
                box-sizing: border-box;
                margin: 0;
                padding: 0;
            }

            body {
                font-family: 'Inter', sans-serif;
                background: linear-gradient(135deg, #f0f2f5 0%, #e2e8f0 100%);
                min-height: 100vh;
                padding: 40px 20px;
            }

            .inv-container {
                max-width: 820px;
                margin: 0 auto;
            }

            /* Status Bar */
            .status-banner {
                border-radius: 16px 16px 0 0;
                padding: 20px 32px;
                display: flex;
                justify-content: space-between;
                align-items: center;
                flex-wrap: wrap;
                gap: 12px;
            }

            .status-banner.paid {
                background: linear-gradient(135deg, #059669, #047857);
            }

            .status-banner.pending {
                background: linear-gradient(135deg, #d97706, #b45309);
            }

            .status-banner.overdue {
                background: linear-gradient(135deg, #dc2626, #b91c1c);
            }

            .status-banner.partiallypaid {
                background: linear-gradient(135deg, #2563eb, #1d4ed8);
            }

            .status-banner h2 {
                color: #fff;
                font-size: 18px;
                font-weight: 700;
                margin: 0;
            }

            .status-banner .total-amount {
                color: #fff;
                font-size: 28px;
                font-weight: 800;
            }

            /* Invoice Paper */
            .invoice-paper {
                background: #fff;
                border-radius: 0 0 16px 16px;
                padding: 40px;
                box-shadow: 0 8px 32px rgba(0, 0, 0, 0.08);
            }

            .inv-header {
                display: flex;
                justify-content: space-between;
                align-items: flex-start;
                margin-bottom: 28px;
                flex-wrap: wrap;
                gap: 16px;
            }

            .inv-brand h2 {
                font-size: 22px;
                font-weight: 800;
                color: #0f172a;
                margin-bottom: 4px;
            }

            .inv-brand p {
                font-size: 13px;
                color: #6b7280;
                line-height: 1.7;
            }

            .inv-title-block {
                text-align: right;
            }

            .inv-title-block h1 {
                font-size: 32px;
                font-weight: 800;
                color: #2563eb;
                letter-spacing: 2px;
                margin-bottom: 4px;
            }

            .inv-badge {
                display: inline-block;
                padding: 5px 14px;
                border-radius: 20px;
                font-size: 11px;
                font-weight: 700;
                text-transform: uppercase;
                letter-spacing: 0.5px;
            }

            .badge-paid {
                background: #ecfdf5;
                color: #059669;
            }

            .badge-pending {
                background: #fffbeb;
                color: #d97706;
            }

            .badge-overdue {
                background: #fef2f2;
                color: #dc2626;
            }

            .badge-partiallypaid {
                background: #eff6ff;
                color: #2563eb;
            }

            .billing-row {
                display: grid;
                grid-template-columns: 1fr 1fr;
                gap: 20px;
                margin-bottom: 28px;
            }

            .billing-card {
                background: #f8fafc;
                border: 1px solid #e5e7eb;
                border-radius: 10px;
                padding: 16px;
            }

            .billing-card h5 {
                font-size: 11px;
                font-weight: 700;
                text-transform: uppercase;
                letter-spacing: 0.5px;
                color: #9ca3af;
                margin-bottom: 8px;
            }

            .billing-card p {
                font-size: 13px;
                color: #374151;
                line-height: 1.7;
                margin: 0;
            }

            /* Items Table */
            .inv-table {
                width: 100%;
                border-collapse: collapse;
                margin-bottom: 20px;
            }

            .inv-table th {
                background: linear-gradient(135deg, #0f172a, #1e293b);
                color: #fff;
                padding: 12px 14px;
                font-size: 11px;
                text-transform: uppercase;
                letter-spacing: 0.5px;
                font-weight: 600;
                text-align: left;
            }

            .inv-table th:first-child {
                border-radius: 8px 0 0 0;
            }

            .inv-table th:last-child {
                border-radius: 0 8px 0 0;
                text-align: right;
            }

            .inv-table td {
                padding: 12px 14px;
                font-size: 13px;
                color: #374151;
                border-bottom: 1px solid #f1f5f9;
            }

            .inv-table td:last-child {
                text-align: right;
                font-weight: 600;
            }

            .inv-table tr:hover {
                background: #f8fafc;
            }

            /* Totals */
            .inv-totals {
                display: flex;
                justify-content: flex-end;
                margin-bottom: 28px;
            }

            .inv-totals table {
                width: 320px;
            }

            .inv-totals td {
                padding: 8px 14px;
                font-size: 14px;
            }

            .t-label {
                text-align: right;
                color: #6b7280;
                font-weight: 500;
            }

            .t-value {
                text-align: right;
                font-weight: 600;
                color: #1e293b;
            }

            .t-grand td {
                font-size: 20px;
                font-weight: 800;
                color: #2563eb;
                border-top: 2px solid #e5e7eb;
                padding-top: 12px;
            }

            /* Bank Details */
            .bank-section {
                background: linear-gradient(135deg, #f0fdf4, #ecfdf5);
                border: 1.5px solid #a7f3d0;
                border-radius: 12px;
                padding: 20px;
                margin-top: 20px;
            }

            .bank-section h5 {
                font-size: 13px;
                font-weight: 700;
                color: #059669;
                margin-bottom: 10px;
                text-transform: uppercase;
                letter-spacing: 0.5px;
            }

            .bank-section p {
                font-size: 13px;
                color: #374151;
                margin: 4px 0;
            }

            /* Footer */
            .inv-footer {
                text-align: center;
                margin-top: 32px;
                padding-top: 20px;
                border-top: 1px solid #e5e7eb;
                color: #9ca3af;
                font-size: 12px;
            }

            /* Due date warning */
            .due-warning {
                background: #fef3c7;
                border: 1px solid #fbbf24;
                border-radius: 8px;
                padding: 12px 16px;
                text-align: center;
                font-size: 13px;
                font-weight: 600;
                color: #92400e;
                margin-bottom: 20px;
            }

            .error-box {
                max-width: 500px;
                margin: 80px auto;
                text-align: center;
                background: #fff;
                border-radius: 16px;
                padding: 48px;
                box-shadow: 0 8px 32px rgba(0, 0, 0, 0.08);
            }

            .error-box h2 {
                color: #dc2626;
                font-size: 48px;
                margin-bottom: 12px;
            }

            .error-box p {
                color: #6b7280;
                font-size: 15px;
            }

            @media print {
                body {
                    background: #fff;
                    padding: 0;
                }

                .status-banner {
                    display: none;
                }

                .invoice-paper {
                    box-shadow: none;
                    border-radius: 0;
                    padding: 20px;
                }

                .btn-print-page {
                    display: none !important;
                }
            }

            .btn-print-page {
                display: block;
                max-width: 820px;
                margin: 20px auto 0;
                text-align: center;
            }

            .btn-print-page button {
                background: linear-gradient(135deg, #0f172a, #1e293b);
                color: #fff;
                border: none;
                border-radius: 10px;
                padding: 12px 28px;
                font-size: 14px;
                font-weight: 600;
                cursor: pointer;
                font-family: 'Inter', sans-serif;
                transition: all 0.2s;
            }

            .btn-print-page button:hover {
                transform: translateY(-1px);
                box-shadow: 0 4px 14px rgba(0, 0, 0, 0.15);
            }

            @media (max-width: 600px) {
                .billing-row {
                    grid-template-columns: 1fr;
                }

                .inv-header {
                    flex-direction: column;
                    text-align: left;
                }

                .inv-title-block {
                    text-align: left;
                }
            }
        </style>
    </head>

    <body>
        <form id="form1" runat="server">

            <asp:Panel ID="pnlError" runat="server" Visible="false">
                <div class="error-box">
                    <h2>🔒</h2>
                    <p>This invoice could not be found or the link has expired.</p>
                </div>
            </asp:Panel>

            <asp:Panel ID="pnlInvoice" runat="server" Visible="false">
                <div class="inv-container">
                    <!-- Status Banner -->
                    <div class="status-banner" id="statusBanner" runat="server">
                        <h2>Invoice #
                            <asp:Label ID="lblInvoiceNumberTop" runat="server" />
                        </h2>
                        <div class="total-amount">₹
                            <asp:Label ID="lblTotalTop" runat="server" />
                        </div>
                    </div>

                    <div class="invoice-paper">
                        <!-- Header -->
                        <div class="inv-header">
                            <div class="inv-brand">
                                <h2>
                                    <asp:Label ID="lblCompanyName" runat="server" />
                                </h2>
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
                                <asp:Label ID="lblStatusBadge" runat="server" />
                            </div>
                        </div>

                        <!-- Due Date Warning -->
                        <asp:Panel ID="pnlDueWarning" runat="server" Visible="false">
                            <div class="due-warning">
                                ⚠️ Payment is due by
                                <asp:Label ID="lblDueDateWarning" runat="server" />
                            </div>
                        </asp:Panel>

                        <!-- Billing Row -->
                        <div class="billing-row">
                            <div class="billing-card">
                                <h5>Billed To</h5>
                                <p>
                                    <asp:Label ID="lblBilledTo" runat="server" />
                                </p>
                            </div>
                            <div class="billing-card">
                                <h5>Invoice Details</h5>
                                <p><strong>Invoice #:</strong>
                                    <asp:Label ID="lblInvoiceNumber" runat="server" />
                                </p>
                                <p><strong>Date:</strong>
                                    <asp:Label ID="lblInvoiceDate" runat="server" />
                                </p>
                                <p><strong>Due Date:</strong>
                                    <asp:Label ID="lblDueDate" runat="server" />
                                </p>
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
                                    <td>
                                        <%# Container.ItemIndex + 1 %>
                                    </td>
                                    <td>
                                        <strong>
                                            <%# Eval("ItemName") %>
                                        </strong>
                                        <%# !string.IsNullOrEmpty(Eval("ItemDescription")?.ToString())
                                            ? "<br/><span style='color:#6b7280;font-size:12px;'>" +
                                            Eval("ItemDescription") + "</span>" : "" %>
                                    </td>
                                    <td>
                                        <%# Eval("Quantity") %>
                                    </td>
                                    <td>₹<%# string.Format("{0:N2}", Eval("UnitPrice")) %>
                                    </td>
                                    <td>₹<%# string.Format("{0:N2}", Eval("TotalPrice")) %>
                                    </td>
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
                                    <td class="t-value">₹
                                        <asp:Label ID="lblSubtotal" runat="server" />
                                    </td>
                                </tr>
                                <tr>
                                    <td class="t-label">CGST (
                                        <asp:Label ID="lblCGSTPct" runat="server" />%):
                                    </td>
                                    <td class="t-value">₹
                                        <asp:Label ID="lblCGST" runat="server" />
                                    </td>
                                </tr>
                                <tr>
                                    <td class="t-label">SGST (
                                        <asp:Label ID="lblSGSTPct" runat="server" />%):
                                    </td>
                                    <td class="t-value">₹
                                        <asp:Label ID="lblSGST" runat="server" />
                                    </td>
                                </tr>
                                <tr class="t-grand">
                                    <td class="t-label">Grand Total:</td>
                                    <td class="t-value">₹
                                        <asp:Label ID="lblGrandTotal" runat="server" />
                                    </td>
                                </tr>
                            </table>
                        </div>

                        <!-- Bank Details -->
                        <asp:Panel ID="pnlBankDetails" runat="server" Visible="false">
                            <div class="bank-section">
                                <h5>🏦 Bank Details for Payment</h5>
                                <p><strong>Account Name:</strong>
                                    <asp:Label ID="lblBankName" runat="server" />
                                </p>
                                <p><strong>Account #:</strong>
                                    <asp:Label ID="lblBankAccNum" runat="server" />
                                </p>
                                <p><strong>IFSC:</strong>
                                    <asp:Label ID="lblBankIFSC" runat="server" />
                                </p>
                                <p><strong>UPI ID:</strong>
                                    <asp:Label ID="lblBankUPI" runat="server" />
                                </p>
                                <asp:PlaceHolder ID="phBankPAN" runat="server">
                                    <p><strong>PAN:</strong>
                                        <asp:Label ID="lblBankPAN" runat="server" />
                                    </p>
                                </asp:PlaceHolder>
                            </div>
                        </asp:Panel>

                        <!-- Footer -->
                        <div class="inv-footer">
                            <p>Thank you for your business! </p>
                            <p style="margin-top:4px;">Generated by <asp:Label ID="lblFooterCompanyName" runat="server" /></p>
                        </div>
                    </div>
                </div>

                <div class="btn-print-page">
                    <button type="button" onclick="window.print()">🖨️ Print This Invoice</button>
                </div>
            </asp:Panel>

        </form>
    </body>

    </html>