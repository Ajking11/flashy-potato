// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'usb_transfer_notifier.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$softwareByIdHash() => r'ada8663e052e36fd76823a0a644ebfef16be37f4';

/// Copied from Dart SDK
class _SystemHash {
  _SystemHash._();

  static int combine(int hash, int value) {
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + value);
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + ((0x0007ffff & hash) << 10));
    return hash ^ (hash >> 6);
  }

  static int finish(int hash) {
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + ((0x03ffffff & hash) << 3));
    // ignore: parameter_assignments
    hash = hash ^ (hash >> 11);
    return 0x1fffffff & (hash + ((0x00003fff & hash) << 15));
  }
}

/// See also [softwareById].
@ProviderFor(softwareById)
const softwareByIdProvider = SoftwareByIdFamily();

/// See also [softwareById].
class SoftwareByIdFamily extends Family<Software> {
  /// See also [softwareById].
  const SoftwareByIdFamily();

  /// See also [softwareById].
  SoftwareByIdProvider call(
    String softwareId,
  ) {
    return SoftwareByIdProvider(
      softwareId,
    );
  }

  @override
  SoftwareByIdProvider getProviderOverride(
    covariant SoftwareByIdProvider provider,
  ) {
    return call(
      provider.softwareId,
    );
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'softwareByIdProvider';
}

/// See also [softwareById].
class SoftwareByIdProvider extends AutoDisposeProvider<Software> {
  /// See also [softwareById].
  SoftwareByIdProvider(
    String softwareId,
  ) : this._internal(
          (ref) => softwareById(
            ref as SoftwareByIdRef,
            softwareId,
          ),
          from: softwareByIdProvider,
          name: r'softwareByIdProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$softwareByIdHash,
          dependencies: SoftwareByIdFamily._dependencies,
          allTransitiveDependencies:
              SoftwareByIdFamily._allTransitiveDependencies,
          softwareId: softwareId,
        );

  SoftwareByIdProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.softwareId,
  }) : super.internal();

  final String softwareId;

  @override
  Override overrideWith(
    Software Function(SoftwareByIdRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: SoftwareByIdProvider._internal(
        (ref) => create(ref as SoftwareByIdRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        softwareId: softwareId,
      ),
    );
  }

  @override
  AutoDisposeProviderElement<Software> createElement() {
    return _SoftwareByIdProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is SoftwareByIdProvider && other.softwareId == softwareId;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, softwareId.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin SoftwareByIdRef on AutoDisposeProviderRef<Software> {
  /// The parameter `softwareId` of this provider.
  String get softwareId;
}

class _SoftwareByIdProviderElement extends AutoDisposeProviderElement<Software>
    with SoftwareByIdRef {
  _SoftwareByIdProviderElement(super.provider);

  @override
  String get softwareId => (origin as SoftwareByIdProvider).softwareId;
}

String _$usbTransferNotifierHash() =>
    r'44f94daa933845b841dfffc4986ae9314f92647a';

abstract class _$UsbTransferNotifier
    extends BuildlessAutoDisposeNotifier<UsbTransferState> {
  late final String softwareId;

  UsbTransferState build(
    String softwareId,
  );
}

/// See also [UsbTransferNotifier].
@ProviderFor(UsbTransferNotifier)
const usbTransferNotifierProvider = UsbTransferNotifierFamily();

/// See also [UsbTransferNotifier].
class UsbTransferNotifierFamily extends Family<UsbTransferState> {
  /// See also [UsbTransferNotifier].
  const UsbTransferNotifierFamily();

  /// See also [UsbTransferNotifier].
  UsbTransferNotifierProvider call(
    String softwareId,
  ) {
    return UsbTransferNotifierProvider(
      softwareId,
    );
  }

  @override
  UsbTransferNotifierProvider getProviderOverride(
    covariant UsbTransferNotifierProvider provider,
  ) {
    return call(
      provider.softwareId,
    );
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'usbTransferNotifierProvider';
}

/// See also [UsbTransferNotifier].
class UsbTransferNotifierProvider extends AutoDisposeNotifierProviderImpl<
    UsbTransferNotifier, UsbTransferState> {
  /// See also [UsbTransferNotifier].
  UsbTransferNotifierProvider(
    String softwareId,
  ) : this._internal(
          () => UsbTransferNotifier()..softwareId = softwareId,
          from: usbTransferNotifierProvider,
          name: r'usbTransferNotifierProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$usbTransferNotifierHash,
          dependencies: UsbTransferNotifierFamily._dependencies,
          allTransitiveDependencies:
              UsbTransferNotifierFamily._allTransitiveDependencies,
          softwareId: softwareId,
        );

  UsbTransferNotifierProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.softwareId,
  }) : super.internal();

  final String softwareId;

  @override
  UsbTransferState runNotifierBuild(
    covariant UsbTransferNotifier notifier,
  ) {
    return notifier.build(
      softwareId,
    );
  }

  @override
  Override overrideWith(UsbTransferNotifier Function() create) {
    return ProviderOverride(
      origin: this,
      override: UsbTransferNotifierProvider._internal(
        () => create()..softwareId = softwareId,
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        softwareId: softwareId,
      ),
    );
  }

  @override
  AutoDisposeNotifierProviderElement<UsbTransferNotifier, UsbTransferState>
      createElement() {
    return _UsbTransferNotifierProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is UsbTransferNotifierProvider &&
        other.softwareId == softwareId;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, softwareId.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin UsbTransferNotifierRef
    on AutoDisposeNotifierProviderRef<UsbTransferState> {
  /// The parameter `softwareId` of this provider.
  String get softwareId;
}

class _UsbTransferNotifierProviderElement
    extends AutoDisposeNotifierProviderElement<UsbTransferNotifier,
        UsbTransferState> with UsbTransferNotifierRef {
  _UsbTransferNotifierProviderElement(super.provider);

  @override
  String get softwareId => (origin as UsbTransferNotifierProvider).softwareId;
}
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
