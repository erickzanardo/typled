import 'package:typled_cli/typled_cli.dart';

void main(List<String> arguments) {
  final commandRunner = buildCommandRunner();
  commandRunner.run(arguments);
}
