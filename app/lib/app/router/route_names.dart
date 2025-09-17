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

  static const String leadEdit = 'leadEdit';
  static const String leadEditPath = '/leads/:leadId/edit';

  static const String leadSearch = 'leadSearch';
  static const String leadSearchPath = '/leads/search';

  // Lead Image routes
  static const String imageGallery = 'imageGallery';
  static const String imageGalleryPath = '/leads/:leadId/images';

  static const String imageViewer = 'imageViewer';
  static const String imageViewerPath = '/leads/:leadId/images/:imageId';

  static const String imageCapture = 'imageCapture';
  static const String imageCapturePath = '/leads/:leadId/images/capture';

  static const String imageUpload = 'imageUpload';
  static const String imageUploadPath = '/leads/:leadId/images/upload';

  static const String imageReplacement = 'imageReplacement';
  static const String imageReplacementPath = '/leads/:leadId/images/replace/:imageId';

  static const String imageStatus = 'imageStatus';
  static const String imageStatusPath = '/leads/:leadId/images/status';

  // Error routes
  static const String error = 'error';
  static const String errorPath = '/error';

  // Helper methods for constructing paths with parameters
  static String getLeadDetailPath(String leadId) => '/leads/$leadId';

  static String getLeadEditPath(String leadId) => '/leads/$leadId/edit';

  static String getImageGalleryPath(String leadId) => '/leads/$leadId/images';

  static String getImageViewerPath(String leadId, String imageId) =>
      '/leads/$leadId/images/$imageId';

  static String getImageCapturePath(String leadId) =>
      '/leads/$leadId/images/capture';

  static String getImageUploadPath(String leadId) =>
      '/leads/$leadId/images/upload';

  static String getImageReplacementPath(String leadId, String imageId) =>
      '/leads/$leadId/images/replace/$imageId';

  static String getImageStatusPath(String leadId) =>
      '/leads/$leadId/images/status';
}