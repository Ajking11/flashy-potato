// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'database.dart';

// ignore_for_file: type=lint
class $DocumentsTable extends Documents
    with TableInfo<$DocumentsTable, Document> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $DocumentsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _titleMeta = const VerificationMeta('title');
  @override
  late final GeneratedColumn<String> title = GeneratedColumn<String>(
      'title', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _descriptionMeta =
      const VerificationMeta('description');
  @override
  late final GeneratedColumn<String> description = GeneratedColumn<String>(
      'description', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _machineIdsMeta =
      const VerificationMeta('machineIds');
  @override
  late final GeneratedColumn<String> machineIds = GeneratedColumn<String>(
      'machine_ids', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _categoryMeta =
      const VerificationMeta('category');
  @override
  late final GeneratedColumn<String> category = GeneratedColumn<String>(
      'category', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _filePathMeta =
      const VerificationMeta('filePath');
  @override
  late final GeneratedColumn<String> filePath = GeneratedColumn<String>(
      'file_path', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _downloadURLMeta =
      const VerificationMeta('downloadURL');
  @override
  late final GeneratedColumn<String> downloadURL = GeneratedColumn<String>(
      'download_u_r_l', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _uploadDateMeta =
      const VerificationMeta('uploadDate');
  @override
  late final GeneratedColumn<DateTime> uploadDate = GeneratedColumn<DateTime>(
      'upload_date', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  static const VerificationMeta _fileSizeKBMeta =
      const VerificationMeta('fileSizeKB');
  @override
  late final GeneratedColumn<int> fileSizeKB = GeneratedColumn<int>(
      'file_size_k_b', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _isDownloadedMeta =
      const VerificationMeta('isDownloaded');
  @override
  late final GeneratedColumn<bool> isDownloaded = GeneratedColumn<bool>(
      'is_downloaded', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints: GeneratedColumn.constraintIsAlways(
          'CHECK ("is_downloaded" IN (0, 1))'),
      defaultValue: const Constant(false));
  static const VerificationMeta _tagsMeta = const VerificationMeta('tags');
  @override
  late final GeneratedColumn<String> tags = GeneratedColumn<String>(
      'tags', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _uploadedByMeta =
      const VerificationMeta('uploadedBy');
  @override
  late final GeneratedColumn<String> uploadedBy = GeneratedColumn<String>(
      'uploaded_by', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _sha256FileHashMeta =
      const VerificationMeta('sha256FileHash');
  @override
  late final GeneratedColumn<String> sha256FileHash = GeneratedColumn<String>(
      'sha256_file_hash', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _lastSyncedMeta =
      const VerificationMeta('lastSynced');
  @override
  late final GeneratedColumn<DateTime> lastSynced = GeneratedColumn<DateTime>(
      'last_synced', aliasedName, false,
      type: DriftSqlType.dateTime,
      requiredDuringInsert: false,
      defaultValue: currentDateAndTime);
  @override
  List<GeneratedColumn> get $columns => [
        id,
        title,
        description,
        machineIds,
        category,
        filePath,
        downloadURL,
        uploadDate,
        fileSizeKB,
        isDownloaded,
        tags,
        uploadedBy,
        sha256FileHash,
        lastSynced
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'documents';
  @override
  VerificationContext validateIntegrity(Insertable<Document> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('title')) {
      context.handle(
          _titleMeta, title.isAcceptableOrUnknown(data['title']!, _titleMeta));
    } else if (isInserting) {
      context.missing(_titleMeta);
    }
    if (data.containsKey('description')) {
      context.handle(
          _descriptionMeta,
          description.isAcceptableOrUnknown(
              data['description']!, _descriptionMeta));
    } else if (isInserting) {
      context.missing(_descriptionMeta);
    }
    if (data.containsKey('machine_ids')) {
      context.handle(
          _machineIdsMeta,
          machineIds.isAcceptableOrUnknown(
              data['machine_ids']!, _machineIdsMeta));
    } else if (isInserting) {
      context.missing(_machineIdsMeta);
    }
    if (data.containsKey('category')) {
      context.handle(_categoryMeta,
          category.isAcceptableOrUnknown(data['category']!, _categoryMeta));
    } else if (isInserting) {
      context.missing(_categoryMeta);
    }
    if (data.containsKey('file_path')) {
      context.handle(_filePathMeta,
          filePath.isAcceptableOrUnknown(data['file_path']!, _filePathMeta));
    } else if (isInserting) {
      context.missing(_filePathMeta);
    }
    if (data.containsKey('download_u_r_l')) {
      context.handle(
          _downloadURLMeta,
          downloadURL.isAcceptableOrUnknown(
              data['download_u_r_l']!, _downloadURLMeta));
    }
    if (data.containsKey('upload_date')) {
      context.handle(
          _uploadDateMeta,
          uploadDate.isAcceptableOrUnknown(
              data['upload_date']!, _uploadDateMeta));
    } else if (isInserting) {
      context.missing(_uploadDateMeta);
    }
    if (data.containsKey('file_size_k_b')) {
      context.handle(
          _fileSizeKBMeta,
          fileSizeKB.isAcceptableOrUnknown(
              data['file_size_k_b']!, _fileSizeKBMeta));
    } else if (isInserting) {
      context.missing(_fileSizeKBMeta);
    }
    if (data.containsKey('is_downloaded')) {
      context.handle(
          _isDownloadedMeta,
          isDownloaded.isAcceptableOrUnknown(
              data['is_downloaded']!, _isDownloadedMeta));
    }
    if (data.containsKey('tags')) {
      context.handle(
          _tagsMeta, tags.isAcceptableOrUnknown(data['tags']!, _tagsMeta));
    } else if (isInserting) {
      context.missing(_tagsMeta);
    }
    if (data.containsKey('uploaded_by')) {
      context.handle(
          _uploadedByMeta,
          uploadedBy.isAcceptableOrUnknown(
              data['uploaded_by']!, _uploadedByMeta));
    }
    if (data.containsKey('sha256_file_hash')) {
      context.handle(
          _sha256FileHashMeta,
          sha256FileHash.isAcceptableOrUnknown(
              data['sha256_file_hash']!, _sha256FileHashMeta));
    }
    if (data.containsKey('last_synced')) {
      context.handle(
          _lastSyncedMeta,
          lastSynced.isAcceptableOrUnknown(
              data['last_synced']!, _lastSyncedMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Document map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Document(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      title: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}title'])!,
      description: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}description'])!,
      machineIds: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}machine_ids'])!,
      category: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}category'])!,
      filePath: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}file_path'])!,
      downloadURL: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}download_u_r_l']),
      uploadDate: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}upload_date'])!,
      fileSizeKB: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}file_size_k_b'])!,
      isDownloaded: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}is_downloaded'])!,
      tags: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}tags'])!,
      uploadedBy: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}uploaded_by']),
      sha256FileHash: attachedDatabase.typeMapping.read(
          DriftSqlType.string, data['${effectivePrefix}sha256_file_hash']),
      lastSynced: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}last_synced'])!,
    );
  }

  @override
  $DocumentsTable createAlias(String alias) {
    return $DocumentsTable(attachedDatabase, alias);
  }
}

class Document extends DataClass implements Insertable<Document> {
  final String id;
  final String title;
  final String description;
  final String machineIds;
  final String category;
  final String filePath;
  final String? downloadURL;
  final DateTime uploadDate;
  final int fileSizeKB;
  final bool isDownloaded;
  final String tags;
  final String? uploadedBy;
  final String? sha256FileHash;
  final DateTime lastSynced;
  const Document(
      {required this.id,
      required this.title,
      required this.description,
      required this.machineIds,
      required this.category,
      required this.filePath,
      this.downloadURL,
      required this.uploadDate,
      required this.fileSizeKB,
      required this.isDownloaded,
      required this.tags,
      this.uploadedBy,
      this.sha256FileHash,
      required this.lastSynced});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['title'] = Variable<String>(title);
    map['description'] = Variable<String>(description);
    map['machine_ids'] = Variable<String>(machineIds);
    map['category'] = Variable<String>(category);
    map['file_path'] = Variable<String>(filePath);
    if (!nullToAbsent || downloadURL != null) {
      map['download_u_r_l'] = Variable<String>(downloadURL);
    }
    map['upload_date'] = Variable<DateTime>(uploadDate);
    map['file_size_k_b'] = Variable<int>(fileSizeKB);
    map['is_downloaded'] = Variable<bool>(isDownloaded);
    map['tags'] = Variable<String>(tags);
    if (!nullToAbsent || uploadedBy != null) {
      map['uploaded_by'] = Variable<String>(uploadedBy);
    }
    if (!nullToAbsent || sha256FileHash != null) {
      map['sha256_file_hash'] = Variable<String>(sha256FileHash);
    }
    map['last_synced'] = Variable<DateTime>(lastSynced);
    return map;
  }

  DocumentsCompanion toCompanion(bool nullToAbsent) {
    return DocumentsCompanion(
      id: Value(id),
      title: Value(title),
      description: Value(description),
      machineIds: Value(machineIds),
      category: Value(category),
      filePath: Value(filePath),
      downloadURL: downloadURL == null && nullToAbsent
          ? const Value.absent()
          : Value(downloadURL),
      uploadDate: Value(uploadDate),
      fileSizeKB: Value(fileSizeKB),
      isDownloaded: Value(isDownloaded),
      tags: Value(tags),
      uploadedBy: uploadedBy == null && nullToAbsent
          ? const Value.absent()
          : Value(uploadedBy),
      sha256FileHash: sha256FileHash == null && nullToAbsent
          ? const Value.absent()
          : Value(sha256FileHash),
      lastSynced: Value(lastSynced),
    );
  }

  factory Document.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Document(
      id: serializer.fromJson<String>(json['id']),
      title: serializer.fromJson<String>(json['title']),
      description: serializer.fromJson<String>(json['description']),
      machineIds: serializer.fromJson<String>(json['machineIds']),
      category: serializer.fromJson<String>(json['category']),
      filePath: serializer.fromJson<String>(json['filePath']),
      downloadURL: serializer.fromJson<String?>(json['downloadURL']),
      uploadDate: serializer.fromJson<DateTime>(json['uploadDate']),
      fileSizeKB: serializer.fromJson<int>(json['fileSizeKB']),
      isDownloaded: serializer.fromJson<bool>(json['isDownloaded']),
      tags: serializer.fromJson<String>(json['tags']),
      uploadedBy: serializer.fromJson<String?>(json['uploadedBy']),
      sha256FileHash: serializer.fromJson<String?>(json['sha256FileHash']),
      lastSynced: serializer.fromJson<DateTime>(json['lastSynced']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'title': serializer.toJson<String>(title),
      'description': serializer.toJson<String>(description),
      'machineIds': serializer.toJson<String>(machineIds),
      'category': serializer.toJson<String>(category),
      'filePath': serializer.toJson<String>(filePath),
      'downloadURL': serializer.toJson<String?>(downloadURL),
      'uploadDate': serializer.toJson<DateTime>(uploadDate),
      'fileSizeKB': serializer.toJson<int>(fileSizeKB),
      'isDownloaded': serializer.toJson<bool>(isDownloaded),
      'tags': serializer.toJson<String>(tags),
      'uploadedBy': serializer.toJson<String?>(uploadedBy),
      'sha256FileHash': serializer.toJson<String?>(sha256FileHash),
      'lastSynced': serializer.toJson<DateTime>(lastSynced),
    };
  }

  Document copyWith(
          {String? id,
          String? title,
          String? description,
          String? machineIds,
          String? category,
          String? filePath,
          Value<String?> downloadURL = const Value.absent(),
          DateTime? uploadDate,
          int? fileSizeKB,
          bool? isDownloaded,
          String? tags,
          Value<String?> uploadedBy = const Value.absent(),
          Value<String?> sha256FileHash = const Value.absent(),
          DateTime? lastSynced}) =>
      Document(
        id: id ?? this.id,
        title: title ?? this.title,
        description: description ?? this.description,
        machineIds: machineIds ?? this.machineIds,
        category: category ?? this.category,
        filePath: filePath ?? this.filePath,
        downloadURL: downloadURL.present ? downloadURL.value : this.downloadURL,
        uploadDate: uploadDate ?? this.uploadDate,
        fileSizeKB: fileSizeKB ?? this.fileSizeKB,
        isDownloaded: isDownloaded ?? this.isDownloaded,
        tags: tags ?? this.tags,
        uploadedBy: uploadedBy.present ? uploadedBy.value : this.uploadedBy,
        sha256FileHash:
            sha256FileHash.present ? sha256FileHash.value : this.sha256FileHash,
        lastSynced: lastSynced ?? this.lastSynced,
      );
  Document copyWithCompanion(DocumentsCompanion data) {
    return Document(
      id: data.id.present ? data.id.value : this.id,
      title: data.title.present ? data.title.value : this.title,
      description:
          data.description.present ? data.description.value : this.description,
      machineIds:
          data.machineIds.present ? data.machineIds.value : this.machineIds,
      category: data.category.present ? data.category.value : this.category,
      filePath: data.filePath.present ? data.filePath.value : this.filePath,
      downloadURL:
          data.downloadURL.present ? data.downloadURL.value : this.downloadURL,
      uploadDate:
          data.uploadDate.present ? data.uploadDate.value : this.uploadDate,
      fileSizeKB:
          data.fileSizeKB.present ? data.fileSizeKB.value : this.fileSizeKB,
      isDownloaded: data.isDownloaded.present
          ? data.isDownloaded.value
          : this.isDownloaded,
      tags: data.tags.present ? data.tags.value : this.tags,
      uploadedBy:
          data.uploadedBy.present ? data.uploadedBy.value : this.uploadedBy,
      sha256FileHash: data.sha256FileHash.present
          ? data.sha256FileHash.value
          : this.sha256FileHash,
      lastSynced:
          data.lastSynced.present ? data.lastSynced.value : this.lastSynced,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Document(')
          ..write('id: $id, ')
          ..write('title: $title, ')
          ..write('description: $description, ')
          ..write('machineIds: $machineIds, ')
          ..write('category: $category, ')
          ..write('filePath: $filePath, ')
          ..write('downloadURL: $downloadURL, ')
          ..write('uploadDate: $uploadDate, ')
          ..write('fileSizeKB: $fileSizeKB, ')
          ..write('isDownloaded: $isDownloaded, ')
          ..write('tags: $tags, ')
          ..write('uploadedBy: $uploadedBy, ')
          ..write('sha256FileHash: $sha256FileHash, ')
          ..write('lastSynced: $lastSynced')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
      id,
      title,
      description,
      machineIds,
      category,
      filePath,
      downloadURL,
      uploadDate,
      fileSizeKB,
      isDownloaded,
      tags,
      uploadedBy,
      sha256FileHash,
      lastSynced);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Document &&
          other.id == this.id &&
          other.title == this.title &&
          other.description == this.description &&
          other.machineIds == this.machineIds &&
          other.category == this.category &&
          other.filePath == this.filePath &&
          other.downloadURL == this.downloadURL &&
          other.uploadDate == this.uploadDate &&
          other.fileSizeKB == this.fileSizeKB &&
          other.isDownloaded == this.isDownloaded &&
          other.tags == this.tags &&
          other.uploadedBy == this.uploadedBy &&
          other.sha256FileHash == this.sha256FileHash &&
          other.lastSynced == this.lastSynced);
}

class DocumentsCompanion extends UpdateCompanion<Document> {
  final Value<String> id;
  final Value<String> title;
  final Value<String> description;
  final Value<String> machineIds;
  final Value<String> category;
  final Value<String> filePath;
  final Value<String?> downloadURL;
  final Value<DateTime> uploadDate;
  final Value<int> fileSizeKB;
  final Value<bool> isDownloaded;
  final Value<String> tags;
  final Value<String?> uploadedBy;
  final Value<String?> sha256FileHash;
  final Value<DateTime> lastSynced;
  final Value<int> rowid;
  const DocumentsCompanion({
    this.id = const Value.absent(),
    this.title = const Value.absent(),
    this.description = const Value.absent(),
    this.machineIds = const Value.absent(),
    this.category = const Value.absent(),
    this.filePath = const Value.absent(),
    this.downloadURL = const Value.absent(),
    this.uploadDate = const Value.absent(),
    this.fileSizeKB = const Value.absent(),
    this.isDownloaded = const Value.absent(),
    this.tags = const Value.absent(),
    this.uploadedBy = const Value.absent(),
    this.sha256FileHash = const Value.absent(),
    this.lastSynced = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  DocumentsCompanion.insert({
    required String id,
    required String title,
    required String description,
    required String machineIds,
    required String category,
    required String filePath,
    this.downloadURL = const Value.absent(),
    required DateTime uploadDate,
    required int fileSizeKB,
    this.isDownloaded = const Value.absent(),
    required String tags,
    this.uploadedBy = const Value.absent(),
    this.sha256FileHash = const Value.absent(),
    this.lastSynced = const Value.absent(),
    this.rowid = const Value.absent(),
  })  : id = Value(id),
        title = Value(title),
        description = Value(description),
        machineIds = Value(machineIds),
        category = Value(category),
        filePath = Value(filePath),
        uploadDate = Value(uploadDate),
        fileSizeKB = Value(fileSizeKB),
        tags = Value(tags);
  static Insertable<Document> custom({
    Expression<String>? id,
    Expression<String>? title,
    Expression<String>? description,
    Expression<String>? machineIds,
    Expression<String>? category,
    Expression<String>? filePath,
    Expression<String>? downloadURL,
    Expression<DateTime>? uploadDate,
    Expression<int>? fileSizeKB,
    Expression<bool>? isDownloaded,
    Expression<String>? tags,
    Expression<String>? uploadedBy,
    Expression<String>? sha256FileHash,
    Expression<DateTime>? lastSynced,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (title != null) 'title': title,
      if (description != null) 'description': description,
      if (machineIds != null) 'machine_ids': machineIds,
      if (category != null) 'category': category,
      if (filePath != null) 'file_path': filePath,
      if (downloadURL != null) 'download_u_r_l': downloadURL,
      if (uploadDate != null) 'upload_date': uploadDate,
      if (fileSizeKB != null) 'file_size_k_b': fileSizeKB,
      if (isDownloaded != null) 'is_downloaded': isDownloaded,
      if (tags != null) 'tags': tags,
      if (uploadedBy != null) 'uploaded_by': uploadedBy,
      if (sha256FileHash != null) 'sha256_file_hash': sha256FileHash,
      if (lastSynced != null) 'last_synced': lastSynced,
      if (rowid != null) 'rowid': rowid,
    });
  }

  DocumentsCompanion copyWith(
      {Value<String>? id,
      Value<String>? title,
      Value<String>? description,
      Value<String>? machineIds,
      Value<String>? category,
      Value<String>? filePath,
      Value<String?>? downloadURL,
      Value<DateTime>? uploadDate,
      Value<int>? fileSizeKB,
      Value<bool>? isDownloaded,
      Value<String>? tags,
      Value<String?>? uploadedBy,
      Value<String?>? sha256FileHash,
      Value<DateTime>? lastSynced,
      Value<int>? rowid}) {
    return DocumentsCompanion(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      machineIds: machineIds ?? this.machineIds,
      category: category ?? this.category,
      filePath: filePath ?? this.filePath,
      downloadURL: downloadURL ?? this.downloadURL,
      uploadDate: uploadDate ?? this.uploadDate,
      fileSizeKB: fileSizeKB ?? this.fileSizeKB,
      isDownloaded: isDownloaded ?? this.isDownloaded,
      tags: tags ?? this.tags,
      uploadedBy: uploadedBy ?? this.uploadedBy,
      sha256FileHash: sha256FileHash ?? this.sha256FileHash,
      lastSynced: lastSynced ?? this.lastSynced,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (title.present) {
      map['title'] = Variable<String>(title.value);
    }
    if (description.present) {
      map['description'] = Variable<String>(description.value);
    }
    if (machineIds.present) {
      map['machine_ids'] = Variable<String>(machineIds.value);
    }
    if (category.present) {
      map['category'] = Variable<String>(category.value);
    }
    if (filePath.present) {
      map['file_path'] = Variable<String>(filePath.value);
    }
    if (downloadURL.present) {
      map['download_u_r_l'] = Variable<String>(downloadURL.value);
    }
    if (uploadDate.present) {
      map['upload_date'] = Variable<DateTime>(uploadDate.value);
    }
    if (fileSizeKB.present) {
      map['file_size_k_b'] = Variable<int>(fileSizeKB.value);
    }
    if (isDownloaded.present) {
      map['is_downloaded'] = Variable<bool>(isDownloaded.value);
    }
    if (tags.present) {
      map['tags'] = Variable<String>(tags.value);
    }
    if (uploadedBy.present) {
      map['uploaded_by'] = Variable<String>(uploadedBy.value);
    }
    if (sha256FileHash.present) {
      map['sha256_file_hash'] = Variable<String>(sha256FileHash.value);
    }
    if (lastSynced.present) {
      map['last_synced'] = Variable<DateTime>(lastSynced.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('DocumentsCompanion(')
          ..write('id: $id, ')
          ..write('title: $title, ')
          ..write('description: $description, ')
          ..write('machineIds: $machineIds, ')
          ..write('category: $category, ')
          ..write('filePath: $filePath, ')
          ..write('downloadURL: $downloadURL, ')
          ..write('uploadDate: $uploadDate, ')
          ..write('fileSizeKB: $fileSizeKB, ')
          ..write('isDownloaded: $isDownloaded, ')
          ..write('tags: $tags, ')
          ..write('uploadedBy: $uploadedBy, ')
          ..write('sha256FileHash: $sha256FileHash, ')
          ..write('lastSynced: $lastSynced, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $SoftwaresTable extends Softwares
    with TableInfo<$SoftwaresTable, Software> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $SoftwaresTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
      'name', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _versionMeta =
      const VerificationMeta('version');
  @override
  late final GeneratedColumn<String> version = GeneratedColumn<String>(
      'version', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _descriptionMeta =
      const VerificationMeta('description');
  @override
  late final GeneratedColumn<String> description = GeneratedColumn<String>(
      'description', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _machineIdsMeta =
      const VerificationMeta('machineIds');
  @override
  late final GeneratedColumn<String> machineIds = GeneratedColumn<String>(
      'machine_ids', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _categoryMeta =
      const VerificationMeta('category');
  @override
  late final GeneratedColumn<String> category = GeneratedColumn<String>(
      'category', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _filePathMeta =
      const VerificationMeta('filePath');
  @override
  late final GeneratedColumn<String> filePath = GeneratedColumn<String>(
      'file_path', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _downloadURLMeta =
      const VerificationMeta('downloadURL');
  @override
  late final GeneratedColumn<String> downloadURL = GeneratedColumn<String>(
      'download_u_r_l', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _uploadDateMeta =
      const VerificationMeta('uploadDate');
  @override
  late final GeneratedColumn<DateTime> uploadDate = GeneratedColumn<DateTime>(
      'upload_date', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  static const VerificationMeta _fileSizeKBMeta =
      const VerificationMeta('fileSizeKB');
  @override
  late final GeneratedColumn<int> fileSizeKB = GeneratedColumn<int>(
      'file_size_k_b', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _isDownloadedMeta =
      const VerificationMeta('isDownloaded');
  @override
  late final GeneratedColumn<bool> isDownloaded = GeneratedColumn<bool>(
      'is_downloaded', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints: GeneratedColumn.constraintIsAlways(
          'CHECK ("is_downloaded" IN (0, 1))'),
      defaultValue: const Constant(false));
  static const VerificationMeta _tagsMeta = const VerificationMeta('tags');
  @override
  late final GeneratedColumn<String> tags = GeneratedColumn<String>(
      'tags', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _uploadedByMeta =
      const VerificationMeta('uploadedBy');
  @override
  late final GeneratedColumn<String> uploadedBy = GeneratedColumn<String>(
      'uploaded_by', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _sha256FileHashMeta =
      const VerificationMeta('sha256FileHash');
  @override
  late final GeneratedColumn<String> sha256FileHash = GeneratedColumn<String>(
      'sha256_file_hash', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _changelogNotesMeta =
      const VerificationMeta('changelogNotes');
  @override
  late final GeneratedColumn<String> changelogNotes = GeneratedColumn<String>(
      'changelog_notes', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _previousVersionMeta =
      const VerificationMeta('previousVersion');
  @override
  late final GeneratedColumn<String> previousVersion = GeneratedColumn<String>(
      'previous_version', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _passwordMeta =
      const VerificationMeta('password');
  @override
  late final GeneratedColumn<String> password = GeneratedColumn<String>(
      'password', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _concessionMeta =
      const VerificationMeta('concession');
  @override
  late final GeneratedColumn<String> concession = GeneratedColumn<String>(
      'concession', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _downloadCountMeta =
      const VerificationMeta('downloadCount');
  @override
  late final GeneratedColumn<int> downloadCount = GeneratedColumn<int>(
      'download_count', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(0));
  static const VerificationMeta _minVersionMeta =
      const VerificationMeta('minVersion');
  @override
  late final GeneratedColumn<String> minVersion = GeneratedColumn<String>(
      'min_version', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _lastSyncedMeta =
      const VerificationMeta('lastSynced');
  @override
  late final GeneratedColumn<DateTime> lastSynced = GeneratedColumn<DateTime>(
      'last_synced', aliasedName, false,
      type: DriftSqlType.dateTime,
      requiredDuringInsert: false,
      defaultValue: currentDateAndTime);
  @override
  List<GeneratedColumn> get $columns => [
        id,
        name,
        version,
        description,
        machineIds,
        category,
        filePath,
        downloadURL,
        uploadDate,
        fileSizeKB,
        isDownloaded,
        tags,
        uploadedBy,
        sha256FileHash,
        changelogNotes,
        previousVersion,
        password,
        concession,
        downloadCount,
        minVersion,
        lastSynced
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'softwares';
  @override
  VerificationContext validateIntegrity(Insertable<Software> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
          _nameMeta, name.isAcceptableOrUnknown(data['name']!, _nameMeta));
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('version')) {
      context.handle(_versionMeta,
          version.isAcceptableOrUnknown(data['version']!, _versionMeta));
    } else if (isInserting) {
      context.missing(_versionMeta);
    }
    if (data.containsKey('description')) {
      context.handle(
          _descriptionMeta,
          description.isAcceptableOrUnknown(
              data['description']!, _descriptionMeta));
    } else if (isInserting) {
      context.missing(_descriptionMeta);
    }
    if (data.containsKey('machine_ids')) {
      context.handle(
          _machineIdsMeta,
          machineIds.isAcceptableOrUnknown(
              data['machine_ids']!, _machineIdsMeta));
    } else if (isInserting) {
      context.missing(_machineIdsMeta);
    }
    if (data.containsKey('category')) {
      context.handle(_categoryMeta,
          category.isAcceptableOrUnknown(data['category']!, _categoryMeta));
    } else if (isInserting) {
      context.missing(_categoryMeta);
    }
    if (data.containsKey('file_path')) {
      context.handle(_filePathMeta,
          filePath.isAcceptableOrUnknown(data['file_path']!, _filePathMeta));
    } else if (isInserting) {
      context.missing(_filePathMeta);
    }
    if (data.containsKey('download_u_r_l')) {
      context.handle(
          _downloadURLMeta,
          downloadURL.isAcceptableOrUnknown(
              data['download_u_r_l']!, _downloadURLMeta));
    }
    if (data.containsKey('upload_date')) {
      context.handle(
          _uploadDateMeta,
          uploadDate.isAcceptableOrUnknown(
              data['upload_date']!, _uploadDateMeta));
    } else if (isInserting) {
      context.missing(_uploadDateMeta);
    }
    if (data.containsKey('file_size_k_b')) {
      context.handle(
          _fileSizeKBMeta,
          fileSizeKB.isAcceptableOrUnknown(
              data['file_size_k_b']!, _fileSizeKBMeta));
    } else if (isInserting) {
      context.missing(_fileSizeKBMeta);
    }
    if (data.containsKey('is_downloaded')) {
      context.handle(
          _isDownloadedMeta,
          isDownloaded.isAcceptableOrUnknown(
              data['is_downloaded']!, _isDownloadedMeta));
    }
    if (data.containsKey('tags')) {
      context.handle(
          _tagsMeta, tags.isAcceptableOrUnknown(data['tags']!, _tagsMeta));
    } else if (isInserting) {
      context.missing(_tagsMeta);
    }
    if (data.containsKey('uploaded_by')) {
      context.handle(
          _uploadedByMeta,
          uploadedBy.isAcceptableOrUnknown(
              data['uploaded_by']!, _uploadedByMeta));
    }
    if (data.containsKey('sha256_file_hash')) {
      context.handle(
          _sha256FileHashMeta,
          sha256FileHash.isAcceptableOrUnknown(
              data['sha256_file_hash']!, _sha256FileHashMeta));
    }
    if (data.containsKey('changelog_notes')) {
      context.handle(
          _changelogNotesMeta,
          changelogNotes.isAcceptableOrUnknown(
              data['changelog_notes']!, _changelogNotesMeta));
    } else if (isInserting) {
      context.missing(_changelogNotesMeta);
    }
    if (data.containsKey('previous_version')) {
      context.handle(
          _previousVersionMeta,
          previousVersion.isAcceptableOrUnknown(
              data['previous_version']!, _previousVersionMeta));
    }
    if (data.containsKey('password')) {
      context.handle(_passwordMeta,
          password.isAcceptableOrUnknown(data['password']!, _passwordMeta));
    }
    if (data.containsKey('concession')) {
      context.handle(
          _concessionMeta,
          concession.isAcceptableOrUnknown(
              data['concession']!, _concessionMeta));
    } else if (isInserting) {
      context.missing(_concessionMeta);
    }
    if (data.containsKey('download_count')) {
      context.handle(
          _downloadCountMeta,
          downloadCount.isAcceptableOrUnknown(
              data['download_count']!, _downloadCountMeta));
    }
    if (data.containsKey('min_version')) {
      context.handle(
          _minVersionMeta,
          minVersion.isAcceptableOrUnknown(
              data['min_version']!, _minVersionMeta));
    }
    if (data.containsKey('last_synced')) {
      context.handle(
          _lastSyncedMeta,
          lastSynced.isAcceptableOrUnknown(
              data['last_synced']!, _lastSyncedMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Software map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Software(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      name: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}name'])!,
      version: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}version'])!,
      description: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}description'])!,
      machineIds: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}machine_ids'])!,
      category: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}category'])!,
      filePath: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}file_path'])!,
      downloadURL: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}download_u_r_l']),
      uploadDate: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}upload_date'])!,
      fileSizeKB: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}file_size_k_b'])!,
      isDownloaded: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}is_downloaded'])!,
      tags: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}tags'])!,
      uploadedBy: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}uploaded_by']),
      sha256FileHash: attachedDatabase.typeMapping.read(
          DriftSqlType.string, data['${effectivePrefix}sha256_file_hash']),
      changelogNotes: attachedDatabase.typeMapping.read(
          DriftSqlType.string, data['${effectivePrefix}changelog_notes'])!,
      previousVersion: attachedDatabase.typeMapping.read(
          DriftSqlType.string, data['${effectivePrefix}previous_version']),
      password: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}password']),
      concession: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}concession'])!,
      downloadCount: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}download_count'])!,
      minVersion: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}min_version']),
      lastSynced: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}last_synced'])!,
    );
  }

  @override
  $SoftwaresTable createAlias(String alias) {
    return $SoftwaresTable(attachedDatabase, alias);
  }
}

class Software extends DataClass implements Insertable<Software> {
  final String id;
  final String name;
  final String version;
  final String description;
  final String machineIds;
  final String category;
  final String filePath;
  final String? downloadURL;
  final DateTime uploadDate;
  final int fileSizeKB;
  final bool isDownloaded;
  final String tags;
  final String? uploadedBy;
  final String? sha256FileHash;
  final String changelogNotes;
  final String? previousVersion;
  final String? password;
  final String concession;
  final int downloadCount;
  final String? minVersion;
  final DateTime lastSynced;
  const Software(
      {required this.id,
      required this.name,
      required this.version,
      required this.description,
      required this.machineIds,
      required this.category,
      required this.filePath,
      this.downloadURL,
      required this.uploadDate,
      required this.fileSizeKB,
      required this.isDownloaded,
      required this.tags,
      this.uploadedBy,
      this.sha256FileHash,
      required this.changelogNotes,
      this.previousVersion,
      this.password,
      required this.concession,
      required this.downloadCount,
      this.minVersion,
      required this.lastSynced});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['name'] = Variable<String>(name);
    map['version'] = Variable<String>(version);
    map['description'] = Variable<String>(description);
    map['machine_ids'] = Variable<String>(machineIds);
    map['category'] = Variable<String>(category);
    map['file_path'] = Variable<String>(filePath);
    if (!nullToAbsent || downloadURL != null) {
      map['download_u_r_l'] = Variable<String>(downloadURL);
    }
    map['upload_date'] = Variable<DateTime>(uploadDate);
    map['file_size_k_b'] = Variable<int>(fileSizeKB);
    map['is_downloaded'] = Variable<bool>(isDownloaded);
    map['tags'] = Variable<String>(tags);
    if (!nullToAbsent || uploadedBy != null) {
      map['uploaded_by'] = Variable<String>(uploadedBy);
    }
    if (!nullToAbsent || sha256FileHash != null) {
      map['sha256_file_hash'] = Variable<String>(sha256FileHash);
    }
    map['changelog_notes'] = Variable<String>(changelogNotes);
    if (!nullToAbsent || previousVersion != null) {
      map['previous_version'] = Variable<String>(previousVersion);
    }
    if (!nullToAbsent || password != null) {
      map['password'] = Variable<String>(password);
    }
    map['concession'] = Variable<String>(concession);
    map['download_count'] = Variable<int>(downloadCount);
    if (!nullToAbsent || minVersion != null) {
      map['min_version'] = Variable<String>(minVersion);
    }
    map['last_synced'] = Variable<DateTime>(lastSynced);
    return map;
  }

  SoftwaresCompanion toCompanion(bool nullToAbsent) {
    return SoftwaresCompanion(
      id: Value(id),
      name: Value(name),
      version: Value(version),
      description: Value(description),
      machineIds: Value(machineIds),
      category: Value(category),
      filePath: Value(filePath),
      downloadURL: downloadURL == null && nullToAbsent
          ? const Value.absent()
          : Value(downloadURL),
      uploadDate: Value(uploadDate),
      fileSizeKB: Value(fileSizeKB),
      isDownloaded: Value(isDownloaded),
      tags: Value(tags),
      uploadedBy: uploadedBy == null && nullToAbsent
          ? const Value.absent()
          : Value(uploadedBy),
      sha256FileHash: sha256FileHash == null && nullToAbsent
          ? const Value.absent()
          : Value(sha256FileHash),
      changelogNotes: Value(changelogNotes),
      previousVersion: previousVersion == null && nullToAbsent
          ? const Value.absent()
          : Value(previousVersion),
      password: password == null && nullToAbsent
          ? const Value.absent()
          : Value(password),
      concession: Value(concession),
      downloadCount: Value(downloadCount),
      minVersion: minVersion == null && nullToAbsent
          ? const Value.absent()
          : Value(minVersion),
      lastSynced: Value(lastSynced),
    );
  }

  factory Software.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Software(
      id: serializer.fromJson<String>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      version: serializer.fromJson<String>(json['version']),
      description: serializer.fromJson<String>(json['description']),
      machineIds: serializer.fromJson<String>(json['machineIds']),
      category: serializer.fromJson<String>(json['category']),
      filePath: serializer.fromJson<String>(json['filePath']),
      downloadURL: serializer.fromJson<String?>(json['downloadURL']),
      uploadDate: serializer.fromJson<DateTime>(json['uploadDate']),
      fileSizeKB: serializer.fromJson<int>(json['fileSizeKB']),
      isDownloaded: serializer.fromJson<bool>(json['isDownloaded']),
      tags: serializer.fromJson<String>(json['tags']),
      uploadedBy: serializer.fromJson<String?>(json['uploadedBy']),
      sha256FileHash: serializer.fromJson<String?>(json['sha256FileHash']),
      changelogNotes: serializer.fromJson<String>(json['changelogNotes']),
      previousVersion: serializer.fromJson<String?>(json['previousVersion']),
      password: serializer.fromJson<String?>(json['password']),
      concession: serializer.fromJson<String>(json['concession']),
      downloadCount: serializer.fromJson<int>(json['downloadCount']),
      minVersion: serializer.fromJson<String?>(json['minVersion']),
      lastSynced: serializer.fromJson<DateTime>(json['lastSynced']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'name': serializer.toJson<String>(name),
      'version': serializer.toJson<String>(version),
      'description': serializer.toJson<String>(description),
      'machineIds': serializer.toJson<String>(machineIds),
      'category': serializer.toJson<String>(category),
      'filePath': serializer.toJson<String>(filePath),
      'downloadURL': serializer.toJson<String?>(downloadURL),
      'uploadDate': serializer.toJson<DateTime>(uploadDate),
      'fileSizeKB': serializer.toJson<int>(fileSizeKB),
      'isDownloaded': serializer.toJson<bool>(isDownloaded),
      'tags': serializer.toJson<String>(tags),
      'uploadedBy': serializer.toJson<String?>(uploadedBy),
      'sha256FileHash': serializer.toJson<String?>(sha256FileHash),
      'changelogNotes': serializer.toJson<String>(changelogNotes),
      'previousVersion': serializer.toJson<String?>(previousVersion),
      'password': serializer.toJson<String?>(password),
      'concession': serializer.toJson<String>(concession),
      'downloadCount': serializer.toJson<int>(downloadCount),
      'minVersion': serializer.toJson<String?>(minVersion),
      'lastSynced': serializer.toJson<DateTime>(lastSynced),
    };
  }

  Software copyWith(
          {String? id,
          String? name,
          String? version,
          String? description,
          String? machineIds,
          String? category,
          String? filePath,
          Value<String?> downloadURL = const Value.absent(),
          DateTime? uploadDate,
          int? fileSizeKB,
          bool? isDownloaded,
          String? tags,
          Value<String?> uploadedBy = const Value.absent(),
          Value<String?> sha256FileHash = const Value.absent(),
          String? changelogNotes,
          Value<String?> previousVersion = const Value.absent(),
          Value<String?> password = const Value.absent(),
          String? concession,
          int? downloadCount,
          Value<String?> minVersion = const Value.absent(),
          DateTime? lastSynced}) =>
      Software(
        id: id ?? this.id,
        name: name ?? this.name,
        version: version ?? this.version,
        description: description ?? this.description,
        machineIds: machineIds ?? this.machineIds,
        category: category ?? this.category,
        filePath: filePath ?? this.filePath,
        downloadURL: downloadURL.present ? downloadURL.value : this.downloadURL,
        uploadDate: uploadDate ?? this.uploadDate,
        fileSizeKB: fileSizeKB ?? this.fileSizeKB,
        isDownloaded: isDownloaded ?? this.isDownloaded,
        tags: tags ?? this.tags,
        uploadedBy: uploadedBy.present ? uploadedBy.value : this.uploadedBy,
        sha256FileHash:
            sha256FileHash.present ? sha256FileHash.value : this.sha256FileHash,
        changelogNotes: changelogNotes ?? this.changelogNotes,
        previousVersion: previousVersion.present
            ? previousVersion.value
            : this.previousVersion,
        password: password.present ? password.value : this.password,
        concession: concession ?? this.concession,
        downloadCount: downloadCount ?? this.downloadCount,
        minVersion: minVersion.present ? minVersion.value : this.minVersion,
        lastSynced: lastSynced ?? this.lastSynced,
      );
  Software copyWithCompanion(SoftwaresCompanion data) {
    return Software(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      version: data.version.present ? data.version.value : this.version,
      description:
          data.description.present ? data.description.value : this.description,
      machineIds:
          data.machineIds.present ? data.machineIds.value : this.machineIds,
      category: data.category.present ? data.category.value : this.category,
      filePath: data.filePath.present ? data.filePath.value : this.filePath,
      downloadURL:
          data.downloadURL.present ? data.downloadURL.value : this.downloadURL,
      uploadDate:
          data.uploadDate.present ? data.uploadDate.value : this.uploadDate,
      fileSizeKB:
          data.fileSizeKB.present ? data.fileSizeKB.value : this.fileSizeKB,
      isDownloaded: data.isDownloaded.present
          ? data.isDownloaded.value
          : this.isDownloaded,
      tags: data.tags.present ? data.tags.value : this.tags,
      uploadedBy:
          data.uploadedBy.present ? data.uploadedBy.value : this.uploadedBy,
      sha256FileHash: data.sha256FileHash.present
          ? data.sha256FileHash.value
          : this.sha256FileHash,
      changelogNotes: data.changelogNotes.present
          ? data.changelogNotes.value
          : this.changelogNotes,
      previousVersion: data.previousVersion.present
          ? data.previousVersion.value
          : this.previousVersion,
      password: data.password.present ? data.password.value : this.password,
      concession:
          data.concession.present ? data.concession.value : this.concession,
      downloadCount: data.downloadCount.present
          ? data.downloadCount.value
          : this.downloadCount,
      minVersion:
          data.minVersion.present ? data.minVersion.value : this.minVersion,
      lastSynced:
          data.lastSynced.present ? data.lastSynced.value : this.lastSynced,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Software(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('version: $version, ')
          ..write('description: $description, ')
          ..write('machineIds: $machineIds, ')
          ..write('category: $category, ')
          ..write('filePath: $filePath, ')
          ..write('downloadURL: $downloadURL, ')
          ..write('uploadDate: $uploadDate, ')
          ..write('fileSizeKB: $fileSizeKB, ')
          ..write('isDownloaded: $isDownloaded, ')
          ..write('tags: $tags, ')
          ..write('uploadedBy: $uploadedBy, ')
          ..write('sha256FileHash: $sha256FileHash, ')
          ..write('changelogNotes: $changelogNotes, ')
          ..write('previousVersion: $previousVersion, ')
          ..write('password: $password, ')
          ..write('concession: $concession, ')
          ..write('downloadCount: $downloadCount, ')
          ..write('minVersion: $minVersion, ')
          ..write('lastSynced: $lastSynced')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hashAll([
        id,
        name,
        version,
        description,
        machineIds,
        category,
        filePath,
        downloadURL,
        uploadDate,
        fileSizeKB,
        isDownloaded,
        tags,
        uploadedBy,
        sha256FileHash,
        changelogNotes,
        previousVersion,
        password,
        concession,
        downloadCount,
        minVersion,
        lastSynced
      ]);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Software &&
          other.id == this.id &&
          other.name == this.name &&
          other.version == this.version &&
          other.description == this.description &&
          other.machineIds == this.machineIds &&
          other.category == this.category &&
          other.filePath == this.filePath &&
          other.downloadURL == this.downloadURL &&
          other.uploadDate == this.uploadDate &&
          other.fileSizeKB == this.fileSizeKB &&
          other.isDownloaded == this.isDownloaded &&
          other.tags == this.tags &&
          other.uploadedBy == this.uploadedBy &&
          other.sha256FileHash == this.sha256FileHash &&
          other.changelogNotes == this.changelogNotes &&
          other.previousVersion == this.previousVersion &&
          other.password == this.password &&
          other.concession == this.concession &&
          other.downloadCount == this.downloadCount &&
          other.minVersion == this.minVersion &&
          other.lastSynced == this.lastSynced);
}

class SoftwaresCompanion extends UpdateCompanion<Software> {
  final Value<String> id;
  final Value<String> name;
  final Value<String> version;
  final Value<String> description;
  final Value<String> machineIds;
  final Value<String> category;
  final Value<String> filePath;
  final Value<String?> downloadURL;
  final Value<DateTime> uploadDate;
  final Value<int> fileSizeKB;
  final Value<bool> isDownloaded;
  final Value<String> tags;
  final Value<String?> uploadedBy;
  final Value<String?> sha256FileHash;
  final Value<String> changelogNotes;
  final Value<String?> previousVersion;
  final Value<String?> password;
  final Value<String> concession;
  final Value<int> downloadCount;
  final Value<String?> minVersion;
  final Value<DateTime> lastSynced;
  final Value<int> rowid;
  const SoftwaresCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.version = const Value.absent(),
    this.description = const Value.absent(),
    this.machineIds = const Value.absent(),
    this.category = const Value.absent(),
    this.filePath = const Value.absent(),
    this.downloadURL = const Value.absent(),
    this.uploadDate = const Value.absent(),
    this.fileSizeKB = const Value.absent(),
    this.isDownloaded = const Value.absent(),
    this.tags = const Value.absent(),
    this.uploadedBy = const Value.absent(),
    this.sha256FileHash = const Value.absent(),
    this.changelogNotes = const Value.absent(),
    this.previousVersion = const Value.absent(),
    this.password = const Value.absent(),
    this.concession = const Value.absent(),
    this.downloadCount = const Value.absent(),
    this.minVersion = const Value.absent(),
    this.lastSynced = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  SoftwaresCompanion.insert({
    required String id,
    required String name,
    required String version,
    required String description,
    required String machineIds,
    required String category,
    required String filePath,
    this.downloadURL = const Value.absent(),
    required DateTime uploadDate,
    required int fileSizeKB,
    this.isDownloaded = const Value.absent(),
    required String tags,
    this.uploadedBy = const Value.absent(),
    this.sha256FileHash = const Value.absent(),
    required String changelogNotes,
    this.previousVersion = const Value.absent(),
    this.password = const Value.absent(),
    required String concession,
    this.downloadCount = const Value.absent(),
    this.minVersion = const Value.absent(),
    this.lastSynced = const Value.absent(),
    this.rowid = const Value.absent(),
  })  : id = Value(id),
        name = Value(name),
        version = Value(version),
        description = Value(description),
        machineIds = Value(machineIds),
        category = Value(category),
        filePath = Value(filePath),
        uploadDate = Value(uploadDate),
        fileSizeKB = Value(fileSizeKB),
        tags = Value(tags),
        changelogNotes = Value(changelogNotes),
        concession = Value(concession);
  static Insertable<Software> custom({
    Expression<String>? id,
    Expression<String>? name,
    Expression<String>? version,
    Expression<String>? description,
    Expression<String>? machineIds,
    Expression<String>? category,
    Expression<String>? filePath,
    Expression<String>? downloadURL,
    Expression<DateTime>? uploadDate,
    Expression<int>? fileSizeKB,
    Expression<bool>? isDownloaded,
    Expression<String>? tags,
    Expression<String>? uploadedBy,
    Expression<String>? sha256FileHash,
    Expression<String>? changelogNotes,
    Expression<String>? previousVersion,
    Expression<String>? password,
    Expression<String>? concession,
    Expression<int>? downloadCount,
    Expression<String>? minVersion,
    Expression<DateTime>? lastSynced,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (version != null) 'version': version,
      if (description != null) 'description': description,
      if (machineIds != null) 'machine_ids': machineIds,
      if (category != null) 'category': category,
      if (filePath != null) 'file_path': filePath,
      if (downloadURL != null) 'download_u_r_l': downloadURL,
      if (uploadDate != null) 'upload_date': uploadDate,
      if (fileSizeKB != null) 'file_size_k_b': fileSizeKB,
      if (isDownloaded != null) 'is_downloaded': isDownloaded,
      if (tags != null) 'tags': tags,
      if (uploadedBy != null) 'uploaded_by': uploadedBy,
      if (sha256FileHash != null) 'sha256_file_hash': sha256FileHash,
      if (changelogNotes != null) 'changelog_notes': changelogNotes,
      if (previousVersion != null) 'previous_version': previousVersion,
      if (password != null) 'password': password,
      if (concession != null) 'concession': concession,
      if (downloadCount != null) 'download_count': downloadCount,
      if (minVersion != null) 'min_version': minVersion,
      if (lastSynced != null) 'last_synced': lastSynced,
      if (rowid != null) 'rowid': rowid,
    });
  }

  SoftwaresCompanion copyWith(
      {Value<String>? id,
      Value<String>? name,
      Value<String>? version,
      Value<String>? description,
      Value<String>? machineIds,
      Value<String>? category,
      Value<String>? filePath,
      Value<String?>? downloadURL,
      Value<DateTime>? uploadDate,
      Value<int>? fileSizeKB,
      Value<bool>? isDownloaded,
      Value<String>? tags,
      Value<String?>? uploadedBy,
      Value<String?>? sha256FileHash,
      Value<String>? changelogNotes,
      Value<String?>? previousVersion,
      Value<String?>? password,
      Value<String>? concession,
      Value<int>? downloadCount,
      Value<String?>? minVersion,
      Value<DateTime>? lastSynced,
      Value<int>? rowid}) {
    return SoftwaresCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      version: version ?? this.version,
      description: description ?? this.description,
      machineIds: machineIds ?? this.machineIds,
      category: category ?? this.category,
      filePath: filePath ?? this.filePath,
      downloadURL: downloadURL ?? this.downloadURL,
      uploadDate: uploadDate ?? this.uploadDate,
      fileSizeKB: fileSizeKB ?? this.fileSizeKB,
      isDownloaded: isDownloaded ?? this.isDownloaded,
      tags: tags ?? this.tags,
      uploadedBy: uploadedBy ?? this.uploadedBy,
      sha256FileHash: sha256FileHash ?? this.sha256FileHash,
      changelogNotes: changelogNotes ?? this.changelogNotes,
      previousVersion: previousVersion ?? this.previousVersion,
      password: password ?? this.password,
      concession: concession ?? this.concession,
      downloadCount: downloadCount ?? this.downloadCount,
      minVersion: minVersion ?? this.minVersion,
      lastSynced: lastSynced ?? this.lastSynced,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (version.present) {
      map['version'] = Variable<String>(version.value);
    }
    if (description.present) {
      map['description'] = Variable<String>(description.value);
    }
    if (machineIds.present) {
      map['machine_ids'] = Variable<String>(machineIds.value);
    }
    if (category.present) {
      map['category'] = Variable<String>(category.value);
    }
    if (filePath.present) {
      map['file_path'] = Variable<String>(filePath.value);
    }
    if (downloadURL.present) {
      map['download_u_r_l'] = Variable<String>(downloadURL.value);
    }
    if (uploadDate.present) {
      map['upload_date'] = Variable<DateTime>(uploadDate.value);
    }
    if (fileSizeKB.present) {
      map['file_size_k_b'] = Variable<int>(fileSizeKB.value);
    }
    if (isDownloaded.present) {
      map['is_downloaded'] = Variable<bool>(isDownloaded.value);
    }
    if (tags.present) {
      map['tags'] = Variable<String>(tags.value);
    }
    if (uploadedBy.present) {
      map['uploaded_by'] = Variable<String>(uploadedBy.value);
    }
    if (sha256FileHash.present) {
      map['sha256_file_hash'] = Variable<String>(sha256FileHash.value);
    }
    if (changelogNotes.present) {
      map['changelog_notes'] = Variable<String>(changelogNotes.value);
    }
    if (previousVersion.present) {
      map['previous_version'] = Variable<String>(previousVersion.value);
    }
    if (password.present) {
      map['password'] = Variable<String>(password.value);
    }
    if (concession.present) {
      map['concession'] = Variable<String>(concession.value);
    }
    if (downloadCount.present) {
      map['download_count'] = Variable<int>(downloadCount.value);
    }
    if (minVersion.present) {
      map['min_version'] = Variable<String>(minVersion.value);
    }
    if (lastSynced.present) {
      map['last_synced'] = Variable<DateTime>(lastSynced.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('SoftwaresCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('version: $version, ')
          ..write('description: $description, ')
          ..write('machineIds: $machineIds, ')
          ..write('category: $category, ')
          ..write('filePath: $filePath, ')
          ..write('downloadURL: $downloadURL, ')
          ..write('uploadDate: $uploadDate, ')
          ..write('fileSizeKB: $fileSizeKB, ')
          ..write('isDownloaded: $isDownloaded, ')
          ..write('tags: $tags, ')
          ..write('uploadedBy: $uploadedBy, ')
          ..write('sha256FileHash: $sha256FileHash, ')
          ..write('changelogNotes: $changelogNotes, ')
          ..write('previousVersion: $previousVersion, ')
          ..write('password: $password, ')
          ..write('concession: $concession, ')
          ..write('downloadCount: $downloadCount, ')
          ..write('minVersion: $minVersion, ')
          ..write('lastSynced: $lastSynced, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $MachineEntriesTable extends MachineEntries
    with TableInfo<$MachineEntriesTable, MachineEntry> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $MachineEntriesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'machine_id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _manufacturerMeta =
      const VerificationMeta('manufacturer');
  @override
  late final GeneratedColumn<String> manufacturer = GeneratedColumn<String>(
      'manufacturer', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _modelMeta = const VerificationMeta('model');
  @override
  late final GeneratedColumn<String> model = GeneratedColumn<String>(
      'model', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _imagePathMeta =
      const VerificationMeta('imagePath');
  @override
  late final GeneratedColumn<String> imagePath = GeneratedColumn<String>(
      'image_path', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _descriptionMeta =
      const VerificationMeta('description');
  @override
  late final GeneratedColumn<String> description = GeneratedColumn<String>(
      'description', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _documentPathMeta =
      const VerificationMeta('documentPath');
  @override
  late final GeneratedColumn<String> documentPath = GeneratedColumn<String>(
      'document_path', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _displayInAppMeta =
      const VerificationMeta('displayInApp');
  @override
  late final GeneratedColumn<bool> displayInApp = GeneratedColumn<bool>(
      'display_in_app', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints: GeneratedColumn.constraintIsAlways(
          'CHECK ("display_in_app" IN (0, 1))'),
      defaultValue: const Constant(true));
  static const VerificationMeta _lastSyncedMeta =
      const VerificationMeta('lastSynced');
  @override
  late final GeneratedColumn<DateTime> lastSynced = GeneratedColumn<DateTime>(
      'last_synced', aliasedName, false,
      type: DriftSqlType.dateTime,
      requiredDuringInsert: false,
      defaultValue: currentDateAndTime);
  @override
  List<GeneratedColumn> get $columns => [
        id,
        manufacturer,
        model,
        imagePath,
        description,
        documentPath,
        displayInApp,
        lastSynced
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'machines';
  @override
  VerificationContext validateIntegrity(Insertable<MachineEntry> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('machine_id')) {
      context.handle(
          _idMeta, id.isAcceptableOrUnknown(data['machine_id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('manufacturer')) {
      context.handle(
          _manufacturerMeta,
          manufacturer.isAcceptableOrUnknown(
              data['manufacturer']!, _manufacturerMeta));
    } else if (isInserting) {
      context.missing(_manufacturerMeta);
    }
    if (data.containsKey('model')) {
      context.handle(
          _modelMeta, model.isAcceptableOrUnknown(data['model']!, _modelMeta));
    } else if (isInserting) {
      context.missing(_modelMeta);
    }
    if (data.containsKey('image_path')) {
      context.handle(_imagePathMeta,
          imagePath.isAcceptableOrUnknown(data['image_path']!, _imagePathMeta));
    }
    if (data.containsKey('description')) {
      context.handle(
          _descriptionMeta,
          description.isAcceptableOrUnknown(
              data['description']!, _descriptionMeta));
    }
    if (data.containsKey('document_path')) {
      context.handle(
          _documentPathMeta,
          documentPath.isAcceptableOrUnknown(
              data['document_path']!, _documentPathMeta));
    }
    if (data.containsKey('display_in_app')) {
      context.handle(
          _displayInAppMeta,
          displayInApp.isAcceptableOrUnknown(
              data['display_in_app']!, _displayInAppMeta));
    }
    if (data.containsKey('last_synced')) {
      context.handle(
          _lastSyncedMeta,
          lastSynced.isAcceptableOrUnknown(
              data['last_synced']!, _lastSyncedMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  MachineEntry map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return MachineEntry(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}machine_id'])!,
      manufacturer: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}manufacturer'])!,
      model: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}model'])!,
      imagePath: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}image_path']),
      description: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}description']),
      documentPath: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}document_path']),
      displayInApp: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}display_in_app'])!,
      lastSynced: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}last_synced'])!,
    );
  }

  @override
  $MachineEntriesTable createAlias(String alias) {
    return $MachineEntriesTable(attachedDatabase, alias);
  }
}

class MachineEntry extends DataClass implements Insertable<MachineEntry> {
  final String id;
  final String manufacturer;
  final String model;
  final String? imagePath;
  final String? description;
  final String? documentPath;
  final bool displayInApp;
  final DateTime lastSynced;
  const MachineEntry(
      {required this.id,
      required this.manufacturer,
      required this.model,
      this.imagePath,
      this.description,
      this.documentPath,
      required this.displayInApp,
      required this.lastSynced});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['machine_id'] = Variable<String>(id);
    map['manufacturer'] = Variable<String>(manufacturer);
    map['model'] = Variable<String>(model);
    if (!nullToAbsent || imagePath != null) {
      map['image_path'] = Variable<String>(imagePath);
    }
    if (!nullToAbsent || description != null) {
      map['description'] = Variable<String>(description);
    }
    if (!nullToAbsent || documentPath != null) {
      map['document_path'] = Variable<String>(documentPath);
    }
    map['display_in_app'] = Variable<bool>(displayInApp);
    map['last_synced'] = Variable<DateTime>(lastSynced);
    return map;
  }

  MachineEntriesCompanion toCompanion(bool nullToAbsent) {
    return MachineEntriesCompanion(
      id: Value(id),
      manufacturer: Value(manufacturer),
      model: Value(model),
      imagePath: imagePath == null && nullToAbsent
          ? const Value.absent()
          : Value(imagePath),
      description: description == null && nullToAbsent
          ? const Value.absent()
          : Value(description),
      documentPath: documentPath == null && nullToAbsent
          ? const Value.absent()
          : Value(documentPath),
      displayInApp: Value(displayInApp),
      lastSynced: Value(lastSynced),
    );
  }

  factory MachineEntry.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return MachineEntry(
      id: serializer.fromJson<String>(json['id']),
      manufacturer: serializer.fromJson<String>(json['manufacturer']),
      model: serializer.fromJson<String>(json['model']),
      imagePath: serializer.fromJson<String?>(json['imagePath']),
      description: serializer.fromJson<String?>(json['description']),
      documentPath: serializer.fromJson<String?>(json['documentPath']),
      displayInApp: serializer.fromJson<bool>(json['displayInApp']),
      lastSynced: serializer.fromJson<DateTime>(json['lastSynced']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'manufacturer': serializer.toJson<String>(manufacturer),
      'model': serializer.toJson<String>(model),
      'imagePath': serializer.toJson<String?>(imagePath),
      'description': serializer.toJson<String?>(description),
      'documentPath': serializer.toJson<String?>(documentPath),
      'displayInApp': serializer.toJson<bool>(displayInApp),
      'lastSynced': serializer.toJson<DateTime>(lastSynced),
    };
  }

  MachineEntry copyWith(
          {String? id,
          String? manufacturer,
          String? model,
          Value<String?> imagePath = const Value.absent(),
          Value<String?> description = const Value.absent(),
          Value<String?> documentPath = const Value.absent(),
          bool? displayInApp,
          DateTime? lastSynced}) =>
      MachineEntry(
        id: id ?? this.id,
        manufacturer: manufacturer ?? this.manufacturer,
        model: model ?? this.model,
        imagePath: imagePath.present ? imagePath.value : this.imagePath,
        description: description.present ? description.value : this.description,
        documentPath:
            documentPath.present ? documentPath.value : this.documentPath,
        displayInApp: displayInApp ?? this.displayInApp,
        lastSynced: lastSynced ?? this.lastSynced,
      );
  MachineEntry copyWithCompanion(MachineEntriesCompanion data) {
    return MachineEntry(
      id: data.id.present ? data.id.value : this.id,
      manufacturer: data.manufacturer.present
          ? data.manufacturer.value
          : this.manufacturer,
      model: data.model.present ? data.model.value : this.model,
      imagePath: data.imagePath.present ? data.imagePath.value : this.imagePath,
      description:
          data.description.present ? data.description.value : this.description,
      documentPath: data.documentPath.present
          ? data.documentPath.value
          : this.documentPath,
      displayInApp: data.displayInApp.present
          ? data.displayInApp.value
          : this.displayInApp,
      lastSynced:
          data.lastSynced.present ? data.lastSynced.value : this.lastSynced,
    );
  }

  @override
  String toString() {
    return (StringBuffer('MachineEntry(')
          ..write('id: $id, ')
          ..write('manufacturer: $manufacturer, ')
          ..write('model: $model, ')
          ..write('imagePath: $imagePath, ')
          ..write('description: $description, ')
          ..write('documentPath: $documentPath, ')
          ..write('displayInApp: $displayInApp, ')
          ..write('lastSynced: $lastSynced')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, manufacturer, model, imagePath,
      description, documentPath, displayInApp, lastSynced);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is MachineEntry &&
          other.id == this.id &&
          other.manufacturer == this.manufacturer &&
          other.model == this.model &&
          other.imagePath == this.imagePath &&
          other.description == this.description &&
          other.documentPath == this.documentPath &&
          other.displayInApp == this.displayInApp &&
          other.lastSynced == this.lastSynced);
}

class MachineEntriesCompanion extends UpdateCompanion<MachineEntry> {
  final Value<String> id;
  final Value<String> manufacturer;
  final Value<String> model;
  final Value<String?> imagePath;
  final Value<String?> description;
  final Value<String?> documentPath;
  final Value<bool> displayInApp;
  final Value<DateTime> lastSynced;
  final Value<int> rowid;
  const MachineEntriesCompanion({
    this.id = const Value.absent(),
    this.manufacturer = const Value.absent(),
    this.model = const Value.absent(),
    this.imagePath = const Value.absent(),
    this.description = const Value.absent(),
    this.documentPath = const Value.absent(),
    this.displayInApp = const Value.absent(),
    this.lastSynced = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  MachineEntriesCompanion.insert({
    required String id,
    required String manufacturer,
    required String model,
    this.imagePath = const Value.absent(),
    this.description = const Value.absent(),
    this.documentPath = const Value.absent(),
    this.displayInApp = const Value.absent(),
    this.lastSynced = const Value.absent(),
    this.rowid = const Value.absent(),
  })  : id = Value(id),
        manufacturer = Value(manufacturer),
        model = Value(model);
  static Insertable<MachineEntry> custom({
    Expression<String>? id,
    Expression<String>? manufacturer,
    Expression<String>? model,
    Expression<String>? imagePath,
    Expression<String>? description,
    Expression<String>? documentPath,
    Expression<bool>? displayInApp,
    Expression<DateTime>? lastSynced,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'machine_id': id,
      if (manufacturer != null) 'manufacturer': manufacturer,
      if (model != null) 'model': model,
      if (imagePath != null) 'image_path': imagePath,
      if (description != null) 'description': description,
      if (documentPath != null) 'document_path': documentPath,
      if (displayInApp != null) 'display_in_app': displayInApp,
      if (lastSynced != null) 'last_synced': lastSynced,
      if (rowid != null) 'rowid': rowid,
    });
  }

  MachineEntriesCompanion copyWith(
      {Value<String>? id,
      Value<String>? manufacturer,
      Value<String>? model,
      Value<String?>? imagePath,
      Value<String?>? description,
      Value<String?>? documentPath,
      Value<bool>? displayInApp,
      Value<DateTime>? lastSynced,
      Value<int>? rowid}) {
    return MachineEntriesCompanion(
      id: id ?? this.id,
      manufacturer: manufacturer ?? this.manufacturer,
      model: model ?? this.model,
      imagePath: imagePath ?? this.imagePath,
      description: description ?? this.description,
      documentPath: documentPath ?? this.documentPath,
      displayInApp: displayInApp ?? this.displayInApp,
      lastSynced: lastSynced ?? this.lastSynced,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['machine_id'] = Variable<String>(id.value);
    }
    if (manufacturer.present) {
      map['manufacturer'] = Variable<String>(manufacturer.value);
    }
    if (model.present) {
      map['model'] = Variable<String>(model.value);
    }
    if (imagePath.present) {
      map['image_path'] = Variable<String>(imagePath.value);
    }
    if (description.present) {
      map['description'] = Variable<String>(description.value);
    }
    if (documentPath.present) {
      map['document_path'] = Variable<String>(documentPath.value);
    }
    if (displayInApp.present) {
      map['display_in_app'] = Variable<bool>(displayInApp.value);
    }
    if (lastSynced.present) {
      map['last_synced'] = Variable<DateTime>(lastSynced.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('MachineEntriesCompanion(')
          ..write('id: $id, ')
          ..write('manufacturer: $manufacturer, ')
          ..write('model: $model, ')
          ..write('imagePath: $imagePath, ')
          ..write('description: $description, ')
          ..write('documentPath: $documentPath, ')
          ..write('displayInApp: $displayInApp, ')
          ..write('lastSynced: $lastSynced, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $SyncMetadataTableTable extends SyncMetadataTable
    with TableInfo<$SyncMetadataTableTable, SyncMetadataTableData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $SyncMetadataTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _tableNameColumnMeta =
      const VerificationMeta('tableNameColumn');
  @override
  late final GeneratedColumn<String> tableNameColumn = GeneratedColumn<String>(
      'table_name', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _lastSyncTimestampMeta =
      const VerificationMeta('lastSyncTimestamp');
  @override
  late final GeneratedColumn<DateTime> lastSyncTimestamp =
      GeneratedColumn<DateTime>('last_sync_timestamp', aliasedName, false,
          type: DriftSqlType.dateTime, requiredDuringInsert: true);
  static const VerificationMeta _recordCountMeta =
      const VerificationMeta('recordCount');
  @override
  late final GeneratedColumn<int> recordCount = GeneratedColumn<int>(
      'record_count', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns =>
      [tableNameColumn, lastSyncTimestamp, recordCount];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'sync_metadata';
  @override
  VerificationContext validateIntegrity(
      Insertable<SyncMetadataTableData> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('table_name')) {
      context.handle(
          _tableNameColumnMeta,
          tableNameColumn.isAcceptableOrUnknown(
              data['table_name']!, _tableNameColumnMeta));
    } else if (isInserting) {
      context.missing(_tableNameColumnMeta);
    }
    if (data.containsKey('last_sync_timestamp')) {
      context.handle(
          _lastSyncTimestampMeta,
          lastSyncTimestamp.isAcceptableOrUnknown(
              data['last_sync_timestamp']!, _lastSyncTimestampMeta));
    } else if (isInserting) {
      context.missing(_lastSyncTimestampMeta);
    }
    if (data.containsKey('record_count')) {
      context.handle(
          _recordCountMeta,
          recordCount.isAcceptableOrUnknown(
              data['record_count']!, _recordCountMeta));
    } else if (isInserting) {
      context.missing(_recordCountMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {tableNameColumn};
  @override
  SyncMetadataTableData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return SyncMetadataTableData(
      tableNameColumn: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}table_name'])!,
      lastSyncTimestamp: attachedDatabase.typeMapping.read(
          DriftSqlType.dateTime,
          data['${effectivePrefix}last_sync_timestamp'])!,
      recordCount: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}record_count'])!,
    );
  }

  @override
  $SyncMetadataTableTable createAlias(String alias) {
    return $SyncMetadataTableTable(attachedDatabase, alias);
  }
}

class SyncMetadataTableData extends DataClass
    implements Insertable<SyncMetadataTableData> {
  final String tableNameColumn;
  final DateTime lastSyncTimestamp;
  final int recordCount;
  const SyncMetadataTableData(
      {required this.tableNameColumn,
      required this.lastSyncTimestamp,
      required this.recordCount});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['table_name'] = Variable<String>(tableNameColumn);
    map['last_sync_timestamp'] = Variable<DateTime>(lastSyncTimestamp);
    map['record_count'] = Variable<int>(recordCount);
    return map;
  }

  SyncMetadataTableCompanion toCompanion(bool nullToAbsent) {
    return SyncMetadataTableCompanion(
      tableNameColumn: Value(tableNameColumn),
      lastSyncTimestamp: Value(lastSyncTimestamp),
      recordCount: Value(recordCount),
    );
  }

  factory SyncMetadataTableData.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return SyncMetadataTableData(
      tableNameColumn: serializer.fromJson<String>(json['tableNameColumn']),
      lastSyncTimestamp:
          serializer.fromJson<DateTime>(json['lastSyncTimestamp']),
      recordCount: serializer.fromJson<int>(json['recordCount']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'tableNameColumn': serializer.toJson<String>(tableNameColumn),
      'lastSyncTimestamp': serializer.toJson<DateTime>(lastSyncTimestamp),
      'recordCount': serializer.toJson<int>(recordCount),
    };
  }

  SyncMetadataTableData copyWith(
          {String? tableNameColumn,
          DateTime? lastSyncTimestamp,
          int? recordCount}) =>
      SyncMetadataTableData(
        tableNameColumn: tableNameColumn ?? this.tableNameColumn,
        lastSyncTimestamp: lastSyncTimestamp ?? this.lastSyncTimestamp,
        recordCount: recordCount ?? this.recordCount,
      );
  SyncMetadataTableData copyWithCompanion(SyncMetadataTableCompanion data) {
    return SyncMetadataTableData(
      tableNameColumn: data.tableNameColumn.present
          ? data.tableNameColumn.value
          : this.tableNameColumn,
      lastSyncTimestamp: data.lastSyncTimestamp.present
          ? data.lastSyncTimestamp.value
          : this.lastSyncTimestamp,
      recordCount:
          data.recordCount.present ? data.recordCount.value : this.recordCount,
    );
  }

  @override
  String toString() {
    return (StringBuffer('SyncMetadataTableData(')
          ..write('tableNameColumn: $tableNameColumn, ')
          ..write('lastSyncTimestamp: $lastSyncTimestamp, ')
          ..write('recordCount: $recordCount')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(tableNameColumn, lastSyncTimestamp, recordCount);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is SyncMetadataTableData &&
          other.tableNameColumn == this.tableNameColumn &&
          other.lastSyncTimestamp == this.lastSyncTimestamp &&
          other.recordCount == this.recordCount);
}

class SyncMetadataTableCompanion
    extends UpdateCompanion<SyncMetadataTableData> {
  final Value<String> tableNameColumn;
  final Value<DateTime> lastSyncTimestamp;
  final Value<int> recordCount;
  final Value<int> rowid;
  const SyncMetadataTableCompanion({
    this.tableNameColumn = const Value.absent(),
    this.lastSyncTimestamp = const Value.absent(),
    this.recordCount = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  SyncMetadataTableCompanion.insert({
    required String tableNameColumn,
    required DateTime lastSyncTimestamp,
    required int recordCount,
    this.rowid = const Value.absent(),
  })  : tableNameColumn = Value(tableNameColumn),
        lastSyncTimestamp = Value(lastSyncTimestamp),
        recordCount = Value(recordCount);
  static Insertable<SyncMetadataTableData> custom({
    Expression<String>? tableNameColumn,
    Expression<DateTime>? lastSyncTimestamp,
    Expression<int>? recordCount,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (tableNameColumn != null) 'table_name': tableNameColumn,
      if (lastSyncTimestamp != null) 'last_sync_timestamp': lastSyncTimestamp,
      if (recordCount != null) 'record_count': recordCount,
      if (rowid != null) 'rowid': rowid,
    });
  }

  SyncMetadataTableCompanion copyWith(
      {Value<String>? tableNameColumn,
      Value<DateTime>? lastSyncTimestamp,
      Value<int>? recordCount,
      Value<int>? rowid}) {
    return SyncMetadataTableCompanion(
      tableNameColumn: tableNameColumn ?? this.tableNameColumn,
      lastSyncTimestamp: lastSyncTimestamp ?? this.lastSyncTimestamp,
      recordCount: recordCount ?? this.recordCount,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (tableNameColumn.present) {
      map['table_name'] = Variable<String>(tableNameColumn.value);
    }
    if (lastSyncTimestamp.present) {
      map['last_sync_timestamp'] = Variable<DateTime>(lastSyncTimestamp.value);
    }
    if (recordCount.present) {
      map['record_count'] = Variable<int>(recordCount.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('SyncMetadataTableCompanion(')
          ..write('tableNameColumn: $tableNameColumn, ')
          ..write('lastSyncTimestamp: $lastSyncTimestamp, ')
          ..write('recordCount: $recordCount, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $DocumentsTable documents = $DocumentsTable(this);
  late final $SoftwaresTable softwares = $SoftwaresTable(this);
  late final $MachineEntriesTable machineEntries = $MachineEntriesTable(this);
  late final $SyncMetadataTableTable syncMetadataTable =
      $SyncMetadataTableTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities =>
      [documents, softwares, machineEntries, syncMetadataTable];
}

typedef $$DocumentsTableCreateCompanionBuilder = DocumentsCompanion Function({
  required String id,
  required String title,
  required String description,
  required String machineIds,
  required String category,
  required String filePath,
  Value<String?> downloadURL,
  required DateTime uploadDate,
  required int fileSizeKB,
  Value<bool> isDownloaded,
  required String tags,
  Value<String?> uploadedBy,
  Value<String?> sha256FileHash,
  Value<DateTime> lastSynced,
  Value<int> rowid,
});
typedef $$DocumentsTableUpdateCompanionBuilder = DocumentsCompanion Function({
  Value<String> id,
  Value<String> title,
  Value<String> description,
  Value<String> machineIds,
  Value<String> category,
  Value<String> filePath,
  Value<String?> downloadURL,
  Value<DateTime> uploadDate,
  Value<int> fileSizeKB,
  Value<bool> isDownloaded,
  Value<String> tags,
  Value<String?> uploadedBy,
  Value<String?> sha256FileHash,
  Value<DateTime> lastSynced,
  Value<int> rowid,
});

class $$DocumentsTableFilterComposer
    extends Composer<_$AppDatabase, $DocumentsTable> {
  $$DocumentsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get title => $composableBuilder(
      column: $table.title, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get description => $composableBuilder(
      column: $table.description, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get machineIds => $composableBuilder(
      column: $table.machineIds, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get category => $composableBuilder(
      column: $table.category, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get filePath => $composableBuilder(
      column: $table.filePath, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get downloadURL => $composableBuilder(
      column: $table.downloadURL, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get uploadDate => $composableBuilder(
      column: $table.uploadDate, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get fileSizeKB => $composableBuilder(
      column: $table.fileSizeKB, builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get isDownloaded => $composableBuilder(
      column: $table.isDownloaded, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get tags => $composableBuilder(
      column: $table.tags, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get uploadedBy => $composableBuilder(
      column: $table.uploadedBy, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get sha256FileHash => $composableBuilder(
      column: $table.sha256FileHash,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get lastSynced => $composableBuilder(
      column: $table.lastSynced, builder: (column) => ColumnFilters(column));
}

class $$DocumentsTableOrderingComposer
    extends Composer<_$AppDatabase, $DocumentsTable> {
  $$DocumentsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get title => $composableBuilder(
      column: $table.title, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get description => $composableBuilder(
      column: $table.description, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get machineIds => $composableBuilder(
      column: $table.machineIds, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get category => $composableBuilder(
      column: $table.category, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get filePath => $composableBuilder(
      column: $table.filePath, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get downloadURL => $composableBuilder(
      column: $table.downloadURL, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get uploadDate => $composableBuilder(
      column: $table.uploadDate, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get fileSizeKB => $composableBuilder(
      column: $table.fileSizeKB, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get isDownloaded => $composableBuilder(
      column: $table.isDownloaded,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get tags => $composableBuilder(
      column: $table.tags, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get uploadedBy => $composableBuilder(
      column: $table.uploadedBy, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get sha256FileHash => $composableBuilder(
      column: $table.sha256FileHash,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get lastSynced => $composableBuilder(
      column: $table.lastSynced, builder: (column) => ColumnOrderings(column));
}

class $$DocumentsTableAnnotationComposer
    extends Composer<_$AppDatabase, $DocumentsTable> {
  $$DocumentsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get title =>
      $composableBuilder(column: $table.title, builder: (column) => column);

  GeneratedColumn<String> get description => $composableBuilder(
      column: $table.description, builder: (column) => column);

  GeneratedColumn<String> get machineIds => $composableBuilder(
      column: $table.machineIds, builder: (column) => column);

  GeneratedColumn<String> get category =>
      $composableBuilder(column: $table.category, builder: (column) => column);

  GeneratedColumn<String> get filePath =>
      $composableBuilder(column: $table.filePath, builder: (column) => column);

  GeneratedColumn<String> get downloadURL => $composableBuilder(
      column: $table.downloadURL, builder: (column) => column);

  GeneratedColumn<DateTime> get uploadDate => $composableBuilder(
      column: $table.uploadDate, builder: (column) => column);

  GeneratedColumn<int> get fileSizeKB => $composableBuilder(
      column: $table.fileSizeKB, builder: (column) => column);

  GeneratedColumn<bool> get isDownloaded => $composableBuilder(
      column: $table.isDownloaded, builder: (column) => column);

  GeneratedColumn<String> get tags =>
      $composableBuilder(column: $table.tags, builder: (column) => column);

  GeneratedColumn<String> get uploadedBy => $composableBuilder(
      column: $table.uploadedBy, builder: (column) => column);

  GeneratedColumn<String> get sha256FileHash => $composableBuilder(
      column: $table.sha256FileHash, builder: (column) => column);

  GeneratedColumn<DateTime> get lastSynced => $composableBuilder(
      column: $table.lastSynced, builder: (column) => column);
}

class $$DocumentsTableTableManager extends RootTableManager<
    _$AppDatabase,
    $DocumentsTable,
    Document,
    $$DocumentsTableFilterComposer,
    $$DocumentsTableOrderingComposer,
    $$DocumentsTableAnnotationComposer,
    $$DocumentsTableCreateCompanionBuilder,
    $$DocumentsTableUpdateCompanionBuilder,
    (Document, BaseReferences<_$AppDatabase, $DocumentsTable, Document>),
    Document,
    PrefetchHooks Function()> {
  $$DocumentsTableTableManager(_$AppDatabase db, $DocumentsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$DocumentsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$DocumentsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$DocumentsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> id = const Value.absent(),
            Value<String> title = const Value.absent(),
            Value<String> description = const Value.absent(),
            Value<String> machineIds = const Value.absent(),
            Value<String> category = const Value.absent(),
            Value<String> filePath = const Value.absent(),
            Value<String?> downloadURL = const Value.absent(),
            Value<DateTime> uploadDate = const Value.absent(),
            Value<int> fileSizeKB = const Value.absent(),
            Value<bool> isDownloaded = const Value.absent(),
            Value<String> tags = const Value.absent(),
            Value<String?> uploadedBy = const Value.absent(),
            Value<String?> sha256FileHash = const Value.absent(),
            Value<DateTime> lastSynced = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              DocumentsCompanion(
            id: id,
            title: title,
            description: description,
            machineIds: machineIds,
            category: category,
            filePath: filePath,
            downloadURL: downloadURL,
            uploadDate: uploadDate,
            fileSizeKB: fileSizeKB,
            isDownloaded: isDownloaded,
            tags: tags,
            uploadedBy: uploadedBy,
            sha256FileHash: sha256FileHash,
            lastSynced: lastSynced,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String id,
            required String title,
            required String description,
            required String machineIds,
            required String category,
            required String filePath,
            Value<String?> downloadURL = const Value.absent(),
            required DateTime uploadDate,
            required int fileSizeKB,
            Value<bool> isDownloaded = const Value.absent(),
            required String tags,
            Value<String?> uploadedBy = const Value.absent(),
            Value<String?> sha256FileHash = const Value.absent(),
            Value<DateTime> lastSynced = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              DocumentsCompanion.insert(
            id: id,
            title: title,
            description: description,
            machineIds: machineIds,
            category: category,
            filePath: filePath,
            downloadURL: downloadURL,
            uploadDate: uploadDate,
            fileSizeKB: fileSizeKB,
            isDownloaded: isDownloaded,
            tags: tags,
            uploadedBy: uploadedBy,
            sha256FileHash: sha256FileHash,
            lastSynced: lastSynced,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$DocumentsTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $DocumentsTable,
    Document,
    $$DocumentsTableFilterComposer,
    $$DocumentsTableOrderingComposer,
    $$DocumentsTableAnnotationComposer,
    $$DocumentsTableCreateCompanionBuilder,
    $$DocumentsTableUpdateCompanionBuilder,
    (Document, BaseReferences<_$AppDatabase, $DocumentsTable, Document>),
    Document,
    PrefetchHooks Function()>;
typedef $$SoftwaresTableCreateCompanionBuilder = SoftwaresCompanion Function({
  required String id,
  required String name,
  required String version,
  required String description,
  required String machineIds,
  required String category,
  required String filePath,
  Value<String?> downloadURL,
  required DateTime uploadDate,
  required int fileSizeKB,
  Value<bool> isDownloaded,
  required String tags,
  Value<String?> uploadedBy,
  Value<String?> sha256FileHash,
  required String changelogNotes,
  Value<String?> previousVersion,
  Value<String?> password,
  required String concession,
  Value<int> downloadCount,
  Value<String?> minVersion,
  Value<DateTime> lastSynced,
  Value<int> rowid,
});
typedef $$SoftwaresTableUpdateCompanionBuilder = SoftwaresCompanion Function({
  Value<String> id,
  Value<String> name,
  Value<String> version,
  Value<String> description,
  Value<String> machineIds,
  Value<String> category,
  Value<String> filePath,
  Value<String?> downloadURL,
  Value<DateTime> uploadDate,
  Value<int> fileSizeKB,
  Value<bool> isDownloaded,
  Value<String> tags,
  Value<String?> uploadedBy,
  Value<String?> sha256FileHash,
  Value<String> changelogNotes,
  Value<String?> previousVersion,
  Value<String?> password,
  Value<String> concession,
  Value<int> downloadCount,
  Value<String?> minVersion,
  Value<DateTime> lastSynced,
  Value<int> rowid,
});

class $$SoftwaresTableFilterComposer
    extends Composer<_$AppDatabase, $SoftwaresTable> {
  $$SoftwaresTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get name => $composableBuilder(
      column: $table.name, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get version => $composableBuilder(
      column: $table.version, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get description => $composableBuilder(
      column: $table.description, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get machineIds => $composableBuilder(
      column: $table.machineIds, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get category => $composableBuilder(
      column: $table.category, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get filePath => $composableBuilder(
      column: $table.filePath, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get downloadURL => $composableBuilder(
      column: $table.downloadURL, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get uploadDate => $composableBuilder(
      column: $table.uploadDate, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get fileSizeKB => $composableBuilder(
      column: $table.fileSizeKB, builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get isDownloaded => $composableBuilder(
      column: $table.isDownloaded, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get tags => $composableBuilder(
      column: $table.tags, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get uploadedBy => $composableBuilder(
      column: $table.uploadedBy, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get sha256FileHash => $composableBuilder(
      column: $table.sha256FileHash,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get changelogNotes => $composableBuilder(
      column: $table.changelogNotes,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get previousVersion => $composableBuilder(
      column: $table.previousVersion,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get password => $composableBuilder(
      column: $table.password, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get concession => $composableBuilder(
      column: $table.concession, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get downloadCount => $composableBuilder(
      column: $table.downloadCount, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get minVersion => $composableBuilder(
      column: $table.minVersion, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get lastSynced => $composableBuilder(
      column: $table.lastSynced, builder: (column) => ColumnFilters(column));
}

class $$SoftwaresTableOrderingComposer
    extends Composer<_$AppDatabase, $SoftwaresTable> {
  $$SoftwaresTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get name => $composableBuilder(
      column: $table.name, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get version => $composableBuilder(
      column: $table.version, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get description => $composableBuilder(
      column: $table.description, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get machineIds => $composableBuilder(
      column: $table.machineIds, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get category => $composableBuilder(
      column: $table.category, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get filePath => $composableBuilder(
      column: $table.filePath, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get downloadURL => $composableBuilder(
      column: $table.downloadURL, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get uploadDate => $composableBuilder(
      column: $table.uploadDate, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get fileSizeKB => $composableBuilder(
      column: $table.fileSizeKB, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get isDownloaded => $composableBuilder(
      column: $table.isDownloaded,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get tags => $composableBuilder(
      column: $table.tags, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get uploadedBy => $composableBuilder(
      column: $table.uploadedBy, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get sha256FileHash => $composableBuilder(
      column: $table.sha256FileHash,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get changelogNotes => $composableBuilder(
      column: $table.changelogNotes,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get previousVersion => $composableBuilder(
      column: $table.previousVersion,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get password => $composableBuilder(
      column: $table.password, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get concession => $composableBuilder(
      column: $table.concession, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get downloadCount => $composableBuilder(
      column: $table.downloadCount,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get minVersion => $composableBuilder(
      column: $table.minVersion, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get lastSynced => $composableBuilder(
      column: $table.lastSynced, builder: (column) => ColumnOrderings(column));
}

class $$SoftwaresTableAnnotationComposer
    extends Composer<_$AppDatabase, $SoftwaresTable> {
  $$SoftwaresTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get version =>
      $composableBuilder(column: $table.version, builder: (column) => column);

  GeneratedColumn<String> get description => $composableBuilder(
      column: $table.description, builder: (column) => column);

  GeneratedColumn<String> get machineIds => $composableBuilder(
      column: $table.machineIds, builder: (column) => column);

  GeneratedColumn<String> get category =>
      $composableBuilder(column: $table.category, builder: (column) => column);

  GeneratedColumn<String> get filePath =>
      $composableBuilder(column: $table.filePath, builder: (column) => column);

  GeneratedColumn<String> get downloadURL => $composableBuilder(
      column: $table.downloadURL, builder: (column) => column);

  GeneratedColumn<DateTime> get uploadDate => $composableBuilder(
      column: $table.uploadDate, builder: (column) => column);

  GeneratedColumn<int> get fileSizeKB => $composableBuilder(
      column: $table.fileSizeKB, builder: (column) => column);

  GeneratedColumn<bool> get isDownloaded => $composableBuilder(
      column: $table.isDownloaded, builder: (column) => column);

  GeneratedColumn<String> get tags =>
      $composableBuilder(column: $table.tags, builder: (column) => column);

  GeneratedColumn<String> get uploadedBy => $composableBuilder(
      column: $table.uploadedBy, builder: (column) => column);

  GeneratedColumn<String> get sha256FileHash => $composableBuilder(
      column: $table.sha256FileHash, builder: (column) => column);

  GeneratedColumn<String> get changelogNotes => $composableBuilder(
      column: $table.changelogNotes, builder: (column) => column);

  GeneratedColumn<String> get previousVersion => $composableBuilder(
      column: $table.previousVersion, builder: (column) => column);

  GeneratedColumn<String> get password =>
      $composableBuilder(column: $table.password, builder: (column) => column);

  GeneratedColumn<String> get concession => $composableBuilder(
      column: $table.concession, builder: (column) => column);

  GeneratedColumn<int> get downloadCount => $composableBuilder(
      column: $table.downloadCount, builder: (column) => column);

  GeneratedColumn<String> get minVersion => $composableBuilder(
      column: $table.minVersion, builder: (column) => column);

  GeneratedColumn<DateTime> get lastSynced => $composableBuilder(
      column: $table.lastSynced, builder: (column) => column);
}

class $$SoftwaresTableTableManager extends RootTableManager<
    _$AppDatabase,
    $SoftwaresTable,
    Software,
    $$SoftwaresTableFilterComposer,
    $$SoftwaresTableOrderingComposer,
    $$SoftwaresTableAnnotationComposer,
    $$SoftwaresTableCreateCompanionBuilder,
    $$SoftwaresTableUpdateCompanionBuilder,
    (Software, BaseReferences<_$AppDatabase, $SoftwaresTable, Software>),
    Software,
    PrefetchHooks Function()> {
  $$SoftwaresTableTableManager(_$AppDatabase db, $SoftwaresTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$SoftwaresTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$SoftwaresTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$SoftwaresTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> id = const Value.absent(),
            Value<String> name = const Value.absent(),
            Value<String> version = const Value.absent(),
            Value<String> description = const Value.absent(),
            Value<String> machineIds = const Value.absent(),
            Value<String> category = const Value.absent(),
            Value<String> filePath = const Value.absent(),
            Value<String?> downloadURL = const Value.absent(),
            Value<DateTime> uploadDate = const Value.absent(),
            Value<int> fileSizeKB = const Value.absent(),
            Value<bool> isDownloaded = const Value.absent(),
            Value<String> tags = const Value.absent(),
            Value<String?> uploadedBy = const Value.absent(),
            Value<String?> sha256FileHash = const Value.absent(),
            Value<String> changelogNotes = const Value.absent(),
            Value<String?> previousVersion = const Value.absent(),
            Value<String?> password = const Value.absent(),
            Value<String> concession = const Value.absent(),
            Value<int> downloadCount = const Value.absent(),
            Value<String?> minVersion = const Value.absent(),
            Value<DateTime> lastSynced = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              SoftwaresCompanion(
            id: id,
            name: name,
            version: version,
            description: description,
            machineIds: machineIds,
            category: category,
            filePath: filePath,
            downloadURL: downloadURL,
            uploadDate: uploadDate,
            fileSizeKB: fileSizeKB,
            isDownloaded: isDownloaded,
            tags: tags,
            uploadedBy: uploadedBy,
            sha256FileHash: sha256FileHash,
            changelogNotes: changelogNotes,
            previousVersion: previousVersion,
            password: password,
            concession: concession,
            downloadCount: downloadCount,
            minVersion: minVersion,
            lastSynced: lastSynced,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String id,
            required String name,
            required String version,
            required String description,
            required String machineIds,
            required String category,
            required String filePath,
            Value<String?> downloadURL = const Value.absent(),
            required DateTime uploadDate,
            required int fileSizeKB,
            Value<bool> isDownloaded = const Value.absent(),
            required String tags,
            Value<String?> uploadedBy = const Value.absent(),
            Value<String?> sha256FileHash = const Value.absent(),
            required String changelogNotes,
            Value<String?> previousVersion = const Value.absent(),
            Value<String?> password = const Value.absent(),
            required String concession,
            Value<int> downloadCount = const Value.absent(),
            Value<String?> minVersion = const Value.absent(),
            Value<DateTime> lastSynced = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              SoftwaresCompanion.insert(
            id: id,
            name: name,
            version: version,
            description: description,
            machineIds: machineIds,
            category: category,
            filePath: filePath,
            downloadURL: downloadURL,
            uploadDate: uploadDate,
            fileSizeKB: fileSizeKB,
            isDownloaded: isDownloaded,
            tags: tags,
            uploadedBy: uploadedBy,
            sha256FileHash: sha256FileHash,
            changelogNotes: changelogNotes,
            previousVersion: previousVersion,
            password: password,
            concession: concession,
            downloadCount: downloadCount,
            minVersion: minVersion,
            lastSynced: lastSynced,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$SoftwaresTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $SoftwaresTable,
    Software,
    $$SoftwaresTableFilterComposer,
    $$SoftwaresTableOrderingComposer,
    $$SoftwaresTableAnnotationComposer,
    $$SoftwaresTableCreateCompanionBuilder,
    $$SoftwaresTableUpdateCompanionBuilder,
    (Software, BaseReferences<_$AppDatabase, $SoftwaresTable, Software>),
    Software,
    PrefetchHooks Function()>;
typedef $$MachineEntriesTableCreateCompanionBuilder = MachineEntriesCompanion
    Function({
  required String id,
  required String manufacturer,
  required String model,
  Value<String?> imagePath,
  Value<String?> description,
  Value<String?> documentPath,
  Value<bool> displayInApp,
  Value<DateTime> lastSynced,
  Value<int> rowid,
});
typedef $$MachineEntriesTableUpdateCompanionBuilder = MachineEntriesCompanion
    Function({
  Value<String> id,
  Value<String> manufacturer,
  Value<String> model,
  Value<String?> imagePath,
  Value<String?> description,
  Value<String?> documentPath,
  Value<bool> displayInApp,
  Value<DateTime> lastSynced,
  Value<int> rowid,
});

class $$MachineEntriesTableFilterComposer
    extends Composer<_$AppDatabase, $MachineEntriesTable> {
  $$MachineEntriesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get manufacturer => $composableBuilder(
      column: $table.manufacturer, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get model => $composableBuilder(
      column: $table.model, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get imagePath => $composableBuilder(
      column: $table.imagePath, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get description => $composableBuilder(
      column: $table.description, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get documentPath => $composableBuilder(
      column: $table.documentPath, builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get displayInApp => $composableBuilder(
      column: $table.displayInApp, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get lastSynced => $composableBuilder(
      column: $table.lastSynced, builder: (column) => ColumnFilters(column));
}

class $$MachineEntriesTableOrderingComposer
    extends Composer<_$AppDatabase, $MachineEntriesTable> {
  $$MachineEntriesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get manufacturer => $composableBuilder(
      column: $table.manufacturer,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get model => $composableBuilder(
      column: $table.model, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get imagePath => $composableBuilder(
      column: $table.imagePath, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get description => $composableBuilder(
      column: $table.description, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get documentPath => $composableBuilder(
      column: $table.documentPath,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get displayInApp => $composableBuilder(
      column: $table.displayInApp,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get lastSynced => $composableBuilder(
      column: $table.lastSynced, builder: (column) => ColumnOrderings(column));
}

class $$MachineEntriesTableAnnotationComposer
    extends Composer<_$AppDatabase, $MachineEntriesTable> {
  $$MachineEntriesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get manufacturer => $composableBuilder(
      column: $table.manufacturer, builder: (column) => column);

  GeneratedColumn<String> get model =>
      $composableBuilder(column: $table.model, builder: (column) => column);

  GeneratedColumn<String> get imagePath =>
      $composableBuilder(column: $table.imagePath, builder: (column) => column);

  GeneratedColumn<String> get description => $composableBuilder(
      column: $table.description, builder: (column) => column);

  GeneratedColumn<String> get documentPath => $composableBuilder(
      column: $table.documentPath, builder: (column) => column);

  GeneratedColumn<bool> get displayInApp => $composableBuilder(
      column: $table.displayInApp, builder: (column) => column);

  GeneratedColumn<DateTime> get lastSynced => $composableBuilder(
      column: $table.lastSynced, builder: (column) => column);
}

class $$MachineEntriesTableTableManager extends RootTableManager<
    _$AppDatabase,
    $MachineEntriesTable,
    MachineEntry,
    $$MachineEntriesTableFilterComposer,
    $$MachineEntriesTableOrderingComposer,
    $$MachineEntriesTableAnnotationComposer,
    $$MachineEntriesTableCreateCompanionBuilder,
    $$MachineEntriesTableUpdateCompanionBuilder,
    (
      MachineEntry,
      BaseReferences<_$AppDatabase, $MachineEntriesTable, MachineEntry>
    ),
    MachineEntry,
    PrefetchHooks Function()> {
  $$MachineEntriesTableTableManager(
      _$AppDatabase db, $MachineEntriesTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$MachineEntriesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$MachineEntriesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$MachineEntriesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> id = const Value.absent(),
            Value<String> manufacturer = const Value.absent(),
            Value<String> model = const Value.absent(),
            Value<String?> imagePath = const Value.absent(),
            Value<String?> description = const Value.absent(),
            Value<String?> documentPath = const Value.absent(),
            Value<bool> displayInApp = const Value.absent(),
            Value<DateTime> lastSynced = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              MachineEntriesCompanion(
            id: id,
            manufacturer: manufacturer,
            model: model,
            imagePath: imagePath,
            description: description,
            documentPath: documentPath,
            displayInApp: displayInApp,
            lastSynced: lastSynced,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String id,
            required String manufacturer,
            required String model,
            Value<String?> imagePath = const Value.absent(),
            Value<String?> description = const Value.absent(),
            Value<String?> documentPath = const Value.absent(),
            Value<bool> displayInApp = const Value.absent(),
            Value<DateTime> lastSynced = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              MachineEntriesCompanion.insert(
            id: id,
            manufacturer: manufacturer,
            model: model,
            imagePath: imagePath,
            description: description,
            documentPath: documentPath,
            displayInApp: displayInApp,
            lastSynced: lastSynced,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$MachineEntriesTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $MachineEntriesTable,
    MachineEntry,
    $$MachineEntriesTableFilterComposer,
    $$MachineEntriesTableOrderingComposer,
    $$MachineEntriesTableAnnotationComposer,
    $$MachineEntriesTableCreateCompanionBuilder,
    $$MachineEntriesTableUpdateCompanionBuilder,
    (
      MachineEntry,
      BaseReferences<_$AppDatabase, $MachineEntriesTable, MachineEntry>
    ),
    MachineEntry,
    PrefetchHooks Function()>;
typedef $$SyncMetadataTableTableCreateCompanionBuilder
    = SyncMetadataTableCompanion Function({
  required String tableNameColumn,
  required DateTime lastSyncTimestamp,
  required int recordCount,
  Value<int> rowid,
});
typedef $$SyncMetadataTableTableUpdateCompanionBuilder
    = SyncMetadataTableCompanion Function({
  Value<String> tableNameColumn,
  Value<DateTime> lastSyncTimestamp,
  Value<int> recordCount,
  Value<int> rowid,
});

class $$SyncMetadataTableTableFilterComposer
    extends Composer<_$AppDatabase, $SyncMetadataTableTable> {
  $$SyncMetadataTableTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get tableNameColumn => $composableBuilder(
      column: $table.tableNameColumn,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get lastSyncTimestamp => $composableBuilder(
      column: $table.lastSyncTimestamp,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get recordCount => $composableBuilder(
      column: $table.recordCount, builder: (column) => ColumnFilters(column));
}

class $$SyncMetadataTableTableOrderingComposer
    extends Composer<_$AppDatabase, $SyncMetadataTableTable> {
  $$SyncMetadataTableTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get tableNameColumn => $composableBuilder(
      column: $table.tableNameColumn,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get lastSyncTimestamp => $composableBuilder(
      column: $table.lastSyncTimestamp,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get recordCount => $composableBuilder(
      column: $table.recordCount, builder: (column) => ColumnOrderings(column));
}

class $$SyncMetadataTableTableAnnotationComposer
    extends Composer<_$AppDatabase, $SyncMetadataTableTable> {
  $$SyncMetadataTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get tableNameColumn => $composableBuilder(
      column: $table.tableNameColumn, builder: (column) => column);

  GeneratedColumn<DateTime> get lastSyncTimestamp => $composableBuilder(
      column: $table.lastSyncTimestamp, builder: (column) => column);

  GeneratedColumn<int> get recordCount => $composableBuilder(
      column: $table.recordCount, builder: (column) => column);
}

class $$SyncMetadataTableTableTableManager extends RootTableManager<
    _$AppDatabase,
    $SyncMetadataTableTable,
    SyncMetadataTableData,
    $$SyncMetadataTableTableFilterComposer,
    $$SyncMetadataTableTableOrderingComposer,
    $$SyncMetadataTableTableAnnotationComposer,
    $$SyncMetadataTableTableCreateCompanionBuilder,
    $$SyncMetadataTableTableUpdateCompanionBuilder,
    (
      SyncMetadataTableData,
      BaseReferences<_$AppDatabase, $SyncMetadataTableTable,
          SyncMetadataTableData>
    ),
    SyncMetadataTableData,
    PrefetchHooks Function()> {
  $$SyncMetadataTableTableTableManager(
      _$AppDatabase db, $SyncMetadataTableTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$SyncMetadataTableTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$SyncMetadataTableTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$SyncMetadataTableTableAnnotationComposer(
                  $db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> tableNameColumn = const Value.absent(),
            Value<DateTime> lastSyncTimestamp = const Value.absent(),
            Value<int> recordCount = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              SyncMetadataTableCompanion(
            tableNameColumn: tableNameColumn,
            lastSyncTimestamp: lastSyncTimestamp,
            recordCount: recordCount,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String tableNameColumn,
            required DateTime lastSyncTimestamp,
            required int recordCount,
            Value<int> rowid = const Value.absent(),
          }) =>
              SyncMetadataTableCompanion.insert(
            tableNameColumn: tableNameColumn,
            lastSyncTimestamp: lastSyncTimestamp,
            recordCount: recordCount,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$SyncMetadataTableTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $SyncMetadataTableTable,
    SyncMetadataTableData,
    $$SyncMetadataTableTableFilterComposer,
    $$SyncMetadataTableTableOrderingComposer,
    $$SyncMetadataTableTableAnnotationComposer,
    $$SyncMetadataTableTableCreateCompanionBuilder,
    $$SyncMetadataTableTableUpdateCompanionBuilder,
    (
      SyncMetadataTableData,
      BaseReferences<_$AppDatabase, $SyncMetadataTableTable,
          SyncMetadataTableData>
    ),
    SyncMetadataTableData,
    PrefetchHooks Function()>;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$DocumentsTableTableManager get documents =>
      $$DocumentsTableTableManager(_db, _db.documents);
  $$SoftwaresTableTableManager get softwares =>
      $$SoftwaresTableTableManager(_db, _db.softwares);
  $$MachineEntriesTableTableManager get machineEntries =>
      $$MachineEntriesTableTableManager(_db, _db.machineEntries);
  $$SyncMetadataTableTableTableManager get syncMetadataTable =>
      $$SyncMetadataTableTableTableManager(_db, _db.syncMetadataTable);
}
