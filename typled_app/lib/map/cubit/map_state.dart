part of 'map_cubit.dart';

class MapState extends Equatable {
  const MapState({
    this.command = '',
    this.commandMode = false,
    this.commandHistory = const [],
    this.commandHistoryIndex = 0,
    this.showPalette = false,
  });

  final String command;
  final bool commandMode;
  final int commandHistoryIndex;
  final List<String> commandHistory;
  final bool showPalette;

  MapState copyWith({
    String? command,
    bool? commandMode,
    List<String>? commandHistory,
    int? commandHistoryIndex,
    bool? showPalette,
  }) {
    return MapState(
      commandMode: commandMode ?? this.commandMode,
      command: command ?? this.command,
      commandHistory: commandHistory ?? this.commandHistory,
      commandHistoryIndex: commandHistoryIndex ?? this.commandHistoryIndex,
      showPalette: showPalette ?? this.showPalette,
    );
  }

  MapState copyWithNewHistory(String command) {
    final newHistory = List<String>.from(commandHistory);
    newHistory.add(command);
    return copyWith(
      commandHistory: newHistory,
    );
  }

  @override
  List<Object?> get props => [
        command,
        commandMode,
        commandHistory,
        commandHistoryIndex,
        showPalette,
      ];
}
