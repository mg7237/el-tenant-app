import 'dart:io';

import 'package:easyleases_tenant/api_client/repository.dart';
import 'package:easyleases_tenant/config/config.dart';
import 'package:easyleases_tenant/model/agreements_response.dart';
import 'package:easyleases_tenant/model/extend_or_terminate_request.dart';
import 'package:easyleases_tenant/model/extend_or_terminate_response.dart';
import 'package:easyleases_tenant/util/utility.dart';
import 'package:easyleases_tenant/widget/button.dart';
import 'package:easyleases_tenant/widget/common_loader.dart';
import 'package:easyleases_tenant/widget/common_menu_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:share/share.dart';

class AgreementPage extends StatefulWidget {
  final String userId;

  AgreementPage(this.userId);

  @override
  _AgreementPageState createState() => _AgreementPageState(userId);
}

class _AgreementPageState extends State<AgreementPage> {
  final String userId;

  _AgreementPageState(this.userId);

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
      GlobalKey<RefreshIndicatorState>();
  AgreementResponse response;
  bool showLoader = true;
  String responseMsg = '';

  Future<Null> _getAgreements() async {
    response = await Repository().getAgreementsList(userId);
    if (response == null) {
      responseMsg = Config.SERVER_ERROR;
      Utility.showErrorSnackBar(_scaffoldKey, responseMsg);
    }
    setState(() {
      showLoader = false;
    });
    return null;
  }

