//Documents Screen
import 'dart:async';
import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:easyleases_tenant/api_client/api_client.dart';

import 'package:easyleases_tenant/api_client/repository.dart';
import 'package:easyleases_tenant/config/config.dart';
import 'package:easyleases_tenant/model/delete_user_document_response.dart';
import 'package:easyleases_tenant/model/documents_list_response.dart';
import 'package:easyleases_tenant/model/get_user_documents_response.dart';
import 'package:easyleases_tenant/model/update_user_document_request.dart';
import 'package:easyleases_tenant/model/update_user_document_response.dart';
import 'package:easyleases_tenant/screen/service_request/add_service_request_page.dart';
import 'package:easyleases_tenant/screen/show_full_screen_image.dart';
import 'package:easyleases_tenant/util/utility.dart';
import 'package:easyleases_tenant/widget/button.dart';
import 'package:easyleases_tenant/widget/common_loader.dart';
import 'package:easyleases_tenant/widget/label_text.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as path;
import 'package:pdf_render/pdf_render_widgets.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:webview_flutter/webview_flutter.dart';

class MyDocuments extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return MyDocumentsState();
  }
}

class MyDocumentsState extends State<MyDocuments> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  DocumentListResponse _documentListResponse;
  GetUserDocumentsResponse _getUserDocumentsResponse;
  UpdateDocumentRequest _documentRequest = UpdateDocumentRequest();
  File image;
  String responseMsg = '';
  bool showLoader = true;
  String documentType = '';
  int documentId;
  ScrollController _controller;
  bool showRightArrow = false;
  bool showLeftArrow = false;
  static const scale = 100.0 / 72.0;
  final flutterWebviewPlugin = new FlutterWebviewPlugin();

  @override
  void initState() {
    _controller = ScrollController();
    _controller.addListener(_scrollListener);
    _getDocumentList();
    _getUserDocument();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      body: showLoader ? _loader() : _getUserDocumentsResponse == null ? _errorMsg() : _buildBody(),
      bottomNavigationBar: showLoader ? Container(height: 1) : _bottomButtons(),
    );
  }

  _buildBody() {
    return ListView(
      children: <Widget>[
        _getUserDocumentsResponse.userDocuments.isEmpty
            ? Container()
            : Container(
                height: 210,
                width: double.infinity,
                child: Stack(
                  children: <Widget>[
                    Container(
                        margin: EdgeInsets.only(top: 10, bottom: 20),
                        height: 200,
                        child: ListView.builder(
                            shrinkWrap: true,
                            controller: _controller,
                            physics: BouncingScrollPhysics(),
                            scrollDirection: Axis.horizontal,
                            itemCount: _getUserDocumentsResponse.userDocuments.length,
                            itemBuilder: (context, index) {
                              return Column(
                                mainAxisSize: MainAxisSize.min,
                                children: <Widget>[
                                  Container(
                                    margin: EdgeInsets.all(10),
                                    decoration: BoxDecoration(
                                      color: Colors.grey.withOpacity(.5),
                                      borderRadius: BorderRadius.all(Radius.circular(8)),
                                    ),
                                    height: 140,
                                    width: 170,
                                    child: Stack(
                                      children: <Widget>[
                                        Align(
                                          alignment: Alignment.center,
                                          child: CommonLoader(),
                                        ),
                                        _checkExtension(_getUserDocumentsResponse.userDocuments[index].proofUrl) ,
                                        Align(
                                          alignment: Alignment.bottomRight,
                                          child: InkWell(
                                            onTap: () {
                                              deleteDialog(context, _getUserDocumentsResponse.userDocuments[index].id);
                                              setState(() {});
                                            },
                                            child: Container(
                                              decoration: BoxDecoration(
                                                  color: Colors.redAccent,
                                                  borderRadius: BorderRadius.only(bottomRight: Radius.circular(8))),
                                              padding: EdgeInsets.all(5),
                                              child: Image.asset(
                                                "assets/icon/delete_icon.png",
                                                height: 30,
                                                width: 30,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Expanded(
                                    child: FittedBox(child: Text(_getDocTitle(_getUserDocumentsResponse.userDocuments[index].proofType))),
                                  ),
                                ],
                              );
                            })),
                    Align(
                      alignment: Alignment(
                        1,
                        -.2,
                      ),
                      child: Container(
                        height: 30,
                        width: 30,
                        child: showRightArrow
                            ? InkWell(
                                onTap: () {
                                  moveToRight();
                                },
                                child: Icon(
                                  Icons.arrow_forward_ios,
                                  size: 35,
                                  color: Colors.black.withOpacity(.4),
                                ),
                              )
                            : Container(
                                height: 1,
                                width: 1,
                              ),
                      ),
                    ),
                    Align(
                      alignment: Alignment(-1, -.2),
                      child: showLeftArrow
                          ? InkWell(
                              onTap: () {
                                moveToLeft();
                              },
                              child: Icon(
                                Icons.arrow_back_ios,
                                size: 35,
                                color: Colors.black.withOpacity(.4),
                              ),
                            )
                          : Container(
                              height: 1,
                              width: 1,
                            ),
                    ),
                  ],
                ),
              ),
        Container(
          padding: EdgeInsets.all(20),
          decoration: BoxDecoration(color: Colors.grey.withOpacity(.3)),
          child: Text(
            'Upload New Document',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
        Container(
          padding: EdgeInsets.only(left: 25, right: 25, top: 40),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Text("Select Document Type"),
              DropDownView(
                text: documentType.isEmpty ? "Select" : documentType,
                onPressed: () {
                  _documentTypePicker();
                },
              ),
              SizedBox(height: 40),
              image != null
                  ? Container(
                      child: Stack(
                        children: <Widget>[
                          Container(
                            margin: const EdgeInsets.all(10),
                            padding: const EdgeInsets.all(5),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(5), border: Border.all(color: Colors.grey)),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: <Widget>[
                                Icon(
                                  Icons.insert_drive_file,
                                  color: Colors.grey[600],
                                  size: 50,
                                ),
                                Text(
                                  path.basename(image.path),
                                  textAlign: TextAlign.center,
                                )
                              ],
                            ),
                          ),
                          InkWell(
                            onTap: () {
                              setState(() {
                                image = null;
                              });
                            },
                            child: CircleAvatar(
                              radius: 16,
                              backgroundColor: Colors.red,
                              child: Icon(Icons.clear),
                            ),
                          )
                        ],
                      ),
                    )
                  : AttachmentView(
                      onPressed: () {
                        _showImagePicker();
                      },
                    ),
            ],
          ),
        ),
      ],
    );
  }

  _deleteDocument(int documentID) async {
    showLoader = true;
    DeleteUserDocumentsResponse response = await Repository().deleteUserDocument(documentID);
    if (response == null) {
      showLoader = false;
      responseMsg = Config.SERVER_ERROR;
      //Utility.showErrorSnackBar(_scaffoldKey, responseMsg);
      _showDialog("Errer", responseMsg);
    } else if (!response.status) {
      showLoader = false;
      responseMsg = response.message;
    } else {
      showLoader = false;
      //Utility.showSuccessSnackBar(_scaffoldKey, response.message);
      _showDialog("Success", 'Document deleted successfully.');
      if (_getUserDocumentsResponse.userDocuments.length < 2) {
        setState(() {
          showRightArrow = false;
          showLeftArrow = false;
        });
      }
    }
    _getUserDocument();
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
                  _submitForm();
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
                  image = null;
                  documentType = '';
                  _getUserDocument();
                }),
          ),
        ],
      ),
    );
  }

  _checkExtension(String fileName) {
   String extension= Utility.getFilerExtension(fileName);
    if (extension=='pdf') {
      return InkWell(
        onTap: (){
          launchURL(fileName);
        },
        child: Container (
            height: 140,
            width: 170,
            child: Center(
                child: Icon(
                  Icons.picture_as_pdf,
                  size: 80,
                  color: Colors.white,
                )),
            decoration: BoxDecoration(
              color: Colors.grey[400],
              borderRadius: BorderRadius.all(Radius.circular(8)),
            )),
      );
    }
    else if(extension=="jpeg"||extension=="png"||extension=="jpg"||extension== "raw"||extension=="tiff"){
      return  InkWell(
        onTap: (){
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => ShowFullScreenImage(fileName)),
          );
        },
        child: Container(
          decoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(8)),
              image: DecorationImage(
                  image: CachedNetworkImageProvider(fileName),
                  fit: BoxFit.cover)),
        ),
      );
    }
    else{
       return Container (
          height: 140,
          width: 170,
          child: Center(
              child: Icon(
                Icons.insert_drive_file,
                size: 80,
                color: Colors.white,
              )),
          decoration: BoxDecoration(
            color: Colors.grey[400],
            borderRadius: BorderRadius.all(Radius.circular(8)),
          ));
    }
  }

  _getDocTitle(String position) {
    switch (position) {
      case "1":
        {
          return "Driving License";
        }
        break;
      case "2":
        {
          return "Aadhaar Card";
        }
        break;
      case "3":
        {
          return "Passport";
        }
        break;
      case "4":
        {
          return "Voter ID";
        }
        break;
      case "5":
        {
          return "Utility Bill (Gas, Water, Electricity, Landline)";
        }
        break;
      case "6":
        {
          return "Letter from Employer";
        }
        break;
      case "7":
        {
          return "Bank Statement or Passbook";
        }
        break;
      case "8":
        {
          return "Not Available";
        }
        break;
      case "9":
        {
          return "PAN Card";
        }
        break;
    }
  }

  _showImagePicker() async {
    File file = await FilePicker.getFile(type: FileType.ANY);
    if (file != null) {
      setState(() {
        image = file;
      });
    }
  }

  _documentTypePicker() {
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
                        child: Text("Select", style: TextStyle(color: Colors.blue)),
                        onPressed: () {
                          if (documentType.isEmpty) {
                            documentType = _documentListResponse.proofTypes[0].name;
                            documentId = _documentListResponse.proofTypes[0].id;
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
                      children: List<Widget>.generate(_documentListResponse.proofTypes.length, (index) {
                        return Center(
                          child: Text(
                            "${_documentListResponse.proofTypes[index].name}",
                            style: TextStyle(fontSize: 14),
                          ),
                        );
                      }),
                      onSelectedItemChanged: (index) {
                        documentType = _documentListResponse.proofTypes[index].name;
                        documentId = _documentListResponse.proofTypes[index].id;
                      },
                    ),
                  ),
                ],
              ),
            ),
          );
        });
  }

  checkPermission(bool result) async {
    if (result) {
      getImage(result);
    } else {
      getImage(false);
    }
  }

  _loader() {
    return Center(child: CommonLoader());
  }

  _errorMsg() {
    return Center(
      child: Text(responseMsg),
    );
  }

  Future getImage(bool result) async {
    if (result) {
      var _image = await ImagePicker.pickImage(source: ImageSource.camera);
      if (_image != null) {
        image = _image;
        setState(() {});
      }
    } else {
      var _image = await ImagePicker.pickImage(source: ImageSource.gallery);
      if (_image != null) {
        image = _image;
        setState(() {});
      }
    }
  }

  Future _getDocumentList() async {
    _documentListResponse = await Repository().getDocumentsType();
    if (_documentListResponse == null) {
      responseMsg = Config.SERVER_ERROR;
      Utility.showErrorSnackBar(_scaffoldKey, responseMsg);
      setState(() {
        showLoader = false;
      });
    } else {
      setState(() {
        showLoader = false;
      });
    }
  }

  Future _getUserDocument() async {
    _getUserDocumentsResponse = await Repository().getUserDocuments();
    if (_getUserDocumentsResponse != null && _getUserDocumentsResponse.userDocuments != null) {
      setState(() {
        showLoader = false;
      });
    } else {
      responseMsg = Config.SERVER_ERROR;
      Utility.showErrorSnackBar(_scaffoldKey, responseMsg);
      setState(() {
        showLoader = false;
      });
    }
  }

  _submitForm() async {
    if (documentType.isNotEmpty) {
      if (image != null) {
        setState(() {
          _documentRequest.documentFile = image;
          _documentRequest.documentType = documentId.toString();
          showLoader = true;
        });
        UpdateUserDocumentsResponse updateUserDocumentsResponse =
            await Repository().updateUserDocuments(_documentRequest);
        print('Update user documents response');
        print(updateUserDocumentsResponse);
        setState(() {
          showLoader = false;
        });
        if (updateUserDocumentsResponse == null) {
          Utility.showSuccessSnackBar(_scaffoldKey, Config.SERVER_ERROR);
        } else {
          if (updateUserDocumentsResponse.status) {
            _showDialog("Success", updateUserDocumentsResponse.message);
            if (_getUserDocumentsResponse.userDocuments.length < 2) {
              setState(() {
                showRightArrow = false;
                showLeftArrow = false;
              });
            }
            image = null;
            documentType = '';
            _getUserDocument();
            // Utility.showSuccessSnackBar(_scaffoldKey, bankDetailsResponse.message);
          } else {
            _showDialog("Failed", updateUserDocumentsResponse.message);
            //Utility.showErrorSnackBar(_scaffoldKey, bankDetailsResponse.message);
          }
        }
      } else {
        Utility.showErrorSnackBar(_scaffoldKey, 'Please upload document image.');
      }
    } else {
      Utility.showErrorSnackBar(_scaffoldKey, 'Please select document type.');
    }
  }

  _showDialog(String title, String message) {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text(title),
            content: Text(message),
            actions: <Widget>[
              FlatButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text("Ok"))
            ],
          );
        });
  }

  deleteDialog(BuildContext context, int id) {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text("Confirmation"),
            content: Text("Are you sure, you want to delete document?"),
            actions: <Widget>[
              FlatButton(
                child: Text("No"),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
              FlatButton(
                child: Text("Yes"),
                onPressed: () {
                  Navigator.of(context).pop();
                  _deleteDocument(id);
                },
              )
            ],
          );
        });
  }


  _scrollListener() {
    if (_getUserDocumentsResponse.userDocuments.length > 2) {
      if (_controller.offset >= _controller.position.maxScrollExtent && !_controller.position.outOfRange) {
        setState(() {
          showLeftArrow = true;
          showRightArrow = false;
        });
      } else if (_controller.offset <= _controller.position.minScrollExtent && !_controller.position.outOfRange) {
        setState(() {
          showLeftArrow = false;
          showRightArrow = true;
        });
      } else {
        setState(() {
          showLeftArrow = true;
          showRightArrow = true;
        });
      }
    } else {
      setState(() {
        showRightArrow = false;
        showLeftArrow = false;
      });
    }
  }

  void moveToRight() {
    _controller.animateTo(_controller.offset + 200.0, curve: Curves.linear, duration: Duration(milliseconds: 500));
  }

  void moveToLeft() {
    _controller.animateTo(_controller.offset - 200.0, curve: Curves.linear, duration: Duration(milliseconds: 500));
  }

  launchURL(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }


  void showImageDialog(String fileName ) {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return AlertDialog(
          /*title: Center(child: Text('Alert')),*/
          contentPadding: EdgeInsets.all(0),
          content: Container(
          height: double.infinity,
            width: double.infinity,
            child: Stack(
              children: <Widget>[
                CachedNetworkImage(
                  imageUrl: fileName,
                  placeholder: (context, url) => new CircularProgressIndicator(
                    strokeWidth: 1,
                  ),
                  errorWidget: (context, url, error) => new Icon(
                    Icons.broken_image,
                    size: 60,
                    color: Colors.grey,
                  ),
                  fit: BoxFit.cover,
                ),

                Align(
                  alignment: Alignment.bottomCenter,
                  child: FlatButton(
                      child: Text('Ok'),
                      onPressed: () {
                        Navigator.of(context).pop();
                      }),
                )

              ],

            ),
          ),
        );
      },
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
