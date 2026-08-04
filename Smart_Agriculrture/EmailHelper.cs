using System;
using System.Net;
using System.Net.Mail;

namespace Smart_Agriculrture
{
    public static class EmailHelper
    {
        private const string SenderEmail = "cherrysoftwerestore@gmail.com";
        private const string SenderPassword = "pzez vgdp wvhs uxmj";
        private const string SmtpHost = "smtp.gmail.com";
        private const int SmtpPort = 587;

        /// <summary>
        /// Sends an email using the pre-configured Gmail SMTP settings.
        /// </summary>
        public static void SendEmail(string toEmail, string subject, string bodyHtml)
        {
            MailMessage mail = new MailMessage();
            mail.From = new MailAddress(SenderEmail, "Smart Agriculture");
            mail.To.Add(toEmail);
            mail.Subject = subject;
            mail.Body = bodyHtml;
            mail.IsBodyHtml = true;

            SmtpClient smtp = new SmtpClient(SmtpHost, SmtpPort);
            smtp.Credentials = new NetworkCredential(SenderEmail, SenderPassword);
            smtp.EnableSsl = true;

            smtp.Send(mail);
        }
    }
}
