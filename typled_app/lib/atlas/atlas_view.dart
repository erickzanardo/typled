import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:typled_editor/atlas/atlas_game.dart';
import 'package:typled_editor/atlas/commands.dart';
import 'package:typled_editor/atlas/cubit/atlas_cubit.dart';
import 'package:typled_editor/prompt/command_prompt.dart';
import 'package:typled_editor/widgets/help_dialog.dart';

import '../workspace/cubit/workspace_cubit.dart';

class AtlasView extends StatefulWidget {
  const AtlasView({
    super.key,
    required this.basePath,
    required this.file,
  });

  final String basePath;
  final String file;

  @override
  State<AtlasView> createState() => _AtlasViewState();
}

class _AtlasViewState extends State<AtlasView> {
  late final AtlasGame _game = AtlasGame(
    basePath: widget.basePath,
    file: widget.file,
  );

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) {
        return AtlasCubit();
      },
      child: BlocBuilder<AtlasCubit, AtlasState>(builder: (context, state) {
        return Column(
          children: [
            Expanded(child: GameWidget(game: _game)),
            CommandPrompt(
              commands: AtlasCommand.commands,
              onSubmitCommand: (command, args) {
                command.execute(
                  (
                    context.read<AtlasCubit>(),
                    context.read<WorkspaceCubit>(),
                  ),
                  args,
                );
              },
              onShowHelp: (context) {
                HelpDialog.show(context, commands: AtlasCommand.commands);
              },
              basePath: widget.basePath,
            ),
          ],
        );
      }),
    );
  }
}
