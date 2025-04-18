// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'machine_detail_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$isMachineDetailLoadingHash() =>
    r'fe6d4621f76067b733901c8f406233564e6b2dfb';

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

/// Provider for checking if machine details are loading
///
/// Copied from [isMachineDetailLoading].
@ProviderFor(isMachineDetailLoading)
const isMachineDetailLoadingProvider = IsMachineDetailLoadingFamily();

/// Provider for checking if machine details are loading
///
/// Copied from [isMachineDetailLoading].
class IsMachineDetailLoadingFamily extends Family<bool> {
  /// Provider for checking if machine details are loading
  ///
  /// Copied from [isMachineDetailLoading].
  const IsMachineDetailLoadingFamily();

  /// Provider for checking if machine details are loading
  ///
  /// Copied from [isMachineDetailLoading].
  IsMachineDetailLoadingProvider call(
    String machineId,
  ) {
    return IsMachineDetailLoadingProvider(
      machineId,
    );
  }

  @override
  IsMachineDetailLoadingProvider getProviderOverride(
    covariant IsMachineDetailLoadingProvider provider,
  ) {
    return call(
      provider.machineId,
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
  String? get name => r'isMachineDetailLoadingProvider';
}

/// Provider for checking if machine details are loading
///
/// Copied from [isMachineDetailLoading].
class IsMachineDetailLoadingProvider extends AutoDisposeProvider<bool> {
  /// Provider for checking if machine details are loading
  ///
  /// Copied from [isMachineDetailLoading].
  IsMachineDetailLoadingProvider(
    String machineId,
  ) : this._internal(
          (ref) => isMachineDetailLoading(
            ref as IsMachineDetailLoadingRef,
            machineId,
          ),
          from: isMachineDetailLoadingProvider,
          name: r'isMachineDetailLoadingProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$isMachineDetailLoadingHash,
          dependencies: IsMachineDetailLoadingFamily._dependencies,
          allTransitiveDependencies:
              IsMachineDetailLoadingFamily._allTransitiveDependencies,
          machineId: machineId,
        );

  IsMachineDetailLoadingProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.machineId,
  }) : super.internal();

  final String machineId;

