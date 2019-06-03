import 'package:flutter/material.dart';

class AboutUsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text("About Us"),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              getIcon("assets/team.png"),
              getTitle(context, "The Team"),
              getParaText(
                  "A passionate team of professionals with cumulative experience of over 5 decades in Financial Services - Products, Advisory, Sales, Operations and Technology. The team has wide experience working for blue chip Financial Services in India and Global organizations like iTrust (now proptiger), Karvy Wealth, Microsoft, ITC, Oracle, Accenture & Capco. "),
              getParaText("Increasing globalization is leading to movement of skilled resources not only within country but also internationally hence providing a unique and growing demand for property management services catering to the property owners, tenants and property advisors."),
              getParaText("We believe in creating value for rental property owners, tenants and property advisors through a digital platform for property/tenant management, to ease their lives and serve as an additional source of income. And, to offer competitively priced quality living spaces for tenants"),
              getIcon("assets/vision.png"),
              getTitle(context, "Our Vision"),
              getParaText("Complete A-Z provider of seamless & hassle-free residential property management and rental services to property owners, tenants and property advisors."),
              getIcon("assets/mission.png"),
              getTitle(context, "Our Mission"),
              getParaText("Largest provider of residential property management and rental services in India over next 5 years through effective use of technology and local ground force."),
            const SizedBox(height: 20,),
            ],
          ),
        ),
      ),
    );
  }

  Widget getTitle(BuildContext context, String text) {
    return Text(
      text,
      style: TextStyle(
          color: Theme.of(context).accentColor,
          fontSize: 25,
          fontWeight: FontWeight.w300),
    );
  }

  Widget getIcon(String name) {
    return Image.asset(
      name,
      width: 60,
      height: 60,
    );
  }

  Widget getParaText(String text) {
    return Padding(
      padding: const EdgeInsets.only(top: 10,bottom: 10),
      child: Text(
        text,
        style: TextStyle(
          color: Colors.black,
          fontWeight: FontWeight.w300,
          fontSize: 14
        ),
        textAlign: TextAlign.justify,
      ),
    );
  }
}
