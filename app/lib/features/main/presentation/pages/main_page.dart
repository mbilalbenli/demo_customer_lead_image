import 'package:flutter/material.dart';
import '../../../../core/presentation/base/base_page.dart';
import '../../../../core/utils/temp_l10n.dart';

class MainPage extends BasePage {
  const MainPage({super.key});

  @override
  MainPageState createState() => MainPageState();
}

class MainPageState extends BasePageState<MainPage> {
  @override
  PreferredSizeWidget? buildAppBar(BuildContext context) {
    return AppBar(title: const Text(TempL10n.appName));
  }

  @override
  Widget buildBody(BuildContext context) {
    return Container(color: Colors.white);
  }
}
