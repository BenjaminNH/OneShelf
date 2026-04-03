// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_database.dart';

// ignore_for_file: type=lint
class $MediaSourcesTableTable extends MediaSourcesTable
    with TableInfo<$MediaSourcesTableTable, MediaSourcesTableData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $MediaSourcesTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _displayNameMeta = const VerificationMeta(
    'displayName',
  );
  @override
  late final GeneratedColumn<String> displayName = GeneratedColumn<String>(
    'display_name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _rootUriMeta = const VerificationMeta(
    'rootUri',
  );
  @override
  late final GeneratedColumn<String> rootUri = GeneratedColumn<String>(
    'root_uri',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways('UNIQUE'),
  );
  static const VerificationMeta _rootRelativeKeyMeta = const VerificationMeta(
    'rootRelativeKey',
  );
  @override
  late final GeneratedColumn<String> rootRelativeKey = GeneratedColumn<String>(
    'root_relative_key',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _sourceTypeMeta = const VerificationMeta(
    'sourceType',
  );
  @override
  late final GeneratedColumn<String> sourceType = GeneratedColumn<String>(
    'source_type',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _permissionStatusMeta = const VerificationMeta(
    'permissionStatus',
  );
  @override
  late final GeneratedColumn<String> permissionStatus = GeneratedColumn<String>(
    'permission_status',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _lastScanStatusMeta = const VerificationMeta(
    'lastScanStatus',
  );
  @override
  late final GeneratedColumn<String> lastScanStatus = GeneratedColumn<String>(
    'last_scan_status',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _isEnabledMeta = const VerificationMeta(
    'isEnabled',
  );
  @override
  late final GeneratedColumn<bool> isEnabled = GeneratedColumn<bool>(
    'is_enabled',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_enabled" IN (0, 1))',
    ),
    defaultValue: const Constant(true),
  );
  static const VerificationMeta _mediaCountMeta = const VerificationMeta(
    'mediaCount',
  );
  @override
  late final GeneratedColumn<int> mediaCount = GeneratedColumn<int>(
    'media_count',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _lastScanStartedAtMeta = const VerificationMeta(
    'lastScanStartedAt',
  );
  @override
  late final GeneratedColumn<DateTime> lastScanStartedAt =
      GeneratedColumn<DateTime>(
        'last_scan_started_at',
        aliasedName,
        true,
        type: DriftSqlType.dateTime,
        requiredDuringInsert: false,
      );
  static const VerificationMeta _lastScanFinishedAtMeta =
      const VerificationMeta('lastScanFinishedAt');
  @override
  late final GeneratedColumn<DateTime> lastScanFinishedAt =
      GeneratedColumn<DateTime>(
        'last_scan_finished_at',
        aliasedName,
        true,
        type: DriftSqlType.dateTime,
        requiredDuringInsert: false,
      );
  static const VerificationMeta _lastErrorMeta = const VerificationMeta(
    'lastError',
  );
  @override
  late final GeneratedColumn<String> lastError = GeneratedColumn<String>(
    'last_error',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    displayName,
    rootUri,
    rootRelativeKey,
    sourceType,
    permissionStatus,
    lastScanStatus,
    isEnabled,
    mediaCount,
    lastScanStartedAt,
    lastScanFinishedAt,
    lastError,
    createdAt,
    updatedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'media_sources_table';
  @override
  VerificationContext validateIntegrity(
    Insertable<MediaSourcesTableData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('display_name')) {
      context.handle(
        _displayNameMeta,
        displayName.isAcceptableOrUnknown(
          data['display_name']!,
          _displayNameMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_displayNameMeta);
    }
    if (data.containsKey('root_uri')) {
      context.handle(
        _rootUriMeta,
        rootUri.isAcceptableOrUnknown(data['root_uri']!, _rootUriMeta),
      );
    } else if (isInserting) {
      context.missing(_rootUriMeta);
    }
    if (data.containsKey('root_relative_key')) {
      context.handle(
        _rootRelativeKeyMeta,
        rootRelativeKey.isAcceptableOrUnknown(
          data['root_relative_key']!,
          _rootRelativeKeyMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_rootRelativeKeyMeta);
    }
    if (data.containsKey('source_type')) {
      context.handle(
        _sourceTypeMeta,
        sourceType.isAcceptableOrUnknown(data['source_type']!, _sourceTypeMeta),
      );
    } else if (isInserting) {
      context.missing(_sourceTypeMeta);
    }
    if (data.containsKey('permission_status')) {
      context.handle(
        _permissionStatusMeta,
        permissionStatus.isAcceptableOrUnknown(
          data['permission_status']!,
          _permissionStatusMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_permissionStatusMeta);
    }
    if (data.containsKey('last_scan_status')) {
      context.handle(
        _lastScanStatusMeta,
        lastScanStatus.isAcceptableOrUnknown(
          data['last_scan_status']!,
          _lastScanStatusMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_lastScanStatusMeta);
    }
    if (data.containsKey('is_enabled')) {
      context.handle(
        _isEnabledMeta,
        isEnabled.isAcceptableOrUnknown(data['is_enabled']!, _isEnabledMeta),
      );
    }
    if (data.containsKey('media_count')) {
      context.handle(
        _mediaCountMeta,
        mediaCount.isAcceptableOrUnknown(data['media_count']!, _mediaCountMeta),
      );
    }
    if (data.containsKey('last_scan_started_at')) {
      context.handle(
        _lastScanStartedAtMeta,
        lastScanStartedAt.isAcceptableOrUnknown(
          data['last_scan_started_at']!,
          _lastScanStartedAtMeta,
        ),
      );
    }
    if (data.containsKey('last_scan_finished_at')) {
      context.handle(
        _lastScanFinishedAtMeta,
        lastScanFinishedAt.isAcceptableOrUnknown(
          data['last_scan_finished_at']!,
          _lastScanFinishedAtMeta,
        ),
      );
    }
    if (data.containsKey('last_error')) {
      context.handle(
        _lastErrorMeta,
        lastError.isAcceptableOrUnknown(data['last_error']!, _lastErrorMeta),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  MediaSourcesTableData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return MediaSourcesTableData(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      displayName: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}display_name'],
      )!,
      rootUri: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}root_uri'],
      )!,
      rootRelativeKey: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}root_relative_key'],
      )!,
      sourceType: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}source_type'],
      )!,
      permissionStatus: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}permission_status'],
      )!,
      lastScanStatus: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}last_scan_status'],
      )!,
      isEnabled: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_enabled'],
      )!,
      mediaCount: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}media_count'],
      )!,
      lastScanStartedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}last_scan_started_at'],
      ),
      lastScanFinishedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}last_scan_finished_at'],
      ),
      lastError: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}last_error'],
      ),
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
    );
  }

  @override
  $MediaSourcesTableTable createAlias(String alias) {
    return $MediaSourcesTableTable(attachedDatabase, alias);
  }
}

