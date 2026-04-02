import 'package:flutter_test/flutter_test.dart';
import 'package:one_shelf/src/shared/media/media_asset_resolver.dart';

void main() {
  test('buildRelativeAssetCacheFileName keeps extension and avoids collisions', () {
    const first = RelativeAssetRequest(
      sourceId: 'source-a',
      relativePath: 'movies/alpha/poster.jpg',
    );
    const second = RelativeAssetRequest(
      sourceId: 'source-a',
      relativePath: 'movies/beta/poster.jpg',
    );

    final firstName = buildRelativeAssetCacheFileName(first);
    final secondName = buildRelativeAssetCacheFileName(second);

    expect(firstName, endsWith('.jpg'));
    expect(secondName, endsWith('.jpg'));
    expect(firstName, isNot(secondName));
  });
}
