part of 'atlas_cubit.dart';

class AtlasState extends Equatable {
  const AtlasState({
    required this.sprites,
    required this.selectedSpriteId,
  });

  const AtlasState.initial()
      : this(
          sprites: const [],
          selectedSpriteId: '',
        );

  final List<String> sprites;
  final String selectedSpriteId;

  AtlasState copyWith({
    List<String>? sprites,
    String? selectedSpriteId,
  }) {
    return AtlasState(
      sprites: sprites ?? this.sprites,
      selectedSpriteId: selectedSpriteId ?? this.selectedSpriteId,
    );
  }

  @override
  List<Object?> get props => [sprites, selectedSpriteId];
}
