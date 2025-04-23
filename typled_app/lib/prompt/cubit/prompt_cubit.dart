import 'dart:math' as math;
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:typled_editor/prompt/prompt_command.dart';

part 'prompt_state.dart';

enum SubmitCommandResult { handled, help, quit, tab, notFound }

class PromptCubit<T> extends Cubit<PromptState> {
  PromptCubit({required this.commands, required this.onSubmitCommand})
    : super(const PromptState());

  final List<Command<T>> commands;
  final void Function(Command<T>, List<String>) onSubmitCommand;

  void searchHistoryUp() {
    if (state.commandHistoryIndex > 0) {
      emit(
        state.copyWith(
          commandHistoryIndex: state.commandHistoryIndex - 1,
          command: state.commandHistory[state.commandHistoryIndex - 1],
        ),
      );
    }
  }

  void commandBackspace() {
    if (state.command.isNotEmpty) {
      emit(
        state.copyWith(
          command: state.command.substring(
            0,
            math.max(0, state.command.length - 1),
          ),
        ),
      );
    }
  }

  void exitCommandMode() {
    emit(state.copyWith(commandMode: false, command: ''));
  }

  void typeCommand(String character) {
    emit(state.copyWith(command: state.command + character));
  }

  void enterCommandMode() {
    emit(state.copyWith(commandMode: true));
  }

  void searchHistoryDown() {
    if (state.commandHistoryIndex < state.commandHistory.length - 1) {
      emit(
        state.copyWith(
          commandHistoryIndex: state.commandHistoryIndex + 1,
          command: state.commandHistory[state.commandHistoryIndex + 1],
        ),
      );
    }
  }

  void setCommandMode(bool commandMode) {
    emit(state.copyWith(commandMode: commandMode));
  }

  void addToHistory(String command) {
    emit(state.copyWithNewHistory(command));
  }

  void resetCommand() {
    emit(
      state.copyWith(
        commandMode: false,
        commandHistoryIndex: state.commandHistory.length,
        command: '',
      ),
    );
  }

  List<String> get args => state.command.split(' ').sublist(1);

  SubmitCommandResult submitCommand() {
    final parts = state.command.split(' ');

    if (parts.isNotEmpty) {
      final command = parts.first;
      final args = parts.sublist(1);

      if (command == 'h') {
        return SubmitCommandResult.help;
      }

      if (command == 'q') {
        return SubmitCommandResult.quit;
      }

      if (command == 't') {
        return SubmitCommandResult.tab;
      }

      final foundCommands = commands.where(
        (element) => element.command == command,
      );

      if (foundCommands.isNotEmpty) {
        emit(state.copyWithNewHistory(state.command));
        final foundCommand = foundCommands.first;
        onSubmitCommand(foundCommand, args);
      } else {
        return SubmitCommandResult.notFound;
      }
      emit(
        state.copyWith(
          commandMode: false,
          commandHistoryIndex: state.commandHistory.length,
          command: '',
        ),
      );
      return SubmitCommandResult.handled;
    }
    return SubmitCommandResult.notFound;
  }

  void clearCommand() {
    emit(
      state.copyWith(
        commandMode: false,
        commandHistoryIndex: state.commandHistory.length,
        command: '',
      ),
    );
  }
}
