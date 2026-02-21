<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="Signup.aspx.cs" Inherits="OnlineGymStore.Pages.User.Signup" %>

<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>GymShop - Sign Up</title>
    <meta name="viewport" content="width=device-width, initial-scale=1" />
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet" />
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" />
    <style>
        @import url('https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700&display=swap');

        body {
            background-color: #ffffff;
            font-family: 'Inter', sans-serif;
            display: flex;
            align-items: center;
            justify-content: center;
            min-height: 100vh;
            margin: 0;
            color: #1a1a1a;
        }

        .signup-container {
            width: 100%;
            max-width: 420px;
            background: #ffffff;
            padding: 40px 30px;
            border-radius: 0;
            box-shadow: none;
            border: 1px solid #e0e0e0;
        }

        .page-title {
            font-size: 28px;
            font-weight: 600;
            text-align: center;
            color: #000000;
            margin-bottom: 30px;
            letter-spacing: -0.5px;
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

        .btn-signup {
            background-color: #000;
            color: white;
            border: none;
            width: 100%;
            padding: 14px;
            font-size: 15px;
            font-weight: 500;
            border-radius: 4px;
            transition: all 0.2s ease;
            letter-spacing: 0.5px;
            text-transform: uppercase;
            margin-top: 10px;
        }

            .btn-signup:hover {
                background-color: dimgray;
                color: white;
                transform: translateY(-1px);
            }

            .btn-signup:active {
                transform: translateY(0);
            }

        .success-message, .validation-error {
            font-size: 14px;
            text-align: center;
            margin-top: 15px;
            padding: 10px;
            border-radius: 4px;
        }

        .success-message {
            color: #000;
            background-color: #f0f0f0;
            border: 1px solid #e0e0e0;
        }

        .validation-error {
            color: #d32f2f;
            background-color: #fde8e8;
            border: 1px solid #f5c6cb;
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

        /* Password toggle styles */
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

        /* Responsive adjustments */
        @media (max-width: 480px) {
            .signup-container {
                padding: 30px 20px;
                border: none;
            }

            body {
                padding: 20px;
                background: #fff;
            }
        }
    </style>
</head>
<body>
    <div class="signup-container">
        <h2 class="page-title">Sign Up</h2>
        <form id="form1" runat="server" onsubmit="return validateForm()">
            <div class="mb-3">
                <label for="txtFullName" class="form-label">Full Name</label>
                <asp:TextBox ID="txtFullName" runat="server" CssClass="form-control" placeholder="John Doe" onblur="validateName()"></asp:TextBox>
                <small id="nameError" class="text-danger" style="display: none;">Name must be at least 2 characters</small>
            </div>

            <div class="mb-3">
                <label for="txtEmail" class="form-label">Email Address</label>
                <asp:TextBox ID="txtEmail" runat="server" CssClass="form-control" placeholder="example@email.com" TextMode="Email" onblur="validateEmail()"></asp:TextBox>
                <small id="emailError" class="text-danger" style="display: none;">Please enter a valid email</small>
            </div>

            <div class="mb-3">
                <label for="txtPassword" class="form-label">Password</label>
                <div class="password-wrapper">
                    <asp:TextBox ID="txtPassword" runat="server" CssClass="form-control" TextMode="Password" onblur="validatePassword()"></asp:TextBox>
                    <button type="button" class="toggle-password" onclick="togglePassword('txtPassword', this)">
                        <i class="fas fa-eye-slash"></i>
                    </button>
                </div>
                <small id="passwordError" class="text-danger" style="display: none;">Password must be at least 6 characters</small>
            </div>

            <div class="mb-3">
                <label for="txtConfirmPassword" class="form-label">Confirm Password</label>
                <div class="password-wrapper">
                    <asp:TextBox ID="txtConfirmPassword" runat="server" CssClass="form-control" TextMode="Password" onblur="validateConfirmPassword()"></asp:TextBox>
                    <button type="button" class="toggle-password" onclick="togglePassword('txtConfirmPassword', this)">
                        <i class="fas fa-eye-slash"></i>
                    </button>
                </div>
                <small id="confirmPasswordError" class="text-danger" style="display: none;">Passwords don't match</small>
            </div>

            <asp:Button ID="btnSignup" runat="server" Text="Sign Up" CssClass="btn btn-signup" OnClick="btnSignup_Click" />

            <asp:Label ID="lblMessage" runat="server" CssClass="success-message" Visible="false"></asp:Label>

            <div class="text-center mt-3">
                <p>Already have an account? <a href="Login.aspx">Login here</a></p>
            </div>
        </form>
    </div>

    <script>
        // Password toggle function
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

        // Client-side validation functions
        function validateName() {
            const name = document.getElementById('txtFullName').value;
            const errorElement = document.getElementById('nameError');
            if (name.length < 2) {
                errorElement.style.display = 'block';
                return false;
            }
            errorElement.style.display = 'none';
            return true;
        }

        function validateEmail() {
            const email = document.getElementById('txtEmail').value;
            const errorElement = document.getElementById('emailError');
            const emailRegex = /^[^@\s]+@[^@\s]+\.[^@\s]+$/;
            if (!emailRegex.test(email)) {
                errorElement.style.display = 'block';
                return false;
            }
            errorElement.style.display = 'none';
            return true;
        }

        function validatePassword() {
            const password = document.getElementById('txtPassword').value;
            const errorElement = document.getElementById('passwordError');
            if (password.length < 6) {
                errorElement.style.display = 'block';
                return false;
            }
            errorElement.style.display = 'none';
            return true;
        }

        function validateConfirmPassword() {
            const password = document.getElementById('txtPassword').value;
            const confirmPassword = document.getElementById('txtConfirmPassword').value;
            const errorElement = document.getElementById('confirmPasswordError');
            if (password !== confirmPassword) {
                errorElement.style.display = 'block';
                return false;
            }
            errorElement.style.display = 'none';
            return true;
        }

        function validateForm() {
            const isNameValid = validateName();
            const isEmailValid = validateEmail();
            const isPasswordValid = validatePassword();
            const isConfirmValid = validateConfirmPassword();

            return isNameValid && isEmailValid && isPasswordValid && isConfirmValid;
        }
    </script>
</body>
</html>
