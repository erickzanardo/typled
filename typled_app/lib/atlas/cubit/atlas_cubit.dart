import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'atlas_state.dart';

class AtlasCubit extends Cubit<AtlasState> {
  AtlasCubit() : super(const AtlasState.initial());

  void setSelections(List<String> selections) {
    emit(state.copyWith(selections: selections));
  }

  void setSelectedSelectionId(String selectedSelectionId) {
    emit(
      state.copyWith(
        selectedSelectionId: selectedSelectionId,
        customSelection: (
          -1,
          -1,
          null,
          null,
        ),
      ),
    );
  }

  void clearSelectedSelectionId() {
    emit(state.copyWith(selectedSelectionId: ''));
  }

  void setHitboxMode() {
    emit(state.copyWith(
      hitboxeMode: true,
    ));
  }

  void setSpritesMode() {
    emit(state.copyWith(hitboxeMode: false));
  }

  void setCustomSelection(
    int x,
    int y,
    int? width,
    int? height,
  ) {
    emit(state.copyWith(
        customSelection: (x, y, width, height), selectedSelectionId: ''));
  }

  void clearCustomSelection() {
    emit(state.copyWith(customSelection: (-1, -1, null, null)));
  }
}
