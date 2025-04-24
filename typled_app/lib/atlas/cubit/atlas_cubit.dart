import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'atlas_state.dart';

class AtlasCubit extends Cubit<AtlasState> {
  AtlasCubit() : super(const AtlasState.initial());
}
