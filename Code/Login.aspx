<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="Login.aspx.cs" Inherits="BlockTheSlot.Login" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>Login Page</title>
    <link rel="stylesheet" href="https://stackpath.bootstrapcdn.com/bootstrap/4.1.3/css/bootstrap.min.css" integrity="sha384-MCw98/SFnGE8fJT3GXwEOngsV7Zt27NXFoaoApmYm81iuXoPkFOJwJ8ERdknLPMO" crossorigin="anonymous" />
    <script src="https://ajax.googleapis.com/ajax/libs/jquery/3.3.1/jquery.min.js"></script>
    <link rel="stylesheet" href="https://use.fontawesome.com/releases/v5.6.1/css/all.css" integrity="sha384-gfdkjb5BdAXd+lj+gudLWI+BXq4IuLW5IT+brZEZsLFm++aCMlF1V92rMkPaX4PP" crossorigin="anonymous" />
    <style>
        :root {
            --input-padding-x: 1.5rem;
            --input-padding-y: .75rem;
        }

        body {
            background: #0062cc;
        }

        .card-signin {
            border: 0;
            border-radius: 1rem;
            box-shadow: 0 0.5rem 1rem 0 rgba(0, 0, 0, 0.1);
        }

            .card-signin .card-title {
                margin-bottom: 2rem;
                font-weight: 300;
                font-size: 1.5rem;
            }

            .card-signin .card-body {
                padding: 2rem;
            }

        .form-signin {
            width: 100%;
        }

            .form-signin .btn {
                font-size: 80%;
                border-radius: 5rem;
                letter-spacing: .1rem;
                font-weight: bold;
                padding: 1rem;
                transition: all 0.2s;
            }

        .form-label-group {
            position: relative;
            margin-bottom: 1rem;
        }

            .form-label-group input {
                height: auto;
                border-radius: 2rem;
            }

            .form-label-group > input,
            .form-label-group > label {
                padding: var(--input-padding-y) var(--input-padding-x);
            }

            .form-label-group > label {
                position: absolute;
                top: 0;
                left: 0;
                display: block;
                width: 100%;
                margin-bottom: 0;
                /* Override default `<label>` margin */
                line-height: 1.5;
                color: #495057;
                border: 1px solid transparent;
                border-radius: .25rem;
                transition: all .1s ease-in-out;
            }

            .form-label-group input::-webkit-input-placeholder {
                color: transparent;
            }

            .form-label-group input:-ms-input-placeholder {
                color: transparent;
            }

            .form-label-group input::-ms-input-placeholder {
                color: transparent;
            }

            .form-label-group input::-moz-placeholder {
                color: transparent;
            }

            .form-label-group input::placeholder {
                color: transparent;
            }

            .form-label-group input:not(:placeholder-shown) {
                padding-top: calc(var(--input-padding-y) + var(--input-padding-y) * (2 / 3));
                padding-bottom: calc(var(--input-padding-y) / 3);
            }

                .form-label-group input:not(:placeholder-shown) ~ label {
                    padding-top: calc(var(--input-padding-y) / 3);
                    padding-bottom: calc(var(--input-padding-y) / 3);
                    font-size: 12px;
                    color: #777;
                }

        .btn-google {
            color: white;
            background-color: #ea4335;
        }

        .btn-facebook {
            color: white;
            background-color: #3b5998;
        }
    </style>
    <script src="http://ajax.aspnetcdn.com/ajax/jQuery/jquery-1.11.1.min.js"></script>
    <script type="text/javascript">
        $(function () {
            $("[id*=btnlogin]").bind("click", function () {
                 $(".loader").show();
                var userid = $("[id*=inputEmail]").val();
                var password = $("[id*=inputPassword]").val();
                var data = { userid: userid, password: password }
                var jsonObj = JSON.stringify(data);

                $.ajax({
                    type: "POST",
                    url: "/Login.aspx/ValidateUser",
                    contentType: 'application/json; charset=utf-8',
                    datatype: 'json',
                    data: jsonObj,
                    success: function (data) {
                        var IsValidUser = data.d;
                        if (IsValidUser) {
                            $(".loader").hide();
                            window.location = "Home.aspx";
                        } else {
                            alert("Oops!!!Something went wrong! Please try after sometime!")
                        }
                    }
                });
                return false;
            });
        });
    </script>

</head>
<body>
    <div class="container">
        <div class="row">
            <div class="col-sm-9 col-md-7 col-lg-5 mx-auto">
                <div class="card card-signin my-5">
                    <div class="card-body">
                        <h5 class="card-title text-center">Sign In</h5>
                        <form class="form-signin">
                            <div class="form-label-group">
                                <input type="email" id="inputEmail" class="form-control" placeholder="Email address" required autofocus />
                                <label for="inputEmail">Email address</label>
                            </div>

                            <div class="form-label-group">
                                <input type="password" id="inputPassword" class="form-control" placeholder="Password" required />
                                <label for="inputPassword">Password</label>
                            </div>

                           
                            <button class="btn btn-lg btn-primary btn-block text-uppercase" type="submit" id="btnlogin">Sign in</button>
                            <div class="mt-4">
                                <div class="d-flex justify-content-center links">
                                    Don't have an account? <a href="Registration.aspx" class="ml-2">Sign Up</a>
                                </div>
                                
                            </div>
                        </form>
                    </div>
                </div>
            </div>
        </div>
    </div>
</body>
</html>
