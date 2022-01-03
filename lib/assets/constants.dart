import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

const Map<String, String> PLATFORM_TO_PREFIX = {
  'Instagram': 'instagram://user?username=',
  'Snapchat': 'snapchat://add/',
  'Twitter': 'twitter://user?screen_name=',
  'Linkedin': 'linkedin://in/saptarshibhattacherya',
  'YouTube': 'vnd.youtube://',
  'Spotify': 'https://open.spotify.com/user/',
};

const Map<String, IconData> PLATFORM_TO_ICON = {
  'Instagram': FontAwesomeIcons.instagram,
  'Snapchat': FontAwesomeIcons.snapchatGhost,
  'Twitter': FontAwesomeIcons.twitter,
  'Linkedin': FontAwesomeIcons.linkedin,
  'YouTube': FontAwesomeIcons.youtube,
  'Spotify': FontAwesomeIcons.spotify,
};
