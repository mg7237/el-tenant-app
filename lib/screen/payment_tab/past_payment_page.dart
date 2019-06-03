import 'package:easyleases_tenant/widget/key_value_widget.dart';
import 'package:flutter/material.dart';

class PastPaymentPage extends StatefulWidget {

  @override
  _PastPaymentPageState createState() => _PastPaymentPageState();

}

class _PastPaymentPageState extends State<PastPaymentPage> {

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      physics: BouncingScrollPhysics(),
      padding: const EdgeInsets.only(top: 16, bottom: 30),
      itemBuilder: (context, index) {
        return _buildRow(index);
      },
      separatorBuilder: (context, index) {
        return Divider(
          color: Colors.grey[400],
        );
      },
      itemCount: 15,
    );
  }

  _buildRow(int index) {
    return Container(
      padding: const EdgeInsets.fromLTRB(14, 10, 14, 10),
      child: Row(
        children: <Widget>[
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                Row(
                  children: <Widget>[
                    Text(
                      "Due Date: 5 April 2019",
                      style: TextStyle(
                          color: const Color(0xFFB59F9F),
                          fontWeight: FontWeight.w600,
                          fontSize: 10),
                    ),
                    const SizedBox(width: 25),
                    Text(
                      "Payment Type: Rent",
                      style: TextStyle(
                          color: const Color(0xFFB59F9F),
                          fontWeight: FontWeight.w600,
                          fontSize: 10),
                    )
                  ],
                ),
                const SizedBox(height: 10),
                Text(
                  "Rent Sumadhura Silver Ripples for 4-2019",
                  style: TextStyle(
                      color: Colors.black, fontWeight: FontWeight.w600, fontSize: 14),
                ),
                const SizedBox(height: 5),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Expanded(
                      child: KeyValueView(
                        type: "Original Amount",
                        value: "₹ 29,000",
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: KeyValueView(
                        type: "Penalty Amount",
                        value: "₹ 765",
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: KeyValueView(
                        type: "Total Amount",
                        value: "₹ 29,765",
                      ),
                    ),
                    const SizedBox(width: 10),
                  ],
                )
              ],
            ),
          ),
          Column(
            children: <Widget>[
              Card(
                elevation: 8,
                color: Theme.of(context).accentColor,
                child: Container(
                  padding: const EdgeInsets.all(8),
                  child: Icon(
                    Icons.email,
                    size: 20,
                    color: Colors.white,
                  ),
                ),
              ),
              Card(
                elevation: 8,
                color: Theme.of(context).primaryColor,
                child: Container(
                  padding: const EdgeInsets.all(8),
                  child: Image.asset(
                    "assets/icon/document_white.png",
                    width: 20,
                    height: 20,
                  ),
                ),
              )
            ],
          ),
        ],
      ),
    );
  }
}
