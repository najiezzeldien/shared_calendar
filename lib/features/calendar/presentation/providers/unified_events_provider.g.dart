// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'unified_events_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(UnifiedEvents)
const unifiedEventsProvider = UnifiedEventsFamily._();

final class UnifiedEventsProvider
    extends $AsyncNotifierProvider<UnifiedEvents, List<UnifiedEvent>> {
  const UnifiedEventsProvider._({
    required UnifiedEventsFamily super.from,
    required ({DateTime startDate, DateTime endDate}) super.argument,
  }) : super(
         retry: null,
         name: r'unifiedEventsProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$unifiedEventsHash();

  @override
  String toString() {
    return r'unifiedEventsProvider'
        ''
        '$argument';
  }

  @$internal
  @override
  UnifiedEvents create() => UnifiedEvents();

  @override
  bool operator ==(Object other) {
    return other is UnifiedEventsProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$unifiedEventsHash() => r'df0aeea958dbda018e8161edcdb8407a99a5f9bd';

final class UnifiedEventsFamily extends $Family
    with
        $ClassFamilyOverride<
          UnifiedEvents,
          AsyncValue<List<UnifiedEvent>>,
          List<UnifiedEvent>,
          FutureOr<List<UnifiedEvent>>,
          ({DateTime startDate, DateTime endDate})
        > {
  const UnifiedEventsFamily._()
    : super(
        retry: null,
        name: r'unifiedEventsProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  UnifiedEventsProvider call({
    required DateTime startDate,
    required DateTime endDate,
  }) => UnifiedEventsProvider._(
    argument: (startDate: startDate, endDate: endDate),
    from: this,
  );

  @override
  String toString() => r'unifiedEventsProvider';
}

abstract class _$UnifiedEvents extends $AsyncNotifier<List<UnifiedEvent>> {
  late final _$args = ref.$arg as ({DateTime startDate, DateTime endDate});
  DateTime get startDate => _$args.startDate;
  DateTime get endDate => _$args.endDate;

  FutureOr<List<UnifiedEvent>> build({
    required DateTime startDate,
    required DateTime endDate,
  });
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build(startDate: _$args.startDate, endDate: _$args.endDate);
    final ref =
        this.ref as $Ref<AsyncValue<List<UnifiedEvent>>, List<UnifiedEvent>>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<List<UnifiedEvent>>, List<UnifiedEvent>>,
              AsyncValue<List<UnifiedEvent>>,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}
