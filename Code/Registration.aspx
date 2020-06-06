<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="Registration.aspx.cs" Inherits="BlockTheSlot.Registration" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>Registration Page</title>

    <script src="styles/jquery/jquery-1.10.2.min.js"></script>
    <link href="styles/bootstrap/css/bootstrap.min.css" rel="stylesheet" />
    <script src="styles/bootstrap/js/bootstrap.min.js"></script>
    <script type="text/javascript" src="https://cdnjs.cloudflare.com/ajax/libs/bootstrap-datepicker/1.4.1/js/bootstrap-datepicker.min.js"></script>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/bootstrap-datepicker/1.4.1/css/bootstrap-datepicker3.css" />
    <script src="styles/jquery/sweetalert.min.js"></script>
    <style>
        .register {
            background: -webkit-linear-gradient(left, #3931af, #00c6ff);
            margin-top: 3%;
            padding: 3%;
        }

        .register-left {
            text-align: center;
            color: #fff;
            margin-top: 4%;
        }

            .register-left input {
                border: none;
                border-radius: 1.5rem;
                padding: 2%;
                width: 60%;
                background: #f8f9fa;
                font-weight: bold;
                color: #383d41;
                margin-top: 30%;
                margin-bottom: 3%;
                cursor: pointer;
            }

        .register-right {
            background: #f8f9fa;
            border-top-left-radius: 10% 50%;
            border-bottom-left-radius: 10% 50%;
        }

        .register-left img {
            margin-top: 15%;
            margin-bottom: 5%;
            width: 25%;
            -webkit-animation: mover 2s infinite alternate;
            animation: mover 1s infinite alternate;
        }

        @-webkit-keyframes mover {
            0% {
                transform: translateY(0);
            }

            100% {
                transform: translateY(-20px);
            }
        }

        @keyframes mover {
            0% {
                transform: translateY(0);
            }

            100% {
                transform: translateY(-20px);
            }
        }

        .register-left p {
            font-weight: lighter;
            padding: 12%;
            margin-top: -9%;
        }

        .register .register-form {
            padding: 10%;
            margin-top: 10%;
        }

        .btnRegister {
            float: right;
            margin-top: 10%;
            border: none;
            border-radius: 1.5rem;
            padding: 2%;
            background: #0062cc;
            color: #fff;
            font-weight: 600;
            width: 50%;
            cursor: pointer;
        }

        .register .nav-tabs {
            margin-top: 3%;
            border: none;
            background: #0062cc;
            border-radius: 1.5rem;
            width: 28%;
            float: right;
        }

            .register .nav-tabs .nav-link {
                padding: 2%;
                height: 34px;
                font-weight: 600;
                color: #fff;
                border-top-right-radius: 1.5rem;
                border-bottom-right-radius: 1.5rem;
            }

                .register .nav-tabs .nav-link:hover {
                    border: none;
                }

                .register .nav-tabs .nav-link.active {
                    width: 100px;
                    color: #0062cc;
                    border: 2px solid #0062cc;
                    border-top-left-radius: 1.5rem;
                    border-bottom-left-radius: 1.5rem;
                }

        .register-heading {
            text-align: center;
            margin-top: 8%;
            margin-bottom: -15%;
            color: #495057;
        }
    </style>
    <%-- <script src="http://ajax.aspnetcdn.com/ajax/jQuery/jquery-1.11.1.min.js"></script>--%>
    <script type="text/javascript">
        $(function () {
            $('#btnSaveReassign').on('click', function () {

                //if ($("#ddlstatus").val() == "" || $("#ddlstatus").val() == null) {
                //    swal("Please select a Status");
                //    return false;
                //}
                //if ($("#inputPassword").val() != $("#inputConfirmPassword").val()) {
                //    alert("Your password is not matched");
                //    return false;
                //}
                $(".loader").show();
                var firstname = $('#inputFirstName').val();
                var lastname = $('#inputLastName').val();
                var email = $('#inputEmail').val();
                var password = $('#inputPassword').val();
                var secquestion = $('#ddlQuestion').val();
                var secanswer = $('#inputAnswer').val();
                var mobileno = $('#inputMobileNo').val();


                var data = { data3: firstname + '|' + lastname + '|' + email + '|' + password + '|' + mobileno + '|' + secquestion + '|' + secanswer }

                var jsonObj = JSON.stringify(data);
                $.ajax({
                    type: "POST",
                    url: "/Registration.aspx/Save_User_Registration",
                    contentType: 'application/json; charset=utf-8',
                    datatype: 'json',
                    data: jsonObj,
                    success: function (data) {
                        var response = JSON.parse(data.d);
                        $(".loader").hide();
                        alert("Success! Registration is done successfully!");
                        var url = "Login.aspx";
                        $(location).attr('href',url);
                    },

                    failure: function (data) {
                        alert("Oops!!!Something went wrong! Please try after sometime!")
                    },
                    error: function (data) {
                        alert("Oops!!!", "Something went wrong! Please try after sometime!")
                    }
                })

            });
        });
    </script>
</head>
<body>
    <div class="container register">
        <div class="row">
            <div class="col-md-3 register-left">
                <img src="https://image.ibb.co/n7oTvU/logo_white.png" alt="" />
                <h3>Welcome</h3>
                <p>You are 30 seconds away from earning your own money!</p>

                <a href="Login.aspx" class="mm-active">Login
                </a>
            </div>
            <div class="col-md-9 register-right">
                <ul class="nav nav-tabs nav-justified" id="myTab" role="tablist">
                    <li class="nav-item">
                        <a class="nav-link active" id="home-tab" data-toggle="tab" href="#home" role="tab" aria-controls="home" aria-selected="true">Customer</a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link" id="profile-tab" data-toggle="tab" href="#profile" role="tab" aria-controls="profile" aria-selected="false">Store Manager</a>
                    </li>
                </ul>
                <div class="tab-content" id="myTabContent">
                    <div class="tab-pane fade show active" id="home" role="tabpanel" aria-labelledby="home-tab">
                        <h3 class="register-heading">Apply as a Customer</h3>
                        <div class="row register-form">
                            <div class="col-md-6">
                                <div class="form-group">
                                    <input type="text" class="form-control" placeholder="First Name *" value="" id="inputFirstName" />
                                </div>
                                <div class="form-group">
                                    <input type="text" class="form-control" placeholder="Last Name *" value="" id="inputLastName" />
                                </div>
                                <div class="form-group">
                                    <input type="password" class="form-control" placeholder="Password *" value="" id="inputPassword" />
                                </div>
                                <div class="form-group">
                                    <input type="password" class="form-control" placeholder="Confirm Password *" value="" id="inputConfirmPassword" />
                                </div>

                            </div>
                            <div class="col-md-6">
                                <div class="form-group">
                                    <input type="email" class="form-control" placeholder="Your Email *" value="" id="inputEmail" />
                                </div>
                                <div class="form-group">
                                    <input type="text" minlength="10" maxlength="10" name="txtEmpPhone" class="form-control" placeholder="Your Phone *" value="" id="inputMobileNo" />
                                </div>
                                <div class="form-group">
                                    <select class="form-control" id="ddlQuestion">
                                        <option class="hidden" selected disabled>Please select your Security Question</option>
                                        <option>What is your Birthdate?</option>
                                        <option>What is Your old Phone Number</option>
                                        <option>What is your Pet Name?</option>
                                    </select>
                                </div>
                                <div class="form-group">
                                    <input type="text" class="form-control" placeholder="Enter Your Answer *" value="" id="inputAnswer" />
                                </div>

                                <button type="button" class="btnRegister" id="btnSaveReassign">Register</button>
                            </div>
                        </div>
                    </div>
                    <div class="tab-pane fade show" id="profile" role="tabpanel" aria-labelledby="profile-tab">
                        <h3 class="register-heading">Apply as a Hirer</h3>
                        <div class="row register-form">
                            <div class="col-md-6">
                                <div class="form-group">
                                    <input type="text" class="form-control" placeholder="First Name *" value="" />
                                </div>
                                <div class="form-group">
                                    <input type="text" class="form-control" placeholder="Last Name *" value="" />
                                </div>
                                <div class="form-group">
                                    <input type="email" class="form-control" placeholder="Email *" value="" />
                                </div>
                                <div class="form-group">
                                    <input type="text" maxlength="10" minlength="10" class="form-control" placeholder="Phone *" value="" />
                                </div>


                            </div>
                            <div class="col-md-6">
                                <div class="form-group">
                                    <input type="password" class="form-control" placeholder="Password *" value="" />
                                </div>
                                <div class="form-group">
                                    <input type="password" class="form-control" placeholder="Confirm Password *" value="" />
                                </div>
                                <div class="form-group">
                                    <select class="form-control">
                                        <option class="hidden" selected disabled>Please select your Sequrity Question</option>
                                        <option>What is your Birthdate?</option>
                                        <option>What is Your old Phone Number</option>
                                        <option>What is your Pet Name?</option>
                                    </select>
                                </div>
                                <div class="form-group">
                                    <input type="text" class="form-control" placeholder="`Answer *" value="" />
                                </div>
                                <input type="submit" class="btnRegister" value="Register" />
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>

    </div>
</body>
</html>
