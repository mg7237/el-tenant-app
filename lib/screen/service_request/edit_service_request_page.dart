import 'dart:io';

import 'package:easyleases_tenant/api_client/repository.dart';
import 'package:easyleases_tenant/config/config.dart';
import 'package:easyleases_tenant/model/comment_request.dart';
import 'package:easyleases_tenant/model/comment_response.dart';
import 'package:easyleases_tenant/model/request_type_list_response.dart';
import 'package:easyleases_tenant/model/service_detail_response.dart';
import 'package:easyleases_tenant/model/service_request_list_response.dart';
import 'package:easyleases_tenant/model/status_list_response.dart';
import 'package:easyleases_tenant/util/utility.dart';
import 'package:easyleases_tenant/widget/EnsureVisibleWhenFocused.dart';
import 'package:easyleases_tenant/widget/common_loader.dart';
import 'package:easyleases_tenant/widget/label_text.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:easyleases_tenant/widget/button.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:intl/intl.dart';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:share/share.dart';

class EditServiceRequestPage extends StatefulWidget {
  final SrList item;

  EditServiceRequestPage(this.item);

  @override
  _EditServiceRequestPageState createState() => _EditServiceRequestPageState();
}

class _EditServiceRequestPageState extends State<EditServiceRequestPage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  final GlobalKey<FormState> _formKey = new GlobalKey<FormState>();
  FocusNode _focusNodeTitle = new FocusNode();
  FocusNode _focusNodeDescription = new FocusNode();
  FocusNode _focusNodeComment = new FocusNode();
  static final TextEditingController _titleController = TextEditingController();
  static final TextEditingController _descriptionController =
      TextEditingController();
  static final TextEditingController _commentController =
      TextEditingController();
  EditServiceModel _addServiceModel = EditServiceModel();
  List<TypesList> _requestTypeList;
  List<StatusList> _statusList;
  ServiceDetailResponse response;
  bool showLoader = true, uploadAttachment = false, addComment = false;
  String responseMsg = '';

  setValue() {
    _titleController.text = response.title;
    _descriptionController.text = response.description;

    _addServiceModel.title = response.title;
    _addServiceModel.description = response.description;
    _addServiceModel.requestTypeId = response.requestType.toString();
    _addServiceModel.requestTypeName = widget.item.type;
    _addServiceModel.statusId = response.requestStatus.toString();
    _addServiceModel.statusName = widget.item.status;
  }

  getRequestDetails() async {
    response =
        await Repository().getServiceDetails(widget.item.srId.toString());
    if (response == null) {
      responseMsg = Config.SERVER_ERROR;
      Utility.showErrorSnackBar(_scaffoldKey, responseMsg);
    } else {
      setValue();
    }
    setState(() {
      showLoader = false;
      uploadAttachment = false;
      addComment = false;
    });
  }

  getRequestTypeList() async {
    RequestTypeListResponse response = await Repository().getRequestTypeList();
    if (response.status) {
      _requestTypeList = response.typesList;
    } else {}
  }

  getStatusList() async {
    StatusListResponse response = await Repository().getStatusList();
    if (response.status) {
      _statusList = response.statusList;
    } else {}
  }

  comment() async {
    setState(() {
      addComment = true;
    });
    CommentRequest request = CommentRequest();
    request.comment = _commentController.text;
    CommentResponse commentResponse =
        await Repository().comment(widget.item.srId.toString(), request);
    if (commentResponse == null) {
      Utility.showSuccessSnackBar(_scaffoldKey, Config.SERVER_ERROR);
    } else if (commentResponse.status) {
      /*Comment item = Comment();
      item.comment = _commentController.text;
      item.commentBy = '';
      item.createdDate = DateTime.now().toIso8601String();
      item.id = 0;
      response.comments.add(item);
      _commentController.text = '';*/
      _commentController.text = '';
      Utility.showSuccessSnackBar(_scaffoldKey, commentResponse.message);
    } else {
      Utility.showErrorSnackBar(_scaffoldKey, commentResponse.message);
    }
    getRequestDetails();
  }

  deleteAttachment(String id) async {
    await Repository().deleteAttachment(id);
  }

  addAttachment(File file) async {
    setState(() {
      uploadAttachment = true;
    });
    CommentResponse commentResponse = await Repository()
        .addAttachmentRequest(widget.item.srId.toString(), file);
    if (commentResponse == null) {
      Utility.showSuccessSnackBar(_scaffoldKey, Config.SERVER_ERROR);
    } else if (commentResponse.status) {
      Utility.showSuccessSnackBar(_scaffoldKey, commentResponse.message);
    } else {
      Utility.showErrorSnackBar(_scaffoldKey, commentResponse.message);
    }
    getRequestDetails();
  }

  updateRequest() async {
    if (_formKey.currentState.validate()) {
      _formKey.currentState.save();
      setState(() {
        showLoader = true;
      });
      CommentResponse commentResponse = await Repository()
          .updateServiceRequest(widget.item.srId.toString(), _addServiceModel);
      if (commentResponse == null) {
        Utility.showSuccessSnackBar(_scaffoldKey, Config.SERVER_ERROR);
      } else if (commentResponse.status) {
        Utility.showSuccessSnackBar(_scaffoldKey, commentResponse.message);
      } else {
        Utility.showErrorSnackBar(_scaffoldKey, commentResponse.message);
      }
      setState(() {
        showLoader = false;
      });
    }
    //getRequestDetails();
  }

  _showImagePicker() async {
    bool checkCameraPermission = false;
    File file = await FilePicker.getFile(type: FileType.ANY);
    if (file != null) {
      addAttachment(file);
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

  void createFolder() async {
    Map<PermissionGroup, PermissionStatus> permissions =
        await PermissionHandler().requestPermissions([PermissionGroup.storage]);
    if (permissions[PermissionGroup.storage] == PermissionStatus.granted) {
      String directory = (await getExternalStorageDirectory()).path;
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
    if (Platform.isIOS) {
      Share.share(url);
    }else {
      String directory = (await getExternalStorageDirectory()).path;
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
    getRequestDetails();
    getRequestTypeList();
    getStatusList();
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
          child: showLoader
              ? _loader()
              : response == null
                  ? _errorMsg()
                  : Form(
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
                                    _addServiceModel.title = value;
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
                                    _addServiceModel.description = value;
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
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: <Widget>[
                                        LabelText("Request Type"),
                                        DropDownView(
                                          text: _addServiceModel
                                                  .requestTypeName.isEmpty
                                              ? "Select"
                                              : _addServiceModel
                                                  .requestTypeName,
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
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: <Widget>[
                                        LabelText("Status"),
                                        DropDownView(
                                          text: _addServiceModel
                                                  .statusName.isEmpty
                                              ? "Select"
                                              : _addServiceModel.statusName,
                                          onPressed: () {
                                            _showStatusPicker();
                                          },
                                        ),
                                      ],
                                    ),
                                  )
                                ],
                              ),
                              const SizedBox(height: 20),
                              LabelText("Assigned To"),
                              new TextFormField(
                                initialValue:
                                    "${response.supportName} ${response.supportEmail} , ${response.supportContact}",
                                enabled: false,
                                decoration: const InputDecoration(
                                  border: const UnderlineInputBorder(),
                                ),
                                onSaved: (String value) {
                                  //TODO
                                },
                                style: TextStyle(color: Colors.grey[700]),
                                keyboardType: TextInputType.text,
                                maxLines: 2,
                                minLines: 1,
                                textInputAction: TextInputAction.done,
                              ),
                              const SizedBox(height: 20),
                              Container(
                                child: ListView.builder(
                                  shrinkWrap: true,
                                  physics: ClampingScrollPhysics(),
                                  itemBuilder: (context, index) {
                                    return Stack(
                                      children: <Widget>[
                                        InkWell(
                                          onTap: () {
                                            _downloadPdf(response
                                                .attachments[index]
                                                .attachmentUrl);
                                          },
                                          child: Container(
                                            margin: const EdgeInsets.all(10),
                                            padding: const EdgeInsets.all(5),
                                            decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(5),
                                                border: Border.all(
                                                    color: Colors.grey)),
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
                                                  path.basename(response
                                                      .attachments[index]
                                                      .attachmentUrl),
                                                  textAlign: TextAlign.center,
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                        InkWell(
                                          onTap: () {
                                            deleteAttachment(response
                                                .attachments[index].id
                                                .toString());
                                            setState(() {
                                              response.attachments
                                                  .removeAt(index);
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
                                  itemCount: response.attachments.length,
                                ),
                              ),
                              LabelText("Attachment"),
                              const SizedBox(height: 14),
                              uploadAttachment
                                  ? Container(height: 30,width: 0,
                              child:Center(child: CommonLoader()))
                                  : AttachmentView(
                                      onPressed: () {
                                        _showImagePicker();
                                      },
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
                                onPressed: () {
                                  comment();
                                },
                              ),
                              const SizedBox(height: 14),
                              response.comments != null
                                  ? ListView.separated(
                                      physics: ClampingScrollPhysics(),
                                      shrinkWrap: true,
                                      itemBuilder: (context, index) {
                                        Comment comment =
                                            response.comments[index];
                                        return _rowComment(index, comment);
                                      },
                                      separatorBuilder: (context, index) {
                                        return Container(
                                          color: Colors.grey[300],
                                          height: 1,
                                        );
                                      },
                                      itemCount: response.comments.length,
                                    )
                                  : Container(),
                            ],
                          ),
                        ),
                      ))),
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

  _showStatusPicker() {
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
                            _addServiceModel.statusName = _statusList[0].name;
                            _addServiceModel.statusId =
                                _statusList[0].id.toString();
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
                          List<Widget>.generate(_statusList.length, (index) {
                        return Center(
                          child: Text("${_statusList[index].name}"),
                        );
                      }),
                      onSelectedItemChanged: (index) {
                        requestType = _statusList[index].name;
                        _addServiceModel.statusName = _statusList[index].name;
                        _addServiceModel.statusId =
                            _statusList[index].id.toString();
                      },
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
              onPressed: () {
                updateRequest();
              }),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: CommonButton(
              text: "Cancel",
              bgColor: Theme.of(context).accentColor,
              onPressed: () {
                Navigator.of(context).pop();
              }),
        ),
      ],
    );
  }

  _rowComment(int index, Comment comment) {
    return Container(
      padding: const EdgeInsets.only(top: 25, bottom: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Text(
            comment.commentBy,
            style: TextStyle(
              fontWeight: FontWeight.w500,
              fontSize: 14,
              color: Colors.blue,
            ),
          ),
          const SizedBox(height: 3),
          Text(
            DateFormat("dd MMM yyyy / hh:mm a")
                .format(DateTime.parse(comment.createdDate)),
            /*"15 May 2019 / 5:30 pm",*/
            style: TextStyle(color: Colors.grey, fontSize: 12),
          ),
          const SizedBox(height: 10),
          Text(
            comment.comment != null ? comment.comment : '',
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

class EditServiceModel {
  String title = '';
  String description = '';
  String requestTypeName = '';
  String requestTypeId = '';
  String statusName = '';
  String statusId = '';
  String propertyName = '';
  String propertyId = '';

  EditServiceModel({
    this.title,
    this.description,
    this.requestTypeName,
    this.requestTypeId,
    this.propertyName,
    this.statusId,
    this.statusName,
    this.propertyId,
  });

  Map<String, dynamic> toMap() => {
        "requestTitle": title,
        "requestDescription": description,
        "requestStatus": statusId,
        "requestType": requestTypeId,
        "propertyId": propertyId,
      };

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
