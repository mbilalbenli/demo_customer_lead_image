// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for French (`fr`).
class AppLocalizationsFr extends AppLocalizations {
  AppLocalizationsFr([String locale = 'fr']) : super(locale);

  @override
  String get appTitle => 'Gestionnaire de Prospects';

  @override
  String get systemMonitorTitle => 'Moniteur Système';

  @override
  String get systemMonitorSubtitle => 'Surveiller l\'état de santé du backend';

  @override
  String get healthStatus => 'État de Santé';

  @override
  String get overallHealth => 'Santé Globale';

  @override
  String get liveStatus => 'Statut en Direct';

  @override
  String get readyStatus => 'Statut Prêt';

  @override
  String get healthy => 'En Bonne Santé';

  @override
  String get unhealthy => 'Pas en Bonne Santé';

  @override
  String get degraded => 'Dégradé';

  @override
  String get checking => 'Vérification...';

  @override
  String get unknown => 'Inconnu';

  @override
  String lastUpdated(String time) {
    return 'Dernière mise à jour: $time';
  }

  @override
  String get refreshing => 'Actualisation...';

  @override
  String get refresh => 'Actualiser';

  @override
  String get autoRefresh => 'Actualisation Automatique';

  @override
  String autoRefreshInterval(int seconds) {
    return 'Actualiser toutes les $seconds secondes';
  }

  @override
  String get connectionError => 'Erreur de Connexion';

  @override
  String get connectionErrorMessage =>
      'Impossible de se connecter au service backend';

  @override
  String get retry => 'Réessayer';

  @override
  String get details => 'Détails';

  @override
  String get serviceName => 'Nom du Service';

  @override
  String get serviceStatus => 'Statut du Service';

  @override
  String get responseTime => 'Temps de Réponse';

  @override
  String responseTimeMs(int ms) {
    return '$ms ms';
  }

  @override
  String get database => 'Base de Données';

  @override
  String get api => 'API';

  @override
  String get cache => 'Cache';

  @override
  String get noDataAvailable => 'Aucune donnée disponible';

  @override
  String get loading => 'Chargement...';

  @override
  String get error => 'Erreur';

  @override
  String get errorOccurred => 'Une erreur s\'est produite';

  @override
  String get close => 'Fermer';

  @override
  String get ok => 'OK';

  @override
  String get cancel => 'Annuler';

  @override
  String get leads => 'Prospects';

  @override
  String get leadManagement => 'Gestion des Prospects';

  @override
  String get createLead => 'Créer un Prospect';

  @override
  String get editLead => 'Modifier le Prospect';

  @override
  String get deleteLead => 'Supprimer le Prospect';

  @override
  String get leadDetails => 'Détails du Prospect';

  @override
  String get leadName => 'Nom du Prospect';

  @override
  String get customerName => 'Nom du Client';

  @override
  String get email => 'Email';

  @override
  String get phone => 'Téléphone';

  @override
  String get status => 'Statut';

  @override
  String get images => 'Images';

  @override
  String get imageManagement => 'Gestion des Images';

  @override
  String get addImage => 'Ajouter une Image';

  @override
  String get addImages => 'Ajouter des Images';

  @override
  String get uploadImage => 'Télécharger une Image';

  @override
  String get uploadImages => 'Télécharger des Images';

  @override
  String get deleteImage => 'Supprimer l\'Image';

  @override
  String get replaceImage => 'Remplacer l\'Image';

  @override
  String get viewImage => 'Voir l\'Image';

  @override
  String get imageGallery => 'Galerie d\'Images';

  @override
  String get viewImageGallery => 'Voir la Galerie d\'Images';

  @override
  String get imageViewer => 'Visionneuse d\'Images';

  @override
  String get captureImage => 'Capturer une Image';

  @override
  String get takePhoto => 'Prendre une Photo';

  @override
  String get selectFromGallery => 'Sélectionner dans la Galerie';

  @override
  String get imageLimitReached => 'Limite d\'Images Atteinte';

  @override
  String imageLimitReachedMessage(int maxCount, int currentCount) {
    return 'Vous avez atteint le maximum de $maxCount images pour ce prospect. Vous avez actuellement $currentCount images.';
  }

  @override
  String get yourOptions => 'Vos Options';

  @override
  String get replaceExistingImage => 'Remplacer une image existante';

  @override
  String get deleteImageToMakeSpace =>
      'Supprimer une image pour faire de la place';

  @override
  String get cancelUpload => 'Annuler le téléchargement';

  @override
  String get whatWouldYouLikeToDo => 'Que souhaitez-vous faire ?';

  @override
  String nearImageLimit(int slotsRemaining) {
    return 'Il ne reste que $slotsRemaining emplacements d\'images';
  }

  @override
  String get gotIt => 'Compris';

