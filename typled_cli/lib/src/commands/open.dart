import 'package:args/args.dart';
import 'package:args/command_runner.dart';

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
      valueHelp: 'file',
    );
}
