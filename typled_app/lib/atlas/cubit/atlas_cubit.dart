import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:typled/typled.dart';

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

  void findSelection({
    required (int, int) index,
    required TypledAtlas atlas,
  }) {
    // Check if any selection is inside the index

    for (final selection in state.selections) {
      final selectionData = atlas.sprites[selection];

      if (selectionData == null) {
        continue;
      }

      final selectionX = selectionData.$1;
      final selectionY = selectionData.$2;
      final selectionDX = selectionX + (selectionData.$3 ?? 1) - 1;
      final selectionDY = selectionY + (selectionData.$4 ?? 1) - 1;

      if (index.$1 >= selectionX && index.$1 <= selectionDX && index.$2 >= selectionY && index.$2 <= selectionDY) {
        setSelectedSelectionId(selection);
        return;
      }
    }
  }
}
