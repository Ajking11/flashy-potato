// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'usb_transfer_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$currentStepHash() => r'2897a787f2d9d0a019cded7b3fdcd9ed18d02382';

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

/// See also [currentStep].
@ProviderFor(currentStep)
const currentStepProvider = CurrentStepFamily();

/// See also [currentStep].
class CurrentStepFamily extends Family<int> {
  /// See also [currentStep].
  const CurrentStepFamily();

  /// See also [currentStep].
  CurrentStepProvider call(
    String softwareId,
  ) {
    return CurrentStepProvider(
      softwareId,
    );
  }

  @override
  CurrentStepProvider getProviderOverride(
    covariant CurrentStepProvider provider,
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
  String? get name => r'currentStepProvider';
}

/// See also [currentStep].
class CurrentStepProvider extends AutoDisposeProvider<int> {
  /// See also [currentStep].
  CurrentStepProvider(
    String softwareId,
  ) : this._internal(
          (ref) => currentStep(
            ref as CurrentStepRef,
            softwareId,
          ),
          from: currentStepProvider,
          name: r'currentStepProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$currentStepHash,
          dependencies: CurrentStepFamily._dependencies,
          allTransitiveDependencies:
              CurrentStepFamily._allTransitiveDependencies,
          softwareId: softwareId,
        );

