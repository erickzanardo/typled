import 'package:path/path.dart' as path;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nes_ui/nes_ui.dart';
import 'package:typled_editor/atlas/atlas.dart';
import 'package:typled_editor/grid/typled_grid_view.dart';
import 'package:typled_editor/map/typled_map_view.dart';
import '../cubit/workspace_cubit.dart';

class WorkspaceView extends StatelessWidget {
  const WorkspaceView({
    super.key,
    this.initialFiles = const [],
    this.initialCurrentFile,
  });

  final List<FileEntry> initialFiles;
  final FileEntry? initialCurrentFile;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => WorkspaceCubit(
        initialFiles: initialFiles,
        initialCurrentFile: initialCurrentFile,
      ),
      child: const WorkspaceViewContent(),
    );
  }
}

class WorkspaceViewContent extends StatelessWidget {
  const WorkspaceViewContent({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<WorkspaceCubit, WorkspaceState>(
      builder: (context, state) {
        return Scaffold(
          body: NesScaffold(
            body: state.files.isEmpty
                ? const Center(child: Text('No files'))
                : Column(
                    children: [
                      if (state.files.length > 1)
                        Row(
                          children: [
                            for (final entry in state.files)
                              ColoredBox(
                                color: entry == state.currentFile
                                    ? Colors.blue.shade900
                                    : Colors.blue,
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 8,
                                  ),
                                  child: Text(entry.basename),
                                ),
                              ),
                          ],
                        ),
                      Expanded(
                        child: Builder(
                          builder: (context) {
                            final entry = state.currentFile;
                            if (entry == null) {
                              return const Center(child: Text('No file'));
                            }

                            final file = entry.file;
                            final basePath = entry.basePath;
                            if (path.extension(file) == '.typled') {
                              return TypledMapView(
                                basePath: basePath,
                                file: file,
                              );
                            } else if (path.extension(file) == '.typled_grid') {
                              return TypledGridView(
                                basePath: basePath,
                                file: file,
                              );
                            } else if (path.extension(file) ==
                                '.typled_atlas') {
                              return AtlasView(
                                basePath: basePath,
                                file: file,
                              );
                            } else {
                              return Center(
                                child: Text(
                                  'Unknown file extension: ${path.extension(file)}',
                                ),
                              );
                            }
                          },
                        ),
                      ),
                    ],
                  ),
          ),
        );
      },
    );
  }
}
