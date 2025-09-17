import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';
import 'image_limit_providers.dart';
import '../../../../core/utils/app_logger.dart';

// Upload Queue Manager Provider
final uploadQueueManagerProvider = StateNotifierProvider.family<
    UploadQueueManager, UploadQueueState, String>(
  (ref, leadId) => UploadQueueManager(ref, leadId),
);

// Active Uploads Provider - tracks currently uploading items
final activeUploadsProvider = Provider.family<List<UploadQueueItem>, String>(
  (ref, leadId) {
    final queueState = ref.watch(uploadQueueManagerProvider(leadId));
    return queueState.items
        .where((item) => item.status == UploadStatus.uploading)
        .toList();
  },
);

// Pending Uploads Provider - tracks items waiting to upload
final pendingUploadsProvider = Provider.family<List<UploadQueueItem>, String>(
  (ref, leadId) {
    final queueState = ref.watch(uploadQueueManagerProvider(leadId));
    return queueState.items
        .where((item) => item.status == UploadStatus.pending)
        .toList();
  },
);

// Failed Uploads Provider - tracks failed upload attempts
final failedUploadsProvider = Provider.family<List<UploadQueueItem>, String>(
  (ref, leadId) {
    final queueState = ref.watch(uploadQueueManagerProvider(leadId));
    return queueState.items
        .where((item) => item.status == UploadStatus.failed)
        .toList();
  },
);

// Upload Progress Provider - overall progress for all uploads
final overallUploadProgressProvider = Provider.family<double?, String>(
  (ref, leadId) {
    final queueState = ref.watch(uploadQueueManagerProvider(leadId));
    if (queueState.items.isEmpty) return null;

    final totalItems = queueState.items.length;
    final completedItems = queueState.items
        .where((item) => item.status == UploadStatus.completed)
        .length;

    final uploadingProgress = queueState.items
        .where((item) => item.status == UploadStatus.uploading)
        .fold<double>(0.0, (sum, item) => sum + (item.progress ?? 0.0));

    final totalProgress = completedItems + uploadingProgress;
    return totalProgress / totalItems;
  },
);

// Upload Queue State
class UploadQueueState {
  final List<UploadQueueItem> items;
  final bool isProcessing;
  final int maxConcurrent;
  final String? currentError;

  const UploadQueueState({
    this.items = const [],
    this.isProcessing = false,
    this.maxConcurrent = 3,
    this.currentError,
  });

  UploadQueueState copyWith({
    List<UploadQueueItem>? items,
    bool? isProcessing,
    int? maxConcurrent,
    String? currentError,
  }) {
    return UploadQueueState(
      items: items ?? this.items,
      isProcessing: isProcessing ?? this.isProcessing,
      maxConcurrent: maxConcurrent ?? this.maxConcurrent,
      currentError: currentError ?? this.currentError,
    );
  }

  int get pendingCount =>
      items.where((item) => item.status == UploadStatus.pending).length;

  int get uploadingCount =>
      items.where((item) => item.status == UploadStatus.uploading).length;

  int get completedCount =>
      items.where((item) => item.status == UploadStatus.completed).length;

  int get failedCount =>
      items.where((item) => item.status == UploadStatus.failed).length;

  bool get hasFailures => failedCount > 0;

  bool get isComplete => pendingCount == 0 && uploadingCount == 0;
}

// Upload Queue Manager
class UploadQueueManager extends StateNotifier<UploadQueueState> {
  final Ref ref;
  final String leadId;
  final _uuid = const Uuid();

  UploadQueueManager(this.ref, this.leadId)
      : super(const UploadQueueState());

  // Add single image to queue
  Future<bool> addToQueue(
    String base64Data, {
    String? fileName,
  }) async {
    try {
      // Check if can add more images
      final canAdd = ref.read(canAddImageProvider(leadId));
      if (!canAdd) {
        AppLogger.warning('Cannot add more images, limit reached');
        state = state.copyWith(
          currentError: 'Image limit reached. Delete an image to add more.',
        );
        return false;
      }

      final item = UploadQueueItem(
        id: _uuid.v4(),
        leadId: leadId,
        base64Data: base64Data,
        fileName: fileName,
        addedAt: DateTime.now(),
      );

      state = state.copyWith(
        items: [...state.items, item],
        currentError: null,
      );

      // Start processing if not already
      if (!state.isProcessing) {
        _processQueue();
      }

      return true;
    } catch (e) {
      AppLogger.error('Failed to add to upload queue', e);
      state = state.copyWith(
        currentError: 'Failed to add image to queue',
      );
      return false;
    }
  }

