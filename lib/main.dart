import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:befriend/assets/constants.dart' as Constants;
import 'pages/get_socials.dart';
import 'pages/share_social.dart';

void main() {
  runApp(Befriend());
}

class Befriend extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Befriend',
      theme: ThemeData(
        primarySwatch: Colors.green,
      ),
      home: MyHomePage(title: 'Befriend'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key? key, this.title}) : super(key: key);
  final String? title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  /// The [SharedPreferences] for this app.
  late SharedPreferences prefs;

  /// This user's Instagram username.
  String? instagramId;

  /// This user's Snapchat username.
  String? snapchatId;

  /// This user's Twitter username.
  String? twitterId;

  /// Reads each handle from disk.
  void _updateIds() {
    instagramId = prefs.getString('Instagram')!;
    snapchatId = prefs.getString('Snapchat')!;
    twitterId = prefs.getString('Twitter')!;
  }

  /// Allows the user to input their social media links.
  void _getSocials() async {
    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) =>
              GetSocials(title: widget.title, updateIds: _updateIds)),
    );
  }

  /// Runs when the app starts.
  void startup() async {
    prefs = await SharedPreferences.getInstance();
    bool? opened = prefs.getBool('opened');
    if (opened != true) {
      prefs.setBool('opened', true);
      Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) =>
                GetSocials(title: widget.title, updateIds: _updateIds)),
      );
    } else {
      setState(_updateIds);
    }
  }

  @override
  void initState() {
    super.initState();
    startup();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title!),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text('Tap one of the following to share it:',
                style: Theme.of(context).textTheme.headline6),
            Padding(padding: EdgeInsets.all(15)),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ShareSocial(
                    title: widget.title,
                    icon: FontAwesomeIcons.instagram,
                    platform: 'Instagram',
                    username: instagramId,
                    prefix: Constants.INSTAGRAM_PREFIX),
                ShareSocial(
                    title: widget.title,
                    icon: FontAwesomeIcons.snapchatGhost,
                    platform: 'Snapchat',
                    username: snapchatId,
                    prefix: Constants.SNAPCHAT_PREFIX),
                ShareSocial(
                    title: widget.title,
                    icon: FontAwesomeIcons.twitter,
                    platform: 'Twitter',
                    username: twitterId,
                    prefix: Constants.TWITTER_PREFIX)
              ],
            )
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _getSocials,
        tooltip: 'Increment',
        child: Icon(Icons.edit),
      ),
    );
  }
}
