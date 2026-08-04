<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="CreateInvoice.aspx.cs" Inherits="Smart_Agriculrture.Companies.CreateInvoice" %>

<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>Create Invoice — Smart Agriculture</title>
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
        .btn-back { background: rgba(255,255,255,0.1); color: #cbd5e1; border: 1px solid rgba(255,255,255,0.15); border-radius: 8px; padding: 9px 18px; font-size: 13px; font-weight: 500; cursor: pointer; text-decoration: none; font-family: 'Inter', sans-serif; }
        .btn-back:hover { background: rgba(255,255,255,0.2); color: #fff; }

        .content-area { padding: 28px 32px; max-width: 950px; margin: 0 auto; }

        .form-card {
            background: #fff; border: 1.5px solid #e5e7eb; border-radius: 14px; padding: 28px;
            margin-bottom: 20px;
        }
        .form-card h3 { font-size: 16px; font-weight: 700; color: #1a1a2e; margin-bottom: 16px; padding-bottom: 10px; border-bottom: 1px solid #f1f5f9; }

        .form-grid { display: grid; grid-template-columns: 1fr 1fr; gap: 14px; }
        label { display: block; font-size: 13px; font-weight: 500; color: #374151; margin-bottom: 4px; }
        input, textarea, select {
            width: 100%; padding: 10px 13px; border: 1.5px solid #d1d5db; border-radius: 8px;
            font-size: 14px; font-family: 'Inter', sans-serif; outline: none; background: #f9fafb;
            transition: border-color 0.2s;
        }
        input:focus, textarea:focus, select:focus { border-color: #2563eb; background: #fff; }

        /* Line Items Table */
        .items-table { width: 100%; border-collapse: collapse; margin-top: 12px; }
        .items-table th {
            background: #f8fafc; font-size: 11px; font-weight: 600; text-transform: uppercase;
            letter-spacing: 0.5px; color: #64748b; padding: 10px 12px; text-align: left;
            border-bottom: 2px solid #e2e8f0;
        }
        .items-table td { padding: 6px 4px; vertical-align: top; }
        .items-table input, .items-table textarea { font-size: 13px; padding: 8px 10px; }
        .items-table textarea { resize: vertical; min-height: 36px; }
        .items-table .col-item { width: 35%; }
        .items-table .col-qty { width: 10%; }
        .items-table .col-price { width: 18%; }
        .items-table .col-total { width: 18%; }
        .items-table .col-action { width: 5%; text-align: center; }
        .item-cell { display: flex; flex-direction: column; gap: 4px; }
        .item-name-input { font-weight: 600; }

        .btn-remove {
            background: #fef2f2; color: #dc2626; border: 1px solid #fecaca; border-radius: 6px;
            width: 32px; height: 32px; cursor: pointer; font-size: 16px; transition: all 0.15s;
        }
        .btn-remove:hover { background: #dc2626; color: #fff; }

        .btn-add-row {
            background: #f0fdf4; color: #059669; border: 1.5px dashed #a7f3d0; border-radius: 8px;
            padding: 10px; width: 100%; font-size: 13px; font-weight: 600; cursor: pointer;
            margin-top: 8px; font-family: 'Inter', sans-serif; transition: all 0.2s;
        }
        .btn-add-row:hover { background: #dcfce7; border-color: #059669; }

        /* Tax inputs */
        .tax-row { display: flex; gap: 16px; margin-top: 16px; flex-wrap: wrap; align-items: flex-end; }
        .tax-field { flex: 1; min-width: 150px; }
        .tax-field input { max-width: 120px; }

        /* Totals */
        .totals-box { display: flex; justify-content: flex-end; margin-top: 16px; }
        .totals-table { width: 320px; }
        .totals-table td { padding: 6px 12px; font-size: 14px; }
        .totals-table .total-label { text-align: right; color: #6b7280; font-weight: 500; }
        .totals-table .total-value { text-align: right; font-weight: 600; color: #1a1a2e; }
        .totals-table .grand-total td { font-size: 18px; font-weight: 700; color: #2563eb; border-top: 2px solid #e5e7eb; padding-top: 10px; }

        .btn-save-invoice {
            background: linear-gradient(135deg, #2563eb, #1d4ed8); color: #fff; border: none;
            border-radius: 10px; padding: 14px 32px; font-size: 15px; font-weight: 700;
            cursor: pointer; font-family: 'Inter', sans-serif; transition: all 0.2s; width: 100%;
            margin-top: 8px;
        }
        .btn-save-invoice:hover { transform: translateY(-1px); box-shadow: 0 6px 20px rgba(37,99,235,0.4); }

        .alert-msg { padding: 10px 16px; border-radius: 8px; font-size: 13px; font-weight: 600; margin-bottom: 16px; text-align: center; }
        .alert-success { background: #ecfdf5; color: #059669; border: 1px solid #a7f3d0; }
        .alert-error { background: #fef2f2; color: #dc2626; border: 1px solid #fecaca; }

        @media (max-width: 768px) {
            .form-grid { grid-template-columns: 1fr; }
            .content-area { padding: 16px; }
        }
    </style>
</head>
<body>
<form id="form1" runat="server">
    <asp:HiddenField ID="hfCompanyID" runat="server" />
    <asp:HiddenField ID="hfItemsJSON" runat="server" Value="[]" />

    <div class="page-header">
        <h1>📄 Create Invoice</h1>
        <a id="lnkBack" runat="server" class="btn-back">← Back to Company</a>
    </div>

    <div class="content-area">
        <asp:Label ID="lblMessage" runat="server" Visible="false" />

        <!-- Invoice Info -->
        <div class="form-card">
            <h3>📋 Invoice Details</h3>
            <div class="form-grid">
                <div style="grid-column: 1 / -1;">
                    <label>Customer *</label>
                    <asp:DropDownList ID="ddlCustomer" runat="server" />
                </div>
                <div>
                    <label>Invoice Number *</label>
                    <asp:TextBox ID="txtInvoiceNumber" runat="server" placeholder="e.g. INV-0001" />
                </div>
                <div>
                    <label>Invoice Date *</label>
                    <asp:TextBox ID="txtInvoiceDate" runat="server" TextMode="Date" />
                </div>
                <div>
                    <label>Due Date *</label>
                    <asp:TextBox ID="txtDueDate" runat="server" TextMode="Date" />
                </div>
                <div>
                    <label>Payment Status</label>
                    <asp:DropDownList ID="ddlStatus" runat="server">
                        <asp:ListItem Text="Pending" Value="Pending" />
                        <asp:ListItem Text="Paid" Value="Paid" />
                        <asp:ListItem Text="Partially Paid" Value="Partially Paid" />
                        <asp:ListItem Text="Overdue" Value="Overdue" />
                    </asp:DropDownList>
                </div>
            </div>
        </div>

        <!-- Line Items -->
        <div class="form-card">
            <h3>📦 Line Items</h3>
            <table class="items-table" id="itemsTable">
                <thead>
                    <tr>
                        <th class="col-item">Item</th>
                        <th class="col-qty">Qty</th>
                        <th class="col-price">Unit Price (₹)</th>
                        <th class="col-total">Total (₹)</th>
                        <th class="col-action"></th>
                    </tr>
                </thead>
                <tbody id="itemsBody">
                    <tr>
                        <td class="item-cell">
                            <input type="text" class="item-name item-name-input" placeholder="Item name" />
                            <textarea class="item-desc" placeholder="Description (optional)" rows="1"></textarea>
                        </td>
                        <td><input type="number" class="item-qty" value="1" min="1" onchange="calcRow(this)" /></td>
                        <td><input type="number" class="item-price" value="0" step="0.01" onchange="calcRow(this)" /></td>
                        <td><input type="text" class="item-total" value="0.00" readonly style="background:#f1f5f9;font-weight:600;" /></td>
                        <td><button type="button" class="btn-remove" onclick="removeRow(this)">✕</button></td>
                    </tr>
                </tbody>
            </table>
            <button type="button" class="btn-add-row" onclick="addRow()">＋ Add Line Item</button>

            <!-- Tax + Totals -->
            <div class="tax-row">
                <div class="tax-field">
                    <label>CGST %</label>
                    <input type="number" id="inputCGST" value="9" step="0.5" min="0" max="50" onchange="calcTotals()" />
                </div>
                <div class="tax-field">
                    <label>SGST %</label>
                    <input type="number" id="inputSGST" value="9" step="0.5" min="0" max="50" onchange="calcTotals()" />
                </div>
            </div>

            <div class="totals-box">
                <table class="totals-table">
                    <tr>
                        <td class="total-label">Subtotal:</td>
                        <td class="total-value" id="subtotal">₹0.00</td>
                    </tr>
                    <tr>
                        <td class="total-label" id="cgstLabel">CGST (9%):</td>
                        <td class="total-value" id="cgst">₹0.00</td>
                    </tr>
                    <tr>
                        <td class="total-label" id="sgstLabel">SGST (9%):</td>
                        <td class="total-value" id="sgst">₹0.00</td>
                    </tr>
                    <tr class="grand-total">
                        <td class="total-label">Grand Total:</td>
                        <td class="total-value" id="grandTotal">₹0.00</td>
                    </tr>
                </table>
            </div>
        </div>

        <!-- Bank Account -->
        <div class="form-card">
            <h3>🏦 Bank Account (for invoice)</h3>
            <div class="form-grid" style="grid-template-columns: 1fr;">
                <div>
                    <label>Select Bank Account</label>
                    <asp:DropDownList ID="ddlBankAccount" runat="server" />
                </div>
            </div>
        </div>

        <asp:HiddenField ID="hfCGST" runat="server" Value="9" />
        <asp:HiddenField ID="hfSGST" runat="server" Value="9" />

        <asp:Button ID="btnSaveInvoice" runat="server" Text="💾 Save Invoice" CssClass="btn-save-invoice" OnClick="btnSaveInvoice_Click" OnClientClick="return prepareSubmit();" />
    </div>
</form>

<script>
    function addRow() {
        var tbody = document.getElementById('itemsBody');
        var row = document.createElement('tr');
        row.innerHTML = `
            <td class="item-cell">
                <input type="text" class="item-name item-name-input" placeholder="Item name" />
                <textarea class="item-desc" placeholder="Description (optional)" rows="1"></textarea>
            </td>
            <td><input type="number" class="item-qty" value="1" min="1" onchange="calcRow(this)" /></td>
            <td><input type="number" class="item-price" value="0" step="0.01" onchange="calcRow(this)" /></td>
            <td><input type="text" class="item-total" value="0.00" readonly style="background:#f1f5f9;font-weight:600;" /></td>
            <td><button type="button" class="btn-remove" onclick="removeRow(this)">✕</button></td>
        `;
        tbody.appendChild(row);
    }

    function removeRow(btn) {
        var tbody = document.getElementById('itemsBody');
        if (tbody.rows.length > 1) {
            btn.closest('tr').remove();
            calcTotals();
        }
    }

    function calcRow(el) {
        var row = el.closest('tr');
        var qty = parseFloat(row.querySelector('.item-qty').value) || 0;
        var price = parseFloat(row.querySelector('.item-price').value) || 0;
        row.querySelector('.item-total').value = (qty * price).toFixed(2);
        calcTotals();
    }

    function calcTotals() {
        var rows = document.querySelectorAll('#itemsBody tr');
        var subtotal = 0;
        rows.forEach(function(r) {
            subtotal += parseFloat(r.querySelector('.item-total').value) || 0;
        });

        var cgstPct = parseFloat(document.getElementById('inputCGST').value) || 0;
        var sgstPct = parseFloat(document.getElementById('inputSGST').value) || 0;
        var cgstAmt = subtotal * (cgstPct / 100);
        var sgstAmt = subtotal * (sgstPct / 100);
        var grand = subtotal + cgstAmt + sgstAmt;

        document.getElementById('subtotal').textContent = '₹' + subtotal.toFixed(2);
        document.getElementById('cgstLabel').textContent = 'CGST (' + cgstPct + '%):';
        document.getElementById('cgst').textContent = '₹' + cgstAmt.toFixed(2);
        document.getElementById('sgstLabel').textContent = 'SGST (' + sgstPct + '%):';
        document.getElementById('sgst').textContent = '₹' + sgstAmt.toFixed(2);
        document.getElementById('grandTotal').textContent = '₹' + grand.toFixed(2);
    }

    function prepareSubmit() {
        var rows = document.querySelectorAll('#itemsBody tr');
        var items = [];
        rows.forEach(function(r) {
            var name = r.querySelector('.item-name').value;
            var desc = r.querySelector('.item-desc').value;
            var qty = r.querySelector('.item-qty').value;
            var price = r.querySelector('.item-price').value;
            if (name && parseFloat(price) > 0) {
                items.push({ name: name, desc: desc, qty: parseInt(qty), price: parseFloat(price) });
            }
        });
        document.getElementById('<%= hfItemsJSON.ClientID %>').value = JSON.stringify(items);
        document.getElementById('<%= hfCGST.ClientID %>').value = document.getElementById('inputCGST').value;
        document.getElementById('<%= hfSGST.ClientID %>').value = document.getElementById('inputSGST').value;
        return true;
    }

    function loadItemsFromJSON() {
        var hf = document.getElementById('<%= hfItemsJSON.ClientID %>').value;
        if (hf && hf !== "[]") {
            try {
                var items = JSON.parse(hf);
                if (items.length > 0) {
                    var tbody = document.getElementById('itemsBody');
                    tbody.innerHTML = ''; // clear default row
                    items.forEach(function(item) {
                        var row = document.createElement('tr');
                        row.innerHTML = `
                            <td class="item-cell">
                                <input type="text" class="item-name item-name-input" placeholder="Item name" value="${item.name.replace(/"/g, '&quot;')}" />
                                <textarea class="item-desc" placeholder="Description (optional)" rows="1">${item.desc ? item.desc.replace(/</g, '&lt;') : ''}</textarea>
                            </td>
                            <td><input type="number" class="item-qty" value="${item.qty}" min="1" onchange="calcRow(this)" /></td>
                            <td><input type="number" class="item-price" value="${item.price}" step="0.01" onchange="calcRow(this)" /></td>
                            <td><input type="text" class="item-total" value="${(item.qty * item.price).toFixed(2)}" readonly style="background:#f1f5f9;font-weight:600;" /></td>
                            <td><button type="button" class="btn-remove" onclick="removeRow(this)">✕</button></td>
                        `;
                        tbody.appendChild(row);
                    });
                    
                    // also load taxes
                    document.getElementById('inputCGST').value = document.getElementById('<%= hfCGST.ClientID %>').value;
                    document.getElementById('inputSGST').value = document.getElementById('<%= hfSGST.ClientID %>').value;
                    
                    calcTotals();
                }
            } catch (e) {}
        }
    }

    window.onload = function() {
        loadItemsFromJSON();
    };
</script>
</body>
</html>
