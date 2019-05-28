import 'package:flutter/material.dart';
import 'package:weather_forecast/forecast/appbar.dart';
import 'package:weather_forecast/forecast/background/background_with_rings.dart';
import 'package:weather_forecast/forecast/week_drawer.dart';
import 'package:flutter/animation.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: 'Weather Forecast',
      debugShowCheckedModeBanner: false,
      theme: new ThemeData(
        primaryColor: Colors.blue,
      ),
      home: new MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> with SingleTickerProviderStateMixin{

  OpenableController openableController;

  void initState() { 
    super.initState();
    openableController = new OpenableController(
      vsync: this,
      openDuration: new Duration(milliseconds: 250),
    )
    ..addListener(() => setState((){}))
    ..open();
  }

  @override 
  Widget build(BuildContext context){
    return new Scaffold(
      body: new Stack(
        children: <Widget>[

          new GestureDetector(
            onTap: (){
              if(openableController.isOpen()){
                 openableController.close();
              }
            },
            child: new BackgroundWithRings(),
          ),
              

          new Positioned(
            top: 0.0,
            right: 0.0,
            left: 0.0,
            child: new ForecastAppBar(
              onDrawerArrowTap: (){
                print("Drawer is Opening..");
                openableController.open();
              },
            ),
          ),

          //Creating a drawer
          new Stack(
            children: <Widget>[

              new Transform(
                transform: new Matrix4.translationValues(
                  125.0 * (1.0 - openableController.percentOpen),
                  0.0,
                  0.0 
                ),
                child: new Align(
                  alignment: Alignment.centerRight,
                  child: new WeekDrawer(
                    onDaySelected: (String title){
                      openableController.close();
                    },
                  ),
                ),
              ),
            ],
          ),

        
        ],
      )
    );
  }
}

class OpenableController extends ChangeNotifier {

  OpenableState _state = OpenableState.close;
  AnimationController _opening;

  OpenableController ({
    @required TickerProvider vsync,
    @required Duration openDuration,
  }): _opening = new AnimationController(duration: openDuration, vsync: vsync){
        _opening
        ..addListener(notifyListeners)
        ..addStatusListener((AnimationStatus status){
         switch(status){
            case AnimationStatus.forward:
            _state = OpenableState.opening;
              break;
            case AnimationStatus.completed:
            _state = OpenableState.open;
              break;
            case AnimationStatus.reverse:
            _state = OpenableState.closing;
              break;
            case AnimationStatus.dismissed:
            _state = OpenableState.close;
              break;

          }
          notifyListeners();
        });
    }
  get state => _state;

  get percentOpen => _opening.value;

  bool isOpen() => state == OpenableState.open;
  bool isClose() => state == OpenableState.close;
  bool isClosing() => state == OpenableState.closing;
  bool isOpening() => state == OpenableState.opening;

  void open(){
    _opening.forward();
  }
  void close(){
    _opening.reverse();
  }
  void toggle(){
    if(isOpen()) {
      close();
    }
    else if(isClose()){
      open();
    }
  }
}

enum OpenableState{
  close,
  opening,
  open,
  closing,
}