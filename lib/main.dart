import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:thiran_tech/core/res/colors.dart';
import 'package:thiran_tech/core/res/constant.dart';
import 'package:thiran_tech/firebase_options.dart';
import 'package:thiran_tech/src/view/Pages/GitHub_Repo/github_list.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await AwesomeNotifications().initialize(
    null,
    [
      NotificationChannel(
        channelKey: 'thiran_tech_channel',
        channelName: 'thiran_tech',
        channelDescription: 'App Push Notification',
        importance: NotificationImportance.Max,
        defaultColor: AppColors.colorPrimary,
        ledColor: AppColors.colorPrimaryDark,
        playSound: true,
        enableVibration: true,
        icon: null,
      )
    ],
    debug: true,
  );
  runApp(const ProviderScope(child: MainApp()));
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    AppConstants.init(context);

    return const MaterialApp(
      home: GithubList(),
    );
  }
}
