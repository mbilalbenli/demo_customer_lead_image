import 'package:flutter/material.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import '../../../../core/base/base_state.dart';
import '../../domain/entities/upload_queue_item_entity.dart';
import '../../domain/entities/upload_options_entity.dart';

part 'image_upload_state.freezed.dart';

@freezed
abstract class ImageUploadState with _$ImageUploadState implements BaseState {
  const ImageUploadState._();

  const factory ImageUploadState({
    @Default(CoreState()) CoreState core,
    required String leadId,
    @Default(<UploadQueueItemEntity>[]) List<UploadQueueItemEntity> queue,
    @Default(false) bool isUploading,
    @Default(0.0) double totalProgress,
    @Default(UploadOptionsEntity()) UploadOptionsEntity options,
    String? errorMessage,
  }) = _ImageUploadState;

  @override
  bool get isBusy => core.isBusy || isUploading;

  @override
  bool get showAppBar => core.showAppBar;

  @override
  String get busyOperation => core.busyOperation;

  @override
  String get title => 'Upload Images';

  @override
  GlobalKey? get widgetKeyForLoadingPosition => core.widgetKeyForLoadingPosition;

  int get queuedCount => queue.length;
}
