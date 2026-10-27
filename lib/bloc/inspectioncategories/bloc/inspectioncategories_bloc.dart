import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:rootysysproject/bloc/inspectioncategories/bloc/inspectioncategories_event.dart';
import 'package:rootysysproject/bloc/inspectioncategories/bloc/inspectioncategories_state.dart';
import 'package:rootysysproject/repositories/Api/inspectictioncategories_api.dart';

class InspectionDetailsBloc
    extends Bloc<InspectionDetailsEvent, InspectionDetailsState> {
  final InspectionDetailsRepository repository;

  InspectionDetailsBloc({required this.repository})
    : super(InspectionDetailsInitial()) {
    on<GetInspectionDataFieldsEvent>(_onGetInspectionDataFields);
  }

  Future<void> _onGetInspectionDataFields(
    GetInspectionDataFieldsEvent event,
    Emitter<InspectionDetailsState> emit,
  ) async {
    emit(InspectionDetailsLoading());

    try {
      final result = await repository.getInspectionDataFields(
        vehicleId: event.vehicleId,
        typeItemId: event.typeItemId,
      );

      if (result.success == true) {
        emit(InspectionDetailsLoaded(result));
      } else {
        emit(InspectionDetailsError('Unable to load inspection details'));
      }
    } catch (e) {
      emit(InspectionDetailsError(e.toString()));
    }
  }
}
