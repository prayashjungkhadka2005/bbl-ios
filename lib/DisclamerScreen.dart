import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'LockOption.dart';

class DisclamerScreen extends StatefulWidget {
  final String useremail;

  const DisclamerScreen({Key? key, required this.useremail}) : super(key: key);

  @override
  _DisclamerScreenState createState() => _DisclamerScreenState();
}

class _DisclamerScreenState extends State<DisclamerScreen> {
  bool _rememberMe = false;
  bool _showError = false;

  void _verifyTermsAndConditions() async {
    final url =
        'http://192.168.1.79:3000/disclaimer'; // Ensure this URL is correct
    try {
      final response = await http.post(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/json',
        },
        body: json.encode({'email': widget.useremail, 'call': 'calling'}),
      );

      print('Status code: ${response.statusCode}');
      print('Response body: ${response.body}');

      if (response.statusCode == 201) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
              builder: (context) => LockOption(useremail: widget.useremail)),
        );
      } else {
        showError(
            'Failed to verify terms and conditions. ${response.reasonPhrase}');
      }
    } catch (e) {
      showError('An error occurred: $e');
    }
  }

  void showError(String message) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
      ),
    );
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
                "Disclaimer",
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.w700,
                  color: Color.fromARGB(223, 4, 4, 4),
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 15),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 40.0),
                child: Text(
                  "BBL Security is designed to enhance the privacy and security of your apps and personal information. While we strive to provide robust protection, we cannot guarantee absolute security against all possible threats. Users are responsible for maintaining the confidentiality of their passwords and other access credentials. BBL Security is not liable for any data loss or unauthorized access resulting from user negligence or misuse of the app. By using this app, you agree to these terms and conditions.",
                  style: TextStyle(
                    color: Color(0xFF000000),
                    fontWeight: FontWeight.w400,
                    fontSize: 15,
                  ),
                  textAlign: TextAlign.justify,
                ),
              ),
              const SizedBox(height: 25),
              Padding(
                padding: const EdgeInsets.only(left: 45.0),
                child: Row(
                  children: <Widget>[
                    CustomCircularCheckbox(
                      value: _rememberMe,
                      onChanged: (value) {
                        setState(() {
                          _rememberMe = value ?? false;
                          _showError = false;
                        });
                      },
                      error: _showError,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      "I agree to these terms and conditions.",
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: _showError
                            ? Colors.red
                            : Color.fromARGB(255, 0, 0, 0),
                      ),
                    ),
                  ],
                ),
              ),
              if (_showError)
                const Padding(
                  padding: EdgeInsets.only(
                    top: 10.0,
                    left: 20.0,
                  ),
                  child: Text(
                    "Please agree to the terms and conditions.",
                    style: TextStyle(
                        color: Colors.red,
                        fontSize: 12,
                        fontWeight: FontWeight.bold),
                  ),
                ),
              const SizedBox(height: 25),
              SizedBox(
                width: 380,
                height: 50,
                child: ElevatedButton(
                  onPressed: () {
                    if (_rememberMe) {
                      _verifyTermsAndConditions();
                    } else {
                      setState(() {
                        _showError = true;
                      });
                    }
                  },
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
            ],
          ),
        ),
      ),
    );
  }
}

class CustomCircularCheckbox extends StatelessWidget {
  final bool value;
  final ValueChanged<bool?> onChanged;
  final bool error;

  const CustomCircularCheckbox({
    super.key,
    required this.value,
    required this.onChanged,
    this.error = false,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        onChanged(!value);
      },
      child: Container(
        width: 20,
        height: 20,
        decoration: BoxDecoration(
          shape: BoxShape.rectangle,
          border: Border.all(
            color: error ? Colors.red : Colors.black,
            width: 2,
          ),
          color: value ? Color(0xFF0084FF) : Colors.transparent,
        ),
        child: value
            ? const Icon(
                Icons.check,
                color: Colors.white,
                size: 16,
              )
            : null,
      ),
    );
  }
}
