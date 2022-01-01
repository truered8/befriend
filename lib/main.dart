import 'package:befriend/pages/social.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uni_links/uni_links.dart';

import 'package:befriend/assets/constants.dart' as Constants;
import 'pages/get_socials.dart';
import 'pages/social.dart';

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
  void updateIds() {
    instagramId = prefs.getString('Instagram')!;
    snapchatId = prefs.getString('Snapchat')!;
    twitterId = prefs.getString('Twitter')!;
  }

  void _shareLink() async {
    getLink();
    setState(() {
      List<Widget> sequence = [
        Social(
            title: widget.title,
            icon: FontAwesomeIcons.instagram,
            platform: 'Instagram',
            username: instagramId,
            prefix: Constants.INSTAGRAM_PREFIX),
        Social(
            title: widget.title,
            icon: FontAwesomeIcons.snapchatGhost,
            platform: 'Snapchat',
            username: snapchatId,
            prefix: Constants.SNAPCHAT_PREFIX),
        Social(
            title: widget.title,
            icon: FontAwesomeIcons.twitter,
            platform: 'Twitter',
            username: twitterId,
            prefix: Constants.TWITTER_PREFIX)
      ];
      for (int i = 0; i < sequence.length; i++)
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => sequence[i]));
    });
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
                GetSocials(title: widget.title, updateIds: updateIds)),
      );
    } else {
      setState(updateIds);
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

  void getLink() async {
    final initialLink = await getInitialLink();
    print(initialLink);
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
                platformDisplay(FontAwesomeIcons.instagram, instagramId),
                platformDisplay(FontAwesomeIcons.snapchat, snapchatId),
                platformDisplay(FontAwesomeIcons.twitter, twitterId)
              ],
            )
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _shareLink,
        tooltip: 'Increment',
        child: Icon(Icons.add),
      ),
    );
  }

  Widget platformDisplay(IconData platform, String? id) {
    return RichText(
      text: TextSpan(
        children: [
          WidgetSpan(
            child: FaIcon(platform),
          ),
          TextSpan(
              text: " $id", style: Theme.of(context).textTheme.bodyMedium),
        ],
      ),
    );
  }
}
