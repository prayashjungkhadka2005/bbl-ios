import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'RecoveryOtpScreen.dart';

class SecurityQueScreen extends StatefulWidget {
  final String email;
  final String country;
  final String password;

  const SecurityQueScreen(
      {Key? key,
      required this.email,
      required this.country,
      required this.password})
      : super(key: key);

  @override
  _SecurityQueScreenState createState() => _SecurityQueScreenState();
}

class _SecurityQueScreenState extends State<SecurityQueScreen> {
  TextEditingController answer1Controller = TextEditingController();
  TextEditingController answer2Controller = TextEditingController();
  TextEditingController recoveryEmailController = TextEditingController();

  bool _question1Error = false;
  bool _question2Error = false;
  bool _question3Error = false;
  String? _question1ErrorMessage;
  String? _question2ErrorMessage;
  String? _question3ErrorMessage;

  void submitSecurityQuestions() async {
    setState(() {
      _question1Error = answer1Controller.text.isEmpty;
      _question2Error = answer2Controller.text.isEmpty;
      _question3Error = recoveryEmailController.text.isEmpty;

      _question1ErrorMessage =
          _question1Error ? 'This field cannot be empty' : null;
      _question2ErrorMessage =
          _question2Error ? 'This field cannot be empty' : null;
      _question3ErrorMessage =
          _question3Error ? 'This field cannot be empty' : null;
    });

    if (_question1Error || _question2Error || _question3Error) {
      return;
    }

    final String qns1 = "What is your first pet name?";
    final String qns2 = "Where were you born?";
    final String ans1 = answer1Controller.text;
    final String ans2 = answer2Controller.text;
    final String recoveryEmail = recoveryEmailController.text;

    final Uri url = Uri.parse('http://localhost:3000/recoveryMail');

    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'useremail': widget.email,
          'recoveryemail': recoveryEmail,
          'qns1': qns1,
          'qns2': qns2,
          'ans1': ans1,
          'ans2': ans2,
        }),
      );

      final responseBody = jsonDecode(response.body);

      if (response.statusCode == 201 && mounted) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => RecoveryOtpScreen(
                useremail: widget.email,
                recoveryemail: recoveryEmail,
                qns1: qns1,
                qns2: qns2,
                ans1: ans1,
                ans2: ans2,
                country: widget.country,
                password: widget.password),
          ),
        );
      } else {
        showError('${responseBody['message']}');
      }
    } catch (e) {
      showError('Failed to send recovery email: $e');
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
                  "Setup Security Questions",
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
                    "One step away to make your mobile secure",
                    style: TextStyle(
                      color: Color.fromARGB(255, 116, 114, 114),
                      fontWeight: FontWeight.w700,
                      fontSize: 15,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                const SizedBox(height: 25),
                const Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    "1. What is your first pet name?",
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                TextField(
                  controller: answer1Controller,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    hintText: 'Enter your answer',
                    errorText: _question1ErrorMessage,
                  ),
                ),
                const SizedBox(height: 25),
                const Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    "2. Where were you born?",
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                TextField(
                  controller: answer2Controller,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    hintText: 'Enter your answer',
                    errorText: _question2ErrorMessage,
                  ),
                ),
                const SizedBox(height: 25),
                const Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    "3. Recovery Email?",
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                TextField(
                  controller: recoveryEmailController,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    hintText: 'Enter your recovery email',
                    errorText: _question3ErrorMessage,
                  ),
                ),
                const SizedBox(height: 25),
                SizedBox(
                  width: 380,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: submitSecurityQuestions,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF000E26),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: const Text(
                      "Let's Go",
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
