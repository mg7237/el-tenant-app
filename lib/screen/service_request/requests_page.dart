import 'package:easyleases_tenant/screen/service_request/add_service_request_page.dart';
import 'package:easyleases_tenant/screen/service_request/edit_service_request_page.dart';
import 'package:easyleases_tenant/widget/common_menu_button.dart';
import 'package:easyleases_tenant/widget/key_value_widget.dart';
import 'package:flutter/material.dart';

class RequestsPage extends StatefulWidget {
  @override
  _RequestsPageState createState() => _RequestsPageState();
}

class _RequestsPageState extends State<RequestsPage> {
  _openAddServiceRequestPage() {
    Navigator.of(context)
        .push(MaterialPageRoute(builder: (context) => AddServiceRequestPage()));
  }

  _openEditServiceRequestPage() {
    Navigator.of(context).push(
        MaterialPageRoute(builder: (context) => EditServiceRequestPage()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: const Color(0xFF427BFF),
        centerTitle: true,
        title: Text("Requests"),
        leading: CommonMenuButton(),
      ),
      body: ListView.separated(
        padding: const EdgeInsets.only(bottom: 80, top: 10),
        itemBuilder: (context, index) {
          return _buildRow(index);
        },
        physics: BouncingScrollPhysics(),
        itemCount: 15,
        separatorBuilder: (context, index) {
          return Divider(
            color: Colors.grey[400],
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _openAddServiceRequestPage();
        },
        child: Image.asset("assets/icon/add.png",width: 30,height: 30,),
      ),
    );
  }

  _buildRow(int index) {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 10, 16, 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Text(
            "15 May 2019",
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
                      "Geyser not working",
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
                        KeyValueView(
                          type: "Type",
                          value: "Complaint",
                        ),
                        const SizedBox(width: 16),
                        KeyValueView(
                          type: "Status",
                          value: "New",
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: KeyValueView(
                            type: "Assigned To",
                            value: "Deepak\ndeepak@gmail.com, 123456954",
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
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      child: Image.asset("assets/icon/delete.png",height: 20,width: 20,),
                    ),
                  ),
                  Card(
                    elevation: 8,
                    color: Theme.of(context).primaryColor,
                    child: InkWell(
                      onTap: () {
                        _openEditServiceRequestPage();
                      },
                      child: Container(
                        padding: const EdgeInsets.all(8),
                        child: Image.asset("assets/icon/pencil_edit_button.png",height: 20,width: 20,),
                      ),
                    ),
                  )
                ],
              ),
            ],
          )
        ],
      ),
    );
  }
}
