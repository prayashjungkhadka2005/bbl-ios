import 'package:flutter/material.dart';
import 'fingerprint_screen.dart';
import 'patterns_screen.dart';
import 'pin_screen.dart';
import 'face_auth_page.dart';

class MyApp extends StatelessWidget {
  final String useremail;

  MyApp({super.key, required this.useremail});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: LockOption(useremail: useremail),
    );
  }
}

class LockOption extends StatefulWidget {
  final String useremail;

  const LockOption({Key? key, required this.useremail}) : super(key: key);

  @override
  _LockOptionState createState() => _LockOptionState();
}

class _LockOptionState extends State<LockOption> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Image.asset(
              'assets/logo.png',
              width: 150,
              height: 150,
            ),
            const SizedBox(height: 20),
            const Text(
              "Choose your preferred option",
              style: TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.w700,
                color: Color.fromARGB(223, 4, 4, 4),
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 15),
            _buildButton(
              context,
              icon: Icons.pin,
              text: 'PIN',
              screen: PinScreen(useremail: widget.useremail),
            ),
            const SizedBox(height: 10),
            _buildButton(
              context,
              icon: Icons.face,
              text: 'Face Lock',
              screen: FaceAuthPage(),
            ),
            const SizedBox(height: 10),
            _buildButton(
              context,
              icon: Icons.fingerprint,
              text: 'Fingerprint',
              screen: FingerprintAuthPage(),
            ),
            const SizedBox(height: 10),
            _buildButton(
              context,
              icon: Icons.pattern,
              text: 'Pattern',
              screen: PatternsScreen(useremail: widget.useremail),
            ),
            const SizedBox(height: 10),
          ],
        ),
      ),
    );
  }

  Widget _buildButton(BuildContext context,
      {required IconData icon, required String text, required Widget screen}) {
    return SizedBox(
      width: 380,
      height: 50,
      child: ElevatedButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => screen),
          );
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF000E26),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Icon(icon, color: Colors.white),
            Text(
              text,
              style: const TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const Icon(
              Icons.arrow_forward_ios,
              color: Colors.white,
            ),
          ],
        ),
      ),
    );
  }
}
