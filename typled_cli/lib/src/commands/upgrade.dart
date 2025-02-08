import 'dart:async';
import 'dart:io';

import 'package:args/args.dart';
import 'package:args/command_runner.dart';
import 'package:typled_cli/src/app/app.dart';

class UpgradeCommand extends Command {
  @override
  String get description => 'Upgrade a the Typled Editor';

  @override
  String get name => 'upgrade';

  @override
  ArgParser get argParser => ArgParser();
  @override
  FutureOr? run() async {
    deleteEditorApp();
    await ensureAppIsDownloaded();
    exit(0);
  }
}
