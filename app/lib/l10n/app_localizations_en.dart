// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'Customer Lead Manager';

  @override
  String get systemMonitorTitle => 'System Monitor';

  @override
  String get systemMonitorSubtitle => 'Monitor backend health status';

  @override
  String get healthStatus => 'Health Status';

  @override
  String get overallHealth => 'Overall Health';

  @override
  String get liveStatus => 'Live Status';

  @override
  String get readyStatus => 'Ready Status';

  @override
  String get healthy => 'Healthy';

  @override
  String get unhealthy => 'Unhealthy';

  @override
  String get degraded => 'Degraded';

  @override
  String get checking => 'Checking...';

  @override
  String get unknown => 'Unknown';

  @override
  String lastUpdated(String time) {
    return 'Last updated: $time';
  }

  @override
  String get refreshing => 'Refreshing...';

  @override
  String get refresh => 'Refresh';

  @override
  String get autoRefresh => 'Auto Refresh';

  @override
  String autoRefreshInterval(int seconds) {
    return 'Refresh every $seconds seconds';
  }

  @override
  String get connectionError => 'Connection Error';

  @override
  String get connectionErrorMessage => 'Unable to connect to backend service';

  @override
  String get retry => 'Retry';

  @override
  String get details => 'Details';

  @override
  String get serviceName => 'Service Name';

  @override
  String get serviceStatus => 'Service Status';

  @override
  String get responseTime => 'Response Time';

  @override
  String responseTimeMs(int ms) {
    return '$ms ms';
  }

  @override
  String get database => 'Database';

  @override
  String get api => 'API';

  @override
  String get cache => 'Cache';

  @override
  String get noDataAvailable => 'No data available';

  @override
  String get loading => 'Loading...';

  @override
  String get error => 'Error';

  @override
  String get errorOccurred => 'An error occurred';

  @override
  String get close => 'Close';

  @override
  String get ok => 'OK';

  @override
  String get cancel => 'Cancel';

  @override
  String get leads => 'Leads';

  @override
  String get customerLeads => 'Customer Leads';

  @override
  String get searchLeadsPlaceholder => 'Search leads...';

  @override
  String get emptyNoLeadsMessage => 'Tap + to create your first customer lead';

  @override
  String get addLead => 'Add Lead';

  @override
  String get leadManagement => 'Lead Management';

  @override
  String get createLead => 'Create Lead';

  @override
  String get editLead => 'Edit Lead';

  @override
  String get deleteLead => 'Delete Lead';

  @override
  String get leadDetails => 'Lead Details';

  @override
  String get leadName => 'Lead Name';

  @override
  String get customerName => 'Customer Name';

  @override
  String get email => 'Email';

  @override
  String get phone => 'Phone';

  @override
  String get status => 'Status';

  @override
  String get images => 'Images';

  @override
  String get imageManagement => 'Image Management';

  @override
  String get addImage => 'Add Image';

  @override
  String get addImages => 'Add Images';

  @override
  String get uploadImage => 'Upload Image';

  @override
  String get uploadImages => 'Upload Images';

  @override
  String get deleteImage => 'Delete Image';

  @override
  String get replaceImage => 'Replace Image';

  @override
  String get viewImage => 'View Image';

  @override
  String get imageGallery => 'Image Gallery';

  @override
  String get viewImageGallery => 'View Image Gallery';

  @override
  String get imageViewer => 'Image Viewer';

  @override
  String get captureImage => 'Capture Image';

  @override
  String get takePhoto => 'Take Photo';

  @override
  String get selectFromGallery => 'Select from Gallery';

  @override
  String get imageLimitReached => 'Image Limit Reached';

  @override
  String imageLimitReachedMessage(int maxCount, int currentCount) {
    return 'You have reached the maximum of $maxCount images for this lead. You currently have $currentCount images.';
  }

  @override
  String get yourOptions => 'Your Options';

  @override
  String get replaceExistingImage => 'Replace an existing image';

  @override
  String get deleteImageToMakeSpace => 'Delete an image to make space';

  @override
  String get cancelUpload => 'Cancel upload';

  @override
  String get whatWouldYouLikeToDo => 'What would you like to do?';

  @override
  String nearImageLimit(int slotsRemaining) {
    return 'Only $slotsRemaining image slots remaining';
  }

  @override
  String get gotIt => 'Got It';

  @override
  String get imageTooLarge => 'Image Too Large';

  @override
  String imageTooLargeMessage(String sizeInMB, String maxSizeInMB) {
    return 'Image is ${sizeInMB}MB but max size is ${maxSizeInMB}MB';
  }

  @override
  String get compressImageSuggestion => 'We can compress the image for you';

  @override
  String get compressAndUpload => 'Compress & Upload';

  @override
  String get retryingUpload => 'Retrying Upload';

  @override
  String get uploadFailed => 'Upload Failed';

  @override
  String get retryUpload => 'Retry Upload';

  @override
  String get retryAllFailed => 'Retry All Failed';

  @override
  String failedUploadsCount(int count) {
    return '$count failed uploads';
  }

  @override
  String get uploadProgress => 'Upload Progress';

  @override
  String get uploading => 'Uploading...';

  @override
  String get uploadComplete => 'Upload Complete';

  @override
  String get uploadCancelled => 'Upload Cancelled';

  @override
  String get networkError => 'Network Error';

  @override
  String get serverError => 'Server Error';

  @override
  String get unknownError => 'Unknown Error';

  @override
  String get search => 'Search';

  @override
  String get searchLeads => 'Search Leads';

  @override
  String get noLeadsFound => 'No leads found';

  @override
  String get noImagesFound => 'No images found';

  @override
  String get save => 'Save';

  @override
  String get update => 'Update';

  @override
  String get delete => 'Delete';

  @override
  String get confirm => 'Confirm';

  @override
  String get confirmDelete => 'Confirm Delete';

  @override
  String get deleteConfirmationMessage =>
      'Are you sure you want to delete this item? This action cannot be undone.';

  @override
  String get yes => 'Yes';

  @override
  String get no => 'No';

  @override
  String get back => 'Back';

  @override
  String get next => 'Next';

  @override
  String get previous => 'Previous';

  @override
  String get done => 'Done';

  @override
  String get skip => 'Skip';

  @override
  String get settings => 'Settings';

  @override
  String get about => 'About';

  @override
  String get help => 'Help';

  @override
  String get version => 'Version';

  @override
  String get buildNumber => 'Build Number';

  @override
  String get developer => 'Developer';

  @override
  String get offlineMode => 'Offline Mode';

  @override
  String get onlineMode => 'Online Mode';

  @override
  String get syncData => 'Sync Data';

  @override
  String lastSync(String time) {
    return 'Last Sync: $time';
  }

  @override
  String imageLimitInfo(int current, int max) {
    return 'Image Limit: $current of $max';
  }

  @override
  String imagesSyncPending(int count) {
    return '$count images pending sync';
  }

  @override
  String storageUsed(String used, String total) {
    return 'Storage Used: $used of $total';
  }

  @override
  String get cacheCleared => 'Cache cleared successfully';

  @override
  String get clearCache => 'Clear Cache';

  @override
  String get maximumImagesReached =>
      'Maximum 10 images reached. Delete one to continue.';

  @override
  String get deleteImageToAddMore => 'Delete an image to add more';

  @override
  String slotsAvailable(int count, int max) {
    return '$count of $max slots available';
  }

  @override
  String get replaceImagePrompt =>
      'Would you like to replace an existing image?';

  @override
  String get replaceImageHint => 'Select an existing image to replace';

  @override
  String get deleteImageHint => 'Remove an image to make space';

  @override
  String imageCountAnnouncement(int current, int total) {
    return 'Image $current of $total';
  }

  @override
  String imageLimitStatus(int current, int max) {
    return '$current of $max images used';
  }

  @override
  String imageAddButtonAccessibility(int available, int max) {
    return 'Add image. $available slots remaining out of $max';
  }

  @override
  String imageAddButtonDisabledAccessibility(int max) {
    return 'Cannot add image. Limit of $max images reached';
  }

  @override
  String imageGalleryAccessibility(int count, int max) {
    return 'Image gallery with $count images. Maximum $max images allowed';
  }

  @override
  String get retrying => 'Retrying...';

  @override
  String get maxRetriesReached => 'Max retries reached';

  @override
  String get dismiss => 'Dismiss';

  @override
  String get imageLimitManager => 'Image Limit Manager';

  @override
  String get maximumCapacityReached => 'Maximum capacity reached';

  @override
  String storageLabel(String size) {
    return 'Storage: $size';
  }

  @override
  String averagePerImage(String size) {
    return 'Avg: $size/image';
  }

  @override
  String get overview => 'Overview';

  @override
  String get manage => 'Manage';

  @override
  String get storage => 'Storage';

  @override
  String get noImagesYet => 'No Images Yet';

  @override
  String get addFirstImage => 'Add your first image to get started';

  @override
  String get limitReached => 'Limit Reached';

  @override
  String get imageSlots => 'Image Slots';

  @override
  String get noImagesToManage => 'No Images to Manage';

  @override
  String get addImagesToManage => 'Add images to manage them here';

  @override
  String get selectImageToReplace => 'Select image to replace';

  @override
  String imagesCount(int count) {
    return '$count images';
  }

  @override
  String deleteImageConfirmation(String fileName) {
    return 'Delete \"$fileName\"?';
  }

  @override
  String get setAsMainImage => 'Set as main image';

  @override
  String get imageReplacementInitiated => 'Image replacement initiated';

  @override
  String get storageOverview => 'Storage Overview';

  @override
  String get totalStorageUsed => 'Total Storage Used';

  @override
  String get largestImage => 'Largest Image';

  @override
  String get smallestImage => 'Smallest Image';

  @override
  String get storageDistribution => 'Storage Distribution';

  @override
  String andMoreImages(int count) {
    return '... and $count more images';
  }

  @override
  String get recommendations => 'Recommendations';

  @override
  String get considerCompressing =>
      'Consider compressing images to reduce storage usage';

  @override
  String get someLargerThanAverage =>
      'Some images are significantly larger than average';

  @override
  String get approachingImageLimit => 'You are approaching the image limit';

  @override
  String get storageOptimal => 'Storage usage is optimal';

  @override
  String get manageStorageSettings => 'Manage Storage Settings';
}
