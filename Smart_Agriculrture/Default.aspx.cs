using System;
using System.Data;
using System.Xml;
using System.Linq;

namespace Smart_Agriculrture
{
    public partial class _Default : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                BindIoTNews();
            }
        }

        protected void BindIoTNews()
        {
            string rssUrl = "https://feeds.feedburner.com/IotBusinessNews";
            DataTable dt = new DataTable();
            dt.Columns.Add("Title");
            dt.Columns.Add("Link");
            dt.Columns.Add("PubDate");

            try
            {
                XmlDocument xmlDoc = new XmlDocument();
                xmlDoc.Load(rssUrl);
                XmlNodeList nodeList = xmlDoc.SelectNodes("rss/channel/item");

                foreach (XmlNode node in nodeList.Cast<XmlNode>().Take(6))
                {
                    DataRow row = dt.NewRow();
                    row["Title"] = node["title"]?.InnerText;
                    row["Link"] = node["link"]?.InnerText;
                    row["PubDate"] = Convert.ToDateTime(node["pubDate"]?.InnerText).ToString("dd MMM yyyy");
                    dt.Rows.Add(row);
                }

                rptIoTNews.DataSource = dt;
                rptIoTNews.DataBind();
            }
            catch
            {
                // handle gracefully
            }
        }


    }
}
