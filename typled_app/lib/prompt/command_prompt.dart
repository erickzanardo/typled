import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nes_ui/nes_ui.dart';
import 'package:typled_editor/prompt/cubit/prompt_cubit.dart';
import 'package:typled_editor/prompt/prompt_command.dart';

class CommandPrompt<T> extends StatelessWidget {
  const CommandPrompt({
    super.key,
    required this.commands,
    required this.onSubmitCommand,
    required this.onShowHelp,
    required this.basePath,
  });

  final List<Command<T>> commands;
  final void Function(Command<T>, List<String>) onSubmitCommand;
  final Function(BuildContext context) onShowHelp;
  final String basePath;

  @override
  Widget build(BuildContext context) {
    return BlocProvider<PromptCubit<T>>(
      create: (context) => PromptCubit(
        commands: commands,
        onSubmitCommand: onSubmitCommand,
      ),
      child: Builder(
        builder: (context) {
          return Focus(
            autofocus: true,
            onKeyEvent: (node, event) {
              if (event is KeyDownEvent) {
                final state = context.read<PromptCubit<T>>().state;
                if (state.commandMode) {
                  if (event.logicalKey == LogicalKeyboardKey.enter) {
                    final result = context.read<PromptCubit<T>>().submitCommand();
                    if (result == SubmitCommandResult.notFound) {
                      NesScaffoldMessenger.of(context).showSnackBar(
                        alignment: Alignment.topRight,
                        const NesSnackbar(
                          type: NesSnackbarType.error,
                          text: 'Unknown command',
                        ),
                      );
                    } else if (result == SubmitCommandResult.help) {
                      onShowHelp(context);
                    }
                  } else if (event.logicalKey == LogicalKeyboardKey.arrowUp) {
                    context.read<PromptCubit<T>>().searchHistoryUp();
                  } else if (event.logicalKey == LogicalKeyboardKey.arrowDown) {
                    context.read<PromptCubit<T>>().searchHistoryDown();
                  } else if (event.logicalKey == LogicalKeyboardKey.backspace) {
                    context.read<PromptCubit<T>>().commandBackspace();
                  } else if (event.logicalKey == LogicalKeyboardKey.colon) {
                    // ignore
                  } else {
                    context.read<PromptCubit<T>>().typeCommand(event.character ?? '');
                  }
                } else if (event.logicalKey == LogicalKeyboardKey.colon &&
                    !state.commandMode) {
                  context.read<PromptCubit<T>>().enterCommandMode();
                }
              }
              return KeyEventResult.handled;
            },
            child: BlocBuilder<PromptCubit<T>, PromptState>(
              builder: (context, state) {
                return state.commandMode
                    ? ColoredBox(
                        color: Colors.blue[900]!,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: SizedBox(
                            width: double.infinity,
                            child: Text(
                              ':${state.command}',
                              style: const TextStyle(fontSize: 12),
                            ),
                          ),
                        ),
                      )
                    : Row(
                        children: [
                          Expanded(
                            child: ColoredBox(
                              color: Colors.blue,
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                  basePath,
                                  style: const TextStyle(fontSize: 12),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ),
                          ),
                        ],
                      );
              },
            ),
          );
        }
      ),
    );
  }
}
