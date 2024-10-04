// ignore_for_file: avoid_print
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:path/path.dart' as path;
import 'package:nes_ui/nes_ui.dart';
import 'package:typled_editor/typled_grid_view.dart';
import 'package:typled_editor/typled_map_view.dart';

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
      body: TypledMapView(
        basePath: basePath,
        file: file,
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

  runApp(
    MaterialApp(
      theme: flutterNesTheme(brightness: Brightness.dark),
      home: child,
    ),
  );
}
