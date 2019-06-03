import 'dart:io';

import 'package:easyleases_tenant/widget/EnsureVisibleWhenFocused.dart';
import 'package:easyleases_tenant/widget/label_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:easyleases_tenant/widget/button.dart';
import 'package:dotted_border/dotted_border.dart';

class EditServiceRequestPage extends StatefulWidget {
  @override
  _EditServiceRequestPageState createState() => _EditServiceRequestPageState();
}

class _EditServiceRequestPageState extends State<EditServiceRequestPage> {
  final GlobalKey<FormState> _formKey = new GlobalKey<FormState>();
  FocusNode _focusNodeTitle = new FocusNode();
  FocusNode _focusNodeDescription = new FocusNode();
  FocusNode _focusNodeComment = new FocusNode();
  static final TextEditingController _titleController = TextEditingController();
  static final TextEditingController _descriptionController =
      TextEditingController();
  static final TextEditingController _commentController =
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

    var x = "12345652457557";
    var lastThree = x.substring(x.length - 3);
    var otherNumbers = x.substring(0, x.length - 3);
    if (otherNumbers != '') lastThree = ',' + lastThree;
    var res =
        otherNumbers.replaceAll(RegExp("\\B(?=(\\d{2})+(?!\\d))"), ",") + lastThree;
    print(res);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Theme.of(context).primaryColor,
        title: Text("Edit Service Request"),
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
                  padding: const EdgeInsets.all(14),
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
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                LabelText("Request Type"),
                                DropDownView(
                                  text: "Select",
                                  onPressed: () {
                                    _showRequestTypePicker();
                                  },
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(
                            width: 30,
                          ),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                LabelText("Status"),
                                DropDownView(
                                  text: "Select",
                                  onPressed: () {
                                    _showRequestTypePicker();
                                  },
                                ),
                              ],
                            ),
                          )
                        ],
                      ),
                      const SizedBox(height: 20),
                      LabelText("Assigned To"),
                      EnsureVisibleWhenFocused(
                        focusNode: _focusNodeDescription,
                        child: new TextFormField(
                          enabled: false,
                          decoration: const InputDecoration(
                            border: const UnderlineInputBorder(),
                            hintText: 'Deepak, deepak@gmail.com, 54862479621',
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
                      LabelText("Attachment"),
                      const SizedBox(height: 14),
                      AttachmentView(
                        onPressed: () {},
                      ),
                      const SizedBox(height: 20),
                      _saveCancelButtons(),
                      const SizedBox(height: 20),
                      LabelText("Add Comment"),
                      EnsureVisibleWhenFocused(
                        focusNode: _focusNodeComment,
                        child: new TextFormField(
                          decoration: const InputDecoration(
                            border: const UnderlineInputBorder(),
                            hintText: 'Type your Comment Here...',
                          ),
                          onSaved: (String value) {
                            //TODO
                          },
                          style: TextStyle(color: Colors.grey[700]),
                          controller: _commentController,
                          focusNode: _focusNodeComment,
                          keyboardType: TextInputType.text,
                          textInputAction: TextInputAction.done,
                        ),
                      ),
                      const SizedBox(height: 10),
                      CommonButton(
                        text: "Add Comment",
                        bgColor: Theme.of(context).primaryColor,
                        onPressed: () {},
                      ),
                      const SizedBox(height: 14),
                      ListView.separated(
                        physics: ClampingScrollPhysics(),
                        shrinkWrap: true,
                        itemBuilder: (context, index) {
                          return _rowComment();
                        },
                        separatorBuilder: (context, index) {
                          return Container(
                            color: Colors.grey[300],
                            height: 1,
                          );
                        },
                        itemCount: 2,
                      )
                    ],
                  ),
                ),
              ))),
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

  _saveCancelButtons() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.max,
      children: <Widget>[
        Expanded(
          child: CommonButton(
              text: "Save",
              bgColor: Theme.of(context).primaryColor,
              onPressed: () {}),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: CommonButton(
              text: "Cancel",
              bgColor: Theme.of(context).accentColor,
              onPressed: () {}),
        ),
      ],
    );
  }

  _rowComment() {
    return Container(
      padding: const EdgeInsets.only(top: 25, bottom: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Text(
            "Vinesh T V",
            style: TextStyle(
              fontWeight: FontWeight.w500,
              fontSize: 14,
              color: Colors.blue,
            ),
          ),
          const SizedBox(height: 3),
          Text(
            "15 May 2019 / 5:30 pm",
            style: TextStyle(color: Colors.grey, fontSize: 12),
          ),
          const SizedBox(height: 10),
          Text(
            "Awaiting response from support team",
            style: TextStyle(
              fontWeight: FontWeight.w300,
              color: Colors.black,
              fontSize: 18,
            ),
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
              Image.asset(
                "assets/icon/attachment.png",
                height: 20,
                width: 20,
              )
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
