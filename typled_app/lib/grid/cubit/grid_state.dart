part of 'grid_cubit.dart';

class GridState extends Equatable {
  const GridState({
    this.gridEnabled = false,
    this.grid,
  });

  final bool gridEnabled;
  final TypledGrid? grid;

  GridState copyWith({
    bool? gridEnabled,
    TypledGrid? grid,
  }) {
    return GridState(
      gridEnabled: gridEnabled ?? this.gridEnabled,
      grid: grid ?? this.grid,
    );
  }

  @override
  List<Object?> get props => [gridEnabled, grid];
}
