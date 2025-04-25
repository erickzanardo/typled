import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nes_ui/nes_ui.dart';
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
    return Column(
      children: [
        Expanded(
            child: Row(
          children: [
            Expanded(
              child: GameWidget(
                autofocus: false,
                game: _game,
              ),
            ),
            SizedBox(
              width: 350,
              child: FutureBuilder(
                  future: _game.loaded,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState != ConnectionState.done) {
                      return const SizedBox();
                    }
                    return BlocBuilder<AtlasCubit, AtlasState>(
                      bloc: _game.cubit,
                      builder: (context, state) {
                        return NesSingleChildScrollView(
                          child: Column(
                            spacing: 16,
                            children: [
                              Text('Sprites',
                                  style:
                                      Theme.of(context).textTheme.titleLarge),
                              const Divider(),
                              for (final spriteId in state.sprites)
                                NesPressable(
                                  onPress: () {
                                    if (spriteId == state.selectedSpriteId) {
                                      _game.cubit.clearSelectedSpriteId();
                                    } else {
                                      _game.cubit.setSelectedSpriteId(spriteId);
                                    }
                                  },
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 8.0),
                                    child: Row(
                                      spacing: 16,
                                      children: [
                                        const SizedBox(),
                                        if (state.selectedSpriteId == spriteId)
                                          NesIcon(
                                            iconData:
                                                NesIcons.handPointingRight,
                                          ),
                                        Text(spriteId),
                                      ],
                                    ),
                                  ),
                                ),
                            ],
                          ),
                        );
                      },
                    );
                  }),
            ),
          ],
        )),
        CommandPrompt(
          commands: AtlasCommand.commands,
          onSubmitCommand: (command, args) {
            command.execute(
              (
                _game.cubit,
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
  }
}
