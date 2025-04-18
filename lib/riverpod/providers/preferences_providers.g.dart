// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'preferences_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$userPreferencesHash() => r'b2279899189cf6c27169d1b75ea84425ea05a920';

/// Provider for accessing UserPreferences
///
/// Copied from [userPreferences].
@ProviderFor(userPreferences)
final userPreferencesProvider = AutoDisposeProvider<UserPreferences>.internal(
  userPreferences,
  name: r'userPreferencesProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$userPreferencesHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef UserPreferencesRef = AutoDisposeProviderRef<UserPreferences>;
String _$isPreferencesLoadingHash() =>
    r'026dcf004f2ab0b51061f63ea51f2bc8b8886ba2';

/// Provider for checking if preferences are loading
///
/// Copied from [isPreferencesLoading].
@ProviderFor(isPreferencesLoading)
final isPreferencesLoadingProvider = AutoDisposeProvider<bool>.internal(
  isPreferencesLoading,
  name: r'isPreferencesLoadingProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$isPreferencesLoadingHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef IsPreferencesLoadingRef = AutoDisposeProviderRef<bool>;
String _$isMachineFavoriteHash() => r'f3f24bcc87c4b09268312f36fd9d1b377ab32c9b';

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

/// Provider for checking if a machine is favorited
///
/// Copied from [isMachineFavorite].
@ProviderFor(isMachineFavorite)
const isMachineFavoriteProvider = IsMachineFavoriteFamily();

/// Provider for checking if a machine is favorited
///
/// Copied from [isMachineFavorite].
class IsMachineFavoriteFamily extends Family<bool> {
  /// Provider for checking if a machine is favorited
  ///
  /// Copied from [isMachineFavorite].
  const IsMachineFavoriteFamily();

  /// Provider for checking if a machine is favorited
  ///
  /// Copied from [isMachineFavorite].
  IsMachineFavoriteProvider call(
    String machineId,
  ) {
    return IsMachineFavoriteProvider(
      machineId,
    );
  }

  @override
  IsMachineFavoriteProvider getProviderOverride(
    covariant IsMachineFavoriteProvider provider,
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
  String? get name => r'isMachineFavoriteProvider';
}

/// Provider for checking if a machine is favorited
///
/// Copied from [isMachineFavorite].
class IsMachineFavoriteProvider extends AutoDisposeProvider<bool> {
  /// Provider for checking if a machine is favorited
  ///
  /// Copied from [isMachineFavorite].
  IsMachineFavoriteProvider(
    String machineId,
  ) : this._internal(
          (ref) => isMachineFavorite(
            ref as IsMachineFavoriteRef,
            machineId,
          ),
          from: isMachineFavoriteProvider,
          name: r'isMachineFavoriteProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$isMachineFavoriteHash,
          dependencies: IsMachineFavoriteFamily._dependencies,
          allTransitiveDependencies:
              IsMachineFavoriteFamily._allTransitiveDependencies,
          machineId: machineId,
        );

  IsMachineFavoriteProvider._internal(
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
    bool Function(IsMachineFavoriteRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: IsMachineFavoriteProvider._internal(
        (ref) => create(ref as IsMachineFavoriteRef),
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
    return _IsMachineFavoriteProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is IsMachineFavoriteProvider && other.machineId == machineId;
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
mixin IsMachineFavoriteRef on AutoDisposeProviderRef<bool> {
  /// The parameter `machineId` of this provider.
  String get machineId;
}

class _IsMachineFavoriteProviderElement extends AutoDisposeProviderElement<bool>
    with IsMachineFavoriteRef {
  _IsMachineFavoriteProviderElement(super.provider);

  @override
  String get machineId => (origin as IsMachineFavoriteProvider).machineId;
}

String _$isFilterFavoriteHash() => r'75cfc87de81292e187f8edb9073cc13edcc90deb';

/// Provider for checking if a filter is favorited
///
/// Copied from [isFilterFavorite].
@ProviderFor(isFilterFavorite)
const isFilterFavoriteProvider = IsFilterFavoriteFamily();

/// Provider for checking if a filter is favorited
///
/// Copied from [isFilterFavorite].
class IsFilterFavoriteFamily extends Family<bool> {
  /// Provider for checking if a filter is favorited
  ///
  /// Copied from [isFilterFavorite].
  const IsFilterFavoriteFamily();

  /// Provider for checking if a filter is favorited
  ///
  /// Copied from [isFilterFavorite].
  IsFilterFavoriteProvider call(
    String filterType,
  ) {
    return IsFilterFavoriteProvider(
      filterType,
    );
  }

  @override
  IsFilterFavoriteProvider getProviderOverride(
    covariant IsFilterFavoriteProvider provider,
  ) {
    return call(
      provider.filterType,
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
  String? get name => r'isFilterFavoriteProvider';
}

/// Provider for checking if a filter is favorited
///
/// Copied from [isFilterFavorite].
class IsFilterFavoriteProvider extends AutoDisposeProvider<bool> {
  /// Provider for checking if a filter is favorited
  ///
  /// Copied from [isFilterFavorite].
  IsFilterFavoriteProvider(
    String filterType,
  ) : this._internal(
          (ref) => isFilterFavorite(
            ref as IsFilterFavoriteRef,
            filterType,
          ),
          from: isFilterFavoriteProvider,
          name: r'isFilterFavoriteProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$isFilterFavoriteHash,
          dependencies: IsFilterFavoriteFamily._dependencies,
          allTransitiveDependencies:
              IsFilterFavoriteFamily._allTransitiveDependencies,
          filterType: filterType,
        );

  IsFilterFavoriteProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.filterType,
  }) : super.internal();

  final String filterType;

  @override
  Override overrideWith(
    bool Function(IsFilterFavoriteRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: IsFilterFavoriteProvider._internal(
        (ref) => create(ref as IsFilterFavoriteRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        filterType: filterType,
      ),
    );
  }

  @override
  AutoDisposeProviderElement<bool> createElement() {
    return _IsFilterFavoriteProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is IsFilterFavoriteProvider && other.filterType == filterType;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, filterType.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin IsFilterFavoriteRef on AutoDisposeProviderRef<bool> {
  /// The parameter `filterType` of this provider.
  String get filterType;
}

class _IsFilterFavoriteProviderElement extends AutoDisposeProviderElement<bool>
    with IsFilterFavoriteRef {
  _IsFilterFavoriteProviderElement(super.provider);

  @override
  String get filterType => (origin as IsFilterFavoriteProvider).filterType;
}

String _$hasUserEmailHash() => r'f4696d63581e594c98402fcfc4865f4d29c0ac8e';

/// Provider for checking if user has email
///
/// Copied from [hasUserEmail].
@ProviderFor(hasUserEmail)
final hasUserEmailProvider = AutoDisposeProvider<bool>.internal(
  hasUserEmail,
  name: r'hasUserEmailProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$hasUserEmailHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef HasUserEmailRef = AutoDisposeProviderRef<bool>;
String _$isEmailConfirmedHash() => r'379016afe6453444b5cd296d23f9bc2db1e73736';

/// Provider for checking if email is confirmed
///
/// Copied from [isEmailConfirmed].
@ProviderFor(isEmailConfirmed)
final isEmailConfirmedProvider = AutoDisposeProvider<bool>.internal(
  isEmailConfirmed,
  name: r'isEmailConfirmedProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$isEmailConfirmedHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef IsEmailConfirmedRef = AutoDisposeProviderRef<bool>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
