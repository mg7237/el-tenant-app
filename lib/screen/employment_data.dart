import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter_cupertino_date_picker/flutter_cupertino_date_picker.dart';
import 'package:easyleases_tenant/api_client/repository.dart';
import 'package:easyleases_tenant/config/config.dart';
import 'package:easyleases_tenant/model/get_employment_response.dart';
import 'package:easyleases_tenant/model/update_employment_details-request.dart';
import 'package:easyleases_tenant/model/update_employment_details_response.dart';
import 'package:easyleases_tenant/util/utility.dart';
import 'package:easyleases_tenant/widget/EnsureVisibleWhenFocused.dart';
import 'package:easyleases_tenant/widget/button.dart';
import 'package:easyleases_tenant/widget/common_loader.dart';
import 'package:easyleases_tenant/widget/label_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart' as path;
import 'package:image_picker/image_picker.dart';
import 'package:date_format/date_format.dart';
import 'package:intl/intl.dart';

class EmploymentData extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return EmploymentDataState();
  }
}

class EmploymentDataState extends State<EmploymentData> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey = new GlobalKey<RefreshIndicatorState>();
  FocusNode _empName = FocusNode();
  FocusNode _empEmail = FocusNode();
  FocusNode _empID = FocusNode();
  FocusNode _empStartDate = FocusNode();
  File image;
  bool isEdit = false;
  bool showLoader = true;
  String responseMsg = '';

  static final TextEditingController _nameController = TextEditingController();
  static final TextEditingController _emailController = TextEditingController();
  static final TextEditingController _idController = TextEditingController();
  static final TextEditingController _startDateController = TextEditingController();
  UpdateEmploymentDetailsRequest _employmentDetailsRequest = UpdateEmploymentDetailsRequest();
  EmploymentResponse employmentResponse;

  @override
  void initState() {
    _getEmploymentData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      body: showLoader ? _loader() : _buildBody(),
      bottomNavigationBar: showLoader ? Container(height: 1) : _bottomButtons(),
    );
  }

  _buildBody() {
    return ListView(
      physics: BouncingScrollPhysics(),
      padding: const EdgeInsets.fromLTRB(20, 16, 16, 20),
      children: <Widget>[
        const SizedBox(height: 14.0),
        Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              LabelText("Employer Name"),
              EnsureVisibleWhenFocused(
                focusNode: _empName,
                child: new TextFormField(
                  decoration: const InputDecoration(
                    border: const UnderlineInputBorder(),
                    hintText: 'Enter name',
                  ),
                  onSaved: (value) => _employmentDetailsRequest.employerName = value,
                  // validator: _employmentDetailsRequest.nameValidate,
                  controller: _nameController,
                  focusNode: _empName,
                  keyboardType: TextInputType.text,
                  textInputAction: TextInputAction.next,
                  onFieldSubmitted: (value) {
                    fieldFocusChange(context, _empName, _empEmail);
                  },
                ),
              ),
              const SizedBox(height: 20.0),
              LabelText("Employer Email"),
              EnsureVisibleWhenFocused(
                focusNode: _empEmail,
                child: new TextFormField(
                  decoration: const InputDecoration(
                    border: const UnderlineInputBorder(),
                    hintText: 'Enter email id',
                  ),
                  onSaved: (value) => _employmentDetailsRequest.employerEmail = value,
                  //validator: _employmentDetailsRequest.emailValidate,
                  controller: _emailController,
                  focusNode: _empEmail,
                  keyboardType: TextInputType.emailAddress,
                  textInputAction: TextInputAction.next,
                  onFieldSubmitted: (value) {
                    fieldFocusChange(context, _empEmail, _empID);
                  },
                ),
              ),
              const SizedBox(height: 20.0),
              LabelText("Employer ID"),
              EnsureVisibleWhenFocused(
                focusNode: _empID,
                child: new TextFormField(
                  decoration: const InputDecoration(
                    border: const UnderlineInputBorder(),
                    hintText: 'Enter ID',
                  ),
                  onSaved: (value) => _employmentDetailsRequest.employeeId = value,
                  //validator: _employmentDetailsRequest.emailValidate,
                  controller: _idController,
                  focusNode: _empID,
                  keyboardType: TextInputType.text,
                  textInputAction: TextInputAction.next,
                  onFieldSubmitted: (value) {
                    fieldFocusChange(context, _empID, _empStartDate);
                  },
                ),
              ),
              const SizedBox(height: 20.0),
              LabelText("Employer Start Date"),
              InkWell(
                onTap: () {
                  _datePicker();
                },
                child: EnsureVisibleWhenFocused(
                  focusNode: _empStartDate,
                  child: new TextFormField(
                    enabled: false,
                    decoration: const InputDecoration(
                      border: const UnderlineInputBorder(),
                      hintText: 'Enter start date',
                    ),
                    onSaved: (value) => _employmentDetailsRequest.employmentStartDate = value,
                    // validator: _employmentDetailsRequest.nameValidate,
                    controller: _startDateController,
                    focusNode: _empStartDate,
                    keyboardType: TextInputType.text,
                    textInputAction: TextInputAction.done,
                    validator: _employmentDetailsRequest.startDateValidate,
                    onFieldSubmitted: (value) {
                      fieldFocusChange(context, _empStartDate, _empStartDate);
                    },
                  ),
                ),
              ),
              const SizedBox(height: 20.0),
              LabelText("Employment Proof Image"),
              const SizedBox(height: 20.0),
              (employmentResponse.employmentProofUrl.isNotEmpty &&
                      employmentResponse.employmentProofUrl != null &&
                      image == null)
                  ? Container(
                      decoration: BoxDecoration(shape: BoxShape.circle,),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: CachedNetworkImage(
                          fit: BoxFit.cover,
                          height: 120,
                          imageUrl: employmentResponse.employmentProofUrl,
                          placeholder: (context, url) => Container(height: 30,width: 0,
                              child:Center(child: CommonLoader())),
                          errorWidget: (context, url, error) => new Icon(
                            Icons.broken_image,
                            size: 60,
                            color: Colors.grey,
                          ),
                        ),
                      ),
                    )
                  : Container(height: 1),
              const SizedBox(height: 10.0),
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
                  _getEmploymentData();
                }),
          ),
        ],
      ),
    );
  }

  _showImagePicker() {
    bool checkCameraPermission = false;
    showCupertinoModalPopup(
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
        });
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
          image = _image;
        });
      }
    } else {
      var _image = await ImagePicker.pickImage(source: ImageSource.gallery);
      if (_image != null) {
        setState(() {
          image = _image;
        });
      }
    }
  }

  Future _getEmploymentData() async {
    employmentResponse = await Repository().getEmploymentDetails();
    if (employmentResponse == null) {
      responseMsg = Config.SERVER_ERROR;
      Utility.showErrorSnackBar(_scaffoldKey, responseMsg);
      setState(() {
        showLoader = false;
      });
    } else {
      _setDataToController();
      setState(() {
        showLoader = false;
      });
    }
  }

  _setDataToController() {
    _nameController.text = employmentResponse.employerName;
    _emailController.text = employmentResponse.employerEmail;
    _idController.text = employmentResponse.employeeId;
    _startDateController.text = employmentResponse.employmentStartDate;
  }

  _submitForm() async {
    setState(() {
      _formKey.currentState.save();
      _employmentDetailsRequest.employmentProof = image;
      showLoader = true;
    });
    UpdateEmploymentDetailsResponse updateEmploymentDetailsResponse =
        await Repository().updateEmploymentDetails(_employmentDetailsRequest);
    setState(() {
      isEdit = false;
      showLoader = false;
    });
    if (updateEmploymentDetailsResponse == null) {
      Utility.showSuccessSnackBar(_scaffoldKey, Config.SERVER_ERROR);
    } else {
      if (updateEmploymentDetailsResponse.status) {
        _showDialog("Success", updateEmploymentDetailsResponse.message);
        image = null;
        _getEmploymentData();

        // Utility.showSuccessSnackBar(_scaffoldKey, bankDetailsResponse.message);
      } else {
        _showDialog("Failed", updateEmploymentDetailsResponse.message);
        //Utility.showErrorSnackBar(_scaffoldKey, bankDetailsResponse.message);
      }
    }
  }

  _loader() {
    return Center(child: CommonLoader());
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

  _datePicker() {
    //var format=  DateFormat('dd-mm-yyyy');
    DatePicker.showDatePicker(context,
        initialDateTime: DateTime.now(),
        maxDateTime: DateTime.now(),
        pickerMode: DateTimePickerMode.date,
        dateFormat: "dd-MMM-yyyy", onConfirm: (dateTime, List<int> index) {
      //  dateOfBirth=format.parse(dateTime.toString()).toString();
      print(dateTime);
      List<String> timeDate = dateTime.toString().split(' ');
      var format = DateFormat('dd-MM-yyyy');
      setState(() {
        // _startDateController.text =timeDate[0];
        _startDateController.text = format.format(dateTime);
      });
      // dateOfBirth=format.parse(timeDate[0]).toString();
    }, onCancel: () {});
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