  CurrentStepProvider._internal(
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
    int Function(CurrentStepRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: CurrentStepProvider._internal(
        (ref) => create(ref as CurrentStepRef),
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
  AutoDisposeProviderElement<int> createElement() {
    return _CurrentStepProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is CurrentStepProvider && other.softwareId == softwareId;
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
mixin CurrentStepRef on AutoDisposeProviderRef<int> {
  /// The parameter `softwareId` of this provider.
  String get softwareId;
}

class _CurrentStepProviderElement extends AutoDisposeProviderElement<int>
    with CurrentStepRef {
  _CurrentStepProviderElement(super.provider);

  @override
  String get softwareId => (origin as CurrentStepProvider).softwareId;
}

String _$isUsbDetectedHash() => r'ea0a0e3dc3b4dd44e5bdac9a642ff0e6691423ba';

/// See also [isUsbDetected].
@ProviderFor(isUsbDetected)
const isUsbDetectedProvider = IsUsbDetectedFamily();

/// See also [isUsbDetected].
class IsUsbDetectedFamily extends Family<bool> {
  /// See also [isUsbDetected].
  const IsUsbDetectedFamily();

  /// See also [isUsbDetected].
  IsUsbDetectedProvider call(
    String softwareId,
  ) {
    return IsUsbDetectedProvider(
      softwareId,
    );
  }

  @override
  IsUsbDetectedProvider getProviderOverride(
    covariant IsUsbDetectedProvider provider,
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
  String? get name => r'isUsbDetectedProvider';
}

/// See also [isUsbDetected].
class IsUsbDetectedProvider extends AutoDisposeProvider<bool> {
  /// See also [isUsbDetected].
  IsUsbDetectedProvider(
    String softwareId,
  ) : this._internal(
          (ref) => isUsbDetected(
            ref as IsUsbDetectedRef,
            softwareId,
          ),
          from: isUsbDetectedProvider,
          name: r'isUsbDetectedProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$isUsbDetectedHash,
          dependencies: IsUsbDetectedFamily._dependencies,
          allTransitiveDependencies:
              IsUsbDetectedFamily._allTransitiveDependencies,
          softwareId: softwareId,
        );

  IsUsbDetectedProvider._internal(
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
    bool Function(IsUsbDetectedRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: IsUsbDetectedProvider._internal(
        (ref) => create(ref as IsUsbDetectedRef),
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
  AutoDisposeProviderElement<bool> createElement() {
    return _IsUsbDetectedProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is IsUsbDetectedProvider && other.softwareId == softwareId;
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
mixin IsUsbDetectedRef on AutoDisposeProviderRef<bool> {
  /// The parameter `softwareId` of this provider.
  String get softwareId;
}

class _IsUsbDetectedProviderElement extends AutoDisposeProviderElement<bool>
    with IsUsbDetectedRef {
  _IsUsbDetectedProviderElement(super.provider);

  @override
  String get softwareId => (origin as IsUsbDetectedProvider).softwareId;
}

String _$isTransferStartedHash() => r'6cfc5b3fe514787250b22d2ea9a6a2c824d18593';

/// See also [isTransferStarted].
@ProviderFor(isTransferStarted)
const isTransferStartedProvider = IsTransferStartedFamily();

/// See also [isTransferStarted].
class IsTransferStartedFamily extends Family<bool> {
  /// See also [isTransferStarted].
  const IsTransferStartedFamily();

  /// See also [isTransferStarted].
  IsTransferStartedProvider call(
    String softwareId,
  ) {
    return IsTransferStartedProvider(
      softwareId,
    );
  }

  @override
  IsTransferStartedProvider getProviderOverride(
    covariant IsTransferStartedProvider provider,
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
  String? get name => r'isTransferStartedProvider';
}

/// See also [isTransferStarted].
class IsTransferStartedProvider extends AutoDisposeProvider<bool> {
  /// See also [isTransferStarted].
  IsTransferStartedProvider(
    String softwareId,
  ) : this._internal(
          (ref) => isTransferStarted(
            ref as IsTransferStartedRef,
            softwareId,
          ),
          from: isTransferStartedProvider,
          name: r'isTransferStartedProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$isTransferStartedHash,
          dependencies: IsTransferStartedFamily._dependencies,
          allTransitiveDependencies:
              IsTransferStartedFamily._allTransitiveDependencies,
          softwareId: softwareId,
        );

  IsTransferStartedProvider._internal(
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
    bool Function(IsTransferStartedRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: IsTransferStartedProvider._internal(
        (ref) => create(ref as IsTransferStartedRef),
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
  AutoDisposeProviderElement<bool> createElement() {
    return _IsTransferStartedProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is IsTransferStartedProvider && other.softwareId == softwareId;
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
mixin IsTransferStartedRef on AutoDisposeProviderRef<bool> {
  /// The parameter `softwareId` of this provider.
  String get softwareId;
}

class _IsTransferStartedProviderElement extends AutoDisposeProviderElement<bool>
    with IsTransferStartedRef {
  _IsTransferStartedProviderElement(super.provider);

  @override
  String get softwareId => (origin as IsTransferStartedProvider).softwareId;
}

String _$isTransferCompleteHash() =>
    r'af419f9ce7dd8662fffa71d00a7580c6a534e88d';

/// See also [isTransferComplete].
@ProviderFor(isTransferComplete)
const isTransferCompleteProvider = IsTransferCompleteFamily();

/// See also [isTransferComplete].
class IsTransferCompleteFamily extends Family<bool> {
  /// See also [isTransferComplete].
  const IsTransferCompleteFamily();

  /// See also [isTransferComplete].
  IsTransferCompleteProvider call(
    String softwareId,
  ) {
    return IsTransferCompleteProvider(
      softwareId,
    );
  }

  @override
  IsTransferCompleteProvider getProviderOverride(
    covariant IsTransferCompleteProvider provider,
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
  String? get name => r'isTransferCompleteProvider';
}

/// See also [isTransferComplete].
class IsTransferCompleteProvider extends AutoDisposeProvider<bool> {
  /// See also [isTransferComplete].
  IsTransferCompleteProvider(
    String softwareId,
  ) : this._internal(
          (ref) => isTransferComplete(
            ref as IsTransferCompleteRef,
            softwareId,
          ),
          from: isTransferCompleteProvider,
          name: r'isTransferCompleteProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$isTransferCompleteHash,
          dependencies: IsTransferCompleteFamily._dependencies,
          allTransitiveDependencies:
              IsTransferCompleteFamily._allTransitiveDependencies,
          softwareId: softwareId,
        );

  IsTransferCompleteProvider._internal(
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
    bool Function(IsTransferCompleteRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: IsTransferCompleteProvider._internal(
        (ref) => create(ref as IsTransferCompleteRef),
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
  AutoDisposeProviderElement<bool> createElement() {
    return _IsTransferCompleteProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is IsTransferCompleteProvider &&
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
mixin IsTransferCompleteRef on AutoDisposeProviderRef<bool> {
  /// The parameter `softwareId` of this provider.
  String get softwareId;
}

class _IsTransferCompleteProviderElement
    extends AutoDisposeProviderElement<bool> with IsTransferCompleteRef {
  _IsTransferCompleteProviderElement(super.provider);

  @override
  String get softwareId => (origin as IsTransferCompleteProvider).softwareId;
}

String _$transferProgressHash() => r'1e1ffec49fb40c458367ee312f23516f5dcb7a07';

/// See also [transferProgress].
@ProviderFor(transferProgress)
const transferProgressProvider = TransferProgressFamily();

/// See also [transferProgress].
class TransferProgressFamily extends Family<double> {
  /// See also [transferProgress].
  const TransferProgressFamily();

  /// See also [transferProgress].
  TransferProgressProvider call(
    String softwareId,
  ) {
    return TransferProgressProvider(
      softwareId,
    );
  }

  @override
  TransferProgressProvider getProviderOverride(
    covariant TransferProgressProvider provider,
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
  String? get name => r'transferProgressProvider';
}

/// See also [transferProgress].
class TransferProgressProvider extends AutoDisposeProvider<double> {
  /// See also [transferProgress].
  TransferProgressProvider(
    String softwareId,
  ) : this._internal(
          (ref) => transferProgress(
            ref as TransferProgressRef,
            softwareId,
          ),
          from: transferProgressProvider,
          name: r'transferProgressProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$transferProgressHash,
          dependencies: TransferProgressFamily._dependencies,
          allTransitiveDependencies:
              TransferProgressFamily._allTransitiveDependencies,
          softwareId: softwareId,
        );

  TransferProgressProvider._internal(
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
    double Function(TransferProgressRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: TransferProgressProvider._internal(
        (ref) => create(ref as TransferProgressRef),
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
  AutoDisposeProviderElement<double> createElement() {
    return _TransferProgressProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is TransferProgressProvider && other.softwareId == softwareId;
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
mixin TransferProgressRef on AutoDisposeProviderRef<double> {
  /// The parameter `softwareId` of this provider.
  String get softwareId;
}

class _TransferProgressProviderElement
    extends AutoDisposeProviderElement<double> with TransferProgressRef {
  _TransferProgressProviderElement(super.provider);

  @override
  String get softwareId => (origin as TransferProgressProvider).softwareId;
}

String _$transferStatusHash() => r'b893bc72dec05e1ecb8a8c679b848b208d9294b0';

/// See also [transferStatus].
@ProviderFor(transferStatus)
const transferStatusProvider = TransferStatusFamily();

/// See also [transferStatus].
class TransferStatusFamily extends Family<String> {
  /// See also [transferStatus].
  const TransferStatusFamily();

  /// See also [transferStatus].
  TransferStatusProvider call(
    String softwareId,
  ) {
    return TransferStatusProvider(
      softwareId,
    );
  }

  @override
  TransferStatusProvider getProviderOverride(
    covariant TransferStatusProvider provider,
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
  String? get name => r'transferStatusProvider';
}

/// See also [transferStatus].
class TransferStatusProvider extends AutoDisposeProvider<String> {
  /// See also [transferStatus].
  TransferStatusProvider(
    String softwareId,
  ) : this._internal(
          (ref) => transferStatus(
            ref as TransferStatusRef,
            softwareId,
          ),
          from: transferStatusProvider,
          name: r'transferStatusProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$transferStatusHash,
          dependencies: TransferStatusFamily._dependencies,
          allTransitiveDependencies:
              TransferStatusFamily._allTransitiveDependencies,
          softwareId: softwareId,
        );

  TransferStatusProvider._internal(
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
    String Function(TransferStatusRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: TransferStatusProvider._internal(
        (ref) => create(ref as TransferStatusRef),
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
  AutoDisposeProviderElement<String> createElement() {
    return _TransferStatusProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is TransferStatusProvider && other.softwareId == softwareId;
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
mixin TransferStatusRef on AutoDisposeProviderRef<String> {
  /// The parameter `softwareId` of this provider.
  String get softwareId;
}

class _TransferStatusProviderElement extends AutoDisposeProviderElement<String>
    with TransferStatusRef {
  _TransferStatusProviderElement(super.provider);

  @override
  String get softwareId => (origin as TransferStatusProvider).softwareId;
}

String _$transferErrorHash() => r'f9ff09bce5ccbb592499d52eabc278b4da501475';

/// See also [transferError].
@ProviderFor(transferError)
const transferErrorProvider = TransferErrorFamily();

/// See also [transferError].
class TransferErrorFamily extends Family<String?> {
  /// See also [transferError].
  const TransferErrorFamily();

  /// See also [transferError].
  TransferErrorProvider call(
    String softwareId,
  ) {
    return TransferErrorProvider(
      softwareId,
    );
  }

  @override
  TransferErrorProvider getProviderOverride(
    covariant TransferErrorProvider provider,
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
  String? get name => r'transferErrorProvider';
}

/// See also [transferError].
class TransferErrorProvider extends AutoDisposeProvider<String?> {
  /// See also [transferError].
  TransferErrorProvider(
    String softwareId,
  ) : this._internal(
          (ref) => transferError(
            ref as TransferErrorRef,
            softwareId,
          ),
          from: transferErrorProvider,
          name: r'transferErrorProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$transferErrorHash,
          dependencies: TransferErrorFamily._dependencies,
          allTransitiveDependencies:
              TransferErrorFamily._allTransitiveDependencies,
          softwareId: softwareId,
        );

  TransferErrorProvider._internal(
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
    String? Function(TransferErrorRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: TransferErrorProvider._internal(
        (ref) => create(ref as TransferErrorRef),
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
  AutoDisposeProviderElement<String?> createElement() {
    return _TransferErrorProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is TransferErrorProvider && other.softwareId == softwareId;
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
mixin TransferErrorRef on AutoDisposeProviderRef<String?> {
  /// The parameter `softwareId` of this provider.
  String get softwareId;
}

class _TransferErrorProviderElement extends AutoDisposeProviderElement<String?>
    with TransferErrorRef {
  _TransferErrorProviderElement(super.provider);

  @override
  String get softwareId => (origin as TransferErrorProvider).softwareId;
}

String _$needsDeleteConfirmationHash() =>
    r'7fe6b7e35ec820ea7ef2a6da03721568a7d9e0f3';

/// See also [needsDeleteConfirmation].
@ProviderFor(needsDeleteConfirmation)
const needsDeleteConfirmationProvider = NeedsDeleteConfirmationFamily();

/// See also [needsDeleteConfirmation].
class NeedsDeleteConfirmationFamily extends Family<bool> {
  /// See also [needsDeleteConfirmation].
  const NeedsDeleteConfirmationFamily();

  /// See also [needsDeleteConfirmation].
  NeedsDeleteConfirmationProvider call(
    String softwareId,
  ) {
    return NeedsDeleteConfirmationProvider(
      softwareId,
    );
  }

  @override
  NeedsDeleteConfirmationProvider getProviderOverride(
    covariant NeedsDeleteConfirmationProvider provider,
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
  String? get name => r'needsDeleteConfirmationProvider';
}

/// See also [needsDeleteConfirmation].
class NeedsDeleteConfirmationProvider extends AutoDisposeProvider<bool> {
  /// See also [needsDeleteConfirmation].
  NeedsDeleteConfirmationProvider(
    String softwareId,
  ) : this._internal(
          (ref) => needsDeleteConfirmation(
            ref as NeedsDeleteConfirmationRef,
            softwareId,
          ),
          from: needsDeleteConfirmationProvider,
          name: r'needsDeleteConfirmationProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$needsDeleteConfirmationHash,
          dependencies: NeedsDeleteConfirmationFamily._dependencies,
          allTransitiveDependencies:
              NeedsDeleteConfirmationFamily._allTransitiveDependencies,
          softwareId: softwareId,
        );

  NeedsDeleteConfirmationProvider._internal(
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
    bool Function(NeedsDeleteConfirmationRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: NeedsDeleteConfirmationProvider._internal(
        (ref) => create(ref as NeedsDeleteConfirmationRef),
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
  AutoDisposeProviderElement<bool> createElement() {
    return _NeedsDeleteConfirmationProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is NeedsDeleteConfirmationProvider &&
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
mixin NeedsDeleteConfirmationRef on AutoDisposeProviderRef<bool> {
  /// The parameter `softwareId` of this provider.
  String get softwareId;
}

class _NeedsDeleteConfirmationProviderElement
    extends AutoDisposeProviderElement<bool> with NeedsDeleteConfirmationRef {
  _NeedsDeleteConfirmationProviderElement(super.provider);

  @override
  String get softwareId =>
      (origin as NeedsDeleteConfirmationProvider).softwareId;
}

String _$filesToDeleteHash() => r'e3c9dae67b4479115678863eb5816cdf8cfeefbd';

/// See also [filesToDelete].
@ProviderFor(filesToDelete)
const filesToDeleteProvider = FilesToDeleteFamily();

/// See also [filesToDelete].
class FilesToDeleteFamily extends Family<List<String>> {
  /// See also [filesToDelete].
  const FilesToDeleteFamily();

  /// See also [filesToDelete].
  FilesToDeleteProvider call(
    String softwareId,
  ) {
    return FilesToDeleteProvider(
      softwareId,
    );
  }

  @override
  FilesToDeleteProvider getProviderOverride(
    covariant FilesToDeleteProvider provider,
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
  String? get name => r'filesToDeleteProvider';
}

/// See also [filesToDelete].
class FilesToDeleteProvider extends AutoDisposeProvider<List<String>> {
  /// See also [filesToDelete].
  FilesToDeleteProvider(
    String softwareId,
  ) : this._internal(
          (ref) => filesToDelete(
            ref as FilesToDeleteRef,
            softwareId,
          ),
          from: filesToDeleteProvider,
          name: r'filesToDeleteProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$filesToDeleteHash,
          dependencies: FilesToDeleteFamily._dependencies,
          allTransitiveDependencies:
              FilesToDeleteFamily._allTransitiveDependencies,
          softwareId: softwareId,
        );

  FilesToDeleteProvider._internal(
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
    List<String> Function(FilesToDeleteRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: FilesToDeleteProvider._internal(
        (ref) => create(ref as FilesToDeleteRef),
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
  AutoDisposeProviderElement<List<String>> createElement() {
    return _FilesToDeleteProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is FilesToDeleteProvider && other.softwareId == softwareId;
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
mixin FilesToDeleteRef on AutoDisposeProviderRef<List<String>> {
  /// The parameter `softwareId` of this provider.
  String get softwareId;
}

class _FilesToDeleteProviderElement
    extends AutoDisposeProviderElement<List<String>> with FilesToDeleteRef {
  _FilesToDeleteProviderElement(super.provider);

  @override
  String get softwareId => (origin as FilesToDeleteProvider).softwareId;
}

String _$hasTransferErrorHash() => r'363eb9c069d1d99bf06227b6c06099dc4d4ba240';

/// See also [hasTransferError].
@ProviderFor(hasTransferError)
const hasTransferErrorProvider = HasTransferErrorFamily();

/// See also [hasTransferError].
class HasTransferErrorFamily extends Family<bool> {
  /// See also [hasTransferError].
  const HasTransferErrorFamily();

  /// See also [hasTransferError].
  HasTransferErrorProvider call(
    String softwareId,
  ) {
    return HasTransferErrorProvider(
      softwareId,
    );
  }

  @override
  HasTransferErrorProvider getProviderOverride(
    covariant HasTransferErrorProvider provider,
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
  String? get name => r'hasTransferErrorProvider';
}

/// See also [hasTransferError].
class HasTransferErrorProvider extends AutoDisposeProvider<bool> {
  /// See also [hasTransferError].
  HasTransferErrorProvider(
    String softwareId,
  ) : this._internal(
          (ref) => hasTransferError(
            ref as HasTransferErrorRef,
            softwareId,
          ),
          from: hasTransferErrorProvider,
          name: r'hasTransferErrorProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$hasTransferErrorHash,
          dependencies: HasTransferErrorFamily._dependencies,
          allTransitiveDependencies:
              HasTransferErrorFamily._allTransitiveDependencies,
          softwareId: softwareId,
        );

  HasTransferErrorProvider._internal(
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
    bool Function(HasTransferErrorRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: HasTransferErrorProvider._internal(
        (ref) => create(ref as HasTransferErrorRef),
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
  AutoDisposeProviderElement<bool> createElement() {
    return _HasTransferErrorProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is HasTransferErrorProvider && other.softwareId == softwareId;
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
mixin HasTransferErrorRef on AutoDisposeProviderRef<bool> {
  /// The parameter `softwareId` of this provider.
  String get softwareId;
}

class _HasTransferErrorProviderElement extends AutoDisposeProviderElement<bool>
    with HasTransferErrorRef {
  _HasTransferErrorProviderElement(super.provider);

  @override
  String get softwareId => (origin as HasTransferErrorProvider).softwareId;
}

String _$isCancelledHash() => r'dadf15bb26b7ae8f9fc4574649bcdfb0937b89d6';

/// See also [isCancelled].
@ProviderFor(isCancelled)
const isCancelledProvider = IsCancelledFamily();

/// See also [isCancelled].
class IsCancelledFamily extends Family<bool> {
  /// See also [isCancelled].
  const IsCancelledFamily();

  /// See also [isCancelled].
  IsCancelledProvider call(
    String softwareId,
  ) {
    return IsCancelledProvider(
      softwareId,
    );
  }

  @override
  IsCancelledProvider getProviderOverride(
    covariant IsCancelledProvider provider,
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
  String? get name => r'isCancelledProvider';
}

/// See also [isCancelled].
class IsCancelledProvider extends AutoDisposeProvider<bool> {
  /// See also [isCancelled].
  IsCancelledProvider(
    String softwareId,
  ) : this._internal(
          (ref) => isCancelled(
            ref as IsCancelledRef,
            softwareId,
          ),
          from: isCancelledProvider,
          name: r'isCancelledProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$isCancelledHash,
          dependencies: IsCancelledFamily._dependencies,
          allTransitiveDependencies:
              IsCancelledFamily._allTransitiveDependencies,
          softwareId: softwareId,
        );

  IsCancelledProvider._internal(
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
    bool Function(IsCancelledRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: IsCancelledProvider._internal(
        (ref) => create(ref as IsCancelledRef),
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
  AutoDisposeProviderElement<bool> createElement() {
    return _IsCancelledProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is IsCancelledProvider && other.softwareId == softwareId;
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
mixin IsCancelledRef on AutoDisposeProviderRef<bool> {
  /// The parameter `softwareId` of this provider.
  String get softwareId;
}

class _IsCancelledProviderElement extends AutoDisposeProviderElement<bool>
    with IsCancelledRef {
  _IsCancelledProviderElement(super.provider);

  @override
  String get softwareId => (origin as IsCancelledProvider).softwareId;
}

String _$isCancellableHash() => r'9bef0819ce806750c1a90083f8e487706caba222';

/// See also [isCancellable].
@ProviderFor(isCancellable)
const isCancellableProvider = IsCancellableFamily();

/// See also [isCancellable].
class IsCancellableFamily extends Family<bool> {
  /// See also [isCancellable].
  const IsCancellableFamily();

  /// See also [isCancellable].
  IsCancellableProvider call(
    String softwareId,
  ) {
    return IsCancellableProvider(
      softwareId,
    );
  }

  @override
  IsCancellableProvider getProviderOverride(
    covariant IsCancellableProvider provider,
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
  String? get name => r'isCancellableProvider';
}

/// See also [isCancellable].
class IsCancellableProvider extends AutoDisposeProvider<bool> {
  /// See also [isCancellable].
  IsCancellableProvider(
    String softwareId,
  ) : this._internal(
          (ref) => isCancellable(
            ref as IsCancellableRef,
            softwareId,
          ),
          from: isCancellableProvider,
          name: r'isCancellableProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$isCancellableHash,
          dependencies: IsCancellableFamily._dependencies,
          allTransitiveDependencies:
              IsCancellableFamily._allTransitiveDependencies,
          softwareId: softwareId,
        );

  IsCancellableProvider._internal(
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
    bool Function(IsCancellableRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: IsCancellableProvider._internal(
        (ref) => create(ref as IsCancellableRef),
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
  AutoDisposeProviderElement<bool> createElement() {
    return _IsCancellableProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is IsCancellableProvider && other.softwareId == softwareId;
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
mixin IsCancellableRef on AutoDisposeProviderRef<bool> {
  /// The parameter `softwareId` of this provider.
  String get softwareId;
}

class _IsCancellableProviderElement extends AutoDisposeProviderElement<bool>
    with IsCancellableRef {
  _IsCancellableProviderElement(super.provider);

  @override
  String get softwareId => (origin as IsCancellableProvider).softwareId;
}

String _$estimatedTimeRemainingHash() =>
    r'2b3c51e1600607b20f2d7cd86710c2add0d49169';

/// See also [estimatedTimeRemaining].
@ProviderFor(estimatedTimeRemaining)
const estimatedTimeRemainingProvider = EstimatedTimeRemainingFamily();

/// See also [estimatedTimeRemaining].
class EstimatedTimeRemainingFamily extends Family<int?> {
  /// See also [estimatedTimeRemaining].
  const EstimatedTimeRemainingFamily();

  /// See also [estimatedTimeRemaining].
  EstimatedTimeRemainingProvider call(
    String softwareId,
  ) {
    return EstimatedTimeRemainingProvider(
      softwareId,
    );
  }

  @override
  EstimatedTimeRemainingProvider getProviderOverride(
    covariant EstimatedTimeRemainingProvider provider,
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
  String? get name => r'estimatedTimeRemainingProvider';
}

/// See also [estimatedTimeRemaining].
class EstimatedTimeRemainingProvider extends AutoDisposeProvider<int?> {
  /// See also [estimatedTimeRemaining].
  EstimatedTimeRemainingProvider(
    String softwareId,
  ) : this._internal(
          (ref) => estimatedTimeRemaining(
            ref as EstimatedTimeRemainingRef,
            softwareId,
          ),
          from: estimatedTimeRemainingProvider,
          name: r'estimatedTimeRemainingProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$estimatedTimeRemainingHash,
          dependencies: EstimatedTimeRemainingFamily._dependencies,
          allTransitiveDependencies:
              EstimatedTimeRemainingFamily._allTransitiveDependencies,
          softwareId: softwareId,
        );

  EstimatedTimeRemainingProvider._internal(
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
    int? Function(EstimatedTimeRemainingRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: EstimatedTimeRemainingProvider._internal(
        (ref) => create(ref as EstimatedTimeRemainingRef),
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
  AutoDisposeProviderElement<int?> createElement() {
    return _EstimatedTimeRemainingProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is EstimatedTimeRemainingProvider &&
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
mixin EstimatedTimeRemainingRef on AutoDisposeProviderRef<int?> {
  /// The parameter `softwareId` of this provider.
  String get softwareId;
}

class _EstimatedTimeRemainingProviderElement
    extends AutoDisposeProviderElement<int?> with EstimatedTimeRemainingRef {
  _EstimatedTimeRemainingProviderElement(super.provider);

  @override
  String get softwareId =>
      (origin as EstimatedTimeRemainingProvider).softwareId;
}

String _$timeRemainingFormattedHash() =>
    r'7e9ace5ffaaa76120eeb692e57e93380940aa70a';

/// See also [timeRemainingFormatted].
@ProviderFor(timeRemainingFormatted)
const timeRemainingFormattedProvider = TimeRemainingFormattedFamily();

/// See also [timeRemainingFormatted].
class TimeRemainingFormattedFamily extends Family<String?> {
  /// See also [timeRemainingFormatted].
  const TimeRemainingFormattedFamily();

  /// See also [timeRemainingFormatted].
  TimeRemainingFormattedProvider call(
    String softwareId,
  ) {
    return TimeRemainingFormattedProvider(
      softwareId,
    );
  }

  @override
  TimeRemainingFormattedProvider getProviderOverride(
    covariant TimeRemainingFormattedProvider provider,
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
  String? get name => r'timeRemainingFormattedProvider';
}

/// See also [timeRemainingFormatted].
class TimeRemainingFormattedProvider extends AutoDisposeProvider<String?> {
  /// See also [timeRemainingFormatted].
  TimeRemainingFormattedProvider(
    String softwareId,
  ) : this._internal(
          (ref) => timeRemainingFormatted(
            ref as TimeRemainingFormattedRef,
            softwareId,
          ),
          from: timeRemainingFormattedProvider,
          name: r'timeRemainingFormattedProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$timeRemainingFormattedHash,
          dependencies: TimeRemainingFormattedFamily._dependencies,
          allTransitiveDependencies:
              TimeRemainingFormattedFamily._allTransitiveDependencies,
          softwareId: softwareId,
        );

  TimeRemainingFormattedProvider._internal(
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
    String? Function(TimeRemainingFormattedRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: TimeRemainingFormattedProvider._internal(
        (ref) => create(ref as TimeRemainingFormattedRef),
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
  AutoDisposeProviderElement<String?> createElement() {
    return _TimeRemainingFormattedProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is TimeRemainingFormattedProvider &&
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
mixin TimeRemainingFormattedRef on AutoDisposeProviderRef<String?> {
  /// The parameter `softwareId` of this provider.
  String get softwareId;
}

class _TimeRemainingFormattedProviderElement
    extends AutoDisposeProviderElement<String?> with TimeRemainingFormattedRef {
  _TimeRemainingFormattedProviderElement(super.provider);

  @override
  String get softwareId =>
      (origin as TimeRemainingFormattedProvider).softwareId;
}

String _$transferStatusInfoHash() =>
    r'eb703551d1a4d753aad9c4387ce5b2816539c0ec';

/// See also [transferStatusInfo].
@ProviderFor(transferStatusInfo)
const transferStatusInfoProvider = TransferStatusInfoFamily();

/// See also [transferStatusInfo].
class TransferStatusInfoFamily extends Family<Map<String, dynamic>> {
  /// See also [transferStatusInfo].
  const TransferStatusInfoFamily();

  /// See also [transferStatusInfo].
  TransferStatusInfoProvider call(
    String softwareId,
  ) {
    return TransferStatusInfoProvider(
      softwareId,
    );
  }

  @override
  TransferStatusInfoProvider getProviderOverride(
    covariant TransferStatusInfoProvider provider,
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
  String? get name => r'transferStatusInfoProvider';
}

/// See also [transferStatusInfo].
class TransferStatusInfoProvider
    extends AutoDisposeProvider<Map<String, dynamic>> {
  /// See also [transferStatusInfo].
  TransferStatusInfoProvider(
    String softwareId,
  ) : this._internal(
          (ref) => transferStatusInfo(
            ref as TransferStatusInfoRef,
            softwareId,
          ),
          from: transferStatusInfoProvider,
          name: r'transferStatusInfoProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$transferStatusInfoHash,
          dependencies: TransferStatusInfoFamily._dependencies,
          allTransitiveDependencies:
              TransferStatusInfoFamily._allTransitiveDependencies,
          softwareId: softwareId,
        );

  TransferStatusInfoProvider._internal(
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
    Map<String, dynamic> Function(TransferStatusInfoRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: TransferStatusInfoProvider._internal(
        (ref) => create(ref as TransferStatusInfoRef),
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
  AutoDisposeProviderElement<Map<String, dynamic>> createElement() {
    return _TransferStatusInfoProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is TransferStatusInfoProvider &&
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
mixin TransferStatusInfoRef on AutoDisposeProviderRef<Map<String, dynamic>> {
  /// The parameter `softwareId` of this provider.
  String get softwareId;
}

class _TransferStatusInfoProviderElement
    extends AutoDisposeProviderElement<Map<String, dynamic>>
    with TransferStatusInfoRef {
  _TransferStatusInfoProviderElement(super.provider);

  @override
  String get softwareId => (origin as TransferStatusInfoProvider).softwareId;
}
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
