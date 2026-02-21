<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="Login.aspx.cs" Inherits="OnlineGymStore.Pages.User.Login" %>


<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>GymShop - Login</title>
    <meta name="viewport" content="width=device-width, initial-scale=1" />
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet" />
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" />

    <style>
        @import url('https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700&display=swap');

        body {
            font-family: 'Inter', sans-serif;
            display: flex;
            align-items: center;
            justify-content: center;
            height: 100vh;
            margin: 0;
            background-color: #ffffff;
        }

        .login-container {
            display: flex;
            width: 900px;
            height: 500px;
            border-radius: 10px;
            overflow: hidden;
            box-shadow: 0 4px 10px rgba(0, 0, 0, 0.1);
        }

        .login-form {
            width: 50%;
            background: #ffffff;
            padding: 40px;
            display: flex;
            flex-direction: column;
            justify-content: center;
        }

        .login-image {
    width: 50%;
    background: url('https://images.unsplash.com/photo-1571019614242-c5c5dee9f50b?ixlib=rb-1.2.1&auto=format&fit=crop&w=1350&q=80') no-repeat center center;
    background-size: cover;
}

        .page-title {
            font-size: 28px;
            font-weight: 600;
            text-align: center;
            margin-bottom: 30px;
            color: #000;
        }

        .form-label {
            font-weight: 500;
            color: #333;
            font-size: 14px;
            margin-bottom: 8px;
            display: block;
        }

        .form-control {
            border-radius: 4px;
            border: 1px solid #ddd;
            padding: 12px 15px;
            transition: all 0.2s ease;
            font-size: 15px;
            background: #fafafa;
        }

            .form-control:focus {
                border-color: #000;
                box-shadow: none;
                background: #fff;
                outline: none;
            }

        .btn-login {
            background-color: #000;
            color: white;
            border: none;
            width: 100%;
            padding: 14px;
            font-size: 15px;
            font-weight: 500;
            border-radius: 4px;
            transition: all 0.2s ease;
            text-transform: uppercase;
            margin-top: 10px;
        }

            .btn-login:hover {
                background-color: dimgray;
                color: white;
                transform: translateY(-1px);
            }

            .btn-login:active {
                transform: translateY(0);
            }

        .text-center {
            text-align: center;
            margin-top: 25px;
            font-size: 14px;
            color: #666;
        }

            .text-center a {
                color: #000;
                text-decoration: underline;
                font-weight: 500;
            }

                .text-center a:hover {
                    color: #333;
                    text-decoration: none;
                }

        .password-wrapper {
            position: relative;
        }

        .toggle-password {
            position: absolute;
            right: 12px;
            top: 50%;
            transform: translateY(-50%);
            cursor: pointer;
            color: #777;
            background: none;
            border: none;
            padding: 0 8px;
        }

            .toggle-password:hover {
                color: #000;
            }

            .toggle-password i {
                font-size: 16px;
            }

        @media (max-width: 768px) {
            .login-container {
                flex-direction: column;
                height: auto;
                width: 90%;
            }

            .login-form, .login-image {
                width: 100%;
                height: 400px;
            }

            .login-image {
                height: 200px;
            }
        }
    </style>
</head>
<body>
    <div class="login-container">
        <!-- Left Side: Login Form -->
        <div class="login-form">
            <h2 class="page-title">Login</h2>
            <form id="form1" runat="server">
                <div class="mb-3">
                    <label for="txtEmail" class="form-label">Email Address</label>
                    <asp:TextBox ID="txtEmail" runat="server" CssClass="form-control" placeholder="example@email.com" TextMode="Email"></asp:TextBox>
                </div>

                <div class="mb-3">
                    <label for="txtPassword" class="form-label">Password</label>
                    <div class="password-wrapper">
                        <asp:TextBox ID="txtPassword" runat="server" CssClass="form-control" TextMode="Password"></asp:TextBox>
                        <button type="button" class="toggle-password" onclick="togglePassword('txtPassword', this)">
                            <i class="fas fa-eye-slash"></i>
                        </button>
                    </div>
                </div>

                <asp:Button ID="btnLogin" runat="server" Text="Login" CssClass="btn btn-login" OnClick="btnLogin_Click" />

                <asp:Label ID="lblMessage" runat="server" CssClass="validation-error" Visible="false"></asp:Label>

                <div class="text-center mt-3">
                    <p>Don't have an account? <a href="Signup.aspx">Sign up here</a></p>
                </div>
            </form>
        </div>

        <!-- Right Side: Gym Boy Image -->
        <div class="login-image"></div>
    </div>

    <script>
        function togglePassword(fieldId, button) {
            const field = document.getElementById(fieldId);
            const icon = button.querySelector('i');

            if (field.type === "password") {
                field.type = "text";
                icon.classList.remove('fa-eye-slash');
                icon.classList.add('fa-eye');
            } else {
                field.type = "password";
                icon.classList.remove('fa-eye');
                icon.classList.add('fa-eye-slash');
            }
        }
    </script>
</body>
</html>
