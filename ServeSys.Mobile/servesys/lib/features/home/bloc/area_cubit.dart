import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:servesys/core/error/app_exception.dart';
import 'package:servesys/features/home/bloc/area_state.dart';
import 'package:servesys/features/home/data/repositories/area_repository.dart';

class AreaCubit extends Cubit<AreaState> {
  final AreaRepository _areaRepository;

  AreaCubit({required areaRepository})
    : _areaRepository = areaRepository,
      super(AreaInitial());

  Future<void> loadAreas() async {
    emit(AreaLoading());
    try {
      final areas = await _areaRepository.getAreas();
      emit(AreaSuccess(areas: areas));
    } catch (e) {
      if (e is AppException) {
        emit(AreaError(e.toString()));
      } else {
        emit(AreaError('Lỗi không xác định'));
      }
    }
  }

  void selectArea(int index) {
    if (state is AreaSuccess) {
      emit((state as AreaSuccess).copyWith(selectedIndex: index));
    }
  }
}
