class ScanReport {
  const ScanReport({
    required this.sourcesScanned,
    required this.itemsFound,
    required this.itemsUpdated,
    required this.itemsMissing,
    this.errorMessage,
  });

  final int sourcesScanned;
  final int itemsFound;
  final int itemsUpdated;
  final int itemsMissing;
  final String? errorMessage;

  bool get hasError => errorMessage != null && errorMessage!.isNotEmpty;
}
