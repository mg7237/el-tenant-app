import 'package:easyleases_tenant/screen/forgot_password_page.dart';
import 'package:easyleases_tenant/widget/EnsureVisibleWhenFocused.dart';
import 'package:easyleases_tenant/widget/button.dart';
import 'package:easyleases_tenant/widget/label_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final GlobalKey<FormState> _formKey = new GlobalKey<FormState>();
  FocusNode _focusNodeEmail = new FocusNode();
  FocusNode _focusNodePassword = new FocusNode();
  static final TextEditingController _emailController =
      new TextEditingController();
  static final TextEditingController _passwordController =
      new TextEditingController();

  _openForgotPassword() {
    Navigator.of(context).pushNamed('/ForgotPassword');
  }

  _openHomePage() {
    Navigator.of(context).pushReplacementNamed('/HomePage');
  }

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
                    height: MediaQuery.of(context).size.height / 3.2,
                    width: double.infinity,
                    decoration: BoxDecoration(
                        color: Colors.grey[300],
                        image: DecorationImage(
                          fit: BoxFit.cover,
                            image: AssetImage("assets/icon/background_image.png"))),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(26.0, 10, 26, 5),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: <Widget>[
                        //const SizedBox(height: 14.0),
                        Hero(tag:"logo",child: Image.asset("assets/icon/login_logo.png")),
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
                        LabelText("Email"),
                        EnsureVisibleWhenFocused(
                          focusNode: _focusNodeEmail,
                          child: new TextFormField(
                            decoration: const InputDecoration(
                              border: const UnderlineInputBorder(),
                              hintText: 'Enter your email address',
                            ),
                            onSaved: (String value) {
                              //TODO
                            },
                            controller: _emailController,
                            focusNode: _focusNodeEmail,
                            keyboardType: TextInputType.emailAddress,
                            textInputAction: TextInputAction.next,
                          ),
                        ),
                        const SizedBox(height: 34.0),
                        LabelText("Password"),
                        EnsureVisibleWhenFocused(
                          focusNode: _focusNodePassword,
                          child: new TextFormField(
                            decoration: const InputDecoration(
                              border: const UnderlineInputBorder(),
                              hintText: 'Enter your password',
                            ),
                            onSaved: (String value) {
                              //TODO
                            },
                            controller: _passwordController,
                            focusNode: _focusNodePassword,
                            keyboardType: TextInputType.text,
                            textInputAction: TextInputAction.done,
                            obscureText: true,
                          ),
                        ),
                        const SizedBox(height: 34.0),
                        CommonButton(
                          text: "Login",
                          bgColor: Theme.of(context).accentColor,
                          onPressed: _openHomePage,
                        ),
                        const SizedBox(height: 14.0),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Padding(
                              padding: const EdgeInsets.fromLTRB(0, 8, 8, 8),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: <Widget>[
                                  Icon(Icons.check_box_outline_blank),
                                  SizedBox(
                                    width: 5,
                                  ),
                                  Text(
                                    "Remember Me",
                                    style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w600,
                                        color: Theme.of(context).primaryColor),
                                  )
                                ],
                              ),
                            ),
                            InkWell(
                              onTap: () {
                                _openForgotPassword();
                              },
                              child: Padding(
                                padding: const EdgeInsets.fromLTRB(8, 8, 0, 8),
                                child: Text(
                                  "Forgot Password?",
                                  style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w600,
                                      color: Theme.of(context).primaryColor),
                                ),
                              ),
                            )
                          ],
                        )
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
