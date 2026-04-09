import 'package:flutter_test/flutter_test.dart';
import 'package:one_shelf/src/app/app_route_pages.dart';

void main() {
  group('buildSettingsUpdateFeedUrlLabel', () {
    test('returns null when debug-only feed label is disabled', () {
      expect(
        buildSettingsUpdateFeedUrlLabel(
          showDebugFeedUrl: false,
          effectiveUpdateFeedApi: 'https://example.com/feed.json',
        ),
        isNull,
      );
    });

    test(
      'returns effective feed url when debug-only feed label is enabled',
      () {
        expect(
          buildSettingsUpdateFeedUrlLabel(
            showDebugFeedUrl: true,
            effectiveUpdateFeedApi: 'https://example.com/feed.json',
          ),
          'https://example.com/feed.json',
        );
      },
    );
  });
}
