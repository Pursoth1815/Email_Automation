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

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: RepositoryLists(),
      builder: (context, child) {
        return MediaQuery(
          child: child!,
          data: MediaQuery.of(context).copyWith(textScaler: TextScaler.linear(1.0)),
        );
      },
    );
  }

  Future? _insertTransactions() async {
    ReceivePort receivePort = ReceivePort();
    final sendPort = receivePort.sendPort;
    final transactionsJson = await _loadJsonFile("lib/core/services/data/mail_json_data.json");

    final databaseHelper = SqfliteServices();

    await databaseHelper.insertTransactionDetails(transactionsJson);

    final errorTransactions = await databaseHelper.fetchErrorTransactions();

    Isolate.spawn(insertTransactions, [errorTransactions, sendPort, emailService], onExit: sendPort);

    receivePort.listen((data) {
      log(data);
      log(data.runtimeType.toString());
      if (data == "true") {
        databaseHelper.updateErrorTransactions(errorTransactions);
      }
      receivePort.close();
    });
  }

  static Future<dynamic> _loadJsonFile(String path) async {
    final jsonString = await rootBundle.loadString(path);
    final dynamic jsonList = jsonDecode(jsonString);
    if (jsonList is List<Map<String, dynamic>>) {
      return jsonList.map((e) => e).toList();
    } else {
      return jsonList;
    }
  }

  static void insertTransactions(List<dynamic> params) async {
    final errorTransactions = params[0] as List<Map<String, dynamic>>;
    final sendPort = params[1] as SendPort;
    final emailService = params[2] as EmailService;
    bool flag = false;
    if (errorTransactions.isNotEmpty) {
      flag = await emailService.sendEmailv2(errorTransactions);
    } else {
      print('No error transactions found.');
    }

    sendPort.send(flag.toString());
  }
}
