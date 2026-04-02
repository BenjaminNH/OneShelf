import 'package:drift/drift.dart';
import 'package:drift_flutter/drift_flutter.dart';

part 'app_database.g.dart';

class MediaSourcesTable extends Table {
  TextColumn get id => text()();

  TextColumn get displayName => text()();

  TextColumn get rootUri => text().unique()();

  TextColumn get rootRelativeKey => text()();

  TextColumn get sourceType => text()();

  TextColumn get permissionStatus => text()();

  TextColumn get lastScanStatus => text()();

  BoolColumn get isEnabled => boolean().withDefault(const Constant(true))();

  IntColumn get mediaCount => integer().withDefault(const Constant(0))();

  DateTimeColumn get lastScanStartedAt => dateTime().nullable()();

  DateTimeColumn get lastScanFinishedAt => dateTime().nullable()();

  TextColumn get lastError => text().nullable()();

  DateTimeColumn get createdAt => dateTime()();

  DateTimeColumn get updatedAt => dateTime()();

  @override
  Set<Column<Object>> get primaryKey => {id};
}

class MediaItemsTable extends Table {
  TextColumn get id => text()();

  TextColumn get sourceId =>
      text().references(MediaSourcesTable, #id, onDelete: KeyAction.cascade)();

  TextColumn get title => text().nullable()();

  TextColumn get displayLabel => text()();

  TextColumn get actorNamesJson => text().withDefault(const Constant('[]'))();

  TextColumn get code => text().nullable()();

  TextColumn get plot => text().nullable()();

  TextColumn get posterRelativePath => text().nullable()();

  TextColumn get fanartRelativePath => text().nullable()();

  TextColumn get folderRelativePath => text().nullable()();

  TextColumn get primaryVideoRelativePath => text().nullable()();

  TextColumn get nfoRelativePath => text().nullable()();

  TextColumn get fileName => text()();

  IntColumn get fileSizeBytes => integer().nullable()();

  IntColumn get durationMs => integer().nullable()();

  IntColumn get width => integer().nullable()();

  IntColumn get height => integer().nullable()();

  BoolColumn get isPlayable => boolean().withDefault(const Constant(true))();

  BoolColumn get isMissing => boolean().withDefault(const Constant(false))();

  DateTimeColumn get firstSeenAt => dateTime()();

  DateTimeColumn get lastSeenAt => dateTime()();

  DateTimeColumn get createdAt => dateTime()();

  DateTimeColumn get updatedAt => dateTime()();

  @override
  Set<Column<Object>> get primaryKey => {id};

  List<Index> get indexes => [
    Index(
      'media_items_source_status_idx',
      'CREATE INDEX IF NOT EXISTS media_items_source_status_idx ON media_items_table (source_id, is_missing)',
    ),
    Index(
      'media_items_file_name_idx',
      'CREATE INDEX IF NOT EXISTS media_items_file_name_idx ON media_items_table (file_name)',
    ),
  ];
}

class MediaUserStatesTable extends Table {
  TextColumn get mediaId => text()();

  RealColumn get ratingValue => real().nullable()();

  IntColumn get lastPositionMs => integer().nullable()();

  IntColumn get durationMsSnapshot => integer().nullable()();

  DateTimeColumn get lastPlayedAt => dateTime().nullable()();

  IntColumn get playCount => integer().withDefault(const Constant(0))();

  BoolColumn get isFinished => boolean().withDefault(const Constant(false))();

  DateTimeColumn get updatedAt => dateTime()();

  @override
  Set<Column<Object>> get primaryKey => {mediaId};

  List<Index> get indexes => [
    Index(
      'media_user_state_last_played_idx',
      'CREATE INDEX IF NOT EXISTS media_user_state_last_played_idx ON media_user_states_table (last_played_at)',
    ),
  ];
}

class AppSettingsTable extends Table {
  IntColumn get id => integer().withDefault(const Constant(1))();

  BoolColumn get preferExternalPlayer =>
      boolean().withDefault(const Constant(false))();

  IntColumn get seekBackwardSeconds =>
      integer().withDefault(const Constant(10))();

  IntColumn get seekForwardSeconds =>
      integer().withDefault(const Constant(10))();

  RealColumn get holdSpeed => real().withDefault(const Constant(2.0))();

  BoolColumn get rememberPlaybackSpeed =>
      boolean().withDefault(const Constant(true))();

  BoolColumn get keepResumeHistory =>
      boolean().withDefault(const Constant(true))();

  BoolColumn get showRecentActivity =>
      boolean().withDefault(const Constant(true))();

  DateTimeColumn get updatedAt => dateTime()();

  @override
  Set<Column<Object>> get primaryKey => {id};
}

class ScanSessionsTable extends Table {
  TextColumn get id => text()();

  TextColumn get sourceId =>
      text().references(MediaSourcesTable, #id, onDelete: KeyAction.cascade)();

  TextColumn get scanType => text()();

  TextColumn get status => text()();

  DateTimeColumn get startedAt => dateTime()();

  DateTimeColumn get finishedAt => dateTime().nullable()();

  IntColumn get itemsFound => integer().withDefault(const Constant(0))();

  IntColumn get itemsUpdated => integer().withDefault(const Constant(0))();

  IntColumn get itemsMissing => integer().withDefault(const Constant(0))();

  TextColumn get errorMessage => text().nullable()();

  @override
  Set<Column<Object>> get primaryKey => {id};
}

@DriftDatabase(
  tables: [
    MediaSourcesTable,
    MediaItemsTable,
    MediaUserStatesTable,
    AppSettingsTable,
    ScanSessionsTable,
  ],
)
class AppDatabase extends _$AppDatabase {
  AppDatabase([QueryExecutor? executor])
    : super(executor ?? _openDefaultConnection());

  static QueryExecutor _openDefaultConnection() =>
      driftDatabase(name: 'oneshelf.sqlite');

  @override
  int get schemaVersion => 2;

  @override
  MigrationStrategy get migration => MigrationStrategy(
    onCreate: (m) async {
      await m.createAll();
    },
    onUpgrade: (m, from, to) async {
      if (from < 2) {
        await m.addColumn(
          appSettingsTable,
          appSettingsTable.showRecentActivity,
        );
      }
    },
    beforeOpen: (details) async {
      await customStatement('PRAGMA foreign_keys = ON');
    },
  );
}
