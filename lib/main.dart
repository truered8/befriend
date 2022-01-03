import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:befriend/assets/constants.dart' as Constants;
import 'pages/get_socials.dart';
import 'share_social.dart';

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
  MyHomePage({Key? key, required this.title}) : super(key: key);
  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  /// The [SharedPreferences] for this app.
  late SharedPreferences prefs;

  /// This user's social media ids.
  Map<String, String?> ids = Map<String, String?>();

  /// Reads each handle from disk.
  void _updateIds() {
    Constants.PLATFORM_TO_ICON.keys.forEach((key) {
      ids[key] = prefs.getString(key);
    });
  }

  /// Allows the user to input their social media links.
  void _getSocials() async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) =>
          GetSocials(title: widget.title, updateIds: _updateIds)),
    );
    setState(_updateIds);
  }

  /// Runs when the app starts.
  void startup() async {
    prefs = await SharedPreferences.getInstance();
    bool? opened = prefs.getBool('opened');
    if (opened != true) {
      prefs.setBool('opened', true);
      _getSocials();
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

  /// Returns the buttons for each social media platform available.
  List<ShareSocial> _getAvailablePlatforms() {
    List<String> nonEmptyPlatforms =
        Constants.PLATFORM_TO_ICON.keys.where((platform) {
      if (ids[platform] != null && ids[platform]!.isNotEmpty) return true;
      return false;
    }).toList();
    return nonEmptyPlatforms
      .map((platform) => ShareSocial(
        title: widget.title,
        icon: Constants.PLATFORM_TO_ICON[platform]!,
        platform: platform,
        username: ids[platform]!,
        prefix: Constants.PLATFORM_TO_PREFIX[platform]!,
      ))
      .toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Padding(
              padding: EdgeInsets.all(16.0),
              child: Text('Tap one of the following to share it:',
                  style: Theme.of(context).textTheme.headline6),
            ),
            Padding(padding: EdgeInsets.all(15)),
            Column(children: _getAvailablePlatforms())
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
