import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../states/main_state.dart';
import '../viewmodels/main_viewmodel.dart';

final mainViewModelProvider = StateNotifierProvider<MainViewModel, MainState>((ref) {
  return MainViewModel();
});

