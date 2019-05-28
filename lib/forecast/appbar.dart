import 'package:flutter/material.dart';

class ForecastAppBar extends StatelessWidget {

  final Function() onDrawerArrowTap;

  ForecastAppBar({
    this.onDrawerArrowTap,
  });

  @override
  Widget build(BuildContext context) {
    return new AppBar(
      centerTitle: false,
      backgroundColor: Colors.transparent,
      elevation: 0.0,
      title: new Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[

          new Padding(
            padding: const EdgeInsets.only(top:2.0),
            child: new Text("Thursday, Agust 29",
              style: new TextStyle(
                color: Colors.white,
                fontSize: 16.0,
              ),
            ),
          ),


          new Text("Sacramento",
            style: new TextStyle(
              color: Colors.white,
              fontSize: 30,
            ),
          ),


        ],
      ),
      actions:<Widget>[
        IconButton(
          icon: Icon(Icons.arrow_forward_ios,size: 35.0,), 
          splashColor: Colors.white70,
          onPressed: () => onDrawerArrowTap(),
        ),
      ]
    );
  }
}