import 'package:freezed_annotation/freezed_annotation.dart';

part 'splash_state.freezed.dart';

@freezed
abstract class SplashState with _$SplashState {
  const factory SplashState({
    @Default(false) bool systemDone,
    @Default(false) bool liveDone,
    @Default(false) bool readyDone,
    @Default(false) bool systemOk,
    @Default(false) bool liveOk,
    @Default(false) bool readyOk,
    @Default('') String message,
    @Default(false) bool completed,
  }) = _SplashState;
}
