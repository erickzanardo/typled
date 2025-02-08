import 'dart:async';
import 'dart:io';

import 'package:args/args.dart';
import 'package:args/command_runner.dart';
import 'package:dart_stork_client/dart_stork_client.dart';
import 'package:typled_cli/src/app/app.dart';

class StatusCommand extends Command {
  @override
  String get description => 'Print the status of the Typled Editor';

  @override
  String get name => 'status';

  @override
  ArgParser get argParser => ArgParser();

  @override
  FutureOr? run() async {
    final version = currentVersion();
    final client = DartStorkClient();
    final appData = await client.getApp(typledStorkAppId);

    final lastVersion = appData.lastVersion!;
    print('Downloaded editor version: $version');
    print('Latest editor version: $lastVersion');
    exit(0);
  }
}
