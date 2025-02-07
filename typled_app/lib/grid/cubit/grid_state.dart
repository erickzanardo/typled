part of 'grid_cubit.dart';

class GridState extends Equatable {
  const GridState({
    required this.gridEnabled,
  });

  final bool gridEnabled;

  @override
  List<Object?> get props => [gridEnabled];

  GridState copyWith({
    bool? gridEnabled,
  }) {
    return GridState(
      gridEnabled: gridEnabled ?? this.gridEnabled,
    );
  }
}
