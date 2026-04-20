// area_state.dart
import 'package:servesys/features/home/domain/entities/area.dart';

abstract class AreaState {}

class AreaInitial extends AreaState {}

class AreaLoading extends AreaState {}

class AreaSuccess extends AreaState {
  final List<Area> areas;
  int selectedIndex;
  AreaSuccess({required this.areas, this.selectedIndex = -1});
  
  AreaSuccess copyWith({List<Area>? areas, int? selectedIndex}) {
    return AreaSuccess(
      areas: areas ?? this.areas,
      selectedIndex: selectedIndex ?? this.selectedIndex,
    );
  }
}

class AreaError extends AreaState {
  final String message;
  AreaError(this.message);
}