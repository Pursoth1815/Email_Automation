import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'dart:isolate';

import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:thiran_tech/core/res/colors.dart';
import 'package:thiran_tech/core/res/constant.dart';
import 'package:thiran_tech/core/services/email_services.dart';
import 'package:thiran_tech/core/services/sqflite_services.dart';
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
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final emailService = EmailService();

  @override
  void initState() {
    super.initState();
    _insertTransactions();
  }

  @override
  Widget build(BuildContext context) {
    AppConstants.init(context);

    return const MaterialApp(
      home: RepositoryLists(),
    );
  }

  Future? _insertTransactions() async {
    ReceivePort receivePort = ReceivePort();
    final sendPort = receivePort.sendPort;
    final transactionsJson = await _loadJsonFile();
    log("start >>>>>>>>>>");

    final databaseHelper = SqfliteServices();

    await databaseHelper.insertTransactionDetails(transactionsJson);

    final errorTransactions = await databaseHelper.fetchErrorTransactions();

    Isolate.spawn(
        insertTransactions, [errorTransactions, sendPort, emailService],
        onExit: sendPort);
    log("spawn complete >>>>>>>>>>");

    receivePort.listen((data) {
      print("%%%%%%%%%%%%%%%% $data");
      receivePort.close();
    });
  }

  static Future<List<Map<String, dynamic>>> _loadJsonFile() async {
    final jsonString = await rootBundle
        .loadString('lib/core/services/data/mail_json_data.json');
    final List<dynamic> jsonList = jsonDecode(jsonString);
    return jsonList.map((e) => e as Map<String, dynamic>).toList();
  }

  static void insertTransactions(List<dynamic> params) async {
    final errorTransactions = params[0] as List<Map<String, dynamic>>;
    final sendPort = params[1] as SendPort;
    final emailService = params[2] as EmailService;

    if (errorTransactions.isNotEmpty) {
      emailService.sendErrorEmail(errorTransactions);
    } else {
      print('No error transactions found.');
    }

    print("mail success");

    sendPort.send(errorTransactions);
  }
}
