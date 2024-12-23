import 'dart:async';

import 'package:args/args.dart';
import 'package:args/command_runner.dart';
import 'package:typled_cli/src/app/app.dart';

class OpenCommand extends Command {
  @override
  String get description => 'Open a Typled file';

  @override
  String get name => 'open';

  @override
  ArgParser get argParser => ArgParser()
    ..addOption(
      'file',
      abbr: 'f',
      help: 'The file to open',
      mandatory: true,
      valueHelp: 'file',
    );

  @override
  FutureOr? run() async {
    await ensureAppIsDownloaded();

    final file = argResults!['file'] as String;
    openFile(file);
  }
}