  // Add multiple images to queue
  Future<int> addBatchToQueue(
    List<String> base64DataList, {
    List<String>? fileNames,
  }) async {
    try {
      // Check how many can be added
      final slotsAvailable = ref.read(slotsAvailableProvider(leadId));
      final itemsToAdd = base64DataList.take(slotsAvailable).toList();

      if (itemsToAdd.isEmpty) {
        AppLogger.warning('No slots available for batch upload');
        state = state.copyWith(
          currentError: 'No slots available. Delete images to add more.',
        );
        return 0;
      }

      final newItems = <UploadQueueItem>[];
      for (int i = 0; i < itemsToAdd.length; i++) {
        newItems.add(UploadQueueItem(
          id: _uuid.v4(),
          leadId: leadId,
          base64Data: itemsToAdd[i],
          fileName: fileNames?.elementAtOrNull(i),
          addedAt: DateTime.now(),
        ));
      }

      state = state.copyWith(
        items: [...state.items, ...newItems],
        currentError: null,
      );

      // Start processing if not already
      if (!state.isProcessing) {
        _processQueue();
      }

      return newItems.length;
    } catch (e) {
      AppLogger.error('Failed to add batch to upload queue', e);
      state = state.copyWith(
        currentError: 'Failed to add images to queue',
      );
      return 0;
    }
  }

  // Process the upload queue
  Future<void> _processQueue() async {
    if (state.isProcessing) return;

    state = state.copyWith(isProcessing: true);

    try {
      while (state.pendingCount > 0) {
        // Check if can upload more concurrently
        if (state.uploadingCount >= state.maxConcurrent) {
          await Future.delayed(const Duration(milliseconds: 500));
          continue;
        }

        // Get next pending item
        final pendingItem = state.items.firstWhere(
          (item) => item.status == UploadStatus.pending,
        );

        // Update status to uploading
        _updateItemStatus(pendingItem.id, UploadStatus.uploading);

        // Simulate upload (replace with actual upload logic)
        _uploadItem(pendingItem);
      }
    } finally {
      state = state.copyWith(isProcessing: false);
    }
  }

  // Upload individual item
  Future<void> _uploadItem(UploadQueueItem item) async {
    try {
      AppLogger.info('Uploading image ${item.id}');

      // Simulate progress updates
      for (double progress = 0.0; progress <= 1.0; progress += 0.1) {
        await Future.delayed(const Duration(milliseconds: 200));
        _updateItemProgress(item.id, progress);
      }

      // TODO: Actual upload logic here
      // final result = await uploadUseCase(item.leadId, item.base64Data);

      _updateItemStatus(item.id, UploadStatus.completed);
      AppLogger.info('Upload completed for ${item.id}');
    } catch (e) {
      AppLogger.error('Upload failed for ${item.id}', e);
      _updateItemStatus(
        item.id,
        UploadStatus.failed,
        error: e.toString(),
      );
    }
  }

  // Update item status
  void _updateItemStatus(
    String itemId,
    UploadStatus status, {
    String? error,
  }) {
    state = state.copyWith(
      items: state.items.map((item) {
        if (item.id == itemId) {
          return item.copyWith(status: status, error: error);
        }
        return item;
      }).toList(),
    );
  }

  // Update item progress
  void _updateItemProgress(String itemId, double progress) {
    state = state.copyWith(
      items: state.items.map((item) {
        if (item.id == itemId) {
          return item.copyWith(progress: progress);
        }
        return item;
      }).toList(),
    );
  }

  // Retry failed uploads
  Future<void> retryFailed() async {
    final failedItems = state.items
        .where((item) => item.status == UploadStatus.failed)
        .toList();

    for (final item in failedItems) {
      _updateItemStatus(item.id, UploadStatus.pending);
    }

    if (!state.isProcessing) {
      _processQueue();
    }
  }

  // Cancel upload
  void cancelUpload(String itemId) {
    state = state.copyWith(
      items: state.items.where((item) => item.id != itemId).toList(),
    );
  }

  // Clear completed uploads
  void clearCompleted() {
    state = state.copyWith(
      items: state.items
          .where((item) => item.status != UploadStatus.completed)
          .toList(),
    );
  }

  // Clear all uploads
  void clearAll() {
    state = const UploadQueueState();
  }
}