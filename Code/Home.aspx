<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="Home.aspx.cs" Inherits="BlockTheSlot.Home" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <meta charset="utf-8" />
    <meta http-equiv="X-UA-Compatible" content="IE=edge" />
    <meta http-equiv="Content-Language" content="en" />
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
    <title>Home Page</title>
    <meta name="viewport" content="width=device-width, initial-scale=1, maximum-scale=1, user-scalable=no, shrink-to-fit=no" />
    <meta name="description" content="This is an example dashboard created using build-in elements and components." />
    <meta name="msapplication-tap-highlight" content="no" />
    <link href="./main.css" rel="stylesheet" />
    <script src="styles/jquery/jquery-1.10.2.min.js"></script>
    <link href="styles/bootstrap/css/bootstrap.min.css" rel="stylesheet" />
    <script src="styles/bootstrap/js/bootstrap.min.js"></script>
    <script type="text/javascript" src="https://cdnjs.cloudflare.com/ajax/libs/bootstrap-datepicker/1.4.1/js/bootstrap-datepicker.min.js"></script>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/bootstrap-datepicker/1.4.1/css/bootstrap-datepicker3.css" />
    <script src="styles/jquery/sweetalert.min.js"></script>

    <script type="text/javascript">
        $(document).ready(function () {
            LoadVenues();
            LoadOffers();


        })
        $(function () {
            $('#<%=ddlVenue.ClientID %>').attr('disabled', 'disabled');

            $('#<%=ddlVenue.ClientID %>').append('<option selected="selected" value="0">Select Venue</option>');

            $('#<%=ddlCity.ClientID %>').change(function () {
                var cityid = $('#<%=ddlCity.ClientID%>').val()
                $('#<%=ddlVenue.ClientID %>').removeAttr("disabled");

                $.ajax({
                    type: "POST",
                    url: "Home.aspx/BindVenue",
                    data: "{'cityid':'" + cityid + "'}",
                    contentType: "application/json; charset=utf-8",
                    dataType: "json",
                    success: function (msg) {
                        var j = jQuery.parseJSON(msg.d);
                        var options;
                        for (var i = 0; i < j.length; i++) {
                            options += '<option value="' + j[i].optionValue + '">' + j[i].optionDisplay + '</option>'
                        }
                        $('#<%=ddlVenue.ClientID %>').html(options)
                    },
                    error: function (data) {
                        alert('Something Went Wrong')
                    }
                });
            });

        })
        function LoadVenues() {
            $(".loader").show();
            //var cityid = $('#ddlCity :selected').text();
            //if (cityid == "Select City") {
            //    cityid = null;
            //}
            //var data = { cityid: cityid }
            //var jsonObj = JSON.stringify(data);
            $.ajax({
                type: "POST",
                url: "/Home.aspx/Get_Venue",
                contentType: 'application/json; charset=utf-8',
                datatype: 'json',
                data: {},
                success: function (data) {
                    // debugger
                    var tempresponse = JSON.parse(data.d);
                    var detail = '';
                    var response = tempresponse.Table1;
                    var params = { VENUE_ID: $('#ddlVenue').val() };
                    detail += '<thead>' +
                        '<tr style="background-color: #F08804; color: white">' +
                        '<th colspan="8" style="text-align: center; font-size: 20px;">Popular Venue</th>' +
                        '</thead>' +
                        '<tbody>';


                    //$(response).each(function (i, item) {
                    //    detail += '<tr>' +
                    //        '<td style="text-align: center">' + '<a href="#" onclick="testcall(' + JSON.stringify(params) + ')">' + (item.VENUE_NAME == null ? "" : item.VENUE_NAME) + '</a>' + '</td>' +
                    //        '</tr>';
                    //});

                    $(response).each(function (i, item) {
                        detail += '<tr>' +
                            //'<td style="text-align: center">' + (item.VENUE_NAME == null ? "" : item.VENUE_NAME) + '</td>' +
                            (item.VENUE_NAME == null || item.VENUE_NAME == 0 ? '<td style="text-align: center">' + (item.VENUE_NAME == null ? "" : item.VENUE_NAME) + '</td>' : '<td style="text-align: center"><a href="VenueSlot.aspx?venueid=' + item.VENUE_ID + '">' + (item.VENUE_NAME == null ? "" : item.VENUE_NAME) + '</a></td>') +

                            '</tr>';
                    });

                    $('#tblVenue').html(detail);
                    $(".loader").hide();
                },
                failure: function (data) {
                    swal("Oops!!!", "Something went wrong! Please try after sometime!", "error")
                },
                error: function (data) {
                    swal("Oops!!!", "Something went wrong! Please try after sometime!", "error")
                }
            });
        }

        function LoadOffers(venueid) {
            $(".loader").show();
            //var venueid = $('#ddlVenue :selected').text();
            // if (venueid == "Select Venue") {
            //     venueid = null;
            //}
            //var data = { venueid: venueid }
            //var jsonObj = JSON.stringify(data);
            $.ajax({
                type: "POST",
                url: "/Home.aspx/Get_Offers",
                contentType: 'application/json; charset=utf-8',
                datatype: 'json',
                data: {},
                success: function (data) {
                    // debugger
                    var tempresponse = JSON.parse(data.d);
                    var detail = '';
                    var response = tempresponse.Table1;

                    detail += '<thead>' +
                        '<tr style="background-color: #F08804; color: white">' +
                        '<th colspan="8" style="text-align: center; font-size: 20px;">Popular Offers</th>' +
                        '</thead>' +
                        '<tbody>';


                    $(response).each(function (i, item) {
                        detail += '<tr>' +
                            '<td style="text-align: center">' + (item.OFFER_DESSCRIPTION == null ? "" : item.OFFER_DESSCRIPTION) + '</td>' +

                            '</tr>';
                    });


                    $('#tblOffers').html(detail);
                    $(".loader").hide();
                },
                failure: function (data) {
                    swal("Oops!!!", "Something went wrong! Please try after sometime!", "error")
                },
                error: function (data) {
                    swal("Oops!!!", "Something went wrong! Please try after sometime!", "error")
                }
            });
        }

        function testcall(VENUE_ID) {
            var url = "VenueSlot.aspx?VenuId=" + encodeURIComponent(VENUE_ID);
            window.location.href = url;
        }


    </script>
    <script>
        window.watsonAssistantChatOptions = {
            integrationID: "5619156a-b5f1-4394-86aa-4f2fbc7d6e41", // The ID of this integration.
            region: "eu-gb", // The region your integration is hosted in.
            serviceInstanceID: "0d95dba8-ae47-45ef-a57a-19aedbde6a77", // The ID of your service instance.
            onLoad: function (instance) { instance.render(); }
        };
        setTimeout(function () {
            const t = document.createElement('script');
            t.src = "https://web-chat.global.assistant.watson.appdomain.cloud/loadWatsonAssistantChat.js";
            document.head.appendChild(t);
        });
    </script>
