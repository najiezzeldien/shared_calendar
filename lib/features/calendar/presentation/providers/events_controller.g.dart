// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'events_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(EventsController)
const eventsControllerProvider = EventsControllerFamily._();

final class EventsControllerProvider
    extends $AsyncNotifierProvider<EventsController, List<Event>> {
  const EventsControllerProvider._({
    required EventsControllerFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'eventsControllerProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$eventsControllerHash();

  @override
  String toString() {
    return r'eventsControllerProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  EventsController create() => EventsController();

  @override
  bool operator ==(Object other) {
    return other is EventsControllerProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$eventsControllerHash() => r'9bc431f1c929df209f06be78917474227ae96dbb';

final class EventsControllerFamily extends $Family
    with
        $ClassFamilyOverride<
          EventsController,
          AsyncValue<List<Event>>,
          List<Event>,
          FutureOr<List<Event>>,
          String
        > {
  const EventsControllerFamily._()
    : super(
        retry: null,
        name: r'eventsControllerProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  EventsControllerProvider call(String groupId) =>
      EventsControllerProvider._(argument: groupId, from: this);

  @override
  String toString() => r'eventsControllerProvider';
}

abstract class _$EventsController extends $AsyncNotifier<List<Event>> {
  late final _$args = ref.$arg as String;
  String get groupId => _$args;

  FutureOr<List<Event>> build(String groupId);
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build(_$args);
    final ref = this.ref as $Ref<AsyncValue<List<Event>>, List<Event>>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<List<Event>>, List<Event>>,
              AsyncValue<List<Event>>,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}
