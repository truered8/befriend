import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_contacts/flutter_contacts.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';

class ShareSocial extends StatefulWidget {
  ShareSocial(
      {Key? key,
      required this.title,
      required this.icon,
      required this.platform,
      required this.ids,
      required this.labels,
      this.prefix})
      : super(key: key);
  final String title;
  final IconData icon;
  final String platform;
  final String? prefix;
  final Map<String, String?> ids;
  final Map<String, String?> labels;
  @override
  _ShareSocialState createState() => _ShareSocialState();
}

class _ShareSocialState extends State<ShareSocial> {
  /// Gets the path to the contact file.
  Future<String> get _localFile async {
    final directory = await getTemporaryDirectory();
    return '${directory.path}/contact.vcf';
  }

  /// Writes the given vCard String to a file.
  Future<File> writeContact(String vCard) async {
    final path = await _localFile;
    final file = File(path);
    return file.writeAsString(vCard);
  }

  /// Shares the given information.
  void shareInfo() async {
    final Size size = MediaQuery.of(context).size;
    if (widget.platform.compareTo('Phone Number') == 0) {
      List<String> names = widget.ids['Name']!.split(' ');
      final contact = Contact()
        ..name.first = names[0]
        ..phones = [Phone(widget.ids[widget.platform]!)];
      if (names.length > 1) contact.name.last = names[1];
      await writeContact(contact.toVCard());
      final path = await _localFile;
      Share.shareFiles(
        [path], 
        text: widget.ids[widget.platform]!,
        sharePositionOrigin: Rect.fromLTWH(0, 0, size.width, size.height / 2),
      );
    } else {
      Share.share(
        widget.prefix! + (widget.ids[widget.platform]!).trim(),
        sharePositionOrigin: Rect.fromLTWH(0, 0, size.width, size.height / 2),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: ElevatedButton(
        onPressed: shareInfo,
        style: ButtonStyle(
          backgroundColor: MaterialStateProperty.all(Theme.of(context).buttonTheme.colorScheme!.inverseSurface),
          shadowColor: MaterialStateProperty.all(Colors.red),
          shape: MaterialStateProperty.all(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
          side: MaterialStateProperty.all(
            BorderSide(
              color: Theme.of(context).colorScheme.onSurface,
              width: 3,
            ),
          ),
        ),
        child: Padding(
            padding: EdgeInsets.all(16.0),
            child: RichText(
              text: TextSpan(
                children: [
                  WidgetSpan(
                    child: FaIcon(
                      widget.icon,
                      color: Theme.of(context).colorScheme.onSurface,
                    ),
                  ),
                  TextSpan(
                      text: " ${widget.labels[widget.platform]!}",
                      style: Theme.of(context).textTheme.titleMedium!.apply(
                            color: Theme.of(context).colorScheme.onSurface,
                          )),
                ],
              ),
              textAlign: TextAlign.start,
            )),
      ),
      padding:
          EdgeInsets.only(left: 16.0, top: 0.0, right: 16.0, bottom: 4.0),
      width: double.infinity,
    );
  }
}
