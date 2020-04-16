import 'dart:io';

import 'package:easyleases_tenant/api_client/repository.dart';
import 'package:easyleases_tenant/config/config.dart';
import 'package:easyleases_tenant/model/download_or_email_request.dart';
import 'package:easyleases_tenant/model/download_or_email_response.dart';
import 'package:easyleases_tenant/model/due_payment_response.dart';
import 'package:easyleases_tenant/model/reverse_payment_response.dart';
import 'package:easyleases_tenant/screen/payment_web_page.dart';
import 'package:easyleases_tenant/util/preference_connector.dart';
import 'package:easyleases_tenant/util/utility.dart';
import 'package:easyleases_tenant/widget/common_loader.dart';
import 'package:easyleases_tenant/widget/key_value_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:path_provider/path_provider.dart';


class PaymentDuePage extends StatefulWidget {
  final String userId;

  PaymentDuePage(this.userId);

  @override
  _PaymentDuePageState createState() => _PaymentDuePageState(userId);
}

class _PaymentDuePageState extends State<PaymentDuePage>
    with AutomaticKeepAliveClientMixin<PaymentDuePage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
      GlobalKey<RefreshIndicatorState>();
  final String userId;
  DuePaymentResponse response;
  bool showLoader = true;
  String responseMsg = '';

  _PaymentDuePageState(this.userId);

  Future<Null> _getDuePayment() async {
    response = await Repository().getDuePaymentList(userId);
    if (response == null) {
      responseMsg = Config.SERVER_ERROR;
      Utility.showErrorSnackBar(_scaffoldKey, responseMsg);
    } else if (!response.status) {
      responseMsg = response.message;
    }
    setState(() {
      showLoader = false;
    });
    return null;
  }

  _callReverseNEFTapi(String rowId)async{

    ReversePaymentResponse  response = await Repository().reverseNEFT(rowId);
    if (response == null) {
      responseMsg = Config.SERVER_ERROR;
      Utility.showErrorSnackBar(_scaffoldKey, responseMsg);
    } else if (!response.status) {
      responseMsg = response.message;
    }else{
      Utility.showSuccessSnackBar(_scaffoldKey, response.message);
    }
    _getDuePayment();
  }


  _showRevertAction(String rowId) {
    showCupertinoModalPopup(
        context: context,
        builder: (context) {
          return CupertinoActionSheet(
            title: Text(
              'Action',
              style: TextStyle(fontSize: 20, color: Colors.grey),
            ),
            actions: <Widget>[
              CupertinoActionSheetAction(
                child: Text("Reverse NEFT/Undo NEFT Payment"),
                onPressed: () async {
                  Navigator.pop(context);
                  _callReverseNEFTapi(rowId);
                },
              ),
            ],
          );
        });
  }

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    _getDuePayment();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      body: showLoader
          ? _loader()
          : response == null ||
                  response.paymentsDueList == null ||
                  response.paymentsDueList.length == 0
              ? _errorMsg()
              : _buildBody(),
    );
  }

  _buildBody() {
    return RefreshIndicator(
      key: _refreshIndicatorKey,
      onRefresh: _getDuePayment,
      child: ListView.separated(
        padding: const EdgeInsets.only(top: 16, bottom: 30),
        itemBuilder: (context, index) {
          PaymentsDueList item = response.paymentsDueList[index];
          return _buildRow(index, item);
        },
        separatorBuilder: (context, index) {
          return Divider(
            color: Colors.grey[400],
          );
        },
        itemCount: response.paymentsDueList.length,
      ),
    );
  }

  _buildRow(int index, PaymentsDueList item) {
    String originalAmount = item.originalAmount;
    String penaltyAmount = item.penaltyAmount;
    String totalAmount = item.totalAmount;
    originalAmount = originalAmount.length < 4
        ? originalAmount
        : Utility.getFilterNumber(originalAmount);
    penaltyAmount = penaltyAmount.length < 4
        ? penaltyAmount
        : Utility.getFilterNumber(penaltyAmount);
    totalAmount = totalAmount.length < 4
        ? totalAmount
        : Utility.getFilterNumber(totalAmount);

    String paymentType = "";
    switch (item.paymentType) {
      case 1:
        paymentType = 'Adhoc Charges';
        break;
      case 2:
        paymentType = 'Rent';
        break;
      default:
        paymentType = 'Rent';
        break;
    }

    return Container(
      padding: const EdgeInsets.fromLTRB(14, 10, 14, 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Row(
            children: <Widget>[
              Expanded(
                child: FittedBox(
                  fit: BoxFit.fitHeight,
                  child: Text(
                    "Due Date: ${item.dueDate}",
                    style: TextStyle(
                        color: const Color(0xFFB59F9F),
                        fontWeight: FontWeight.w600,
                        fontSize: 10),
                  ),
                ),
              ),
              const SizedBox(width: 25),
              Expanded(
                child: FittedBox(
                  child: Text(
                    "Payment Type: $paymentType",
                    style: TextStyle(
                        color: const Color(0xFFB59F9F),
                        fontWeight: FontWeight.w600,
                        fontSize: 10),
                  ),
                ),
              ),
              Expanded(child: Container()),
              item.paymentStatus == '2'
                  ? Container(
                      padding: const EdgeInsets.fromLTRB(10, 3, 10, 3),
                      decoration: BoxDecoration(
                          color: Colors.green,
                          borderRadius: BorderRadius.circular(6)),
                      child: FittedBox(
                        child: Text(
                          "Under Moderation",
                          style: TextStyle(color: Colors.white, fontSize: 11),
                        ),
                      ),
                    )
                  : Container()
            ],
          ),
          const SizedBox(height: 10),
          FittedBox(
            child: Text(
              item.title,
              style: TextStyle(
                  color: Colors.black, fontWeight: FontWeight.w600, fontSize: 14),
            ),
          ),
          const SizedBox(height: 5),
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Expanded(
                child: KeyValueView(
                  type: "Original Amount",
                  value: "₹ $originalAmount",
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: KeyValueView(
                  type: "Penalty Amount",
                  value: "₹ $penaltyAmount",
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: KeyValueView(
                  type: "Total Amount",
                  value: "₹ $totalAmount",
                ),
              ),
              const SizedBox(width: 10),
              item.paymentStatus == '2'
                  ? InkWell(
                      onTap: () {
                        _showRevertAction(item.paymentRowid.toString());
                      },
                      child: Card(
                        elevation: 8,
                        color: Theme.of(context).accentColor,
                        child: Container(
                          padding: const EdgeInsets.all(8),
                          child: Icon(
                            Icons.more_vert,
                            color: Colors.white,
                          ),
                        ),
                      ))
                  : InkWell(
                      onTap: () async {
                        String deviceId = await PreferenceConnector()
                            .getString(PreferenceConnector.DEVICE_ID);
                        String x_api_key = await PreferenceConnector()
                            .getString(PreferenceConnector.X_API_KEY);
                        bool value = await Navigator.of(context).push(
                            MaterialPageRoute(
                                builder: (context) => PaymentWebPage(
                                    deviceId, x_api_key, item.paymentRowid)));
                        _getDuePayment();
                      },
                      child: Card(
                        elevation: 8,
                        color: Theme.of(context).accentColor,
                        child: Container(
                          padding: const EdgeInsets.all(8),
                          child: Image.asset(
                            "assets/icon/payment_white.png",
                            width: 20,
                            height: 20,
                          ),
                        ),
                      ),
                    ),
            ],
          )
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
}
