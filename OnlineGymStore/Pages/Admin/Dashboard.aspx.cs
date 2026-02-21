using System;
using System.Data;
using System.Data.SqlClient;
using System.Configuration;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Collections.Generic;
using System.Linq;

namespace OnlineGymStore.Pages.Admin
{
    public partial class Dashboard : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                LoadDashboardStats();
                LoadSalesChart();
                LoadRevenueChart();
                LoadRecentOrders();
            }
        }

        private void LoadDashboardStats()
        {
            string connectionString = ConfigurationManager.ConnectionStrings["GymShop"].ConnectionString;

            using (SqlConnection con = new SqlConnection(connectionString))
            {
                // Total Users
                using (SqlCommand cmd = new SqlCommand("SELECT COUNT(*) FROM Users", con))
                {
                    con.Open();
                    lblTotalUsers.Text = cmd.ExecuteScalar().ToString();
                    con.Close();
                }

                // Total Products
                using (SqlCommand cmd = new SqlCommand("SELECT COUNT(*) FROM Products WHERE IsActive = 1", con))
                {
                    con.Open();
                    lblTotalProducts.Text = cmd.ExecuteScalar().ToString();
                    con.Close();
                }

                // New Orders (orders from last 7 days)
                using (SqlCommand cmd = new SqlCommand("SELECT COUNT(*) FROM Orders WHERE OrderDate >= DATEADD(day, -7, GETDATE())", con))
                {
                    con.Open();
                    lblNewOrders.Text = cmd.ExecuteScalar().ToString();
                    con.Close();
                }

                // Total Revenue (sum of all completed orders)
                using (SqlCommand cmd = new SqlCommand("SELECT ISNULL(SUM(Total), 0) FROM Orders WHERE Status = 'Completed'", con))
                {
                    con.Open();
                    lblTotalRevenue.Text = string.Format("{0:N2}", cmd.ExecuteScalar());
                    con.Close();
                }
            }
        }

        protected void ddlTimePeriod_SelectedIndexChanged(object sender, EventArgs e)
        {
            LoadSalesChart();
        }

        private void LoadSalesChart()
        {
            int days = int.Parse(ddlTimePeriod.SelectedValue);
            string connectionString = ConfigurationManager.ConnectionStrings["GymShop"].ConnectionString;

            // Generate chart data for the selected time period
            var chartData = new List<SalesData>();

            using (SqlConnection con = new SqlConnection(connectionString))
            {
                string query = @"
                    SELECT 
                        CONVERT(date, OrderDate) as OrderDay,
                        SUM(Total) as DailySales,
                        COUNT(OrderID) as OrderCount
                    FROM Orders
                    WHERE OrderDate >= DATEADD(day, -@Days, GETDATE())
                    GROUP BY CONVERT(date, OrderDate)
                    ORDER BY OrderDay";

                using (SqlCommand cmd = new SqlCommand(query, con))
                {
                    cmd.Parameters.AddWithValue("@Days", days);
                    con.Open();
                    SqlDataReader reader = cmd.ExecuteReader();

                    while (reader.Read())
                    {
                        chartData.Add(new SalesData
                        {
                            Date = Convert.ToDateTime(reader["OrderDay"]),
                            Amount = Convert.ToDecimal(reader["DailySales"]),
                            Count = Convert.ToInt32(reader["OrderCount"])
                        });
                    }
                }
            }

            // Generate JavaScript for the chart
            string labels = string.Join(",", chartData.Select(d => $"'{d.Date.ToString("MMM dd")}'"));
            string amounts = string.Join(",", chartData.Select(d => d.Amount));
            string counts = string.Join(",", chartData.Select(d => d.Count));

            string chartScript = $@"
            <script>
                var ctx = document.createElement('canvas');
                ctx.id = 'salesChart';
                document.getElementById('{ltSalesChart.ClientID}').appendChild(ctx);
                
                var salesChart = new Chart(ctx, {{
                    type: 'line',
                    data: {{
                        labels: [{labels}],
                        datasets: [
                            {{
                                label: 'Sales Amount ($)',
                                data: [{amounts}],
                                backgroundColor: 'rgba(78, 115, 223, 0.05)',
                                borderColor: 'rgba(78, 115, 223, 1)',
                                borderWidth: 2,
                                yAxisID: 'y-axis-amount'
                            }},
                            {{
                                label: 'Number of Orders',
                                data: [{counts}],
                                backgroundColor: 'rgba(28, 200, 138, 0.05)',
                                borderColor: 'rgba(28, 200, 138, 1)',
                                borderWidth: 2,
                                type: 'bar',
                                yAxisID: 'y-axis-count'
                            }}
                        ]
                    }},
                    options: {{
                        responsive: true,
                        maintainAspectRatio: false,
                        scales: {{
                            yAxes: [
                                {{
                                    id: 'y-axis-amount',
                                    type: 'linear',
                                    position: 'left',
                                    ticks: {{
                                        beginAtZero: true,
                                        callback: function(value) {{ return '$' + value; }}
                                    }}
                                }},
                                {{
                                    id: 'y-axis-count',
                                    type: 'linear',
                                    position: 'right',
                                    ticks: {{ beginAtZero: true }},
                                    gridLines: {{ drawOnChartArea: false }}
                                }}
                            ]
                        }}
                    }}
                }});
            </script>";

            ltSalesChart.Text = chartScript;
        }

        private void LoadRevenueChart()
        {
            string connectionString = ConfigurationManager.ConnectionStrings["GymShop"].ConnectionString;

            // Get revenue by product category
            var revenueData = new Dictionary<string, decimal>();

            using (SqlConnection con = new SqlConnection(connectionString))
            {
                string query = @"
                    SELECT 
                        c.CategoryName,
                        SUM(oi.Quantity * oi.UnitPrice) as CategoryRevenue
                    FROM OrderItems oi
                    JOIN Products p ON oi.ProductID = p.ProductID
                    JOIN Categories c ON p.CategoryID = c.CategoryID
                    JOIN Orders o ON oi.OrderID = o.OrderID
                    WHERE o.Status = 'Completed'
                    GROUP BY c.CategoryName
                    ORDER BY CategoryRevenue DESC";

                using (SqlCommand cmd = new SqlCommand(query, con))
                {
                    con.Open();
                    SqlDataReader reader = cmd.ExecuteReader();

                    while (reader.Read())
                    {
                        revenueData.Add(
                            reader["CategoryName"].ToString(),
                            Convert.ToDecimal(reader["CategoryRevenue"])
                        );
                    }
                }
            }

            // Generate JavaScript for the chart
            string labels = string.Join(",", revenueData.Keys.Select(k => $"'{k}'"));
            string data = string.Join(",", revenueData.Values);
            string backgroundColors = string.Join(",", GetChartColors(revenueData.Count));

            string chartScript = $@"
            <script>
                var ctx = document.createElement('canvas');
                ctx.id = 'revenueChart';
                document.getElementById('{ltRevenueChart.ClientID}').appendChild(ctx);
                
                var revenueChart = new Chart(ctx, {{
                    type: 'doughnut',
                    data: {{
                        labels: [{labels}],
                        datasets: [{{
                            data: [{data}],
                            backgroundColor: [{backgroundColors}],
                            hoverBackgroundColor: [{backgroundColors}],
                            hoverBorderColor: 'rgba(234, 236, 244, 1)',
                        }}]
                    }},
                    options: {{
                        responsive: true,
                        maintainAspectRatio: false,
                        tooltips: {{
                            backgroundColor: 'rgb(255,255,255)',
                            bodyFontColor: '#858796',
                            borderColor: '#dddfeb',
                            borderWidth: 1,
                            xPadding: 15,
                            yPadding: 15,
                            displayColors: false,
                            caretPadding: 10,
                            callbacks: {{
                                label: function(tooltipItem, data) {{
                                    var label = data.labels[tooltipItem.index] || '';
                                    var value = data.datasets[0].data[tooltipItem.index];
                                    return label + ': $' + value.toFixed(2);
                                }}
                            }}
                        }},
                        legend: {{
                            display: true,
                            position: 'bottom'
                        }},
                        cutoutPercentage: 70
                    }}
                }});
            </script>";

            ltRevenueChart.Text = chartScript;
        }

        private void LoadRecentOrders()
        {
            string connectionString = ConfigurationManager.ConnectionStrings["GymShop"].ConnectionString;

            using (SqlConnection con = new SqlConnection(connectionString))
            {
                string query = @"
                    SELECT TOP 5 
                        o.OrderID,
                        u.FullName as CustomerName,
                        o.OrderDate,
                        o.Total as TotalAmount,
                        o.Status
                    FROM Orders o
                    JOIN Users u ON o.UserID = u.UserID
                    ORDER BY o.OrderDate DESC";

                using (SqlCommand cmd = new SqlCommand(query, con))
                {
                    con.Open();
                    SqlDataAdapter da = new SqlDataAdapter(cmd);
                    DataTable dt = new DataTable();
                    da.Fill(dt);

                    gvRecentOrders.DataSource = dt;
                    gvRecentOrders.DataBind();
                }
            }
        }

        private List<string> GetChartColors(int count)
        {
            var colors = new List<string>
            {
                "'#4e73df'", "'#1cc88a'", "'#36b9cc'", "'#f6c23e'", "'#e74a3b'",
                "'#5a5c69'", "'#858796'", "'#dddfeb'", "'#3a3b45'", "'#b7b7cc'"
            };

            return colors.Take(count).ToList();
        }
    }

    public class SalesData
    {
        public DateTime Date { get; set; }
        public decimal Amount { get; set; }
        public int Count { get; set; }
    }
}