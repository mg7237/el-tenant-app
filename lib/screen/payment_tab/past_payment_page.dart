import 'dart:io';

import 'package:easyleases_tenant/api_client/api_client.dart';
import 'package:easyleases_tenant/api_client/repository.dart';
import 'package:easyleases_tenant/config/config.dart';
import 'package:easyleases_tenant/model/download_or_email_request.dart';
import 'package:easyleases_tenant/model/download_or_email_response.dart';
import 'package:easyleases_tenant/model/past_payment_response.dart';
import 'package:easyleases_tenant/util/utility.dart';
import 'package:easyleases_tenant/widget/common_loader.dart';
import 'package:easyleases_tenant/widget/key_value_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:share/share.dart';

class PastPaymentPage extends StatefulWidget {
  final String userId;

  PastPaymentPage(this.userId);

  @override
  _PastPaymentPageState createState() => _PastPaymentPageState(userId);
}

class _PastPaymentPageState extends State<PastPaymentPage>
    with AutomaticKeepAliveClientMixin<PastPaymentPage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
      GlobalKey<RefreshIndicatorState>();
  final String userId;
  PastPaymentResponse response;
  bool showLoader = true;
  String responseMsg = '';

  _PastPaymentPageState(this.userId);

  Future<Null> _getPasPayment() async {
    response = await Repository().getPastPaymentList(userId);
    if (response == null) {
      responseMsg = Config.SERVER_ERROR;
      Utility.showErrorSnackBar(_scaffoldKey, responseMsg);
    }
    setState(() {
      showLoader = false;
    });
    return null;
  }

  _sendEmail(String id) async {
    setState(() {
      showLoader = true;
    });
    DownloadOrEmailRequest model = DownloadOrEmailRequest();
    model.downloadOrEmail = "2";
    DownloadOrEmailResponse response =
        await Repository().downloadOrEmail(id, model);
    if (response == null) {
      String responseMsg = Config.SERVER_ERROR;
      Utility.showErrorSnackBar(_scaffoldKey, responseMsg);
    } else if (response.status) {
      Utility.showSuccessSnackBar(_scaffoldKey, response.message);
    } else {
      Utility.showErrorSnackBar(_scaffoldKey, response.message);
    }
    setState(() {
      showLoader = false;
    });
  }

  _downloadDoc(String id) async {
    setState(() {
      showLoader = true;
    });
    DownloadOrEmailRequest model = DownloadOrEmailRequest();
    model.downloadOrEmail = "1";
    DownloadOrEmailResponse response =
        await Repository().downloadOrEmail(id, model);
    setState(() {
      showLoader = false;
    });
    if (response == null) {
      String responseMsg = Config.SERVER_ERROR;
      Utility.showErrorSnackBar(_scaffoldKey, responseMsg);
    } else if (response.status) {
      _downloadPdf(response.docUrl);
    } else {
      Utility.showErrorSnackBar(_scaffoldKey, response.message);
    }
  }

  /// Requests the users permission to storage.
  Future requestWritePermission(PaymentsDueList item, {Function onPermissionDenied}) async {
    bool granted = await _requestPermission(PermissionGroup.storage);
    if (!granted) {
      Utility.showErrorSnackBar(_scaffoldKey, "Need storage permission, go to app setting and provide storage permission.");
    }
    else{
      _downloadDoc(item.paymentRowid.toString());
    }
    //return granted;
  }

  Future<bool> _requestPermission(PermissionGroup permission) async {
    final PermissionHandler _permissionHandler = PermissionHandler();
    var result = await _permissionHandler.requestPermissions([permission]);
    if (result[permission] == PermissionStatus.granted) {
      return true;
    }
    return false;
  }

  void createFolder() async {
    Map<PermissionGroup, PermissionStatus> permissions =
        await PermissionHandler().requestPermissions([PermissionGroup.storage]);
    if (permissions[PermissionGroup.storage] == PermissionStatus.granted) {
      String directory = '';
      if (Platform.isIOS) {
        directory = (await getApplicationDocumentsDirectory()).path;
      } else {
        directory = (await getExternalStorageDirectory()).path;
      }
      bool hasExisted =
          await Directory(directory + "/EasyleasesTenant").exists();
      if (!hasExisted) {
        print("Directory not exist");
       await Directory(directory + "/EasyleasesTenant").create();
      } else {
        print("Directoryexist");
      }
    }
  }

  _downloadPdf(String url) async {
    await createFolder();
    String directory = '';
    if (Platform.isIOS) {
      /*directory = (await getApplicationDocumentsDirectory()).path;
      File file  = await Repository().download(directory + "/EasyleasesTenant");
      if (file.lengthSync() > 0) {
        Utility.showSuccessSnackBar(_scaffoldKey, "Download successfully.");
      } else  {
        Utility.showErrorSnackBar(_scaffoldKey, "Download failed.");
      }*/
      Share.share(url);
    } else {
      directory = (await getExternalStorageDirectory()).path;

      final taskId = await FlutterDownloader.enqueue(
        url: url,
        savedDir: directory + "/EasyleasesTenant",
        showNotification: true,
        // show download progress in status bar (for Android)
        openFileFromNotification:
        true, // click on notification to open downloaded file (for Android)
      );
      FlutterDownloader.registerCallback((id, status, progress) {
        // code to update your UI
        if (status == DownloadTaskStatus.complete) {
          Utility.showSuccessSnackBar(_scaffoldKey, "Download successful.");
        } else if (status == DownloadTaskStatus.failed) {
          Utility.showErrorSnackBar(_scaffoldKey, "Download failed.");
        }
      });
    }
  }

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    _getPasPayment();
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
      onRefresh: _getPasPayment,
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
      child: Row(
        children: <Widget>[
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                Row(
                  children: <Widget>[
                    Expanded(
                      child: FittedBox(
                        child: Text(
                          "Due Date: ${item.dueDate}",
                          style: TextStyle(
                              color: const Color(0xFFB59F9F),
                              fontWeight: FontWeight.w600,
                              ),
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
                              ),
                        ),
                      ),
                    )
                  ],
                ),
                const SizedBox(height: 10),
                Text(
                  item.title,
                  style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.w600,
                      fontSize: 14),
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
                  ],
                )
              ],
            ),
          ),
          Column(
            children: <Widget>[
              InkWell(
                onTap: () {
                  _sendEmail(item.paymentRowid.toString());
                },
                child: Card(
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
              ),
              InkWell(
                onTap: () {
                  requestWritePermission(item);

                },
                child: Card(
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
                ),
              )
            ],
          ),
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
