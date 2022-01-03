import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

class Social extends StatefulWidget {
  Social({
    Key? key,
    required this.title,
    required this.icon,
    required this.platform,
    required this.username,
    required this.prefix
  }) : super(key: key);
  final String title;
  final IconData icon;
  final String platform;
  final String username;
  final String prefix;
  @override
  _SocialState createState() => _SocialState();
}

class _SocialState extends State<Social> {
  void launchPlatform() {
    launch(widget.prefix + widget.username);
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.title)),
      body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            FaIcon(widget.icon, size: 88),
            ElevatedButton(
              onPressed: launchPlatform,
              child: Text(
                'Go to ${widget.username} on ${widget.platform}',
                textAlign: TextAlign.center,
              ))
          ],
      ));
  }
}
