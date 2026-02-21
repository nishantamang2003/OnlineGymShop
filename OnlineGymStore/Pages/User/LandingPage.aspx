<%@ Page Title="Home" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="LandingPage.aspx.cs" Inherits="OnlineGymStore.Pages.User.LandingPage" %>

<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">
    <style>
        /* Main Styles */
        body {
            font-family: 'Segoe UI', Arial, sans-serif;
            background-color: black;
            color: white;
            margin: 0;
            padding: 0;
            line-height: 1.6;
        }

        /* Hero Section */
        .hero {
            text-align: center;
            padding: 6rem 2rem 8rem;
            background: linear-gradient(rgba(0, 0, 0, 0.6), rgba(0, 0, 0, 0.7)), url('/Image/header.jpg');
            background-size: cover;
            background-position: center top;
            background-repeat: no-repeat;
            background-attachment: fixed;
            color: white;
            position: relative;
            overflow: hidden;
            animation: panImage 20s ease-in-out infinite alternate;
        }

        @keyframes panImage {
            0% {
                background-position: center top;
            }
            100% {
                background-position: center bottom;
            }
        }

        .hero h1 {
            font-size: 3rem;
            margin-bottom: 1.5rem;
            font-weight: 700;
            text-shadow: 0 2px 4px rgba(0,0,0,0.5);
            line-height: 1.2;
        }

        .hero h1 .highlight {
            color: #ff5a5f;
            font-weight: 800;
            position: relative;
            display: inline-block;
        }

        .hero h1 .highlight:after {
            content: '';
            position: absolute;
            bottom: 5px;
            left: 0;
            width: 100%;
            height: 3px;
            background: white;
            z-index: -1;
            opacity: 0.7;
        }

        .hero p {
            font-size: 1.3rem;
            margin-bottom: 2rem;
            line-height: 1.6;
            max-width: 800px;
            margin-left: auto;
            margin-right: auto;
            text-shadow: 0 1px 3px rgba(0,0,0,0.5);
        }

        .hero p .highlight {
            color: #ffcc00;
            font-weight: 600;
        }

        .hero-cta {
            display: flex;
            justify-content: center;
            gap: 1rem;
            margin-bottom: 3rem;
        }

        .cta-btn {
            background-color: #ff5a5f;
            color: white;
            padding: 0.8rem 2rem;
            border-radius: 4px;
            text-decoration: none;
            font-weight: 600;
            transition: all 0.3s;
            box-shadow: 0 4px 8px rgba(0,0,0,0.2);
            border: 2px solid transparent;
        }

        .cta-btn:hover {
            background-color: #e04a50;
            transform: translateY(-2px);
            box-shadow: 0 6px 12px rgba(0,0,0,0.3);
        }

        .secondary-btn {
            background-color: transparent;
            border: 2px solid white;
            color: white;
            padding: 0.8rem 2rem;
            border-radius: 4px;
            text-decoration: none;
            font-weight: 600;
            transition: all 0.3s;
            box-shadow: 0 4px 8px rgba(0,0,0,0.1);
        }

        .secondary-btn:hover {
            background-color: rgba(255, 255, 255, 0.2);
            transform: translateY(-2px);
            box-shadow: 0 6px 12px rgba(0,0,0,0.2);
        }

        .hero-stats {
            display: flex;
            justify-content: center;
            gap: 3rem;
            margin-top: 2rem;
            background-color: rgba(0,0,0,0.4);
            padding: 1.5rem;
            border-radius: 8px;
            max-width: 800px;
            margin-left: auto;
            margin-right: auto;
            backdrop-filter: blur(5px);
        }

        .stat-item {
            display: flex;
            flex-direction: column;
        }

        .stat-number {
            font-size: 2.5rem;
            font-weight: 700;
            margin-bottom: 0.5rem;
            color: #ff5a5f;
        }

        .stat-label {
            font-size: 1rem;
            opacity: 0.9;
        }

        /* FAQ Section */
        .fitness-faq-container {
            padding: 80px 20px;
            background-color: rgba(0,0,0,0.2);
        }

        .fitness-faq-content {
            display: flex;
            max-width: 1200px;
            margin: 0 auto;
            gap: 50px;
        }

        .faq-image-column {
            flex: 1;
        }

        .image-placeholder {
            height: 500px;
            border-radius: 8px;
            overflow: hidden;
        }

        .faq-text-column {
            flex: 1;
        }

        .faq-text-column h1 {
            font-size: 2.2rem;
            margin-bottom: 15px;
        }

        .intro-text {
            font-size: 1.1rem;
            margin-bottom: 30px;
            line-height: 1.6;
        }

        .divider {
            width: 80px;
            height: 3px;
            background: #e63946;
            margin: 0 0 40px;
        }

        .faq-list {
            display: flex;
            flex-direction: column;
            gap: 10px;
        }

        .faq-item {
            border-bottom: 1px solid #444;
        }

        .faq-question {
            display: flex;
            justify-content: space-between;
            align-items: center;
            padding: 15px 0;
            cursor: pointer;
            font-weight: 600;
            transition: all 0.3s ease;
        }

        .faq-question:hover {
            color: #ff5a5f;
        }

        .arrow {
            font-size: 0.8rem;
            transition: transform 0.3s ease;
        }

        .faq-answer {
            max-height: 0;
            overflow: hidden;
            transition: max-height 0.3s ease;
            padding-left: 10px;
        }

        .faq-answer p {
            line-height: 1.6;
            padding-bottom: 20px;
        }

        .faq-item.active .arrow {
            transform: rotate(90deg);
        }

        .faq-item.active .faq-question {
            color: #ff5a5f;
        }

        @media (max-width: 768px) {
            .hero {
                padding: 4rem 1rem 6rem;
                background-attachment: scroll;
            }

            .hero h1 {
                font-size: 2rem;
            }

            .hero p {
                font-size: 1.1rem;
            }

            .hero-stats {
                flex-direction: column;
                gap: 1.5rem;
                padding: 1rem;
            }

            .hero-cta {
                flex-direction: column;
                align-items: center;
            }

            .fitness-faq-content {
                flex-direction: column;
            }

            .image-placeholder {
                height: 300px;
            }

            .faq-text-column h1 {
                font-size: 1.8rem;
            }
        }
    </style>

    <!-- Hero Section -->
    <div class="hero">
        <h1><span class="highlight">Premium</span> Gym Equipment & <span class="highlight">Accessories</span></h1>
        <p>
            Upgrade your workouts with <span class="highlight">high-quality</span> gear designed for <span class="highlight">performance</span> and <span class="highlight">durability</span>.<br>
            Shop the <span class="highlight">best equipment</span> for your home gym or fitness studio.
        </p>

        <div class="hero-cta">
            <a href="Products.aspx" class="cta-btn">Shop Now</a>
            <a href="Products.aspx" class="secondary-btn">View Best Sellers</a>
        </div>

        <div class="hero-stats">
            <div class="stat-item">
                <span class="stat-number">10k+</span>
                <span class="stat-label">Satisfied Customers</span>
            </div>
            <div class="stat-item">
                <span class="stat-number">500+</span>
                <span class="stat-label">Quality Products</span>
            </div>
            <div class="stat-item">
                <span class="stat-number">24/7</span>
                <span class="stat-label">Customer Support</span>
            </div>
        </div>
    </div>

    <!-- FAQ Section -->
    <div class="fitness-faq-container">
        <div class="fitness-faq-content">
            <!-- Left Column for Image -->
            <div class="faq-image-column">
                <div class="image-placeholder">
                    <img src="/Image/feature.jpg" alt="Feature Image" style="width: 100%; height: 100%; object-fit: cover;" />
                </div>
            </div>

            <!-- Right Column for FAQ Content -->
            <div class="faq-text-column">
                <h1>Experience the Best in Fitness: Here's Why?</h1>
                <p class="intro-text">Discover what makes our gym equipment stand out from the competition with premium quality and innovative features.</p>
                <div class="divider"></div>

                <div class="faq-list">
                    <div class="faq-item">
                        <div class="faq-question">
                            <span>Commercial-Grade Equipment</span>
                            <div class="arrow">▶</div>
                        </div>
                        <div class="faq-answer">
                            <p>Professional quality gym equipment built to withstand intense daily use with premium materials and construction.</p>
                        </div>
                    </div>

                    <div class="faq-item">
                        <div class="faq-question">
                            <span>Smart Workout Technology</span>
                            <div class="arrow">▶</div>
                        </div>
                        <div class="faq-answer">
                            <p>Bluetooth-connected machines that sync with fitness apps and automatically adjust to your workout needs.</p>
                        </div>
                    </div>

                    <div class="faq-item">
                        <div class="faq-question">
                            <span>Space-Saving Designs</span>
                            <div class="arrow">▶</div>
                        </div>
                        <div class="faq-answer">
                            <p>Innovative compact equipment that delivers full functionality without requiring a large footprint.</p>
                        </div>
                    </div>

                    <div class="faq-item">
                        <div class="faq-question">
                            <span>Lifetime Support</span>
                            <div class="arrow">▶</div>
                        </div>
                        <div class="faq-answer">
                            <p>Comprehensive warranties and access to our network of certified technicians for maintenance and repairs.</p>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <script>
        document.addEventListener('DOMContentLoaded', function () {
            const faqItems = document.querySelectorAll('.faq-item');

            faqItems.forEach(item => {
                const question = item.querySelector('.faq-question');

                question.addEventListener('click', () => {
                    faqItems.forEach(otherItem => {
                        if (otherItem !== item && otherItem.classList.contains('active')) {
                            otherItem.classList.remove('active');
                            otherItem.querySelector('.faq-answer').style.maxHeight = null;
                        }
                    });

                    item.classList.toggle('active');
                    const answer = item.querySelector('.faq-answer');

                    if (item.classList.contains('active')) {
                        answer.style.maxHeight = answer.scrollHeight + 'px';
                    } else {
                        answer.style.maxHeight = null;
                    }
                });
            });
        });
    </script>
</asp:Content>
