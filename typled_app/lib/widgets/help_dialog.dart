import 'package:flutter/material.dart';
import 'package:nes_ui/nes_ui.dart';
import 'package:typled_editor/prompt/prompt_command.dart';

class HelpDialog extends StatelessWidget {
  const HelpDialog({
    required this.commands,
    super.key,
  });

  final List<Command> commands;

  static Future<void> show(
    BuildContext context, {
    required List<Command> commands,
  }) async {
    await NesDialog.show(
      context: context,
      builder: (context) => HelpDialog(
        commands: commands,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 480,
      height: 620,
      child: NesSingleChildScrollView(
        child: Column(
          spacing: 8,
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    'q',
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                  Text(
                    'Quit the editor',
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'USAGE: q',
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                ],
              ),
            ),
            for (final command in commands)
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(
                      command.command,
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
                    Text(
                      command.description,
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'USAGE: ${command.usage}',
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }
}
