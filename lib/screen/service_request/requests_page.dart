import 'package:easyleases_tenant/api_client/repository.dart';
import 'package:easyleases_tenant/config/config.dart';
import 'package:easyleases_tenant/model/delete_request_response.dart';
import 'package:easyleases_tenant/model/service_request_list_response.dart';
import 'package:easyleases_tenant/screen/service_request/add_service_request_page.dart';
import 'package:easyleases_tenant/screen/service_request/edit_service_request_page.dart';
import 'package:easyleases_tenant/util/utility.dart';
import 'package:easyleases_tenant/widget/common_loader.dart';
import 'package:easyleases_tenant/widget/common_menu_button.dart';
import 'package:easyleases_tenant/widget/key_value_widget.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class RequestsPage extends StatefulWidget {
  @override
  _RequestsPageState createState() => _RequestsPageState();
}

class _RequestsPageState extends State<RequestsPage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey();
  ServiceRequestResponse response;
  bool showLoader = true;
  String responseMsg = '';

  _openAddServiceRequestPage()async {
    await Navigator.of(context)
        .push(MaterialPageRoute(builder: (context) => AddServiceRequestPage()));
    setState(() {
      showLoader = true;
    });
    _getServiceRequestList();
  }

  _openEditServiceRequestPage(SrList item) async{
    await Navigator.of(context).push(
        MaterialPageRoute(builder: (context) => EditServiceRequestPage(item)));
    setState(() {
      showLoader = true;
    });
    _getServiceRequestList();
  }

  _deleteService(String serviceId) async {
    DeleteRequestResponse response =
        await Repository().deleteServiceRequestById(serviceId);
    if (response == null) {
      responseMsg = Config.SERVER_ERROR;
      Utility.showErrorSnackBar(_scaffoldKey, responseMsg);
    } else if (!response.status) {
      responseMsg = response.message;
    } else {
      Utility.showSuccessSnackBar(_scaffoldKey, response.message);
    }
    _getServiceRequestList();
  }

  _showDialogConfirmation(String serviceId) {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text("Confirmation"),
            content: Text("Do you realy want to delete this?"),
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
                  _deleteService(serviceId);
                },
              )
            ],
          );
        });
  }

  Future<Null> _getServiceRequestList() async {
    response = await Repository().getServiceRequestList();
    if (response == null) {
      responseMsg = Config.SERVER_ERROR;
      Utility.showErrorSnackBar(_scaffoldKey, responseMsg);
    }
    setState(() {
      showLoader = false;
    });
    return null;
  }

  @override
  void initState() {
    _getServiceRequestList();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: const Color(0xFF427BFF),
        centerTitle: true,
        title: Text("Requests"),
        leading: CommonMenuButton(),
      ),
      body: showLoader
          ? _loader()
          : response == null ||
                  response.srList == null ||
                  response.srList.length == 0
              ? _errorMsg()
              : _buildBody(),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _openAddServiceRequestPage();
        },
        child: Image.asset(
          "assets/icon/add.png",
          width: 30,
          height: 30,
        ),
      ),
    );
  }

  _buildBody() {
    return ListView.separated(
      padding: const EdgeInsets.only(bottom: 80, top: 10),
      itemBuilder: (context, index) {
        SrList item = response.srList[index];
        return _buildRow(index, item);
      },
      physics: BouncingScrollPhysics(),
      itemCount: response.srList.length,
      separatorBuilder: (context, index) {
        return Divider(
          color: Colors.grey[400],
        );
      },
    );
  }

  _buildRow(int index, SrList item) {
    String supportStr = '';
    if(item.supportContact.isEmpty){
      supportStr = "${item.supportName}\n${item.supportEmail}";
    }else{
      supportStr = "${item.supportName}\n${item.supportEmail} , ${item.supportContact}";
    }
    return InkWell(
      onTap: (){
        _openEditServiceRequestPage(item);
      },
      child: Container(
        padding: const EdgeInsets.fromLTRB(16, 10, 16, 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Text(
              DateFormat("dd MMM yyyy").format(DateTime.parse(item.updateDate)),
              style: TextStyle(
                  color: Colors.grey[400],
                  fontWeight: FontWeight.w600,
                  fontSize: 10),
            ),
            const SizedBox(height: 10),
            Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        "${item.title}",
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: 13,
                            fontWeight: FontWeight.w500),
                      ),
                      const SizedBox(height: 10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.max,
                        children: <Widget>[
                          Flexible(
                            flex: 1,
                            child: KeyValueView(
                              type: "Type",
                              value: "${item.type}",
                            ),
                          ),
                          Flexible(
                            flex: 1,
                            child: KeyValueView(
                              type: "Status",
                              value: "${item.status}",
                            ),
                          ),
                          Flexible(
                            flex: 2,
                            child: KeyValueView(
                              type: "Assigned To",
                              value:
                                  supportStr,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 16),
                Row(
                  children: <Widget>[
                    Card(
                      elevation: 8,
                      color: Theme.of(context).accentColor,
                      child: InkWell(
                        onTap: () {
                          _showDialogConfirmation(item.srId.toString());
                        },
                        child: Container(
                          padding: const EdgeInsets.all(8),
                          child: Image.asset(
                            "assets/icon/delete.png",
                            height: 20,
                            width: 20,
                          ),
                        ),
                      ),
                    ),
                    /*Card(
                      elevation: 8,
                      color: Theme.of(context).primaryColor,
                      child: InkWell(
                        onTap: () {
                          _openEditServiceRequestPage(item);
                        },
                        child: Container(
                          padding: const EdgeInsets.all(8),
                          child: Image.asset(
                            "assets/icon/pencil_edit_button.png",
                            height: 20,
                            width: 20,
                          ),
                        ),
                      ),
                    )*/
                  ],
                ),
              ],
            )
          ],
        ),
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
