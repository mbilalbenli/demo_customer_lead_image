import 'package:flutter/material.dart';
import '../../../../core/presentation/base/base_page.dart';

class MainPage extends BasePage {
  const MainPage({super.key});

  @override
  MainPageState createState() => MainPageState();
}

class MainPageState extends BasePageState<MainPage> {
  @override
  PreferredSizeWidget? buildAppBar(BuildContext context) {
    return AppBar(title: const Text('Demo App'));
  }

  @override
  Widget buildBody(BuildContext context) {
    return Container(color: Colors.white);
  }
}

