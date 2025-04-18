// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'document_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$documentsHash() => r'69bf1b49f69ab85c7352de1dae76a3cb57fa9149';

/// Provider for accessing all documents
///
/// Copied from [documents].
@ProviderFor(documents)
final documentsProvider = AutoDisposeProvider<List<TechnicalDocument>>.internal(
  documents,
  name: r'documentsProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$documentsHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef DocumentsRef = AutoDisposeProviderRef<List<TechnicalDocument>>;
String _$filteredDocumentsHash() => r'1d9c14c00bf58d1648ff8ffdc211ab345e3ee6f8';

/// Provider for accessing filtered documents
///
/// Copied from [filteredDocuments].
@ProviderFor(filteredDocuments)
final filteredDocumentsProvider =
    AutoDisposeProvider<List<TechnicalDocument>>.internal(
  filteredDocuments,
  name: r'filteredDocumentsProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$filteredDocumentsHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef FilteredDocumentsRef = AutoDisposeProviderRef<List<TechnicalDocument>>;
String _$isDocumentsLoadingHash() =>
    r'a9141199e7457e80ebfb65b17531aaed6a19ec1a';

/// Provider for checking if documents are loading
///
/// Copied from [isDocumentsLoading].
@ProviderFor(isDocumentsLoading)
final isDocumentsLoadingProvider = AutoDisposeProvider<bool>.internal(
  isDocumentsLoading,
  name: r'isDocumentsLoadingProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$isDocumentsLoadingHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef IsDocumentsLoadingRef = AutoDisposeProviderRef<bool>;
String _$documentSearchQueryHash() =>
    r'd98ae9ff92d22c3aa32f6ba80aa2e4bf8d084841';

/// Provider for current search query
///
/// Copied from [documentSearchQuery].
@ProviderFor(documentSearchQuery)
final documentSearchQueryProvider = AutoDisposeProvider<String>.internal(
  documentSearchQuery,
  name: r'documentSearchQueryProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$documentSearchQueryHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef DocumentSearchQueryRef = AutoDisposeProviderRef<String>;
String _$selectedMachineIdHash() => r'33612e23a0bda688453092c59b4661b0ce747080';

/// Provider for selected machine ID filter
///
/// Copied from [selectedMachineId].
@ProviderFor(selectedMachineId)
final selectedMachineIdProvider = AutoDisposeProvider<String?>.internal(
  selectedMachineId,
  name: r'selectedMachineIdProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$selectedMachineIdHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef SelectedMachineIdRef = AutoDisposeProviderRef<String?>;
String _$selectedCategoryHash() => r'f0aa4337b03b3b0df3e946d933cef1c6ea6028c6';

/// Provider for selected category filter
///
/// Copied from [selectedCategory].
@ProviderFor(selectedCategory)
final selectedCategoryProvider = AutoDisposeProvider<String?>.internal(
  selectedCategory,
  name: r'selectedCategoryProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$selectedCategoryHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef SelectedCategoryRef = AutoDisposeProviderRef<String?>;
String _$documentDownloadProgressHash() =>
    r'0ba0c7e1e3d4793e15807283c6d01ea56944fdb3';

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

/// Provider for document download progress
///
/// Copied from [documentDownloadProgress].
@ProviderFor(documentDownloadProgress)
const documentDownloadProgressProvider = DocumentDownloadProgressFamily();

/// Provider for document download progress
///
/// Copied from [documentDownloadProgress].
class DocumentDownloadProgressFamily extends Family<double> {
  /// Provider for document download progress
  ///
  /// Copied from [documentDownloadProgress].
  const DocumentDownloadProgressFamily();

  /// Provider for document download progress
  ///
  /// Copied from [documentDownloadProgress].
  DocumentDownloadProgressProvider call(
    String documentId,
  ) {
    return DocumentDownloadProgressProvider(
      documentId,
    );
  }

  @override
  DocumentDownloadProgressProvider getProviderOverride(
    covariant DocumentDownloadProgressProvider provider,
  ) {
    return call(
      provider.documentId,
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
  String? get name => r'documentDownloadProgressProvider';
}

/// Provider for document download progress
///
/// Copied from [documentDownloadProgress].
class DocumentDownloadProgressProvider extends AutoDisposeProvider<double> {
  /// Provider for document download progress
  ///
  /// Copied from [documentDownloadProgress].
  DocumentDownloadProgressProvider(
    String documentId,
  ) : this._internal(
          (ref) => documentDownloadProgress(
            ref as DocumentDownloadProgressRef,
            documentId,
          ),
          from: documentDownloadProgressProvider,
          name: r'documentDownloadProgressProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$documentDownloadProgressHash,
          dependencies: DocumentDownloadProgressFamily._dependencies,
          allTransitiveDependencies:
              DocumentDownloadProgressFamily._allTransitiveDependencies,
          documentId: documentId,
        );

  DocumentDownloadProgressProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.documentId,
  }) : super.internal();

  final String documentId;

  @override
  Override overrideWith(
    double Function(DocumentDownloadProgressRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: DocumentDownloadProgressProvider._internal(
        (ref) => create(ref as DocumentDownloadProgressRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        documentId: documentId,
      ),
    );
  }

  @override
  AutoDisposeProviderElement<double> createElement() {
    return _DocumentDownloadProgressProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is DocumentDownloadProgressProvider &&
        other.documentId == documentId;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, documentId.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin DocumentDownloadProgressRef on AutoDisposeProviderRef<double> {
  /// The parameter `documentId` of this provider.
  String get documentId;
}

class _DocumentDownloadProgressProviderElement
    extends AutoDisposeProviderElement<double>
    with DocumentDownloadProgressRef {
  _DocumentDownloadProgressProviderElement(super.provider);

  @override
  String get documentId =>
      (origin as DocumentDownloadProgressProvider).documentId;
}

String _$isDocumentDownloadingHash() =>
    r'4a65369fa953ccd73be26d871f6e83b1d67033be';

/// Provider to check if a document is currently downloading
///
/// Copied from [isDocumentDownloading].
@ProviderFor(isDocumentDownloading)
const isDocumentDownloadingProvider = IsDocumentDownloadingFamily();

/// Provider to check if a document is currently downloading
///
/// Copied from [isDocumentDownloading].
class IsDocumentDownloadingFamily extends Family<bool> {
  /// Provider to check if a document is currently downloading
  ///
  /// Copied from [isDocumentDownloading].
  const IsDocumentDownloadingFamily();

  /// Provider to check if a document is currently downloading
  ///
  /// Copied from [isDocumentDownloading].
  IsDocumentDownloadingProvider call(
    String documentId,
  ) {
    return IsDocumentDownloadingProvider(
      documentId,
    );
  }

  @override
  IsDocumentDownloadingProvider getProviderOverride(
    covariant IsDocumentDownloadingProvider provider,
  ) {
    return call(
      provider.documentId,
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
  String? get name => r'isDocumentDownloadingProvider';
}

/// Provider to check if a document is currently downloading
///
/// Copied from [isDocumentDownloading].
class IsDocumentDownloadingProvider extends AutoDisposeProvider<bool> {
  /// Provider to check if a document is currently downloading
  ///
  /// Copied from [isDocumentDownloading].
  IsDocumentDownloadingProvider(
    String documentId,
  ) : this._internal(
          (ref) => isDocumentDownloading(
            ref as IsDocumentDownloadingRef,
            documentId,
          ),
          from: isDocumentDownloadingProvider,
          name: r'isDocumentDownloadingProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$isDocumentDownloadingHash,
          dependencies: IsDocumentDownloadingFamily._dependencies,
          allTransitiveDependencies:
              IsDocumentDownloadingFamily._allTransitiveDependencies,
          documentId: documentId,
        );

  IsDocumentDownloadingProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.documentId,
  }) : super.internal();

  final String documentId;

  @override
  Override overrideWith(
    bool Function(IsDocumentDownloadingRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: IsDocumentDownloadingProvider._internal(
        (ref) => create(ref as IsDocumentDownloadingRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        documentId: documentId,
      ),
    );
  }

  @override
  AutoDisposeProviderElement<bool> createElement() {
    return _IsDocumentDownloadingProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is IsDocumentDownloadingProvider &&
        other.documentId == documentId;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, documentId.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin IsDocumentDownloadingRef on AutoDisposeProviderRef<bool> {
  /// The parameter `documentId` of this provider.
  String get documentId;
}

class _IsDocumentDownloadingProviderElement
    extends AutoDisposeProviderElement<bool> with IsDocumentDownloadingRef {
  _IsDocumentDownloadingProviderElement(super.provider);

  @override
  String get documentId => (origin as IsDocumentDownloadingProvider).documentId;
}

String _$documentByIdHash() => r'834c35889f7ab56e5af2f7f1d824d8509a08045a';

/// Provider to get a specific document by ID
///
/// Copied from [documentById].
@ProviderFor(documentById)
const documentByIdProvider = DocumentByIdFamily();

/// Provider to get a specific document by ID
///
/// Copied from [documentById].
class DocumentByIdFamily extends Family<TechnicalDocument?> {
  /// Provider to get a specific document by ID
  ///
  /// Copied from [documentById].
  const DocumentByIdFamily();

  /// Provider to get a specific document by ID
  ///
  /// Copied from [documentById].
  DocumentByIdProvider call(
    String documentId,
  ) {
    return DocumentByIdProvider(
      documentId,
    );
  }

  @override
  DocumentByIdProvider getProviderOverride(
    covariant DocumentByIdProvider provider,
  ) {
    return call(
      provider.documentId,
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
  String? get name => r'documentByIdProvider';
}

/// Provider to get a specific document by ID
///
/// Copied from [documentById].
class DocumentByIdProvider extends AutoDisposeProvider<TechnicalDocument?> {
  /// Provider to get a specific document by ID
  ///
  /// Copied from [documentById].
  DocumentByIdProvider(
    String documentId,
  ) : this._internal(
          (ref) => documentById(
            ref as DocumentByIdRef,
            documentId,
          ),
          from: documentByIdProvider,
          name: r'documentByIdProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$documentByIdHash,
          dependencies: DocumentByIdFamily._dependencies,
          allTransitiveDependencies:
              DocumentByIdFamily._allTransitiveDependencies,
          documentId: documentId,
        );

  DocumentByIdProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.documentId,
  }) : super.internal();

  final String documentId;

  @override
  Override overrideWith(
    TechnicalDocument? Function(DocumentByIdRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: DocumentByIdProvider._internal(
        (ref) => create(ref as DocumentByIdRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        documentId: documentId,
      ),
    );
  }

  @override
  AutoDisposeProviderElement<TechnicalDocument?> createElement() {
    return _DocumentByIdProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is DocumentByIdProvider && other.documentId == documentId;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, documentId.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin DocumentByIdRef on AutoDisposeProviderRef<TechnicalDocument?> {
  /// The parameter `documentId` of this provider.
  String get documentId;
}

class _DocumentByIdProviderElement
    extends AutoDisposeProviderElement<TechnicalDocument?>
    with DocumentByIdRef {
  _DocumentByIdProviderElement(super.provider);

  @override
  String get documentId => (origin as DocumentByIdProvider).documentId;
}

String _$documentErrorHash() => r'edd8b95bee93717e52998f47bac4cb222dd590ef';

/// Provider for document error state
///
/// Copied from [documentError].
@ProviderFor(documentError)
final documentErrorProvider = AutoDisposeProvider<String?>.internal(
  documentError,
  name: r'documentErrorProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$documentErrorHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef DocumentErrorRef = AutoDisposeProviderRef<String?>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
