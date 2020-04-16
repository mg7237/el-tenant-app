import 'dart:io';

import 'package:easyleases_tenant/api_client/repository.dart';
import 'package:easyleases_tenant/config/config.dart';
import 'package:easyleases_tenant/model/comment_response.dart';
import 'package:easyleases_tenant/model/property_list_response.dart';
import 'package:easyleases_tenant/model/request_type_list_response.dart';
import 'package:easyleases_tenant/util/utility.dart';
import 'package:easyleases_tenant/widget/EnsureVisibleWhenFocused.dart';
import 'package:easyleases_tenant/widget/common_loader.dart';
import 'package:easyleases_tenant/widget/label_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:easyleases_tenant/widget/button.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:image_picker/image_picker.dart';
import 'package:file_picker/file_picker.dart';
import 'package:path/path.dart' as path;

class AddServiceRequestPage extends StatefulWidget {
  @override
  _AddServiceRequestPageState createState() => _AddServiceRequestPageState();
}

class _AddServiceRequestPageState extends State<AddServiceRequestPage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  final GlobalKey<FormState> _formKey = new GlobalKey<FormState>();
  FocusNode _focusNodeTitle = new FocusNode();
  FocusNode _focusNodeDescription = new FocusNode();
  static final TextEditingController _titleController = TextEditingController();
  static final TextEditingController _descriptionController =
      TextEditingController();
  AddServiceModel _addServiceModel =
      AddServiceModel(propertyName: '', requestTypeName: '', files: []);
  List<TypesList> _requestTypeList;
  List<PropertyList> _propertyList;
  bool showLoader = true;
  String responseMsg = '';

  getRequestTypeList() async {
    RequestTypeListResponse response = await Repository().getRequestTypeList();
    if (response.status) {
      _requestTypeList = response.typesList;
      getPropertyList();
    } else {}
  }

  getPropertyList() async {
    PropertyListResponse response = await Repository().getPropertyList();
    if (response.status) {
      _propertyList = response.propertyList;
      setState(() {
        showLoader = false;
      });
    }
  }

  _showImagePicker() async {
    bool checkCameraPermission = false;
    File file = await FilePicker.getFile(type: FileType.ANY);
    if (file != null) {
      setState(() {
        _addServiceModel.files.add(file);
      });
    }
    /*showCupertinoModalPopup(
        context: context,
        builder: (context) {
          return CupertinoActionSheet(
            title: Text(
              'Select Image',
              style: TextStyle(fontSize: 20, color: Colors.grey),
            ),
            actions: <Widget>[
              CupertinoActionSheetAction(
                child: Text("Select from Camera"),
                onPressed: () async {
                  checkCameraPermission = true;
                  checkPermission(checkCameraPermission);
                  Navigator.pop(context);
                },
              ),
              CupertinoActionSheetAction(
                child: Text("Select from Gallery"),
                onPressed: () async {
                  checkPermission(false);
                  Navigator.pop(context);
                },
              ),
            ],
          );
        });*/
  }

  checkPermission(bool result) async {
    if (result) {
      getImage(result);
    } else {
      getImage(false);
    }
  }

  Future getImage(bool result) async {
    if (result) {
      var _image = await ImagePicker.pickImage(source: ImageSource.camera);
      if (_image != null) {
        setState(() {
          _addServiceModel..files.add(_image);
        });
      }
    } else {
      var _image = await ImagePicker.pickImage(source: ImageSource.gallery);
      if (_image != null) {
        setState(() {
          _addServiceModel..files.add(_image);
        });
      }
    }
  }

  createRequest() async {
    if (_formKey.currentState.validate()) {
      _formKey.currentState.save();
      if (_addServiceModel.requestTypeId != null &&
          _addServiceModel.requestTypeId.isNotEmpty) {
        if (_addServiceModel.propertyId != null &&
            _addServiceModel.propertyId.isNotEmpty) {
          /*if (_addServiceModel.files != null &&
              _addServiceModel.files.length != 0) {*/
          setState(() {
            showLoader = true;
          });
          CommentResponse response =
              await Repository().addServiceRequest(_addServiceModel);
          if (response == null) {
            Utility.showErrorSnackBar(_scaffoldKey, Config.SERVER_ERROR);
          } else if (response.status) {
            Utility.showSuccessSnackBar(_scaffoldKey, response.message);
            Future.delayed(Duration(milliseconds: 500), () {
              Navigator.of(context).pop();
            });
          } else {
            Utility.showSuccessSnackBar(_scaffoldKey, response.message);
          }
          setState(() {
            showLoader = false;
          });
          /*} else {
            Utility.showErrorSnackBar(_scaffoldKey, "Add attachment.");
          }*/
        } else {
          Utility.showErrorSnackBar(_scaffoldKey, "Select property.");
        }
      } else {
        Utility.showErrorSnackBar(_scaffoldKey, "Select Request type.");
      }
    }
  }

  @override
  void initState() {
    getRequestTypeList();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
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
      body: showLoader
          ? _loader()
          : responseMsg.isNotEmpty ? _errorMsg() : _buildBody(),
      bottomNavigationBar: _bottomButtons(),
    );
  }

  _buildBody() {
    return SafeArea(
        top: false,
        bottom: false,
        child: Form(
            key: _formKey,
            child: SingleChildScrollView(
              physics: BouncingScrollPhysics(),
              child: Padding(
                padding: const EdgeInsets.fromLTRB(14, 20, 14, 10),
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
                          _addServiceModel.title = value;
                        },
                        validator: _addServiceModel.titleValidate,
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
                          _addServiceModel.description = value;
                        },
                        validator: _addServiceModel.descValidate,
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
                      text: _addServiceModel.requestTypeName.isEmpty
                          ? "Select"
                          : _addServiceModel.requestTypeName,
                      onPressed: () {
                        _showRequestTypePicker();
                      },
                    ),
                    const SizedBox(height: 20),
                    LabelText("Property"),
                    DropDownView(
                      text: _addServiceModel.propertyName.isEmpty
                          ? "Select"
                          : _addServiceModel.propertyName,
                      onPressed: () {
                        _showPropertyPicker();
                      },
                    ),
                    const SizedBox(height: 20),
                    LabelText("Attachment"),
                    const SizedBox(height: 10),
                    Container(
                      child: ListView.builder(
                        shrinkWrap: true,
                        physics: ClampingScrollPhysics(),
                        itemBuilder: (context, index) {
                          return Stack(
                            children: <Widget>[
                              Container(
                                margin: const EdgeInsets.all(10),
                                padding: const EdgeInsets.all(5),
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(5),
                                    border: Border.all(color: Colors.grey)),
                                child: Column(
                                  crossAxisAlignment:
                                      CrossAxisAlignment.stretch,
                                  children: <Widget>[
                                    Icon(
                                      Icons.insert_drive_file,
                                      color: Colors.grey[600],
                                      size: 50,
                                    ),
                                    Text(
                                      path.basename(
                                          _addServiceModel.files[index].path),
                                      textAlign: TextAlign.center,
                                    ),
                                  ],
                                ),
                              ),
                              InkWell(
                                onTap: () {
                                  setState(() {
                                    _addServiceModel.files.removeAt(index);
                                  });
                                },
                                child: CircleAvatar(
                                  radius: 16,
                                  backgroundColor: Colors.red,
                                  child: Icon(Icons.clear),
                                ),
                              )
                            ],
                          );
                        },
                        itemCount: _addServiceModel.files.length,
                      ),
                    ),
                    const SizedBox(height: 10),
                    AttachmentView(
                      onPressed: () {
                        _showImagePicker();
                      },
                    ),
                  ],
                ),
              ),
            )));
  }

  _loader() {
    return Center(child: CommonLoader());
  }

  _errorMsg() {
    return Center(
      child: Text(responseMsg),
    );
  }

  _showRequestTypePicker() {
    String requestType = '';
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
                          if (requestType.isEmpty) {
                            _addServiceModel.requestTypeName =
                                _requestTypeList[0].name;
                            _addServiceModel.requestTypeId =
                                _requestTypeList[0].id;
                          }
                          setState(() {});
                          Navigator.of(context).pop();
                        },
                      )
                    ],
                  ),
                  Expanded(
                    child: CupertinoPicker(
                      backgroundColor: Colors.grey[300],
                      itemExtent: 32,
                      children: List<Widget>.generate(_requestTypeList.length,
                          (index) {
                        return Center(
                          child: Text("${_requestTypeList[index].name}"),
                        );
                      }),
                      onSelectedItemChanged: (index) {
                        requestType = _requestTypeList[index].name;
                        _addServiceModel.requestTypeName =
                            _requestTypeList[index].name;
                        _addServiceModel.requestTypeId =
                            _requestTypeList[index].id;
                      },
                    ),
                  ),
                ],
              ),
            ),
          );
        });
  }

  _showPropertyPicker() {
    String propertyType = '';
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
                          if (propertyType.isEmpty) {
                            _addServiceModel.propertyName =
                                _propertyList[0].name;
                            _addServiceModel.propertyId = _propertyList[0].id;
                          }
                          setState(() {});
                          Navigator.of(context).pop();
                        },
                      )
                    ],
                  ),
                  Expanded(
                    child: CupertinoPicker(
                      backgroundColor: Colors.grey[300],
                      itemExtent: 32,
                      children:
                          List<Widget>.generate(_propertyList.length, (index) {
                        return Center(
                          child: Text("${_propertyList[index].name}"),
                        );
                      }),
                      onSelectedItemChanged: (index) {
                        propertyType = _propertyList[index].name;
                        _addServiceModel.propertyName =
                            _propertyList[index].name;
                        _addServiceModel.propertyId = _propertyList[index].id;
                      },
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
                onPressed: () {
                  createRequest();
                }),
          ),
          const SizedBox(
            width: 10,
          ),
          Expanded(
            child: CommonButton(
                text: "Cancel",
                bgColor: Theme.of(context).accentColor,
                onPressed: () {
                  Navigator.of(context).pop();
                }),
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
                /*Icon(
                  Icons.arrow_drop_down,
                  color: Colors.black,
                )*/
                Image.asset('assets/icon/drop_down_arrow.png')
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
              ),
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
  String requestTypeName = '';
  String requestTypeId = '';
  String propertyName = '';
  String propertyId = '';
  List<File> files;

  AddServiceModel({
    this.title,
    this.description,
    this.requestTypeName,
    this.requestTypeId,
    this.propertyName,
    this.propertyId,
    this.files,
  });

  String titleValidate(String value) {
    if (value.isNotEmpty) {
      return null;
    } else {
      return "Enter title.";
    }
  }

  String descValidate(String value) {
    if (value.isNotEmpty) {
      return null;
    } else {
      return "Enter description.";
    }
  }
}
