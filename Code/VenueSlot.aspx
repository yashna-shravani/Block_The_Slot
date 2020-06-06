<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="VenueSlot.aspx.cs" Inherits="BlockTheSlot.VenueSlot" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <meta charset="utf-8" />
    <meta http-equiv="X-UA-Compatible" content="IE=edge" />
    <meta http-equiv="Content-Language" content="en" />
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
    <title>Venue Slot</title>
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
    <script type="text/javascript" src="https://cdnjs.cloudflare.com/ajax/libs/bootstrap-datepicker/1.4.1/js/bootstrap-datepicker.min.js"></script>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/bootstrap-datepicker/1.4.1/css/bootstrap-datepicker3.css" />
    <script>
        $(document).ready(function () {
            var date_input = $('input[name="date"]'); //our date input has the name "date"
            var container = $('.bootstrap-iso form').length > 0 ? $('.bootstrap-iso form').parent() : "body";
            date_input.datepicker({
                format: 'mm/dd/yyyy',
                container: container,
                todayHighlight: true,
                autoclose: true,
            })
        })
    </script>
    <script type="text/javascript">
        $(document).ready(function () {
            LoadSlotDetails();
            // LoadOffers();


        })
        $(function () {
            $('#<%=ddlStore.ClientID %>').attr('disabled', 'disabled');

            $('#<%=ddlStore.ClientID %>').append('<option selected="selected" value="0">Select Store</option>');

            $('#<%=ddlCategory.ClientID %>').change(function () {
                var categoryid = $('#<%=ddlCategory.ClientID%>').val()
                $('#<%=ddlStore.ClientID %>').removeAttr("disabled");
                var venueid = 6;
                var url = window.location.href.slice(window.location.href.indexOf('?') + 1).split('&');
                for (var i = 0; i < url.length; i++) {
                    urlparam = url[i].split('=');
                    if (urlparam[0] == 'venueid') {
                        venueid = urlparam[1];
                    }
                }


                $.ajax({
                    type: "POST",
                    url: "VenueSlot.aspx/BindStore",
                    data: "{'categoryid':'" + categoryid + "','venueid':'" + venueid + "'}",
                    contentType: "application/json; charset=utf-8",
                    dataType: "json",
                    success: function (msg) {
                        var j = jQuery.parseJSON(msg.d);
                        var options;
                        for (var i = 0; i < j.length; i++) {
                            options += '<option value="' + j[i].optionValue + '">' + j[i].optionDisplay + '</option>'
                        }
                        $('#<%=ddlStore.ClientID %>').html(options)
                    },
                    error: function (data) {
                        alert('Something Went Wrong')
                    }
                });
            });

        })
        function LoadSlotDetails() {
            $(".loader").show();
            var venueid = 6;
            var url = window.location.href.slice(window.location.href.indexOf('?') + 1).split('&');
            for (var i = 0; i < url.length; i++) {
                urlparam = url[i].split('=');
                if (urlparam[0] == 'venueid') {
                    venueid = urlparam[1];
                }

            }
            var data = { venueid: venueid }
            var jsonObj = JSON.stringify(data);
            $.ajax({
                type: "POST",
                url: "/VenueSlot.aspx/BindSlotDetails",
                contentType: 'application/json; charset=utf-8',
                datatype: 'json',
                data: jsonObj,
                success: function (data) {
                    var tempresponse = JSON.parse(data.d);
                    var detail = '';
                    var response = tempresponse.Table1;
                    var totalvolume = 0;

                    $(response).each(function (i, item) {
                        //var slotdate = $('#inslotdate').val();
                        var slotdate = '06/06/2020';
                        //var slottime = $('#ddlSlotTiming :selected').text();
                        //var SlotDetails = { data3: item.Venue_Name + '|' + item.STORE_NAME + '|' + item.CATEGORY_NAME + '|' + slotdate + '|' + item.slot_timing }
                        $('#lblVenue').text(item.Venue_Name);
                        $('#lblStore').text(item.STORE_NAME);
                        $('#lblCategory').text(item.CATEGORY_NAME);
                        $('#lblSlotDate').text(slotdate);
                        $('#lblSlot').text(item.slot_timing);
                        detail += '<tr>' +
                            '<td style="text-align: center">' + (item.STORE_ID == null ? "" : item.STORE_ID) + '</td>' +
                            '<td style="text-align: center">' + (item.STORE_NAME == null ? "" : item.STORE_NAME) + '</td>' +
                            '<td style="text-align: center">' + (item.Venue_Name == null ? "" : item.Venue_Name) + '</td>' +
                            '<td style="text-align: center">' + (item.CATEGORY_NAME == null ? "" : item.CATEGORY_NAME) + '</td>' +
                            '<td style="text-align: center">' + (item.slot_timing == null ? "" : item.slot_timing) + '</td>' +
                            '<td style="text-align: center">' + (item.RemainingCapacity == null ? "" : item.RemainingCapacity) + '</td>' +
                            '<td class="cell-which-triggers-popup"><a href="#" data-toggle="modal" data-target=".bd-example-modal-lg" onclick="return getbyID()">Slot Booking</a></td>' +
                            '</tr>';

                    });
                    var header = '<thead>' +
                        '<tr>' +
                        //'<th colspan="7" style="text-align: left; font-size: 14px;">Total Count : ' + totalvolume + '</th>' +
                        // '<tr style="background-color: #F08804; color: white">' +
                        //'<th colspan="7" style="text-align: center; font-size: 20px;">Service Now Cases</th>' +
                        '<tr style="background-color: #F08804; color: white">' +
                        '<th style="text-align: center">STORE_ID</th>' +
                        '<th style="text-align: center">Store Name</th>' +
                        '<th style="text-align: center">Venue Name</th>' +
                        '<th style="text-align: center">Category Name</th>' +
                        '<th style="text-align: center">Slot Timing</th>' +
                        '<th style="text-align: center">Remaining Capacity</th>' +
                        '<th style="text-align: center">Action</th>' +
                        '</tr>' +
                        '</thead>' +
                        '<tbody>';
                    detail = header + detail;
                    $('#tblSlotDetails').html(detail);
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

        //function getbyID(SlotDetails) {
        //    var venue_name = SlotDetails.Split('|')[0].ToString();
        //    var store_name = SlotDetails.Split('|')[1].ToString();
        //    var category_name = SlotDetails.Split('|')[2].ToString();
        //    var slotdate = SlotDetails.Split('|')[3].ToString();
        //    var slottime = SlotDetails.Split('|')[4].ToString();

        //    $('#lblVenue').text(venue_name);
        //    $('#lblStore').text(store_name);
        //    $('#lblCategory').text(category_name);
        //    $('#lblSlot').text(slotdate);
        //    $('#lblNoofPeople').text(slottime);
        //}

         $(function () {
            $('#btnResendRph').on('click', function () {
                var venue_name = lblVenue.innerHTML;
                var store_name = lblStore.innerHTML;
                var category_name = lblCategory.innerHTML;
                var slotdate = '06/06/2020';
                var slot = lblSlot.innerHTML;
               var noofpeople = $("#lblNoofPeople").val();
               
                 var data = { data3: venue_name + '|' + store_name + '|' + category_name + '|' + slotdate + '|' + slot + '|' + noofpeople  }
                //var data = { venue_name: venue_name, store_name: store_name, slotdate: slotdate ,category_name:category_name,slot:slot,noofpeople:noofpeople}
                var jsonObj = JSON.stringify(data);
                $.ajax({
                    type: "POST",
                    url: "/VenueSlot.aspx/BookSlot",
                    contentType: 'application/json; charset=utf-8',
                    datatype: 'json',
                    data: jsonObj,
                    success: function (data) {
                        $(".loader").hide();
                        alert("Success! Slot Booking is done successfully!", "success");
                    },

                    failure: function (data) {
                        alert("Oops!!! Something went wrong! Please try after sometime!", "error")
                    },
                    error: function (data) {
                        alert("Oops!!! Something went wrong! Please try after sometime!", "error")
                    }
                })

            });
        });
          function getbyID(slottime) {
              //alert('hii');
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
                                        <div class="col-md-3">
                                            <div class="position-relative form-group">
                                                <label for="exampleSelect" class="">Category</label>
                                                <asp:DropDownList ID="ddlCategory" runat="server" class="form-control"></asp:DropDownList>


                                            </div>
                                        </div>
                                        <div class="col-md-3">
                                            <div class="position-relative form-group">
                                                <label for="exampleSelect" class="">Store</label>
                                                <asp:DropDownList ID="ddlStore" runat="server" class="form-control"></asp:DropDownList>


                                            </div>
                                        </div>
                                        <div class="col-md-3">
                                            <div class="position-relative form-group">
                                                <label for="exampleSelect" class="">Slot Day</label>
                                                <input class="form-control" id="inslotdate" name="date" placeholder="MM/DD/YYY" type="text" />


                                            </div>
                                        </div>
                                        <div class="col-md-3">
                                            <div class="position-relative form-group">
                                                <div class="position-relative form-group">
                                                    <label for="exampleSelect" class="">Slot Timing</label>
                                                    <asp:DropDownList ID="ddlSlotTiming" runat="server" class="form-control"></asp:DropDownList>
                                                </div>
                                            </div>
                                        </div>

                                    </div>
                                </form>
                            </div>
                        </div>

                        <div class="row">
                            <div class="col-md-12">
                                <div class="main-card mb-3 card">
                                    <div class="card-header">
                                        Slot Details
                                                <asp:Label ID="Label1" runat="server" Text="Label" Visible="false"></asp:Label>
                                    </div>
                                    <div class="table-responsive">
                                        <table class="align-middle mb-0 table table-borderless table-striped table-hover" id="tblSlotDetails">
                                        </table>
                                    </div>

                                </div>
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
        <div class="modal fade bd-example-modal-lg" tabindex="-1" role="dialog" aria-labelledby="myLargeModalLabel" aria-hidden="true">
            <div class="modal-dialog modal-lg">
                <div class="modal-content">
                    <div class="modal-header">
                        <h5 class="modal-title" id="exampleModalLongTitle">Slot Booking</h5>
                        <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                            <span aria-hidden="true">&times;</span>
                        </button>
                    </div>
                    <div class="modal-body">
                        <form class="">
                            <div class="form-row">
                                <div class="col-md-6">
                                    <div class="position-relative form-group">
                                        <label for="exampleSelect" class="">Venue</label>
                                        <label class="form-control" id="lblVenue"></label>


                                    </div>
                                </div>
                                <div class="col-md-6">
                                    <div class="position-relative form-group">
                                        <label for="exampleSelect" class="">Category</label>
                                        <label class="form-control" id="lblCategory"></label>


                                    </div>
                                </div>


                            </div>
                            <div class="form-row">
                                <div class="col-md-6">
                                    <div class="position-relative form-group">
                                        <label for="exampleSelect" class="">Store</label>
                                        <label class="form-control" id="lblStore"></label>
                                    </div>
                                </div>
                                <div class="col-md-6">
                                    <div class="position-relative form-group">
                                        <label for="exampleSelect" class="">Slot Date</label>
                                        <label class="form-control" id="lblSlotDate"></label>


                                    </div>
                                </div>



                            </div>
                            <div class="form-row">
                                <div class="col-md-6">
                                    <div class="position-relative form-group">
                                        <label for="exampleSelect" class="">Choosen Slot</label>
                                        <label class="form-control" id="lblSlot"></label>


                                    </div>
                                </div>
                                <div class="col-md-6">
                                    <div class="position-relative form-group">
                                        <label for="exampleSelect" class="">No of People</label>
                                        <input class="form-control" id="lblNoofPeople" name="noofpeople"  type="text" />
                                    </div>
                                </div>




                            </div>
                            <div class="modal-footer">
                                <button type="button" class="btn btn-secondary" data-dismiss="modal">Close</button>
                                <button type="button" class="btn btn-primary" id="btnResendRph">Save changes</button>

                            </div>
                        </form>
                    </div>
                </div>
            </div>
        </div>
        <script type="text/javascript" src="./assets/scripts/main.js"></script>
    </form>
</body>
</html>



