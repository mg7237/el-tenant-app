import 'package:easyleases_tenant/screen/service_request/add_service_request_page.dart';
import 'package:easyleases_tenant/widget/EnsureVisibleWhenFocused.dart';
import 'package:easyleases_tenant/widget/common_menu_button.dart';
import 'package:easyleases_tenant/widget/label_text.dart';
import 'package:flutter/material.dart';
import 'package:easyleases_tenant/widget/button.dart';
import 'package:flutter/services.dart';

class MyProfilePage extends StatefulWidget {
  @override
  _MyProfilePageState createState() => _MyProfilePageState();
}

class _MyProfilePageState extends State<MyProfilePage> {
  final GlobalKey<FormState> _formKey = new GlobalKey<FormState>();
  FocusNode _focusNodeName = new FocusNode();
  FocusNode _focusNodeEmail = new FocusNode();
  FocusNode _focusNodePhone = new FocusNode();
  FocusNode _focusNodeAdd1 = new FocusNode();
  FocusNode _focusNodeAdd2 = new FocusNode();
  FocusNode _focusNodeCity = new FocusNode();
  FocusNode _focusNodePinCode = new FocusNode();
  static final TextEditingController _nameController = TextEditingController();
  static final TextEditingController _emailController = TextEditingController();
  static final TextEditingController _phoneController = TextEditingController();
  static final TextEditingController _add1Controller = TextEditingController();
  static final TextEditingController _add2Controller = TextEditingController();
  static final TextEditingController _cityController = TextEditingController();
  static final TextEditingController _pinCodeController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF427BFF),
        centerTitle: true,
        title: Text("Profile"),
        leading: CommonMenuButton(),
      ),
      body: Container(
        color: Colors.white,
        child: ListView(
          physics: BouncingScrollPhysics(),
          padding: const EdgeInsets.fromLTRB(20,16,16,20),
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                ClipRRect(
                  borderRadius: BorderRadius.circular(45),
                  child: Container(
                    color: Colors.grey[300],
                    height: 90,
                    width: 90,
                    child: FlutterLogo(),
                  ),
                ),
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
                      onSaved: (String value) {
                        //TODO
                      },
                      controller: _nameController,
                      focusNode: _focusNodeName,
                      keyboardType: TextInputType.text,
                      textInputAction: TextInputAction.done,
                    ),
                  ),
                  const SizedBox(height: 20.0),
                  LabelText("Email"),
                  EnsureVisibleWhenFocused(
                    focusNode: _focusNodeEmail,
                    child: new TextFormField(
                      decoration: const InputDecoration(
                        border: const UnderlineInputBorder(),
                        hintText: 'Enter your email',
                      ),
                      onSaved: (String value) {
                        //TODO
                      },
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
                      onSaved: (String value) {
                        //TODO
                      },
                      controller: _phoneController,
                      focusNode: _focusNodePhone,
                      keyboardType: TextInputType.phone,
                      textInputAction: TextInputAction.done,
                    ),
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
                      onSaved: (String value) {
                        //TODO
                      },
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
                      onSaved: (String value) {
                        //TODO
                      },
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
                      onSaved: (String value) {
                        //TODO
                      },
                      controller: _cityController,
                      focusNode: _focusNodeCity,
                      keyboardType: TextInputType.text,
                      textInputAction: TextInputAction.done,
                    ),
                  ),
                  const SizedBox(height: 20.0),
                  LabelText("State"),
                  DropDownView(
                    text: "Select",
                    onPressed: () {

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
                        WhitelistingTextInputFormatter(RegExp(r'^[a-zA-Z0-9]+$')),
                      ],
                      onSaved: (String value) {
                        //TODO
                      },
                      controller: _pinCodeController,
                      focusNode: _focusNodePinCode,
                      keyboardType: TextInputType.number,
                      textInputAction: TextInputAction.done,
                    ),
                  ),
                ],
              ),
            ),

          ],
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.fromLTRB(20,10,20,10),
        child: CommonButton(
          text: "Save Edits",
          bgColor: Theme.of(context).accentColor,
          onPressed: (){

          },
        ),
      ),
    );
  }
}
