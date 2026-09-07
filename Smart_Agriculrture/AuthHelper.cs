using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace Smart_Agriculrture
{
	public class AuthHelper
	{
        public static void CheckLogin()
        {
            if (HttpContext.Current.Session["FarmerID"] == null)
            {
                // Redirect if not logged in
                HttpContext.Current.Response.Redirect("~/login.aspx");
            }
        }
    }
}