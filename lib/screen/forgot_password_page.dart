import 'package:easyleases_tenant/widget/EnsureVisibleWhenFocused.dart';
import 'package:easyleases_tenant/widget/button.dart';
import 'package:easyleases_tenant/widget/label_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ForgotPasswordPage extends StatefulWidget {
  @override
  _ForgotPasswordPageState createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> {
  final GlobalKey<FormState> _formKey = new GlobalKey<FormState>();
  FocusNode _focusNodeCode = new FocusNode();
  FocusNode _focusNodePassword = new FocusNode();
  FocusNode _focusNodeRePassword = new FocusNode();
  static final TextEditingController _codeController =
      new TextEditingController();
  static final TextEditingController _passwordController =
      new TextEditingController();
  static final TextEditingController _rePasswordController =
  new TextEditingController();

  TextStyle labelTextStyle =
      TextStyle(color: Colors.black, fontWeight: FontWeight.w500, fontSize: 14);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        top: false,
        bottom: false,
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            physics: BouncingScrollPhysics(),
            child: Container(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  Container(
                    height: MediaQuery.of(context).size.height / 4,
                    width: double.infinity,
                    decoration: BoxDecoration(
                        color: Colors.grey[300],
                        image: DecorationImage(
                            fit: BoxFit.cover,
                            image: AssetImage("assets/icon/background_image.png"))),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(26.0, 10, 26, 12),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: <Widget>[
                       // const SizedBox(height: 14.0),
                        Image.asset("assets/icon/login_logo.png"),
                        const SizedBox(height: 14.0),
                        Text(
                          "Zero Brokerage & Hassle-Free Living With All Property Managment Taken Care of",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.w500
                          ),
                        ),
                        const SizedBox(height: 30),
                        LabelText("Security code (sent to you on email)"),
                        EnsureVisibleWhenFocused(
                          focusNode: _focusNodeCode,
                          child: new TextFormField(
                            decoration: const InputDecoration(
                                border: const UnderlineInputBorder(),
                                hintText: 'Enter Security code',
                                contentPadding:
                                    const EdgeInsets.fromLTRB(0, 16, 0, 16)),
                            onSaved: (String value) {
                              //TODO
                            },
                            controller: _codeController,
                            focusNode: _focusNodeCode,
                          ),
                        ),
                        const SizedBox(height: 24.0),
                        LabelText(
                          "Password",
                        ),
                        EnsureVisibleWhenFocused(
                          focusNode: _focusNodePassword,
                          child: new TextFormField(
                            decoration: const InputDecoration(
                                border: const UnderlineInputBorder(),
                                hintText: 'Enter your new password',
                                contentPadding:
                                    const EdgeInsets.fromLTRB(0, 16, 0, 16)),
                            onSaved: (String value) {
                              //TODO
                            },
                            controller: _passwordController,
                            focusNode: _focusNodePassword,
                            obscureText: true,
                          ),
                        ),
                        const SizedBox(height: 24.0),
                        LabelText("Confirm Password"),
                        EnsureVisibleWhenFocused(
                          focusNode: _focusNodeRePassword,
                          child: new TextFormField(
                            decoration: const InputDecoration(
                                border: const UnderlineInputBorder(),
                                hintText: 'Re-enter your new password',
                                contentPadding:
                                    const EdgeInsets.fromLTRB(0, 16, 0, 16)),
                            onSaved: (String value) {
                              //TODO
                            },
                            controller: _rePasswordController,
                            focusNode: _focusNodeRePassword,
                            obscureText: true,
                          ),
                        ),
                        const SizedBox(height: 34.0),
                        CommonButton(
                          text: "Reset Password",
                          bgColor: Theme.of(context).accentColor,
                          onPressed: () {},
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
