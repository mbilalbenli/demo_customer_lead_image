import 'package:freezed_annotation/freezed_annotation.dart';
import '../../../../core/utils/temp_l10n.dart';

part 'splash_state.freezed.dart';

@freezed
abstract class SplashState with _$SplashState {
  const factory SplashState({
    @Default(TempL10n.loading) String message,
    @Default(true) bool isLoading,
    @Default(false) bool allResponsesReceived,
    @Default(0) int responsesCount,
    @Default(false) bool shouldNavigate,
    @Default(false) bool shouldRetry,
  }) = _SplashState;
}
