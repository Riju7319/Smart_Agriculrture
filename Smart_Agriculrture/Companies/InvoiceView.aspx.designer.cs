namespace Smart_Agriculrture.Companies
{
    public partial class InvoiceView
    {
        protected global::System.Web.UI.HtmlControls.HtmlForm form1;
        protected global::System.Web.UI.WebControls.HiddenField hfInvoiceID;
        protected global::System.Web.UI.WebControls.HiddenField hfCompanyID;
        protected global::System.Web.UI.HtmlControls.HtmlAnchor lnkBack;
        protected global::System.Web.UI.WebControls.DropDownList ddlStatusUpdate;
        protected global::System.Web.UI.WebControls.Button btnUpdateStatus;
        protected global::System.Web.UI.WebControls.Button btnSendEmail;
        protected global::System.Web.UI.WebControls.Label lblMessage;
        protected global::System.Web.UI.WebControls.Label lblCompanyName;
        protected global::System.Web.UI.WebControls.Label lblCompanyAddress;
        protected global::System.Web.UI.WebControls.Label lblCompanyContact;
        protected global::System.Web.UI.WebControls.PlaceHolder phGST;
        protected global::System.Web.UI.WebControls.Label lblCompanyGST;
        protected global::System.Web.UI.WebControls.PlaceHolder phPAN;
        protected global::System.Web.UI.WebControls.Label lblCompanyPAN;
        protected global::System.Web.UI.WebControls.Label lblStatusBadge;
        protected global::System.Web.UI.WebControls.Label lblBilledTo;
        protected global::System.Web.UI.WebControls.Label lblInvoiceNumber;
        protected global::System.Web.UI.WebControls.Label lblInvoiceDate;
        protected global::System.Web.UI.WebControls.Label lblDueDate;
        protected global::System.Web.UI.WebControls.Label lblSentStatus;
        protected global::System.Web.UI.WebControls.Repeater rptItems;
        protected global::System.Web.UI.WebControls.Label lblSubtotal;
        protected global::System.Web.UI.WebControls.Label lblCGSTPct;
        protected global::System.Web.UI.WebControls.Label lblSGSTPct;
        protected global::System.Web.UI.WebControls.Label lblCGST;
        protected global::System.Web.UI.WebControls.Label lblSGST;
        protected global::System.Web.UI.WebControls.Label lblGrandTotal;
        protected global::System.Web.UI.WebControls.Panel pnlBankDetails;
        protected global::System.Web.UI.WebControls.Label lblBankName;
        protected global::System.Web.UI.WebControls.Label lblBankAccount;
        protected global::System.Web.UI.WebControls.Label lblBankIFSC;
        protected global::System.Web.UI.WebControls.Label lblBankUPI;
        protected global::System.Web.UI.WebControls.PlaceHolder phBankPAN;
        protected global::System.Web.UI.WebControls.Label lblBankPAN;
    }
}
