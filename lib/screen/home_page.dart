import 'package:easyleases_tenant/screen/agreement_page.dart';
import 'package:easyleases_tenant/screen/dashboard_page.dart';
import 'package:easyleases_tenant/screen/my_profile_page.dart';
import 'package:easyleases_tenant/screen/payment_tab/payment_page.dart';
import 'package:easyleases_tenant/screen/service_request/requests_page.dart';
import 'package:easyleases_tenant/widget/my_drawer.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final GlobalKey<ScaffoldState> _globalKey = GlobalKey<ScaffoldState>();

  String _currentTitle = 'Dashboard';
  int _currentIndex = 0;
  final pageController = PageController();
  List<Widget> _children;

  @override
  void initState() {
    _buildChildrenList();
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
      ),
    );
  }

  _buildChildrenList() {
    _children = [
      DashboardPage(),
      MyProfilePage(),
      AgreementPage(),
      PaymentPage(),
      RequestsPage(),
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
            _currentIndex == 0
                ? "assets/icon/dashboard_white.png"
                : "assets/icon/dashboard_gray.png",
            width: 19,
            height: 19,
          ),
          title: Text("Dashboard"),
        ),
        BottomNavigationBarItem(
          icon: Image.asset(
            _currentIndex == 1
                ? "assets/icon/profile_white.png"
                : "assets/icon/profile_gray.png",
            width: 19,
            height: 19,
          ),
          title: Text("My Profile"),
        ),
        BottomNavigationBarItem(
          icon: Image.asset(
            _currentIndex == 2
                ? "assets/icon/agreements_white.png"
                : "assets/icon/agreements_gray.png",
            width: 19,
            height: 19,
          ),
          title: Text("Agreements"),
        ),
        BottomNavigationBarItem(
          icon: Image.asset(
            _currentIndex == 3
                ? "assets/icon/payment_white.png"
                : "assets/icon/payment_gray.png",
            width: 19,
            height: 19,
          ),
          title: Text("Payments"),
        ),
        BottomNavigationBarItem(
          icon: Image.asset(
            _currentIndex == 4
                ? "assets/icon/service_requests_white.png"
                : "assets/icon/service_requests_gray.png",
            width: 19,
            height: 19,
          ),
          title: Text("Requests"),
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
    });
    pageController.jumpToPage(index);
  }
}
