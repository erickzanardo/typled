import 'dart:io';
import 'package:archive/archive_io.dart';
import 'package:dart_stork_client/dart_stork_client.dart';
import 'package:path/path.dart' as path;
import 'package:typled_cli/src/logger.dart';

const macosBinDownloadName = 'osx.zip';
const macosBinName = 'typled.app';
const macosArtifactName = 'macos';

const linuxBinDownloadName = 'linux.zip';
const linuxBinName = 'typled';
const linuxArtifactName = 'linux';

const typledStorkAppId = 3;

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

String _getVersionStampPath() {
  final appFolder = _ensureAppFolder();
  return path.join(appFolder, '.version');
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

    try {
      final client = DartStorkClient();
      final appData = await client.getApp(typledStorkAppId);

      final version = appData.lastVersion!;
      final appBytes = await client.downloadArtifact(
        appId: typledStorkAppId,
        version: version,
        platform: Platform.isMacOS ? macosArtifactName : linuxArtifactName,
      );

      final appFile =
          File(path.join(Directory.systemTemp.path, macosBinDownloadName));
      appFile.writeAsBytesSync(appBytes);

      progress.complete('Typled downloaded');

      extractFileToDisk(appFile.path, _getAppFolder());

      appFile.deleteSync();

      // On linux we need to add permission to run the bin
      if (Platform.isLinux) {
        final appPath = _getAppPath();
        Process.runSync('chmod', ['+x', appPath]);
      }

      // Write version stamp
      File(_getVersionStampPath()).writeAsStringSync(version);
    } catch (e, s) {
      print(e);
      print(s);
      progress.fail('Failed to download Typled');
      exit(1);
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
