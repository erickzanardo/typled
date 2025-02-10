part of 'workspace_cubit.dart';

class FileEntry extends Equatable {
  const FileEntry({
    required this.file,
    required this.basePath,
  });

  final String file;
  final String basePath;

  @override
  List<Object?> get props => [file, basePath];

  get basename => path.basename(file);
}

class WorkspaceState extends Equatable {
  const WorkspaceState({
    this.files = const [],
    this.currentFile,
  });

  final List<FileEntry> files;
  final FileEntry? currentFile;

  WorkspaceState copyWith({
    List<FileEntry>? files,
    FileEntry? Function()? currentFile,
  }) {
    return WorkspaceState(
      files: files ?? this.files,
      currentFile: currentFile != null ? currentFile() : this.currentFile,
    );
  }

  @override
  List<Object?> get props => [files, currentFile];
}
