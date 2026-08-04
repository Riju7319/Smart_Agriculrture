using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace Smart_Agriculrture.WeatherData
{
	public partial class ViewSensoreData : System.Web.UI.Page
	{
		protected void Page_Load(object sender, EventArgs e)
		{
            AuthHelper.CheckLogin();
        }
        protected void btnLogout_Click(object sender, EventArgs e)
        {
            Session.Clear();
            Session.Abandon();
            Response.Redirect("~/Login.aspx");
        }
    }
}