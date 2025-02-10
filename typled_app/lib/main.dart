// ignore_for_file: avoid_print
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:path/path.dart' as path;
import 'package:nes_ui/nes_ui.dart';
import 'package:typled_editor/workspace/cubit/workspace_cubit.dart';
import 'package:typled_editor/workspace/view/workspace_view.dart';

void main(List<String> args) {
  WidgetsFlutterBinding.ensureInitialized();

  if (args.length != 2) {
    print('Usage: main.dart <basePath> <file>');
    return;
  }

  final basePath = args[0];
  final file = args[1];

  const knownExtensions = ['.typled', '.typled_grid'];
  if (!knownExtensions.contains(path.extension(file))) {
    print('Unknown file extension: ${path.extension(file)}');
    exit(1);
  }

  final entry = FileEntry(file: file, basePath: basePath);

  final theme = flutterNesTheme(
    brightness: Brightness.dark,
    nesSnackbarTheme: const NesSnackbarTheme(
      normal: Colors.white,
      success: Colors.green,
      warning: Colors.orange,
      error: Colors.red,
    ),
  );

  runApp(
    MaterialApp(
      theme: theme,
      home: WorkspaceView(
        initialFiles: [entry],
        initialCurrentFile: entry,
      ),
    ),
  );
}
