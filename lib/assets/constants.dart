import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

/// Maps social media platforms to deep links to their apps.
const Map<String, String> PLATFORM_TO_PREFIX = {
  'Instagram': 'instagram://user?username=',
  'Snapchat': 'snapchat://add/',
  'Twitter': 'twitter://user?screen_name=',
  'Linkedin': 'linkedin://in/',
  'YouTube': 'vnd.youtube://www.youtube.com/channel/',
  'Spotify': '',
};

/// Maps social media platforms to icons.
const Map<String, IconData> PLATFORM_TO_ICON = {
  'Name': FontAwesomeIcons.signature,
  'Phone Number': FontAwesomeIcons.phone,
  'Instagram': FontAwesomeIcons.instagram,
  'Snapchat': FontAwesomeIcons.snapchatGhost,
  'Twitter': FontAwesomeIcons.twitter,
  'Linkedin': FontAwesomeIcons.linkedin,
  'YouTube': FontAwesomeIcons.youtube,
  'Spotify': FontAwesomeIcons.spotify,
};

/// Maps platforms to their `TextInputType`.
const Map<String, TextInputType> PLATFORM_TO_KEYBOARD = {
  'Name': TextInputType.name,
  'Phone Number': TextInputType.phone,
  'Instagram': TextInputType.text,
  'Snapchat': TextInputType.text,
  'Twitter': TextInputType.text,
  'Linkedin': TextInputType.text,
  'YouTube': TextInputType.text,
  'Spotify': TextInputType.text,
};