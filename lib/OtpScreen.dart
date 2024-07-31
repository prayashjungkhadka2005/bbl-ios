import 'package:flutter/material.dart';
import 'package:flutter_otp_text_field/flutter_otp_text_field.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'SecurityQueScreen.dart'; // Make sure to update the import if necessary
import 'package:logging/logging.dart';

final Logger _logger = Logger('OtpScreen');

class OtpScreen extends StatefulWidget {
  final String email;
  final String country;
  final String password;

  const OtpScreen(
      {super.key,
      required this.email,
      required this.country,
      required this.password});

  @override
  OtpScreenState createState() => OtpScreenState();
}

class OtpScreenState extends State<OtpScreen> {
  String otpCode = '';
  final Uri verifyOtpUrl = Uri.parse('http://192.168.1.79:3000/verifyotp');
  final Uri resendOtpUrl = Uri.parse('http://192.168.1.79:3000/resendotp');

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
          'email': widget.email,
          'otp': otpCode,
        }),
      );

      final responseBody = jsonDecode(response.body);

      if (response.statusCode == 200) {
        _logger.info('OTP verified successfully');
        _showSnackBar('OTP verified successfully');

        await Future.delayed(const Duration(seconds: 1));

        if (!mounted) return;
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => SecurityQueScreen(
                email: widget.email,
                country: widget.country,
                password: widget.password),
          ),
        );
      } else {
        _logger.warning('Failed to verify OTP: ${responseBody['message']}');
        _showSnackBar(responseBody['message']);
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
          'email': widget.email,
        }),
      );

      final responseBody = jsonDecode(response.body);

      if (response.statusCode == 201) {
        _logger.info('OTP resent successfully');
        _showSnackBar('OTP resent successfully');
      } else {
        _logger.warning('Failed to resend OTP: ${responseBody['message']}');
        _showSnackBar(responseBody['message']);
      }
    } catch (e) {
      _logger.severe('Error during OTP resend: $e');
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
          child: SingleChildScrollView(
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
                  "OTP Verification",
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
                    "Enter the OTP sent to your email.",
                    style: TextStyle(
                      color: Color.fromARGB(255, 116, 114, 114),
                      fontWeight: FontWeight.w700,
                      fontSize: 15,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                const SizedBox(height: 25),
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.8,
                  child: OtpTextField(
                    fieldWidth: 40.0, // Adjust width as needed
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
                ),
                const SizedBox(height: 50),
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.8,
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
                      "Verify Now",
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
      ),
    );
  }
}
