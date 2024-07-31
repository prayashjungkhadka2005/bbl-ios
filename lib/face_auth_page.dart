import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:local_auth/local_auth.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'dart:convert'; // Import for encoding to base64

class AuthService {
  static final LocalAuthentication _localAuthentication = LocalAuthentication();

  static Future<bool> authenticateUser() async {
    bool isAuthenticated = false;
    try {
      bool isBiometricSupported =
          await _localAuthentication.isDeviceSupported();
      bool canCheckBiometrics = await _localAuthentication.canCheckBiometrics;

      if (isBiometricSupported && canCheckBiometrics) {
        isAuthenticated = await _localAuthentication.authenticate(
          localizedReason: 'Scan your fingerprint to authenticate',
          // Removed the undefined parameters
        );
      }
    } on PlatformException catch (e) {
      print("Error during authentication: $e");
    }
    return isAuthenticated;
  }
}

class FaceAuthPage extends StatefulWidget {
  @override
  _FaceAuthPageState createState() => _FaceAuthPageState();
}

class _FaceAuthPageState extends State<FaceAuthPage> {
  final LocalAuthentication auth = LocalAuthentication();
  bool _canCheckBiometrics = false;
  bool _canCheckFace = false;
  String _authorized = 'Not Authorized';
  String _statusMessage = 'Initializing...';

  @override
  void initState() {
    super.initState();
    _checkBiometrics();
  }

  Future<void> _checkBiometrics() async {
    try {
      bool canCheckBiometrics = await auth.canCheckBiometrics;
      List<BiometricType> biometricTypes = await auth.getAvailableBiometrics();

      setState(() {
        _canCheckBiometrics = canCheckBiometrics;
        _canCheckFace = biometricTypes.contains(BiometricType.face);

        if (_canCheckFace) {
          _statusMessage = 'Face recognition available';
        } else if (biometricTypes.isNotEmpty) {
          _statusMessage = 'Other biometric authentication available';
        } else {
          _statusMessage = 'No biometric authentication available';
        }
      });
    } catch (e) {
      setState(() {
        _canCheckBiometrics = false;
        _canCheckFace = false;
        _statusMessage = 'Error checking biometrics';
      });
      print("Error checking biometrics: $e");
    }
  }

  Future<void> _authenticate() async {
    bool authenticated = false;
    try {
      authenticated = await auth.authenticate(
        localizedReason: 'Scan your face to authenticate',
        // Removed the undefined parameters
      );
    } catch (e) {
      print("Error during authentication: $e");
      setState(() {
        _authorized = 'Authentication error';
        _statusMessage = 'Authentication error';
      });
      return;
    }

    if (authenticated) {
      // Generate a token after successful authentication
      String token = _generateToken();
      print("Generated Token: $token");
    }

    setState(() {
      _authorized = authenticated ? 'Authorized' : 'Not Authorized';
      _statusMessage = authenticated ? 'Authorized' : 'Not Authorized';
    });

    print("Authentication result: $authenticated");
  }

  // Dummy function to generate a token. Replace with your own logic.
  String _generateToken() {
    final bytes = utf8.encode(DateTime.now().toString()); // Use a unique value
    return base64Encode(bytes); // Encode to Base64
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Biometric Authentication'),
      ),
      body: Container(
        decoration: BoxDecoration(
          color: Color.fromARGB(255, 253, 253, 253),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                'assets/logo.png',
                width: 100,
                height: 100,
              ),
              const SizedBox(height: 10),
              Text(
                'Setup biometric authentication',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF000E26),
                ),
              ),
              SizedBox(height: 20),
              GestureDetector(
                onTap: () async {
                  if (_canCheckBiometrics &&
                      (_canCheckFace ||
                          _statusMessage ==
                              'Other biometric authentication available')) {
                    await _authenticate(); // Update to handle token generation
                  } else {
                    setState(() {
                      _authorized = 'No biometric authentication available';
                      _statusMessage = 'No biometric authentication available';
                    });
                  }
                },
                child: SvgPicture.asset(
                  'assets/faceauth.svg',
                  width: 200,
                  height: 200,
                  color: Color(0xFF00358C),
                ),
              ),
              SizedBox(height: 32),
              Text(
                'Status: $_statusMessage',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.black,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class PrivateScreen extends StatelessWidget {
  const PrivateScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Private Screen'),
      ),
      body: Center(
        child: Text('Welcome to the private screen!'),
      ),
    );
  }
}
