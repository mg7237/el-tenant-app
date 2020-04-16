import 'dart:io';

import 'package:easyleases_tenant/api_client/api_client.dart';
import 'package:easyleases_tenant/api_client/repository.dart';
import 'package:easyleases_tenant/config/config.dart';
import 'package:easyleases_tenant/model/EditProfileRequest.dart';
import 'package:easyleases_tenant/model/edit_profile_response.dart';
import 'package:easyleases_tenant/model/update_profile_request.dart';
import 'package:easyleases_tenant/model/update_profile_response.dart';
import 'package:easyleases_tenant/model/state_list_response.dart' as stateRespnse;
import 'package:easyleases_tenant/model/user_profile_response.dart';
import 'package:easyleases_tenant/screen/bank_details.dart';
import 'package:easyleases_tenant/screen/emergency_contact.dart';
import 'package:easyleases_tenant/screen/employment_data.dart';
import 'package:easyleases_tenant/screen/my_documents.dart';
import 'package:easyleases_tenant/screen/service_request/add_service_request_page.dart';
import 'package:easyleases_tenant/util/hex_color.dart';
import 'package:easyleases_tenant/util/preference_connector.dart';
import 'package:easyleases_tenant/util/route_setting.dart';
import 'package:easyleases_tenant/util/utility.dart';
import 'package:easyleases_tenant/widget/EnsureVisibleWhenFocused.dart';
import 'package:easyleases_tenant/widget/common_loader.dart';
import 'package:easyleases_tenant/widget/common_menu_button.dart';
import 'package:easyleases_tenant/widget/key_value_widget.dart';
import 'package:easyleases_tenant/widget/label_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:easyleases_tenant/widget/button.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:cached_network_image/cached_network_image.dart';

// ignore: must_be_immutable
class MyProfilePage extends StatefulWidget {
  final String userId;
  _MyProfilePageState state;

  MyProfilePage(this.userId);

  @override
  _MyProfilePageState createState() => state = _MyProfilePageState(userId);
}

class _MyProfilePageState extends State<MyProfilePage> with AutomaticKeepAliveClientMixin<MyProfilePage> {
  final String userId;

  int position = 0;

  _MyProfilePageState(this.userId);

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey = new GlobalKey<RefreshIndicatorState>();
  FocusNode _focusNodeName = FocusNode();
  FocusNode _focusNodeEmail = FocusNode();
  FocusNode _focusNodePhone = FocusNode();
  FocusNode _focusNodeAdd1 = FocusNode();
  FocusNode _focusNodeAdd2 = FocusNode();
  FocusNode _focusNodeCity = FocusNode();
  FocusNode _focusNodePinCode = FocusNode();
  static final TextEditingController _nameController = TextEditingController();
  static final TextEditingController _emailController = TextEditingController();
  static final TextEditingController _phoneController = TextEditingController();
  static final TextEditingController _add1Controller = TextEditingController();
  static final TextEditingController _add2Controller = TextEditingController();
  static final TextEditingController _cityController = TextEditingController();
  static final TextEditingController _pinCodeController = TextEditingController();
  UserProfileResponse profileResponse;
  stateRespnse.StateListResponse stateListResponse;
  bool showLoader = true;
  String responseMsg = '';
  String stateName = "";
  String title = 'Profile';
  File image;
  EditProfileRequest _updateProfileRequest = EditProfileRequest();
  bool isEdit = false;

  Future<Null> _refreshProfile() async {
    image = null;
    profileResponse = await Repository().getProfile(userId);
    if (profileResponse == null) {
      responseMsg = Config.SERVER_ERROR;
      Utility.showErrorSnackBar(_scaffoldKey, responseMsg);
    } else {
      _setDataToController();
      _setStateName(profileResponse.stateCode);
    }
    return null;
  }

  _getProfile() async {
    profileResponse = await Repository().getProfile(userId);
    if (profileResponse == null) {
      responseMsg = Config.SERVER_ERROR;
      Utility.showErrorSnackBar(_scaffoldKey, responseMsg);
      setState(() {
        showLoader = false;
      });
    } else {
      _getStateList();
      _setDataToController();
    }
  }

