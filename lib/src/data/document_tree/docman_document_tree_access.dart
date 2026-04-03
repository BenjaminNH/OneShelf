import 'dart:convert';
import 'dart:typed_data';

import 'package:docman/docman.dart';

import 'document_tree_access.dart';

class DocmanDocumentTreeAccess implements DocumentTreeAccess {
  @override
  Future<DocumentFile?> pickDirectory({String? initDir}) {
    return DocMan.pick.directory(initDir: initDir);
  }

  @override
  Future<List<DocumentFile>> listPersistedRoots() {
    return DocMan.perms.listDocuments(directories: true, files: false);
  }

  @override
  Future<bool> validatePersistedRoots() {
    return DocMan.perms.validateList();
  }

  @override
  Future<PersistedPermission?> permissionStatus(String uri) {
    return DocMan.perms.status(uri);
  }

  @override
  Future<DocumentFile?> resolve(String uri) {
    return DocumentFile.fromUri(uri);
  }

  @override
  Future<List<DocumentFile>> listChildren(DocumentFile directory) {
    return directory.listDocuments();
  }

  @override
  Future<DocumentFile?> findChild(DocumentFile directory, String name) {
    return directory.find(name);
  }

  @override
  Future<String?> readText(DocumentFile file) async {
    if (!file.exists || !file.isFile) {
      return null;
    }
    final bytes = await file.read();
    if (bytes == null || bytes.isEmpty) {
      return null;
    }
    try {
      return utf8.decode(bytes, allowMalformed: true);
    } catch (_) {
      return latin1.decode(bytes, allowInvalid: true);
    }
  }

  @override
  Future<Uint8List?> readBytes(DocumentFile file) {
    return file.read();
  }

  @override
  Future<bool> open(DocumentFile file, {String? title}) {
    return file.open(title: title);
  }
}
