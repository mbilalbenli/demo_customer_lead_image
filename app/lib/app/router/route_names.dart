class RouteNames {
  // Splash
  static const String splash = 'splash';
  static const String splashPath = '/';

  // Lead routes
  static const String leadList = 'leadList';
  static const String leadListPath = '/leads';

  static const String leadDetail = 'leadDetail';
  static const String leadDetailPath = '/leads/:leadId';

  static const String leadCreate = 'leadCreate';
  static const String leadCreatePath = '/leads/create';

  static const String leadSearch = 'leadSearch';
  static const String leadSearchPath = '/leads/search';

  static const String imageViewer = 'imageViewer';
  static const String imageViewerPath = '/leads/:leadId/images/:imageId';

  // Error routes
  static const String error = 'error';
  static const String errorPath = '/error';

  // Helper methods for constructing paths with parameters
  static String getLeadDetailPath(String leadId) => '/leads/$leadId';

  static String getImageViewerPath(String leadId, String imageId) =>
      '/leads/$leadId/images/$imageId';
}
