import 'dart:io';

extension StringExtension on String {
  String get homeReplaced {
    String? home;

    Map<String, String> envVars = Platform.environment;
    if (Platform.isMacOS) {
      home = envVars['HOME'];
    } else if (Platform.isLinux) {
      home = envVars['HOME'];
    } else if (Platform.isWindows) {
      home = envVars['UserProfile'];
    }

    if (home == null) {
      return this;
    } else {
      return replaceAll(home, '~');
    }
  }
}
