import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:befriend/assets/constants.dart' as Constants;
import 'pages/get_socials.dart';
import 'components/share_social.dart';

void main() {
  runApp(Befriend());
}

class Befriend extends StatelessWidget {
  static final ValueNotifier<ThemeMode> themeNotifier =
      ValueNotifier(ThemeMode.light);

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<ThemeMode>(
        valueListenable: themeNotifier,
        builder:
            (BuildContext context, ThemeMode currentMode, Widget? child) {
          return MaterialApp(
            title: 'Befriend',
            theme: ThemeData.from(colorScheme: ColorScheme.light(
              onSecondary: Colors.white,
              secondary: Color.fromARGB(255, 0, 39, 234),
              surface: Color.fromARGB(255, 0, 39, 234),
              inverseSurface: Color.fromARGB(255, 255, 255, 255),
            )),
            darkTheme: ThemeData.from(colorScheme: ColorScheme.dark(
              onPrimary: Colors.white,
              onSecondary: Colors.white,
              secondary: Color.fromARGB(255, 30, 30, 30),
              background: Color.fromARGB(255, 0, 0, 0),
              onSurface: Colors.white,
              surface: Color.fromARGB(255, 30, 30, 30),
              inverseSurface: Color.fromARGB(255, 30, 30, 30),
            )),
            themeMode: currentMode,
            home: HomePage(title: 'Befriend'),
            debugShowCheckedModeBanner: false,
          );
        });
  }
}

class HomePage extends StatefulWidget {
  HomePage({Key? key, required this.title}) : super(key: key);
  final String title;

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  /// The`SharedPreferences` for this app.
  late SharedPreferences prefs;

  /// This user's social media ids.
  Map<String, String?> ids = Map<String, String?>();

  /// The labels for each `ShareSocial` button.
  Map<String, String?> labels = Map<String, String?>();

  /// Reads each handle from disk.
  void _updateIds() {
    Constants.PLATFORM_TO_ICON.keys.forEach((key) {
      if (key == 'YouTube') {
        labels[key] = prefs.getString('YouTubeChannel');
      } else if (key == 'Spotify') {
        labels[key] = prefs.getString('SpotifyProfile');
      } else {
        labels[key] = prefs.getString(key);
      }
      ids[key] = prefs.getString(key);
    });
  }

  /// Sets the theme accordingly.
  void _updateTheme() {
    Befriend.themeNotifier.value =
        prefs.getBool('lightMode')! ? ThemeMode.light : ThemeMode.dark;
  }

  /// Toggles the theme.
  void _toggleTheme() {
    prefs.setBool(
        'lightMode', Befriend.themeNotifier.value == ThemeMode.dark);
    setState(_updateTheme);
  }

  /// Allows the user to input their social media links.
  void _getSocials() async {
    await Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => GetSocials(
              title: widget.title,
              updateIds: _updateIds,
              themeButton: _themeButton())),
    );
    setState(_updateIds);
  }

  /// Button that toggles between light and dark theme.
  IconButton _themeButton() {
    return IconButton(
        icon: Icon(Befriend.themeNotifier.value == ThemeMode.light
            ? Icons.dark_mode
            : Icons.light_mode),
        onPressed: _toggleTheme);
  }

  /// Runs when the app starts.
  void startup() async {
    prefs = await SharedPreferences.getInstance();
    bool? opened = prefs.getBool('opened');
    if (opened != true) {
      prefs.setBool('opened', true);
      prefs.setBool('lightMode', true);
      _getSocials();
    } else {
      setState(_updateIds);
      setState(_updateTheme);
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

  /// Returns the platforms that have been entered by the user.
  List<String> _getNonEmptyPlatforms() {
    List<String> platforms =
        Constants.PLATFORM_TO_ICON.keys.where((platform) {
      if (platform.compareTo('Name') == 0) return false;
      if (ids[platform] != null && ids[platform]!.isNotEmpty) return true;
      return false;
    }).toList();
    return platforms;
  }

  /// Returns the buttons for each social media platform available.
  List<Widget> _getShareSocials() {
    return _getNonEmptyPlatforms()
        .map((platform) => Container(
            margin: EdgeInsets.fromLTRB(0, 5.0, 0, 5.0),
            child: ShareSocial(
                title: widget.title,
                icon: Constants.PLATFORM_TO_ICON[platform]!,
                platform: platform,
                prefix: Constants.PLATFORM_TO_PREFIX[platform],
                ids: ids,
                labels: labels)))
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        actions: [_themeButton()],
      ),
      body: Container(
          child: (_getNonEmptyPlatforms().length > 0
              ? ListView(
                  children: <Widget>[
                    Padding(padding: EdgeInsets.all(15)),
                    Text(
                      'Tap one of the following to share it:',
                      style: Theme.of(context).textTheme.headline6,
                      textAlign: TextAlign.center,
                    ),
                    Padding(padding: EdgeInsets.all(15)),
                    Column(children: _getShareSocials())
                  ],
                  shrinkWrap: true,
                )
              : Text('Tap the edit button to start sharing.',
                  style: Theme.of(context).textTheme.headline6))),
      floatingActionButton: FloatingActionButton(
        onPressed: _getSocials,
        tooltip: 'Edit Platforms',
        child: Icon(Icons.edit),
      ),
    );
  }
}
