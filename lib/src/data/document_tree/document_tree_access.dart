import 'dart:typed_data';

import 'package:docman/docman.dart';

abstract interface class DocumentTreeAccess {
  Future<DocumentFile?> pickDirectory({String? initDir});

  Future<List<DocumentFile>> listPersistedRoots();

  Future<bool> validatePersistedRoots();

  Future<PersistedPermission?> permissionStatus(String uri);

  Future<DocumentFile?> resolve(String uri);

  Future<List<DocumentFile>> listChildren(DocumentFile directory);

  Future<DocumentFile?> findChild(DocumentFile directory, String name);

  Future<String?> readText(DocumentFile file);

  Future<Uint8List?> readBytes(DocumentFile file);

  Future<bool> open(DocumentFile file, {String? title});
}
