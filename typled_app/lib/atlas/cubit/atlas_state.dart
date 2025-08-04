part of 'atlas_cubit.dart';

class AtlasState extends Equatable {
  const AtlasState({
    required this.selections,
    required this.selectedSelectionId,
    required this.customSelection,
    required this.hitboxeMode,
  });

  const AtlasState.initial()
      : this(
          selections: const [],
          selectedSelectionId: '',
          customSelection: (-1, -1, null, null),
          hitboxeMode: false,
        );

  final List<String> selections;
  final String selectedSelectionId;
  final (int, int, int?, int?) customSelection;
  final bool hitboxeMode;

  AtlasState copyWith({
    List<String>? selections,
    String? selectedSelectionId,
    (int, int, int?, int?)? customSelection,
    bool? hitboxeMode,
  }) {
    return AtlasState(
      selections: selections ?? this.selections,
      selectedSelectionId: selectedSelectionId ?? this.selectedSelectionId,
      customSelection: customSelection ?? this.customSelection,
      hitboxeMode: hitboxeMode ?? this.hitboxeMode,
    );
  }

  @override
  List<Object?> get props => [
        selections,
        selectedSelectionId,
        customSelection,
        hitboxeMode,
      ];
}
