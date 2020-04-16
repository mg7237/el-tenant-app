import 'dart:io';
import 'package:easyleases_tenant/api_client/repository.dart';
import 'package:easyleases_tenant/config/config.dart';
import 'package:easyleases_tenant/model/download_or_email_request.dart';
import 'package:easyleases_tenant/model/update_fcm_response.dart';
import 'package:easyleases_tenant/model/update_fcm_token_request.dart';
import 'package:easyleases_tenant/screen/agreement_page.dart';
import 'package:easyleases_tenant/screen/dashboard_page.dart';
import 'package:easyleases_tenant/screen/my_profile_page.dart';
import 'package:easyleases_tenant/screen/payment_tab/payment_page.dart';
import 'package:easyleases_tenant/screen/service_request/requests_page.dart';
import 'package:easyleases_tenant/util/preference_connector.dart';
import 'package:easyleases_tenant/util/route_setting.dart';
import 'package:easyleases_tenant/util/utility.dart';
import 'package:easyleases_tenant/widget/my_drawer.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:overlay_support/overlay_support.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final GlobalKey<ScaffoldState> _globalKey = GlobalKey<ScaffoldState>();
  final FirebaseMessaging _fireBaseMessaging = FirebaseMessaging();
  String _currentTitle = 'Dashboard';

  int _currentIndex = 0;
  final pageController = PageController();
  List<Widget> _children = List<Widget>();
  String userId = '';

  _getUserId() async {
    userId = await PreferenceConnector().getString(PreferenceConnector.USER_ID);
    _buildChildrenList();
    setState(() {});
  }

  @override
  void initState() {
    firebaseCloudMessaging_Listeners();
    _getUserId();
    _subscribeToTopic();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _globalKey,
      /*appBar: AppBar(
        backgroundColor: const Color(0xFF427BFF),
        centerTitle: true,
        title: Text(_currentTitle),
      ),*/
      drawer: MyDrawer(),
      bottomNavigationBar: _buildBottomBar(),
      body: PageView(
        children: _children,
        controller: pageController,
        onPageChanged: onPageChanged,
        physics: NeverScrollableScrollPhysics(),
      ),
    );
  }

  DashboardPage dashboardPage;
  MyProfilePage myProfilePage;
  AgreementPage agreementPage;
  PaymentPage paymentPage;
  RequestsPage requestsPage;

  _buildChildrenList() {
    dashboardPage = DashboardPage(userId, pageController);
    myProfilePage = MyProfilePage(userId);
    agreementPage = AgreementPage(userId);
    paymentPage = PaymentPage(userId);
    requestsPage = RequestsPage();

    _children = [
      dashboardPage,
      myProfilePage,
      agreementPage,
      paymentPage,
      requestsPage,
    ];
  }

  _buildBottomBar() {
    return BottomNavigationBar(
      backgroundColor: Theme.of(context).primaryColor,
      selectedFontSize: 12,
      unselectedFontSize: 10,
      selectedItemColor: Colors.white,
      unselectedItemColor: Colors.grey[400],
      onTap: onTabTapped,
      currentIndex: _currentIndex,
      type: BottomNavigationBarType.fixed,
      iconSize: 30,
      items: <BottomNavigationBarItem>[
        BottomNavigationBarItem(
          icon: Image.asset(
            _currentIndex == 0 ? "assets/icon/dashboard_white.png" : "assets/icon/dashboard_gray.png",
            width: 19,
            height: 19,
          ),
          title: FittedBox(
            child: Text(
              "Dashboard",
            ),
          ),
        ),
        BottomNavigationBarItem(
          icon: Image.asset(
            _currentIndex == 1 ? "assets/icon/profile_white.png" : "assets/icon/profile_gray.png",
            width: 19,
            height: 19,
          ),
          title: FittedBox(
            child: Text(
              "My Profile",
            ),
          ),
        ),
        BottomNavigationBarItem(
          icon: Image.asset(
            _currentIndex == 2 ? "assets/icon/agreements_white.png" : "assets/icon/agreements_gray.png",
            width: 19,
            height: 19,
          ),
          title: FittedBox(
            child: Text(
              "Agreements",
            ),
          ),
        ),
        BottomNavigationBarItem(
          icon: Image.asset(
            _currentIndex == 3 ? "assets/icon/payment_white.png" : "assets/icon/payment_gray.png",
            width: 19,
            height: 19,
          ),
          title: FittedBox(
            child: Text(
              "Payments",
            ),
          ),
        ),
        BottomNavigationBarItem(
          icon: Image.asset(
            _currentIndex == 4 ? "assets/icon/service_requests_white.png" : "assets/icon/service_requests_gray.png",
            width: 19,
            height: 19,
          ),
          title: FittedBox(
            child: Text(
              "Requests",
            ),
          ),

        )
      ],
    );
  }

  updateTitle(int index) {
    switch (index) {
      case 0:
        _currentTitle = "Dashboard";
        break;
      case 1:
        _currentTitle = "Profile";

        break;
      case 2:
        _currentTitle = "Agreements";
        break;
      case 3:
        _currentTitle = "Payments";
        break;
      case 4:
        _currentTitle = "Service Requests";
        break;
    }
  }

  void onPageChanged(int index) {
    setState(() {
      updateTitle(index);
      _currentIndex = index;
    });
  }

  void onTabTapped(int index) {
    setState(() {
      updateTitle(index);
      _currentIndex = index;
      pageController.jumpToPage(index);
      if (myProfilePage.state != null && index == 1) {
        myProfilePage.state.myProfilePosition(0);
      }
    });
  }

  void firebaseCloudMessaging_Listeners() {
    if (Platform.isIOS) iOS_Permission();
    _fireBaseMessaging.getToken().then((token) {
      print('Token');
      print(token);
   //   saveFcmToken(token);
    });

    _fireBaseMessaging.configure(onMessage: (Map<String, dynamic> message) async {
      print('On Message $message');
      if (message != null) {
        if (message.containsKey('notification')) {
          final dynamic notification = message['notification'];
          setState(() {});
          showSimpleNotification(
            ListTile(
              title: Text(notification['title'].toString()),
              subtitle: Text(notification['body'].toString()),
            ),
            trailing: Builder(builder: (context) {
              return FlatButton(
                  textColor: Colors.yellow,
                  onPressed: () {
                    OverlaySupportEntry.of(context).dismiss();
                    onNotificationClick(message);
                  },
                  child: Text('View'));
            }),
            background: Colors.green,
            autoDismiss: false,
            slideDismiss: true,
          );
        }

        // myBackgroundMessageHandler(message);

      }
    },

//onBackgroundMessage: myBackgroundMessageHandler,
        onLaunch: (Map<String, dynamic> message) async {
      print('On Launch : $message');
      onNotificationClick(message);
    }, onResume: (Map<String, dynamic> message) async {
      onNotificationClick(message);
    });
  }

  void iOS_Permission() {
    _fireBaseMessaging.requestNotificationPermissions(IosNotificationSettings(sound: true, badge: true, alert: true));
    _fireBaseMessaging.onIosSettingsRegistered.listen((IosNotificationSettings settings) {
      print("Settings registered: $settings");
    });
  }

  // call api for set fcm token
  saveFcmToken(String token) async {
    UpdateFcmTokenRequest model = UpdateFcmTokenRequest();
    model.fcmToken = token;
    UpdateFcmResponse response = await Repository().updateFcm(model);
    if (response == null) {
      print('Response');
      print(response);
      String responseMsg = Config.SERVER_ERROR;
      //Utility.showErrorSnackBar(_globalKey, responseMsg);
    } else if (response.status) {
      // Utility.showSuccessSnackBar(_globalKey, response.message);
    } else {
      // Utility.showErrorSnackBar(_globalKey, response.message);
    }
  }

  openScreen(String i) {
    switch (i) {
      case "1":
        {
          onTabTapped(0);
        }
        break;

      case '2':
        {
          onTabTapped(1);
        }
        break;
      case '3':
        {
          onTabTapped(2);
        }
        break;
      case '4':
        {
          onTabTapped(3);
        }
        break;
      case '5':
        {
          onTabTapped(4);
        }
        break;
    }
  }

  launchURL(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  _subscribeToTopic() async {
    String userType = await PreferenceConnector().getString(PreferenceConnector.USER_TYPE);
    _fireBaseMessaging.subscribeToTopic('all');
    if (userType == "2") {
      _fireBaseMessaging.subscribeToTopic('applicants');
    } else if (userType == "3") {
      _fireBaseMessaging.subscribeToTopic('tenants');
    }
  }

  onNotificationClick(Map<String, dynamic> message) {
    final dynamic data = message['data'];
    if (data['clickActionType'] == 'app') {
      openScreen(data['clickTarget']);
    } else if (data['clickActionType'] == 'url') {
      launchURL(data['clickTarget']);
    }
  }
}
