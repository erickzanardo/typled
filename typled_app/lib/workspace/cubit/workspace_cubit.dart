import 'dart:io';
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

  void quit() {
    if (state.files.length <= 1) {
      exit(0);
    }

    final currentIndex = state.files.indexOf(state.currentFile!);
    final nextIndex = (currentIndex + 1) % state.files.length;

    emit(state.copyWith(
      currentFile: () => state.files[nextIndex],
    ));
  }
}
