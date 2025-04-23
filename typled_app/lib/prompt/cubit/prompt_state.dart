part of 'prompt_cubit.dart';

class PromptState extends Equatable {
  const PromptState({
    this.command = '',
    this.commandMode = false,
    this.commandHistory = const [],
    this.commandHistoryIndex = 0,
  });

  final String command;
  final bool commandMode;
  final int commandHistoryIndex;
  final List<String> commandHistory;

  PromptState copyWith({
    String? command,
    bool? commandMode,
    List<String>? commandHistory,
    int? commandHistoryIndex,
  }) {
    return PromptState(
      commandMode: commandMode ?? this.commandMode,
      command: command ?? this.command,
      commandHistory: commandHistory ?? this.commandHistory,
      commandHistoryIndex: commandHistoryIndex ?? this.commandHistoryIndex,
    );
  }

  PromptState copyWithNewHistory(String command) {
    final newHistory = List<String>.from(commandHistory)..add(command);
    return copyWith(
      commandHistory: newHistory,
      commandHistoryIndex: newHistory.length,
    );
  }

  @override
  List<Object?> get props => [
    command,
    commandMode,
    commandHistory,
    commandHistoryIndex,
  ];
}
