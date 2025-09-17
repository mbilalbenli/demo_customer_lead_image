import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_es.dart';
import 'app_localizations_fr.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('es'),
    Locale('fr'),
  ];

  /// Application title
  ///
  /// In en, this message translates to:
  /// **'Customer Lead Manager'**
  String get appTitle;

  /// System monitor page title
  ///
  /// In en, this message translates to:
  /// **'System Monitor'**
  String get systemMonitorTitle;

  /// System monitor page subtitle
  ///
  /// In en, this message translates to:
  /// **'Monitor backend health status'**
  String get systemMonitorSubtitle;

  /// Health status label
  ///
  /// In en, this message translates to:
  /// **'Health Status'**
  String get healthStatus;

  /// Overall health label
  ///
  /// In en, this message translates to:
  /// **'Overall Health'**
  String get overallHealth;

  /// Live status label
  ///
  /// In en, this message translates to:
  /// **'Live Status'**
  String get liveStatus;

  /// Ready status label
  ///
  /// In en, this message translates to:
  /// **'Ready Status'**
  String get readyStatus;

  /// Healthy status
  ///
  /// In en, this message translates to:
  /// **'Healthy'**
  String get healthy;

  /// Unhealthy status
  ///
  /// In en, this message translates to:
  /// **'Unhealthy'**
  String get unhealthy;

  /// Degraded status
  ///
  /// In en, this message translates to:
  /// **'Degraded'**
  String get degraded;

  /// Checking status
  ///
  /// In en, this message translates to:
  /// **'Checking...'**
  String get checking;

  /// Unknown status
  ///
  /// In en, this message translates to:
  /// **'Unknown'**
  String get unknown;

  /// Last updated time
  ///
  /// In en, this message translates to:
  /// **'Last updated: {time}'**
  String lastUpdated(String time);

  /// Refreshing message
  ///
  /// In en, this message translates to:
  /// **'Refreshing...'**
  String get refreshing;

  /// Refresh button
  ///
  /// In en, this message translates to:
  /// **'Refresh'**
  String get refresh;

  /// Auto refresh toggle
  ///
  /// In en, this message translates to:
  /// **'Auto Refresh'**
  String get autoRefresh;

  /// Auto refresh interval
  ///
  /// In en, this message translates to:
  /// **'Refresh every {seconds} seconds'**
  String autoRefreshInterval(int seconds);

  /// Connection error title
  ///
  /// In en, this message translates to:
  /// **'Connection Error'**
  String get connectionError;

  /// Connection error message
  ///
  /// In en, this message translates to:
  /// **'Unable to connect to backend service'**
  String get connectionErrorMessage;

  /// Retry button
  ///
  /// In en, this message translates to:
  /// **'Retry'**
  String get retry;

  /// Details button/label
  ///
  /// In en, this message translates to:
  /// **'Details'**
  String get details;

  /// Service name label
  ///
  /// In en, this message translates to:
  /// **'Service Name'**
  String get serviceName;

  /// Service status label
  ///
  /// In en, this message translates to:
  /// **'Service Status'**
  String get serviceStatus;

  /// Response time label
  ///
  /// In en, this message translates to:
  /// **'Response Time'**
  String get responseTime;

  /// Response time in milliseconds
  ///
  /// In en, this message translates to:
  /// **'{ms} ms'**
  String responseTimeMs(int ms);

  /// Database service
  ///
  /// In en, this message translates to:
  /// **'Database'**
  String get database;

  /// API service
  ///
  /// In en, this message translates to:
  /// **'API'**
  String get api;

  /// Cache service
  ///
  /// In en, this message translates to:
  /// **'Cache'**
  String get cache;

  /// No data available message
  ///
  /// In en, this message translates to:
  /// **'No data available'**
  String get noDataAvailable;

  /// Loading message
  ///
  /// In en, this message translates to:
  /// **'Loading...'**
  String get loading;

  /// Error title
  ///
  /// In en, this message translates to:
  /// **'Error'**
  String get error;

  /// Generic error message
  ///
  /// In en, this message translates to:
  /// **'An error occurred'**
  String get errorOccurred;

  /// Close button
  ///
  /// In en, this message translates to:
  /// **'Close'**
  String get close;

  /// OK button
  ///
  /// In en, this message translates to:
  /// **'OK'**
  String get ok;

  /// Cancel button
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// Leads section title
  ///
  /// In en, this message translates to:
  /// **'Leads'**
  String get leads;

  /// Lead management page title
  ///
  /// In en, this message translates to:
  /// **'Lead Management'**
  String get leadManagement;

  /// Create lead button text
  ///
  /// In en, this message translates to:
  /// **'Create Lead'**
  String get createLead;

  /// Edit lead button text
  ///
  /// In en, this message translates to:
  /// **'Edit Lead'**
  String get editLead;

  /// Delete lead button text
  ///
  /// In en, this message translates to:
  /// **'Delete Lead'**
  String get deleteLead;

  /// Lead details page title
  ///
  /// In en, this message translates to:
  /// **'Lead Details'**
  String get leadDetails;

  /// Lead name field label
  ///
  /// In en, this message translates to:
  /// **'Lead Name'**
  String get leadName;

  /// Customer name field label
  ///
  /// In en, this message translates to:
  /// **'Customer Name'**
  String get customerName;

  /// Email field label
  ///
  /// In en, this message translates to:
  /// **'Email'**
  String get email;

  /// Phone field label
  ///
  /// In en, this message translates to:
  /// **'Phone'**
  String get phone;

  /// Status field label
  ///
  /// In en, this message translates to:
  /// **'Status'**
  String get status;

  /// Images section title
  ///
  /// In en, this message translates to:
  /// **'Images'**
  String get images;

  /// Image management page title
  ///
  /// In en, this message translates to:
  /// **'Image Management'**
  String get imageManagement;

  /// Add image button text
  ///
  /// In en, this message translates to:
  /// **'Add Image'**
  String get addImage;

  /// Add multiple images button text
  ///
  /// In en, this message translates to:
  /// **'Add Images'**
  String get addImages;

  /// Upload image button text
  ///
  /// In en, this message translates to:
  /// **'Upload Image'**
  String get uploadImage;

  /// Upload multiple images button text
  ///
  /// In en, this message translates to:
  /// **'Upload Images'**
  String get uploadImages;

  /// Delete image button text
  ///
  /// In en, this message translates to:
  /// **'Delete Image'**
  String get deleteImage;

  /// Replace image button text
  ///
  /// In en, this message translates to:
  /// **'Replace Image'**
  String get replaceImage;

  /// View image button text
  ///
  /// In en, this message translates to:
  /// **'View Image'**
  String get viewImage;

  /// Image gallery page title
  ///
  /// In en, this message translates to:
  /// **'Image Gallery'**
  String get imageGallery;

  /// View image gallery button text
  ///
  /// In en, this message translates to:
  /// **'View Image Gallery'**
  String get viewImageGallery;

  /// Image viewer page title
  ///
  /// In en, this message translates to:
  /// **'Image Viewer'**
  String get imageViewer;

  /// Capture image button text
  ///
  /// In en, this message translates to:
  /// **'Capture Image'**
  String get captureImage;

  /// Take photo button text
  ///
  /// In en, this message translates to:
  /// **'Take Photo'**
  String get takePhoto;

  /// Select from gallery button text
  ///
  /// In en, this message translates to:
  /// **'Select from Gallery'**
  String get selectFromGallery;

  /// Image limit reached title
  ///
  /// In en, this message translates to:
  /// **'Image Limit Reached'**
  String get imageLimitReached;

  /// Image limit reached message
  ///
  /// In en, this message translates to:
  /// **'You have reached the maximum of {maxCount} images for this lead. You currently have {currentCount} images.'**
  String imageLimitReachedMessage(int maxCount, int currentCount);

  /// Your options title
  ///
  /// In en, this message translates to:
  /// **'Your Options'**
  String get yourOptions;

  /// Replace existing image option
  ///
  /// In en, this message translates to:
  /// **'Replace an existing image'**
  String get replaceExistingImage;

  /// Delete image to make space option
  ///
  /// In en, this message translates to:
  /// **'Delete an image to make space'**
  String get deleteImageToMakeSpace;

  /// Cancel upload option
  ///
  /// In en, this message translates to:
  /// **'Cancel upload'**
  String get cancelUpload;

  /// What would you like to do question
  ///
  /// In en, this message translates to:
  /// **'What would you like to do?'**
  String get whatWouldYouLikeToDo;

  /// Near image limit warning
  ///
  /// In en, this message translates to:
  /// **'Only {slotsRemaining} image slots remaining'**
  String nearImageLimit(int slotsRemaining);

  /// Got it acknowledgment button
  ///
  /// In en, this message translates to:
  /// **'Got It'**
  String get gotIt;

  /// Image too large title
  ///
  /// In en, this message translates to:
  /// **'Image Too Large'**
  String get imageTooLarge;

  /// Image too large message
  ///
  /// In en, this message translates to:
  /// **'Image is {sizeInMB}MB but max size is {maxSizeInMB}MB'**
  String imageTooLargeMessage(String sizeInMB, String maxSizeInMB);

  /// Compress image suggestion
  ///
  /// In en, this message translates to:
  /// **'We can compress the image for you'**
  String get compressImageSuggestion;

  /// Compress and upload button text
  ///
  /// In en, this message translates to:
  /// **'Compress & Upload'**
  String get compressAndUpload;

  /// Retrying upload status
  ///
  /// In en, this message translates to:
  /// **'Retrying Upload'**
  String get retryingUpload;

  /// Upload failed status
  ///
  /// In en, this message translates to:
  /// **'Upload Failed'**
  String get uploadFailed;

  /// Retry upload button text
  ///
  /// In en, this message translates to:
  /// **'Retry Upload'**
  String get retryUpload;

  /// Retry all failed uploads button text
  ///
  /// In en, this message translates to:
  /// **'Retry All Failed'**
  String get retryAllFailed;

  /// Failed uploads count
  ///
  /// In en, this message translates to:
  /// **'{count} failed uploads'**
  String failedUploadsCount(int count);

  /// Upload progress title
  ///
  /// In en, this message translates to:
  /// **'Upload Progress'**
  String get uploadProgress;

  /// Uploading status
  ///
  /// In en, this message translates to:
  /// **'Uploading...'**
  String get uploading;

  /// Upload complete status
  ///
  /// In en, this message translates to:
  /// **'Upload Complete'**
  String get uploadComplete;

  /// Upload cancelled status
  ///
  /// In en, this message translates to:
  /// **'Upload Cancelled'**
  String get uploadCancelled;

  /// Network error message
  ///
  /// In en, this message translates to:
  /// **'Network Error'**
  String get networkError;

  /// Server error message
  ///
  /// In en, this message translates to:
  /// **'Server Error'**
  String get serverError;

  /// Unknown error message
  ///
  /// In en, this message translates to:
  /// **'Unknown Error'**
  String get unknownError;

  /// Search button or field label
  ///
  /// In en, this message translates to:
  /// **'Search'**
  String get search;

  /// Search leads placeholder
  ///
  /// In en, this message translates to:
  /// **'Search Leads'**
  String get searchLeads;

  /// No leads found message
  ///
  /// In en, this message translates to:
  /// **'No leads found'**
  String get noLeadsFound;

  /// No images found message
  ///
  /// In en, this message translates to:
  /// **'No images found'**
  String get noImagesFound;

  /// Save button text
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get save;

  /// Update button text
  ///
  /// In en, this message translates to:
  /// **'Update'**
  String get update;

  /// Delete button text
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get delete;

  /// Confirm button text
  ///
  /// In en, this message translates to:
  /// **'Confirm'**
  String get confirm;

  /// Confirm delete title
  ///
  /// In en, this message translates to:
  /// **'Confirm Delete'**
  String get confirmDelete;

  /// Delete confirmation message
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to delete this item? This action cannot be undone.'**
  String get deleteConfirmationMessage;

  /// Yes button text
  ///
  /// In en, this message translates to:
  /// **'Yes'**
  String get yes;

  /// No button text
  ///
  /// In en, this message translates to:
  /// **'No'**
  String get no;

  /// Back button text
  ///
  /// In en, this message translates to:
  /// **'Back'**
  String get back;

  /// Next button text
  ///
  /// In en, this message translates to:
  /// **'Next'**
  String get next;

  /// Previous button text
  ///
  /// In en, this message translates to:
  /// **'Previous'**
  String get previous;

  /// Done button text
  ///
  /// In en, this message translates to:
  /// **'Done'**
  String get done;

  /// Skip button text
  ///
  /// In en, this message translates to:
  /// **'Skip'**
  String get skip;

  /// Settings page title
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settings;

  /// About page title
  ///
  /// In en, this message translates to:
  /// **'About'**
  String get about;

  /// Help page title
  ///
  /// In en, this message translates to:
  /// **'Help'**
  String get help;

  /// Version label
  ///
  /// In en, this message translates to:
  /// **'Version'**
  String get version;

  /// Build number label
  ///
  /// In en, this message translates to:
  /// **'Build Number'**
  String get buildNumber;

  /// Developer label
  ///
  /// In en, this message translates to:
  /// **'Developer'**
  String get developer;

  /// Offline mode indicator
  ///
  /// In en, this message translates to:
  /// **'Offline Mode'**
  String get offlineMode;

  /// Online mode indicator
  ///
  /// In en, this message translates to:
  /// **'Online Mode'**
  String get onlineMode;

  /// Sync data button text
  ///
  /// In en, this message translates to:
  /// **'Sync Data'**
  String get syncData;

  /// Last sync time
  ///
  /// In en, this message translates to:
  /// **'Last Sync: {time}'**
  String lastSync(String time);

  /// Image limit information
  ///
  /// In en, this message translates to:
  /// **'Image Limit: {current} of {max}'**
  String imageLimitInfo(int current, int max);

  /// Images sync pending count
  ///
  /// In en, this message translates to:
  /// **'{count} images pending sync'**
  String imagesSyncPending(int count);

  /// Storage usage information
  ///
  /// In en, this message translates to:
  /// **'Storage Used: {used} of {total}'**
  String storageUsed(String used, String total);

  /// Cache cleared confirmation
  ///
  /// In en, this message translates to:
  /// **'Cache cleared successfully'**
  String get cacheCleared;

  /// Clear cache button text
  ///
  /// In en, this message translates to:
  /// **'Clear Cache'**
  String get clearCache;

  /// Error message when maximum images reached
  ///
  /// In en, this message translates to:
  /// **'Maximum 10 images reached. Delete one to continue.'**
  String get maximumImagesReached;

  /// Hint message to delete image to add more
  ///
  /// In en, this message translates to:
  /// **'Delete an image to add more'**
  String get deleteImageToAddMore;

  /// Number of slots available for images
  ///
  /// In en, this message translates to:
  /// **'{count} slots available'**
  String slotsAvailable(int count);

  /// Prompt to replace existing image
  ///
  /// In en, this message translates to:
  /// **'Would you like to replace an existing image?'**
  String get replaceImagePrompt;

  /// Hint for replacing image
  ///
  /// In en, this message translates to:
  /// **'Select an existing image to replace'**
  String get replaceImageHint;

  /// Hint for deleting image
  ///
  /// In en, this message translates to:
  /// **'Remove an image to make space'**
  String get deleteImageHint;

  /// Screen reader announcement for image count
  ///
  /// In en, this message translates to:
  /// **'Image {current} of {total}'**
  String imageCountAnnouncement(int current, int total);

  /// Image limit status for screen readers
  ///
  /// In en, this message translates to:
  /// **'{current} of {max} images used'**
  String imageLimitStatus(int current, int max);

  /// Accessibility label for add image button
  ///
  /// In en, this message translates to:
  /// **'Add image. {available} slots remaining out of {max}'**
  String imageAddButtonAccessibility(int available, int max);

  /// Accessibility label for disabled add image button
  ///
  /// In en, this message translates to:
  /// **'Cannot add image. Limit of {max} images reached'**
  String imageAddButtonDisabledAccessibility(int max);

  /// Accessibility description for image gallery
  ///
  /// In en, this message translates to:
  /// **'Image gallery with {count} images. Maximum {max} images allowed'**
  String imageGalleryAccessibility(int count, int max);

  /// Retrying status message
  ///
  /// In en, this message translates to:
  /// **'Retrying...'**
  String get retrying;

  /// Max retries reached message
  ///
  /// In en, this message translates to:
  /// **'Max retries reached'**
  String get maxRetriesReached;

  /// Dismiss button text
  ///
  /// In en, this message translates to:
  /// **'Dismiss'**
  String get dismiss;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'es', 'fr'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'es':
      return AppLocalizationsEs();
    case 'fr':
      return AppLocalizationsFr();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
