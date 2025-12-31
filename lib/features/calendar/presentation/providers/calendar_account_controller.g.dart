// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'calendar_account_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(CalendarAccountController)
const calendarAccountControllerProvider = CalendarAccountControllerProvider._();

final class CalendarAccountControllerProvider
    extends $AsyncNotifierProvider<CalendarAccountController, void> {
  const CalendarAccountControllerProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'calendarAccountControllerProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$calendarAccountControllerHash();

  @$internal
  @override
  CalendarAccountController create() => CalendarAccountController();
}

String _$calendarAccountControllerHash() =>
    r'94e7e9a9d3b60020791f505857d60b49cadd7605';

abstract class _$CalendarAccountController extends $AsyncNotifier<void> {
  FutureOr<void> build();
  @$mustCallSuper
  @override
  void runBuild() {
    build();
    final ref = this.ref as $Ref<AsyncValue<void>, void>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<void>, void>,
              AsyncValue<void>,
              Object?,
              Object?
            >;
    element.handleValue(ref, null);
  }
}
