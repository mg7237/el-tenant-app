import 'package:easyleases_tenant/api_client/repository.dart';
import 'package:easyleases_tenant/config/config.dart';
import 'package:easyleases_tenant/model/dashboard_response.dart';
import 'package:easyleases_tenant/util/helper.dart';
import 'package:easyleases_tenant/util/utility.dart';
import 'package:easyleases_tenant/widget/common_loader.dart';
import 'package:easyleases_tenant/widget/common_menu_button.dart';
import 'package:flutter/material.dart';
import 'dart:math' as math;

class DashboardPage extends StatefulWidget {
  final String userId;
  final PageController pageController;

  DashboardPage(this.userId, this.pageController);

  @override
  _DashboardPageState createState() => _DashboardPageState(userId);
}

class _DashboardPageState extends State<DashboardPage>
    with AutomaticKeepAliveClientMixin<DashboardPage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
      new GlobalKey<RefreshIndicatorState>();

  final String userId;
  DashboardResponse dashboard;
  bool showLoader = true;
  String responseMsg = '';

  _DashboardPageState(this.userId);

  Future<Null> getDashboardDetails() async {
    dashboard = await Repository().getDashboard(userId);
    if (dashboard == null) {
      responseMsg = Config.SERVER_ERROR;
      Utility.showErrorSnackBar(_scaffoldKey, responseMsg);
    } else {
      dashboard.paymentOverdue = dashboard.paymentOverdue.length < 4
          ? dashboard.paymentOverdue
          : Utility.getFilterNumber(dashboard.paymentOverdue);
      dashboard.upcomingPayment = dashboard.upcomingPayment.length < 4
          ? dashboard.upcomingPayment
          : Utility.getFilterNumber(dashboard.upcomingPayment);
      dashboard.depositAmount = dashboard.depositAmount.length < 4
          ? dashboard.depositAmount
          : Utility.getFilterNumber(dashboard.depositAmount);
    }
    setState(() {
      showLoader = false;
    });
    return null;
  }

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    getDashboardDetails();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        backgroundColor: const Color(0xFF427BFF),
        centerTitle: true,
        title: Text("Dashboard"),
        leading: CommonMenuButton(),
      ),
      body: showLoader
          ? _loader()
          : dashboard == null ? _errorMsg() : _buildBody(),
    );
  }

  _buildBody() {
    return RefreshIndicator(
      key: _refreshIndicatorKey,
      onRefresh: getDashboardDetails,
      child: ListView(
        padding: const EdgeInsets.all(10),
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.only(top: 16),
            child: Row(
              children: <Widget>[
                Text(
                  dashboard.propertyName,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                  ),
                )
              ],
            ),
          ),
          const SizedBox(height: 26),
          _buildDepositPaid(),
          _buildCardPaymentOverDue(),
        //  const SizedBox(height: 2),
          _buildCardUpComingPayment(),
         // const SizedBox(height: 2),
          _buildCardExpiry(),
         // const SizedBox(height: 2),
        ],
      ),
    );
  }

  _loader() {
    return Center(child: CommonLoader());
  }

  _errorMsg() {
    return Center(
      child: Text(responseMsg),
    );
  }

  _buildCardPaymentOverDue() {
    return Container(
      padding: const EdgeInsets.only(top: 5, left: 10,bottom: 15),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          image: DecorationImage(
              image: AssetImage("assets/icon/blue_rectangle.png"),
              fit: BoxFit.fill)),
      child: InkWell(
        onTap: () {
          widget.pageController.jumpToPage(3);
        },
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.fromLTRB(22.0, 10, 16, 0),
              child: Image.asset(
                "assets/icon/payment_white.png",
                width: 22,
                height: 22,
              ),
            ),
            Divider(
              color: Colors.white,
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(22, 10, 20, 5),
              child: FittedBox(
                child: Text(
                  "Upcoming Payment in Next 30 Days",
                  style: TextStyle(
                    fontSize: 16,
                      color: Colors.white,
                      fontWeight: FontWeight.w300),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(22, 0, 20, 5),
              child: FittedBox(
                child: Text(
                  "${Helper.RUPEE} ${dashboard.upcomingPayment}",
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.white,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  _buildCardUpComingPayment() {
    return Container(
      padding: const EdgeInsets.only(top: 5, left: 10,bottom: 15),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          image: DecorationImage(
              image: AssetImage("assets/icon/orange_rectangle.png"),
              fit: BoxFit.fill)),
      child: InkWell(
        onTap: () {
          widget.pageController.jumpToPage(3);
        },
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.fromLTRB(22.0, 10, 16, 0),
              child: Image.asset(
                "assets/icon/payment_white.png",
                width: 22,
                height: 22,
              ),
            ),
            Divider(
              color: Colors.white,
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(22, 10, 20, 5),
              child: FittedBox(
                child: Text(
                  "Total Payment Overdue",
                  style: TextStyle(
                    fontSize: 16,
                      color: Colors.white,
                      fontWeight: FontWeight.w300),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(22, 0, 20, 5),
              child: FittedBox(
                child: Text(
                  "${Helper.RUPEE} ${dashboard.paymentOverdue}",
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.white,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  _buildCardExpiry() {
    return Container(
      padding: const EdgeInsets.only(top: 5, left: 10,bottom: 15),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          image: DecorationImage(
              image: AssetImage("assets/icon/red_rectangle.png"),
              fit: BoxFit.fill)),
      child: InkWell(
        onTap: () {
          widget.pageController.jumpToPage(2);
        },
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.fromLTRB(22.0, 10, 16, 0),
              child: Icon(
                Icons.today,
                size: 28,
                color: Colors.white,
              ),
            ),
            Divider(
              color: Colors.white,
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(22, 10, 20, 5),
              child: FittedBox(
                child: Text(
                  "Days Remaining for Lease Expiry",
                  style: TextStyle(
                    fontSize: 16,
                      color: Colors.white,
                      fontWeight: FontWeight.w300),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(22, 0, 20, 5),
              child: FittedBox(
                child: Text(
                  "${dashboard.dayesToExpiry}",
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.white,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  _buildDepositPaid() {
    return Container(

      padding: const EdgeInsets.only(top: 5, left: 10,bottom: 15),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          image: DecorationImage(
              image: AssetImage("assets/icon/green_rectangle.jpeg"),
              fit: BoxFit.fill)),
      child: InkWell(
        onTap: () {
           widget.pageController.jumpToPage(2);
        },
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.fromLTRB(22.0, 10, 16, 0),
              child: Image.asset(
                'assets/green_icon.png',
                width: 30,
                height: 30,
                color: Colors.white,
              ),
            ),
            Divider(
              color: Colors.white,
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(22, 8, 20, 5),
              child: FittedBox(
                child: Text(
                  "Total Deposit Amount",
                  style: TextStyle(
                    fontSize: 16,
                      color: Colors.white,
                      fontWeight: FontWeight.w300),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(22, 0, 20, 5),
              child: FittedBox(
                child: Text(
                  "${Helper.RUPEE} ${dashboard.depositAmount}",
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.white,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
