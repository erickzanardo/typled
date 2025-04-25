import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'atlas_state.dart';

class AtlasCubit extends Cubit<AtlasState> {
  AtlasCubit() : super(const AtlasState.initial());

  void setSprites(List<String> sprites) {
    emit(state.copyWith(sprites: sprites));
  }

  void setSelectedSpriteId(String selectedSpriteId) {
    emit(state.copyWith(selectedSpriteId: selectedSpriteId));
  }

  void clearSelectedSpriteId() {
    emit(state.copyWith(selectedSpriteId: ''));
  }
}
