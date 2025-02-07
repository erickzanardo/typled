import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'map_state.dart';

class MapCubit extends Cubit<MapState> {
  MapCubit() : super(const MapState());

  void setPalette(bool showPalette) {
    emit(state.copyWith(showPalette: showPalette));
  }

  void togglePalette() {
    emit(state.copyWith(showPalette: !state.showPalette));
  }
}