class MediaSourcesTableData extends DataClass
    implements Insertable<MediaSourcesTableData> {
  final String id;
  final String displayName;
  final String rootUri;
  final String rootRelativeKey;
  final String sourceType;
  final String permissionStatus;
  final String lastScanStatus;
  final bool isEnabled;
  final int mediaCount;
  final DateTime? lastScanStartedAt;
  final DateTime? lastScanFinishedAt;
  final String? lastError;
  final DateTime createdAt;
  final DateTime updatedAt;
  const MediaSourcesTableData({
    required this.id,
    required this.displayName,
    required this.rootUri,
    required this.rootRelativeKey,
    required this.sourceType,
    required this.permissionStatus,
    required this.lastScanStatus,
    required this.isEnabled,
    required this.mediaCount,
    this.lastScanStartedAt,
    this.lastScanFinishedAt,
    this.lastError,
    required this.createdAt,
    required this.updatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['display_name'] = Variable<String>(displayName);
    map['root_uri'] = Variable<String>(rootUri);
    map['root_relative_key'] = Variable<String>(rootRelativeKey);
    map['source_type'] = Variable<String>(sourceType);
    map['permission_status'] = Variable<String>(permissionStatus);
    map['last_scan_status'] = Variable<String>(lastScanStatus);
    map['is_enabled'] = Variable<bool>(isEnabled);
    map['media_count'] = Variable<int>(mediaCount);
    if (!nullToAbsent || lastScanStartedAt != null) {
      map['last_scan_started_at'] = Variable<DateTime>(lastScanStartedAt);
    }
    if (!nullToAbsent || lastScanFinishedAt != null) {
      map['last_scan_finished_at'] = Variable<DateTime>(lastScanFinishedAt);
    }
    if (!nullToAbsent || lastError != null) {
      map['last_error'] = Variable<String>(lastError);
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  MediaSourcesTableCompanion toCompanion(bool nullToAbsent) {
    return MediaSourcesTableCompanion(
      id: Value(id),
      displayName: Value(displayName),
      rootUri: Value(rootUri),
      rootRelativeKey: Value(rootRelativeKey),
      sourceType: Value(sourceType),
      permissionStatus: Value(permissionStatus),
      lastScanStatus: Value(lastScanStatus),
      isEnabled: Value(isEnabled),
      mediaCount: Value(mediaCount),
      lastScanStartedAt: lastScanStartedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(lastScanStartedAt),
      lastScanFinishedAt: lastScanFinishedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(lastScanFinishedAt),
      lastError: lastError == null && nullToAbsent
          ? const Value.absent()
          : Value(lastError),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
    );
  }

  factory MediaSourcesTableData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return MediaSourcesTableData(
      id: serializer.fromJson<String>(json['id']),
      displayName: serializer.fromJson<String>(json['displayName']),
      rootUri: serializer.fromJson<String>(json['rootUri']),
      rootRelativeKey: serializer.fromJson<String>(json['rootRelativeKey']),
      sourceType: serializer.fromJson<String>(json['sourceType']),
      permissionStatus: serializer.fromJson<String>(json['permissionStatus']),
      lastScanStatus: serializer.fromJson<String>(json['lastScanStatus']),
      isEnabled: serializer.fromJson<bool>(json['isEnabled']),
      mediaCount: serializer.fromJson<int>(json['mediaCount']),
      lastScanStartedAt: serializer.fromJson<DateTime?>(
        json['lastScanStartedAt'],
      ),
      lastScanFinishedAt: serializer.fromJson<DateTime?>(
        json['lastScanFinishedAt'],
      ),
      lastError: serializer.fromJson<String?>(json['lastError']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'displayName': serializer.toJson<String>(displayName),
      'rootUri': serializer.toJson<String>(rootUri),
      'rootRelativeKey': serializer.toJson<String>(rootRelativeKey),
      'sourceType': serializer.toJson<String>(sourceType),
      'permissionStatus': serializer.toJson<String>(permissionStatus),
      'lastScanStatus': serializer.toJson<String>(lastScanStatus),
      'isEnabled': serializer.toJson<bool>(isEnabled),
      'mediaCount': serializer.toJson<int>(mediaCount),
      'lastScanStartedAt': serializer.toJson<DateTime?>(lastScanStartedAt),
      'lastScanFinishedAt': serializer.toJson<DateTime?>(lastScanFinishedAt),
      'lastError': serializer.toJson<String?>(lastError),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  MediaSourcesTableData copyWith({
    String? id,
    String? displayName,
    String? rootUri,
    String? rootRelativeKey,
    String? sourceType,
    String? permissionStatus,
    String? lastScanStatus,
    bool? isEnabled,
    int? mediaCount,
    Value<DateTime?> lastScanStartedAt = const Value.absent(),
    Value<DateTime?> lastScanFinishedAt = const Value.absent(),
    Value<String?> lastError = const Value.absent(),
    DateTime? createdAt,
    DateTime? updatedAt,
  }) => MediaSourcesTableData(
    id: id ?? this.id,
    displayName: displayName ?? this.displayName,
    rootUri: rootUri ?? this.rootUri,
    rootRelativeKey: rootRelativeKey ?? this.rootRelativeKey,
    sourceType: sourceType ?? this.sourceType,
    permissionStatus: permissionStatus ?? this.permissionStatus,
    lastScanStatus: lastScanStatus ?? this.lastScanStatus,
    isEnabled: isEnabled ?? this.isEnabled,
    mediaCount: mediaCount ?? this.mediaCount,
    lastScanStartedAt: lastScanStartedAt.present
        ? lastScanStartedAt.value
        : this.lastScanStartedAt,
    lastScanFinishedAt: lastScanFinishedAt.present
        ? lastScanFinishedAt.value
        : this.lastScanFinishedAt,
    lastError: lastError.present ? lastError.value : this.lastError,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
  );
  MediaSourcesTableData copyWithCompanion(MediaSourcesTableCompanion data) {
    return MediaSourcesTableData(
      id: data.id.present ? data.id.value : this.id,
      displayName: data.displayName.present
          ? data.displayName.value
          : this.displayName,
      rootUri: data.rootUri.present ? data.rootUri.value : this.rootUri,
      rootRelativeKey: data.rootRelativeKey.present
          ? data.rootRelativeKey.value
          : this.rootRelativeKey,
      sourceType: data.sourceType.present
          ? data.sourceType.value
          : this.sourceType,
      permissionStatus: data.permissionStatus.present
          ? data.permissionStatus.value
          : this.permissionStatus,
      lastScanStatus: data.lastScanStatus.present
          ? data.lastScanStatus.value
          : this.lastScanStatus,
      isEnabled: data.isEnabled.present ? data.isEnabled.value : this.isEnabled,
      mediaCount: data.mediaCount.present
          ? data.mediaCount.value
          : this.mediaCount,
      lastScanStartedAt: data.lastScanStartedAt.present
          ? data.lastScanStartedAt.value
          : this.lastScanStartedAt,
      lastScanFinishedAt: data.lastScanFinishedAt.present
          ? data.lastScanFinishedAt.value
          : this.lastScanFinishedAt,
      lastError: data.lastError.present ? data.lastError.value : this.lastError,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('MediaSourcesTableData(')
          ..write('id: $id, ')
          ..write('displayName: $displayName, ')
          ..write('rootUri: $rootUri, ')
          ..write('rootRelativeKey: $rootRelativeKey, ')
          ..write('sourceType: $sourceType, ')
          ..write('permissionStatus: $permissionStatus, ')
          ..write('lastScanStatus: $lastScanStatus, ')
          ..write('isEnabled: $isEnabled, ')
          ..write('mediaCount: $mediaCount, ')
          ..write('lastScanStartedAt: $lastScanStartedAt, ')
          ..write('lastScanFinishedAt: $lastScanFinishedAt, ')
          ..write('lastError: $lastError, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    displayName,
    rootUri,
    rootRelativeKey,
    sourceType,
    permissionStatus,
    lastScanStatus,
    isEnabled,
    mediaCount,
    lastScanStartedAt,
    lastScanFinishedAt,
    lastError,
    createdAt,
    updatedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is MediaSourcesTableData &&
          other.id == this.id &&
          other.displayName == this.displayName &&
          other.rootUri == this.rootUri &&
          other.rootRelativeKey == this.rootRelativeKey &&
          other.sourceType == this.sourceType &&
          other.permissionStatus == this.permissionStatus &&
          other.lastScanStatus == this.lastScanStatus &&
          other.isEnabled == this.isEnabled &&
          other.mediaCount == this.mediaCount &&
          other.lastScanStartedAt == this.lastScanStartedAt &&
          other.lastScanFinishedAt == this.lastScanFinishedAt &&
          other.lastError == this.lastError &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class MediaSourcesTableCompanion
    extends UpdateCompanion<MediaSourcesTableData> {
  final Value<String> id;
  final Value<String> displayName;
  final Value<String> rootUri;
  final Value<String> rootRelativeKey;
  final Value<String> sourceType;
  final Value<String> permissionStatus;
  final Value<String> lastScanStatus;
  final Value<bool> isEnabled;
  final Value<int> mediaCount;
  final Value<DateTime?> lastScanStartedAt;
  final Value<DateTime?> lastScanFinishedAt;
  final Value<String?> lastError;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  final Value<int> rowid;
  const MediaSourcesTableCompanion({
    this.id = const Value.absent(),
    this.displayName = const Value.absent(),
    this.rootUri = const Value.absent(),
    this.rootRelativeKey = const Value.absent(),
    this.sourceType = const Value.absent(),
    this.permissionStatus = const Value.absent(),
    this.lastScanStatus = const Value.absent(),
    this.isEnabled = const Value.absent(),
    this.mediaCount = const Value.absent(),
    this.lastScanStartedAt = const Value.absent(),
    this.lastScanFinishedAt = const Value.absent(),
    this.lastError = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  MediaSourcesTableCompanion.insert({
    required String id,
    required String displayName,
    required String rootUri,
    required String rootRelativeKey,
    required String sourceType,
    required String permissionStatus,
    required String lastScanStatus,
    this.isEnabled = const Value.absent(),
    this.mediaCount = const Value.absent(),
    this.lastScanStartedAt = const Value.absent(),
    this.lastScanFinishedAt = const Value.absent(),
    this.lastError = const Value.absent(),
    required DateTime createdAt,
    required DateTime updatedAt,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       displayName = Value(displayName),
       rootUri = Value(rootUri),
       rootRelativeKey = Value(rootRelativeKey),
       sourceType = Value(sourceType),
       permissionStatus = Value(permissionStatus),
       lastScanStatus = Value(lastScanStatus),
       createdAt = Value(createdAt),
       updatedAt = Value(updatedAt);
  static Insertable<MediaSourcesTableData> custom({
    Expression<String>? id,
    Expression<String>? displayName,
    Expression<String>? rootUri,
    Expression<String>? rootRelativeKey,
    Expression<String>? sourceType,
    Expression<String>? permissionStatus,
    Expression<String>? lastScanStatus,
    Expression<bool>? isEnabled,
    Expression<int>? mediaCount,
    Expression<DateTime>? lastScanStartedAt,
    Expression<DateTime>? lastScanFinishedAt,
    Expression<String>? lastError,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (displayName != null) 'display_name': displayName,
      if (rootUri != null) 'root_uri': rootUri,
      if (rootRelativeKey != null) 'root_relative_key': rootRelativeKey,
      if (sourceType != null) 'source_type': sourceType,
      if (permissionStatus != null) 'permission_status': permissionStatus,
      if (lastScanStatus != null) 'last_scan_status': lastScanStatus,
      if (isEnabled != null) 'is_enabled': isEnabled,
      if (mediaCount != null) 'media_count': mediaCount,
      if (lastScanStartedAt != null) 'last_scan_started_at': lastScanStartedAt,
      if (lastScanFinishedAt != null)
        'last_scan_finished_at': lastScanFinishedAt,
      if (lastError != null) 'last_error': lastError,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  MediaSourcesTableCompanion copyWith({
    Value<String>? id,
    Value<String>? displayName,
    Value<String>? rootUri,
    Value<String>? rootRelativeKey,
    Value<String>? sourceType,
    Value<String>? permissionStatus,
    Value<String>? lastScanStatus,
    Value<bool>? isEnabled,
    Value<int>? mediaCount,
    Value<DateTime?>? lastScanStartedAt,
    Value<DateTime?>? lastScanFinishedAt,
    Value<String?>? lastError,
    Value<DateTime>? createdAt,
    Value<DateTime>? updatedAt,
    Value<int>? rowid,
  }) {
    return MediaSourcesTableCompanion(
      id: id ?? this.id,
      displayName: displayName ?? this.displayName,
      rootUri: rootUri ?? this.rootUri,
      rootRelativeKey: rootRelativeKey ?? this.rootRelativeKey,
      sourceType: sourceType ?? this.sourceType,
      permissionStatus: permissionStatus ?? this.permissionStatus,
      lastScanStatus: lastScanStatus ?? this.lastScanStatus,
      isEnabled: isEnabled ?? this.isEnabled,
      mediaCount: mediaCount ?? this.mediaCount,
      lastScanStartedAt: lastScanStartedAt ?? this.lastScanStartedAt,
      lastScanFinishedAt: lastScanFinishedAt ?? this.lastScanFinishedAt,
      lastError: lastError ?? this.lastError,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (displayName.present) {
      map['display_name'] = Variable<String>(displayName.value);
    }
    if (rootUri.present) {
      map['root_uri'] = Variable<String>(rootUri.value);
    }
    if (rootRelativeKey.present) {
      map['root_relative_key'] = Variable<String>(rootRelativeKey.value);
    }
    if (sourceType.present) {
      map['source_type'] = Variable<String>(sourceType.value);
    }
    if (permissionStatus.present) {
      map['permission_status'] = Variable<String>(permissionStatus.value);
    }
    if (lastScanStatus.present) {
      map['last_scan_status'] = Variable<String>(lastScanStatus.value);
    }
    if (isEnabled.present) {
      map['is_enabled'] = Variable<bool>(isEnabled.value);
    }
    if (mediaCount.present) {
      map['media_count'] = Variable<int>(mediaCount.value);
    }
    if (lastScanStartedAt.present) {
      map['last_scan_started_at'] = Variable<DateTime>(lastScanStartedAt.value);
    }
    if (lastScanFinishedAt.present) {
      map['last_scan_finished_at'] = Variable<DateTime>(
        lastScanFinishedAt.value,
      );
    }
    if (lastError.present) {
      map['last_error'] = Variable<String>(lastError.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('MediaSourcesTableCompanion(')
          ..write('id: $id, ')
          ..write('displayName: $displayName, ')
          ..write('rootUri: $rootUri, ')
          ..write('rootRelativeKey: $rootRelativeKey, ')
          ..write('sourceType: $sourceType, ')
          ..write('permissionStatus: $permissionStatus, ')
          ..write('lastScanStatus: $lastScanStatus, ')
          ..write('isEnabled: $isEnabled, ')
          ..write('mediaCount: $mediaCount, ')
          ..write('lastScanStartedAt: $lastScanStartedAt, ')
          ..write('lastScanFinishedAt: $lastScanFinishedAt, ')
          ..write('lastError: $lastError, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $MediaItemsTableTable extends MediaItemsTable
    with TableInfo<$MediaItemsTableTable, MediaItemsTableData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $MediaItemsTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _sourceIdMeta = const VerificationMeta(
    'sourceId',
  );
  @override
  late final GeneratedColumn<String> sourceId = GeneratedColumn<String>(
    'source_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES media_sources_table (id) ON DELETE CASCADE',
    ),
  );
  static const VerificationMeta _titleMeta = const VerificationMeta('title');
  @override
  late final GeneratedColumn<String> title = GeneratedColumn<String>(
    'title',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _displayLabelMeta = const VerificationMeta(
    'displayLabel',
  );
  @override
  late final GeneratedColumn<String> displayLabel = GeneratedColumn<String>(
    'display_label',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _actorNamesJsonMeta = const VerificationMeta(
    'actorNamesJson',
  );
  @override
  late final GeneratedColumn<String> actorNamesJson = GeneratedColumn<String>(
    'actor_names_json',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('[]'),
  );
  static const VerificationMeta _codeMeta = const VerificationMeta('code');
  @override
  late final GeneratedColumn<String> code = GeneratedColumn<String>(
    'code',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _plotMeta = const VerificationMeta('plot');
  @override
  late final GeneratedColumn<String> plot = GeneratedColumn<String>(
    'plot',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _posterRelativePathMeta =
      const VerificationMeta('posterRelativePath');
  @override
  late final GeneratedColumn<String> posterRelativePath =
      GeneratedColumn<String>(
        'poster_relative_path',
        aliasedName,
        true,
        type: DriftSqlType.string,
        requiredDuringInsert: false,
      );
  static const VerificationMeta _posterUriMeta = const VerificationMeta(
    'posterUri',
  );
  @override
  late final GeneratedColumn<String> posterUri = GeneratedColumn<String>(
    'poster_uri',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _posterLastModifiedMeta =
      const VerificationMeta('posterLastModified');
  @override
  late final GeneratedColumn<int> posterLastModified = GeneratedColumn<int>(
    'poster_last_modified',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _fanartRelativePathMeta =
      const VerificationMeta('fanartRelativePath');
  @override
  late final GeneratedColumn<String> fanartRelativePath =
      GeneratedColumn<String>(
        'fanart_relative_path',
        aliasedName,
        true,
        type: DriftSqlType.string,
        requiredDuringInsert: false,
      );
  static const VerificationMeta _fanartUriMeta = const VerificationMeta(
    'fanartUri',
  );
  @override
  late final GeneratedColumn<String> fanartUri = GeneratedColumn<String>(
    'fanart_uri',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _fanartLastModifiedMeta =
      const VerificationMeta('fanartLastModified');
  @override
  late final GeneratedColumn<int> fanartLastModified = GeneratedColumn<int>(
    'fanart_last_modified',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _folderRelativePathMeta =
      const VerificationMeta('folderRelativePath');
  @override
  late final GeneratedColumn<String> folderRelativePath =
      GeneratedColumn<String>(
        'folder_relative_path',
        aliasedName,
        true,
        type: DriftSqlType.string,
        requiredDuringInsert: false,
      );
  static const VerificationMeta _primaryVideoRelativePathMeta =
      const VerificationMeta('primaryVideoRelativePath');
  @override
  late final GeneratedColumn<String> primaryVideoRelativePath =
      GeneratedColumn<String>(
        'primary_video_relative_path',
        aliasedName,
        true,
        type: DriftSqlType.string,
        requiredDuringInsert: false,
      );
  static const VerificationMeta _primaryVideoUriMeta = const VerificationMeta(
    'primaryVideoUri',
  );
  @override
  late final GeneratedColumn<String> primaryVideoUri = GeneratedColumn<String>(
    'primary_video_uri',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _primaryVideoLastModifiedMeta =
      const VerificationMeta('primaryVideoLastModified');
  @override
  late final GeneratedColumn<int> primaryVideoLastModified =
      GeneratedColumn<int>(
        'primary_video_last_modified',
        aliasedName,
        true,
        type: DriftSqlType.int,
        requiredDuringInsert: false,
      );
  static const VerificationMeta _nfoRelativePathMeta = const VerificationMeta(
    'nfoRelativePath',
  );
  @override
  late final GeneratedColumn<String> nfoRelativePath = GeneratedColumn<String>(
    'nfo_relative_path',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _nfoUriMeta = const VerificationMeta('nfoUri');
  @override
  late final GeneratedColumn<String> nfoUri = GeneratedColumn<String>(
    'nfo_uri',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _fileNameMeta = const VerificationMeta(
    'fileName',
  );
  @override
  late final GeneratedColumn<String> fileName = GeneratedColumn<String>(
    'file_name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _fileSizeBytesMeta = const VerificationMeta(
    'fileSizeBytes',
  );
  @override
  late final GeneratedColumn<int> fileSizeBytes = GeneratedColumn<int>(
    'file_size_bytes',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _folderFingerprintMeta = const VerificationMeta(
    'folderFingerprint',
  );
  @override
  late final GeneratedColumn<String> folderFingerprint =
      GeneratedColumn<String>(
        'folder_fingerprint',
        aliasedName,
        true,
        type: DriftSqlType.string,
        requiredDuringInsert: false,
      );
  static const VerificationMeta _durationMsMeta = const VerificationMeta(
    'durationMs',
  );
  @override
  late final GeneratedColumn<int> durationMs = GeneratedColumn<int>(
    'duration_ms',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _widthMeta = const VerificationMeta('width');
  @override
  late final GeneratedColumn<int> width = GeneratedColumn<int>(
    'width',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _heightMeta = const VerificationMeta('height');
  @override
  late final GeneratedColumn<int> height = GeneratedColumn<int>(
    'height',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _isPlayableMeta = const VerificationMeta(
    'isPlayable',
  );
  @override
  late final GeneratedColumn<bool> isPlayable = GeneratedColumn<bool>(
    'is_playable',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_playable" IN (0, 1))',
    ),
    defaultValue: const Constant(true),
  );
  static const VerificationMeta _isMissingMeta = const VerificationMeta(
    'isMissing',
  );
  @override
  late final GeneratedColumn<bool> isMissing = GeneratedColumn<bool>(
    'is_missing',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_missing" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _firstSeenAtMeta = const VerificationMeta(
    'firstSeenAt',
  );
  @override
  late final GeneratedColumn<DateTime> firstSeenAt = GeneratedColumn<DateTime>(
    'first_seen_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _lastSeenAtMeta = const VerificationMeta(
    'lastSeenAt',
  );
  @override
  late final GeneratedColumn<DateTime> lastSeenAt = GeneratedColumn<DateTime>(
    'last_seen_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    sourceId,
    title,
    displayLabel,
    actorNamesJson,
    code,
    plot,
    posterRelativePath,
    posterUri,
    posterLastModified,
    fanartRelativePath,
    fanartUri,
    fanartLastModified,
    folderRelativePath,
    primaryVideoRelativePath,
    primaryVideoUri,
    primaryVideoLastModified,
    nfoRelativePath,
    nfoUri,
    fileName,
    fileSizeBytes,
    folderFingerprint,
    durationMs,
    width,
    height,
    isPlayable,
    isMissing,
    firstSeenAt,
    lastSeenAt,
    createdAt,
    updatedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'media_items_table';
  @override
  VerificationContext validateIntegrity(
    Insertable<MediaItemsTableData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('source_id')) {
      context.handle(
        _sourceIdMeta,
        sourceId.isAcceptableOrUnknown(data['source_id']!, _sourceIdMeta),
      );
    } else if (isInserting) {
      context.missing(_sourceIdMeta);
    }
    if (data.containsKey('title')) {
      context.handle(
        _titleMeta,
        title.isAcceptableOrUnknown(data['title']!, _titleMeta),
      );
    }
    if (data.containsKey('display_label')) {
      context.handle(
        _displayLabelMeta,
        displayLabel.isAcceptableOrUnknown(
          data['display_label']!,
          _displayLabelMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_displayLabelMeta);
    }
    if (data.containsKey('actor_names_json')) {
      context.handle(
        _actorNamesJsonMeta,
        actorNamesJson.isAcceptableOrUnknown(
          data['actor_names_json']!,
          _actorNamesJsonMeta,
        ),
      );
    }
    if (data.containsKey('code')) {
      context.handle(
        _codeMeta,
        code.isAcceptableOrUnknown(data['code']!, _codeMeta),
      );
    }
    if (data.containsKey('plot')) {
      context.handle(
        _plotMeta,
        plot.isAcceptableOrUnknown(data['plot']!, _plotMeta),
      );
    }
    if (data.containsKey('poster_relative_path')) {
      context.handle(
        _posterRelativePathMeta,
        posterRelativePath.isAcceptableOrUnknown(
          data['poster_relative_path']!,
          _posterRelativePathMeta,
        ),
      );
    }
    if (data.containsKey('poster_uri')) {
      context.handle(
        _posterUriMeta,
        posterUri.isAcceptableOrUnknown(data['poster_uri']!, _posterUriMeta),
      );
    }
    if (data.containsKey('poster_last_modified')) {
      context.handle(
        _posterLastModifiedMeta,
        posterLastModified.isAcceptableOrUnknown(
          data['poster_last_modified']!,
          _posterLastModifiedMeta,
        ),
      );
    }
    if (data.containsKey('fanart_relative_path')) {
      context.handle(
        _fanartRelativePathMeta,
        fanartRelativePath.isAcceptableOrUnknown(
          data['fanart_relative_path']!,
          _fanartRelativePathMeta,
        ),
      );
    }
    if (data.containsKey('fanart_uri')) {
      context.handle(
        _fanartUriMeta,
        fanartUri.isAcceptableOrUnknown(data['fanart_uri']!, _fanartUriMeta),
      );
    }
    if (data.containsKey('fanart_last_modified')) {
      context.handle(
        _fanartLastModifiedMeta,
        fanartLastModified.isAcceptableOrUnknown(
          data['fanart_last_modified']!,
          _fanartLastModifiedMeta,
        ),
      );
    }
    if (data.containsKey('folder_relative_path')) {
      context.handle(
        _folderRelativePathMeta,
        folderRelativePath.isAcceptableOrUnknown(
          data['folder_relative_path']!,
          _folderRelativePathMeta,
        ),
      );
    }
    if (data.containsKey('primary_video_relative_path')) {
      context.handle(
        _primaryVideoRelativePathMeta,
        primaryVideoRelativePath.isAcceptableOrUnknown(
          data['primary_video_relative_path']!,
          _primaryVideoRelativePathMeta,
        ),
      );
    }
    if (data.containsKey('primary_video_uri')) {
      context.handle(
        _primaryVideoUriMeta,
        primaryVideoUri.isAcceptableOrUnknown(
          data['primary_video_uri']!,
          _primaryVideoUriMeta,
        ),
      );
    }
    if (data.containsKey('primary_video_last_modified')) {
      context.handle(
        _primaryVideoLastModifiedMeta,
        primaryVideoLastModified.isAcceptableOrUnknown(
          data['primary_video_last_modified']!,
          _primaryVideoLastModifiedMeta,
        ),
      );
    }
    if (data.containsKey('nfo_relative_path')) {
      context.handle(
        _nfoRelativePathMeta,
        nfoRelativePath.isAcceptableOrUnknown(
          data['nfo_relative_path']!,
          _nfoRelativePathMeta,
        ),
      );
    }
    if (data.containsKey('nfo_uri')) {
      context.handle(
        _nfoUriMeta,
        nfoUri.isAcceptableOrUnknown(data['nfo_uri']!, _nfoUriMeta),
      );
    }
    if (data.containsKey('file_name')) {
      context.handle(
        _fileNameMeta,
        fileName.isAcceptableOrUnknown(data['file_name']!, _fileNameMeta),
      );
    } else if (isInserting) {
      context.missing(_fileNameMeta);
    }
    if (data.containsKey('file_size_bytes')) {
      context.handle(
        _fileSizeBytesMeta,
        fileSizeBytes.isAcceptableOrUnknown(
          data['file_size_bytes']!,
          _fileSizeBytesMeta,
        ),
      );
    }
    if (data.containsKey('folder_fingerprint')) {
      context.handle(
        _folderFingerprintMeta,
        folderFingerprint.isAcceptableOrUnknown(
          data['folder_fingerprint']!,
          _folderFingerprintMeta,
        ),
      );
    }
    if (data.containsKey('duration_ms')) {
      context.handle(
        _durationMsMeta,
        durationMs.isAcceptableOrUnknown(data['duration_ms']!, _durationMsMeta),
      );
    }
    if (data.containsKey('width')) {
      context.handle(
        _widthMeta,
        width.isAcceptableOrUnknown(data['width']!, _widthMeta),
      );
    }
    if (data.containsKey('height')) {
      context.handle(
        _heightMeta,
        height.isAcceptableOrUnknown(data['height']!, _heightMeta),
      );
    }
    if (data.containsKey('is_playable')) {
      context.handle(
        _isPlayableMeta,
        isPlayable.isAcceptableOrUnknown(data['is_playable']!, _isPlayableMeta),
      );
    }
    if (data.containsKey('is_missing')) {
      context.handle(
        _isMissingMeta,
        isMissing.isAcceptableOrUnknown(data['is_missing']!, _isMissingMeta),
      );
    }
    if (data.containsKey('first_seen_at')) {
      context.handle(
        _firstSeenAtMeta,
        firstSeenAt.isAcceptableOrUnknown(
          data['first_seen_at']!,
          _firstSeenAtMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_firstSeenAtMeta);
    }
    if (data.containsKey('last_seen_at')) {
      context.handle(
        _lastSeenAtMeta,
        lastSeenAt.isAcceptableOrUnknown(
          data['last_seen_at']!,
          _lastSeenAtMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_lastSeenAtMeta);
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  MediaItemsTableData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return MediaItemsTableData(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      sourceId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}source_id'],
      )!,
      title: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}title'],
      ),
      displayLabel: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}display_label'],
      )!,
      actorNamesJson: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}actor_names_json'],
      )!,
      code: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}code'],
      ),
      plot: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}plot'],
      ),
      posterRelativePath: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}poster_relative_path'],
      ),
      posterUri: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}poster_uri'],
      ),
      posterLastModified: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}poster_last_modified'],
      ),
      fanartRelativePath: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}fanart_relative_path'],
      ),
      fanartUri: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}fanart_uri'],
      ),
      fanartLastModified: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}fanart_last_modified'],
      ),
      folderRelativePath: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}folder_relative_path'],
      ),
      primaryVideoRelativePath: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}primary_video_relative_path'],
      ),
      primaryVideoUri: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}primary_video_uri'],
      ),
      primaryVideoLastModified: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}primary_video_last_modified'],
      ),
      nfoRelativePath: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}nfo_relative_path'],
      ),
      nfoUri: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}nfo_uri'],
      ),
      fileName: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}file_name'],
      )!,
      fileSizeBytes: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}file_size_bytes'],
      ),
      folderFingerprint: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}folder_fingerprint'],
      ),
      durationMs: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}duration_ms'],
      ),
      width: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}width'],
      ),
      height: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}height'],
      ),
      isPlayable: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_playable'],
      )!,
      isMissing: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_missing'],
      )!,
      firstSeenAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}first_seen_at'],
      )!,
      lastSeenAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}last_seen_at'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
    );
  }

  @override
  $MediaItemsTableTable createAlias(String alias) {
    return $MediaItemsTableTable(attachedDatabase, alias);
  }
}

