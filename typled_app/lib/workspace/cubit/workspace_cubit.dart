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
}
