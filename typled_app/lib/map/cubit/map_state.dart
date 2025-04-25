part of 'map_cubit.dart';

class MapState extends Equatable {
  const MapState({this.showPalette = false});

  final bool showPalette;

  MapState copyWith({bool? showPalette}) {
    return MapState(showPalette: showPalette ?? this.showPalette);
  }

  @override
  List<Object?> get props => [showPalette];
}
