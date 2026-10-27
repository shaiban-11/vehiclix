import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:rootysysproject/bloc/inspectiontype/bloc/inspectiontype_event.dart';
import 'package:rootysysproject/bloc/inspectiontype/bloc/inspectiontype_state.dart';
import 'package:rootysysproject/repositories/Api/inspectiontype_api.dart';

class InspectionBloc extends Bloc<InspectionEvent, InspectionState> {
  final InspectionRepository repository;

  InspectionBloc({required this.repository}) : super(InspectionInitial()) {
    on<GetInspectionTypesEvent>(_onGetInspectionTypes);
  }

  Future<void> _onGetInspectionTypes(
    GetInspectionTypesEvent event,
    Emitter<InspectionState> emit,
  ) async {
    emit(InspectionLoading());

    try {
      final result = await repository.getInspectionTypes();
      emit(InspectionTypesLoaded(result));
    } catch (e) {
      emit(InspectionError(e.toString()));
    }
  }
}
