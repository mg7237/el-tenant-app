import 'package:easyleases_tenant/widget/button.dart';
import 'package:easyleases_tenant/widget/common_menu_button.dart';
import 'package:flutter/material.dart';

class AgreementPage extends StatefulWidget {
  @override
  _AgreementPageState createState() => _AgreementPageState();
}

class _AgreementPageState extends State<AgreementPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: const Color(0xFF427BFF),
        centerTitle: true,
        title: Text("Agreement Details"),
        leading: CommonMenuButton(),
      ),
      bottomNavigationBar: _bottomButtons(),
      body: Column(
        children: <Widget>[
          _topView(),
          Expanded(
            child: _middleView(),
          )
        ],
      ),
    );
  }

  _topView() {
    return Container(
      padding: const EdgeInsets.all(14),
      child: Row(
        children: <Widget>[
          Expanded(
            child: Text(
              "Sumadhura Silver Ripples",
              maxLines: 2,
              style: TextStyle(
                color: Colors.black,
                fontSize: 14,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          CommonButton(
            text: "Download PDF",
            bgColor: Theme.of(context).accentColor,
            onPressed: () {},
            fontSize: 11.0,
          ),
        ],
      ),
    );
  }

  _middleView() {
    return Container(
      padding: const EdgeInsets.fromLTRB(16,10,16,10),
      margin: const EdgeInsets.only(left: 8,right: 8),
      color: const Color(0xFFF5F5F5),
      child: Center(
        child: SingleChildScrollView(
          physics: BouncingScrollPhysics(),
          child: Column(
            children: <Widget>[
              Row(
                children: <Widget>[
                  _buildItem("Rent", "₹ 29,000"),
                  const SizedBox(width: 20),
                  _buildItem("Maintenance", "₹ 0"),
                  const SizedBox(width: 20),
                  _buildItem("Deposit", "₹ 1,75,000"),
                ],
              ),
              const SizedBox(height: 17),
              Row(
                children: <Widget>[
                  _buildItem("Lease Start Date", "24 Jun 2018"),
                  const SizedBox(width: 20),
                  _buildItem("Lease End Date", "28 Feb 2019"),
                ],
              ),
              const SizedBox(height: 17),
              Row(
                children: <Widget>[
                  _buildItem("Minimum Stay Period", "6 Months"),
                  const SizedBox(width: 20),
                  _buildItem("Notice Period", "2 Months"),
                ],
              ),
              const SizedBox(height: 17),
              Row(
                children: <Widget>[
                  _buildItem("Late Fee Changes", "24%"),
                  const SizedBox(width: 20),
                  _buildItem("Late Fee Min Amount", "₹ 0"),
                ],
              ),
              const SizedBox(height: 17),
            ],
          ),
        ),
      ),
    );
  }

  _bottomButtons() {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 14, 16, 14),
      width: double.infinity,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.max,
        children: <Widget>[
          Expanded(
            child: CommonButton(
              text: "Request Extension",
              bgColor: Theme.of(context).primaryColor,
              onPressed: () {},
              fontSize: 11.0,
            ),
          ),
          const SizedBox(
            width: 10,
          ),
          Expanded(
            child: CommonButton(
              text: "Request Termination",
              bgColor: Theme.of(context).accentColor,
              onPressed: () {},
              fontSize: 11.0,
            ),
          ),
        ],
      ),
    );
  }

  _buildItem(String title, String value) {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.only(left: 5),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  title,
                  style: TextStyle(
                      color: Colors.black, fontSize: 11, fontWeight: FontWeight.w500),
                ),
                const SizedBox(
                  height: 8,
                ),
                Text(
                  value,
                  style: TextStyle(
                      color: const Color(0xFF525252),
                      fontSize: 12,
                      fontWeight: FontWeight.w400),
                ),
                const SizedBox(
                  height: 10,
                ),
              ],
            ),
          ),
          Container(
            height: 1,
            color: Colors.grey[300],
          ),
        ],
      ),
    );
  }
}
