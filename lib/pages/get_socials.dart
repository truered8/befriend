import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_multi_formatter/flutter_multi_formatter.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:befriend/assets/constants.dart' as Constants;

class GetSocials extends StatefulWidget {
  GetSocials({Key? key, required this.title, required this.updateIds})
      : super(key: key);
  final String title;
  final Function updateIds;
  @override
  _GetSocialsState createState() => _GetSocialsState();
}

class _GetSocialsState extends State<GetSocials> {
  /// `TextEditingController`s for each platform.
  Map<String, TextEditingController> _controllers = Map.fromEntries(Constants
      .PLATFORM_TO_ICON.keys
      .map((platform) => MapEntry(platform, TextEditingController())));

  /// The key for the form.
  final _formKey = GlobalKey<FormState>();

  /// The `SharedPreferences` for this app.
  late SharedPreferences prefs;

  /// Runs when the app starts.
  void startup() async {
    prefs = await SharedPreferences.getInstance();
    setState(() {
      _controllers.keys.forEach((platform) {
        String? id = prefs.getString(platform);
        if (id != null) _controllers[platform]!.text = id;
      });
    });
  }

  @override
  void initState() {
    super.initState();
    startup();
  }

  @override
  void dispose() {
    _controllers.values.map((controller) {
      controller.dispose();
    });
    super.dispose();
  }

  /// Returns a text field to enter the username for `platform`.
  Widget addTextField(String platform, String hint) {
    print('$platform: ${Constants.PLATFORM_TO_KEYBOARD[platform]}');
    return Container(
      margin: EdgeInsets.only(left: 16.0, right: 16.0, bottom: 16.0),
      child: TextFormField(
        controller: _controllers[platform],
        decoration: InputDecoration(
          border: OutlineInputBorder(),
          labelText: hint,
          prefixIcon: Padding(
            padding: EdgeInsets.only(left: 9.0, top: 9.0),
            child: FaIcon(Constants.PLATFORM_TO_ICON[platform])),
          prefixIconColor: Colors.black,
        ),
        inputFormatters: (platform.compareTo('Phone Number') == 0
            ? [PhoneInputFormatter()]
            : []),
        keyboardType: Constants.PLATFORM_TO_KEYBOARD[platform],
        textCapitalization: (platform.compareTo('Name') == 0
            ? TextCapitalization.words
            : TextCapitalization.none)
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(widget.title),
        ),
        body: Center(
            child: Form(
                key: _formKey,
                child: ListView(
                  children: [
                    Padding(
                      padding: EdgeInsets.all(16.0),
                      child: Text(
                          'Fill out whichever of the following you would like:',
                          style: Theme.of(context).textTheme.titleSmall),
                    ),
                    addTextField('Name', 'Your name'),
                    addTextField('Phone Number', 'Phone number (with country code)'),
                    addTextField('Instagram', 'Instagram username'),
                    addTextField('Snapchat', 'Snapchat username'),
                    addTextField('Twitter', 'Twitter username'),
                    addTextField('Linkedin', 'Linkedin username'),
                    addTextField('YouTube', 'YouTube link'),
                    addTextField('Spotify', 'Spotify username'),
                    Padding(
                      padding: EdgeInsets.only(left: 16.0, right: 16.0),
                      child: ElevatedButton(
                        onPressed: () {
                          _controllers.keys.forEach((platform) {
                            prefs.setString(
                                platform, _controllers[platform]!.text);
                          });
                          widget.updateIds();
                          Navigator.pop(context);
                        },
                        child: Text('Save'),
                      ),
                    )
                  ],
                ))));
  }
}
