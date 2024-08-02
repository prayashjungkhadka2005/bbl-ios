import 'package:flutter/material.dart';
import 'package:device_apps/device_apps.dart';

void main() {
  runApp(BBLSecurityApp());
}

class BBLSecurityApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'BBL Security',
      theme: ThemeData(
        primarySwatch: MaterialColor(
          0xFF000E26,
          {
            50: Color(0xFFE1E6F0),
            100: Color(0xFFB3BCCF),
            200: Color(0xFF8093AA),
            300: Color(0xFF4D6B8D),
            400: Color(0xFF1A3A6A),
            500: Color(0xFF000E26),
            600: Color(0xFF000B22),
            700: Color(0xFF00081E),
            800: Color(0xFF00051A),
            900: Color(0xFF00010D),
          },
        ),
        appBarTheme: AppBarTheme(
          backgroundColor: Color(0xFF000E26),
          titleTextStyle: TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        textTheme: TextTheme(
          bodyLarge: TextStyle(color: Colors.black),
          bodyMedium: TextStyle(color: Colors.black),
          bodySmall: TextStyle(color: Colors.black),
        ),
      ),
      home: AppsScreen(),
    );
  }
}

class AppsScreen extends StatefulWidget {
  @override
  _AppsScreenState createState() => _AppsScreenState();
}

class _AppsScreenState extends State<AppsScreen> {
  List<Application> allApps = [];
  List<String> securedAppNames = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    getApps();
  }

  Future<void> getApps() async {
    try {
      List<Application> apps = await DeviceApps.getInstalledApplications(
        onlyAppsWithLaunchIntent: true,
        includeAppIcons: true,
        includeSystemApps: true,
      );

      // Sort apps alphabetically by their names
      apps.sort(
          (a, b) => a.appName.toLowerCase().compareTo(b.appName.toLowerCase()));

      setState(() {
        allApps = apps;
        isLoading = false;
      });
    } catch (e) {
      print('Error fetching apps: $e');
      setState(() {
        isLoading = false;
      });
    }
  }

  List<Application> getSecuredApps() {
    List<Application> securedApps =
        allApps.where((app) => securedAppNames.contains(app.appName)).toList();
    securedApps.sort(
        (a, b) => a.appName.toLowerCase().compareTo(b.appName.toLowerCase()));
    return securedApps;
  }

  List<Application> getNotSecuredApps() {
    List<Application> notSecuredApps =
        allApps.where((app) => !securedAppNames.contains(app.appName)).toList();
    notSecuredApps.sort(
        (a, b) => a.appName.toLowerCase().compareTo(b.appName.toLowerCase()));
    return notSecuredApps;
  }

  void _addNewApp(Application app) {
    setState(() {
      securedAppNames.add(app.appName);
    });
  }

  void _showConfirmationDialog(
    BuildContext context,
    Application app,
    VoidCallback onConfirm,
  ) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // User must tap a button to close the dialog
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            'Confirm Action',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.blueAccent,
            ),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.warning_amber_outlined,
                size: 48,
                color: Colors.amber,
              ),
              SizedBox(height: 16),
              Text(
                'Are you sure you want to move "${app.appName}" from the secured list to the unsecured list?\n\n'
                'This action will make "${app.appName}" accessible without additional security. Please confirm if you wish to proceed.',
                style: TextStyle(fontSize: 16, color: Colors.black87),
                textAlign: TextAlign.center,
              ),
            ],
          ),
          actions: <Widget>[
            TextButton(
              style: TextButton.styleFrom(
                foregroundColor: Colors.redAccent,
              ),
              child: Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xFF000E26), // Background color
                foregroundColor: Colors.white, // Text color
              ),
              child: Text('Confirm'),
              onPressed: () {
                onConfirm(); // Call the function to remove the app
                Navigator.of(context).pop(); // Close the dialog
              },
            ),
          ],
        );
      },
    );
  }

  void _removeAppFromSecured(Application app) {
    _showConfirmationDialog(
      context,
      app,
      () {
        setState(() {
          securedAppNames.remove(app.appName);
        });
      },
    );
  }

  void _showAddAppDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AddAppDialog(
          notSecuredApps: getNotSecuredApps(),
          onAdd: _addNewApp,
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Image.asset(
              'assets/logo.png',
              width: 40,
              height: 40,
            ),
            SizedBox(width: 10),
            Text(
              'BBL Security',
              style: Theme.of(context).appBarTheme.titleTextStyle,
            ),
          ],
        ),
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '🔒 Secure Applications',
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 12),
                  Expanded(
                    child: GridView.count(
                      crossAxisCount: 4,
                      crossAxisSpacing: 12,
                      mainAxisSpacing: 12,
                      childAspectRatio: 1.0,
                      children:
                          List.generate(getSecuredApps().length + 1, (index) {
                        if (index == getSecuredApps().length) {
                          return GestureDetector(
                            onTap: _showAddAppDialog,
                            child: Container(
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(12),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.grey.withOpacity(0.3),
                                    spreadRadius: 2,
                                    blurRadius: 6,
                                  ),
                                ],
                              ),
                              child: Center(
                                child: Icon(
                                  Icons.add,
                                  size: 36,
                                  color: Color(0xFF000E26),
                                ),
                              ),
                            ),
                          );
                        } else {
                          Application app = getSecuredApps()[index];
                          return GestureDetector(
                            onTap: () => _removeAppFromSecured(app),
                            child: Container(
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(12),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.grey.withOpacity(0.3),
                                    spreadRadius: 2,
                                    blurRadius: 6,
                                  ),
                                ],
                              ),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  SizedBox(
                                    width: 40,
                                    height: 40,
                                    child: app is ApplicationWithIcon
                                        ? Image.memory(app.icon)
                                        : Icon(Icons.android, size: 40),
                                  ),
                                  SizedBox(height: 8),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 8.0),
                                    child: Text(
                                      app.appName,
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.bold),
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        }
                      }),
                    ),
                  ),
                  SizedBox(height: 12),
                  Text(
                    '⚠️ Not Secured',
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 12),
                  Expanded(
                    child: ListView.builder(
                      itemCount: getNotSecuredApps().length,
                      itemBuilder: (context, index) {
                        Application app = getNotSecuredApps()[index];
                        return Card(
                          elevation: 4,
                          margin: EdgeInsets.symmetric(vertical: 4),
                          child: ListTile(
                            leading: app is ApplicationWithIcon
                                ? Image.memory(app.icon, width: 40, height: 40)
                                : Icon(Icons.android, size: 40),
                            title: Text(app.appName),
                            trailing: Icon(Icons.lock_outline),
                            onTap: () => _addNewApp(app),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}

class AddAppDialog extends StatelessWidget {
  final List<Application> notSecuredApps;
  final ValueChanged<Application> onAdd;

  AddAppDialog({required this.notSecuredApps, required this.onAdd});

  @override
  Widget build(BuildContext context) {
    // Sort not secured apps alphabetically
    List<Application> sortedNotSecuredApps = notSecuredApps.toList()
      ..sort(
          (a, b) => a.appName.toLowerCase().compareTo(b.appName.toLowerCase()));

    return AlertDialog(
      title: Text('Add Application'),
      content: SingleChildScrollView(
        child: ListBody(
          children: sortedNotSecuredApps.map((app) {
            return ListTile(
              leading: app is ApplicationWithIcon
                  ? Image.memory(app.icon, width: 40, height: 40)
                  : Icon(Icons.android, size: 40),
              title: Text(app.appName),
              onTap: () {
                onAdd(app);
                Navigator.of(context).pop();
              },
            );
          }).toList(),
        ),
      ),
    );
  }
}
