using System;
using System.Configuration;
using System.Data.SqlClient;
using System.Web.UI;

namespace OnlineGymStore.Pages.User
{
    public partial class Feedback : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            // No special logic needed on page load
        }

        protected void btnSubmitFeedback_Click(object sender, EventArgs e)
        {
            try
            {
                // Get user ID - modified to use a more reliable approach
                int userId;

                // Option 1: Try to get from Session if you're using session management
                if (Session["UserID"] != null)
                {
                    userId = Convert.ToInt32(Session["UserID"]);
                }
                // Option 2: Try to get from QueryString
                else if (Request.QueryString["UserID"] != null)
                {
                    userId = Convert.ToInt32(Request.QueryString["UserID"]);
                }
                // Option 3: For testing purposes, use a known valid UserID from your database
                else
                {
                    // Replace 1 with a valid UserID that exists in your Users table
                    userId = 1;
                }

                // Get form values
                string subject = txtSubject.Text.Trim();
                string feedbackType = ddlFeedbackType.SelectedValue;

                // Check if a rating is selected
                int rating;
                if (rblRating.SelectedValue != "")
                {
                    rating = Convert.ToInt32(rblRating.SelectedValue);
                }
                else
                {
                    // Default rating or error handling
                    Label1.Text = "Please select a rating.";
                    Label1.CssClass = "alert alert-warning mt-3";
                    Label1.Visible = true;
                    return;
                }

                string message = txtMessage.Text.Trim();
                DateTime submissionDate = DateTime.Now;

                // Verify the user exists first
                if (UserExists(userId))
                {
                    // Save feedback to database
                    if (SaveFeedback(userId, subject, feedbackType, rating, message, submissionDate))
                    {
                        // Clear form and display success message
                        txtSubject.Text = "";
                        ddlFeedbackType.SelectedIndex = 0;
                        rblRating.SelectedIndex = -1;
                        txtMessage.Text = "";

                        Label1.Text = "Thank you for your feedback!";
                        Label1.CssClass = "alert alert-success mt-3";
                        Label1.Visible = true;
                    }
                }
                else
                {
                    Label1.Text = "Unable to submit feedback. User ID not found.";
                    Label1.CssClass = "alert alert-danger mt-3";
                    Label1.Visible = true;
                }
            }
            catch (Exception ex)
            {
                Label1.Text = "An error occurred: " + ex.Message;
                Label1.CssClass = "alert alert-danger mt-3";
                Label1.Visible = true;
            }
        }

        // Helper method to check if user exists in the database
        private bool UserExists(int userId)
        {
            string connectionString = ConfigurationManager.ConnectionStrings["GymShop"].ConnectionString;
            using (SqlConnection connection = new SqlConnection(connectionString))
            {
                string query = "SELECT COUNT(1) FROM Users WHERE UserID = @UserID";
                using (SqlCommand command = new SqlCommand(query, connection))
                {
                    command.Parameters.AddWithValue("@UserID", userId);
                    connection.Open();
                    int count = (int)command.ExecuteScalar();
                    return count > 0;
                }
            }
        }

        private bool SaveFeedback(int userId, string subject, string feedbackType, int rating, string message, DateTime submissionDate)
        {
            string connectionString = ConfigurationManager.ConnectionStrings["GymShop"].ConnectionString;

            try
            {
                using (SqlConnection connection = new SqlConnection(connectionString))
                {
                    string query = @"INSERT INTO Feedback (UserID, Subject, FeedbackType, Rating, Message, SubmissionDate) 
                                   VALUES (@UserID, @Subject, @FeedbackType, @Rating, @Message, @SubmissionDate)";

                    using (SqlCommand command = new SqlCommand(query, connection))
                    {
                        command.Parameters.AddWithValue("@UserID", userId);
                        command.Parameters.AddWithValue("@Subject", subject);
                        command.Parameters.AddWithValue("@FeedbackType", feedbackType);
                        command.Parameters.AddWithValue("@Rating", rating);
                        command.Parameters.AddWithValue("@Message", message);
                        command.Parameters.AddWithValue("@SubmissionDate", submissionDate);

                        connection.Open();
                        command.ExecuteNonQuery();
                        return true;
                    }
                }
            }
            catch (SqlException ex)
            {
                // Handle SQL specific exceptions
                if (ex.Number == 547) // Foreign key violation
                {
                    Label1.Text = "Database constraint error: " + ex.Message;
                }
                else
                {
                    Label1.Text = "Database error occurred: " + ex.Message;
                }
                Label1.CssClass = "alert alert-danger mt-3";
                Label1.Visible = true;
                return false;
            }
        }
    }
}