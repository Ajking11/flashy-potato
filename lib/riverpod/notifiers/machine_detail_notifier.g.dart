// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'machine_detail_notifier.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$machineDetailNotifierHash() =>
    r'ec6ff74895c96613901a4adf2ca5078b06d5eb30';

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

abstract class _$MachineDetailNotifier
    extends BuildlessAutoDisposeNotifier<MachineDetailState> {
  late final String machineId;

  MachineDetailState build(
    String machineId,
  );
}

/// See also [MachineDetailNotifier].
@ProviderFor(MachineDetailNotifier)
const machineDetailNotifierProvider = MachineDetailNotifierFamily();

/// See also [MachineDetailNotifier].
class MachineDetailNotifierFamily extends Family<MachineDetailState> {
  /// See also [MachineDetailNotifier].
  const MachineDetailNotifierFamily();

  /// See also [MachineDetailNotifier].
  MachineDetailNotifierProvider call(
    String machineId,
  ) {
    return MachineDetailNotifierProvider(
      machineId,
    );
  }

  @override
  MachineDetailNotifierProvider getProviderOverride(
    covariant MachineDetailNotifierProvider provider,
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
  String? get name => r'machineDetailNotifierProvider';
}

/// See also [MachineDetailNotifier].
class MachineDetailNotifierProvider extends AutoDisposeNotifierProviderImpl<
    MachineDetailNotifier, MachineDetailState> {
  /// See also [MachineDetailNotifier].
  MachineDetailNotifierProvider(
    String machineId,
  ) : this._internal(
          () => MachineDetailNotifier()..machineId = machineId,
          from: machineDetailNotifierProvider,
          name: r'machineDetailNotifierProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$machineDetailNotifierHash,
          dependencies: MachineDetailNotifierFamily._dependencies,
          allTransitiveDependencies:
              MachineDetailNotifierFamily._allTransitiveDependencies,
          machineId: machineId,
        );

  MachineDetailNotifierProvider._internal(
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
  MachineDetailState runNotifierBuild(
    covariant MachineDetailNotifier notifier,
  ) {
    return notifier.build(
      machineId,
    );
  }

  @override
  Override overrideWith(MachineDetailNotifier Function() create) {
    return ProviderOverride(
      origin: this,
      override: MachineDetailNotifierProvider._internal(
        () => create()..machineId = machineId,
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
  AutoDisposeNotifierProviderElement<MachineDetailNotifier, MachineDetailState>
      createElement() {
    return _MachineDetailNotifierProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is MachineDetailNotifierProvider &&
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
mixin MachineDetailNotifierRef
    on AutoDisposeNotifierProviderRef<MachineDetailState> {
  /// The parameter `machineId` of this provider.
  String get machineId;
}

class _MachineDetailNotifierProviderElement
    extends AutoDisposeNotifierProviderElement<MachineDetailNotifier,
        MachineDetailState> with MachineDetailNotifierRef {
  _MachineDetailNotifierProviderElement(super.provider);

  @override
  String get machineId => (origin as MachineDetailNotifierProvider).machineId;
}
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