  @override
  String get imageTooLarge => 'Image Trop Volumineuse';

  @override
  String imageTooLargeMessage(String sizeInMB, String maxSizeInMB) {
    return 'L\'image fait ${sizeInMB}MB mais la taille maximale est ${maxSizeInMB}MB';
  }

  @override
  String get compressImageSuggestion =>
      'Nous pouvons compresser l\'image pour vous';

  @override
  String get compressAndUpload => 'Compresser et Télécharger';

  @override
  String get retryingUpload => 'Nouvelle Tentative de Téléchargement';

  @override
  String get uploadFailed => 'Téléchargement Échoué';

  @override
  String get retryUpload => 'Réessayer le Téléchargement';

  @override
  String get retryAllFailed => 'Réessayer Tous les Échecs';

  @override
  String failedUploadsCount(int count) {
    return '$count téléchargements échoués';
  }

  @override
  String get uploadProgress => 'Progression du Téléchargement';

  @override
  String get uploading => 'Téléchargement...';

  @override
  String get uploadComplete => 'Téléchargement Terminé';

  @override
  String get uploadCancelled => 'Téléchargement Annulé';

  @override
  String get networkError => 'Erreur Réseau';

  @override
  String get serverError => 'Erreur Serveur';

  @override
  String get unknownError => 'Erreur Inconnue';

  @override
  String get search => 'Rechercher';

  @override
  String get searchLeads => 'Rechercher des Prospects';

  @override
  String get noLeadsFound => 'Aucun prospect trouvé';

  @override
  String get noImagesFound => 'Aucune image trouvée';

  @override
  String get save => 'Enregistrer';

  @override
  String get update => 'Mettre à jour';

  @override
  String get delete => 'Supprimer';

  @override
  String get confirm => 'Confirmer';

  @override
  String get confirmDelete => 'Confirmer la Suppression';

  @override
  String get deleteConfirmationMessage =>
      'Êtes-vous sûr de vouloir supprimer cet élément ? Cette action ne peut pas être annulée.';

  @override
  String get yes => 'Oui';

  @override
  String get no => 'Non';

  @override
  String get back => 'Retour';

  @override
  String get next => 'Suivant';

  @override
  String get previous => 'Précédent';

  @override
  String get done => 'Terminé';

  @override
  String get skip => 'Passer';

  @override
  String get settings => 'Paramètres';

  @override
  String get about => 'À Propos';

  @override
  String get help => 'Aide';

  @override
  String get version => 'Version';

  @override
  String get buildNumber => 'Numéro de Build';

  @override
  String get developer => 'Développeur';

  @override
  String get offlineMode => 'Mode Hors Ligne';

  @override
  String get onlineMode => 'Mode En Ligne';

  @override
  String get syncData => 'Synchroniser les Données';

  @override
  String lastSync(String time) {
    return 'Dernière Synchronisation: $time';
  }

  @override
  String imageLimitInfo(int current, int max) {
    return 'Limite d\'Images: $current de $max';
  }

  @override
  String imagesSyncPending(int count) {
    return '$count images en attente de synchronisation';
  }

  @override
  String storageUsed(String used, String total) {
    return 'Stockage Utilisé: $used de $total';
  }

  @override
  String get cacheCleared => 'Cache vidé avec succès';

  @override
  String get clearCache => 'Vider le Cache';

  @override
  String get maximumImagesReached =>
      'Maximum de 10 images atteint. Supprimez-en une pour continuer.';

  @override
  String get deleteImageToAddMore => 'Supprimez une image pour en ajouter plus';

  @override
  String slotsAvailable(int count) {
    return '$count emplacements disponibles';
  }

  @override
  String get replaceImagePrompt =>
      'Souhaitez-vous remplacer une image existante ?';

  @override
  String get replaceImageHint => 'Sélectionnez une image existante à remplacer';

  @override
  String get deleteImageHint => 'Supprimez une image pour faire de la place';

  @override
  String imageCountAnnouncement(int current, int total) {
    return 'Image $current de $total';
  }

  @override
  String imageLimitStatus(int current, int max) {
    return '$current de $max images utilisées';
  }

  @override
  String imageAddButtonAccessibility(int available, int max) {
    return 'Ajouter une image. $available emplacements restants sur $max';
  }

  @override
  String imageAddButtonDisabledAccessibility(int max) {
    return 'Impossible d\'ajouter une image. Limite de $max images atteinte';
  }

  @override
  String imageGalleryAccessibility(int count, int max) {
    return 'Galerie d\'images avec $count images. Maximum $max images autorisées';
  }

  @override
  String get retrying => 'Nouvelle tentative...';

  @override
  String get maxRetriesReached => 'Maximum de tentatives atteint';

  @override
  String get dismiss => 'Ignorer';
}
