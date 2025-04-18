// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'software_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$softwareListHash() => r'5b0fa099ede3cae63a7ba74b83dc809e6ab5ffe2';

/// Provider for accessing all software
///
/// Copied from [softwareList].
@ProviderFor(softwareList)
final softwareListProvider = AutoDisposeProvider<List<Software>>.internal(
  softwareList,
  name: r'softwareListProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$softwareListHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef SoftwareListRef = AutoDisposeProviderRef<List<Software>>;
String _$filteredSoftwareListHash() =>
    r'8d6e6b66e600dbd360b06ceccf46ec000f97a967';

/// Provider for accessing filtered software
///
/// Copied from [filteredSoftwareList].
@ProviderFor(filteredSoftwareList)
final filteredSoftwareListProvider =
    AutoDisposeProvider<List<Software>>.internal(
  filteredSoftwareList,
  name: r'filteredSoftwareListProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$filteredSoftwareListHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef FilteredSoftwareListRef = AutoDisposeProviderRef<List<Software>>;
String _$isSoftwareLoadingHash() => r'2c8e817502bf9ce8022a7f92ea32f7ffe3eb91e4';

/// Provider for checking if software is loading
///
/// Copied from [isSoftwareLoading].
@ProviderFor(isSoftwareLoading)
final isSoftwareLoadingProvider = AutoDisposeProvider<bool>.internal(
  isSoftwareLoading,
  name: r'isSoftwareLoadingProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$isSoftwareLoadingHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef IsSoftwareLoadingRef = AutoDisposeProviderRef<bool>;
String _$softwareSearchQueryHash() =>
    r'8418022a888395900f42494821922a8643dd855a';

/// Provider for current search query
///
/// Copied from [softwareSearchQuery].
@ProviderFor(softwareSearchQuery)
final softwareSearchQueryProvider = AutoDisposeProvider<String>.internal(
  softwareSearchQuery,
  name: r'softwareSearchQueryProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$softwareSearchQueryHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef SoftwareSearchQueryRef = AutoDisposeProviderRef<String>;
String _$softwareSelectedMachineIdHash() =>
    r'f3a5ae7098844a42f03a6f714d1131c7b519e51e';

/// Provider for selected machine ID filter
///
/// Copied from [softwareSelectedMachineId].
@ProviderFor(softwareSelectedMachineId)
final softwareSelectedMachineIdProvider = AutoDisposeProvider<String?>.internal(
  softwareSelectedMachineId,
  name: r'softwareSelectedMachineIdProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$softwareSelectedMachineIdHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef SoftwareSelectedMachineIdRef = AutoDisposeProviderRef<String?>;
String _$softwareSelectedCategoryHash() =>
    r'65964ff078aee503e70da388f8acd88b061fcb3f';

/// Provider for selected category filter
///
/// Copied from [softwareSelectedCategory].
@ProviderFor(softwareSelectedCategory)
final softwareSelectedCategoryProvider = AutoDisposeProvider<String?>.internal(
  softwareSelectedCategory,
  name: r'softwareSelectedCategoryProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$softwareSelectedCategoryHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef SoftwareSelectedCategoryRef = AutoDisposeProviderRef<String?>;
String _$softwareDownloadProgressHash() =>
    r'05f0973dd66abd4adcf7cd78f67121173a5a86b0';

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

/// Provider for software download progress
///
/// Copied from [softwareDownloadProgress].
@ProviderFor(softwareDownloadProgress)
const softwareDownloadProgressProvider = SoftwareDownloadProgressFamily();

/// Provider for software download progress
///
/// Copied from [softwareDownloadProgress].
class SoftwareDownloadProgressFamily extends Family<double> {
  /// Provider for software download progress
  ///
  /// Copied from [softwareDownloadProgress].
  const SoftwareDownloadProgressFamily();

  /// Provider for software download progress
  ///
  /// Copied from [softwareDownloadProgress].
  SoftwareDownloadProgressProvider call(
    String softwareId,
  ) {
    return SoftwareDownloadProgressProvider(
      softwareId,
    );
  }

  @override
  SoftwareDownloadProgressProvider getProviderOverride(
    covariant SoftwareDownloadProgressProvider provider,
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
  String? get name => r'softwareDownloadProgressProvider';
}

/// Provider for software download progress
///
/// Copied from [softwareDownloadProgress].
class SoftwareDownloadProgressProvider extends AutoDisposeProvider<double> {
  /// Provider for software download progress
  ///
  /// Copied from [softwareDownloadProgress].
  SoftwareDownloadProgressProvider(
    String softwareId,
  ) : this._internal(
          (ref) => softwareDownloadProgress(
            ref as SoftwareDownloadProgressRef,
            softwareId,
          ),
          from: softwareDownloadProgressProvider,
          name: r'softwareDownloadProgressProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$softwareDownloadProgressHash,
          dependencies: SoftwareDownloadProgressFamily._dependencies,
          allTransitiveDependencies:
              SoftwareDownloadProgressFamily._allTransitiveDependencies,
          softwareId: softwareId,
        );

  SoftwareDownloadProgressProvider._internal(
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
    double Function(SoftwareDownloadProgressRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: SoftwareDownloadProgressProvider._internal(
        (ref) => create(ref as SoftwareDownloadProgressRef),
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
    return _SoftwareDownloadProgressProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is SoftwareDownloadProgressProvider &&
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
mixin SoftwareDownloadProgressRef on AutoDisposeProviderRef<double> {
  /// The parameter `softwareId` of this provider.
  String get softwareId;
}

class _SoftwareDownloadProgressProviderElement
    extends AutoDisposeProviderElement<double>
    with SoftwareDownloadProgressRef {
  _SoftwareDownloadProgressProviderElement(super.provider);

  @override
  String get softwareId =>
      (origin as SoftwareDownloadProgressProvider).softwareId;
}

String _$isSoftwareDownloadingHash() =>
    r'83554ede0fbc87d82f65c21dad400abe1645237b';

/// Provider to check if a software is currently downloading
///
/// Copied from [isSoftwareDownloading].
@ProviderFor(isSoftwareDownloading)
const isSoftwareDownloadingProvider = IsSoftwareDownloadingFamily();

/// Provider to check if a software is currently downloading
///
/// Copied from [isSoftwareDownloading].
class IsSoftwareDownloadingFamily extends Family<bool> {
  /// Provider to check if a software is currently downloading
  ///
  /// Copied from [isSoftwareDownloading].
  const IsSoftwareDownloadingFamily();

  /// Provider to check if a software is currently downloading
  ///
  /// Copied from [isSoftwareDownloading].
  IsSoftwareDownloadingProvider call(
    String softwareId,
  ) {
    return IsSoftwareDownloadingProvider(
      softwareId,
    );
  }

  @override
  IsSoftwareDownloadingProvider getProviderOverride(
    covariant IsSoftwareDownloadingProvider provider,
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
  String? get name => r'isSoftwareDownloadingProvider';
}

/// Provider to check if a software is currently downloading
///
/// Copied from [isSoftwareDownloading].
class IsSoftwareDownloadingProvider extends AutoDisposeProvider<bool> {
  /// Provider to check if a software is currently downloading
  ///
  /// Copied from [isSoftwareDownloading].
  IsSoftwareDownloadingProvider(
    String softwareId,
  ) : this._internal(
          (ref) => isSoftwareDownloading(
            ref as IsSoftwareDownloadingRef,
            softwareId,
          ),
          from: isSoftwareDownloadingProvider,
          name: r'isSoftwareDownloadingProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$isSoftwareDownloadingHash,
          dependencies: IsSoftwareDownloadingFamily._dependencies,
          allTransitiveDependencies:
              IsSoftwareDownloadingFamily._allTransitiveDependencies,
          softwareId: softwareId,
        );

  IsSoftwareDownloadingProvider._internal(
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
    bool Function(IsSoftwareDownloadingRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: IsSoftwareDownloadingProvider._internal(
        (ref) => create(ref as IsSoftwareDownloadingRef),
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
    return _IsSoftwareDownloadingProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is IsSoftwareDownloadingProvider &&
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
mixin IsSoftwareDownloadingRef on AutoDisposeProviderRef<bool> {
  /// The parameter `softwareId` of this provider.
  String get softwareId;
}

class _IsSoftwareDownloadingProviderElement
    extends AutoDisposeProviderElement<bool> with IsSoftwareDownloadingRef {
  _IsSoftwareDownloadingProviderElement(super.provider);

  @override
  String get softwareId => (origin as IsSoftwareDownloadingProvider).softwareId;
}

String _$softwareByIdHash() => r'a16110bd63bc117a9d72d9884d0e12b1a0c1f326';

/// Provider to get a specific software by ID
///
/// Copied from [softwareById].
@ProviderFor(softwareById)
const softwareByIdProvider = SoftwareByIdFamily();

/// Provider to get a specific software by ID
///
/// Copied from [softwareById].
class SoftwareByIdFamily extends Family<Software?> {
  /// Provider to get a specific software by ID
  ///
  /// Copied from [softwareById].
  const SoftwareByIdFamily();

  /// Provider to get a specific software by ID
  ///
  /// Copied from [softwareById].
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

/// Provider to get a specific software by ID
///
/// Copied from [softwareById].
class SoftwareByIdProvider extends AutoDisposeProvider<Software?> {
  /// Provider to get a specific software by ID
  ///
  /// Copied from [softwareById].
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
    Software? Function(SoftwareByIdRef provider) create,
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
  AutoDisposeProviderElement<Software?> createElement() {
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
mixin SoftwareByIdRef on AutoDisposeProviderRef<Software?> {
  /// The parameter `softwareId` of this provider.
  String get softwareId;
}

class _SoftwareByIdProviderElement extends AutoDisposeProviderElement<Software?>
    with SoftwareByIdRef {
  _SoftwareByIdProviderElement(super.provider);

  @override
  String get softwareId => (origin as SoftwareByIdProvider).softwareId;
}

String _$softwareErrorHash() => r'09034a745c6498c6450b3e10f883f62f7e4aedd8';

/// Provider for software error state
///
/// Copied from [softwareError].
@ProviderFor(softwareError)
final softwareErrorProvider = AutoDisposeProvider<String?>.internal(
  softwareError,
  name: r'softwareErrorProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$softwareErrorHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef SoftwareErrorRef = AutoDisposeProviderRef<String?>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
