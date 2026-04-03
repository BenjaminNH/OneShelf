import 'package:flutter_test/flutter_test.dart';
import 'package:one_shelf/src/shared/media/media_asset_resolver.dart';

void main() {
  test('image cache file name includes variant and source freshness', () {
    const base = RelativeImageRequest(
      sourceId: 'source-a',
      relativePath: 'Movies/ABP-001/poster.jpg',
      variant: RelativeImageVariant.posterThumb,
      lastModified: 100,
    );
    const samePathDifferentVariant = RelativeImageRequest(
      sourceId: 'source-a',
      relativePath: 'Movies/ABP-001/poster.jpg',
      variant: RelativeImageVariant.posterDetail,
      lastModified: 100,
    );
    const samePathDifferentModified = RelativeImageRequest(
      sourceId: 'source-a',
      relativePath: 'Movies/ABP-001/poster.jpg',
      variant: RelativeImageVariant.posterThumb,
      lastModified: 200,
    );

    final baseKey = buildRelativeImageCacheFileName(base);
    final variantKey = buildRelativeImageCacheFileName(
      samePathDifferentVariant,
    );
    final modifiedKey = buildRelativeImageCacheFileName(
      samePathDifferentModified,
    );

    expect(baseKey, endsWith('.jpg'));
    expect(variantKey, isNot(baseKey));
    expect(modifiedKey, isNot(baseKey));
  });
}
