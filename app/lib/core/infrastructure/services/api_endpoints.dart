class ApiEndpoints {
  ApiEndpoints._();

  // Use 10.0.2.2 for Android emulator to access host machine
  // Use localhost for iOS simulator
  // For real device, use your machine's IP address
  static const String baseUrl = 'http://10.0.2.2:5000';
  static const String apiVersion = '/api';
  static const String baseApiUrl = '$baseUrl$apiVersion';

  static const String leads = '/leads';
  static const String leadById = '/leads/{id}';
  static const String searchLeads = '/leads/search';

  // Lead images (nested under lead)
  static const String leadImagesByLeadId = '/leads/{leadId}/images';
  static const String leadImageById = '/leads/{leadId}/images/{imageId}';
  static const String uploadImageForLead = '/leads/{leadId}/images';
  static const String batchUploadImagesForLead = '/leads/{leadId}/images/batch';
  static const String validateImageForLead = '/leads/{leadId}/images/validate';
  static const String imageCountForLead = '/leads/{leadId}/images/count';
  static const String replaceImageForLead = '/leads/{leadId}/images/{imageId}';

  static String getLeadById(String id) => leadById.replaceAll('{id}', id);
  static String getImagesByLeadId(String leadId) =>
      leadImagesByLeadId.replaceAll('{leadId}', leadId);
  static String getImageCount(String leadId) =>
      imageCountForLead.replaceAll('{leadId}', leadId);
  static String postUploadImage(String leadId) =>
      uploadImageForLead.replaceAll('{leadId}', leadId);
  static String postBatchUploadImages(String leadId) =>
      batchUploadImagesForLead.replaceAll('{leadId}', leadId);
  static String postValidateImage(String leadId) =>
      validateImageForLead.replaceAll('{leadId}', leadId);
  static String putReplaceImage(String leadId, String imageId) =>
      replaceImageForLead.replaceAll('{leadId}', leadId).replaceAll('{imageId}', imageId);
  static String deleteImagePath(String leadId, String imageId) =>
      leadImageById.replaceAll('{leadId}', leadId).replaceAll('{imageId}', imageId);
}