class MediaItemsTableData extends DataClass
    implements Insertable<MediaItemsTableData> {
  final String id;
  final String sourceId;
  final String? title;
  final String displayLabel;
  final String actorNamesJson;
  final String? code;
  final String? plot;
  final String? posterRelativePath;
  final String? posterUri;
  final int? posterLastModified;
  final String? fanartRelativePath;
  final String? fanartUri;
  final int? fanartLastModified;
  final String? folderRelativePath;
  final String? primaryVideoRelativePath;
  final String? primaryVideoUri;
  final int? primaryVideoLastModified;
  final String? nfoRelativePath;
  final String? nfoUri;
  final String fileName;
  final int? fileSizeBytes;
  final String? folderFingerprint;
  final int? durationMs;
  final int? width;
  final int? height;
  final bool isPlayable;
  final bool isMissing;
  final DateTime firstSeenAt;
  final DateTime lastSeenAt;
  final DateTime createdAt;
  final DateTime updatedAt;
  const MediaItemsTableData({
    required this.id,
    required this.sourceId,
    this.title,
    required this.displayLabel,
    required this.actorNamesJson,
    this.code,
    this.plot,
    this.posterRelativePath,
    this.posterUri,
    this.posterLastModified,
    this.fanartRelativePath,
    this.fanartUri,
    this.fanartLastModified,
    this.folderRelativePath,
    this.primaryVideoRelativePath,
    this.primaryVideoUri,
    this.primaryVideoLastModified,
    this.nfoRelativePath,
    this.nfoUri,
    required this.fileName,
    this.fileSizeBytes,
    this.folderFingerprint,
    this.durationMs,
    this.width,
    this.height,
    required this.isPlayable,
    required this.isMissing,
    required this.firstSeenAt,
    required this.lastSeenAt,
    required this.createdAt,
    required this.updatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['source_id'] = Variable<String>(sourceId);
    if (!nullToAbsent || title != null) {
      map['title'] = Variable<String>(title);
    }
    map['display_label'] = Variable<String>(displayLabel);
    map['actor_names_json'] = Variable<String>(actorNamesJson);
    if (!nullToAbsent || code != null) {
      map['code'] = Variable<String>(code);
    }
    if (!nullToAbsent || plot != null) {
      map['plot'] = Variable<String>(plot);
    }
    if (!nullToAbsent || posterRelativePath != null) {
      map['poster_relative_path'] = Variable<String>(posterRelativePath);
    }
    if (!nullToAbsent || posterUri != null) {
      map['poster_uri'] = Variable<String>(posterUri);
    }
    if (!nullToAbsent || posterLastModified != null) {
      map['poster_last_modified'] = Variable<int>(posterLastModified);
    }
    if (!nullToAbsent || fanartRelativePath != null) {
      map['fanart_relative_path'] = Variable<String>(fanartRelativePath);
    }
    if (!nullToAbsent || fanartUri != null) {
      map['fanart_uri'] = Variable<String>(fanartUri);
    }
    if (!nullToAbsent || fanartLastModified != null) {
      map['fanart_last_modified'] = Variable<int>(fanartLastModified);
    }
    if (!nullToAbsent || folderRelativePath != null) {
      map['folder_relative_path'] = Variable<String>(folderRelativePath);
    }
    if (!nullToAbsent || primaryVideoRelativePath != null) {
      map['primary_video_relative_path'] = Variable<String>(
        primaryVideoRelativePath,
      );
    }
    if (!nullToAbsent || primaryVideoUri != null) {
      map['primary_video_uri'] = Variable<String>(primaryVideoUri);
    }
    if (!nullToAbsent || primaryVideoLastModified != null) {
      map['primary_video_last_modified'] = Variable<int>(
        primaryVideoLastModified,
      );
    }
    if (!nullToAbsent || nfoRelativePath != null) {
      map['nfo_relative_path'] = Variable<String>(nfoRelativePath);
    }
    if (!nullToAbsent || nfoUri != null) {
      map['nfo_uri'] = Variable<String>(nfoUri);
    }
    map['file_name'] = Variable<String>(fileName);
    if (!nullToAbsent || fileSizeBytes != null) {
      map['file_size_bytes'] = Variable<int>(fileSizeBytes);
    }
    if (!nullToAbsent || folderFingerprint != null) {
      map['folder_fingerprint'] = Variable<String>(folderFingerprint);
    }
    if (!nullToAbsent || durationMs != null) {
      map['duration_ms'] = Variable<int>(durationMs);
    }
    if (!nullToAbsent || width != null) {
      map['width'] = Variable<int>(width);
    }
    if (!nullToAbsent || height != null) {
      map['height'] = Variable<int>(height);
    }
    map['is_playable'] = Variable<bool>(isPlayable);
    map['is_missing'] = Variable<bool>(isMissing);
    map['first_seen_at'] = Variable<DateTime>(firstSeenAt);
    map['last_seen_at'] = Variable<DateTime>(lastSeenAt);
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  MediaItemsTableCompanion toCompanion(bool nullToAbsent) {
    return MediaItemsTableCompanion(
      id: Value(id),
      sourceId: Value(sourceId),
      title: title == null && nullToAbsent
          ? const Value.absent()
          : Value(title),
      displayLabel: Value(displayLabel),
      actorNamesJson: Value(actorNamesJson),
      code: code == null && nullToAbsent ? const Value.absent() : Value(code),
      plot: plot == null && nullToAbsent ? const Value.absent() : Value(plot),
      posterRelativePath: posterRelativePath == null && nullToAbsent
          ? const Value.absent()
          : Value(posterRelativePath),
      posterUri: posterUri == null && nullToAbsent
          ? const Value.absent()
          : Value(posterUri),
      posterLastModified: posterLastModified == null && nullToAbsent
          ? const Value.absent()
          : Value(posterLastModified),
      fanartRelativePath: fanartRelativePath == null && nullToAbsent
          ? const Value.absent()
          : Value(fanartRelativePath),
      fanartUri: fanartUri == null && nullToAbsent
          ? const Value.absent()
          : Value(fanartUri),
      fanartLastModified: fanartLastModified == null && nullToAbsent
          ? const Value.absent()
          : Value(fanartLastModified),
      folderRelativePath: folderRelativePath == null && nullToAbsent
          ? const Value.absent()
          : Value(folderRelativePath),
      primaryVideoRelativePath: primaryVideoRelativePath == null && nullToAbsent
          ? const Value.absent()
          : Value(primaryVideoRelativePath),
      primaryVideoUri: primaryVideoUri == null && nullToAbsent
          ? const Value.absent()
          : Value(primaryVideoUri),
      primaryVideoLastModified: primaryVideoLastModified == null && nullToAbsent
          ? const Value.absent()
          : Value(primaryVideoLastModified),
      nfoRelativePath: nfoRelativePath == null && nullToAbsent
          ? const Value.absent()
          : Value(nfoRelativePath),
      nfoUri: nfoUri == null && nullToAbsent
          ? const Value.absent()
          : Value(nfoUri),
      fileName: Value(fileName),
      fileSizeBytes: fileSizeBytes == null && nullToAbsent
          ? const Value.absent()
          : Value(fileSizeBytes),
      folderFingerprint: folderFingerprint == null && nullToAbsent
          ? const Value.absent()
          : Value(folderFingerprint),
      durationMs: durationMs == null && nullToAbsent
          ? const Value.absent()
          : Value(durationMs),
      width: width == null && nullToAbsent
          ? const Value.absent()
          : Value(width),
      height: height == null && nullToAbsent
          ? const Value.absent()
          : Value(height),
      isPlayable: Value(isPlayable),
      isMissing: Value(isMissing),
      firstSeenAt: Value(firstSeenAt),
      lastSeenAt: Value(lastSeenAt),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
    );
  }

  factory MediaItemsTableData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return MediaItemsTableData(
      id: serializer.fromJson<String>(json['id']),
      sourceId: serializer.fromJson<String>(json['sourceId']),
      title: serializer.fromJson<String?>(json['title']),
      displayLabel: serializer.fromJson<String>(json['displayLabel']),
      actorNamesJson: serializer.fromJson<String>(json['actorNamesJson']),
      code: serializer.fromJson<String?>(json['code']),
      plot: serializer.fromJson<String?>(json['plot']),
      posterRelativePath: serializer.fromJson<String?>(
        json['posterRelativePath'],
      ),
      posterUri: serializer.fromJson<String?>(json['posterUri']),
      posterLastModified: serializer.fromJson<int?>(json['posterLastModified']),
      fanartRelativePath: serializer.fromJson<String?>(
        json['fanartRelativePath'],
      ),
      fanartUri: serializer.fromJson<String?>(json['fanartUri']),
      fanartLastModified: serializer.fromJson<int?>(json['fanartLastModified']),
      folderRelativePath: serializer.fromJson<String?>(
        json['folderRelativePath'],
      ),
      primaryVideoRelativePath: serializer.fromJson<String?>(
        json['primaryVideoRelativePath'],
      ),
      primaryVideoUri: serializer.fromJson<String?>(json['primaryVideoUri']),
      primaryVideoLastModified: serializer.fromJson<int?>(
        json['primaryVideoLastModified'],
      ),
      nfoRelativePath: serializer.fromJson<String?>(json['nfoRelativePath']),
      nfoUri: serializer.fromJson<String?>(json['nfoUri']),
      fileName: serializer.fromJson<String>(json['fileName']),
      fileSizeBytes: serializer.fromJson<int?>(json['fileSizeBytes']),
      folderFingerprint: serializer.fromJson<String?>(
        json['folderFingerprint'],
      ),
      durationMs: serializer.fromJson<int?>(json['durationMs']),
      width: serializer.fromJson<int?>(json['width']),
      height: serializer.fromJson<int?>(json['height']),
      isPlayable: serializer.fromJson<bool>(json['isPlayable']),
      isMissing: serializer.fromJson<bool>(json['isMissing']),
      firstSeenAt: serializer.fromJson<DateTime>(json['firstSeenAt']),
      lastSeenAt: serializer.fromJson<DateTime>(json['lastSeenAt']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'sourceId': serializer.toJson<String>(sourceId),
      'title': serializer.toJson<String?>(title),
      'displayLabel': serializer.toJson<String>(displayLabel),
      'actorNamesJson': serializer.toJson<String>(actorNamesJson),
      'code': serializer.toJson<String?>(code),
      'plot': serializer.toJson<String?>(plot),
      'posterRelativePath': serializer.toJson<String?>(posterRelativePath),
      'posterUri': serializer.toJson<String?>(posterUri),
      'posterLastModified': serializer.toJson<int?>(posterLastModified),
      'fanartRelativePath': serializer.toJson<String?>(fanartRelativePath),
      'fanartUri': serializer.toJson<String?>(fanartUri),
      'fanartLastModified': serializer.toJson<int?>(fanartLastModified),
      'folderRelativePath': serializer.toJson<String?>(folderRelativePath),
      'primaryVideoRelativePath': serializer.toJson<String?>(
        primaryVideoRelativePath,
      ),
      'primaryVideoUri': serializer.toJson<String?>(primaryVideoUri),
      'primaryVideoLastModified': serializer.toJson<int?>(
        primaryVideoLastModified,
      ),
      'nfoRelativePath': serializer.toJson<String?>(nfoRelativePath),
      'nfoUri': serializer.toJson<String?>(nfoUri),
      'fileName': serializer.toJson<String>(fileName),
      'fileSizeBytes': serializer.toJson<int?>(fileSizeBytes),
      'folderFingerprint': serializer.toJson<String?>(folderFingerprint),
      'durationMs': serializer.toJson<int?>(durationMs),
      'width': serializer.toJson<int?>(width),
      'height': serializer.toJson<int?>(height),
      'isPlayable': serializer.toJson<bool>(isPlayable),
      'isMissing': serializer.toJson<bool>(isMissing),
      'firstSeenAt': serializer.toJson<DateTime>(firstSeenAt),
      'lastSeenAt': serializer.toJson<DateTime>(lastSeenAt),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  MediaItemsTableData copyWith({
    String? id,
    String? sourceId,
    Value<String?> title = const Value.absent(),
    String? displayLabel,
    String? actorNamesJson,
    Value<String?> code = const Value.absent(),
    Value<String?> plot = const Value.absent(),
    Value<String?> posterRelativePath = const Value.absent(),
    Value<String?> posterUri = const Value.absent(),
    Value<int?> posterLastModified = const Value.absent(),
    Value<String?> fanartRelativePath = const Value.absent(),
    Value<String?> fanartUri = const Value.absent(),
    Value<int?> fanartLastModified = const Value.absent(),
    Value<String?> folderRelativePath = const Value.absent(),
    Value<String?> primaryVideoRelativePath = const Value.absent(),
    Value<String?> primaryVideoUri = const Value.absent(),
    Value<int?> primaryVideoLastModified = const Value.absent(),
    Value<String?> nfoRelativePath = const Value.absent(),
    Value<String?> nfoUri = const Value.absent(),
    String? fileName,
    Value<int?> fileSizeBytes = const Value.absent(),
    Value<String?> folderFingerprint = const Value.absent(),
    Value<int?> durationMs = const Value.absent(),
    Value<int?> width = const Value.absent(),
    Value<int?> height = const Value.absent(),
    bool? isPlayable,
    bool? isMissing,
    DateTime? firstSeenAt,
    DateTime? lastSeenAt,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) => MediaItemsTableData(
    id: id ?? this.id,
    sourceId: sourceId ?? this.sourceId,
    title: title.present ? title.value : this.title,
    displayLabel: displayLabel ?? this.displayLabel,
    actorNamesJson: actorNamesJson ?? this.actorNamesJson,
    code: code.present ? code.value : this.code,
    plot: plot.present ? plot.value : this.plot,
    posterRelativePath: posterRelativePath.present
        ? posterRelativePath.value
        : this.posterRelativePath,
    posterUri: posterUri.present ? posterUri.value : this.posterUri,
    posterLastModified: posterLastModified.present
        ? posterLastModified.value
        : this.posterLastModified,
    fanartRelativePath: fanartRelativePath.present
        ? fanartRelativePath.value
        : this.fanartRelativePath,
    fanartUri: fanartUri.present ? fanartUri.value : this.fanartUri,
    fanartLastModified: fanartLastModified.present
        ? fanartLastModified.value
        : this.fanartLastModified,
    folderRelativePath: folderRelativePath.present
        ? folderRelativePath.value
        : this.folderRelativePath,
    primaryVideoRelativePath: primaryVideoRelativePath.present
        ? primaryVideoRelativePath.value
        : this.primaryVideoRelativePath,
    primaryVideoUri: primaryVideoUri.present
        ? primaryVideoUri.value
        : this.primaryVideoUri,
    primaryVideoLastModified: primaryVideoLastModified.present
        ? primaryVideoLastModified.value
        : this.primaryVideoLastModified,
    nfoRelativePath: nfoRelativePath.present
        ? nfoRelativePath.value
        : this.nfoRelativePath,
    nfoUri: nfoUri.present ? nfoUri.value : this.nfoUri,
    fileName: fileName ?? this.fileName,
    fileSizeBytes: fileSizeBytes.present
        ? fileSizeBytes.value
        : this.fileSizeBytes,
    folderFingerprint: folderFingerprint.present
        ? folderFingerprint.value
        : this.folderFingerprint,
    durationMs: durationMs.present ? durationMs.value : this.durationMs,
    width: width.present ? width.value : this.width,
    height: height.present ? height.value : this.height,
    isPlayable: isPlayable ?? this.isPlayable,
    isMissing: isMissing ?? this.isMissing,
    firstSeenAt: firstSeenAt ?? this.firstSeenAt,
    lastSeenAt: lastSeenAt ?? this.lastSeenAt,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
  );
  MediaItemsTableData copyWithCompanion(MediaItemsTableCompanion data) {
    return MediaItemsTableData(
      id: data.id.present ? data.id.value : this.id,
      sourceId: data.sourceId.present ? data.sourceId.value : this.sourceId,
      title: data.title.present ? data.title.value : this.title,
      displayLabel: data.displayLabel.present
          ? data.displayLabel.value
          : this.displayLabel,
      actorNamesJson: data.actorNamesJson.present
          ? data.actorNamesJson.value
          : this.actorNamesJson,
      code: data.code.present ? data.code.value : this.code,
      plot: data.plot.present ? data.plot.value : this.plot,
      posterRelativePath: data.posterRelativePath.present
          ? data.posterRelativePath.value
          : this.posterRelativePath,
      posterUri: data.posterUri.present ? data.posterUri.value : this.posterUri,
      posterLastModified: data.posterLastModified.present
          ? data.posterLastModified.value
          : this.posterLastModified,
      fanartRelativePath: data.fanartRelativePath.present
          ? data.fanartRelativePath.value
          : this.fanartRelativePath,
      fanartUri: data.fanartUri.present ? data.fanartUri.value : this.fanartUri,
      fanartLastModified: data.fanartLastModified.present
          ? data.fanartLastModified.value
          : this.fanartLastModified,
      folderRelativePath: data.folderRelativePath.present
          ? data.folderRelativePath.value
          : this.folderRelativePath,
      primaryVideoRelativePath: data.primaryVideoRelativePath.present
          ? data.primaryVideoRelativePath.value
          : this.primaryVideoRelativePath,
      primaryVideoUri: data.primaryVideoUri.present
          ? data.primaryVideoUri.value
          : this.primaryVideoUri,
      primaryVideoLastModified: data.primaryVideoLastModified.present
          ? data.primaryVideoLastModified.value
          : this.primaryVideoLastModified,
      nfoRelativePath: data.nfoRelativePath.present
          ? data.nfoRelativePath.value
          : this.nfoRelativePath,
      nfoUri: data.nfoUri.present ? data.nfoUri.value : this.nfoUri,
      fileName: data.fileName.present ? data.fileName.value : this.fileName,
      fileSizeBytes: data.fileSizeBytes.present
          ? data.fileSizeBytes.value
          : this.fileSizeBytes,
      folderFingerprint: data.folderFingerprint.present
          ? data.folderFingerprint.value
          : this.folderFingerprint,
      durationMs: data.durationMs.present
          ? data.durationMs.value
          : this.durationMs,
      width: data.width.present ? data.width.value : this.width,
      height: data.height.present ? data.height.value : this.height,
      isPlayable: data.isPlayable.present
          ? data.isPlayable.value
          : this.isPlayable,
      isMissing: data.isMissing.present ? data.isMissing.value : this.isMissing,
      firstSeenAt: data.firstSeenAt.present
          ? data.firstSeenAt.value
          : this.firstSeenAt,
      lastSeenAt: data.lastSeenAt.present
          ? data.lastSeenAt.value
          : this.lastSeenAt,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('MediaItemsTableData(')
          ..write('id: $id, ')
          ..write('sourceId: $sourceId, ')
          ..write('title: $title, ')
          ..write('displayLabel: $displayLabel, ')
          ..write('actorNamesJson: $actorNamesJson, ')
          ..write('code: $code, ')
          ..write('plot: $plot, ')
          ..write('posterRelativePath: $posterRelativePath, ')
          ..write('posterUri: $posterUri, ')
          ..write('posterLastModified: $posterLastModified, ')
          ..write('fanartRelativePath: $fanartRelativePath, ')
          ..write('fanartUri: $fanartUri, ')
          ..write('fanartLastModified: $fanartLastModified, ')
          ..write('folderRelativePath: $folderRelativePath, ')
          ..write('primaryVideoRelativePath: $primaryVideoRelativePath, ')
          ..write('primaryVideoUri: $primaryVideoUri, ')
          ..write('primaryVideoLastModified: $primaryVideoLastModified, ')
          ..write('nfoRelativePath: $nfoRelativePath, ')
          ..write('nfoUri: $nfoUri, ')
          ..write('fileName: $fileName, ')
          ..write('fileSizeBytes: $fileSizeBytes, ')
          ..write('folderFingerprint: $folderFingerprint, ')
          ..write('durationMs: $durationMs, ')
          ..write('width: $width, ')
          ..write('height: $height, ')
          ..write('isPlayable: $isPlayable, ')
          ..write('isMissing: $isMissing, ')
          ..write('firstSeenAt: $firstSeenAt, ')
          ..write('lastSeenAt: $lastSeenAt, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hashAll([
    id,
    sourceId,
    title,
    displayLabel,
    actorNamesJson,
    code,
    plot,
    posterRelativePath,
    posterUri,
    posterLastModified,
    fanartRelativePath,
    fanartUri,
    fanartLastModified,
    folderRelativePath,
    primaryVideoRelativePath,
    primaryVideoUri,
    primaryVideoLastModified,
    nfoRelativePath,
    nfoUri,
    fileName,
    fileSizeBytes,
    folderFingerprint,
    durationMs,
    width,
    height,
    isPlayable,
    isMissing,
    firstSeenAt,
    lastSeenAt,
    createdAt,
    updatedAt,
  ]);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is MediaItemsTableData &&
          other.id == this.id &&
          other.sourceId == this.sourceId &&
          other.title == this.title &&
          other.displayLabel == this.displayLabel &&
          other.actorNamesJson == this.actorNamesJson &&
          other.code == this.code &&
          other.plot == this.plot &&
          other.posterRelativePath == this.posterRelativePath &&
          other.posterUri == this.posterUri &&
          other.posterLastModified == this.posterLastModified &&
          other.fanartRelativePath == this.fanartRelativePath &&
          other.fanartUri == this.fanartUri &&
          other.fanartLastModified == this.fanartLastModified &&
          other.folderRelativePath == this.folderRelativePath &&
          other.primaryVideoRelativePath == this.primaryVideoRelativePath &&
          other.primaryVideoUri == this.primaryVideoUri &&
          other.primaryVideoLastModified == this.primaryVideoLastModified &&
          other.nfoRelativePath == this.nfoRelativePath &&
          other.nfoUri == this.nfoUri &&
          other.fileName == this.fileName &&
          other.fileSizeBytes == this.fileSizeBytes &&
          other.folderFingerprint == this.folderFingerprint &&
          other.durationMs == this.durationMs &&
          other.width == this.width &&
          other.height == this.height &&
          other.isPlayable == this.isPlayable &&
          other.isMissing == this.isMissing &&
          other.firstSeenAt == this.firstSeenAt &&
          other.lastSeenAt == this.lastSeenAt &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class MediaItemsTableCompanion extends UpdateCompanion<MediaItemsTableData> {
  final Value<String> id;
  final Value<String> sourceId;
  final Value<String?> title;
  final Value<String> displayLabel;
  final Value<String> actorNamesJson;
  final Value<String?> code;
  final Value<String?> plot;
  final Value<String?> posterRelativePath;
  final Value<String?> posterUri;
  final Value<int?> posterLastModified;
  final Value<String?> fanartRelativePath;
  final Value<String?> fanartUri;
  final Value<int?> fanartLastModified;
  final Value<String?> folderRelativePath;
  final Value<String?> primaryVideoRelativePath;
  final Value<String?> primaryVideoUri;
  final Value<int?> primaryVideoLastModified;
  final Value<String?> nfoRelativePath;
  final Value<String?> nfoUri;
  final Value<String> fileName;
  final Value<int?> fileSizeBytes;
  final Value<String?> folderFingerprint;
  final Value<int?> durationMs;
  final Value<int?> width;
  final Value<int?> height;
  final Value<bool> isPlayable;
  final Value<bool> isMissing;
  final Value<DateTime> firstSeenAt;
  final Value<DateTime> lastSeenAt;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  final Value<int> rowid;
  const MediaItemsTableCompanion({
    this.id = const Value.absent(),
    this.sourceId = const Value.absent(),
    this.title = const Value.absent(),
    this.displayLabel = const Value.absent(),
    this.actorNamesJson = const Value.absent(),
    this.code = const Value.absent(),
    this.plot = const Value.absent(),
    this.posterRelativePath = const Value.absent(),
    this.posterUri = const Value.absent(),
    this.posterLastModified = const Value.absent(),
    this.fanartRelativePath = const Value.absent(),
    this.fanartUri = const Value.absent(),
    this.fanartLastModified = const Value.absent(),
    this.folderRelativePath = const Value.absent(),
    this.primaryVideoRelativePath = const Value.absent(),
    this.primaryVideoUri = const Value.absent(),
    this.primaryVideoLastModified = const Value.absent(),
    this.nfoRelativePath = const Value.absent(),
    this.nfoUri = const Value.absent(),
    this.fileName = const Value.absent(),
    this.fileSizeBytes = const Value.absent(),
    this.folderFingerprint = const Value.absent(),
    this.durationMs = const Value.absent(),
    this.width = const Value.absent(),
    this.height = const Value.absent(),
    this.isPlayable = const Value.absent(),
    this.isMissing = const Value.absent(),
    this.firstSeenAt = const Value.absent(),
    this.lastSeenAt = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  MediaItemsTableCompanion.insert({
    required String id,
    required String sourceId,
    this.title = const Value.absent(),
    required String displayLabel,
    this.actorNamesJson = const Value.absent(),
    this.code = const Value.absent(),
    this.plot = const Value.absent(),
    this.posterRelativePath = const Value.absent(),
    this.posterUri = const Value.absent(),
    this.posterLastModified = const Value.absent(),
    this.fanartRelativePath = const Value.absent(),
    this.fanartUri = const Value.absent(),
    this.fanartLastModified = const Value.absent(),
    this.folderRelativePath = const Value.absent(),
    this.primaryVideoRelativePath = const Value.absent(),
    this.primaryVideoUri = const Value.absent(),
    this.primaryVideoLastModified = const Value.absent(),
    this.nfoRelativePath = const Value.absent(),
    this.nfoUri = const Value.absent(),
    required String fileName,
    this.fileSizeBytes = const Value.absent(),
    this.folderFingerprint = const Value.absent(),
    this.durationMs = const Value.absent(),
    this.width = const Value.absent(),
    this.height = const Value.absent(),
    this.isPlayable = const Value.absent(),
    this.isMissing = const Value.absent(),
    required DateTime firstSeenAt,
    required DateTime lastSeenAt,
    required DateTime createdAt,
    required DateTime updatedAt,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       sourceId = Value(sourceId),
       displayLabel = Value(displayLabel),
       fileName = Value(fileName),
       firstSeenAt = Value(firstSeenAt),
       lastSeenAt = Value(lastSeenAt),
       createdAt = Value(createdAt),
       updatedAt = Value(updatedAt);
  static Insertable<MediaItemsTableData> custom({
    Expression<String>? id,
    Expression<String>? sourceId,
    Expression<String>? title,
    Expression<String>? displayLabel,
    Expression<String>? actorNamesJson,
    Expression<String>? code,
    Expression<String>? plot,
    Expression<String>? posterRelativePath,
    Expression<String>? posterUri,
    Expression<int>? posterLastModified,
    Expression<String>? fanartRelativePath,
    Expression<String>? fanartUri,
    Expression<int>? fanartLastModified,
    Expression<String>? folderRelativePath,
    Expression<String>? primaryVideoRelativePath,
    Expression<String>? primaryVideoUri,
    Expression<int>? primaryVideoLastModified,
    Expression<String>? nfoRelativePath,
    Expression<String>? nfoUri,
    Expression<String>? fileName,
    Expression<int>? fileSizeBytes,
    Expression<String>? folderFingerprint,
    Expression<int>? durationMs,
    Expression<int>? width,
    Expression<int>? height,
    Expression<bool>? isPlayable,
    Expression<bool>? isMissing,
    Expression<DateTime>? firstSeenAt,
    Expression<DateTime>? lastSeenAt,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (sourceId != null) 'source_id': sourceId,
      if (title != null) 'title': title,
      if (displayLabel != null) 'display_label': displayLabel,
      if (actorNamesJson != null) 'actor_names_json': actorNamesJson,
      if (code != null) 'code': code,
      if (plot != null) 'plot': plot,
      if (posterRelativePath != null)
        'poster_relative_path': posterRelativePath,
      if (posterUri != null) 'poster_uri': posterUri,
      if (posterLastModified != null)
        'poster_last_modified': posterLastModified,
      if (fanartRelativePath != null)
        'fanart_relative_path': fanartRelativePath,
      if (fanartUri != null) 'fanart_uri': fanartUri,
      if (fanartLastModified != null)
        'fanart_last_modified': fanartLastModified,
      if (folderRelativePath != null)
        'folder_relative_path': folderRelativePath,
      if (primaryVideoRelativePath != null)
        'primary_video_relative_path': primaryVideoRelativePath,
      if (primaryVideoUri != null) 'primary_video_uri': primaryVideoUri,
      if (primaryVideoLastModified != null)
        'primary_video_last_modified': primaryVideoLastModified,
      if (nfoRelativePath != null) 'nfo_relative_path': nfoRelativePath,
      if (nfoUri != null) 'nfo_uri': nfoUri,
      if (fileName != null) 'file_name': fileName,
      if (fileSizeBytes != null) 'file_size_bytes': fileSizeBytes,
      if (folderFingerprint != null) 'folder_fingerprint': folderFingerprint,
      if (durationMs != null) 'duration_ms': durationMs,
      if (width != null) 'width': width,
      if (height != null) 'height': height,
      if (isPlayable != null) 'is_playable': isPlayable,
      if (isMissing != null) 'is_missing': isMissing,
      if (firstSeenAt != null) 'first_seen_at': firstSeenAt,
      if (lastSeenAt != null) 'last_seen_at': lastSeenAt,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  MediaItemsTableCompanion copyWith({
    Value<String>? id,
    Value<String>? sourceId,
    Value<String?>? title,
    Value<String>? displayLabel,
    Value<String>? actorNamesJson,
    Value<String?>? code,
    Value<String?>? plot,
    Value<String?>? posterRelativePath,
    Value<String?>? posterUri,
    Value<int?>? posterLastModified,
    Value<String?>? fanartRelativePath,
    Value<String?>? fanartUri,
    Value<int?>? fanartLastModified,
    Value<String?>? folderRelativePath,
    Value<String?>? primaryVideoRelativePath,
    Value<String?>? primaryVideoUri,
    Value<int?>? primaryVideoLastModified,
    Value<String?>? nfoRelativePath,
    Value<String?>? nfoUri,
    Value<String>? fileName,
    Value<int?>? fileSizeBytes,
    Value<String?>? folderFingerprint,
    Value<int?>? durationMs,
    Value<int?>? width,
    Value<int?>? height,
    Value<bool>? isPlayable,
    Value<bool>? isMissing,
    Value<DateTime>? firstSeenAt,
    Value<DateTime>? lastSeenAt,
    Value<DateTime>? createdAt,
    Value<DateTime>? updatedAt,
    Value<int>? rowid,
  }) {
    return MediaItemsTableCompanion(
      id: id ?? this.id,
      sourceId: sourceId ?? this.sourceId,
      title: title ?? this.title,
      displayLabel: displayLabel ?? this.displayLabel,
      actorNamesJson: actorNamesJson ?? this.actorNamesJson,
      code: code ?? this.code,
      plot: plot ?? this.plot,
      posterRelativePath: posterRelativePath ?? this.posterRelativePath,
      posterUri: posterUri ?? this.posterUri,
      posterLastModified: posterLastModified ?? this.posterLastModified,
      fanartRelativePath: fanartRelativePath ?? this.fanartRelativePath,
      fanartUri: fanartUri ?? this.fanartUri,
      fanartLastModified: fanartLastModified ?? this.fanartLastModified,
      folderRelativePath: folderRelativePath ?? this.folderRelativePath,
      primaryVideoRelativePath:
          primaryVideoRelativePath ?? this.primaryVideoRelativePath,
      primaryVideoUri: primaryVideoUri ?? this.primaryVideoUri,
      primaryVideoLastModified:
          primaryVideoLastModified ?? this.primaryVideoLastModified,
      nfoRelativePath: nfoRelativePath ?? this.nfoRelativePath,
      nfoUri: nfoUri ?? this.nfoUri,
      fileName: fileName ?? this.fileName,
      fileSizeBytes: fileSizeBytes ?? this.fileSizeBytes,
      folderFingerprint: folderFingerprint ?? this.folderFingerprint,
      durationMs: durationMs ?? this.durationMs,
      width: width ?? this.width,
      height: height ?? this.height,
      isPlayable: isPlayable ?? this.isPlayable,
      isMissing: isMissing ?? this.isMissing,
      firstSeenAt: firstSeenAt ?? this.firstSeenAt,
      lastSeenAt: lastSeenAt ?? this.lastSeenAt,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (sourceId.present) {
      map['source_id'] = Variable<String>(sourceId.value);
    }
    if (title.present) {
      map['title'] = Variable<String>(title.value);
    }
    if (displayLabel.present) {
      map['display_label'] = Variable<String>(displayLabel.value);
    }
    if (actorNamesJson.present) {
      map['actor_names_json'] = Variable<String>(actorNamesJson.value);
    }
    if (code.present) {
      map['code'] = Variable<String>(code.value);
    }
    if (plot.present) {
      map['plot'] = Variable<String>(plot.value);
    }
    if (posterRelativePath.present) {
      map['poster_relative_path'] = Variable<String>(posterRelativePath.value);
    }
    if (posterUri.present) {
      map['poster_uri'] = Variable<String>(posterUri.value);
    }
    if (posterLastModified.present) {
      map['poster_last_modified'] = Variable<int>(posterLastModified.value);
    }
    if (fanartRelativePath.present) {
      map['fanart_relative_path'] = Variable<String>(fanartRelativePath.value);
    }
    if (fanartUri.present) {
      map['fanart_uri'] = Variable<String>(fanartUri.value);
    }
    if (fanartLastModified.present) {
      map['fanart_last_modified'] = Variable<int>(fanartLastModified.value);
    }
    if (folderRelativePath.present) {
      map['folder_relative_path'] = Variable<String>(folderRelativePath.value);
    }
    if (primaryVideoRelativePath.present) {
      map['primary_video_relative_path'] = Variable<String>(
        primaryVideoRelativePath.value,
      );
    }
    if (primaryVideoUri.present) {
      map['primary_video_uri'] = Variable<String>(primaryVideoUri.value);
    }
    if (primaryVideoLastModified.present) {
      map['primary_video_last_modified'] = Variable<int>(
        primaryVideoLastModified.value,
      );
    }
    if (nfoRelativePath.present) {
      map['nfo_relative_path'] = Variable<String>(nfoRelativePath.value);
    }
    if (nfoUri.present) {
      map['nfo_uri'] = Variable<String>(nfoUri.value);
    }
    if (fileName.present) {
      map['file_name'] = Variable<String>(fileName.value);
    }
    if (fileSizeBytes.present) {
      map['file_size_bytes'] = Variable<int>(fileSizeBytes.value);
    }
    if (folderFingerprint.present) {
      map['folder_fingerprint'] = Variable<String>(folderFingerprint.value);
    }
    if (durationMs.present) {
      map['duration_ms'] = Variable<int>(durationMs.value);
    }
    if (width.present) {
      map['width'] = Variable<int>(width.value);
    }
    if (height.present) {
      map['height'] = Variable<int>(height.value);
    }
    if (isPlayable.present) {
      map['is_playable'] = Variable<bool>(isPlayable.value);
    }
    if (isMissing.present) {
      map['is_missing'] = Variable<bool>(isMissing.value);
    }
    if (firstSeenAt.present) {
      map['first_seen_at'] = Variable<DateTime>(firstSeenAt.value);
    }
    if (lastSeenAt.present) {
      map['last_seen_at'] = Variable<DateTime>(lastSeenAt.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('MediaItemsTableCompanion(')
          ..write('id: $id, ')
          ..write('sourceId: $sourceId, ')
          ..write('title: $title, ')
          ..write('displayLabel: $displayLabel, ')
          ..write('actorNamesJson: $actorNamesJson, ')
          ..write('code: $code, ')
          ..write('plot: $plot, ')
          ..write('posterRelativePath: $posterRelativePath, ')
          ..write('posterUri: $posterUri, ')
          ..write('posterLastModified: $posterLastModified, ')
          ..write('fanartRelativePath: $fanartRelativePath, ')
          ..write('fanartUri: $fanartUri, ')
          ..write('fanartLastModified: $fanartLastModified, ')
          ..write('folderRelativePath: $folderRelativePath, ')
          ..write('primaryVideoRelativePath: $primaryVideoRelativePath, ')
          ..write('primaryVideoUri: $primaryVideoUri, ')
          ..write('primaryVideoLastModified: $primaryVideoLastModified, ')
          ..write('nfoRelativePath: $nfoRelativePath, ')
          ..write('nfoUri: $nfoUri, ')
          ..write('fileName: $fileName, ')
          ..write('fileSizeBytes: $fileSizeBytes, ')
          ..write('folderFingerprint: $folderFingerprint, ')
          ..write('durationMs: $durationMs, ')
          ..write('width: $width, ')
          ..write('height: $height, ')
          ..write('isPlayable: $isPlayable, ')
          ..write('isMissing: $isMissing, ')
          ..write('firstSeenAt: $firstSeenAt, ')
          ..write('lastSeenAt: $lastSeenAt, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $MediaUserStatesTableTable extends MediaUserStatesTable
    with TableInfo<$MediaUserStatesTableTable, MediaUserStatesTableData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $MediaUserStatesTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _mediaIdMeta = const VerificationMeta(
    'mediaId',
  );
  @override
  late final GeneratedColumn<String> mediaId = GeneratedColumn<String>(
    'media_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _ratingValueMeta = const VerificationMeta(
    'ratingValue',
  );
  @override
  late final GeneratedColumn<double> ratingValue = GeneratedColumn<double>(
    'rating_value',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _lastPositionMsMeta = const VerificationMeta(
    'lastPositionMs',
  );
  @override
  late final GeneratedColumn<int> lastPositionMs = GeneratedColumn<int>(
    'last_position_ms',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _durationMsSnapshotMeta =
      const VerificationMeta('durationMsSnapshot');
  @override
  late final GeneratedColumn<int> durationMsSnapshot = GeneratedColumn<int>(
    'duration_ms_snapshot',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _lastPlayedAtMeta = const VerificationMeta(
    'lastPlayedAt',
  );
  @override
  late final GeneratedColumn<DateTime> lastPlayedAt = GeneratedColumn<DateTime>(
    'last_played_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _playCountMeta = const VerificationMeta(
    'playCount',
  );
  @override
  late final GeneratedColumn<int> playCount = GeneratedColumn<int>(
    'play_count',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _isFinishedMeta = const VerificationMeta(
    'isFinished',
  );
  @override
  late final GeneratedColumn<bool> isFinished = GeneratedColumn<bool>(
    'is_finished',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_finished" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    mediaId,
    ratingValue,
    lastPositionMs,
    durationMsSnapshot,
    lastPlayedAt,
    playCount,
    isFinished,
    updatedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'media_user_states_table';
  @override
  VerificationContext validateIntegrity(
    Insertable<MediaUserStatesTableData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('media_id')) {
      context.handle(
        _mediaIdMeta,
        mediaId.isAcceptableOrUnknown(data['media_id']!, _mediaIdMeta),
      );
    } else if (isInserting) {
      context.missing(_mediaIdMeta);
    }
    if (data.containsKey('rating_value')) {
      context.handle(
        _ratingValueMeta,
        ratingValue.isAcceptableOrUnknown(
          data['rating_value']!,
          _ratingValueMeta,
        ),
      );
    }
    if (data.containsKey('last_position_ms')) {
      context.handle(
        _lastPositionMsMeta,
        lastPositionMs.isAcceptableOrUnknown(
          data['last_position_ms']!,
          _lastPositionMsMeta,
        ),
      );
    }
    if (data.containsKey('duration_ms_snapshot')) {
      context.handle(
        _durationMsSnapshotMeta,
        durationMsSnapshot.isAcceptableOrUnknown(
          data['duration_ms_snapshot']!,
          _durationMsSnapshotMeta,
        ),
      );
    }
    if (data.containsKey('last_played_at')) {
      context.handle(
        _lastPlayedAtMeta,
        lastPlayedAt.isAcceptableOrUnknown(
          data['last_played_at']!,
          _lastPlayedAtMeta,
        ),
      );
    }
    if (data.containsKey('play_count')) {
      context.handle(
        _playCountMeta,
        playCount.isAcceptableOrUnknown(data['play_count']!, _playCountMeta),
      );
    }
    if (data.containsKey('is_finished')) {
      context.handle(
        _isFinishedMeta,
        isFinished.isAcceptableOrUnknown(data['is_finished']!, _isFinishedMeta),
      );
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {mediaId};
  @override
  MediaUserStatesTableData map(
    Map<String, dynamic> data, {
    String? tablePrefix,
  }) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return MediaUserStatesTableData(
      mediaId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}media_id'],
      )!,
      ratingValue: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}rating_value'],
      ),
      lastPositionMs: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}last_position_ms'],
      ),
      durationMsSnapshot: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}duration_ms_snapshot'],
      ),
      lastPlayedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}last_played_at'],
      ),
      playCount: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}play_count'],
      )!,
      isFinished: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_finished'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
    );
  }

  @override
  $MediaUserStatesTableTable createAlias(String alias) {
    return $MediaUserStatesTableTable(attachedDatabase, alias);
  }
}

class MediaUserStatesTableData extends DataClass
    implements Insertable<MediaUserStatesTableData> {
  final String mediaId;
  final double? ratingValue;
  final int? lastPositionMs;
  final int? durationMsSnapshot;
  final DateTime? lastPlayedAt;
  final int playCount;
  final bool isFinished;
  final DateTime updatedAt;
  const MediaUserStatesTableData({
    required this.mediaId,
    this.ratingValue,
    this.lastPositionMs,
    this.durationMsSnapshot,
    this.lastPlayedAt,
    required this.playCount,
    required this.isFinished,
    required this.updatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['media_id'] = Variable<String>(mediaId);
    if (!nullToAbsent || ratingValue != null) {
      map['rating_value'] = Variable<double>(ratingValue);
    }
    if (!nullToAbsent || lastPositionMs != null) {
      map['last_position_ms'] = Variable<int>(lastPositionMs);
    }
    if (!nullToAbsent || durationMsSnapshot != null) {
      map['duration_ms_snapshot'] = Variable<int>(durationMsSnapshot);
    }
    if (!nullToAbsent || lastPlayedAt != null) {
      map['last_played_at'] = Variable<DateTime>(lastPlayedAt);
    }
    map['play_count'] = Variable<int>(playCount);
    map['is_finished'] = Variable<bool>(isFinished);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  MediaUserStatesTableCompanion toCompanion(bool nullToAbsent) {
    return MediaUserStatesTableCompanion(
      mediaId: Value(mediaId),
      ratingValue: ratingValue == null && nullToAbsent
          ? const Value.absent()
          : Value(ratingValue),
      lastPositionMs: lastPositionMs == null && nullToAbsent
          ? const Value.absent()
          : Value(lastPositionMs),
      durationMsSnapshot: durationMsSnapshot == null && nullToAbsent
          ? const Value.absent()
          : Value(durationMsSnapshot),
      lastPlayedAt: lastPlayedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(lastPlayedAt),
      playCount: Value(playCount),
      isFinished: Value(isFinished),
      updatedAt: Value(updatedAt),
    );
  }

  factory MediaUserStatesTableData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return MediaUserStatesTableData(
      mediaId: serializer.fromJson<String>(json['mediaId']),
      ratingValue: serializer.fromJson<double?>(json['ratingValue']),
      lastPositionMs: serializer.fromJson<int?>(json['lastPositionMs']),
      durationMsSnapshot: serializer.fromJson<int?>(json['durationMsSnapshot']),
      lastPlayedAt: serializer.fromJson<DateTime?>(json['lastPlayedAt']),
      playCount: serializer.fromJson<int>(json['playCount']),
      isFinished: serializer.fromJson<bool>(json['isFinished']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'mediaId': serializer.toJson<String>(mediaId),
      'ratingValue': serializer.toJson<double?>(ratingValue),
      'lastPositionMs': serializer.toJson<int?>(lastPositionMs),
      'durationMsSnapshot': serializer.toJson<int?>(durationMsSnapshot),
      'lastPlayedAt': serializer.toJson<DateTime?>(lastPlayedAt),
      'playCount': serializer.toJson<int>(playCount),
      'isFinished': serializer.toJson<bool>(isFinished),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  MediaUserStatesTableData copyWith({
    String? mediaId,
    Value<double?> ratingValue = const Value.absent(),
    Value<int?> lastPositionMs = const Value.absent(),
    Value<int?> durationMsSnapshot = const Value.absent(),
    Value<DateTime?> lastPlayedAt = const Value.absent(),
    int? playCount,
    bool? isFinished,
    DateTime? updatedAt,
  }) => MediaUserStatesTableData(
    mediaId: mediaId ?? this.mediaId,
    ratingValue: ratingValue.present ? ratingValue.value : this.ratingValue,
    lastPositionMs: lastPositionMs.present
        ? lastPositionMs.value
        : this.lastPositionMs,
    durationMsSnapshot: durationMsSnapshot.present
        ? durationMsSnapshot.value
        : this.durationMsSnapshot,
    lastPlayedAt: lastPlayedAt.present ? lastPlayedAt.value : this.lastPlayedAt,
    playCount: playCount ?? this.playCount,
    isFinished: isFinished ?? this.isFinished,
    updatedAt: updatedAt ?? this.updatedAt,
  );
  MediaUserStatesTableData copyWithCompanion(
    MediaUserStatesTableCompanion data,
  ) {
    return MediaUserStatesTableData(
      mediaId: data.mediaId.present ? data.mediaId.value : this.mediaId,
      ratingValue: data.ratingValue.present
          ? data.ratingValue.value
          : this.ratingValue,
      lastPositionMs: data.lastPositionMs.present
          ? data.lastPositionMs.value
          : this.lastPositionMs,
      durationMsSnapshot: data.durationMsSnapshot.present
          ? data.durationMsSnapshot.value
          : this.durationMsSnapshot,
      lastPlayedAt: data.lastPlayedAt.present
          ? data.lastPlayedAt.value
          : this.lastPlayedAt,
      playCount: data.playCount.present ? data.playCount.value : this.playCount,
      isFinished: data.isFinished.present
          ? data.isFinished.value
          : this.isFinished,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('MediaUserStatesTableData(')
          ..write('mediaId: $mediaId, ')
          ..write('ratingValue: $ratingValue, ')
          ..write('lastPositionMs: $lastPositionMs, ')
          ..write('durationMsSnapshot: $durationMsSnapshot, ')
          ..write('lastPlayedAt: $lastPlayedAt, ')
          ..write('playCount: $playCount, ')
          ..write('isFinished: $isFinished, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    mediaId,
    ratingValue,
    lastPositionMs,
    durationMsSnapshot,
    lastPlayedAt,
    playCount,
    isFinished,
    updatedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is MediaUserStatesTableData &&
          other.mediaId == this.mediaId &&
          other.ratingValue == this.ratingValue &&
          other.lastPositionMs == this.lastPositionMs &&
          other.durationMsSnapshot == this.durationMsSnapshot &&
          other.lastPlayedAt == this.lastPlayedAt &&
          other.playCount == this.playCount &&
          other.isFinished == this.isFinished &&
          other.updatedAt == this.updatedAt);
}

class MediaUserStatesTableCompanion
    extends UpdateCompanion<MediaUserStatesTableData> {
  final Value<String> mediaId;
  final Value<double?> ratingValue;
  final Value<int?> lastPositionMs;
  final Value<int?> durationMsSnapshot;
  final Value<DateTime?> lastPlayedAt;
  final Value<int> playCount;
  final Value<bool> isFinished;
  final Value<DateTime> updatedAt;
  final Value<int> rowid;
  const MediaUserStatesTableCompanion({
    this.mediaId = const Value.absent(),
    this.ratingValue = const Value.absent(),
    this.lastPositionMs = const Value.absent(),
    this.durationMsSnapshot = const Value.absent(),
    this.lastPlayedAt = const Value.absent(),
    this.playCount = const Value.absent(),
    this.isFinished = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  MediaUserStatesTableCompanion.insert({
    required String mediaId,
    this.ratingValue = const Value.absent(),
    this.lastPositionMs = const Value.absent(),
    this.durationMsSnapshot = const Value.absent(),
    this.lastPlayedAt = const Value.absent(),
    this.playCount = const Value.absent(),
    this.isFinished = const Value.absent(),
    required DateTime updatedAt,
    this.rowid = const Value.absent(),
  }) : mediaId = Value(mediaId),
       updatedAt = Value(updatedAt);
  static Insertable<MediaUserStatesTableData> custom({
    Expression<String>? mediaId,
    Expression<double>? ratingValue,
    Expression<int>? lastPositionMs,
    Expression<int>? durationMsSnapshot,
    Expression<DateTime>? lastPlayedAt,
    Expression<int>? playCount,
    Expression<bool>? isFinished,
    Expression<DateTime>? updatedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (mediaId != null) 'media_id': mediaId,
      if (ratingValue != null) 'rating_value': ratingValue,
      if (lastPositionMs != null) 'last_position_ms': lastPositionMs,
      if (durationMsSnapshot != null)
        'duration_ms_snapshot': durationMsSnapshot,
      if (lastPlayedAt != null) 'last_played_at': lastPlayedAt,
      if (playCount != null) 'play_count': playCount,
      if (isFinished != null) 'is_finished': isFinished,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  MediaUserStatesTableCompanion copyWith({
    Value<String>? mediaId,
    Value<double?>? ratingValue,
    Value<int?>? lastPositionMs,
    Value<int?>? durationMsSnapshot,
    Value<DateTime?>? lastPlayedAt,
    Value<int>? playCount,
    Value<bool>? isFinished,
    Value<DateTime>? updatedAt,
    Value<int>? rowid,
  }) {
    return MediaUserStatesTableCompanion(
      mediaId: mediaId ?? this.mediaId,
      ratingValue: ratingValue ?? this.ratingValue,
      lastPositionMs: lastPositionMs ?? this.lastPositionMs,
      durationMsSnapshot: durationMsSnapshot ?? this.durationMsSnapshot,
      lastPlayedAt: lastPlayedAt ?? this.lastPlayedAt,
      playCount: playCount ?? this.playCount,
      isFinished: isFinished ?? this.isFinished,
      updatedAt: updatedAt ?? this.updatedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (mediaId.present) {
      map['media_id'] = Variable<String>(mediaId.value);
    }
    if (ratingValue.present) {
      map['rating_value'] = Variable<double>(ratingValue.value);
    }
    if (lastPositionMs.present) {
      map['last_position_ms'] = Variable<int>(lastPositionMs.value);
    }
    if (durationMsSnapshot.present) {
      map['duration_ms_snapshot'] = Variable<int>(durationMsSnapshot.value);
    }
    if (lastPlayedAt.present) {
      map['last_played_at'] = Variable<DateTime>(lastPlayedAt.value);
    }
    if (playCount.present) {
      map['play_count'] = Variable<int>(playCount.value);
    }
    if (isFinished.present) {
      map['is_finished'] = Variable<bool>(isFinished.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('MediaUserStatesTableCompanion(')
          ..write('mediaId: $mediaId, ')
          ..write('ratingValue: $ratingValue, ')
          ..write('lastPositionMs: $lastPositionMs, ')
          ..write('durationMsSnapshot: $durationMsSnapshot, ')
          ..write('lastPlayedAt: $lastPlayedAt, ')
          ..write('playCount: $playCount, ')
          ..write('isFinished: $isFinished, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $AppSettingsTableTable extends AppSettingsTable
    with TableInfo<$AppSettingsTableTable, AppSettingsTableData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $AppSettingsTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(1),
  );
  static const VerificationMeta _preferExternalPlayerMeta =
      const VerificationMeta('preferExternalPlayer');
  @override
  late final GeneratedColumn<bool> preferExternalPlayer = GeneratedColumn<bool>(
    'prefer_external_player',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("prefer_external_player" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _seekBackwardSecondsMeta =
      const VerificationMeta('seekBackwardSeconds');
  @override
  late final GeneratedColumn<int> seekBackwardSeconds = GeneratedColumn<int>(
    'seek_backward_seconds',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(10),
  );
  static const VerificationMeta _seekForwardSecondsMeta =
      const VerificationMeta('seekForwardSeconds');
  @override
  late final GeneratedColumn<int> seekForwardSeconds = GeneratedColumn<int>(
    'seek_forward_seconds',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(10),
  );
  static const VerificationMeta _holdSpeedMeta = const VerificationMeta(
    'holdSpeed',
  );
  @override
  late final GeneratedColumn<double> holdSpeed = GeneratedColumn<double>(
    'hold_speed',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
    defaultValue: const Constant(2.0),
  );
  static const VerificationMeta _rememberPlaybackSpeedMeta =
      const VerificationMeta('rememberPlaybackSpeed');
  @override
  late final GeneratedColumn<bool> rememberPlaybackSpeed =
      GeneratedColumn<bool>(
        'remember_playback_speed',
        aliasedName,
        false,
        type: DriftSqlType.bool,
        requiredDuringInsert: false,
        defaultConstraints: GeneratedColumn.constraintIsAlways(
          'CHECK ("remember_playback_speed" IN (0, 1))',
        ),
        defaultValue: const Constant(true),
      );
  static const VerificationMeta _keepResumeHistoryMeta = const VerificationMeta(
    'keepResumeHistory',
  );
  @override
  late final GeneratedColumn<bool> keepResumeHistory = GeneratedColumn<bool>(
    'keep_resume_history',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("keep_resume_history" IN (0, 1))',
    ),
    defaultValue: const Constant(true),
  );
  static const VerificationMeta _showRecentActivityMeta =
      const VerificationMeta('showRecentActivity');
  @override
  late final GeneratedColumn<bool> showRecentActivity = GeneratedColumn<bool>(
    'show_recent_activity',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("show_recent_activity" IN (0, 1))',
    ),
    defaultValue: const Constant(true),
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    preferExternalPlayer,
    seekBackwardSeconds,
    seekForwardSeconds,
    holdSpeed,
    rememberPlaybackSpeed,
    keepResumeHistory,
    showRecentActivity,
    updatedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'app_settings_table';
  @override
  VerificationContext validateIntegrity(
    Insertable<AppSettingsTableData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('prefer_external_player')) {
      context.handle(
        _preferExternalPlayerMeta,
        preferExternalPlayer.isAcceptableOrUnknown(
          data['prefer_external_player']!,
          _preferExternalPlayerMeta,
        ),
      );
    }
    if (data.containsKey('seek_backward_seconds')) {
      context.handle(
        _seekBackwardSecondsMeta,
        seekBackwardSeconds.isAcceptableOrUnknown(
          data['seek_backward_seconds']!,
          _seekBackwardSecondsMeta,
        ),
      );
    }
    if (data.containsKey('seek_forward_seconds')) {
      context.handle(
        _seekForwardSecondsMeta,
        seekForwardSeconds.isAcceptableOrUnknown(
          data['seek_forward_seconds']!,
          _seekForwardSecondsMeta,
        ),
      );
    }
    if (data.containsKey('hold_speed')) {
      context.handle(
        _holdSpeedMeta,
        holdSpeed.isAcceptableOrUnknown(data['hold_speed']!, _holdSpeedMeta),
      );
    }
    if (data.containsKey('remember_playback_speed')) {
      context.handle(
        _rememberPlaybackSpeedMeta,
        rememberPlaybackSpeed.isAcceptableOrUnknown(
          data['remember_playback_speed']!,
          _rememberPlaybackSpeedMeta,
        ),
      );
    }
    if (data.containsKey('keep_resume_history')) {
      context.handle(
        _keepResumeHistoryMeta,
        keepResumeHistory.isAcceptableOrUnknown(
          data['keep_resume_history']!,
          _keepResumeHistoryMeta,
        ),
      );
    }
    if (data.containsKey('show_recent_activity')) {
      context.handle(
        _showRecentActivityMeta,
        showRecentActivity.isAcceptableOrUnknown(
          data['show_recent_activity']!,
          _showRecentActivityMeta,
        ),
      );
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  AppSettingsTableData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return AppSettingsTableData(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      preferExternalPlayer: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}prefer_external_player'],
      )!,
      seekBackwardSeconds: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}seek_backward_seconds'],
      )!,
      seekForwardSeconds: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}seek_forward_seconds'],
      )!,
      holdSpeed: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}hold_speed'],
      )!,
      rememberPlaybackSpeed: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}remember_playback_speed'],
      )!,
      keepResumeHistory: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}keep_resume_history'],
      )!,
      showRecentActivity: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}show_recent_activity'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
    );
  }

  @override
  $AppSettingsTableTable createAlias(String alias) {
    return $AppSettingsTableTable(attachedDatabase, alias);
  }
}

class AppSettingsTableData extends DataClass
    implements Insertable<AppSettingsTableData> {
  final int id;
  final bool preferExternalPlayer;
  final int seekBackwardSeconds;
  final int seekForwardSeconds;
  final double holdSpeed;
  final bool rememberPlaybackSpeed;
  final bool keepResumeHistory;
  final bool showRecentActivity;
  final DateTime updatedAt;
  const AppSettingsTableData({
    required this.id,
    required this.preferExternalPlayer,
    required this.seekBackwardSeconds,
    required this.seekForwardSeconds,
    required this.holdSpeed,
    required this.rememberPlaybackSpeed,
    required this.keepResumeHistory,
    required this.showRecentActivity,
    required this.updatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['prefer_external_player'] = Variable<bool>(preferExternalPlayer);
    map['seek_backward_seconds'] = Variable<int>(seekBackwardSeconds);
    map['seek_forward_seconds'] = Variable<int>(seekForwardSeconds);
    map['hold_speed'] = Variable<double>(holdSpeed);
    map['remember_playback_speed'] = Variable<bool>(rememberPlaybackSpeed);
    map['keep_resume_history'] = Variable<bool>(keepResumeHistory);
    map['show_recent_activity'] = Variable<bool>(showRecentActivity);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  AppSettingsTableCompanion toCompanion(bool nullToAbsent) {
    return AppSettingsTableCompanion(
      id: Value(id),
      preferExternalPlayer: Value(preferExternalPlayer),
      seekBackwardSeconds: Value(seekBackwardSeconds),
      seekForwardSeconds: Value(seekForwardSeconds),
      holdSpeed: Value(holdSpeed),
      rememberPlaybackSpeed: Value(rememberPlaybackSpeed),
      keepResumeHistory: Value(keepResumeHistory),
      showRecentActivity: Value(showRecentActivity),
      updatedAt: Value(updatedAt),
    );
  }

  factory AppSettingsTableData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return AppSettingsTableData(
      id: serializer.fromJson<int>(json['id']),
      preferExternalPlayer: serializer.fromJson<bool>(
        json['preferExternalPlayer'],
      ),
      seekBackwardSeconds: serializer.fromJson<int>(
        json['seekBackwardSeconds'],
      ),
      seekForwardSeconds: serializer.fromJson<int>(json['seekForwardSeconds']),
      holdSpeed: serializer.fromJson<double>(json['holdSpeed']),
      rememberPlaybackSpeed: serializer.fromJson<bool>(
        json['rememberPlaybackSpeed'],
      ),
      keepResumeHistory: serializer.fromJson<bool>(json['keepResumeHistory']),
      showRecentActivity: serializer.fromJson<bool>(json['showRecentActivity']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'preferExternalPlayer': serializer.toJson<bool>(preferExternalPlayer),
      'seekBackwardSeconds': serializer.toJson<int>(seekBackwardSeconds),
      'seekForwardSeconds': serializer.toJson<int>(seekForwardSeconds),
      'holdSpeed': serializer.toJson<double>(holdSpeed),
      'rememberPlaybackSpeed': serializer.toJson<bool>(rememberPlaybackSpeed),
      'keepResumeHistory': serializer.toJson<bool>(keepResumeHistory),
      'showRecentActivity': serializer.toJson<bool>(showRecentActivity),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  AppSettingsTableData copyWith({
    int? id,
    bool? preferExternalPlayer,
    int? seekBackwardSeconds,
    int? seekForwardSeconds,
    double? holdSpeed,
    bool? rememberPlaybackSpeed,
    bool? keepResumeHistory,
    bool? showRecentActivity,
    DateTime? updatedAt,
  }) => AppSettingsTableData(
    id: id ?? this.id,
    preferExternalPlayer: preferExternalPlayer ?? this.preferExternalPlayer,
    seekBackwardSeconds: seekBackwardSeconds ?? this.seekBackwardSeconds,
    seekForwardSeconds: seekForwardSeconds ?? this.seekForwardSeconds,
    holdSpeed: holdSpeed ?? this.holdSpeed,
    rememberPlaybackSpeed: rememberPlaybackSpeed ?? this.rememberPlaybackSpeed,
    keepResumeHistory: keepResumeHistory ?? this.keepResumeHistory,
    showRecentActivity: showRecentActivity ?? this.showRecentActivity,
    updatedAt: updatedAt ?? this.updatedAt,
  );
  AppSettingsTableData copyWithCompanion(AppSettingsTableCompanion data) {
    return AppSettingsTableData(
      id: data.id.present ? data.id.value : this.id,
      preferExternalPlayer: data.preferExternalPlayer.present
          ? data.preferExternalPlayer.value
          : this.preferExternalPlayer,
      seekBackwardSeconds: data.seekBackwardSeconds.present
          ? data.seekBackwardSeconds.value
          : this.seekBackwardSeconds,
      seekForwardSeconds: data.seekForwardSeconds.present
          ? data.seekForwardSeconds.value
          : this.seekForwardSeconds,
      holdSpeed: data.holdSpeed.present ? data.holdSpeed.value : this.holdSpeed,
      rememberPlaybackSpeed: data.rememberPlaybackSpeed.present
          ? data.rememberPlaybackSpeed.value
          : this.rememberPlaybackSpeed,
      keepResumeHistory: data.keepResumeHistory.present
          ? data.keepResumeHistory.value
          : this.keepResumeHistory,
      showRecentActivity: data.showRecentActivity.present
          ? data.showRecentActivity.value
          : this.showRecentActivity,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('AppSettingsTableData(')
          ..write('id: $id, ')
          ..write('preferExternalPlayer: $preferExternalPlayer, ')
          ..write('seekBackwardSeconds: $seekBackwardSeconds, ')
          ..write('seekForwardSeconds: $seekForwardSeconds, ')
          ..write('holdSpeed: $holdSpeed, ')
          ..write('rememberPlaybackSpeed: $rememberPlaybackSpeed, ')
          ..write('keepResumeHistory: $keepResumeHistory, ')
          ..write('showRecentActivity: $showRecentActivity, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    preferExternalPlayer,
    seekBackwardSeconds,
    seekForwardSeconds,
    holdSpeed,
    rememberPlaybackSpeed,
    keepResumeHistory,
    showRecentActivity,
    updatedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is AppSettingsTableData &&
          other.id == this.id &&
          other.preferExternalPlayer == this.preferExternalPlayer &&
          other.seekBackwardSeconds == this.seekBackwardSeconds &&
          other.seekForwardSeconds == this.seekForwardSeconds &&
          other.holdSpeed == this.holdSpeed &&
          other.rememberPlaybackSpeed == this.rememberPlaybackSpeed &&
          other.keepResumeHistory == this.keepResumeHistory &&
          other.showRecentActivity == this.showRecentActivity &&
          other.updatedAt == this.updatedAt);
}

class AppSettingsTableCompanion extends UpdateCompanion<AppSettingsTableData> {
  final Value<int> id;
  final Value<bool> preferExternalPlayer;
  final Value<int> seekBackwardSeconds;
  final Value<int> seekForwardSeconds;
  final Value<double> holdSpeed;
  final Value<bool> rememberPlaybackSpeed;
  final Value<bool> keepResumeHistory;
  final Value<bool> showRecentActivity;
  final Value<DateTime> updatedAt;
  const AppSettingsTableCompanion({
    this.id = const Value.absent(),
    this.preferExternalPlayer = const Value.absent(),
    this.seekBackwardSeconds = const Value.absent(),
    this.seekForwardSeconds = const Value.absent(),
    this.holdSpeed = const Value.absent(),
    this.rememberPlaybackSpeed = const Value.absent(),
    this.keepResumeHistory = const Value.absent(),
    this.showRecentActivity = const Value.absent(),
    this.updatedAt = const Value.absent(),
  });
  AppSettingsTableCompanion.insert({
    this.id = const Value.absent(),
    this.preferExternalPlayer = const Value.absent(),
    this.seekBackwardSeconds = const Value.absent(),
    this.seekForwardSeconds = const Value.absent(),
    this.holdSpeed = const Value.absent(),
    this.rememberPlaybackSpeed = const Value.absent(),
    this.keepResumeHistory = const Value.absent(),
    this.showRecentActivity = const Value.absent(),
    required DateTime updatedAt,
  }) : updatedAt = Value(updatedAt);
  static Insertable<AppSettingsTableData> custom({
    Expression<int>? id,
    Expression<bool>? preferExternalPlayer,
    Expression<int>? seekBackwardSeconds,
    Expression<int>? seekForwardSeconds,
    Expression<double>? holdSpeed,
    Expression<bool>? rememberPlaybackSpeed,
    Expression<bool>? keepResumeHistory,
    Expression<bool>? showRecentActivity,
    Expression<DateTime>? updatedAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (preferExternalPlayer != null)
        'prefer_external_player': preferExternalPlayer,
      if (seekBackwardSeconds != null)
        'seek_backward_seconds': seekBackwardSeconds,
      if (seekForwardSeconds != null)
        'seek_forward_seconds': seekForwardSeconds,
      if (holdSpeed != null) 'hold_speed': holdSpeed,
      if (rememberPlaybackSpeed != null)
        'remember_playback_speed': rememberPlaybackSpeed,
      if (keepResumeHistory != null) 'keep_resume_history': keepResumeHistory,
      if (showRecentActivity != null)
        'show_recent_activity': showRecentActivity,
      if (updatedAt != null) 'updated_at': updatedAt,
    });
  }

  AppSettingsTableCompanion copyWith({
    Value<int>? id,
    Value<bool>? preferExternalPlayer,
    Value<int>? seekBackwardSeconds,
    Value<int>? seekForwardSeconds,
    Value<double>? holdSpeed,
    Value<bool>? rememberPlaybackSpeed,
    Value<bool>? keepResumeHistory,
    Value<bool>? showRecentActivity,
    Value<DateTime>? updatedAt,
  }) {
    return AppSettingsTableCompanion(
      id: id ?? this.id,
      preferExternalPlayer: preferExternalPlayer ?? this.preferExternalPlayer,
      seekBackwardSeconds: seekBackwardSeconds ?? this.seekBackwardSeconds,
      seekForwardSeconds: seekForwardSeconds ?? this.seekForwardSeconds,
      holdSpeed: holdSpeed ?? this.holdSpeed,
      rememberPlaybackSpeed:
          rememberPlaybackSpeed ?? this.rememberPlaybackSpeed,
      keepResumeHistory: keepResumeHistory ?? this.keepResumeHistory,
      showRecentActivity: showRecentActivity ?? this.showRecentActivity,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (preferExternalPlayer.present) {
      map['prefer_external_player'] = Variable<bool>(
        preferExternalPlayer.value,
      );
    }
    if (seekBackwardSeconds.present) {
      map['seek_backward_seconds'] = Variable<int>(seekBackwardSeconds.value);
    }
    if (seekForwardSeconds.present) {
      map['seek_forward_seconds'] = Variable<int>(seekForwardSeconds.value);
    }
    if (holdSpeed.present) {
      map['hold_speed'] = Variable<double>(holdSpeed.value);
    }
    if (rememberPlaybackSpeed.present) {
      map['remember_playback_speed'] = Variable<bool>(
        rememberPlaybackSpeed.value,
      );
    }
    if (keepResumeHistory.present) {
      map['keep_resume_history'] = Variable<bool>(keepResumeHistory.value);
    }
    if (showRecentActivity.present) {
      map['show_recent_activity'] = Variable<bool>(showRecentActivity.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('AppSettingsTableCompanion(')
          ..write('id: $id, ')
          ..write('preferExternalPlayer: $preferExternalPlayer, ')
          ..write('seekBackwardSeconds: $seekBackwardSeconds, ')
          ..write('seekForwardSeconds: $seekForwardSeconds, ')
          ..write('holdSpeed: $holdSpeed, ')
          ..write('rememberPlaybackSpeed: $rememberPlaybackSpeed, ')
          ..write('keepResumeHistory: $keepResumeHistory, ')
          ..write('showRecentActivity: $showRecentActivity, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }
}

class $ScanSessionsTableTable extends ScanSessionsTable
    with TableInfo<$ScanSessionsTableTable, ScanSessionsTableData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ScanSessionsTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _sourceIdMeta = const VerificationMeta(
    'sourceId',
  );
  @override
  late final GeneratedColumn<String> sourceId = GeneratedColumn<String>(
    'source_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES media_sources_table (id) ON DELETE CASCADE',
    ),
  );
  static const VerificationMeta _scanTypeMeta = const VerificationMeta(
    'scanType',
  );
  @override
  late final GeneratedColumn<String> scanType = GeneratedColumn<String>(
    'scan_type',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _statusMeta = const VerificationMeta('status');
  @override
  late final GeneratedColumn<String> status = GeneratedColumn<String>(
    'status',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _startedAtMeta = const VerificationMeta(
    'startedAt',
  );
  @override
  late final GeneratedColumn<DateTime> startedAt = GeneratedColumn<DateTime>(
    'started_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _finishedAtMeta = const VerificationMeta(
    'finishedAt',
  );
  @override
  late final GeneratedColumn<DateTime> finishedAt = GeneratedColumn<DateTime>(
    'finished_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _itemsFoundMeta = const VerificationMeta(
    'itemsFound',
  );
  @override
  late final GeneratedColumn<int> itemsFound = GeneratedColumn<int>(
    'items_found',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _itemsUpdatedMeta = const VerificationMeta(
    'itemsUpdated',
  );
  @override
  late final GeneratedColumn<int> itemsUpdated = GeneratedColumn<int>(
    'items_updated',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _itemsMissingMeta = const VerificationMeta(
    'itemsMissing',
  );
  @override
  late final GeneratedColumn<int> itemsMissing = GeneratedColumn<int>(
    'items_missing',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _errorMessageMeta = const VerificationMeta(
    'errorMessage',
  );
  @override
  late final GeneratedColumn<String> errorMessage = GeneratedColumn<String>(
    'error_message',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    sourceId,
    scanType,
    status,
    startedAt,
    finishedAt,
    itemsFound,
    itemsUpdated,
    itemsMissing,
    errorMessage,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'scan_sessions_table';
  @override
  VerificationContext validateIntegrity(
    Insertable<ScanSessionsTableData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('source_id')) {
      context.handle(
        _sourceIdMeta,
        sourceId.isAcceptableOrUnknown(data['source_id']!, _sourceIdMeta),
      );
    } else if (isInserting) {
      context.missing(_sourceIdMeta);
    }
    if (data.containsKey('scan_type')) {
      context.handle(
        _scanTypeMeta,
        scanType.isAcceptableOrUnknown(data['scan_type']!, _scanTypeMeta),
      );
    } else if (isInserting) {
      context.missing(_scanTypeMeta);
    }
    if (data.containsKey('status')) {
      context.handle(
        _statusMeta,
        status.isAcceptableOrUnknown(data['status']!, _statusMeta),
      );
    } else if (isInserting) {
      context.missing(_statusMeta);
    }
    if (data.containsKey('started_at')) {
      context.handle(
        _startedAtMeta,
        startedAt.isAcceptableOrUnknown(data['started_at']!, _startedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_startedAtMeta);
    }
    if (data.containsKey('finished_at')) {
      context.handle(
        _finishedAtMeta,
        finishedAt.isAcceptableOrUnknown(data['finished_at']!, _finishedAtMeta),
      );
    }
    if (data.containsKey('items_found')) {
      context.handle(
        _itemsFoundMeta,
        itemsFound.isAcceptableOrUnknown(data['items_found']!, _itemsFoundMeta),
      );
    }
    if (data.containsKey('items_updated')) {
      context.handle(
        _itemsUpdatedMeta,
        itemsUpdated.isAcceptableOrUnknown(
          data['items_updated']!,
          _itemsUpdatedMeta,
        ),
      );
    }
    if (data.containsKey('items_missing')) {
      context.handle(
        _itemsMissingMeta,
        itemsMissing.isAcceptableOrUnknown(
          data['items_missing']!,
          _itemsMissingMeta,
        ),
      );
    }
    if (data.containsKey('error_message')) {
      context.handle(
        _errorMessageMeta,
        errorMessage.isAcceptableOrUnknown(
          data['error_message']!,
          _errorMessageMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  ScanSessionsTableData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ScanSessionsTableData(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      sourceId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}source_id'],
      )!,
      scanType: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}scan_type'],
      )!,
      status: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}status'],
      )!,
      startedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}started_at'],
      )!,
      finishedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}finished_at'],
      ),
      itemsFound: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}items_found'],
      )!,
      itemsUpdated: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}items_updated'],
      )!,
      itemsMissing: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}items_missing'],
      )!,
      errorMessage: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}error_message'],
      ),
    );
  }

  @override
  $ScanSessionsTableTable createAlias(String alias) {
    return $ScanSessionsTableTable(attachedDatabase, alias);
  }
}

class ScanSessionsTableData extends DataClass
    implements Insertable<ScanSessionsTableData> {
  final String id;
  final String sourceId;
  final String scanType;
  final String status;
  final DateTime startedAt;
  final DateTime? finishedAt;
  final int itemsFound;
  final int itemsUpdated;
  final int itemsMissing;
  final String? errorMessage;
  const ScanSessionsTableData({
    required this.id,
    required this.sourceId,
    required this.scanType,
    required this.status,
    required this.startedAt,
    this.finishedAt,
    required this.itemsFound,
    required this.itemsUpdated,
    required this.itemsMissing,
    this.errorMessage,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['source_id'] = Variable<String>(sourceId);
    map['scan_type'] = Variable<String>(scanType);
    map['status'] = Variable<String>(status);
    map['started_at'] = Variable<DateTime>(startedAt);
    if (!nullToAbsent || finishedAt != null) {
      map['finished_at'] = Variable<DateTime>(finishedAt);
    }
    map['items_found'] = Variable<int>(itemsFound);
    map['items_updated'] = Variable<int>(itemsUpdated);
    map['items_missing'] = Variable<int>(itemsMissing);
    if (!nullToAbsent || errorMessage != null) {
      map['error_message'] = Variable<String>(errorMessage);
    }
    return map;
  }

  ScanSessionsTableCompanion toCompanion(bool nullToAbsent) {
    return ScanSessionsTableCompanion(
      id: Value(id),
      sourceId: Value(sourceId),
      scanType: Value(scanType),
      status: Value(status),
      startedAt: Value(startedAt),
      finishedAt: finishedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(finishedAt),
      itemsFound: Value(itemsFound),
      itemsUpdated: Value(itemsUpdated),
      itemsMissing: Value(itemsMissing),
      errorMessage: errorMessage == null && nullToAbsent
          ? const Value.absent()
          : Value(errorMessage),
    );
  }

  factory ScanSessionsTableData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ScanSessionsTableData(
      id: serializer.fromJson<String>(json['id']),
      sourceId: serializer.fromJson<String>(json['sourceId']),
      scanType: serializer.fromJson<String>(json['scanType']),
      status: serializer.fromJson<String>(json['status']),
      startedAt: serializer.fromJson<DateTime>(json['startedAt']),
      finishedAt: serializer.fromJson<DateTime?>(json['finishedAt']),
      itemsFound: serializer.fromJson<int>(json['itemsFound']),
      itemsUpdated: serializer.fromJson<int>(json['itemsUpdated']),
      itemsMissing: serializer.fromJson<int>(json['itemsMissing']),
      errorMessage: serializer.fromJson<String?>(json['errorMessage']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'sourceId': serializer.toJson<String>(sourceId),
      'scanType': serializer.toJson<String>(scanType),
      'status': serializer.toJson<String>(status),
      'startedAt': serializer.toJson<DateTime>(startedAt),
      'finishedAt': serializer.toJson<DateTime?>(finishedAt),
      'itemsFound': serializer.toJson<int>(itemsFound),
      'itemsUpdated': serializer.toJson<int>(itemsUpdated),
      'itemsMissing': serializer.toJson<int>(itemsMissing),
      'errorMessage': serializer.toJson<String?>(errorMessage),
    };
  }

  ScanSessionsTableData copyWith({
    String? id,
    String? sourceId,
    String? scanType,
    String? status,
    DateTime? startedAt,
    Value<DateTime?> finishedAt = const Value.absent(),
    int? itemsFound,
    int? itemsUpdated,
    int? itemsMissing,
    Value<String?> errorMessage = const Value.absent(),
  }) => ScanSessionsTableData(
    id: id ?? this.id,
    sourceId: sourceId ?? this.sourceId,
    scanType: scanType ?? this.scanType,
    status: status ?? this.status,
    startedAt: startedAt ?? this.startedAt,
    finishedAt: finishedAt.present ? finishedAt.value : this.finishedAt,
    itemsFound: itemsFound ?? this.itemsFound,
    itemsUpdated: itemsUpdated ?? this.itemsUpdated,
    itemsMissing: itemsMissing ?? this.itemsMissing,
    errorMessage: errorMessage.present ? errorMessage.value : this.errorMessage,
  );
  ScanSessionsTableData copyWithCompanion(ScanSessionsTableCompanion data) {
    return ScanSessionsTableData(
      id: data.id.present ? data.id.value : this.id,
      sourceId: data.sourceId.present ? data.sourceId.value : this.sourceId,
      scanType: data.scanType.present ? data.scanType.value : this.scanType,
      status: data.status.present ? data.status.value : this.status,
      startedAt: data.startedAt.present ? data.startedAt.value : this.startedAt,
      finishedAt: data.finishedAt.present
          ? data.finishedAt.value
          : this.finishedAt,
      itemsFound: data.itemsFound.present
          ? data.itemsFound.value
          : this.itemsFound,
      itemsUpdated: data.itemsUpdated.present
          ? data.itemsUpdated.value
          : this.itemsUpdated,
      itemsMissing: data.itemsMissing.present
          ? data.itemsMissing.value
          : this.itemsMissing,
      errorMessage: data.errorMessage.present
          ? data.errorMessage.value
          : this.errorMessage,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ScanSessionsTableData(')
          ..write('id: $id, ')
          ..write('sourceId: $sourceId, ')
          ..write('scanType: $scanType, ')
          ..write('status: $status, ')
          ..write('startedAt: $startedAt, ')
          ..write('finishedAt: $finishedAt, ')
          ..write('itemsFound: $itemsFound, ')
          ..write('itemsUpdated: $itemsUpdated, ')
          ..write('itemsMissing: $itemsMissing, ')
          ..write('errorMessage: $errorMessage')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    sourceId,
    scanType,
    status,
    startedAt,
    finishedAt,
    itemsFound,
    itemsUpdated,
    itemsMissing,
    errorMessage,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ScanSessionsTableData &&
          other.id == this.id &&
          other.sourceId == this.sourceId &&
          other.scanType == this.scanType &&
          other.status == this.status &&
          other.startedAt == this.startedAt &&
          other.finishedAt == this.finishedAt &&
          other.itemsFound == this.itemsFound &&
          other.itemsUpdated == this.itemsUpdated &&
          other.itemsMissing == this.itemsMissing &&
          other.errorMessage == this.errorMessage);
}

class ScanSessionsTableCompanion
    extends UpdateCompanion<ScanSessionsTableData> {
  final Value<String> id;
  final Value<String> sourceId;
  final Value<String> scanType;
  final Value<String> status;
  final Value<DateTime> startedAt;
  final Value<DateTime?> finishedAt;
  final Value<int> itemsFound;
  final Value<int> itemsUpdated;
  final Value<int> itemsMissing;
  final Value<String?> errorMessage;
  final Value<int> rowid;
  const ScanSessionsTableCompanion({
    this.id = const Value.absent(),
    this.sourceId = const Value.absent(),
    this.scanType = const Value.absent(),
    this.status = const Value.absent(),
    this.startedAt = const Value.absent(),
    this.finishedAt = const Value.absent(),
    this.itemsFound = const Value.absent(),
    this.itemsUpdated = const Value.absent(),
    this.itemsMissing = const Value.absent(),
    this.errorMessage = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  ScanSessionsTableCompanion.insert({
    required String id,
    required String sourceId,
    required String scanType,
    required String status,
    required DateTime startedAt,
    this.finishedAt = const Value.absent(),
    this.itemsFound = const Value.absent(),
    this.itemsUpdated = const Value.absent(),
    this.itemsMissing = const Value.absent(),
    this.errorMessage = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       sourceId = Value(sourceId),
       scanType = Value(scanType),
       status = Value(status),
       startedAt = Value(startedAt);
  static Insertable<ScanSessionsTableData> custom({
    Expression<String>? id,
    Expression<String>? sourceId,
    Expression<String>? scanType,
    Expression<String>? status,
    Expression<DateTime>? startedAt,
    Expression<DateTime>? finishedAt,
    Expression<int>? itemsFound,
    Expression<int>? itemsUpdated,
    Expression<int>? itemsMissing,
    Expression<String>? errorMessage,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (sourceId != null) 'source_id': sourceId,
      if (scanType != null) 'scan_type': scanType,
      if (status != null) 'status': status,
      if (startedAt != null) 'started_at': startedAt,
      if (finishedAt != null) 'finished_at': finishedAt,
      if (itemsFound != null) 'items_found': itemsFound,
      if (itemsUpdated != null) 'items_updated': itemsUpdated,
      if (itemsMissing != null) 'items_missing': itemsMissing,
      if (errorMessage != null) 'error_message': errorMessage,
      if (rowid != null) 'rowid': rowid,
    });
  }

  ScanSessionsTableCompanion copyWith({
    Value<String>? id,
    Value<String>? sourceId,
    Value<String>? scanType,
    Value<String>? status,
    Value<DateTime>? startedAt,
    Value<DateTime?>? finishedAt,
    Value<int>? itemsFound,
    Value<int>? itemsUpdated,
    Value<int>? itemsMissing,
    Value<String?>? errorMessage,
    Value<int>? rowid,
  }) {
    return ScanSessionsTableCompanion(
      id: id ?? this.id,
      sourceId: sourceId ?? this.sourceId,
      scanType: scanType ?? this.scanType,
      status: status ?? this.status,
      startedAt: startedAt ?? this.startedAt,
      finishedAt: finishedAt ?? this.finishedAt,
      itemsFound: itemsFound ?? this.itemsFound,
      itemsUpdated: itemsUpdated ?? this.itemsUpdated,
      itemsMissing: itemsMissing ?? this.itemsMissing,
      errorMessage: errorMessage ?? this.errorMessage,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (sourceId.present) {
      map['source_id'] = Variable<String>(sourceId.value);
    }
    if (scanType.present) {
      map['scan_type'] = Variable<String>(scanType.value);
    }
    if (status.present) {
      map['status'] = Variable<String>(status.value);
    }
    if (startedAt.present) {
      map['started_at'] = Variable<DateTime>(startedAt.value);
    }
    if (finishedAt.present) {
      map['finished_at'] = Variable<DateTime>(finishedAt.value);
    }
    if (itemsFound.present) {
      map['items_found'] = Variable<int>(itemsFound.value);
    }
    if (itemsUpdated.present) {
      map['items_updated'] = Variable<int>(itemsUpdated.value);
    }
    if (itemsMissing.present) {
      map['items_missing'] = Variable<int>(itemsMissing.value);
    }
    if (errorMessage.present) {
      map['error_message'] = Variable<String>(errorMessage.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ScanSessionsTableCompanion(')
          ..write('id: $id, ')
          ..write('sourceId: $sourceId, ')
          ..write('scanType: $scanType, ')
          ..write('status: $status, ')
          ..write('startedAt: $startedAt, ')
          ..write('finishedAt: $finishedAt, ')
          ..write('itemsFound: $itemsFound, ')
          ..write('itemsUpdated: $itemsUpdated, ')
          ..write('itemsMissing: $itemsMissing, ')
          ..write('errorMessage: $errorMessage, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $MediaSourcesTableTable mediaSourcesTable =
      $MediaSourcesTableTable(this);
  late final $MediaItemsTableTable mediaItemsTable = $MediaItemsTableTable(
    this,
  );
  late final $MediaUserStatesTableTable mediaUserStatesTable =
      $MediaUserStatesTableTable(this);
  late final $AppSettingsTableTable appSettingsTable = $AppSettingsTableTable(
    this,
  );
  late final $ScanSessionsTableTable scanSessionsTable =
      $ScanSessionsTableTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
    mediaSourcesTable,
    mediaItemsTable,
    mediaUserStatesTable,
    appSettingsTable,
    scanSessionsTable,
  ];
  @override
  StreamQueryUpdateRules get streamUpdateRules => const StreamQueryUpdateRules([
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'media_sources_table',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('media_items_table', kind: UpdateKind.delete)],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'media_sources_table',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('scan_sessions_table', kind: UpdateKind.delete)],
    ),
  ]);
}

typedef $$MediaSourcesTableTableCreateCompanionBuilder =
    MediaSourcesTableCompanion Function({
      required String id,
      required String displayName,
      required String rootUri,
      required String rootRelativeKey,
      required String sourceType,
      required String permissionStatus,
      required String lastScanStatus,
      Value<bool> isEnabled,
      Value<int> mediaCount,
      Value<DateTime?> lastScanStartedAt,
      Value<DateTime?> lastScanFinishedAt,
      Value<String?> lastError,
      required DateTime createdAt,
      required DateTime updatedAt,
      Value<int> rowid,
    });
typedef $$MediaSourcesTableTableUpdateCompanionBuilder =
    MediaSourcesTableCompanion Function({
      Value<String> id,
      Value<String> displayName,
      Value<String> rootUri,
      Value<String> rootRelativeKey,
      Value<String> sourceType,
      Value<String> permissionStatus,
      Value<String> lastScanStatus,
      Value<bool> isEnabled,
      Value<int> mediaCount,
      Value<DateTime?> lastScanStartedAt,
      Value<DateTime?> lastScanFinishedAt,
      Value<String?> lastError,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
      Value<int> rowid,
    });

final class $$MediaSourcesTableTableReferences
    extends
        BaseReferences<
          _$AppDatabase,
          $MediaSourcesTableTable,
          MediaSourcesTableData
        > {
  $$MediaSourcesTableTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static MultiTypedResultKey<$MediaItemsTableTable, List<MediaItemsTableData>>
  _mediaItemsTableRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.mediaItemsTable,
    aliasName: $_aliasNameGenerator(
      db.mediaSourcesTable.id,
      db.mediaItemsTable.sourceId,
    ),
  );

  $$MediaItemsTableTableProcessedTableManager get mediaItemsTableRefs {
    final manager = $$MediaItemsTableTableTableManager(
      $_db,
      $_db.mediaItemsTable,
    ).filter((f) => f.sourceId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(
      _mediaItemsTableRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<
    $ScanSessionsTableTable,
    List<ScanSessionsTableData>
  >
  _scanSessionsTableRefsTable(_$AppDatabase db) =>
      MultiTypedResultKey.fromTable(
        db.scanSessionsTable,
        aliasName: $_aliasNameGenerator(
          db.mediaSourcesTable.id,
          db.scanSessionsTable.sourceId,
        ),
      );

  $$ScanSessionsTableTableProcessedTableManager get scanSessionsTableRefs {
    final manager = $$ScanSessionsTableTableTableManager(
      $_db,
      $_db.scanSessionsTable,
    ).filter((f) => f.sourceId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(
      _scanSessionsTableRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$MediaSourcesTableTableFilterComposer
    extends Composer<_$AppDatabase, $MediaSourcesTableTable> {
  $$MediaSourcesTableTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get displayName => $composableBuilder(
    column: $table.displayName,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get rootUri => $composableBuilder(
    column: $table.rootUri,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get rootRelativeKey => $composableBuilder(
    column: $table.rootRelativeKey,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get sourceType => $composableBuilder(
    column: $table.sourceType,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get permissionStatus => $composableBuilder(
    column: $table.permissionStatus,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get lastScanStatus => $composableBuilder(
    column: $table.lastScanStatus,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isEnabled => $composableBuilder(
    column: $table.isEnabled,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get mediaCount => $composableBuilder(
    column: $table.mediaCount,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get lastScanStartedAt => $composableBuilder(
    column: $table.lastScanStartedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get lastScanFinishedAt => $composableBuilder(
    column: $table.lastScanFinishedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get lastError => $composableBuilder(
    column: $table.lastError,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );

  Expression<bool> mediaItemsTableRefs(
    Expression<bool> Function($$MediaItemsTableTableFilterComposer f) f,
  ) {
    final $$MediaItemsTableTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.mediaItemsTable,
      getReferencedColumn: (t) => t.sourceId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$MediaItemsTableTableFilterComposer(
            $db: $db,
            $table: $db.mediaItemsTable,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> scanSessionsTableRefs(
    Expression<bool> Function($$ScanSessionsTableTableFilterComposer f) f,
  ) {
    final $$ScanSessionsTableTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.scanSessionsTable,
      getReferencedColumn: (t) => t.sourceId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ScanSessionsTableTableFilterComposer(
            $db: $db,
            $table: $db.scanSessionsTable,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$MediaSourcesTableTableOrderingComposer
    extends Composer<_$AppDatabase, $MediaSourcesTableTable> {
  $$MediaSourcesTableTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get displayName => $composableBuilder(
    column: $table.displayName,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get rootUri => $composableBuilder(
    column: $table.rootUri,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get rootRelativeKey => $composableBuilder(
    column: $table.rootRelativeKey,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get sourceType => $composableBuilder(
    column: $table.sourceType,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get permissionStatus => $composableBuilder(
    column: $table.permissionStatus,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get lastScanStatus => $composableBuilder(
    column: $table.lastScanStatus,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isEnabled => $composableBuilder(
    column: $table.isEnabled,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get mediaCount => $composableBuilder(
    column: $table.mediaCount,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get lastScanStartedAt => $composableBuilder(
    column: $table.lastScanStartedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get lastScanFinishedAt => $composableBuilder(
    column: $table.lastScanFinishedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get lastError => $composableBuilder(
    column: $table.lastError,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$MediaSourcesTableTableAnnotationComposer
    extends Composer<_$AppDatabase, $MediaSourcesTableTable> {
  $$MediaSourcesTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get displayName => $composableBuilder(
    column: $table.displayName,
    builder: (column) => column,
  );

  GeneratedColumn<String> get rootUri =>
      $composableBuilder(column: $table.rootUri, builder: (column) => column);

  GeneratedColumn<String> get rootRelativeKey => $composableBuilder(
    column: $table.rootRelativeKey,
    builder: (column) => column,
  );

  GeneratedColumn<String> get sourceType => $composableBuilder(
    column: $table.sourceType,
    builder: (column) => column,
  );

  GeneratedColumn<String> get permissionStatus => $composableBuilder(
    column: $table.permissionStatus,
    builder: (column) => column,
  );

  GeneratedColumn<String> get lastScanStatus => $composableBuilder(
    column: $table.lastScanStatus,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get isEnabled =>
      $composableBuilder(column: $table.isEnabled, builder: (column) => column);

  GeneratedColumn<int> get mediaCount => $composableBuilder(
    column: $table.mediaCount,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get lastScanStartedAt => $composableBuilder(
    column: $table.lastScanStartedAt,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get lastScanFinishedAt => $composableBuilder(
    column: $table.lastScanFinishedAt,
    builder: (column) => column,
  );

  GeneratedColumn<String> get lastError =>
      $composableBuilder(column: $table.lastError, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  Expression<T> mediaItemsTableRefs<T extends Object>(
    Expression<T> Function($$MediaItemsTableTableAnnotationComposer a) f,
  ) {
    final $$MediaItemsTableTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.mediaItemsTable,
      getReferencedColumn: (t) => t.sourceId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$MediaItemsTableTableAnnotationComposer(
            $db: $db,
            $table: $db.mediaItemsTable,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> scanSessionsTableRefs<T extends Object>(
    Expression<T> Function($$ScanSessionsTableTableAnnotationComposer a) f,
  ) {
    final $$ScanSessionsTableTableAnnotationComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.id,
          referencedTable: $db.scanSessionsTable,
          getReferencedColumn: (t) => t.sourceId,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$ScanSessionsTableTableAnnotationComposer(
                $db: $db,
                $table: $db.scanSessionsTable,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return f(composer);
  }
}

class $$MediaSourcesTableTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $MediaSourcesTableTable,
          MediaSourcesTableData,
          $$MediaSourcesTableTableFilterComposer,
          $$MediaSourcesTableTableOrderingComposer,
          $$MediaSourcesTableTableAnnotationComposer,
          $$MediaSourcesTableTableCreateCompanionBuilder,
          $$MediaSourcesTableTableUpdateCompanionBuilder,
          (MediaSourcesTableData, $$MediaSourcesTableTableReferences),
          MediaSourcesTableData,
          PrefetchHooks Function({
            bool mediaItemsTableRefs,
            bool scanSessionsTableRefs,
          })
        > {
  $$MediaSourcesTableTableTableManager(
    _$AppDatabase db,
    $MediaSourcesTableTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$MediaSourcesTableTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$MediaSourcesTableTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$MediaSourcesTableTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> displayName = const Value.absent(),
                Value<String> rootUri = const Value.absent(),
                Value<String> rootRelativeKey = const Value.absent(),
                Value<String> sourceType = const Value.absent(),
                Value<String> permissionStatus = const Value.absent(),
                Value<String> lastScanStatus = const Value.absent(),
                Value<bool> isEnabled = const Value.absent(),
                Value<int> mediaCount = const Value.absent(),
                Value<DateTime?> lastScanStartedAt = const Value.absent(),
                Value<DateTime?> lastScanFinishedAt = const Value.absent(),
                Value<String?> lastError = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => MediaSourcesTableCompanion(
                id: id,
                displayName: displayName,
                rootUri: rootUri,
                rootRelativeKey: rootRelativeKey,
                sourceType: sourceType,
                permissionStatus: permissionStatus,
                lastScanStatus: lastScanStatus,
                isEnabled: isEnabled,
                mediaCount: mediaCount,
                lastScanStartedAt: lastScanStartedAt,
                lastScanFinishedAt: lastScanFinishedAt,
                lastError: lastError,
                createdAt: createdAt,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String displayName,
                required String rootUri,
                required String rootRelativeKey,
                required String sourceType,
                required String permissionStatus,
                required String lastScanStatus,
                Value<bool> isEnabled = const Value.absent(),
                Value<int> mediaCount = const Value.absent(),
                Value<DateTime?> lastScanStartedAt = const Value.absent(),
                Value<DateTime?> lastScanFinishedAt = const Value.absent(),
                Value<String?> lastError = const Value.absent(),
                required DateTime createdAt,
                required DateTime updatedAt,
                Value<int> rowid = const Value.absent(),
              }) => MediaSourcesTableCompanion.insert(
                id: id,
                displayName: displayName,
                rootUri: rootUri,
                rootRelativeKey: rootRelativeKey,
                sourceType: sourceType,
                permissionStatus: permissionStatus,
                lastScanStatus: lastScanStatus,
                isEnabled: isEnabled,
                mediaCount: mediaCount,
                lastScanStartedAt: lastScanStartedAt,
                lastScanFinishedAt: lastScanFinishedAt,
                lastError: lastError,
                createdAt: createdAt,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$MediaSourcesTableTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback:
              ({mediaItemsTableRefs = false, scanSessionsTableRefs = false}) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [
                    if (mediaItemsTableRefs) db.mediaItemsTable,
                    if (scanSessionsTableRefs) db.scanSessionsTable,
                  ],
                  addJoins: null,
                  getPrefetchedDataCallback: (items) async {
                    return [
                      if (mediaItemsTableRefs)
                        await $_getPrefetchedData<
                          MediaSourcesTableData,
                          $MediaSourcesTableTable,
                          MediaItemsTableData
                        >(
                          currentTable: table,
                          referencedTable: $$MediaSourcesTableTableReferences
                              ._mediaItemsTableRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$MediaSourcesTableTableReferences(
                                db,
                                table,
                                p0,
                              ).mediaItemsTableRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.sourceId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (scanSessionsTableRefs)
                        await $_getPrefetchedData<
                          MediaSourcesTableData,
                          $MediaSourcesTableTable,
                          ScanSessionsTableData
                        >(
                          currentTable: table,
                          referencedTable: $$MediaSourcesTableTableReferences
                              ._scanSessionsTableRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$MediaSourcesTableTableReferences(
                                db,
                                table,
                                p0,
                              ).scanSessionsTableRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.sourceId == item.id,
                              ),
                          typedResults: items,
                        ),
                    ];
                  },
                );
              },
        ),
      );
}

typedef $$MediaSourcesTableTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $MediaSourcesTableTable,
      MediaSourcesTableData,
      $$MediaSourcesTableTableFilterComposer,
      $$MediaSourcesTableTableOrderingComposer,
      $$MediaSourcesTableTableAnnotationComposer,
      $$MediaSourcesTableTableCreateCompanionBuilder,
      $$MediaSourcesTableTableUpdateCompanionBuilder,
      (MediaSourcesTableData, $$MediaSourcesTableTableReferences),
      MediaSourcesTableData,
      PrefetchHooks Function({
        bool mediaItemsTableRefs,
        bool scanSessionsTableRefs,
      })
    >;
typedef $$MediaItemsTableTableCreateCompanionBuilder =
    MediaItemsTableCompanion Function({
      required String id,
      required String sourceId,
      Value<String?> title,
      required String displayLabel,
      Value<String> actorNamesJson,
      Value<String?> code,
      Value<String?> plot,
      Value<String?> posterRelativePath,
      Value<String?> posterUri,
      Value<int?> posterLastModified,
      Value<String?> fanartRelativePath,
      Value<String?> fanartUri,
      Value<int?> fanartLastModified,
      Value<String?> folderRelativePath,
      Value<String?> primaryVideoRelativePath,
      Value<String?> primaryVideoUri,
      Value<int?> primaryVideoLastModified,
      Value<String?> nfoRelativePath,
      Value<String?> nfoUri,
      required String fileName,
      Value<int?> fileSizeBytes,
      Value<String?> folderFingerprint,
      Value<int?> durationMs,
      Value<int?> width,
      Value<int?> height,
      Value<bool> isPlayable,
      Value<bool> isMissing,
      required DateTime firstSeenAt,
      required DateTime lastSeenAt,
      required DateTime createdAt,
      required DateTime updatedAt,
      Value<int> rowid,
    });
typedef $$MediaItemsTableTableUpdateCompanionBuilder =
    MediaItemsTableCompanion Function({
      Value<String> id,
      Value<String> sourceId,
      Value<String?> title,
      Value<String> displayLabel,
      Value<String> actorNamesJson,
      Value<String?> code,
      Value<String?> plot,
      Value<String?> posterRelativePath,
      Value<String?> posterUri,
      Value<int?> posterLastModified,
      Value<String?> fanartRelativePath,
      Value<String?> fanartUri,
      Value<int?> fanartLastModified,
      Value<String?> folderRelativePath,
      Value<String?> primaryVideoRelativePath,
      Value<String?> primaryVideoUri,
      Value<int?> primaryVideoLastModified,
      Value<String?> nfoRelativePath,
      Value<String?> nfoUri,
      Value<String> fileName,
      Value<int?> fileSizeBytes,
      Value<String?> folderFingerprint,
      Value<int?> durationMs,
      Value<int?> width,
      Value<int?> height,
      Value<bool> isPlayable,
      Value<bool> isMissing,
      Value<DateTime> firstSeenAt,
      Value<DateTime> lastSeenAt,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
      Value<int> rowid,
    });

final class $$MediaItemsTableTableReferences
    extends
        BaseReferences<
          _$AppDatabase,
          $MediaItemsTableTable,
          MediaItemsTableData
        > {
  $$MediaItemsTableTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $MediaSourcesTableTable _sourceIdTable(_$AppDatabase db) =>
      db.mediaSourcesTable.createAlias(
        $_aliasNameGenerator(
          db.mediaItemsTable.sourceId,
          db.mediaSourcesTable.id,
        ),
      );

  $$MediaSourcesTableTableProcessedTableManager get sourceId {
    final $_column = $_itemColumn<String>('source_id')!;

    final manager = $$MediaSourcesTableTableTableManager(
      $_db,
      $_db.mediaSourcesTable,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_sourceIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$MediaItemsTableTableFilterComposer
    extends Composer<_$AppDatabase, $MediaItemsTableTable> {
  $$MediaItemsTableTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get displayLabel => $composableBuilder(
    column: $table.displayLabel,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get actorNamesJson => $composableBuilder(
    column: $table.actorNamesJson,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get code => $composableBuilder(
    column: $table.code,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get plot => $composableBuilder(
    column: $table.plot,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get posterRelativePath => $composableBuilder(
    column: $table.posterRelativePath,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get posterUri => $composableBuilder(
    column: $table.posterUri,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get posterLastModified => $composableBuilder(
    column: $table.posterLastModified,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get fanartRelativePath => $composableBuilder(
    column: $table.fanartRelativePath,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get fanartUri => $composableBuilder(
    column: $table.fanartUri,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get fanartLastModified => $composableBuilder(
    column: $table.fanartLastModified,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get folderRelativePath => $composableBuilder(
    column: $table.folderRelativePath,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get primaryVideoRelativePath => $composableBuilder(
    column: $table.primaryVideoRelativePath,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get primaryVideoUri => $composableBuilder(
    column: $table.primaryVideoUri,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get primaryVideoLastModified => $composableBuilder(
    column: $table.primaryVideoLastModified,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get nfoRelativePath => $composableBuilder(
    column: $table.nfoRelativePath,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get nfoUri => $composableBuilder(
    column: $table.nfoUri,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get fileName => $composableBuilder(
    column: $table.fileName,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get fileSizeBytes => $composableBuilder(
    column: $table.fileSizeBytes,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get folderFingerprint => $composableBuilder(
    column: $table.folderFingerprint,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get durationMs => $composableBuilder(
    column: $table.durationMs,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get width => $composableBuilder(
    column: $table.width,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get height => $composableBuilder(
    column: $table.height,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isPlayable => $composableBuilder(
    column: $table.isPlayable,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isMissing => $composableBuilder(
    column: $table.isMissing,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get firstSeenAt => $composableBuilder(
    column: $table.firstSeenAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get lastSeenAt => $composableBuilder(
    column: $table.lastSeenAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );

  $$MediaSourcesTableTableFilterComposer get sourceId {
    final $$MediaSourcesTableTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.sourceId,
      referencedTable: $db.mediaSourcesTable,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$MediaSourcesTableTableFilterComposer(
            $db: $db,
            $table: $db.mediaSourcesTable,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$MediaItemsTableTableOrderingComposer
    extends Composer<_$AppDatabase, $MediaItemsTableTable> {
  $$MediaItemsTableTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get displayLabel => $composableBuilder(
    column: $table.displayLabel,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get actorNamesJson => $composableBuilder(
    column: $table.actorNamesJson,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get code => $composableBuilder(
    column: $table.code,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get plot => $composableBuilder(
    column: $table.plot,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get posterRelativePath => $composableBuilder(
    column: $table.posterRelativePath,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get posterUri => $composableBuilder(
    column: $table.posterUri,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get posterLastModified => $composableBuilder(
    column: $table.posterLastModified,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get fanartRelativePath => $composableBuilder(
    column: $table.fanartRelativePath,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get fanartUri => $composableBuilder(
    column: $table.fanartUri,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get fanartLastModified => $composableBuilder(
    column: $table.fanartLastModified,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get folderRelativePath => $composableBuilder(
    column: $table.folderRelativePath,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get primaryVideoRelativePath => $composableBuilder(
    column: $table.primaryVideoRelativePath,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get primaryVideoUri => $composableBuilder(
    column: $table.primaryVideoUri,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get primaryVideoLastModified => $composableBuilder(
    column: $table.primaryVideoLastModified,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get nfoRelativePath => $composableBuilder(
    column: $table.nfoRelativePath,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get nfoUri => $composableBuilder(
    column: $table.nfoUri,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get fileName => $composableBuilder(
    column: $table.fileName,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get fileSizeBytes => $composableBuilder(
    column: $table.fileSizeBytes,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get folderFingerprint => $composableBuilder(
    column: $table.folderFingerprint,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get durationMs => $composableBuilder(
    column: $table.durationMs,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get width => $composableBuilder(
    column: $table.width,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get height => $composableBuilder(
    column: $table.height,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isPlayable => $composableBuilder(
    column: $table.isPlayable,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isMissing => $composableBuilder(
    column: $table.isMissing,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get firstSeenAt => $composableBuilder(
    column: $table.firstSeenAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get lastSeenAt => $composableBuilder(
    column: $table.lastSeenAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );

  $$MediaSourcesTableTableOrderingComposer get sourceId {
    final $$MediaSourcesTableTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.sourceId,
      referencedTable: $db.mediaSourcesTable,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$MediaSourcesTableTableOrderingComposer(
            $db: $db,
            $table: $db.mediaSourcesTable,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$MediaItemsTableTableAnnotationComposer
    extends Composer<_$AppDatabase, $MediaItemsTableTable> {
  $$MediaItemsTableTableAnnotationComposer({
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

  GeneratedColumn<String> get displayLabel => $composableBuilder(
    column: $table.displayLabel,
    builder: (column) => column,
  );

  GeneratedColumn<String> get actorNamesJson => $composableBuilder(
    column: $table.actorNamesJson,
    builder: (column) => column,
  );

  GeneratedColumn<String> get code =>
      $composableBuilder(column: $table.code, builder: (column) => column);

  GeneratedColumn<String> get plot =>
      $composableBuilder(column: $table.plot, builder: (column) => column);

  GeneratedColumn<String> get posterRelativePath => $composableBuilder(
    column: $table.posterRelativePath,
    builder: (column) => column,
  );

  GeneratedColumn<String> get posterUri =>
      $composableBuilder(column: $table.posterUri, builder: (column) => column);

  GeneratedColumn<int> get posterLastModified => $composableBuilder(
    column: $table.posterLastModified,
    builder: (column) => column,
  );

  GeneratedColumn<String> get fanartRelativePath => $composableBuilder(
    column: $table.fanartRelativePath,
    builder: (column) => column,
  );

  GeneratedColumn<String> get fanartUri =>
      $composableBuilder(column: $table.fanartUri, builder: (column) => column);

  GeneratedColumn<int> get fanartLastModified => $composableBuilder(
    column: $table.fanartLastModified,
    builder: (column) => column,
  );

  GeneratedColumn<String> get folderRelativePath => $composableBuilder(
    column: $table.folderRelativePath,
    builder: (column) => column,
  );

  GeneratedColumn<String> get primaryVideoRelativePath => $composableBuilder(
    column: $table.primaryVideoRelativePath,
    builder: (column) => column,
  );

  GeneratedColumn<String> get primaryVideoUri => $composableBuilder(
    column: $table.primaryVideoUri,
    builder: (column) => column,
  );

  GeneratedColumn<int> get primaryVideoLastModified => $composableBuilder(
    column: $table.primaryVideoLastModified,
    builder: (column) => column,
  );

  GeneratedColumn<String> get nfoRelativePath => $composableBuilder(
    column: $table.nfoRelativePath,
    builder: (column) => column,
  );

  GeneratedColumn<String> get nfoUri =>
      $composableBuilder(column: $table.nfoUri, builder: (column) => column);

  GeneratedColumn<String> get fileName =>
      $composableBuilder(column: $table.fileName, builder: (column) => column);

  GeneratedColumn<int> get fileSizeBytes => $composableBuilder(
    column: $table.fileSizeBytes,
    builder: (column) => column,
  );

  GeneratedColumn<String> get folderFingerprint => $composableBuilder(
    column: $table.folderFingerprint,
    builder: (column) => column,
  );

  GeneratedColumn<int> get durationMs => $composableBuilder(
    column: $table.durationMs,
    builder: (column) => column,
  );

  GeneratedColumn<int> get width =>
      $composableBuilder(column: $table.width, builder: (column) => column);

  GeneratedColumn<int> get height =>
      $composableBuilder(column: $table.height, builder: (column) => column);

  GeneratedColumn<bool> get isPlayable => $composableBuilder(
    column: $table.isPlayable,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get isMissing =>
      $composableBuilder(column: $table.isMissing, builder: (column) => column);

  GeneratedColumn<DateTime> get firstSeenAt => $composableBuilder(
    column: $table.firstSeenAt,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get lastSeenAt => $composableBuilder(
    column: $table.lastSeenAt,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  $$MediaSourcesTableTableAnnotationComposer get sourceId {
    final $$MediaSourcesTableTableAnnotationComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.sourceId,
          referencedTable: $db.mediaSourcesTable,
          getReferencedColumn: (t) => t.id,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$MediaSourcesTableTableAnnotationComposer(
                $db: $db,
                $table: $db.mediaSourcesTable,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return composer;
  }
}

class $$MediaItemsTableTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $MediaItemsTableTable,
          MediaItemsTableData,
          $$MediaItemsTableTableFilterComposer,
          $$MediaItemsTableTableOrderingComposer,
          $$MediaItemsTableTableAnnotationComposer,
          $$MediaItemsTableTableCreateCompanionBuilder,
          $$MediaItemsTableTableUpdateCompanionBuilder,
          (MediaItemsTableData, $$MediaItemsTableTableReferences),
          MediaItemsTableData,
          PrefetchHooks Function({bool sourceId})
        > {
  $$MediaItemsTableTableTableManager(
    _$AppDatabase db,
    $MediaItemsTableTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$MediaItemsTableTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$MediaItemsTableTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$MediaItemsTableTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> sourceId = const Value.absent(),
                Value<String?> title = const Value.absent(),
                Value<String> displayLabel = const Value.absent(),
                Value<String> actorNamesJson = const Value.absent(),
                Value<String?> code = const Value.absent(),
                Value<String?> plot = const Value.absent(),
                Value<String?> posterRelativePath = const Value.absent(),
                Value<String?> posterUri = const Value.absent(),
                Value<int?> posterLastModified = const Value.absent(),
                Value<String?> fanartRelativePath = const Value.absent(),
                Value<String?> fanartUri = const Value.absent(),
                Value<int?> fanartLastModified = const Value.absent(),
                Value<String?> folderRelativePath = const Value.absent(),
                Value<String?> primaryVideoRelativePath = const Value.absent(),
                Value<String?> primaryVideoUri = const Value.absent(),
                Value<int?> primaryVideoLastModified = const Value.absent(),
                Value<String?> nfoRelativePath = const Value.absent(),
                Value<String?> nfoUri = const Value.absent(),
                Value<String> fileName = const Value.absent(),
                Value<int?> fileSizeBytes = const Value.absent(),
                Value<String?> folderFingerprint = const Value.absent(),
                Value<int?> durationMs = const Value.absent(),
                Value<int?> width = const Value.absent(),
                Value<int?> height = const Value.absent(),
                Value<bool> isPlayable = const Value.absent(),
                Value<bool> isMissing = const Value.absent(),
                Value<DateTime> firstSeenAt = const Value.absent(),
                Value<DateTime> lastSeenAt = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => MediaItemsTableCompanion(
                id: id,
                sourceId: sourceId,
                title: title,
                displayLabel: displayLabel,
                actorNamesJson: actorNamesJson,
                code: code,
                plot: plot,
                posterRelativePath: posterRelativePath,
                posterUri: posterUri,
                posterLastModified: posterLastModified,
                fanartRelativePath: fanartRelativePath,
                fanartUri: fanartUri,
                fanartLastModified: fanartLastModified,
                folderRelativePath: folderRelativePath,
                primaryVideoRelativePath: primaryVideoRelativePath,
                primaryVideoUri: primaryVideoUri,
                primaryVideoLastModified: primaryVideoLastModified,
                nfoRelativePath: nfoRelativePath,
                nfoUri: nfoUri,
                fileName: fileName,
                fileSizeBytes: fileSizeBytes,
                folderFingerprint: folderFingerprint,
                durationMs: durationMs,
                width: width,
                height: height,
                isPlayable: isPlayable,
                isMissing: isMissing,
                firstSeenAt: firstSeenAt,
                lastSeenAt: lastSeenAt,
                createdAt: createdAt,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String sourceId,
                Value<String?> title = const Value.absent(),
                required String displayLabel,
                Value<String> actorNamesJson = const Value.absent(),
                Value<String?> code = const Value.absent(),
                Value<String?> plot = const Value.absent(),
                Value<String?> posterRelativePath = const Value.absent(),
                Value<String?> posterUri = const Value.absent(),
                Value<int?> posterLastModified = const Value.absent(),
                Value<String?> fanartRelativePath = const Value.absent(),
                Value<String?> fanartUri = const Value.absent(),
                Value<int?> fanartLastModified = const Value.absent(),
                Value<String?> folderRelativePath = const Value.absent(),
                Value<String?> primaryVideoRelativePath = const Value.absent(),
                Value<String?> primaryVideoUri = const Value.absent(),
                Value<int?> primaryVideoLastModified = const Value.absent(),
                Value<String?> nfoRelativePath = const Value.absent(),
                Value<String?> nfoUri = const Value.absent(),
                required String fileName,
                Value<int?> fileSizeBytes = const Value.absent(),
                Value<String?> folderFingerprint = const Value.absent(),
                Value<int?> durationMs = const Value.absent(),
                Value<int?> width = const Value.absent(),
                Value<int?> height = const Value.absent(),
                Value<bool> isPlayable = const Value.absent(),
                Value<bool> isMissing = const Value.absent(),
                required DateTime firstSeenAt,
                required DateTime lastSeenAt,
                required DateTime createdAt,
                required DateTime updatedAt,
                Value<int> rowid = const Value.absent(),
              }) => MediaItemsTableCompanion.insert(
                id: id,
                sourceId: sourceId,
                title: title,
                displayLabel: displayLabel,
                actorNamesJson: actorNamesJson,
                code: code,
                plot: plot,
                posterRelativePath: posterRelativePath,
                posterUri: posterUri,
                posterLastModified: posterLastModified,
                fanartRelativePath: fanartRelativePath,
                fanartUri: fanartUri,
                fanartLastModified: fanartLastModified,
                folderRelativePath: folderRelativePath,
                primaryVideoRelativePath: primaryVideoRelativePath,
                primaryVideoUri: primaryVideoUri,
                primaryVideoLastModified: primaryVideoLastModified,
                nfoRelativePath: nfoRelativePath,
                nfoUri: nfoUri,
                fileName: fileName,
                fileSizeBytes: fileSizeBytes,
                folderFingerprint: folderFingerprint,
                durationMs: durationMs,
                width: width,
                height: height,
                isPlayable: isPlayable,
                isMissing: isMissing,
                firstSeenAt: firstSeenAt,
                lastSeenAt: lastSeenAt,
                createdAt: createdAt,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$MediaItemsTableTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({sourceId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (sourceId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.sourceId,
                                referencedTable:
                                    $$MediaItemsTableTableReferences
                                        ._sourceIdTable(db),
                                referencedColumn:
                                    $$MediaItemsTableTableReferences
                                        ._sourceIdTable(db)
                                        .id,
                              )
                              as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$MediaItemsTableTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $MediaItemsTableTable,
      MediaItemsTableData,
      $$MediaItemsTableTableFilterComposer,
      $$MediaItemsTableTableOrderingComposer,
      $$MediaItemsTableTableAnnotationComposer,
      $$MediaItemsTableTableCreateCompanionBuilder,
      $$MediaItemsTableTableUpdateCompanionBuilder,
      (MediaItemsTableData, $$MediaItemsTableTableReferences),
      MediaItemsTableData,
      PrefetchHooks Function({bool sourceId})
    >;
typedef $$MediaUserStatesTableTableCreateCompanionBuilder =
    MediaUserStatesTableCompanion Function({
      required String mediaId,
      Value<double?> ratingValue,
      Value<int?> lastPositionMs,
      Value<int?> durationMsSnapshot,
      Value<DateTime?> lastPlayedAt,
      Value<int> playCount,
      Value<bool> isFinished,
      required DateTime updatedAt,
      Value<int> rowid,
    });
typedef $$MediaUserStatesTableTableUpdateCompanionBuilder =
    MediaUserStatesTableCompanion Function({
      Value<String> mediaId,
      Value<double?> ratingValue,
      Value<int?> lastPositionMs,
      Value<int?> durationMsSnapshot,
      Value<DateTime?> lastPlayedAt,
      Value<int> playCount,
      Value<bool> isFinished,
      Value<DateTime> updatedAt,
      Value<int> rowid,
    });

class $$MediaUserStatesTableTableFilterComposer
    extends Composer<_$AppDatabase, $MediaUserStatesTableTable> {
  $$MediaUserStatesTableTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get mediaId => $composableBuilder(
    column: $table.mediaId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get ratingValue => $composableBuilder(
    column: $table.ratingValue,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get lastPositionMs => $composableBuilder(
    column: $table.lastPositionMs,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get durationMsSnapshot => $composableBuilder(
    column: $table.durationMsSnapshot,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get lastPlayedAt => $composableBuilder(
    column: $table.lastPlayedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get playCount => $composableBuilder(
    column: $table.playCount,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isFinished => $composableBuilder(
    column: $table.isFinished,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$MediaUserStatesTableTableOrderingComposer
    extends Composer<_$AppDatabase, $MediaUserStatesTableTable> {
  $$MediaUserStatesTableTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get mediaId => $composableBuilder(
    column: $table.mediaId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get ratingValue => $composableBuilder(
    column: $table.ratingValue,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get lastPositionMs => $composableBuilder(
    column: $table.lastPositionMs,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get durationMsSnapshot => $composableBuilder(
    column: $table.durationMsSnapshot,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get lastPlayedAt => $composableBuilder(
    column: $table.lastPlayedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get playCount => $composableBuilder(
    column: $table.playCount,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isFinished => $composableBuilder(
    column: $table.isFinished,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$MediaUserStatesTableTableAnnotationComposer
    extends Composer<_$AppDatabase, $MediaUserStatesTableTable> {
  $$MediaUserStatesTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get mediaId =>
      $composableBuilder(column: $table.mediaId, builder: (column) => column);

  GeneratedColumn<double> get ratingValue => $composableBuilder(
    column: $table.ratingValue,
    builder: (column) => column,
  );

  GeneratedColumn<int> get lastPositionMs => $composableBuilder(
    column: $table.lastPositionMs,
    builder: (column) => column,
  );

  GeneratedColumn<int> get durationMsSnapshot => $composableBuilder(
    column: $table.durationMsSnapshot,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get lastPlayedAt => $composableBuilder(
    column: $table.lastPlayedAt,
    builder: (column) => column,
  );

  GeneratedColumn<int> get playCount =>
      $composableBuilder(column: $table.playCount, builder: (column) => column);

  GeneratedColumn<bool> get isFinished => $composableBuilder(
    column: $table.isFinished,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);
}

class $$MediaUserStatesTableTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $MediaUserStatesTableTable,
          MediaUserStatesTableData,
          $$MediaUserStatesTableTableFilterComposer,
          $$MediaUserStatesTableTableOrderingComposer,
          $$MediaUserStatesTableTableAnnotationComposer,
          $$MediaUserStatesTableTableCreateCompanionBuilder,
          $$MediaUserStatesTableTableUpdateCompanionBuilder,
          (
            MediaUserStatesTableData,
            BaseReferences<
              _$AppDatabase,
              $MediaUserStatesTableTable,
              MediaUserStatesTableData
            >,
          ),
          MediaUserStatesTableData,
          PrefetchHooks Function()
        > {
  $$MediaUserStatesTableTableTableManager(
    _$AppDatabase db,
    $MediaUserStatesTableTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$MediaUserStatesTableTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$MediaUserStatesTableTableOrderingComposer(
                $db: db,
                $table: table,
              ),
          createComputedFieldComposer: () =>
              $$MediaUserStatesTableTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<String> mediaId = const Value.absent(),
                Value<double?> ratingValue = const Value.absent(),
                Value<int?> lastPositionMs = const Value.absent(),
                Value<int?> durationMsSnapshot = const Value.absent(),
                Value<DateTime?> lastPlayedAt = const Value.absent(),
                Value<int> playCount = const Value.absent(),
                Value<bool> isFinished = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => MediaUserStatesTableCompanion(
                mediaId: mediaId,
                ratingValue: ratingValue,
                lastPositionMs: lastPositionMs,
                durationMsSnapshot: durationMsSnapshot,
                lastPlayedAt: lastPlayedAt,
                playCount: playCount,
                isFinished: isFinished,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String mediaId,
                Value<double?> ratingValue = const Value.absent(),
                Value<int?> lastPositionMs = const Value.absent(),
                Value<int?> durationMsSnapshot = const Value.absent(),
                Value<DateTime?> lastPlayedAt = const Value.absent(),
                Value<int> playCount = const Value.absent(),
                Value<bool> isFinished = const Value.absent(),
                required DateTime updatedAt,
                Value<int> rowid = const Value.absent(),
              }) => MediaUserStatesTableCompanion.insert(
                mediaId: mediaId,
                ratingValue: ratingValue,
                lastPositionMs: lastPositionMs,
                durationMsSnapshot: durationMsSnapshot,
                lastPlayedAt: lastPlayedAt,
                playCount: playCount,
                isFinished: isFinished,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$MediaUserStatesTableTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $MediaUserStatesTableTable,
      MediaUserStatesTableData,
      $$MediaUserStatesTableTableFilterComposer,
      $$MediaUserStatesTableTableOrderingComposer,
      $$MediaUserStatesTableTableAnnotationComposer,
      $$MediaUserStatesTableTableCreateCompanionBuilder,
      $$MediaUserStatesTableTableUpdateCompanionBuilder,
      (
        MediaUserStatesTableData,
        BaseReferences<
          _$AppDatabase,
          $MediaUserStatesTableTable,
          MediaUserStatesTableData
        >,
      ),
      MediaUserStatesTableData,
      PrefetchHooks Function()
    >;
typedef $$AppSettingsTableTableCreateCompanionBuilder =
    AppSettingsTableCompanion Function({
      Value<int> id,
      Value<bool> preferExternalPlayer,
      Value<int> seekBackwardSeconds,
      Value<int> seekForwardSeconds,
      Value<double> holdSpeed,
      Value<bool> rememberPlaybackSpeed,
      Value<bool> keepResumeHistory,
      Value<bool> showRecentActivity,
      required DateTime updatedAt,
    });
typedef $$AppSettingsTableTableUpdateCompanionBuilder =
    AppSettingsTableCompanion Function({
      Value<int> id,
      Value<bool> preferExternalPlayer,
      Value<int> seekBackwardSeconds,
      Value<int> seekForwardSeconds,
      Value<double> holdSpeed,
      Value<bool> rememberPlaybackSpeed,
      Value<bool> keepResumeHistory,
      Value<bool> showRecentActivity,
      Value<DateTime> updatedAt,
    });

class $$AppSettingsTableTableFilterComposer
    extends Composer<_$AppDatabase, $AppSettingsTableTable> {
  $$AppSettingsTableTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get preferExternalPlayer => $composableBuilder(
    column: $table.preferExternalPlayer,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get seekBackwardSeconds => $composableBuilder(
    column: $table.seekBackwardSeconds,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get seekForwardSeconds => $composableBuilder(
    column: $table.seekForwardSeconds,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get holdSpeed => $composableBuilder(
    column: $table.holdSpeed,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get rememberPlaybackSpeed => $composableBuilder(
    column: $table.rememberPlaybackSpeed,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get keepResumeHistory => $composableBuilder(
    column: $table.keepResumeHistory,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get showRecentActivity => $composableBuilder(
    column: $table.showRecentActivity,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$AppSettingsTableTableOrderingComposer
    extends Composer<_$AppDatabase, $AppSettingsTableTable> {
  $$AppSettingsTableTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get preferExternalPlayer => $composableBuilder(
    column: $table.preferExternalPlayer,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get seekBackwardSeconds => $composableBuilder(
    column: $table.seekBackwardSeconds,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get seekForwardSeconds => $composableBuilder(
    column: $table.seekForwardSeconds,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get holdSpeed => $composableBuilder(
    column: $table.holdSpeed,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get rememberPlaybackSpeed => $composableBuilder(
    column: $table.rememberPlaybackSpeed,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get keepResumeHistory => $composableBuilder(
    column: $table.keepResumeHistory,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get showRecentActivity => $composableBuilder(
    column: $table.showRecentActivity,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$AppSettingsTableTableAnnotationComposer
    extends Composer<_$AppDatabase, $AppSettingsTableTable> {
  $$AppSettingsTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<bool> get preferExternalPlayer => $composableBuilder(
    column: $table.preferExternalPlayer,
    builder: (column) => column,
  );

  GeneratedColumn<int> get seekBackwardSeconds => $composableBuilder(
    column: $table.seekBackwardSeconds,
    builder: (column) => column,
  );

  GeneratedColumn<int> get seekForwardSeconds => $composableBuilder(
    column: $table.seekForwardSeconds,
    builder: (column) => column,
  );

  GeneratedColumn<double> get holdSpeed =>
      $composableBuilder(column: $table.holdSpeed, builder: (column) => column);

  GeneratedColumn<bool> get rememberPlaybackSpeed => $composableBuilder(
    column: $table.rememberPlaybackSpeed,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get keepResumeHistory => $composableBuilder(
    column: $table.keepResumeHistory,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get showRecentActivity => $composableBuilder(
    column: $table.showRecentActivity,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);
}

class $$AppSettingsTableTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $AppSettingsTableTable,
          AppSettingsTableData,
          $$AppSettingsTableTableFilterComposer,
          $$AppSettingsTableTableOrderingComposer,
          $$AppSettingsTableTableAnnotationComposer,
          $$AppSettingsTableTableCreateCompanionBuilder,
          $$AppSettingsTableTableUpdateCompanionBuilder,
          (
            AppSettingsTableData,
            BaseReferences<
              _$AppDatabase,
              $AppSettingsTableTable,
              AppSettingsTableData
            >,
          ),
          AppSettingsTableData,
          PrefetchHooks Function()
        > {
  $$AppSettingsTableTableTableManager(
    _$AppDatabase db,
    $AppSettingsTableTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$AppSettingsTableTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$AppSettingsTableTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$AppSettingsTableTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<bool> preferExternalPlayer = const Value.absent(),
                Value<int> seekBackwardSeconds = const Value.absent(),
                Value<int> seekForwardSeconds = const Value.absent(),
                Value<double> holdSpeed = const Value.absent(),
                Value<bool> rememberPlaybackSpeed = const Value.absent(),
                Value<bool> keepResumeHistory = const Value.absent(),
                Value<bool> showRecentActivity = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
              }) => AppSettingsTableCompanion(
                id: id,
                preferExternalPlayer: preferExternalPlayer,
                seekBackwardSeconds: seekBackwardSeconds,
                seekForwardSeconds: seekForwardSeconds,
                holdSpeed: holdSpeed,
                rememberPlaybackSpeed: rememberPlaybackSpeed,
                keepResumeHistory: keepResumeHistory,
                showRecentActivity: showRecentActivity,
                updatedAt: updatedAt,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<bool> preferExternalPlayer = const Value.absent(),
                Value<int> seekBackwardSeconds = const Value.absent(),
                Value<int> seekForwardSeconds = const Value.absent(),
                Value<double> holdSpeed = const Value.absent(),
                Value<bool> rememberPlaybackSpeed = const Value.absent(),
                Value<bool> keepResumeHistory = const Value.absent(),
                Value<bool> showRecentActivity = const Value.absent(),
                required DateTime updatedAt,
              }) => AppSettingsTableCompanion.insert(
                id: id,
                preferExternalPlayer: preferExternalPlayer,
                seekBackwardSeconds: seekBackwardSeconds,
                seekForwardSeconds: seekForwardSeconds,
                holdSpeed: holdSpeed,
                rememberPlaybackSpeed: rememberPlaybackSpeed,
                keepResumeHistory: keepResumeHistory,
                showRecentActivity: showRecentActivity,
                updatedAt: updatedAt,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$AppSettingsTableTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $AppSettingsTableTable,
      AppSettingsTableData,
      $$AppSettingsTableTableFilterComposer,
      $$AppSettingsTableTableOrderingComposer,
      $$AppSettingsTableTableAnnotationComposer,
      $$AppSettingsTableTableCreateCompanionBuilder,
      $$AppSettingsTableTableUpdateCompanionBuilder,
      (
        AppSettingsTableData,
        BaseReferences<
          _$AppDatabase,
          $AppSettingsTableTable,
          AppSettingsTableData
        >,
      ),
      AppSettingsTableData,
      PrefetchHooks Function()
    >;
typedef $$ScanSessionsTableTableCreateCompanionBuilder =
    ScanSessionsTableCompanion Function({
      required String id,
      required String sourceId,
      required String scanType,
      required String status,
      required DateTime startedAt,
      Value<DateTime?> finishedAt,
      Value<int> itemsFound,
      Value<int> itemsUpdated,
      Value<int> itemsMissing,
      Value<String?> errorMessage,
      Value<int> rowid,
    });
typedef $$ScanSessionsTableTableUpdateCompanionBuilder =
    ScanSessionsTableCompanion Function({
      Value<String> id,
      Value<String> sourceId,
      Value<String> scanType,
      Value<String> status,
      Value<DateTime> startedAt,
      Value<DateTime?> finishedAt,
      Value<int> itemsFound,
      Value<int> itemsUpdated,
      Value<int> itemsMissing,
      Value<String?> errorMessage,
      Value<int> rowid,
    });

final class $$ScanSessionsTableTableReferences
    extends
        BaseReferences<
          _$AppDatabase,
          $ScanSessionsTableTable,
          ScanSessionsTableData
        > {
  $$ScanSessionsTableTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $MediaSourcesTableTable _sourceIdTable(_$AppDatabase db) =>
      db.mediaSourcesTable.createAlias(
        $_aliasNameGenerator(
          db.scanSessionsTable.sourceId,
          db.mediaSourcesTable.id,
        ),
      );

  $$MediaSourcesTableTableProcessedTableManager get sourceId {
    final $_column = $_itemColumn<String>('source_id')!;

    final manager = $$MediaSourcesTableTableTableManager(
      $_db,
      $_db.mediaSourcesTable,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_sourceIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$ScanSessionsTableTableFilterComposer
    extends Composer<_$AppDatabase, $ScanSessionsTableTable> {
  $$ScanSessionsTableTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get scanType => $composableBuilder(
    column: $table.scanType,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get startedAt => $composableBuilder(
    column: $table.startedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get finishedAt => $composableBuilder(
    column: $table.finishedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get itemsFound => $composableBuilder(
    column: $table.itemsFound,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get itemsUpdated => $composableBuilder(
    column: $table.itemsUpdated,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get itemsMissing => $composableBuilder(
    column: $table.itemsMissing,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get errorMessage => $composableBuilder(
    column: $table.errorMessage,
    builder: (column) => ColumnFilters(column),
  );

  $$MediaSourcesTableTableFilterComposer get sourceId {
    final $$MediaSourcesTableTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.sourceId,
      referencedTable: $db.mediaSourcesTable,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$MediaSourcesTableTableFilterComposer(
            $db: $db,
            $table: $db.mediaSourcesTable,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$ScanSessionsTableTableOrderingComposer
    extends Composer<_$AppDatabase, $ScanSessionsTableTable> {
  $$ScanSessionsTableTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get scanType => $composableBuilder(
    column: $table.scanType,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get startedAt => $composableBuilder(
    column: $table.startedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get finishedAt => $composableBuilder(
    column: $table.finishedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get itemsFound => $composableBuilder(
    column: $table.itemsFound,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get itemsUpdated => $composableBuilder(
    column: $table.itemsUpdated,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get itemsMissing => $composableBuilder(
    column: $table.itemsMissing,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get errorMessage => $composableBuilder(
    column: $table.errorMessage,
    builder: (column) => ColumnOrderings(column),
  );

  $$MediaSourcesTableTableOrderingComposer get sourceId {
    final $$MediaSourcesTableTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.sourceId,
      referencedTable: $db.mediaSourcesTable,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$MediaSourcesTableTableOrderingComposer(
            $db: $db,
            $table: $db.mediaSourcesTable,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$ScanSessionsTableTableAnnotationComposer
    extends Composer<_$AppDatabase, $ScanSessionsTableTable> {
  $$ScanSessionsTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get scanType =>
      $composableBuilder(column: $table.scanType, builder: (column) => column);

  GeneratedColumn<String> get status =>
      $composableBuilder(column: $table.status, builder: (column) => column);

  GeneratedColumn<DateTime> get startedAt =>
      $composableBuilder(column: $table.startedAt, builder: (column) => column);

  GeneratedColumn<DateTime> get finishedAt => $composableBuilder(
    column: $table.finishedAt,
    builder: (column) => column,
  );

  GeneratedColumn<int> get itemsFound => $composableBuilder(
    column: $table.itemsFound,
    builder: (column) => column,
  );

  GeneratedColumn<int> get itemsUpdated => $composableBuilder(
    column: $table.itemsUpdated,
    builder: (column) => column,
  );

  GeneratedColumn<int> get itemsMissing => $composableBuilder(
    column: $table.itemsMissing,
    builder: (column) => column,
  );

  GeneratedColumn<String> get errorMessage => $composableBuilder(
    column: $table.errorMessage,
    builder: (column) => column,
  );

  $$MediaSourcesTableTableAnnotationComposer get sourceId {
    final $$MediaSourcesTableTableAnnotationComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.sourceId,
          referencedTable: $db.mediaSourcesTable,
          getReferencedColumn: (t) => t.id,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$MediaSourcesTableTableAnnotationComposer(
                $db: $db,
                $table: $db.mediaSourcesTable,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return composer;
  }
}

class $$ScanSessionsTableTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $ScanSessionsTableTable,
          ScanSessionsTableData,
          $$ScanSessionsTableTableFilterComposer,
          $$ScanSessionsTableTableOrderingComposer,
          $$ScanSessionsTableTableAnnotationComposer,
          $$ScanSessionsTableTableCreateCompanionBuilder,
          $$ScanSessionsTableTableUpdateCompanionBuilder,
          (ScanSessionsTableData, $$ScanSessionsTableTableReferences),
          ScanSessionsTableData,
          PrefetchHooks Function({bool sourceId})
        > {
  $$ScanSessionsTableTableTableManager(
    _$AppDatabase db,
    $ScanSessionsTableTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ScanSessionsTableTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ScanSessionsTableTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ScanSessionsTableTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> sourceId = const Value.absent(),
                Value<String> scanType = const Value.absent(),
                Value<String> status = const Value.absent(),
                Value<DateTime> startedAt = const Value.absent(),
                Value<DateTime?> finishedAt = const Value.absent(),
                Value<int> itemsFound = const Value.absent(),
                Value<int> itemsUpdated = const Value.absent(),
                Value<int> itemsMissing = const Value.absent(),
                Value<String?> errorMessage = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => ScanSessionsTableCompanion(
                id: id,
                sourceId: sourceId,
                scanType: scanType,
                status: status,
                startedAt: startedAt,
                finishedAt: finishedAt,
                itemsFound: itemsFound,
                itemsUpdated: itemsUpdated,
                itemsMissing: itemsMissing,
                errorMessage: errorMessage,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String sourceId,
                required String scanType,
                required String status,
                required DateTime startedAt,
                Value<DateTime?> finishedAt = const Value.absent(),
                Value<int> itemsFound = const Value.absent(),
                Value<int> itemsUpdated = const Value.absent(),
                Value<int> itemsMissing = const Value.absent(),
                Value<String?> errorMessage = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => ScanSessionsTableCompanion.insert(
                id: id,
                sourceId: sourceId,
                scanType: scanType,
                status: status,
                startedAt: startedAt,
                finishedAt: finishedAt,
                itemsFound: itemsFound,
                itemsUpdated: itemsUpdated,
                itemsMissing: itemsMissing,
                errorMessage: errorMessage,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$ScanSessionsTableTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({sourceId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (sourceId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.sourceId,
                                referencedTable:
                                    $$ScanSessionsTableTableReferences
                                        ._sourceIdTable(db),
                                referencedColumn:
                                    $$ScanSessionsTableTableReferences
                                        ._sourceIdTable(db)
                                        .id,
                              )
                              as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$ScanSessionsTableTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $ScanSessionsTableTable,
      ScanSessionsTableData,
      $$ScanSessionsTableTableFilterComposer,
      $$ScanSessionsTableTableOrderingComposer,
      $$ScanSessionsTableTableAnnotationComposer,
      $$ScanSessionsTableTableCreateCompanionBuilder,
      $$ScanSessionsTableTableUpdateCompanionBuilder,
      (ScanSessionsTableData, $$ScanSessionsTableTableReferences),
      ScanSessionsTableData,
      PrefetchHooks Function({bool sourceId})
    >;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$MediaSourcesTableTableTableManager get mediaSourcesTable =>
      $$MediaSourcesTableTableTableManager(_db, _db.mediaSourcesTable);
  $$MediaItemsTableTableTableManager get mediaItemsTable =>
      $$MediaItemsTableTableTableManager(_db, _db.mediaItemsTable);
  $$MediaUserStatesTableTableTableManager get mediaUserStatesTable =>
      $$MediaUserStatesTableTableTableManager(_db, _db.mediaUserStatesTable);
  $$AppSettingsTableTableTableManager get appSettingsTable =>
      $$AppSettingsTableTableTableManager(_db, _db.appSettingsTable);
  $$ScanSessionsTableTableTableManager get scanSessionsTable =>
      $$ScanSessionsTableTableTableManager(_db, _db.scanSessionsTable);
}
