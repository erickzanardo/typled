part of 'atlas_cubit.dart';

class AtlasState extends Equatable {
  const AtlasState({
    required this.sprites,
    required this.selectedSpriteId,
    required this.customSelection,
  });

  const AtlasState.initial()
      : this(
          sprites: const [],
          selectedSpriteId: '',
          customSelection: (-1, -1, null, null),
        );

  final List<String> sprites;
  final String selectedSpriteId;
  final (int, int, int?, int?) customSelection;

  AtlasState copyWith({
    List<String>? sprites,
    String? selectedSpriteId,
    (int, int, int?, int?)? customSelection,
  }) {
    return AtlasState(
      sprites: sprites ?? this.sprites,
      selectedSpriteId: selectedSpriteId ?? this.selectedSpriteId,
      customSelection: customSelection ?? this.customSelection,
    );
  }

  @override
  List<Object?> get props => [sprites, selectedSpriteId, customSelection];
}
