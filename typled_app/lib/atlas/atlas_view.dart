import 'dart:async';
import 'dart:io';

import 'package:flame/components.dart';
import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:typled/typled.dart';
import 'package:typled_editor/atlas/commands.dart';
import 'package:typled_editor/atlas/cubit/atlas_cubit.dart';
import 'package:typled_editor/atlas_provider.dart';
import 'package:typled_editor/prompt/command_prompt.dart';
import 'package:typled_editor/widgets/help_dialog.dart';
import 'package:path/path.dart' as path;

import '../workspace/cubit/workspace_cubit.dart';

class AtlasGame extends FlameGame {
  AtlasGame({
    required this.basePath,
    required this.file,
  });

  final String basePath;
  final String file;

  late TypledAtlasProvider atlasProvider;
  late TypledAtlas loadedAtlas;

  late SpriteComponent atlasImage;

  @override
  FutureOr<void> onLoad() async {
    await super.onLoad();

    final atlasFile = File(path.join(basePath, file));
    atlasProvider = (await AtlasProvider.load(
      file: atlasFile,
      basePath: basePath,
    )) as TypledAtlasProvider;

    final rawAtlas = await atlasFile.readAsString();
    loadedAtlas = TypledAtlas.parse(rawAtlas);
  }
}

class AtlasView extends StatelessWidget {
  const AtlasView({
    super.key,
    required this.basePath,
    required this.file,
  });

  final String basePath;
  final String file;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Expanded(child: const SizedBox()),
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
          basePath: basePath,
        ),
      ],
    );
  }
}
