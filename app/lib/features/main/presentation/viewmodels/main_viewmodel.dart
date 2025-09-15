import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../states/main_state.dart';

class MainViewModel extends StateNotifier<MainState> {
  MainViewModel() : super(const MainState.initial());
}

