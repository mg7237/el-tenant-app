import 'package:cached_network_image/cached_network_image.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:easyleases_tenant/api_client/repository.dart';
import 'package:easyleases_tenant/config/config.dart';
import 'package:easyleases_tenant/model/get_support_person_response.dart';
import 'package:easyleases_tenant/util/utility.dart';
import 'package:easyleases_tenant/widget/EnsureVisibleWhenFocused.dart';
import 'package:easyleases_tenant/widget/button.dart';
import 'package:easyleases_tenant/widget/common_loader.dart';
import 'package:easyleases_tenant/widget/label_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class SupportPersonDetails extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return SupportPersonDetailsState();
  }
}

class SupportPersonDetailsState extends State<SupportPersonDetails> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey = new GlobalKey<RefreshIndicatorState>();
  GetSupportPersonResponse _getSupportPersonResponse;
  FocusNode _name = FocusNode();
  FocusNode _email = FocusNode();
  FocusNode _mobile = FocusNode();
  bool showLoader = true;
  String responseMsg = '';
  static final TextEditingController _nameController = TextEditingController();
  static final TextEditingController _emailController = TextEditingController();
  static final TextEditingController _mobileController = TextEditingController();

  @override
  void initState() {
    _getSupportPersonDetails();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Theme.of(context).primaryColor,
        title: Text("Support Person Details"),
        leading: InkWell(
            onTap: () {
              Navigator.pop(context);
            },
            child: Image.asset('assets/icon/back_arrow.png')),
      ),
      body: showLoader ? _loader() : _getSupportPersonResponse == null ? _errorMsg() : _buildBody(),
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
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  InkWell(
                    onTap: () {},
                    child: DottedBorder(
                      color: Colors.grey[400],
                      gap: 3,
                      strokeWidth: 1,
                      child: Container(
                        height: 120,
                        width: 120,
                        decoration: BoxDecoration(color: Colors.grey[200]),
                        child: CachedNetworkImage(
                          height: 90,
                          width: 90,
                          imageUrl: _getSupportPersonResponse.profileImageUrl,
                          placeholder: (context, url) => new CircularProgressIndicator(
                            strokeWidth: 1
                          ),
                          errorWidget: (context, url, error) => Image.asset(
                            "assets/icon/photo_camera.png",
                            height: 120,
                            width: 120,
                          ),
                          fit: BoxFit.cover,
                        ),

                      ),
                    ),
                  )
                ],
              ),
              LabelText("Name"),
              EnsureVisibleWhenFocused(
                focusNode: _name,
                child: new TextFormField(
                  enabled: false,
                  decoration: const InputDecoration(
                    border: const UnderlineInputBorder(),
                  ),
                  //onSaved: (value) => _updateProfileRequest.name = value,
                  // validator: _updateProfileRequest.nameValidate,
                  controller: _nameController,
                  focusNode: _name,
                  keyboardType: TextInputType.text,
                  textInputAction: TextInputAction.next,
                  onFieldSubmitted: (value) {
                    fieldFocusChange(context, _name, _email);
                  },
                ),
              ),
              const SizedBox(height: 20.0),
              LabelText("Email"),
              EnsureVisibleWhenFocused(
                focusNode: _email,
                child: new TextFormField(
                  enabled: false,
                  decoration: const InputDecoration(
                    border: const UnderlineInputBorder(),
                  ),
                  //onSaved: (value) => _updateProfileRequest.name = value,
                  // validator: _updateProfileRequest.nameValidate,
                  controller: _emailController,
                  focusNode: _email,
                  keyboardType: TextInputType.emailAddress,
                  textInputAction: TextInputAction.next,
                  onFieldSubmitted: (value) {
                    fieldFocusChange(context, _email, _mobile);
                  },
                ),
              ),
              const SizedBox(height: 20.0),
              LabelText("Mobile Number"),
              EnsureVisibleWhenFocused(
                focusNode: _mobile,
                child: new TextFormField(
                  enabled: false,
                  decoration: const InputDecoration(
                    border: const UnderlineInputBorder(),
                  ),
                  //onSaved: (value) => _updateProfileRequest.name = value,
                  // validator: _updateProfileRequest.nameValidate,
                  controller: _mobileController,
                  focusNode: _mobile,
                  keyboardType: TextInputType.text,
                  textInputAction: TextInputAction.done,
                  inputFormatters: [WhitelistingTextInputFormatter.digitsOnly],
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

  Future _getSupportPersonDetails() async {
    _getSupportPersonResponse = await Repository().getSupportPerson();
    if (_getSupportPersonResponse != null&&_getSupportPersonResponse.status==true ) {
      setState(() {
        showLoader = false;
        _setDataToController();
      });
    } else {
      responseMsg = Config.SERVER_ERROR;
      Utility.showErrorSnackBar(_scaffoldKey, responseMsg);
      setState(() {
        showLoader = false;
      });
    }

  }


  _loader() {
    return Center(child: CommonLoader());
  }

  _setDataToController(){
    _nameController.text = _getSupportPersonResponse.name;
    _emailController.text = _getSupportPersonResponse.email;
    _mobileController.text = _getSupportPersonResponse.phone;
  }

  _errorMsg() {
    return Center(
      child: Text(responseMsg),
    );
  }

}