  _getStateList() async {
    stateListResponse = await Repository().getStateList();

    if (stateListResponse == null) {
      responseMsg = Config.SERVER_ERROR;
      Utility.showErrorSnackBar(_scaffoldKey, responseMsg);
    } else {
      String stateCode = profileResponse.stateCode;
      if (stateListResponse != null) {
        _setStateName(stateCode);
      }
    }
    setState(() {
      showLoader = false;
    });
  }

  _setStateName(String stateCode) {
    for (int i = 0; i < stateListResponse.states.length; i++) {
      String code = stateListResponse.states[i].code;

      if (stateCode == code) {
        stateName = stateListResponse.states[i].name;
        _updateProfileRequest.stateCode = stateListResponse.states[i].code;
        break;
      } else {
        stateName = "";
      }
    }
    setState(() {});
  }

  _setDataToController() {
    if (profileResponse != null) {
      _nameController.text = profileResponse.name;
      _emailController.text = profileResponse.email;
      _phoneController.text = profileResponse.phoneNumber;
      _add1Controller.text = profileResponse.addressLine1;
      _add2Controller.text = profileResponse.addressLine2;
      _cityController.text = profileResponse.city;
      _pinCodeController.text = profileResponse.pinCode;
      isEdit = false;
      addListener();
    }
  }

  /// working on this
  _validateAndSubmitForm() async {
    if (_formKey.currentState.validate()) {
      _formKey.currentState.save();
      _updateProfileRequest.userId = widget.userId;
      _updateProfileRequest.profilePic = image;
      setState(() {
        showLoader = true;
      });
      EditProfileResponse updateProfileResponse = await Repository().editProfileData(_updateProfileRequest);
      setState(() {
        isEdit = false;
        showLoader = false;
      });
      if (updateProfileResponse == null) {
        Utility.showSuccessSnackBar(_scaffoldKey, Config.SERVER_ERROR);
      } else {

        if (updateProfileResponse.status) {
          //_showDialog();
          Utility.showSuccessSnackBar(_scaffoldKey, updateProfileResponse.message);
        } else {

          Utility.showErrorSnackBar(_scaffoldKey, updateProfileResponse.message);
        }
      }
    }
  }

