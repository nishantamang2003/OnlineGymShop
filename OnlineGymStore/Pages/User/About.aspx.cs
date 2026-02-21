using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace OnlineGymStore.Pages.User
{
    public partial class About : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                // You can load dynamic content here in future, like pulling from a database.
                // For now, it's just a placeholder for demonstration.
                LoadStats();
            }
        }

        private void LoadStats()
        {
            // In a real scenario, these values might be fetched from a database.
            ViewState["CompletedProjects"] = "10k+";
            ViewState["SatisfiedCustomers"] = "15k+";
            ViewState["YearsOfMastery"] = "10+";
            ViewState["WorldwideHonors"] = "45+";

            // Example: You can use these ViewState values in controls later if needed.
        }
    }
}