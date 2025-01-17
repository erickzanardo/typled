import 'dart:io';
import 'package:archive/archive_io.dart';
import 'package:http/http.dart' as http;
import 'package:path/path.dart' as path;
import 'package:typled_cli/src/logger.dart';

const _baseGithubPath =
    'https://github.com/erickzanardo/typled/releases/download/';
const macosBinDownloadName = 'osx.zip';
const macosBinName = 'typled.app';

// TODO(erickzanardo): This should come from elsewhere.
// Keep as a constant for now.
const lastAppVersion = '0.0.1+1';

String _getUserHome() {
  final envVars = Platform.environment;
  if (Platform.isMacOS) {
    return envVars['HOME']!;
  } else if (Platform.isLinux) {
    return envVars['HOME']!;
  } else if (Platform.isWindows) {
    return envVars['UserProfile']!;
  }
  throw UnsupportedError('Unsupported platform');
}

String _getAppFolder() {
  final userHome = _getUserHome();
  return path.join(userHome, '.typled');
}

String _ensureAppFolder() {
  final appPath = _getAppFolder();
  final appDir = Directory(appPath);
  if (!appDir.existsSync()) {
    appDir.createSync();
  }
  return appPath;
}

String _getAppPath() {
  final appFolder = _ensureAppFolder();
  return path.join(appFolder, macosBinName);
}

bool _isAppDownloaded() {
  final appPath = _getAppPath();
  if (Platform.isMacOS) {
    final appDir = Directory(appPath);
    return appDir.existsSync();
  } else {
    final appFile = File(appPath);
    return appFile.existsSync();
  }
}

Future<void> ensureAppIsDownloaded() async {
  if (!_isAppDownloaded()) {
    final progress = logger.progress('Downloading Typled...');

    final downloadUrl = '$_baseGithubPath$lastAppVersion/$macosBinDownloadName';

    final response = await http.get(Uri.parse(downloadUrl));
    if (response.statusCode != 200) {
      progress.fail('Failed to download Typled');
      exit(1);
    } else {
      final appFile =
          File(path.join(Directory.systemTemp.path, macosBinDownloadName));
      appFile.writeAsBytesSync(response.bodyBytes);

      progress.complete('Typled downloaded');

      extractFileToDisk(appFile.path, _getAppFolder());

      appFile.deleteSync();
    }
  }
}

void openFile(String filePath) {
  final appPath = _getAppPath();

  if (!File(filePath).existsSync()) {
    logger.err('File not found: $filePath');
    exit(1);
  }

  late final ProcessResult process;

  if (Platform.isMacOS) {
    process = Process.runSync(
      'open',
      ['-n', appPath, '--args', Directory.current.path, filePath],
    );
  } else if (Platform.isLinux) {
    process = Process.runSync(
      appPath,
      [
        Directory.current.path,
        filePath,
      ],
    );
  }

  if (process.exitCode != 0) {
    logger.err('Failed to open file');
    exit(1);
  }
}