  _showDialog() {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text("Success"),
            content: Text("Profile updated successfully"),
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

  addListener() {
    _nameController.addListener(onChange);
    _phoneController.addListener(onChange);
    _add1Controller.addListener(onChange);
    _add2Controller.addListener(onChange);
    _cityController.addListener(onChange);
    _pinCodeController.addListener(onChange);
  }

  onChange() {
    setState(() {
      isEdit = true;
    });
  }

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    position = 0;
    _getProfile();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        backgroundColor: const Color(0xFF427BFF),
        centerTitle: true,
        title: Text(title),
        leading: CommonMenuButton(),
      ),
      body: showLoader ? _loader() : profileResponse == null ? _errorMsg() : _body(),
      bottomNavigationBar: showLoader || profileResponse == null
          ? Container(
              height: 1,
            )
          : _profileOptions(),
    );
  }

  _body() {
    return RefreshIndicator(
      key: _refreshIndicatorKey,
      onRefresh: _refreshProfile,
      child: Container(
        color: Colors.white,
        child: changeView(position),
      ),
    );
  }

  getUserProfile() {
    return ListView(
      physics: BouncingScrollPhysics(),
      padding: const EdgeInsets.fromLTRB(20, 16, 16, 20),
      children: <Widget>[
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            ClipRRect(
              borderRadius: BorderRadius.circular(45),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                ),
                height: 90,
                width: 90,
                child: InkWell(
                    onTap: () {
                      _showImagePicker();
                    },
                    child: image == null
                        ? profileResponse.profilePhotoUrl == ApiClient.BASE_URL_IMAGE
                            ? Icon(
                                Icons.person,
                                size: 60,
                                color: Colors.grey,
                              )
                            : Stack(
                                alignment: Alignment.center,
                                children: <Widget>[
                                  /*CircularProgressIndicator(
                                        strokeWidth: 1,
                                      ),*/
                                  CachedNetworkImage(
                                    height: 90,
                                    width: 90,
                                    imageUrl: profileResponse.profilePhotoUrl,
                                    placeholder: (context, url) => new CircularProgressIndicator(
                                      strokeWidth: 1,
                                    ),
                                    errorWidget: (context, url, error) => new Icon(
                                      Icons.person,
                                      size: 60,
                                      color: Colors.grey,
                                    ),
                                    fit: BoxFit.cover,
                                  ),
                                ],
                              )
                        : Image.file(
                            image,
                            fit: BoxFit.cover,
                          )),
              ),
            ),
            _saveButton(),
          ],
        ),
        const SizedBox(height: 14.0),
        Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              LabelText("Name"),
              EnsureVisibleWhenFocused(
                focusNode: _focusNodeName,
                child: new TextFormField(
                  decoration: const InputDecoration(
                    border: const UnderlineInputBorder(),
                    hintText: 'Enter your Name',
                  ),
                  onSaved: (value) => _updateProfileRequest.name = value,
                  validator: _updateProfileRequest.nameValidate,
                  controller: _nameController,
                  focusNode: _focusNodeName,
                  keyboardType: TextInputType.text,
                  textInputAction: TextInputAction.next,
                ),
              ),
              const SizedBox(height: 20.0),
              LabelText("Email"),
              EnsureVisibleWhenFocused(
                focusNode: _focusNodeEmail,
                child: new TextFormField(
                  enabled: false,
                  decoration: const InputDecoration(
                    border: const UnderlineInputBorder(),
                    hintText: 'Enter your email',
                  ),
                  onSaved: (value) => _updateProfileRequest.email = value,
                  validator: _updateProfileRequest.emailValidate,
                  controller: _emailController,
                  focusNode: _focusNodeEmail,
                  keyboardType: TextInputType.emailAddress,
                  textInputAction: TextInputAction.done,
                ),
              ),
              const SizedBox(height: 20.0),
              LabelText("Phone"),
              EnsureVisibleWhenFocused(
                focusNode: _focusNodePhone,
                child: new TextFormField(
                    decoration: const InputDecoration(
                      border: const UnderlineInputBorder(),
                      hintText: 'Enter your phone number',
                    ),
                    onSaved: (value) => _updateProfileRequest.phone = value,
                    validator: _updateProfileRequest.numberValidate,
                    controller: _phoneController,
                    focusNode: _focusNodePhone,
                    keyboardType: TextInputType.text,
                    textInputAction: TextInputAction.done,
                    inputFormatters: [
                      LengthLimitingTextInputFormatter(15),
                    ]),
              ),
              const SizedBox(height: 20.0),
              LabelText("Address Line 1"),
              EnsureVisibleWhenFocused(
                focusNode: _focusNodeAdd1,
                child: new TextFormField(
                  decoration: const InputDecoration(
                    border: const UnderlineInputBorder(),
                    hintText: 'Enter your address line 1',
                  ),
                  onSaved: (value) => _updateProfileRequest.addLine1 = value,
                  validator: _updateProfileRequest.addressLine1Validate,
                  controller: _add1Controller,
                  focusNode: _focusNodeAdd1,
                  keyboardType: TextInputType.text,
                  textInputAction: TextInputAction.done,
                ),
              ),
              const SizedBox(height: 20.0),
              LabelText("Address Line 2"),
              EnsureVisibleWhenFocused(
                focusNode: _focusNodeAdd2,
                child: new TextFormField(
                  decoration: const InputDecoration(
                    border: const UnderlineInputBorder(),
                    hintText: 'Enter your address line 2',
                  ),
                  onSaved: (value) => _updateProfileRequest.addLine2 = value,
                  validator: _updateProfileRequest.addressLine2Validate,
                  controller: _add2Controller,
                  focusNode: _focusNodeAdd2,
                  keyboardType: TextInputType.text,
                  textInputAction: TextInputAction.done,
                ),
              ),
              const SizedBox(height: 20.0),
              LabelText("City"),
              EnsureVisibleWhenFocused(
                focusNode: _focusNodeCity,
                child: new TextFormField(
                  decoration: const InputDecoration(
                    border: const UnderlineInputBorder(),
                    hintText: 'Enter your city',
                  ),
                  onSaved: (value) => _updateProfileRequest.city = value,
                  validator: _updateProfileRequest.cityValidate,
                  controller: _cityController,
                  focusNode: _focusNodeCity,
                  keyboardType: TextInputType.text,
                  textInputAction: TextInputAction.done,
                ),
              ),
              const SizedBox(height: 20.0),
              LabelText("State"),
              DropDownView(
                text: stateName != null || stateName.isNotEmpty ? stateName : "Select",
                onPressed: () {
                  _showStatePicker();
                },
              ),
              const SizedBox(height: 20.0),
              LabelText("Pin Code"),
              EnsureVisibleWhenFocused(
                focusNode: _focusNodePinCode,
                child: new TextFormField(
                  decoration: const InputDecoration(
                    border: const UnderlineInputBorder(),
                    hintText: 'Enter your pin code',
                  ),
                  inputFormatters: <TextInputFormatter>[
                    LengthLimitingTextInputFormatter(15),
                  ],
                  onSaved: (value) => _updateProfileRequest.pinCode = value,
                  validator: _updateProfileRequest.pinCodeValidate,
                  controller: _pinCodeController,
                  focusNode: _focusNodePinCode,
                  textInputAction: TextInputAction.done,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  //Show bottom option on profile screen.
  _profileOptions() {
    return Container(
      padding: EdgeInsets.all(8),
      decoration: BoxDecoration(color: HexColor('#ff0000').withOpacity(.8)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          InkWell(
            onTap: () {
              // Navigator.pushNamed(context, MY_DOCUMENTS);
              position = 1;
              setState(() {
                title = 'Documents';
              });
            },
            child: Container(padding: EdgeInsets.all(8), child: Image.asset('assets/icon/documents.png')),
          ),
          InkWell(
            onTap: () {
              //Navigator.pushNamed(context, BANK_DETAILS);
              position = 2;
              setState(() {
                title = 'Bank Details';
              });
            },
            child: Container(
                padding: EdgeInsets.all(8),
                child: Image.asset(
                  'assets/icon/bank_details_.png',
                )),
          ),
          InkWell(
            onTap: () {
              // Navigator.pushNamed(context, EMPLOYMENT_DATA);
              position = 3;
              setState(() {
                title = 'Employment';
              });
            },
            child: Container(padding: EdgeInsets.all(8), child: Image.asset('assets/icon/employement.png')),
          ),
          InkWell(
            onTap: () {
              //Navigator.pushNamed(context, EMERGENCY_CONTACT);
              position = 4;
              setState(() {
                title = 'Emergency';
              });
            },
            child: Container(padding: EdgeInsets.all(8), child: Image.asset('assets/icon/emergency.png')),
          )
        ],
      ),
    );
  }

  _saveButton() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
      child: showLoader
          ? CommonLoader()
          : MaterialButton(
              child: Text(
                'Save Edits',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                ),
              ),
              padding: const EdgeInsets.all(14),
              color: Theme.of(context).accentColor,
              onPressed: isEdit ? _validateAndSubmitForm : null,
              disabledColor: Theme.of(context).accentColor.withOpacity(0.5),
            ) /*CommonButton(
              text: "Save Edits",
              bgColor: Theme.of(context).accentColor,
              onPressed: _validateAndSubmitForm,
            )*/
      ,
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

  _showStatePicker() {
    if (stateListResponse != null) {
      stateName = stateListResponse.states[0].name;
      _updateProfileRequest.stateCode = stateListResponse.states[0].code;
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
                            Navigator.of(context).pop();
                            setState(() {});
                          },
                        )
                      ],
                    ),
                    Expanded(
                      child: CupertinoPicker(
                        backgroundColor: Colors.grey[300],
                        itemExtent: 32,
                        children: List<Widget>.generate(stateListResponse.states.length, (index) {
                          return Center(
                            child: Text(stateListResponse.states[index].name),
                          );
                        }),
                        onSelectedItemChanged: (index) {
                          stateName = stateListResponse.states[index].name;
                          _updateProfileRequest.stateCode = stateListResponse.states[index].code;
                          setState(() {});
                        },
                      ),
                    ),
                  ],
                ),
              ),
            );
          });
    }
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

  changeView(newPosition) {
    switch (newPosition) {
      case 0:
        {
          return getUserProfile();
        }
        break;
      case 1:
        {

          return MyDocuments();
        }
        break;
      case 2:
        {

          return BankDetails();
        }
        break;
      case 3:
        {
          return EmploymentData();
        }
        break;
      case 4:
        {
          return EmergencyContact();
        }
        break;

      default:
        {
          return getUserProfile();
        }
        break;
    }
  }

  myProfilePosition(int i) {
    position = i;
    title='Profile';
    setState(() {});
  }


}
