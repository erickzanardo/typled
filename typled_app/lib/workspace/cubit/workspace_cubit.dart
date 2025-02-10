import 'dart:io';
import 'package:path/path.dart' as path;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';

part 'workspace_state.dart';

class WorkspaceCubit extends Cubit<WorkspaceState> {
  WorkspaceCubit({
    List<FileEntry> initialFiles = const [],
    FileEntry? initialCurrentFile,
  }) : super(
          WorkspaceState(
            files: initialFiles,
            currentFile: initialCurrentFile,
          ),
        );

  void openFile(FileEntry entry) {
    emit(state.copyWith(
      files:
          state.files.contains(entry) ? state.files : [...state.files, entry],
      currentFile: () => entry,
    ));
  }

  void handleTabCommand(List<String> args) {
    if (args.isNotEmpty) {
      // Next
      if (args[0] == 'n') {
        final nextFile = state.files.indexOf(state.currentFile!) + 1;
        if (nextFile >= state.files.length) return;

        final entry = state.files[nextFile];
        openFile(entry);
      } else if (args[0] == 'p') {
        final prevFile = state.files.indexOf(state.currentFile!) - 1;
        if (prevFile < 0) return;
        final entry = state.files[prevFile];
        openFile(entry);
      }
    }
  }

  void quit() {
    if (state.files.length <= 1) {
      exit(0);
    }

    final currentIndex = state.files.indexOf(state.currentFile!);
    final nextIndex = (currentIndex + 1) % state.files.length;

    emit(
      state.copyWith(
        currentFile: () => state.files[nextIndex],
        files: state.files
            .where((element) => element != state.currentFile)
            .toList(),
      ),
    );
  }
}