  @override
  Override overrideWith(
    bool Function(IsMachineDetailLoadingRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: IsMachineDetailLoadingProvider._internal(
        (ref) => create(ref as IsMachineDetailLoadingRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        machineId: machineId,
      ),
    );
  }

  @override
  AutoDisposeProviderElement<bool> createElement() {
    return _IsMachineDetailLoadingProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is IsMachineDetailLoadingProvider &&
        other.machineId == machineId;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, machineId.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin IsMachineDetailLoadingRef on AutoDisposeProviderRef<bool> {
  /// The parameter `machineId` of this provider.
  String get machineId;
}

class _IsMachineDetailLoadingProviderElement
    extends AutoDisposeProviderElement<bool> with IsMachineDetailLoadingRef {
  _IsMachineDetailLoadingProviderElement(super.provider);

  @override
  String get machineId => (origin as IsMachineDetailLoadingProvider).machineId;
}

String _$machineDetailHash() => r'c4973b30ca33d2869591f7a5484099d5211da795';

/// Provider for accessing machine details
///
/// Copied from [machineDetail].
@ProviderFor(machineDetail)
const machineDetailProvider = MachineDetailFamily();

/// Provider for accessing machine details
///
/// Copied from [machineDetail].
class MachineDetailFamily extends Family<MachineDetail?> {
  /// Provider for accessing machine details
  ///
  /// Copied from [machineDetail].
  const MachineDetailFamily();

  /// Provider for accessing machine details
  ///
  /// Copied from [machineDetail].
  MachineDetailProvider call(
    String machineId,
  ) {
    return MachineDetailProvider(
      machineId,
    );
  }

  @override
  MachineDetailProvider getProviderOverride(
    covariant MachineDetailProvider provider,
  ) {
    return call(
      provider.machineId,
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
  String? get name => r'machineDetailProvider';
}

/// Provider for accessing machine details
///
/// Copied from [machineDetail].
class MachineDetailProvider extends AutoDisposeProvider<MachineDetail?> {
  /// Provider for accessing machine details
  ///
  /// Copied from [machineDetail].
  MachineDetailProvider(
    String machineId,
  ) : this._internal(
          (ref) => machineDetail(
            ref as MachineDetailRef,
            machineId,
          ),
          from: machineDetailProvider,
          name: r'machineDetailProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$machineDetailHash,
          dependencies: MachineDetailFamily._dependencies,
          allTransitiveDependencies:
              MachineDetailFamily._allTransitiveDependencies,
          machineId: machineId,
        );

  MachineDetailProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.machineId,
  }) : super.internal();

  final String machineId;

  @override
  Override overrideWith(
    MachineDetail? Function(MachineDetailRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: MachineDetailProvider._internal(
        (ref) => create(ref as MachineDetailRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        machineId: machineId,
      ),
    );
  }

  @override
  AutoDisposeProviderElement<MachineDetail?> createElement() {
    return _MachineDetailProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is MachineDetailProvider && other.machineId == machineId;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, machineId.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin MachineDetailRef on AutoDisposeProviderRef<MachineDetail?> {
  /// The parameter `machineId` of this provider.
  String get machineId;
}

class _MachineDetailProviderElement
    extends AutoDisposeProviderElement<MachineDetail?> with MachineDetailRef {
  _MachineDetailProviderElement(super.provider);

  @override
  String get machineId => (origin as MachineDetailProvider).machineId;
}

String _$machineDetailErrorHash() =>
    r'f6d32822ae1a112daa4718461a6df8c57e8cd6fd';

/// Provider for machine detail error state
///
/// Copied from [machineDetailError].
@ProviderFor(machineDetailError)
const machineDetailErrorProvider = MachineDetailErrorFamily();

/// Provider for machine detail error state
///
/// Copied from [machineDetailError].
class MachineDetailErrorFamily extends Family<String?> {
  /// Provider for machine detail error state
  ///
  /// Copied from [machineDetailError].
  const MachineDetailErrorFamily();

  /// Provider for machine detail error state
  ///
  /// Copied from [machineDetailError].
  MachineDetailErrorProvider call(
    String machineId,
  ) {
    return MachineDetailErrorProvider(
      machineId,
    );
  }

  @override
  MachineDetailErrorProvider getProviderOverride(
    covariant MachineDetailErrorProvider provider,
  ) {
    return call(
      provider.machineId,
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
  String? get name => r'machineDetailErrorProvider';
}

/// Provider for machine detail error state
///
/// Copied from [machineDetailError].
class MachineDetailErrorProvider extends AutoDisposeProvider<String?> {
  /// Provider for machine detail error state
  ///
  /// Copied from [machineDetailError].
  MachineDetailErrorProvider(
    String machineId,
  ) : this._internal(
          (ref) => machineDetailError(
            ref as MachineDetailErrorRef,
            machineId,
          ),
          from: machineDetailErrorProvider,
          name: r'machineDetailErrorProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$machineDetailErrorHash,
          dependencies: MachineDetailErrorFamily._dependencies,
          allTransitiveDependencies:
              MachineDetailErrorFamily._allTransitiveDependencies,
          machineId: machineId,
        );

  MachineDetailErrorProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.machineId,
  }) : super.internal();

  final String machineId;

  @override
  Override overrideWith(
    String? Function(MachineDetailErrorRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: MachineDetailErrorProvider._internal(
        (ref) => create(ref as MachineDetailErrorRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        machineId: machineId,
      ),
    );
  }

  @override
  AutoDisposeProviderElement<String?> createElement() {
    return _MachineDetailErrorProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is MachineDetailErrorProvider && other.machineId == machineId;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, machineId.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin MachineDetailErrorRef on AutoDisposeProviderRef<String?> {
  /// The parameter `machineId` of this provider.
  String get machineId;
}

class _MachineDetailErrorProviderElement
    extends AutoDisposeProviderElement<String?> with MachineDetailErrorRef {
  _MachineDetailErrorProviderElement(super.provider);

  @override
  String get machineId => (origin as MachineDetailErrorProvider).machineId;
}
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
