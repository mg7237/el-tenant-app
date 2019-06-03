import 'package:easyleases_tenant/widget/common_menu_button.dart';
import 'package:flutter/material.dart';
import 'dart:math' as math;

class DashboardPage extends StatefulWidget {
  @override
  _DashboardPageState createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF427BFF),
        centerTitle: true,
        title: Text("Dashboard"),
        leading: CommonMenuButton(),
      ),
      body: ListView(
        shrinkWrap: true,
        physics: BouncingScrollPhysics(),
        padding: const EdgeInsets.all(10),
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.only(top: 16),
            child: Text(
              "Sumadhura Sliver Ripples",
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.black,
                fontSize: 16,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          const SizedBox(height: 26),
          _buildCardPaymentOverDue(),
          const SizedBox(height: 15),
          _buildCardUpComingPayment(),
          const SizedBox(height: 15),
          _buildCardExpiry(),
        ],
      ),
    );
  }

  _buildCardPaymentOverDue() {
    return Container(
      height: 135,
      padding: const EdgeInsets.only(top: 5, left: 10),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          image: DecorationImage(
              image: AssetImage("assets/icon/blue_rectangle.png"),
              fit: BoxFit.fill)),
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
            child: Text(
              "Total Payment Over Due",
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w300),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(22, 0, 20, 5),
            child: Text(
              "₹ 55,194",
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.w800,
              ),
            ),
          )
        ],
      ),
    );
  }

  _buildCardUpComingPayment() {
    return Container(
      height: 135,
      padding: const EdgeInsets.only(top: 5, left: 10),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          image: DecorationImage(
              image: AssetImage("assets/icon/orange_rectangle.png"),
              fit: BoxFit.fill)),
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
            child: Text(
              "Upcoming Payment in next 30 days",
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w300),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(22, 0, 20, 5),
            child: Text(
              "₹ 29,000",
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.w800,
              ),
            ),
          )
        ],
      ),
    );
  }

  _buildCardExpiry() {
    return Container(
      height: 135,
      padding: const EdgeInsets.only(top: 5, left: 10),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          image: DecorationImage(
              image: AssetImage("assets/icon/red_rectangle.png"),
              fit: BoxFit.fill)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.fromLTRB(22.0, 10, 16, 0),
            child: Icon(
              Icons.access_time,
              size: 28,
              color: Colors.white,
            ),
          ),
          Divider(
            color: Colors.white,
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(22, 10, 20, 5),
            child: Text(
              "Days Remaining for Expiry",
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w300),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(22, 0, 20, 5),
            child: Text(
              "655",
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.w800,
              ),
            ),
          )
        ],
      ),
    );
  }
}
