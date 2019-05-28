import 'package:flutter/material.dart';

class BackgroundWithRings extends StatelessWidget {
  
  @override
  Widget build(BuildContext context) {
    return Stack(
          fit: StackFit.expand,
          children: <Widget>[

            new Image.asset("assets/weather-bk_enlarged.png",
              fit: BoxFit.cover,
            ),

            new ClipOval(
              clipper: new CircleClipper(
                offset: new Offset(40.0, 0.0),
                radius: 140.0,
              ),
              child: new Image.asset("assets/weather-bk.png",
                fit:BoxFit.cover
              ),
            ),

            new CustomPaint(
              foregroundPainter: new WhiteCircleCutOutPainter(
                centerOffset: new Offset(40.0, 0.0),
                circles: <Circle>[
                  Circle(radius: 140.0, alpha: 0x10),
                  Circle(radius: 140.0 + 15.0, alpha: 0x28),
                  Circle(radius: 140.0 + 30.0, alpha: 0x38),
                  Circle(radius: 140.0 + 75.0, alpha: 0x50),
                ]
              ),
              child: Container(),
            ),

          ]
        );
  }
}

class WhiteCircleCutOutPainter extends CustomPainter{

  final Color layoutColor = new Color(0xFFAA88AA);

  final Offset centerOffset;
  final List<Circle> circles;
  final Paint whitePaint;
  final Paint borderPaint;

  WhiteCircleCutOutPainter({
    this.centerOffset = const Offset(0.0, 0.0),
    this.circles = const [],
  }): whitePaint = new  Paint(),
      borderPaint = new Paint()
      ..color = new Color(0x10FFFFFF)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.5;

  _maskCircle(Canvas canvas, Size size, double radius){
      Path clippedCircle = new Path();
      clippedCircle.fillType = PathFillType.evenOdd;
      clippedCircle.addRect(Rect.fromLTWH(0.0, 0.0, size.width, size.height));
      clippedCircle.addOval(
        new Rect.fromCircle(
          center: new Offset(0.0, size.height/2) + centerOffset,
          radius: radius,
        ),
      );
    canvas.clipPath(clippedCircle);
  }
  @override
  void paint(Canvas canvas, Size size) {
    
    for(var i = 1; i < circles.length; ++i){

      _maskCircle(canvas,size,circles[i-1].radius);
      whitePaint.color = layoutColor.withAlpha(circles[i-1].alpha);

      //fill circles
      canvas.drawCircle(
        new Offset(0.0, size.height/2) + centerOffset, 
        circles[i].radius, 
        whitePaint
      );

      //make a circle border
      canvas.drawCircle(
        new Offset(0.0, size.height/2) + centerOffset, 
        circles[i-1].radius, 
        borderPaint
      );
    }//for loop end

    //mask the area of final circle
      _maskCircle(canvas, size, circles.last.radius);

    //Draw an ovrlay that fills the rest of the screen
    whitePaint.color = layoutColor.withAlpha(circles.last.alpha);
    canvas.drawRect(
        new Rect.fromLTWH(0.0, 0.0, size.width, size.height), 
        whitePaint
    );
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;
}


class CircleClipper extends CustomClipper<Rect>{

  final Offset offset;
  final double radius;

  CircleClipper({
    this.offset = const Offset(0.0, 0.0),
    this.radius,
  });

  @override
  Rect getClip(Size size) {
    return Rect.fromCircle(
      center: new Offset(0.0, size.height/2) + offset,
      radius: radius,
    );
  }

  @override
  bool shouldReclip(CustomClipper<Rect> oldClipper) => true;

}

class Circle{
  final double radius;
  final int alpha;

  Circle({
    this.radius, 
    this.alpha = 0xFF,
  });
}