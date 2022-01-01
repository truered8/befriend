import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class GetSocials extends StatefulWidget {
  GetSocials({Key? key, this.title, this.updateIds}) : super(key: key);
  final String? title;
  final Function? updateIds;
  @override
  _GetSocialsState createState() => _GetSocialsState();
}

class _GetSocialsState extends State<GetSocials> {
  final _formKey = GlobalKey<FormState>();
  late SharedPreferences prefs;
  late Map<String, String> ids = {
    'Instagram': '',
    'Snapchat': '',
    'Twitter': ''
  };

  String? validate(value) {
    if (value == null || value.isEmpty) {
      return 'Enter some text 🤡';
    }
    return null;
  }

  /// Returns a text field to enter the username for `platform`.
  Widget addTextField(String platform, String hint) {
    return TextFormField(
      decoration: InputDecoration(
        border: OutlineInputBorder(),
        hintText: hint,
      ),
      validator: validate,
      onChanged: (text) => {ids[platform] = text},
    );
  }

  void startup() async {
    prefs = await SharedPreferences.getInstance();
  }

  @override
  void initState() {
    super.initState();
    startup();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(widget.title!),
        ),
        body: Center(
            child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    addTextField('Instagram', 'Enter your Instagram username'),
                    addTextField('Snapchat', 'Enter your Snapchat username'),
                    addTextField('Twitter', 'Enter your Twitter username'),
                    ElevatedButton(
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          ids.entries.forEach((entry) {
                            prefs.setString(entry.key, entry.value);
                          });
                          widget.updateIds!();
                          Navigator.pop(context);
                        }
                      },
                      child: const Text('Submit'),
                    ),
                  ],
                ))));
  }
}
