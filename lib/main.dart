import 'package:flutter/material.dart';

import 'app_controller.dart';
import 'lia_app.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final controller = AppController();
  await controller.load();
  runApp(LiaSimplisApp(controller: controller));
}
