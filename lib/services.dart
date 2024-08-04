import 'package:bbl_security/pin_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class AuthenticationService {
  static const platform = MethodChannel('com.example.app/auth');

  // static get useremail => null;

  static Future<void> setupChannel() async {
    platform.setMethodCallHandler((call) async {
      if (call.method == 'requestAuth') {
        // Show authentication screen
        var navigatorKey;
        bool success = await Navigator.push(
          navigatorKey.currentContext!,
          MaterialPageRoute(
              builder: (context) => PinScreen(useremail: useremail)),
        );

        return success;
      }
    });
  }
}

class AuthenticationScreen {}
