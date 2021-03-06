import 'package:easyleases_tenant/screen/payment_tab/past_payment_page.dart';
import 'package:easyleases_tenant/screen/payment_tab/payment_due_page.dart';
import 'package:easyleases_tenant/widget/common_menu_button.dart';
import 'package:flutter/material.dart';

class PaymentPage extends StatefulWidget {
  final String userId;

  PaymentPage(this.userId);

  @override
  _PaymentPageState createState() => _PaymentPageState(userId);
}

class _PaymentPageState extends State<PaymentPage> {
  final String userId;

  _PaymentPageState(this.userId);

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: const Color(0xFF427BFF),
          centerTitle: true,
          title: Text("Payments"),
          bottom: TabBar(
            indicatorColor: Colors.white,
            indicatorWeight: 4,
            tabs: [
              Tab(
                text: "Payments Due",
              ),
              Tab(
                text: "Past Payments",
              )
            ],
          ),
          leading: CommonMenuButton(),
        ),
        body: TabBarView(
          children: [
            PaymentDuePage(userId),
            PastPaymentPage(userId),
          ],
        ),
      ),
    );
  }
}
