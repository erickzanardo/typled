import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'grid_state.dart';

class GridCubit extends Cubit<GridState> {
  GridCubit() : super(const GridState(gridEnabled: false));

  void toggleGrid() {
    emit(state.copyWith(gridEnabled: !state.gridEnabled));
  }
}
