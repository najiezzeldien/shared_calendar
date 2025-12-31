// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'calendar_view_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(CalendarViewController)
const calendarViewControllerProvider = CalendarViewControllerProvider._();

final class CalendarViewControllerProvider
    extends $NotifierProvider<CalendarViewController, CalendarViewState> {
  const CalendarViewControllerProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'calendarViewControllerProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$calendarViewControllerHash();

  @$internal
  @override
  CalendarViewController create() => CalendarViewController();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(CalendarViewState value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<CalendarViewState>(value),
    );
  }
}

String _$calendarViewControllerHash() =>
    r'cf5c458a1837b071f5b4aa0e92d4b2d941585492';

abstract class _$CalendarViewController extends $Notifier<CalendarViewState> {
  CalendarViewState build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref = this.ref as $Ref<CalendarViewState, CalendarViewState>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<CalendarViewState, CalendarViewState>,
              CalendarViewState,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}