  extendOrTerminate(int index, propertyId, extendOrTerminate) async {
    ExtendOrTerminateRequest request = ExtendOrTerminateRequest();
    request.propertyId = propertyId;
    request.extendOrTerminate = extendOrTerminate;
    setState(() {
      this.response.paymentsDueList[index].showLoader = true;
    });
    ExtendOrTerminateResponse response =
        await Repository().extendOrTerminate(userId, request);
    if (response == null) {
      responseMsg = Config.SERVER_ERROR;
      Utility.showErrorSnackBar(_scaffoldKey, responseMsg);
    } else {
      Utility.showSuccessSnackBar(_scaffoldKey, response.message);
    }
    setState(() {
      this.response.paymentsDueList[index].showLoader = false;
    });
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
      if (await Directory(directory + "/EasyleasesTenant").exists() != true) {
        print("Directory not exist");
        new Directory(directory + "/EasyleasesTenant")
            .createSync(recursive: true);
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
      File file = await Repository().download(directory + "/EasyleasesTenant");
      if (file.lengthSync() > 0) {
        Utility.showSuccessSnackBar(_scaffoldKey, "Download successfully.");
      } else {
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
  void initState() {
    super.initState();
    _getAgreements();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: Colors.grey[300],
      appBar: AppBar(
        backgroundColor: const Color(0xFF427BFF),
        centerTitle: true,
        title: Text("Agreement Details"),
        leading: CommonMenuButton(),
      ),
      body: showLoader
          ? _loader()
          : response == null ? _errorMsg() : _buildBody(),
    );
  }

  _buildBody() {
    return RefreshIndicator(
      key: _refreshIndicatorKey,
      onRefresh: _getAgreements,
      child: ListView.separated(
        padding: const EdgeInsets.only(bottom: 30),
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

  _loader() {
    return Center(child: CommonLoader());
  }

  _errorMsg() {
    return Center(
      child: Text(responseMsg),
    );
  }

  Widget _buildRow(int index, PaymentsDueList item) {
    return Card(
      child: Column(
        children: <Widget>[
          _topView(item),
          _middleView(item),
          _bottomButtons(index, item),
        ],
      ),
    );
  }

  Future requestWritePermission(PaymentsDueList item,  {Function onPermissionDenied}) async {
    bool granted = await _requestPermission(PermissionGroup.storage);
    if (!granted) {
      Utility.showErrorSnackBar(_scaffoldKey, "Need storage permission, go to app setting and provide storage permission.");
    }
    else{
      _downloadPdf(item.agreementUrl);
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

  _topView(PaymentsDueList item) {
    return Container(
      padding: const EdgeInsets.all(14),
      child: Row(
        children: <Widget>[
          Expanded(
            child: FittedBox(
              child: Text(
                item.propertyName,
                maxLines: 2,
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ),
          CommonButton(
            text: "Download PDF",
            bgColor: Theme.of(context).accentColor,
            onPressed: () {
              if (item.agreementUrl != null && item.agreementUrl.isNotEmpty) {
                requestWritePermission(item);
              } else {
                Utility.showErrorSnackBar(
                    _scaffoldKey, "Agreement document not available.");
              }
            },
            fontSize: 11.0,
          ),
        ],
      ),
    );
  }

  _middleView(PaymentsDueList item) {
    String rent = item.rent;
    String maintenance = item.maintenance;
    String deposit = item.deposit;
    String lateFeeMinAmount = item.lateFeeMinAmount;
    rent = rent.length < 4 ? rent : Utility.getFilterNumber(rent);
    maintenance = maintenance.length < 4
        ? maintenance
        : Utility.getFilterNumber(maintenance);
    deposit = deposit.length < 4 ? deposit : Utility.getFilterNumber(deposit);
    lateFeeMinAmount = lateFeeMinAmount.length < 4
        ? lateFeeMinAmount
        : Utility.getFilterNumber(lateFeeMinAmount);

    return Container(
      padding: const EdgeInsets.fromLTRB(16, 10, 16, 10),
      margin: const EdgeInsets.only(left: 8, right: 8),
      color: const Color(0xFFF5F5F5),
      child: Column(
        children: <Widget>[
          Row(
            children: <Widget>[
              _buildItem("Rent", "₹ $rent"),
              const SizedBox(width: 20),
              _buildItem("Maintenance", "₹ $maintenance"),
              const SizedBox(width: 20),
              _buildItem("Deposit", "₹ $deposit"),
            ],
          ),
          const SizedBox(height: 17),
          Row(
            children: <Widget>[
              _buildItem("Lease Start Date", item.leaseStartDate),
              const SizedBox(width: 20),
              _buildItem("Lease End Date", item.leaseEndDate),
            ],
          ),
          const SizedBox(height: 17),
          Row(
            children: <Widget>[
              _buildItem("Minimum Stay Period", "${item.minimumStay} Months"),
              const SizedBox(width: 20),
              _buildItem("Notice Period", "${item.noticePeriod} Months"),
            ],
          ),
          const SizedBox(height: 17),
          Row(
            children: <Widget>[
              _buildItem("Late Fee Changes", "${item.lateFeeCharges}%"),
              const SizedBox(width: 20),
              _buildItem("Late Fee Min Amount", "₹ $lateFeeMinAmount"),
            ],
          ),
          const SizedBox(height: 17),
        ],
      ),
    );
  }

  _bottomButtons(int index, PaymentsDueList item) {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 14, 16, 14),
      width: double.infinity,
      child: item.showLoader
          ? _loader()
          : Row(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.max,
              children: <Widget>[
                Expanded(
                  child: CommonButton(
                    text: "Request Extension",
                    bgColor: Theme.of(context).primaryColor,
                    onPressed: () {
                      showConfirmationDialog(index, item.propertyId,
                          'Do you really want to extend the lease?', 1);
                    },
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
                    onPressed: () {
                      showConfirmationDialog(index, item.propertyId,
                          'Do you really want to terminate the lease?', 2);
                    },
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
                      color: Colors.black,
                      fontSize: 11,
                      fontWeight: FontWeight.w500),
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

  showConfirmationDialog(int index, propertyId, String msg, int type) {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text("Confirmation"),
            content: Text(msg),
            actions: <Widget>[
              FlatButton(
                child: Text("Cancel"),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
              FlatButton(
                child: Text("Yes"),
                onPressed: () {
                  Navigator.of(context).pop();
                  if (type == 1) {
                    extendOrTerminate(index, propertyId, "1");
                  } else {
                    extendOrTerminate(index, propertyId, "2");
                  }
                },
              ),
            ],
          );
        });
  }
}
