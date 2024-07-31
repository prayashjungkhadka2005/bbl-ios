import 'package:flutter/material.dart';
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
        primarySwatch: Colors.blue,
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
  List<AppInfo> securedApps = [
    AppInfo(name: "Instagram", icon: FontAwesomeIcons.instagram),
    AppInfo(name: "Facebook", icon: FontAwesomeIcons.facebook),
    AppInfo(name: "Discord", icon: FontAwesomeIcons.discord),
    AppInfo(name: "Pinterest", icon: FontAwesomeIcons.pinterest),
    AppInfo(name: "Gmail", icon: FontAwesomeIcons.envelope),
    AppInfo(name: "WeChat", icon: FontAwesomeIcons.weixin),
    AppInfo(name: "Snapchat", icon: FontAwesomeIcons.snapchat),
    AppInfo(name: "Telegram", icon: FontAwesomeIcons.telegram),
    AppInfo(name: "Threads", icon: FontAwesomeIcons.xTwitter),
    AppInfo(name: "WhatsApp", icon: FontAwesomeIcons.whatsapp),
    AppInfo(name: "Youtube", icon: FontAwesomeIcons.youtube),
  ];

  List<AppInfo> notSecuredApps = [
    AppInfo(name: "LinkedIn", icon: FontAwesomeIcons.linkedin),
    AppInfo(name: "Tiktok", icon: FontAwesomeIcons.tiktok),
    AppInfo(name: "Wordpress", icon: FontAwesomeIcons.wordpress),
    AppInfo(name: "ChatGPT", icon: FontAwesomeIcons.robot),
    AppInfo(name: "Viber", icon: FontAwesomeIcons.viber),
  ];

  void _addNewApp(AppInfo app) {
    setState(() {
      securedApps.add(app);
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
        title: Text('BBL Security'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Image.asset(
                'assets/logo.png',
                width: 150,
                height: 150,
              ),
            ),
            Text(
              'Secure applications',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Expanded(
              child: GridView.count(
                crossAxisCount: 4,
                children: List.generate(securedApps.length + 1, (index) {
                  if (index == securedApps.length) {
                    return IconButton(
                      icon: Icon(Icons.add),
                      onPressed: _showAddAppDialog,
                    );
                  } else {
                    return Column(
                      children: [
                        Icon(securedApps[index].icon, size: 40),
                        Text(securedApps[index].name,
                            textAlign: TextAlign.center),
                      ],
                    );
                  }
                }),
              ),
            ),
            SizedBox(height: 10),
            Text(
              'Not Secured',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Expanded(
              child: ListView(
                children: notSecuredApps.map((app) {
                  return ListTile(
                    leading: Icon(app.icon),
                    title: Text(app.name),
                    trailing: Icon(Icons.lock_outline),
                  );
                }).toList(),
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
  final IconData icon;

  AppInfo({required this.name, required this.icon});
}

class AddAppDialog extends StatelessWidget {
  final List<AppInfo> notSecuredApps;
  final ValueChanged<AppInfo> onAdd;

  AddAppDialog({required this.notSecuredApps, required this.onAdd});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Add Application'),
      content: SingleChildScrollView(
        child: ListBody(
          children: notSecuredApps.map((app) {
            return ListTile(
              leading: Icon(app.icon),
              title: Text(app.name),
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
