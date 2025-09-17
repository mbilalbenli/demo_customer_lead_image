// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Spanish Castilian (`es`).
class AppLocalizationsEs extends AppLocalizations {
  AppLocalizationsEs([String locale = 'es']) : super(locale);

  @override
  String get appTitle => 'Gestor de Clientes Potenciales';

  @override
  String get systemMonitorTitle => 'Monitor del Sistema';

  @override
  String get systemMonitorSubtitle =>
      'Monitorear el estado de salud del backend';

  @override
  String get healthStatus => 'Estado de Salud';

  @override
  String get overallHealth => 'Salud General';

  @override
  String get liveStatus => 'Estado en Vivo';

  @override
  String get readyStatus => 'Estado Listo';

  @override
  String get healthy => 'Saludable';

  @override
  String get unhealthy => 'No Saludable';

  @override
  String get degraded => 'Degradado';

  @override
  String get checking => 'Verificando...';

  @override
  String get unknown => 'Desconocido';

  @override
  String lastUpdated(String time) {
    return 'Última actualización: $time';
  }

  @override
  String get refreshing => 'Actualizando...';

  @override
  String get refresh => 'Actualizar';

  @override
  String get autoRefresh => 'Actualización Automática';

  @override
  String autoRefreshInterval(int seconds) {
    return 'Actualizar cada $seconds segundos';
  }

  @override
  String get connectionError => 'Error de Conexión';

  @override
  String get connectionErrorMessage =>
      'No se puede conectar al servicio backend';

  @override
  String get retry => 'Reintentar';

  @override
  String get details => 'Detalles';

  @override
  String get serviceName => 'Nombre del Servicio';

  @override
  String get serviceStatus => 'Estado del Servicio';

  @override
  String get responseTime => 'Tiempo de Respuesta';

  @override
  String responseTimeMs(int ms) {
    return '$ms ms';
  }

  @override
  String get database => 'Base de Datos';

  @override
  String get api => 'API';

  @override
  String get cache => 'Caché';

  @override
  String get noDataAvailable => 'No hay datos disponibles';

  @override
  String get loading => 'Cargando...';

  @override
  String get error => 'Error';

  @override
  String get errorOccurred => 'Ocurrió un error';

  @override
  String get close => 'Cerrar';

  @override
  String get ok => 'OK';

  @override
  String get cancel => 'Cancelar';

  @override
  String get leads => 'Clientes Potenciales';

  @override
  String get leadManagement => 'Gestión de Clientes Potenciales';

  @override
  String get createLead => 'Crear Cliente Potencial';

  @override
  String get editLead => 'Editar Cliente Potencial';

  @override
  String get deleteLead => 'Eliminar Cliente Potencial';

  @override
  String get leadDetails => 'Detalles del Cliente Potencial';

  @override
  String get leadName => 'Nombre del Cliente Potencial';

  @override
  String get customerName => 'Nombre del Cliente';

  @override
  String get email => 'Correo Electrónico';

  @override
  String get phone => 'Teléfono';

  @override
  String get status => 'Estado';

  @override
  String get images => 'Imágenes';

  @override
  String get imageManagement => 'Gestión de Imágenes';

  @override
  String get addImage => 'Agregar Imagen';

  @override
  String get addImages => 'Agregar Imágenes';

  @override
  String get uploadImage => 'Subir Imagen';

  @override
  String get uploadImages => 'Subir Imágenes';

  @override
  String get deleteImage => 'Eliminar Imagen';

  @override
  String get replaceImage => 'Reemplazar Imagen';

  @override
  String get viewImage => 'Ver Imagen';

  @override
  String get imageGallery => 'Galería de Imágenes';

  @override
  String get viewImageGallery => 'Ver Galería de Imágenes';

  @override
  String get imageViewer => 'Visor de Imágenes';

  @override
  String get captureImage => 'Capturar Imagen';

  @override
  String get takePhoto => 'Tomar Foto';

  @override
  String get selectFromGallery => 'Seleccionar de la Galería';

  @override
  String get imageLimitReached => 'Límite de Imágenes Alcanzado';

  @override
  String imageLimitReachedMessage(int maxCount, int currentCount) {
    return 'Has alcanzado el máximo de $maxCount imágenes para este cliente potencial. Actualmente tienes $currentCount imágenes.';
  }

  @override
  String get yourOptions => 'Tus Opciones';

  @override
  String get replaceExistingImage => 'Reemplazar una imagen existente';

  @override
  String get deleteImageToMakeSpace => 'Eliminar una imagen para hacer espacio';

  @override
  String get cancelUpload => 'Cancelar subida';

  @override
  String get whatWouldYouLikeToDo => '¿Qué te gustaría hacer?';

  @override
  String nearImageLimit(int slotsRemaining) {
    return 'Solo quedan $slotsRemaining espacios para imágenes';
  }

