import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:phonecallstate/phonecallstate.dart';

void main() => runApp(new MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => new _MyAppState();
}

enum PhonecallState { incoming, dialing, connected, disconnected, none }
enum PhonecallStateError { notimplementedyet  }

class _MyAppState extends State<MyApp> {

  Phonecallstate  phonecallstate;
  PhonecallState phonecallstatus;

  var  phonecallstatuslog;

  @override
  initState() {
    super.initState();
    initPhonecallstate();
  }

  void initPhonecallstate() async {
    print("Phonecallstate init");

    phonecallstate = new Phonecallstate();
    phonecallstatus = PhonecallState.none;


    phonecallstate.setIncomingHandler(() {
      setState(() {
        phonecallstatus = PhonecallState.incoming;
        phonecallstatuslog =  phonecallstatuslog.toString() + PhonecallState.incoming.toString()+"\n";
      });
    });

    phonecallstate.setDialingHandler(() {
      setState(() {
        phonecallstatus = PhonecallState.dialing;
        phonecallstatuslog =  phonecallstatuslog.toString() + PhonecallState.dialing.toString()+"\n";
      });
    });

    phonecallstate.setConnectedHandler(() {
      setState(() {
        phonecallstatus = PhonecallState.connected;
        phonecallstatuslog =  phonecallstatuslog.toString() + PhonecallState.connected.toString()+"\n";
      });
    });

    phonecallstate.setDisconnectedHandler(() {
      setState(() {
        phonecallstatus = PhonecallState.disconnected;
        phonecallstatuslog =  phonecallstatuslog.toString() + PhonecallState.disconnected.toString()+"\n";
      });
    });

    phonecallstate.setErrorHandler((msg) {

    });
  }





  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      home: new Scaffold(
        appBar: new AppBar(
          title: new Text('Phone Call State example app'),
        ),
        body: new Text('Last state: $phonecallstatuslog'),
      ),
    );
  }
}
