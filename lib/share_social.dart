import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:share_plus/share_plus.dart';

class ShareSocial extends StatefulWidget {
  ShareSocial({
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
  _ShareSocialState createState() => _ShareSocialState();
}

class _ShareSocialState extends State<ShareSocial> {
  void shareLink() {
    Share.share(widget.prefix + (widget.username).trim());
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: ElevatedButton(
        onPressed: shareLink,
        child: RichText(
          text: TextSpan(
            children: [
              WidgetSpan(
                child: FaIcon(widget.icon),
              ),
              TextSpan(
                text: " ${widget.username}",
                style: TextStyle(color: Colors.white70)
              ),
            ],
          ),
        ),
      ),
      padding: EdgeInsets.only(left: 8.0, top: 0.0, right: 8.0, bottom: 1.0),
      width: double.infinity,
    );
  }
}
