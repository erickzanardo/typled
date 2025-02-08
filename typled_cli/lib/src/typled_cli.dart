import 'package:args/command_runner.dart';

import 'commands/commands.dart';

CommandRunner buildCommandRunner() {
  return CommandRunner(
    'typled',
    'CLI tool for the Typled application.',
  )
    ..addCommand(OpenCommand())
    ..addCommand(UpgradeCommand())
    ..addCommand(StatusCommand());
}
