// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'groups_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(groupsRepository)
const groupsRepositoryProvider = GroupsRepositoryProvider._();

final class GroupsRepositoryProvider
    extends
        $FunctionalProvider<
          GroupsRepository,
          GroupsRepository,
          GroupsRepository
        >
    with $Provider<GroupsRepository> {
  const GroupsRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'groupsRepositoryProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$groupsRepositoryHash();

  @$internal
  @override
  $ProviderElement<GroupsRepository> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  GroupsRepository create(Ref ref) {
    return groupsRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(GroupsRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<GroupsRepository>(value),
    );
  }
}

String _$groupsRepositoryHash() => r'8dc6fc3556014324d3ed941fb6951a8d214e0f10';

@ProviderFor(getGroup)
const getGroupProvider = GetGroupFamily._();

final class GetGroupProvider
    extends $FunctionalProvider<AsyncValue<Group>, Group, FutureOr<Group>>
    with $FutureModifier<Group>, $FutureProvider<Group> {
  const GetGroupProvider._({
    required GetGroupFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'getGroupProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$getGroupHash();

  @override
  String toString() {
    return r'getGroupProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $FutureProviderElement<Group> $createElement($ProviderPointer pointer) =>
      $FutureProviderElement(pointer);

  @override
  FutureOr<Group> create(Ref ref) {
    final argument = this.argument as String;
    return getGroup(ref, argument);
  }

  @override
  bool operator ==(Object other) {
    return other is GetGroupProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$getGroupHash() => r'a5adbac02d58c43c81681d29788e2f93f7f96948';

final class GetGroupFamily extends $Family
    with $FunctionalFamilyOverride<FutureOr<Group>, String> {
  const GetGroupFamily._()
    : super(
        retry: null,
        name: r'getGroupProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  GetGroupProvider call(String groupId) =>
      GetGroupProvider._(argument: groupId, from: this);

  @override
  String toString() => r'getGroupProvider';
}
