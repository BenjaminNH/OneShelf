import 'package:drift/drift.dart' hide isNull;
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:one_shelf/src/data/database/app_database.dart';
import 'package:one_shelf/src/features/metadata/metadata_prefill_service.dart';
import 'package:one_shelf/src/shared/debug/app_debug_logger.dart';
import 'package:one_shelf/src/shared/media/local_video_metadata.dart';

class MockLocalVideoMetadataReader extends Mock
    implements LocalVideoMetadataReader {}

class MockAppDebugLogger extends Mock implements AppDebugLogger {}

void main() {
  late AppDatabase database;
  late MockLocalVideoMetadataReader mockReader;
  late MockAppDebugLogger mockLogger;

  setUp(() {
    database = AppDatabase(NativeDatabase.memory());
    mockReader = MockLocalVideoMetadataReader();
    mockLogger = MockAppDebugLogger();
  });

  tearDown(() async {
    await database.close();
  });

  Future<void> insertTestSource(AppDatabase db) async {
    final now = DateTime.now();
    await db
        .into(db.mediaSourcesTable)
        .insert(
          MediaSourcesTableCompanion.insert(
            id: 'source-1',
            displayName: 'Test Source',
            rootUri: 'file:///test',
            rootRelativeKey: 'test',
            sourceType: 'local',
            permissionStatus: 'granted',
            lastScanStatus: 'completed',
            createdAt: now,
            updatedAt: now,
          ),
        );
  }

  group('MetadataPrefillService', () {
    test(
      'getItemsNeedingMetadata returns items with missing durationMs',
      () async {
        final now = DateTime.now();
        await insertTestSource(database);

        await database
            .into(database.mediaItemsTable)
            .insert(
              MediaItemsTableCompanion.insert(
                id: 'item-1',
                sourceId: 'source-1',
                displayLabel: 'Video 1',
                fileName: 'video1.mp4',
                primaryVideoUri: const Value('file:///test/video1.mp4'),
                durationMs: const Value(null),
                width: const Value(null),
                height: const Value(null),
                firstSeenAt: now,
                lastSeenAt: now,
                createdAt: now,
                updatedAt: now,
              ),
            );

        await database
            .into(database.mediaItemsTable)
            .insert(
              MediaItemsTableCompanion.insert(
                id: 'item-2',
                sourceId: 'source-1',
                displayLabel: 'Video 2',
                fileName: 'video2.mp4',
                primaryVideoUri: const Value('file:///test/video2.mp4'),
                durationMs: const Value(3600000),
                width: const Value(1920),
                height: const Value(1080),
                firstSeenAt: now,
                lastSeenAt: now,
                createdAt: now,
                updatedAt: now,
              ),
            );

        final service = MetadataPrefillService(
          database: database,
          metadataReader: mockReader,
          logger: mockLogger,
        );

        final items = await service.getItemsNeedingMetadata();

        expect(items.length, 1);
        expect(items.first.id, 'item-1');
      },
    );

    test(
      'getItemsNeedingMetadata returns items with missing width or height',
      () async {
        final now = DateTime.now();
        await insertTestSource(database);

        await database
            .into(database.mediaItemsTable)
            .insert(
              MediaItemsTableCompanion.insert(
                id: 'item-3',
                sourceId: 'source-1',
                displayLabel: 'Video 3',
                fileName: 'video3.mp4',
                primaryVideoUri: const Value('file:///test/video3.mp4'),
                durationMs: const Value(3600000),
                width: const Value(null),
                height: const Value(1080),
                firstSeenAt: now,
                lastSeenAt: now,
                createdAt: now,
                updatedAt: now,
              ),
            );

        final service = MetadataPrefillService(
          database: database,
          metadataReader: mockReader,
          logger: mockLogger,
        );

        final items = await service.getItemsNeedingMetadata();

        expect(items.length, 1);
        expect(items.first.id, 'item-3');
      },
    );

    test(
      'getItemsNeedingMetadata excludes items without primaryVideoUri',
      () async {
        final now = DateTime.now();
        await insertTestSource(database);

        await database
            .into(database.mediaItemsTable)
            .insert(
              MediaItemsTableCompanion.insert(
                id: 'item-4',
                sourceId: 'source-1',
                displayLabel: 'Video 4',
                fileName: 'video4.mp4',
                primaryVideoUri: const Value(null),
                durationMs: const Value(null),
                width: const Value(null),
                height: const Value(null),
                firstSeenAt: now,
                lastSeenAt: now,
                createdAt: now,
                updatedAt: now,
              ),
            );

        final service = MetadataPrefillService(
          database: database,
          metadataReader: mockReader,
          logger: mockLogger,
        );

        final items = await service.getItemsNeedingMetadata();

        expect(items.length, 0);
      },
    );

    test(
      'prefillMissingMetadata updates database with fetched metadata',
      () async {
        final now = DateTime.now();
        await insertTestSource(database);

        await database
            .into(database.mediaItemsTable)
            .insert(
              MediaItemsTableCompanion.insert(
                id: 'item-1',
                sourceId: 'source-1',
                displayLabel: 'Video 1',
                fileName: 'video1.mp4',
                primaryVideoUri: const Value('file:///test/video1.mp4'),
                durationMs: const Value(null),
                width: const Value(null),
                height: const Value(null),
                firstSeenAt: now,
                lastSeenAt: now,
                createdAt: now,
                updatedAt: now,
              ),
            );

        when(() => mockReader.read('file:///test/video1.mp4')).thenAnswer(
          (_) async => const LocalVideoMetadata(
            durationMs: 3600000,
            width: 1920,
            height: 1080,
          ),
        );

        when(
          () => mockLogger.log(
            scope: any(named: 'scope'),
            event: any(named: 'event'),
            fields: any(named: 'fields'),
          ),
        ).thenAnswer((_) async {});

        final service = MetadataPrefillService(
          database: database,
          metadataReader: mockReader,
          logger: mockLogger,
        );

        await service.prefillMissingMetadata();

        final updated = await (database.select(
          database.mediaItemsTable,
        )..where((tbl) => tbl.id.equals('item-1'))).getSingle();

        expect(updated.durationMs, 3600000);
        expect(updated.width, 1920);
        expect(updated.height, 1080);

        verify(() => mockReader.read('file:///test/video1.mp4')).called(1);
      },
    );

    test(
      'prefillMissingMetadata processes multiple items sequentially',
      () async {
        final now = DateTime.now();
        await insertTestSource(database);

        await database
            .into(database.mediaItemsTable)
            .insert(
              MediaItemsTableCompanion.insert(
                id: 'item-1',
                sourceId: 'source-1',
                displayLabel: 'Video 1',
                fileName: 'video1.mp4',
                primaryVideoUri: const Value('file:///test/video1.mp4'),
                durationMs: const Value(null),
                width: const Value(null),
                height: const Value(null),
                firstSeenAt: now,
                lastSeenAt: now,
                createdAt: now,
                updatedAt: now,
              ),
            );

        await database
            .into(database.mediaItemsTable)
            .insert(
              MediaItemsTableCompanion.insert(
                id: 'item-2',
                sourceId: 'source-1',
                displayLabel: 'Video 2',
                fileName: 'video2.mp4',
                primaryVideoUri: const Value('file:///test/video2.mp4'),
                durationMs: const Value(null),
                width: const Value(null),
                height: const Value(null),
                firstSeenAt: now,
                lastSeenAt: now,
                createdAt: now,
                updatedAt: now,
              ),
            );

        when(() => mockReader.read('file:///test/video1.mp4')).thenAnswer(
          (_) async => const LocalVideoMetadata(
            durationMs: 1800000,
            width: 1280,
            height: 720,
          ),
        );

        when(() => mockReader.read('file:///test/video2.mp4')).thenAnswer(
          (_) async => const LocalVideoMetadata(
            durationMs: 3600000,
            width: 1920,
            height: 1080,
          ),
        );

        when(
          () => mockLogger.log(
            scope: any(named: 'scope'),
            event: any(named: 'event'),
            fields: any(named: 'fields'),
          ),
        ).thenAnswer((_) async {});

        final service = MetadataPrefillService(
          database: database,
          metadataReader: mockReader,
          logger: mockLogger,
        );

        await service.prefillMissingMetadata();

        final items = await database.select(database.mediaItemsTable).get();
        expect(items.length, 2);

        final item1 = items.firstWhere((i) => i.id == 'item-1');
        expect(item1.durationMs, 1800000);
        expect(item1.width, 1280);
        expect(item1.height, 720);

        final item2 = items.firstWhere((i) => i.id == 'item-2');
        expect(item2.durationMs, 3600000);
        expect(item2.width, 1920);
        expect(item2.height, 1080);
      },
    );

    test(
      'prefillMissingMetadata handles reader returning null gracefully',
      () async {
        final now = DateTime.now();
        await insertTestSource(database);

        await database
            .into(database.mediaItemsTable)
            .insert(
              MediaItemsTableCompanion.insert(
                id: 'item-1',
                sourceId: 'source-1',
                displayLabel: 'Video 1',
                fileName: 'video1.mp4',
                primaryVideoUri: const Value('file:///test/video1.mp4'),
                durationMs: const Value(null),
                width: const Value(null),
                height: const Value(null),
                firstSeenAt: now,
                lastSeenAt: now,
                createdAt: now,
                updatedAt: now,
              ),
            );

        when(
          () => mockReader.read('file:///test/video1.mp4'),
        ).thenAnswer((_) async => null);

        when(
          () => mockLogger.log(
            scope: any(named: 'scope'),
            event: any(named: 'event'),
            fields: any(named: 'fields'),
          ),
        ).thenAnswer((_) async {});

        final service = MetadataPrefillService(
          database: database,
          metadataReader: mockReader,
          logger: mockLogger,
        );

        await service.prefillMissingMetadata();

        final unchanged = await (database.select(
          database.mediaItemsTable,
        )..where((tbl) => tbl.id.equals('item-1'))).getSingle();

        expect(unchanged.durationMs, isNull);
        expect(unchanged.width, isNull);
        expect(unchanged.height, isNull);
      },
    );

    test(
      'prefillMissingMetadata skips items already having all metadata',
      () async {
        final now = DateTime.now();
        await insertTestSource(database);

        await database
            .into(database.mediaItemsTable)
            .insert(
              MediaItemsTableCompanion.insert(
                id: 'item-complete',
                sourceId: 'source-1',
                displayLabel: 'Complete Video',
                fileName: 'complete.mp4',
                primaryVideoUri: const Value('file:///test/complete.mp4'),
                durationMs: const Value(3600000),
                width: const Value(1920),
                height: const Value(1080),
                firstSeenAt: now,
                lastSeenAt: now,
                createdAt: now,
                updatedAt: now,
              ),
            );

        when(
          () => mockLogger.log(
            scope: any(named: 'scope'),
            event: any(named: 'event'),
            fields: any(named: 'fields'),
          ),
        ).thenAnswer((_) async {});

        final service = MetadataPrefillService(
          database: database,
          metadataReader: mockReader,
          logger: mockLogger,
        );

        await service.prefillMissingMetadata();

        verifyNever(() => mockReader.read(any()));
      },
    );

    test('prefillMissingMetadata does NOT modify updatedAt field', () async {
      final now = DateTime.now();
      final originalUpdatedAt = DateTime(2026, 1, 1, 12, 0, 0);
      await insertTestSource(database);

      await database
          .into(database.mediaItemsTable)
          .insert(
            MediaItemsTableCompanion.insert(
              id: 'item-1',
              sourceId: 'source-1',
              displayLabel: 'Video 1',
              fileName: 'video1.mp4',
              primaryVideoUri: const Value('file:///test/video1.mp4'),
              durationMs: const Value(null),
              width: const Value(null),
              height: const Value(null),
              firstSeenAt: now,
              lastSeenAt: now,
              createdAt: now,
              updatedAt: originalUpdatedAt,
            ),
          );

      when(() => mockReader.read('file:///test/video1.mp4')).thenAnswer(
        (_) async => const LocalVideoMetadata(
          durationMs: 3600000,
          width: 1920,
          height: 1080,
        ),
      );

      when(
        () => mockLogger.log(
          scope: any(named: 'scope'),
          event: any(named: 'event'),
          fields: any(named: 'fields'),
        ),
      ).thenAnswer((_) async {});

      final service = MetadataPrefillService(
        database: database,
        metadataReader: mockReader,
        logger: mockLogger,
      );

      await service.prefillMissingMetadata();

      final updated = await (database.select(
        database.mediaItemsTable,
      )..where((tbl) => tbl.id.equals('item-1'))).getSingle();

      expect(updated.durationMs, 3600000);
      expect(updated.width, 1920);
      expect(updated.height, 1080);
      expect(
        updated.updatedAt.millisecondsSinceEpoch,
        originalUpdatedAt.millisecondsSinceEpoch,
        reason:
            'updatedAt should NOT be modified during prefill to avoid UI reordering',
      );
    });
  });
}
