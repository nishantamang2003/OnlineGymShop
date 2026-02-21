<%@ Page Title="" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="About.aspx.cs" Inherits="OnlineGymStore.Pages.User.About" %>

<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">
    <style>
        .about-wrapper {
            background-color: #111;
            color: #fff;
            padding: 60px 5% 40px;
            font-family: 'Segoe UI', sans-serif;
        }

        .about-header {
            text-align: center;
            font-size: 36px;
            font-weight: bold;
            margin-bottom: 30px;
        }

        .about-section {
            display: flex;
            flex-wrap: wrap;
            justify-content: space-between;
            gap: 40px;
        }

        /* Centered Stats Section */
        .stats-container {
            width: 100%;
            display: flex;
            justify-content: center;
            margin: 30px 0;
        }

        .centered-stats {
            display: flex;
            gap: 50px;
            justify-content: center;
        }

        .stat-item {
            text-align: center;
        }

            .stat-item h3 {
                font-size: 28px;
                margin-bottom: 5px;
                color: #e63946;
            }

            .stat-item p {
                font-size: 16px;
                color: #aaa;
            }

        /* Rest of your existing styles */
        .breadcrumb {
            text-align: center;
            font-size: 14px;
            color: #ccc;
            margin-bottom: 50px;
        }

        .about-left {
            flex: 1;
            min-width: 300px;
        }

        .about-right {
            flex: 1;
            min-width: 300px;
        }

        .label {
            font-size: 12px;
            letter-spacing: 2px;
            color: #aaa;
            margin-bottom: 10px;
            position: relative;
        }

            .label::before {
                content: "";
                position: absolute;
                left: -20px;
                top: 5px;
                width: 4px;
                height: 20px;
                background: linear-gradient(to bottom, #e63946, #ff0000);
            }

        .about-title {
            font-size: 28px;
            font-weight: bold;
            margin-bottom: 20px;
        }

        .highlight {
            color: #e63946;
        }

        .about-left img,
        .about-right img {
            width: 100%;
            border-radius: 12px;
        }

        .description {
            color: #ccc;
            font-size: 15px;
            line-height: 1.6;
            margin-top: 20px;
            margin-bottom: 30px;
        }
        
        /* Our Team Section Styles */
        .team-section {
            width: 100%;
            margin-top: 60px;
            text-align: center;
        }
        
        .team-title {
            font-size: 32px;
            font-weight: bold;
            margin-bottom: 30px;
        }
        
        .team-description {
            color: #ccc;
            max-width: 700px;
            margin: 0 auto 30px;
            line-height: 1.6;
        }
        
        .team-members {
            display: flex;
            flex-wrap: wrap;
            justify-content: center;
            gap: 30px;
            margin-top: 40px;
        }
        
        .team-member {
            width: 300px;
            background-color: #222;
            border-radius: 12px;
            padding-bottom: 20px;
            box-shadow: 0 5px 15px rgba(0, 0, 0, 0.3);
            overflow: hidden;
        }
        
        .member-image-container {
            width: 100%;
            height: 300px;
            background-color: #333;
            position: relative;
            overflow: hidden;
            margin-bottom: 15px;
        }
        
        .member-image {
            width: 100%;
            height: 100%;
            object-fit: cover;
            display: block;
        }
        
        .member-info {
            padding: 0 15px;
        }
        
        .member-name {
            font-size: 22px;
            font-weight: bold;
            margin-bottom: 5px;
        }
        
        .member-role {
            color: #e63946;
            font-size: 16px;
            margin-bottom: 15px;
        }
        
        .member-bio {
            color: #ccc;
            font-size: 14px;
            line-height: 1.5;
            margin-bottom: 15px;
        }
    </style>

    <div class="about-wrapper">
        <h1 class="about-header">About Us</h1>

        <div class="about-section">
            <!-- LEFT SECTION -->
            <div class="about-left">
                <div class="label">OUR STORY</div>
                <div class="about-title">
                    Your Vision Our Expertise Your Success Get Noticed Generate
                    <span class="highlight">Leads Dominate.</span>
                </div>
                <img src="/Image/aboutus.jpg" alt="Team Discussion" />
            </div>

            <!-- RIGHT SECTION -->
            <div class="about-right">
                <div style="display: flex; gap: 10px; margin-bottom: 15px;">
                    <img src="/Image/small.jpg" alt="KettleBells" style="border-radius: 10px; width: 48%;" />
                    <img src="/Image/weight.jpg" alt="Weight Lifting" style="border-radius: 10px; width: 48%;" />
                </div>
                <div class="description">
                   

Explore a wide range of premium gym accessories designed to elevate your fitness routine. Whether you're looking to improve strength, endurance, or flexibility, we have the perfect equipment for every goal. Our collection includes everything from dumbbells and resistance bands to yoga mats and fitness trackers, all crafted for quality and durability.
                </div>
                
                <!-- Centered Stats Section -->
                <div class="stats-container">
                    <div class="centered-stats">
                        <div class="stat-item">
                            <h3>15k</h3>
                            <p>Satisfied Customers</p>
                        </div>
                        <div class="stat-item">
                            <h3>10k+</h3>
                            <p>Years Of Mastery</p>
                        </div>
                    </div>
                </div>
            </div>
        </div>
        
        <!-- OUR TEAM SECTION (Newly Added) -->
        <div class="team-section">
            <h2 class="team-title">Our <span class="highlight">Team</span></h2>
            <p class="team-description">
                Meet the passionate fitness professionals behind our success. Our team of certified trainers and nutrition experts are dedicated to helping you achieve your fitness goals.
            </p>
            
            <div class="team-members">
                <!-- Team Member 1 -->
                <div class="team-member">
                    <div class="member-image-container">
                        <img src="/Image/trainer.jpg" class="member-image" alt="Harish Singh Air" />
                    </div>
                    <div class="member-info">
                        <h3 class="member-name">Harish Singh Air</h3>
                        <p class="member-role">Head Trainer</p>
                        <p class="member-bio">With over 10 years of experience in fitness training, Harish specializes in strength and conditioning programs for athletes of all levels.</p>
                    </div>
                </div>
                
                <!-- Team Member 2 -->
                <div class="team-member">
                    <div class="member-image-container">
                        <img src="/Image/nutrition.jpg" class="member-image" alt="Sabal Shahi" />
                    </div>
                    <div class="member-info">
                        <h3 class="member-name">Sabal Shahi</h3>
                        <p class="member-role">Nutrition Expert</p>
                        <p class="member-bio">Sabal holds a Masters in Nutrition and creates personalized meal plans to complement your workout routine for maximum results.</p>
                    </div>
                </div>
                
                <!-- Team Member 3 -->
                <div class="team-member">
                    <div class="member-image-container">
                        <img src="/Image/yoga.jpg" class="member-image" alt="Nirjala Thapa" />
                    </div>
                    <div class="member-info">
                        <h3 class="member-name">Nirjala thapa</h3>
                        <p class="member-role">Yoga Instructor</p>
                        <p class="member-bio">Nirjala combines traditional yoga techniques with modern fitness principles to create balanced, comprehensive wellness programs.</p>
                    </div>
                </div>
            </div>
        </div>
    </div>
</asp:Content>