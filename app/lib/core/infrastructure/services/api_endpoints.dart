class ApiEndpoints {
  ApiEndpoints._();

  static const String baseUrl = 'http://localhost:5000';
  static const String apiVersion = '/api';
  static const String baseApiUrl = '$baseUrl$apiVersion';

  static const String leads = '/leads';
  static const String leadById = '/leads/{id}';
  static const String searchLeads = '/leads/search';

  static const String leadImages = '/lead-images';
  static const String leadImagesByLeadId = '/lead-images/lead/{leadId}';
  static const String leadImageById = '/lead-images/{id}';
  static const String uploadImage = '/lead-images/upload';
  static const String imageCount = '/lead-images/lead/{leadId}/count';
  static const String replaceImage = '/lead-images/{id}/replace';

  static String getLeadById(String id) => leadById.replaceAll('{id}', id);
  static String getImagesByLeadId(String leadId) =>
      leadImagesByLeadId.replaceAll('{leadId}', leadId);
  static String getImageById(String id) =>
      leadImageById.replaceAll('{id}', id);
  static String getImageCount(String leadId) =>
      imageCount.replaceAll('{leadId}', leadId);
  static String getReplaceImage(String id) =>
      replaceImage.replaceAll('{id}', id);
}