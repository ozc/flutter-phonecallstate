import Flutter
import UIKit
import CallKit


@available(iOS 10.0,*)
public class SwiftPhonecallstatePlugin: NSObject, FlutterPlugin, CXCallObserverDelegate {

    var callObserver: CXCallObserver!
    var _channel: FlutterMethodChannel

    var testTimer: Timer?
    var counter = 0


    public static func register(with registrar: FlutterPluginRegistrar) {
    let channel = FlutterMethodChannel(name: "com.plusdt.phonecallstate", binaryMessenger: registrar.messenger())
    let instance = SwiftPhonecallstatePlugin(channel:channel)
    registrar.addMethodCallDelegate(instance, channel: channel)


    }

    init(channel:FlutterMethodChannel){
        super.init()
        _channel = channel

        setupCallObserver()
    }


    @objc func timerAction() {
        counter += 1
        _channel.invokeMethod("phone.incoming", arguments: nil)
        print("Timer!")
        //testTimer.invalidate()
    }

    public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        print("iOS => call \(call.method)")

        switch (call.method) {
            case "phoneTest.PhoneIncoming":
                var testTimer = Timer.scheduledTimer(timeInterval: call.arguments as! Double,
                                target: self,
                                selector: #selector(SwiftPhonecallstatePlugin.timerAction),
                                userInfo: nil,
                                repeats: true)
        default:
            result(FlutterMethodNotImplemented)
        }

        result(1)
    }

    @available(iOS 10.0,*)
    func setupCallObserver(){
            callObserver = CXCallObserver()
            callObserver.setDelegate(self, queue: nil)
    }


    @available(iOS 10.0,*)
    public func callObserver(_ callObserver: CXCallObserver, callChanged call: CXCall) {
        if call.hasEnded == true {
            print("CXCallState :Disconnected")
             _channel.invokeMethod("phone.disconnected", arguments: nil)
        }
        if call.isOutgoing == true && call.hasConnected == false {
            print("CXCallState :Dialing")
            _channel.invokeMethod("phone.dialing", arguments: nil)
        }
        if call.isOutgoing == false && call.hasConnected == false && call.hasEnded == false {
            print("CXCallState :Incoming")
            _channel.invokeMethod("phone.incoming", arguments: nil)
        }

        if call.hasConnected == true && call.hasEnded == false {
            print("CXCallState : Connected")
             _channel.invokeMethod("phone.connected", arguments: nil)
        }
    }

}


// reference
// https://stackoverflow.com/questions/42557701/can-callkit-be-used-with-non-voip-call-to-get-the-call-states-in-ios?rq=1
