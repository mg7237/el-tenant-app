import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class ShowFullScreenImage extends StatefulWidget{
  String fileName="";
  ShowFullScreenImage(String fileName){
    this.fileName=fileName;
  }
  @override
  State<StatefulWidget> createState() {
    return ShowFullScreenImageState();
  }
}
class ShowFullScreenImageState extends State<ShowFullScreenImage>{
  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        leading: Container(),
        actions: <Widget>[
          InkWell(
              onTap: (){
                Navigator.pop(context);
              },
              child: Icon(Icons.clear,color: Colors.white,)),
          SizedBox(
            width: 20,
          )
        ],
      ),
      body: Container(
        margin: EdgeInsets.only(bottom: 50),
        height: double.infinity,
        width: double.infinity,
        child: CachedNetworkImage(
          imageUrl: widget.fileName,
          placeholder: (context, url) => new CircularProgressIndicator(
            strokeWidth: 1,
          ),
          errorWidget: (context, url, error) => new Icon(
            Icons.broken_image,
            size: 60,
            color: Colors.grey,
          ),
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}