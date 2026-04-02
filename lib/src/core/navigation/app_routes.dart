abstract final class AppRoutes {
  static const library = '/';
  static const search = '/search';
  static const settings = '/settings';
  static const sources = '/settings/sources';

  static String detail(String mediaId) => '/detail/$mediaId';
  static String player(String mediaId) => '/player/$mediaId';
}
