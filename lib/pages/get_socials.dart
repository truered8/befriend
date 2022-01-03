import 'package:flutter/material.dart';
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
  Map<String, TextEditingController> _textControllers = Map.fromEntries(
    Constants.PLATFORM_TO_ICON.keys
      .map((platform) => MapEntry(platform, TextEditingController())));
  final _formKey = GlobalKey<FormState>();
  late SharedPreferences prefs;
  Map<String, String> ids = Map.fromEntries(Constants.PLATFORM_TO_ICON.keys
    .map((platform) => MapEntry(platform, '')));

  void startup() async {
    prefs = await SharedPreferences.getInstance();
    setState(() {
      _textControllers.keys.forEach((platform) {
        String? id = prefs.getString(platform);
        if (id != null) _textControllers[platform]!.text = id;
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
    _textControllers.values.map((controller) {
      controller.dispose();
    });
    super.dispose();
  }

  /// Returns a text field to enter the username for `platform`.
  Widget addTextField(String platform, String hint) {
    return Container(
      margin: EdgeInsets.only(left: 16.0, right: 16.0, bottom: 16.0),
      child: TextFormField(
        controller: _textControllers[platform],
        decoration: InputDecoration(
          border: OutlineInputBorder(),
          labelText: hint,
          prefixIcon: Padding(
            padding: EdgeInsets.only(left: 9.0, top: 9.0),
            child: FaIcon(Constants.PLATFORM_TO_ICON[platform])),
          prefixIconColor: Colors.black,
        ),
        onChanged: (text) => {ids[platform] = text},
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
                      ids.keys.forEach((platform) {
                        ids[platform] = _textControllers[platform]!.text;
                      });
                      ids.entries.forEach((entry) {
                        prefs.setString(entry.key, entry.value);
                      });
                      widget.updateIds();
                      Navigator.pop(context);
                    },
                    child: Text('Done'),
                  ),
                )
              ],
            ))));
  }
}
