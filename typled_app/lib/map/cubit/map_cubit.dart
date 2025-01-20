import 'dart:math' as math;
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:typled_editor/map/commands.dart';
import 'package:typled_editor/map/typled_game.dart';

part 'map_state.dart';

enum SubmitCommandResult {
  handled,
  help,
  notFound,
}

class MapCubit extends Cubit<MapState> {
  MapCubit() : super(const MapState());

  SubmitCommandResult submitCommand(TypledGame game) {
    final parts = state.command.split(' ');

    if (parts.isNotEmpty) {
      final command = parts.first;
      final args = parts.sublist(1);

      if (command == 'help') {
        return SubmitCommandResult.help;
      }

      final foundCommands = Command.commands.where(
        (element) => element.command == command,
      );

      if (foundCommands.isNotEmpty) {
        emit(state.copyWithNewHistory(state.command));
        final foundCommand = foundCommands.first;
        foundCommand.execute(game, args);
      } else {
        return SubmitCommandResult.notFound;
      }
      emit(state.copyWith(
        commandMode: false,
        commandHistoryIndex: state.commandHistory.length,
        command: '',
      ));
      return SubmitCommandResult.handled;
    }
    return SubmitCommandResult.notFound;
  }

  void searchHistoryUp() {
    if (state.commandHistoryIndex > 0) {
      emit(state.copyWith(
        commandHistoryIndex: state.commandHistoryIndex - 1,
        command: state.commandHistory[state.commandHistoryIndex - 1],
      ));
    }
  }

  void commandBackspace() {
    if (state.command.isNotEmpty) {
      emit(
        state.copyWith(
            command: state.command.substring(
          0,
          math.max(0, state.command.length - 1),
        )),
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
      emit(state.copyWith(
        commandHistoryIndex: state.commandHistoryIndex + 1,
        command: state.commandHistory[state.commandHistoryIndex + 1],
      ));
    }
  }

  void setCommandMode(bool commandMode) {
    emit(state.copyWith(commandMode: commandMode));
  }

  void setPalette(bool showPalette) {
    emit(state.copyWith(showPalette: showPalette));
  }

  void toggleCommandMode() {
    emit(state.copyWith(commandMode: !state.commandMode));
  }

  void togglePalette() {
    emit(state.copyWith(showPalette: !state.showPalette));
  }
}
