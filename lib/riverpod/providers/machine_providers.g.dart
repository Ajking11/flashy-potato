// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'machine_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$machinesHash() => r'729cd66fb962ca15626455712763b11b9fc9166a';

/// Provider for accessing all machines
///
/// Copied from [machines].
@ProviderFor(machines)
final machinesProvider = AutoDisposeProvider<List<Machine>>.internal(
  machines,
  name: r'machinesProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$machinesHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef MachinesRef = AutoDisposeProviderRef<List<Machine>>;
String _$displayableMachinesHash() =>
    r'cd13fe598df0096116cfb275bf796ee95ff30107';

/// Provider for accessing only displayable machines (displayInApp = true)
///
/// Copied from [displayableMachines].
@ProviderFor(displayableMachines)
final displayableMachinesProvider = AutoDisposeProvider<List<Machine>>.internal(
  displayableMachines,
  name: r'displayableMachinesProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$displayableMachinesHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef DisplayableMachinesRef = AutoDisposeProviderRef<List<Machine>>;
String _$isMachinesLoadingHash() => r'1c6aa141e73190c8ca5ceb1d5455cb0621d7d04c';

/// Provider for checking if machines are loading
///
/// Copied from [isMachinesLoading].
@ProviderFor(isMachinesLoading)
final isMachinesLoadingProvider = AutoDisposeProvider<bool>.internal(
  isMachinesLoading,
  name: r'isMachinesLoadingProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$isMachinesLoadingHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef IsMachinesLoadingRef = AutoDisposeProviderRef<bool>;
String _$machineErrorHash() => r'6f0bc8576686034b6ff9f3ed96df7b051cff35e0';

/// Provider for machine error state
///
/// Copied from [machineError].
@ProviderFor(machineError)
final machineErrorProvider = AutoDisposeProvider<String?>.internal(
  machineError,
  name: r'machineErrorProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$machineErrorHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef MachineErrorRef = AutoDisposeProviderRef<String?>;
String _$machineByIdHash() => r'161374b530285d13a5b54305c9c84138c0459086';

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

/// Provider to get a specific machine by ID
///
/// Copied from [machineById].
@ProviderFor(machineById)
const machineByIdProvider = MachineByIdFamily();

/// Provider to get a specific machine by ID
///
/// Copied from [machineById].
class MachineByIdFamily extends Family<Machine?> {
  /// Provider to get a specific machine by ID
  ///
  /// Copied from [machineById].
  const MachineByIdFamily();

  /// Provider to get a specific machine by ID
  ///
  /// Copied from [machineById].
  MachineByIdProvider call(
    String machineId,
  ) {
    return MachineByIdProvider(
      machineId,
    );
  }

  @override
  MachineByIdProvider getProviderOverride(
    covariant MachineByIdProvider provider,
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
  String? get name => r'machineByIdProvider';
}

/// Provider to get a specific machine by ID
///
/// Copied from [machineById].
class MachineByIdProvider extends AutoDisposeProvider<Machine?> {
  /// Provider to get a specific machine by ID
  ///
  /// Copied from [machineById].
  MachineByIdProvider(
    String machineId,
  ) : this._internal(
          (ref) => machineById(
            ref as MachineByIdRef,
            machineId,
          ),
          from: machineByIdProvider,
          name: r'machineByIdProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$machineByIdHash,
          dependencies: MachineByIdFamily._dependencies,
          allTransitiveDependencies:
              MachineByIdFamily._allTransitiveDependencies,
          machineId: machineId,
        );

  MachineByIdProvider._internal(
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
    Machine? Function(MachineByIdRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: MachineByIdProvider._internal(
        (ref) => create(ref as MachineByIdRef),
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
  AutoDisposeProviderElement<Machine?> createElement() {
    return _MachineByIdProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is MachineByIdProvider && other.machineId == machineId;
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
mixin MachineByIdRef on AutoDisposeProviderRef<Machine?> {
  /// The parameter `machineId` of this provider.
  String get machineId;
}

class _MachineByIdProviderElement extends AutoDisposeProviderElement<Machine?>
    with MachineByIdRef {
  _MachineByIdProviderElement(super.provider);

  @override
  String get machineId => (origin as MachineByIdProvider).machineId;
}

String _$machinesCachedHash() => r'928afc23ec10f67befbf6a75ef9bafb39e0cea66';

/// Provider for checking if machines are cached
///
/// Copied from [machinesCached].
@ProviderFor(machinesCached)
final machinesCachedProvider = AutoDisposeProvider<bool>.internal(
  machinesCached,
  name: r'machinesCachedProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$machinesCachedHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef MachinesCachedRef = AutoDisposeProviderRef<bool>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
