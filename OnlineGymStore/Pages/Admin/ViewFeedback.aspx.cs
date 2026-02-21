using System;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace OnlineGymStore.Pages.Admin
{
    public partial class ViewFeedback : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                // Initial data load
                LoadFeedbackData();
            }
        }

        private void LoadFeedbackData()
        {
            try
            {
                string feedbackType = ddlFilterType.SelectedValue;
                int rating = Convert.ToInt32(ddlFilterRating.SelectedValue);
                string searchTerm = txtSearch.Text.Trim();

                // Build the query based on filters
                string query = @"SELECT f.FeedbackID, u.FullName AS UserName, f.Subject, f.FeedbackType, 
                               f.Rating, f.Message, f.SubmissionDate 
                               FROM Feedback f
                               INNER JOIN Users u ON f.UserID = u.UserID
                               WHERE 1=1";

                // Add filter conditions
                if (!string.IsNullOrEmpty(feedbackType))
                {
                    query += " AND f.FeedbackType = @FeedbackType";
                }

                if (rating > 0)
                {
                    query += " AND f.Rating = @Rating";
                }

                if (!string.IsNullOrEmpty(searchTerm))
                {
                    query += " AND (f.Subject LIKE @SearchTerm OR f.Message LIKE @SearchTerm)";
                }

                // Add order by
                query += " ORDER BY f.SubmissionDate DESC";

                // Execute query and bind data
                string connectionString = ConfigurationManager.ConnectionStrings["GymShop"].ConnectionString;
                using (SqlConnection connection = new SqlConnection(connectionString))
                {
                    using (SqlCommand command = new SqlCommand(query, connection))
                    {
                        if (!string.IsNullOrEmpty(feedbackType))
                        {
                            command.Parameters.AddWithValue("@FeedbackType", feedbackType);
                        }

                        if (rating > 0)
                        {
                            command.Parameters.AddWithValue("@Rating", rating);
                        }

                        if (!string.IsNullOrEmpty(searchTerm))
                        {
                            command.Parameters.AddWithValue("@SearchTerm", "%" + searchTerm + "%");
                        }

                        using (SqlDataAdapter sda = new SqlDataAdapter(command))
                        {
                            DataTable dt = new DataTable();
                            connection.Open();
                            sda.Fill(dt);
                            gvFeedback.DataSource = dt;
                            gvFeedback.DataBind();
                        }
                    }
                }
            }
            catch (Exception ex)
            {
                // Display error message
                ScriptManager.RegisterStartupScript(this, GetType(), "ErrorAlert",
                    $"alert('Error loading feedback data: {ex.Message}');", true);
            }
        }

        protected void ApplyFilters(object sender, EventArgs e)
        {
            LoadFeedbackData();
        }

        protected void btnSearch_Click(object sender, EventArgs e)
        {
            LoadFeedbackData();
        }

        protected void btnClearFilters_Click(object sender, EventArgs e)
        {
            ddlFilterType.SelectedIndex = 0;
            ddlFilterRating.SelectedIndex = 0;
            txtSearch.Text = string.Empty;
            LoadFeedbackData();
        }

        protected void gvFeedback_PageIndexChanging(object sender, GridViewPageEventArgs e)
        {
            gvFeedback.PageIndex = e.NewPageIndex;
            LoadFeedbackData();
        }

        protected void gvFeedback_RowCommand(object sender, GridViewCommandEventArgs e)
        {
            // Get the feedback ID from the command argument
            int feedbackId = Convert.ToInt32(e.CommandArgument);

            // View message button clicked
            if (e.CommandName == "ViewMessage")
            {
                DisplayFeedbackDetails(feedbackId);
            }
            // Delete feedback button clicked
            else if (e.CommandName == "DeleteFeedback")
            {
                DeleteFeedback(feedbackId);
            }
        }

        private void DisplayFeedbackDetails(int feedbackId)
        {
            try
            {
                string connectionString = ConfigurationManager.ConnectionStrings["GymShop"].ConnectionString;
                using (SqlConnection connection = new SqlConnection(connectionString))
                {
                    string query = @"SELECT f.FeedbackID, u.FullName AS UserName, u.Email, f.Subject, 
                                   f.FeedbackType, f.Rating, f.Message, f.SubmissionDate 
                                   FROM Feedback f
                                   INNER JOIN Users u ON f.UserID = u.UserID
                                   WHERE f.FeedbackID = @FeedbackID";

                    using (SqlCommand command = new SqlCommand(query, connection))
                    {
                        command.Parameters.AddWithValue("@FeedbackID", feedbackId);
                        connection.Open();

                        using (SqlDataReader reader = command.ExecuteReader())
                        {
                            if (reader.Read())
                            {
                                // Format the feedback details
                                string details = $@"
                                    <div class='card'>
                                        <div class='card-body'>
                                            <h5 class='card-title'>{reader["Subject"]}</h5>
                                            <h6 class='card-subtitle mb-2 text-muted'>
                                                {reader["FeedbackType"]} - {reader["Rating"]} Stars
                                            </h6>
                                            <p class='card-text'>{reader["Message"]}</p>
                                            <div class='feedback-meta'>
                                                <small>
                                                    Submitted by: {reader["UserName"]} ({reader["Email"]})
                                                    <br>
                                                    Date: {Convert.ToDateTime(reader["SubmissionDate"]).ToString("MM/dd/yyyy hh:mm tt")}
                                                </small>
                                            </div>
                                        </div>
                                    </div>";

                                litFeedbackDetails.Text = details;

                                // Show the modal using JavaScript
                                ScriptManager.RegisterStartupScript(this, GetType(), "ShowFeedbackModal", "showFeedbackModal();", true);
                            }
                        }
                    }
                }
            }
            catch (Exception ex)
            {
                ScriptManager.RegisterStartupScript(this, GetType(), "ErrorAlert",
                    $"alert('Error displaying feedback details: {ex.Message}');", true);
            }
        }

        private void DeleteFeedback(int feedbackId)
        {
            try
            {
                string connectionString = ConfigurationManager.ConnectionStrings["GymShop"].ConnectionString;
                using (SqlConnection connection = new SqlConnection(connectionString))
                {
                    string query = "DELETE FROM Feedback WHERE FeedbackID = @FeedbackID";
                    using (SqlCommand command = new SqlCommand(query, connection))
                    {
                        command.Parameters.AddWithValue("@FeedbackID", feedbackId);
                        connection.Open();
                        int rowsAffected = command.ExecuteNonQuery();

                        if (rowsAffected > 0)
                        {
                            // Successful deletion
                            ScriptManager.RegisterStartupScript(this, GetType(), "SuccessAlert",
                                "alert('Feedback deleted successfully.');", true);
                        }
                        else
                        {
                            // Record not found
                            ScriptManager.RegisterStartupScript(this, GetType(), "ErrorAlert",
                                "alert('Feedback record not found.');", true);
                        }
                    }
                }

                // Reload the grid after deletion
                LoadFeedbackData();
            }
            catch (Exception ex)
            {
                ScriptManager.RegisterStartupScript(this, GetType(), "ErrorAlert",
                    $"alert('Error deleting feedback: {ex.Message}');", true);
            }
        }
    }
}