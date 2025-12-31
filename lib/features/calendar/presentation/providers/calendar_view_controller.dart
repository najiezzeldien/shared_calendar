import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'calendar_view_controller.g.dart';

enum CalendarViewType {
  day,
  week,
  month,
}

@riverpod
class CalendarViewController extends _$CalendarViewController {
  @override
  CalendarViewState build() {
    return CalendarViewState(
      viewType: CalendarViewType.month,
      focusedDate: DateTime.now(),
    );
  }

  void setViewType(CalendarViewType type) {
    state = state.copyWith(viewType: type);
  }

  void setFocusedDate(DateTime date) {
    state = state.copyWith(focusedDate: date);
  }
}

class CalendarViewState {
  final CalendarViewType viewType;
  final DateTime focusedDate;

  CalendarViewState({
    required this.viewType,
    required this.focusedDate,
  });

  CalendarViewState copyWith({
    CalendarViewType? viewType,
    DateTime? focusedDate,
  }) {
    return CalendarViewState(
      viewType: viewType ?? this.viewType,
      focusedDate: focusedDate ?? this.focusedDate,
    );
  }
}
