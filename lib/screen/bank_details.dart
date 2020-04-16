import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:easyleases_tenant/api_client/repository.dart';
import 'package:easyleases_tenant/config/config.dart';
import 'package:easyleases_tenant/model/get_bank_details_response.dart';
import 'package:easyleases_tenant/model/update_bank_details_request.dart';
import 'package:easyleases_tenant/model/update_bank_details_response.dart';
import 'package:easyleases_tenant/util/preference_connector.dart';
import 'package:easyleases_tenant/util/utility.dart';
import 'package:easyleases_tenant/widget/EnsureVisibleWhenFocused.dart';
import 'package:easyleases_tenant/widget/button.dart';
import 'package:easyleases_tenant/widget/common_loader.dart';
import 'package:easyleases_tenant/widget/label_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as path;
import 'package:date_format/date_format.dart';
import 'package:intl/intl.dart';

class BankDetails extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return BankDetailsState();
  }
}

class BankDetailsState extends State<BankDetails> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey = new GlobalKey<RefreshIndicatorState>();
  UpdateBankDetailsRequest _bankDetailsRequest = UpdateBankDetailsRequest();
  GetBankDetailsResponse getBankDetailsResponse;



  FocusNode _name = FocusNode();
  FocusNode _panNumber = FocusNode();
  FocusNode _bankName = FocusNode();
  FocusNode _iFSC = FocusNode();
  FocusNode _branchName = FocusNode();
  FocusNode _accountNumber = FocusNode();

  //FocusNode _checkImage = FocusNode();
  static final TextEditingController _nameController = TextEditingController();
  static final TextEditingController _panController = TextEditingController();
  static final TextEditingController _bankNameController = TextEditingController();
  static final TextEditingController _iFSCController = TextEditingController();
  static final TextEditingController _branchController = TextEditingController();
  static final TextEditingController _accountController = TextEditingController();

  //static final TextEditingController _checkController = TextEditingController();
  bool showLoader = true;
  File image;
  String responseMsg='';
  bool isEdit = false;

  @override
  void initState() {
    _getBankProfile();
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
              LabelText("Account Holder Number"),
              EnsureVisibleWhenFocused(
                focusNode: _name,
                child: new TextFormField(
                  decoration: const InputDecoration(
                    border: const UnderlineInputBorder(),
                    hintText: 'Enter account holder name',
                  ),
                  onSaved: (value) => _bankDetailsRequest.accountHolderName = value,
                  validator: _bankDetailsRequest.nameValidate,
                  controller: _nameController,
                  focusNode: _name,
                  keyboardType: TextInputType.text,
                  textInputAction: TextInputAction.next,
                  onFieldSubmitted: (value) {
                    fieldFocusChange(context, _name, _panNumber);
                  },
                ),
              ),
              const SizedBox(height: 20.0),
              LabelText("PAN Number"),
              EnsureVisibleWhenFocused(
                focusNode: _panNumber,
                child: new TextFormField(
                  decoration: const InputDecoration(
                    border: const UnderlineInputBorder(),
                    hintText: 'Enter PAN number',
                  ),
                  onSaved: (value) => _bankDetailsRequest.PAN = value,
                  validator: _bankDetailsRequest.panNumberValidate,
                  controller: _panController,
                  focusNode: _panNumber,
                  keyboardType: TextInputType.text,
                  textInputAction: TextInputAction.next,
                  onFieldSubmitted: (value) {
                    fieldFocusChange(context, _panNumber, _bankName);
                  },
                ),
              ),
              const SizedBox(height: 20.0),
              LabelText("Bank Name"),
              EnsureVisibleWhenFocused(
                focusNode: _bankName,
                child: new TextFormField(
                  decoration: const InputDecoration(
                    border: const UnderlineInputBorder(),
                    hintText: 'Enter bank name',
                  ),
                  onSaved: (value) => _bankDetailsRequest.bankName = value,
                  validator: _bankDetailsRequest.bankNameValidate,
                  controller: _bankNameController,
                  focusNode: _bankName,
                  keyboardType: TextInputType.text,
                  textInputAction: TextInputAction.next,
                  onFieldSubmitted: (value) {
                    fieldFocusChange(context, _bankName, _iFSC);
                  },
                ),
              ),
              const SizedBox(height: 20.0),
              LabelText("IFSC"),
              EnsureVisibleWhenFocused(
                focusNode: _iFSC,
                child: new TextFormField(
                  decoration: const InputDecoration(
                    border: const UnderlineInputBorder(),
                    hintText: 'Enter IFSC code',
                  ),
                  onSaved: (value) => _bankDetailsRequest.IFSC = value,
                  validator: _bankDetailsRequest.iFSCValidate,
                  controller: _iFSCController,
                  focusNode: _iFSC,
                  keyboardType: TextInputType.text,
                  textInputAction: TextInputAction.next,
                  onFieldSubmitted: (value) {
                    fieldFocusChange(context, _iFSC, _branchName);
                  },
                ),
              ),
              const SizedBox(height: 20.0),
              LabelText("Branch Name"),
              EnsureVisibleWhenFocused(
                focusNode: _branchName,
                child: new TextFormField(
                  decoration: const InputDecoration(
                    border: const UnderlineInputBorder(),
                    hintText: 'Enter branch name',
                  ),
                  onSaved: (value) => _bankDetailsRequest.branchName = value,
                  validator: _bankDetailsRequest.branchNameValidate,
                  controller: _branchController,
                  focusNode: _branchName,
                  keyboardType: TextInputType.text,
                  textInputAction: TextInputAction.next,
                  onFieldSubmitted: (value) {
                    fieldFocusChange(context, _branchName, _accountNumber);
                  },
                ),
              ),
              const SizedBox(height: 20.0),
              LabelText("Account Number"),
              EnsureVisibleWhenFocused(
                focusNode: _accountNumber,
                child: new TextFormField(
                  decoration: const InputDecoration(
                    border: const UnderlineInputBorder(),
                    hintText: 'Enter account number',
                  ),
                  onSaved: (value) => _bankDetailsRequest.accountNumber = value,
                  validator: _bankDetailsRequest.accountNumberValidate,
                  inputFormatters: [WhitelistingTextInputFormatter.digitsOnly],
                  controller: _accountController,
                  focusNode: _accountNumber,
                  keyboardType: TextInputType.phone,
                  textInputAction: TextInputAction.done,
                ),
              ),
              const SizedBox(height: 20.0),
              LabelText("Cheque Image"),
              const SizedBox(height: 20.0),
              (getBankDetailsResponse.chequeImageUrl.isNotEmpty&&getBankDetailsResponse.chequeImageUrl!=null&&image==null)
                  ?Container(
                decoration: BoxDecoration(shape: BoxShape.circle,),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: CachedNetworkImage(
                    fit: BoxFit.cover,
                    height: 120,
                    imageUrl: getBankDetailsResponse.chequeImageUrl,
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
                  :Container(height: 1),
              const SizedBox(height: 10.0),
              image!=null
                  ? Container(
                child: Stack(
                  children: <Widget>[
                    Container(
                      margin: const EdgeInsets.all(10),
                      padding: const EdgeInsets.all(5),
                      decoration:
                      BoxDecoration(borderRadius: BorderRadius.circular(5), border: Border.all(color: Colors.grey)),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: <Widget>[
                          Icon(
                            Icons.insert_drive_file,
                            color: Colors.grey[600],
                            size: 50,
                          ),
                          Text(
                            path.basename(
                                image.path),
                            textAlign: TextAlign.center,
                          )
                        ],
                      ),
                    ),
                    InkWell(
                      onTap: () {
                        setState(() {
                          image=null;
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
            child:
                CommonButton(text: "Save", bgColor: Theme.of(context).primaryColor, onPressed: _validateAndSubmitForm),
          ),
          const SizedBox(
            width: 10,
          ),
          Expanded(
            child: CommonButton(
                text: "Cancel",
                bgColor: Theme.of(context).accentColor,
                onPressed: () {
                  image=null;
                  _getBankProfile();
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

  _validateAndSubmitForm() async {
    if (_formKey.currentState.validate()) {
      _formKey.currentState.save();
      _bankDetailsRequest.cancelledChequePic = image;
        setState(() {
          showLoader = true;
        });
        UpdateBankDetailsResponse bankDetailsResponse = await Repository().updateBankDetails(_bankDetailsRequest);
        print('Update bank details response');
        print(bankDetailsResponse);
        setState(() {
           isEdit = false;
          showLoader = false;
        });
        if (bankDetailsResponse == null) {
          Utility.showSuccessSnackBar(_scaffoldKey, Config.SERVER_ERROR);
        } else {
          if (bankDetailsResponse.status) {
            _showDialog("Success",bankDetailsResponse.message);
              image=null;
            _getBankProfile();

            // Utility.showSuccessSnackBar(_scaffoldKey, bankDetailsResponse.message);
          } else {
            _showDialog("Failed",bankDetailsResponse.message);
            //Utility.showErrorSnackBar(_scaffoldKey, bankDetailsResponse.message);
          }
        }


    }
  }

  _showDialog(String title,String message) {
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







  _loader() {
    return Center(child: CommonLoader());
  }

  _getBankProfile() async {
    getBankDetailsResponse = await Repository().getBankDetails();
    if (getBankDetailsResponse == null) {
      responseMsg = Config.SERVER_ERROR;
      Utility.showErrorSnackBar(_scaffoldKey, responseMsg);
      setState(() {
        showLoader = false;
      });
    } else {
      _setDataToController();
      setState(() {
        showLoader=false;
      });
    }
  }

  void _setDataToController() {
    _nameController.text=getBankDetailsResponse.accountHolderName;
    _panController.text=getBankDetailsResponse.pan;
    _bankNameController.text=getBankDetailsResponse.bankName;
    _iFSCController.text=getBankDetailsResponse.ifsc;
    _branchController.text=getBankDetailsResponse.branchName;
    _accountController.text=getBankDetailsResponse.accountNumber;
    addListener();
    isEdit = false;
  }

  onChange() {
    setState(() {
      isEdit = true;
    });
  }

  addListener() {
    _nameController.addListener(onChange);
    _panController.addListener(onChange);
    _bankNameController.addListener(onChange);
    _iFSCController.addListener(onChange);
    _branchController.addListener(onChange);
    _accountController.addListener(onChange);
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
