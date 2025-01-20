// ignore_for_file: avoid_print
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:path/path.dart' as path;
import 'package:nes_ui/nes_ui.dart';
import 'package:typled_editor/grid/grid.dart';
import 'package:typled_editor/map/map.dart';

void main(List<String> args) {
  WidgetsFlutterBinding.ensureInitialized();

  if (args.length != 2) {
    print('Usage: main.dart <basePath> <file>');
    return;
  }

  final basePath = args[0];
  final file = args[1];

  late Widget child;

  if (path.extension(file) == '.typled') {
    child = Scaffold(
      body: NesScaffold(
        body: TypledMapView(
          basePath: basePath,
          file: file,
        ),
      ),
    );
  } else if (path.extension(file) == '.typled_grid') {
    child = TypledGridView(
      basePath: basePath,
      file: file,
    );
  } else {
    print('Unknown file extension: ${path.extension(file)}');
    exit(1);
  }

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
      home: child,
    ),
  );
}