  @override
  String get gotIt => 'Entendido';

  @override
  String get imageTooLarge => 'Imagen Demasiado Grande';

  @override
  String imageTooLargeMessage(String sizeInMB, String maxSizeInMB) {
    return 'La imagen es de ${sizeInMB}MB pero el tamaño máximo es ${maxSizeInMB}MB';
  }

  @override
  String get compressImageSuggestion => 'Podemos comprimir la imagen por ti';

  @override
  String get compressAndUpload => 'Comprimir y Subir';

  @override
  String get retryingUpload => 'Reintentando Subida';

  @override
  String get uploadFailed => 'Subida Fallida';

  @override
  String get retryUpload => 'Reintentar Subida';

  @override
  String get retryAllFailed => 'Reintentar Todas las Fallidas';

  @override
  String failedUploadsCount(int count) {
    return '$count subidas fallidas';
  }

  @override
  String get uploadProgress => 'Progreso de Subida';

  @override
  String get uploading => 'Subiendo...';

  @override
  String get uploadComplete => 'Subida Completa';

  @override
  String get uploadCancelled => 'Subida Cancelada';

  @override
  String get networkError => 'Error de Red';

  @override
  String get serverError => 'Error del Servidor';

  @override
  String get unknownError => 'Error Desconocido';

  @override
  String get search => 'Buscar';

  @override
  String get searchLeads => 'Buscar Clientes Potenciales';

  @override
  String get noLeadsFound => 'No se encontraron clientes potenciales';

  @override
  String get noImagesFound => 'No se encontraron imágenes';

  @override
  String get save => 'Guardar';

  @override
  String get update => 'Actualizar';

  @override
  String get delete => 'Eliminar';

  @override
  String get confirm => 'Confirmar';

  @override
  String get confirmDelete => 'Confirmar Eliminación';

  @override
  String get deleteConfirmationMessage =>
      '¿Estás seguro de que quieres eliminar este elemento? Esta acción no se puede deshacer.';

  @override
  String get yes => 'Sí';

  @override
  String get no => 'No';

  @override
  String get back => 'Atrás';

  @override
  String get next => 'Siguiente';

  @override
  String get previous => 'Anterior';

  @override
  String get done => 'Hecho';

  @override
  String get skip => 'Omitir';

  @override
  String get settings => 'Configuración';

  @override
  String get about => 'Acerca de';

  @override
  String get help => 'Ayuda';

  @override
  String get version => 'Versión';

  @override
  String get buildNumber => 'Número de Compilación';

  @override
  String get developer => 'Desarrollador';

  @override
  String get offlineMode => 'Modo Sin Conexión';

  @override
  String get onlineMode => 'Modo En Línea';

  @override
  String get syncData => 'Sincronizar Datos';

  @override
  String lastSync(String time) {
    return 'Última Sincronización: $time';
  }

  @override
  String imageLimitInfo(int current, int max) {
    return 'Límite de Imágenes: $current de $max';
  }

  @override
  String imagesSyncPending(int count) {
    return '$count imágenes pendientes de sincronización';
  }

  @override
  String storageUsed(String used, String total) {
    return 'Almacenamiento Usado: $used de $total';
  }

  @override
  String get cacheCleared => 'Caché limpiado exitosamente';

  @override
  String get clearCache => 'Limpiar Caché';

  @override
  String get maximumImagesReached =>
      'Máximo de 10 imágenes alcanzado. Elimina una para continuar.';

  @override
  String get deleteImageToAddMore => 'Elimina una imagen para agregar más';

  @override
  String slotsAvailable(int count) {
    return '$count espacios disponibles';
  }

  @override
  String get replaceImagePrompt =>
      '¿Te gustaría reemplazar una imagen existente?';

  @override
  String get replaceImageHint =>
      'Selecciona una imagen existente para reemplazar';

  @override
  String get deleteImageHint => 'Elimina una imagen para hacer espacio';

  @override
  String imageCountAnnouncement(int current, int total) {
    return 'Imagen $current de $total';
  }

  @override
  String imageLimitStatus(int current, int max) {
    return '$current de $max imágenes usadas';
  }

  @override
  String imageAddButtonAccessibility(int available, int max) {
    return 'Agregar imagen. $available espacios restantes de $max';
  }

  @override
  String imageAddButtonDisabledAccessibility(int max) {
    return 'No se puede agregar imagen. Límite de $max imágenes alcanzado';
  }

  @override
  String imageGalleryAccessibility(int count, int max) {
    return 'Galería de imágenes con $count imágenes. Máximo $max imágenes permitidas';
  }

  @override
  String get retrying => 'Reintentando...';

  @override
  String get maxRetriesReached => 'Máximo de intentos alcanzado';

  @override
  String get dismiss => 'Descartar';
}
