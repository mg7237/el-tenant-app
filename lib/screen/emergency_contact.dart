import 'package:dotted_border/dotted_border.dart';
import 'package:easyleases_tenant/api_client/repository.dart';
import 'package:easyleases_tenant/config/config.dart';
import 'package:easyleases_tenant/model/get_emergency_details_response.dart';
import 'package:easyleases_tenant/model/update_emergency_details_request.dart';
import 'package:easyleases_tenant/model/update_emergency_details_response.dart';
import 'package:easyleases_tenant/model/update_employment_details-request.dart';
import 'package:easyleases_tenant/util/utility.dart';
import 'package:easyleases_tenant/widget/EnsureVisibleWhenFocused.dart';
import 'package:easyleases_tenant/widget/button.dart';
import 'package:easyleases_tenant/widget/common_loader.dart';
import 'package:easyleases_tenant/widget/label_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
class EmergencyContact extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {
    return EmergencyContactState() ;
  }
}

class EmergencyContactState extends State<EmergencyContact> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
  new GlobalKey<RefreshIndicatorState>();
  FocusNode _name = FocusNode();
  FocusNode _email = FocusNode();
  FocusNode _mobile = FocusNode();
  bool isEdit = false;
  bool showLoader = true;
  String responseMsg = '';
  UpdateEmergencyDetailsRequest _emergencyDetailsRequest = UpdateEmergencyDetailsRequest();
  GetEmergencyDetailsResponse _getEmergencyDetailsResponse;
  static final TextEditingController _nameController = TextEditingController();
  static final TextEditingController _emailController = TextEditingController();
  static final TextEditingController _mobileController = TextEditingController();

  @override
  void initState() {
    _getEmergencyData();
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
              LabelText("Name"),
              EnsureVisibleWhenFocused(
                focusNode: _name,
                child: new TextFormField(
                  decoration: const InputDecoration(
                    border: const UnderlineInputBorder(),
                    hintText: 'Enter name',
                  ),
                  onSaved: (value) => _emergencyDetailsRequest.contactName = value,
                  // validator: _updateProfileRequest.nameValidate,
                  controller: _nameController,
                  focusNode: _name,
                  keyboardType: TextInputType.text,
                  textInputAction: TextInputAction.next,
                  onFieldSubmitted: (value) {
                    fieldFocusChange(
                        context, _name, _email);
                  },
                ),
              ),
              const SizedBox(height: 20.0),
              LabelText("Email"),
              EnsureVisibleWhenFocused(
                focusNode: _email,
                child: new TextFormField(
                  decoration: const InputDecoration(
                    border: const UnderlineInputBorder(),
                    hintText: 'Enter Email',
                  ),
                  onSaved: (value) => _emergencyDetailsRequest.contactEmail = value,
                   validator: _emergencyDetailsRequest.emailValidate,
                  controller: _emailController,
                  focusNode: _email,
                  keyboardType: TextInputType.emailAddress,
                  textInputAction: TextInputAction.next,
                  onFieldSubmitted: (value) {
                    fieldFocusChange(
                        context, _email, _mobile);
                  },
                ),
              ),
              const SizedBox(height: 20.0),
              LabelText("Mobile Number"),
              EnsureVisibleWhenFocused(
                focusNode: _mobile,
                child: new TextFormField(
                  decoration: const InputDecoration(
                    border: const UnderlineInputBorder(),
                    hintText: 'Enter Number',
                  ),
                  onSaved: (value) => _emergencyDetailsRequest.contactPhone = value,
                  // validator: _updateProfileRequest.nameValidate,
                  controller: _mobileController,
                  focusNode: _mobile,
                  keyboardType: TextInputType.number,
                  textInputAction: TextInputAction.done,
                  inputFormatters: [
                    WhitelistingTextInputFormatter.digitsOnly
                  ],
                  onFieldSubmitted: (value) {
                    /*fieldFocusChange(
                        context, _mobile, _empStartDate
                    );*/
                  },
                ),
              ),
              const SizedBox(height: 20.0),

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

                  _getEmergencyData();
                }),
          ),
        ],
      ),
    );
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

  Future _getEmergencyData() async {
    _getEmergencyDetailsResponse = await Repository().getEmergencyDetails();
    if (_getEmergencyDetailsResponse == null) {
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

  _submitForm() async {

    if (_formKey.currentState.validate()){
      _formKey.currentState.save();
      setState(() {
        showLoader = true;
      });
      UpdateEmergencyDetailsResponse updateEmergencyDetailsResponse =
      await Repository().updateEmergencyDetails(_emergencyDetailsRequest);
      print('Update emergency details response');
      print(updateEmergencyDetailsResponse);
      setState(() {
        isEdit = false;
        showLoader = false;
      });
      if (updateEmergencyDetailsResponse == null) {
        Utility.showSuccessSnackBar(_scaffoldKey, Config.SERVER_ERROR);
      } else {
        if (updateEmergencyDetailsResponse.status) {
          _showDialog("Success", updateEmergencyDetailsResponse.message);
          _getEmergencyData();
          // Utility.showSuccessSnackBar(_scaffoldKey, bankDetailsResponse.message);
        } else {
          _showDialog("Failed", updateEmergencyDetailsResponse.message);
          //Utility.showErrorSnackBar(_scaffoldKey, bankDetailsResponse.message);
        }
      }
      if(true){}
      else {
        Utility.showErrorSnackBar(_scaffoldKey, 'Please upload employment proof image.');
      }
    }

  }
   _setDataToController() {
    _nameController.text=_getEmergencyDetailsResponse.name;
    _emailController.text=_getEmergencyDetailsResponse.email;
    _mobileController.text=_getEmergencyDetailsResponse.phone;
   }
}