package com.plusdt.phonecallstate;


import android.telephony.PhoneStateListener;
import android.telephony.TelephonyManager;
import android.util.Log;
import android.os.RemoteException;

import android.content.Context;
import android.content.Context;

import android.app.Activity;
import io.flutter.app.FlutterActivity;

import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.common.MethodChannel.MethodCallHandler;
import io.flutter.plugin.common.MethodChannel.Result;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.PluginRegistry.Registrar;

// TODO: Implement NEW_OUTGOING_CALL Intent broadcast receiver
// TODO: Implement event direction

/**
 * PhonecallstatePlugin
 */
public class PhonecallstatePlugin implements MethodCallHandler {
  private final MethodChannel channel;
  private Activity activity;
  private static final String TAG = "KORDON";//MyClass.class.getSimpleName();

  TelephonyManager tm;

  //private PhoneStateListener mPhoneListener;

  /**
   * Plugin registration.
   */
  public static void registerWith(Registrar registrar) {
    final MethodChannel channel = new MethodChannel(registrar.messenger(), "com.plusdt.phonecallstate");
    channel.setMethodCallHandler(new PhonecallstatePlugin(registrar.activity(), channel));
  }



  PhonecallstatePlugin(Activity activity, MethodChannel channel) {
    this.activity = activity;
    this.channel = channel;
    this.channel.setMethodCallHandler(this);

    TelephonyManager tm = (TelephonyManager) this.activity.getSystemService(Context.TELEPHONY_SERVICE);
    tm.listen(mPhoneListener, PhoneStateListener.LISTEN_CALL_STATE);

  }


  @Override
  public void onMethodCall(MethodCall call, MethodChannel.Result response) {
    if (call.method.equals("phoneTest.PhoneIncoming")) {
        Log.i(TAG,"phoneIncoming Test implementation");
      // TODO: test mode with seconds to wait as parameter
    }
    else {
      response.notImplemented();
    }

  }


  private PhoneStateListener mPhoneListener = new PhoneStateListener() {
    public void onCallStateChanged(int state, String incomingNumber) {
      try {
        switch (state) {
          case TelephonyManager.CALL_STATE_IDLE:
            channel.invokeMethod("phone.disconnected", true);
            break;
          case TelephonyManager.CALL_STATE_RINGING:
            channel.invokeMethod("phone.incoming", true);
            break;
          case TelephonyManager.CALL_STATE_OFFHOOK:
            channel.invokeMethod("phone.connected", true);
            break;

          default:
            Log.d(TAG, "Unknown phone state=" + String.valueOf(state));
        }
      } catch (Exception e) {
        Log.e("TAG","Exception");
      }
    }
  };


}
