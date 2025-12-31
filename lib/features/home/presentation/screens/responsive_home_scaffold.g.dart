// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'responsive_home_scaffold.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(DesktopSelectedGroup)
const desktopSelectedGroupProvider = DesktopSelectedGroupProvider._();

final class DesktopSelectedGroupProvider
    extends $NotifierProvider<DesktopSelectedGroup, String?> {
  const DesktopSelectedGroupProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'desktopSelectedGroupProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$desktopSelectedGroupHash();

  @$internal
  @override
  DesktopSelectedGroup create() => DesktopSelectedGroup();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(String? value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<String?>(value),
    );
  }
}

String _$desktopSelectedGroupHash() =>
    r'8e893e81af6a3bece425d981c31fef62d6e06d1f';

abstract class _$DesktopSelectedGroup extends $Notifier<String?> {
  String? build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref = this.ref as $Ref<String?, String?>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<String?, String?>,
              String?,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}
