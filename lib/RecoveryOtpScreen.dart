import 'package:bbl_security/DisclamerScreen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_otp_text_field/flutter_otp_text_field.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:logging/logging.dart';

final Logger _logger = Logger('RecoveryOtpScreen');

class RecoveryOtpScreen extends StatefulWidget {
  final String useremail;
  final String recoveryemail;
  final String qns1;
  final String qns2;
  final String ans1;
  final String ans2;
  final String country;
  final String password;

  const RecoveryOtpScreen(
      {super.key,
      required this.useremail,
      required this.recoveryemail,
      required this.qns1,
      required this.qns2,
      required this.ans1,
      required this.ans2,
      required this.country,
      required this.password});

  @override
  _RecoveryOtpScreenState createState() => _RecoveryOtpScreenState();
}

class _RecoveryOtpScreenState extends State<RecoveryOtpScreen> {
  String otpCode = '';
  final Uri verifyOtpUrl = Uri.parse('http://localhost:3000/setSecurity');
  final Uri resendOtpUrl = Uri.parse('http://localhost:3000/resendRecoveryOtp');

  void _submitOtp() async {
    if (otpCode.length != 6) {
      _logger.warning('OTP code must be 6 digits long');
      _showSnackBar('Please enter a 6-digit OTP');
      return;
    }

    try {
      final response = await http.post(
        verifyOtpUrl,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'useremail': widget.useremail,
          'recoveryemail': widget.recoveryemail,
          'qns1': widget.qns1,
          'qns2': widget.qns2,
          'ans1': widget.ans1,
          'ans2': widget.ans2,
          'otp': otpCode,
          'country': widget.country,
          'password': widget.password
        }),
      );

      if (response.statusCode == 200) {
        _logger.info('OTP verified successfully');
        _showSnackBar('OTP verified successfully');

        await Future.delayed(const Duration(seconds: 1));

        if (!mounted) return;
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => DisclamerScreen(useremail: widget.useremail),
          ),
        );
      } else {
        _logger.warning('${response.body}');
        _showSnackBar('Incorrect OTP. Please try again.');
      }
    } catch (e) {
      _logger.severe('Error during OTP verification: $e');
      _showSnackBar('Error during OTP verification');
    }
  }

  void _resendOtp() async {
    try {
      final response = await http.post(
        resendOtpUrl,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'recoveryemail': widget.recoveryemail,
          'useremail': widget.useremail
        }),
      );

      if (response.statusCode == 201) {
        _logger.info('OTP resent successfully');
        _showSnackBar('Confirmation OTP resent successfully');
      } else {
        _logger.warning('${response.body}');
        _showSnackBar('Failed to resend Confirmation OTP. Please try again.');
      }
    } catch (e) {
      _logger.severe('$e');
      _showSnackBar('Error during OTP resend');
    }
  }

  void _showSnackBar(String message) {
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(message)),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Image.asset(
                'assets/logo.png',
                width: 100,
                height: 100,
              ),
              const SizedBox(height: 20),
              const Text(
                "Recovery OTP Verification",
                style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.w700,
                    color: Color.fromARGB(223, 4, 4, 4)),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 15),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 40.0),
                child: Text(
                  "Enter the recovery OTP sent to your email.",
                  style: TextStyle(
                    color: Color.fromARGB(255, 116, 114, 114),
                    fontWeight: FontWeight.w700,
                    fontSize: 15,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              const SizedBox(height: 25),
              OtpTextField(
                fieldWidth: 50.0,
                numberOfFields: 6,
                borderColor: const Color(0xFF512DA8),
                showFieldAsBox: true,
                onCodeChanged: (String code) {
                  setState(() {
                    otpCode = code;
                  });
                },
                onSubmit: (String verificationCode) {
                  setState(() {
                    otpCode = verificationCode;
                  });
                },
              ),
              const SizedBox(height: 50),
              SizedBox(
                width: 380,
                height: 50,
                child: ElevatedButton(
                  onPressed: _submitOtp,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF000E26),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: const Text(
                    "Verify Recovery Email",
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  GestureDetector(
                    onTap: _resendOtp,
                    child: const Text(
                      "Resend OTP Code",
                      style: TextStyle(
                          color: Color(0xFF000E26),
                          fontSize: 18,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
