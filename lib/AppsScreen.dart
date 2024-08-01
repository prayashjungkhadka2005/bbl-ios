import 'package:flutter/material.dart';
import 'package:device_apps/device_apps.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

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
          bodyLarge: TextStyle(color: Colors.black), // Updated property
          bodyMedium: TextStyle(color: Colors.black), // Updated property
          bodySmall: TextStyle(color: Colors.black), // Updated property
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
  List<AppInfo> securedApps = [];
  List<Application> notSecuredApps = [];

  @override
  void initState() {
    super.initState();
    getApps();
  }

  Future<void> getApps() async {
    List<Application> allApps = await DeviceApps.getInstalledApplications(
      onlyAppsWithLaunchIntent: true,
      includeAppIcons: true,
      includeSystemApps: true,
    );

    setState(() {
      notSecuredApps = allApps
          .where((app) =>
              !securedApps.any((securedApp) => securedApp.name == app.appName))
          .toList();
    });
  }

  void _addNewApp(Application app) {
    setState(() {
      securedApps.add(AppInfo(
        name: app.appName,
        icon: app is ApplicationWithIcon
            ? Image.memory(app.icon).image
            : AssetImage('assets/default_icon.png'),
      ));
      notSecuredApps.remove(app);
    });
  }

  void _showAddAppDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AddAppDialog(
          notSecuredApps: notSecuredApps,
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
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '🔒 Secure applications',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 12),
            Expanded(
              child: GridView.count(
                crossAxisCount: 4,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
                childAspectRatio: 1.0,
                children: List.generate(securedApps.length + 1, (index) {
                  if (index == securedApps.length) {
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
                    return Container(
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
                            child: Image(
                              image: securedApps[index].icon,
                            ),
                          ),
                          SizedBox(height: 8),
                          Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 8.0),
                            child: Text(
                              securedApps[index].name,
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  fontSize: 14, fontWeight: FontWeight.bold),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
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
                itemCount: notSecuredApps.length,
                itemBuilder: (context, index) {
                  Application app = notSecuredApps[index];
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

class AppInfo {
  final String name;
  final ImageProvider icon;
  AppInfo({required this.name, required this.icon});
}

class AddAppDialog extends StatelessWidget {
  final List<Application> notSecuredApps;
  final ValueChanged<Application> onAdd;

  AddAppDialog({required this.notSecuredApps, required this.onAdd});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Add Application'),
      content: SingleChildScrollView(
        child: ListBody(
          children: notSecuredApps.map((app) {
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
