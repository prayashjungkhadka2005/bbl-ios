import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import '../LoginScreen.dart';

class PermissionHandler {
  static Future<bool> requestPermissions() async {
    // Define the permissions you need to request
    List<Permission> permissions = [
      Permission.camera,
      Permission.microphone,
      Permission.location,
      Permission.storage,
      Permission.manageExternalStorage,
    ];
    // Request the permissions and get the statuses
    Map<Permission, PermissionStatus> statuses = {};
    for (var permission in permissions) {
      statuses[permission] = await permission.request();
    }
    // Check if all permissions are granted
    bool allGranted = statuses.values.every((status) => status.isGranted);
    return allGranted;
  }

  static Future<void> checkPermissions() async {
    // Define the permissions you want to check
    List<Permission> permissions = [
      Permission.camera,
      Permission.microphone,
      Permission.location,
      Permission.storage,
      Permission.manageExternalStorage,
    ];
    // Get the statuses of all permissions
    Map<Permission, PermissionStatus> statuses = {};
    for (var permission in permissions) {
      statuses[permission] = await permission.status;
    }
    // Print the status of each permission
    for (var entry in statuses.entries) {
      Permission permission = entry.key;
      PermissionStatus status = entry.value;
      print(
          'Permission: ${permission.toString()}, Status: ${status.toString()}');
    }
  }

  static Future<void> openSettings() async {
    await openAppSettings();
  }

  static checkManageExternalStoragePermission() {}
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    _checkAndRequestPermissions();
  }

  Future<void> _checkAndRequestPermissions() async {
    try {
      bool allPermissionsGranted = await PermissionHandler.requestPermissions();
      if (!allPermissionsGranted) {
        _showPermissionDeniedDialog();
      } else {
        _navigateToLoginScreen();
      }
    } catch (e) {
      print("Error checking permissions: $e");
    }
  }

  void _showPermissionDeniedDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Permissions required"),
        content: Text(
            "This app needs the necessary permissions to function properly. Please grant the permissions."),
        actions: [
          TextButton(
            onPressed: () async {
              await PermissionHandler.openSettings();
              Navigator.of(context).pop();
            },
            child: Text("Open Settings"),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text("Cancel"),
          ),
        ],
      ),
    );
  }

  void _navigateToLoginScreen() {
    Future.delayed(const Duration(seconds: 2), () {
      Navigator.pushReplacement(
        context,
        PageRouteBuilder(
          pageBuilder: (context, animation, secondaryAnimation) =>
              const LoginScreen(), // Ensure LoginScreen is correctly defined and imported
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            const begin = Offset(0.0, 1.0);
            const end = Offset.zero;
            const curve = Curves.ease;
            var tween =
                Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
            return SlideTransition(
              position: animation.drive(tween),
              child: child,
            );
          },
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Image.asset(
              'assets/logo.png',
              width: 250,
              height: 250,
            ),
            const SizedBox(height: 20),
            const Text(
              "BBL Security",
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
                "Ultimate App Lock with Premium Protection",
                style: TextStyle(
                  color: Color.fromARGB(255, 116, 114, 114),
                  fontWeight: FontWeight.w700,
                  fontSize: 15,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'BBL Security',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const HomeScreen(),
    );
  }
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  bool allPermissionsGranted = await PermissionHandler.requestPermissions();
  if (allPermissionsGranted) {
    print("All permissions granted");
  } else {
    print("Some permissions are denied");
  }
  runApp(const MyApp());
}