</head>
<body>
    <form id="form1" runat="server">
        <div class="app-container app-theme-white body-tabs-shadow fixed-sidebar fixed-header">
            <div class="app-header header-shadow">
                <div class="app-header__logo">
                    <div class="logo-src"></div>
                    <div class="header__pane ml-auto">
                        <div>
                            <button type="button" class="hamburger close-sidebar-btn hamburger--elastic" data-class="closed-sidebar">
                                <span class="hamburger-box">
                                    <span class="hamburger-inner"></span>
                                </span>
                            </button>
                        </div>
                    </div>
                </div>
                <div class="app-header__mobile-menu">
                    <div>
                        <button type="button" class="hamburger hamburger--elastic mobile-toggle-nav">
                            <span class="hamburger-box">
                                <span class="hamburger-inner"></span>
                            </span>
                        </button>
                    </div>
                </div>
                <div class="app-header__menu">
                    <span>
                        <button type="button" class="btn-icon btn-icon-only btn btn-primary btn-sm mobile-toggle-header-nav">
                            <span class="btn-icon-wrapper">
                                <i class="fa fa-ellipsis-v fa-w-6"></i>
                            </span>
                        </button>
                    </span>
                </div>
                <div class="app-header__content">
                    <div class="app-header-left">
                        <div class="search-wrapper">
                            <div class="input-holder">
                                <input type="text" class="search-input" placeholder="Type to search">
                                <button class="search-icon"><span></span></button>
                            </div>
                            <button class="close"></button>
                        </div>
                        <!--<ul class="header-menu nav">
                        <li class="nav-item">
                            <a href="javascript:void(0);" class="nav-link">
                                <i class="nav-link-icon fa fa-database"> </i>
                                Statistics
                            </a>
                        </li>
                        <li class="btn-group nav-item">
                            <a href="javascript:void(0);" class="nav-link">
                                <i class="nav-link-icon fa fa-edit"></i>
                                Projects
                            </a>
                        </li>
                        <li class="dropdown nav-item">
                            <a href="javascript:void(0);" class="nav-link">
                                <i class="nav-link-icon fa fa-cog"></i>
                                Settings
                            </a>
                        </li>
                    </ul>-->
                    </div>
                    <div class="app-header-right">
                        <div class="header-btn-lg pr-0">
                            <div class="widget-content p-0">
                                <div class="widget-content-wrapper">
                                    <div class="widget-content-left">
                                        <div class="btn-group">
                                            <a data-toggle="dropdown" aria-haspopup="true" aria-expanded="false" class="p-0 btn">
                                                <img width="42" class="rounded-circle" src="assets/images/avatars/1.jpg" alt="">
                                                <i class="fa fa-angle-down ml-2 opacity-8"></i>
                                            </a>
                                            <div tabindex="-1" role="menu" aria-hidden="true" class="dropdown-menu dropdown-menu-right">
                                                <button type="button" tabindex="0" class="dropdown-item">User Account</button>
                                                <button type="button" tabindex="0" class="dropdown-item">Settings</button>
                                                <h6 tabindex="-1" class="dropdown-header">Header</h6>
                                                <button type="button" tabindex="0" class="dropdown-item">Actions</button>
                                                <div tabindex="-1" class="dropdown-divider"></div>
                                                <button type="button" tabindex="0" class="dropdown-item">Dividers</button>
                                            </div>
                                        </div>
                                    </div>
                                    <div class="widget-content-left  ml-3 header-user-info">
                                        <div class="widget-heading">
                                            Ankita Khare
                                        </div>
                                    </div>
                                    <div class="widget-content-right header-user-info ml-3">
                                        <button type="button" data-toggle="dropdown" aria-haspopup="true" aria-expanded="false" class="btn-shadow dropdown-toggle btn btn-info">
                                            <span class="btn-icon-wrapper pr-2 opacity-7">
                                                <i class="fa fa-business-time fa-w-20"></i>
                                            </span>

                                        </button>
                                        <div tabindex="-1" role="menu" aria-hidden="true" class="dropdown-menu dropdown-menu-right">
                                            <ul class="nav flex-column">
                                                <li class="nav-item">
                                                    <a href="javascript:void(0);" class="nav-link">
                                                        <i class="nav-link-icon lnr-inbox"></i>
                                                        <span>Inbox
                                                        </span>
                                                        <div class="ml-auto badge badge-pill badge-secondary">86</div>
                                                    </a>
                                                </li>
                                                <li class="nav-item">
                                                    <a href="javascript:void(0);" class="nav-link">
                                                        <i class="nav-link-icon lnr-book"></i>
                                                        <span>Book
                                                        </span>
                                                        <div class="ml-auto badge badge-pill badge-danger">5</div>
                                                    </a>
                                                </li>
                                                <li class="nav-item">
                                                    <a href="javascript:void(0);" class="nav-link">
                                                        <i class="nav-link-icon lnr-picture"></i>
                                                        <span>Picture
                                                        </span>
                                                    </a>
                                                </li>
                                                <li class="nav-item">
                                                    <a disabled href="javascript:void(0);" class="nav-link disabled">
                                                        <i class="nav-link-icon lnr-file-empty"></i>
                                                        <span>File Disabled
                                                        </span>
                                                    </a>
                                                </li>
                                            </ul>
                                        </div>

                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
            <div class="app-main">
                <div class="app-sidebar sidebar-shadow">
                    <div class="app-header__logo">
                        <div class="logo-src"></div>
                        <div class="header__pane ml-auto">
                            <div>
                                <button type="button" class="hamburger close-sidebar-btn hamburger--elastic" data-class="closed-sidebar">
                                    <span class="hamburger-box">
                                        <span class="hamburger-inner"></span>
                                    </span>
                                </button>
                            </div>
                        </div>
                    </div>
                    <div class="app-header__mobile-menu">
                        <div>
                            <button type="button" class="hamburger hamburger--elastic mobile-toggle-nav">
                                <span class="hamburger-box">
                                    <span class="hamburger-inner"></span>
                                </span>
                            </button>
                        </div>
                    </div>
                    <div class="app-header__menu">
                        <span>
                            <button type="button" class="btn-icon btn-icon-only btn btn-primary btn-sm mobile-toggle-header-nav">
                                <span class="btn-icon-wrapper">
                                    <i class="fa fa-ellipsis-v fa-w-6"></i>
                                </span>
                            </button>
                        </span>
                    </div>
                    <div class="scrollbar-sidebar">
                        <div class="app-sidebar__inner">
                            <ul class="vertical-nav-menu">
                                <li class="app-sidebar__heading">Dashboards</li>
                                <li>
                                    <a href="Home.aspx" class="mm-active">
                                        <i class="metismenu-icon pe-7s-rocket"></i>
                                        Dashboard
                                    </a>
                                </li>
                                <li class="app-sidebar__heading">Venue Slot</li>
                                <li>
                                    <a href="VenueSlot.aspx">
                                        <i class="metismenu-icon pe-7s-diamond"></i>
                                        Venue Slot Details
                                    <i class="metismenu-state-icon pe-7s-angle-down caret-left"></i>
                                    </a>
                                </li>
                                

                            </ul>
                        </div>
                    </div>
                </div>
                <div class="app-main__outer">
                    <div class="app-main__inner">
                        <div class="main-card mb-3 card">
                            <div class="card-body">
                                <h5 class="card-title">Grid Rows</h5>
                                <form class="">

                                    <div class="form-row">
                                        <div class="col-md-6">
                                            <div class="position-relative form-group">
                                                <label for="exampleSelect" class="">City</label>
                                                <asp:DropDownList ID="ddlCity" runat="server" class="form-control"></asp:DropDownList>


                                            </div>
                                        </div>
                                        <div class="col-md-6">
                                            <div class="position-relative form-group">
                                                <div class="position-relative form-group">
                                                    <label for="exampleSelect" class="">Venue</label>
                                                    <asp:DropDownList ID="ddlVenue" runat="server" class="form-control"></asp:DropDownList>
                                                </div>
                                            </div>
                                        </div>
                                    </div>
                                    <div class="form-row">
                                        <div class="col-md-6">
                                            <div class="main-card mb-3 card">
                                                <div class="card-body">
                                                    <h5 class="card-title">Popular Venue</h5>


                                                    <table id="tblVenue" class="table table-striped table-bordered table-sm" style="width: 100%">
                                                    </table>

                                                </div>
                                            </div>
                                        </div>
                                        <div class="col-md-6">
                                            <div class="main-card mb-3 card">
                                                <div class="card-body">
                                                    <h5 class="card-title">Popular Offer</h5>

                                                    <table id="tblOffers" class="table table-striped table-bordered table-sm" style="width: 100%">
                                                    </table>

                                                </div>
                                            </div>
                                        </div>
                                    </div>
                                </form>
                            </div>
                        </div>

                    </div>
                    <div class="app-wrapper-footer">
                        <div class="app-footer">
                            <div class="app-footer__inner">
                                <div class="app-footer-left">
                                    <ul class="nav">
                                        <li class="nav-item">
                                            <a href="javascript:void(0);" class="nav-link">Footer Link 1
                                            </a>
                                        </li>
                                        <li class="nav-item">
                                            <a href="javascript:void(0);" class="nav-link">Footer Link 2
                                            </a>
                                        </li>
                                    </ul>
                                </div>
                                <div class="app-footer-right">
                                    <ul class="nav">
                                        <li class="nav-item">
                                            <a href="javascript:void(0);" class="nav-link">Footer Link 3
                                            </a>
                                        </li>
                                        <li class="nav-item">
                                            <a href="javascript:void(0);" class="nav-link">
                                                <div class="badge badge-success mr-1 ml-0">
                                                    <small>NEW</small>
                                                </div>
                                                Footer Link 4
                                            </a>
                                        </li>
                                    </ul>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
                <script src="http://maps.google.com/maps/api/js?sensor=true"></script>
            </div>
        </div>
        <script type="text/javascript" src="./assets/scripts/main.js"></script>
    </form>
</body>
</html>
