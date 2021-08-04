import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

typedef void ErrorHandler(String message);

class Phonecallstate {
  static const MethodChannel _channel =
  const MethodChannel('com.plusdt.phonecallstate');

  VoidCallback? incomingHandler;
  VoidCallback? dialingHandler;
  VoidCallback? connectedHandler;
  VoidCallback? disconnectedHandler;
  ErrorHandler? errorHandler;


  Phonecallstate(){
    _channel.setMethodCallHandler(platformCallHandler);
  }

  Future<dynamic> setTestMode(double seconds) => _channel.invokeMethod('phoneTest.PhoneIncoming', seconds);

  void setIncomingHandler(VoidCallback? callback) {
    incomingHandler = callback;
  }
  void setDialingHandler(VoidCallback? callback) {
    dialingHandler = callback;
  }
  void setConnectedHandler(VoidCallback? callback) {
    connectedHandler = callback;
  }
  void setDisconnectedHandler(VoidCallback? callback) {
    disconnectedHandler = callback;
  }

  void setErrorHandler(ErrorHandler? handler) {
    errorHandler = handler;
  }


  Future platformCallHandler(MethodCall call) async {
    print("_platformCallHandler call ${call.method} ${call.arguments}");
    switch (call.method) {
      case "phone.incoming":
        print("incoming");
        incomingHandler?.call();
        break;
      case "phone.dialing":
      //print("dialing");
        dialingHandler?.call();
        break;
      case "phone.connected":
      //print("connected");
        connectedHandler?.call();
        break;
      case "phone.disconnected":
      //print("disconnected");
        disconnectedHandler?.call();
        break;
      case "phone.onError":
        errorHandler?.call(call.arguments);
        break;
      default:
        print('Unknown method ${call.method} ');
    }
  }


  static Future<String> get platformVersion async {
    final String version = await _channel.invokeMethod('getPlatformVersion');
    return version;
  }
}
