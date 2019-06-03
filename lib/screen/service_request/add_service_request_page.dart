import 'dart:io';

import 'package:easyleases_tenant/widget/EnsureVisibleWhenFocused.dart';
import 'package:easyleases_tenant/widget/label_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:easyleases_tenant/widget/button.dart';
import 'package:dotted_border/dotted_border.dart';

class AddServiceRequestPage extends StatefulWidget {
  @override
  _AddServiceRequestPageState createState() => _AddServiceRequestPageState();
}

class _AddServiceRequestPageState extends State<AddServiceRequestPage> {
  final GlobalKey<FormState> _formKey = new GlobalKey<FormState>();
  FocusNode _focusNodeTitle = new FocusNode();
  FocusNode _focusNodeDescription = new FocusNode();
  static final TextEditingController _titleController = TextEditingController();
  static final TextEditingController _descriptionController =
      TextEditingController();
  AddServiceModel _addServiceModel = AddServiceModel();
  List<String> requestTypeList = List<String>();

  @override
  void initState() {
    requestTypeList.add("List Value");
    requestTypeList.add("List Value");
    requestTypeList.add("List Value");
    requestTypeList.add("List Value");
    requestTypeList.add("List Value");
    requestTypeList.add("List Value");
    requestTypeList.add("List Value");
    requestTypeList.add("List Value");
    requestTypeList.add("List Value");
    requestTypeList.add("List Value");
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Theme.of(context).primaryColor,
        title: Text("Create Service Request"),
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios,
            color: Colors.white,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: SafeArea(
          top: false,
          bottom: false,
          child: Form(
              key: _formKey,
              child: SingleChildScrollView(
                physics: BouncingScrollPhysics(),
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(14,20,14,10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: <Widget>[
                      LabelText("Title"),
                      EnsureVisibleWhenFocused(
                        focusNode: _focusNodeTitle,
                        child: new TextFormField(
                          decoration: const InputDecoration(
                            border: const UnderlineInputBorder(),
                            hintText: 'Enter service title',
                          ),
                          onSaved: (String value) {
                            //TODO
                          },
                          style: TextStyle(color: Colors.grey[700]),
                          controller: _titleController,
                          focusNode: _focusNodeTitle,
                          keyboardType: TextInputType.text,
                          textInputAction: TextInputAction.done,
                        ),
                      ),
                      const SizedBox(height: 20),
                      LabelText("Description"),
                      EnsureVisibleWhenFocused(
                        focusNode: _focusNodeDescription,
                        child: new TextFormField(
                          decoration: const InputDecoration(
                            border: const UnderlineInputBorder(),
                            hintText: 'Enter description',
                          ),
                          onSaved: (String value) {
                            //TODO
                          },
                          style: TextStyle(color: Colors.grey[700]),
                          controller: _descriptionController,
                          focusNode: _focusNodeDescription,
                          keyboardType: TextInputType.text,
                          maxLines: 2,
                          minLines: 1,
                          textInputAction: TextInputAction.done,
                        ),
                      ),
                      const SizedBox(height: 20),
                      LabelText("Request Type"),
                      DropDownView(
                        text: "Select",
                        onPressed: () {
                          _showRequestTypePicker();
                        },
                      ),
                      const SizedBox(height: 20),
                      LabelText("Property"),
                      DropDownView(
                        text: "Select",
                        onPressed: () {
                          _showRequestTypePicker();
                        },
                      ),
                      const SizedBox(height: 20),
                      LabelText("Attachment"),
                      const SizedBox(height: 10),
                      AttachmentView(
                        onPressed: () {},
                      ),
                    ],
                  ),
                ),
              ))),
      bottomNavigationBar: _bottomButtons(),
    );
  }

  _showRequestTypePicker() {
    showModalBottomSheet(
        context: context,
        builder: (context) {
          return InkWell(
            onTap: () {},
            child: Container(
              height: 200,
              color: Colors.white,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      FlatButton(
                        child: Text(
                          "Cancel",
                          style: TextStyle(color: Colors.red),
                        ),
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                      ),
                      FlatButton(
                        child: Text("Select",
                            style: TextStyle(color: Colors.blue)),
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                      )
                    ],
                  ),
                  Expanded(
                    child: CupertinoPicker(
                      backgroundColor: Colors.grey[300],
                      itemExtent: 32,
                      children: List<Widget>.generate(requestTypeList.length,
                          (index) {
                        return Center(
                          child: Text("Item $index"),
                        );
                      }),
                      onSelectedItemChanged: (index) {},
                    ),
                  ),
                ],
              ),
            ),
          );
        });
  }

  _bottomButtons() {
    return Container(
      padding: const EdgeInsets.fromLTRB(12, 20, 12, 20),
      width: double.infinity,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.max,
        children: <Widget>[
          Expanded(
            child: CommonButton(
                text: "Save",
                bgColor: Theme.of(context).primaryColor,
                onPressed: () {}),
          ),
          const SizedBox(
            width: 10,
          ),
          Expanded(
            child: CommonButton(
                text: "Cancel",
                bgColor: Theme.of(context).accentColor,
                onPressed: () {}),
          ),
        ],
      ),
    );
  }
}

class DropDownView extends StatelessWidget {
  final String text;
  final Function onPressed;

  DropDownView({@required this.text, @required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPressed,
      child: Padding(
        padding: const EdgeInsets.only(top: 15),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Row(
              children: <Widget>[
                Expanded(
                  child: Text(
                    text,
                    style: TextStyle(color: Colors.grey[700], fontSize: 16),
                  ),
                ),
                Icon(
                  Icons.arrow_drop_down,
                  color: Colors.black,
                )
              ],
            ),
            SizedBox(
              height: 10,
            ),
            Container(
              height: 0.5,
              color: Colors.grey,
            ),
          ],
        ),
      ),
    );
  }
}

class AttachmentView extends StatelessWidget {
  final Function onPressed;

  AttachmentView({@required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPressed,
      child: DottedBorder(
        color: Colors.grey[400],
        gap: 3,
        strokeWidth: 1,
        child: Container(
          padding: const EdgeInsets.all(6),
          child: Row(
            children: <Widget>[
              Expanded(
                child: Text(
                  "Upload Attachment",
                  style: TextStyle(
                    color: Colors.grey[700],
                    fontSize: 16,
                  ),
                ),
              ),
              Image.asset("assets/icon/attachment.png",height: 20,width: 20,),
            ],
          ),
        ),
      ),
    );
  }
}

class AddServiceModel {
  String title = '';
  String description = '';
  String requestType = '';
  String property = '';
  File file;

  AddServiceModel({
    this.title,
    this.description,
    this.requestType,
    this.property,
    this.file,
  });
}
