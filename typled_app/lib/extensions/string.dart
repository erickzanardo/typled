import 'dart:io' show Platform;

import 'package:universal_platform/universal_platform.dart';

extension StringExtension on String {
  String get homeReplaced {
    if (UniversalPlatform.isWeb) return this;

    String? home;

    Map<String, String> envVars = Platform.environment;
    if (UniversalPlatform.isMacOS) {
      home = envVars['HOME'];
    } else if (UniversalPlatform.isLinux) {
      home = envVars['HOME'];
    } else if (UniversalPlatform.isWindows) {
      home = envVars['UserProfile'];
    }

    if (home == null) {
      return this;
    } else {
      return replaceAll(home, '~');
    }
  }
}
