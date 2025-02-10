import 'dart:io';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:typled/typled.dart';
import 'package:path/path.dart' as path;

part 'grid_state.dart';

class GridCubit extends Cubit<GridState> {
  GridCubit() : super(const GridState());

  void toggleGrid() {
    emit(state.copyWith(gridEnabled: !state.gridEnabled));
  }

  Future<void> load(String basePath, String file) async {
    final grid = await _loadTypledGrid(basePath, file);
    emit(state.copyWith(grid: grid));
  }

  Future<TypledGrid> _loadTypledGrid(String basePath, String fileName) async {
    final file = File(path.join(basePath, fileName));
    final fileContent = await file.readAsString();
    return TypledGrid.parse(fileContent);
  }
}
