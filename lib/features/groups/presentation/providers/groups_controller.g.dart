// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'groups_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(GroupsController)
const groupsControllerProvider = GroupsControllerProvider._();

final class GroupsControllerProvider
    extends $AsyncNotifierProvider<GroupsController, List<Group>> {
  const GroupsControllerProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'groupsControllerProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$groupsControllerHash();

  @$internal
  @override
  GroupsController create() => GroupsController();
}

String _$groupsControllerHash() => r'14d65afe20a2a0c494f7e5b802aaef6ad319289b';

abstract class _$GroupsController extends $AsyncNotifier<List<Group>> {
  FutureOr<List<Group>> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref = this.ref as $Ref<AsyncValue<List<Group>>, List<Group>>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<List<Group>>, List<Group>>,
              AsyncValue<List<Group>>,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}
