import 'dart:async';
import 'dart:convert';
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
    final transactionsJson = await _loadJsonFile();
    final emailCredentials = await _loadEmailCredentials();

    final databaseHelper = SqfliteServices();

    await databaseHelper.insertTransactionDetails(transactionsJson);

    final errorTransactions = await databaseHelper.fetchErrorTransactions();

    Isolate.spawn(insertTransactions, [errorTransactions, emailCredentials, sendPort, emailService], onExit: sendPort);

    receivePort.listen((data) {
      receivePort.close();
    });
    if (errorTransactions.isNotEmpty) await databaseHelper.updateErrorTransactions(errorTransactions);
  }

  static Future<List<Map<String, dynamic>>> _loadJsonFile() async {
    final jsonString = await rootBundle.loadString('lib/core/services/data/mail_json_data.json');
    final List<dynamic> jsonList = jsonDecode(jsonString);
    return jsonList.map((e) => e as Map<String, dynamic>).toList();
  }

  static Future<Map<String, dynamic>> _loadEmailCredentials() async {
    final jsonString = await rootBundle.loadString('lib/core/services/data/mail.json');
    final Map<String, dynamic> jsonMap = jsonDecode(jsonString);
    return jsonMap;
  }

  static void insertTransactions(List<dynamic> params) async {
    final errorTransactions = params[0] as List<Map<String, dynamic>>;
    final emailCred = params[1] as Map<String, dynamic>;
    final sendPort = params[2] as SendPort;
    final emailService = params[3] as EmailService;

    if (errorTransactions.isNotEmpty) {
      emailService.sendErrorEmail(errorTransactions, emailCred);
    } else {
      print('No error transactions found.');
    }

    print("mail success");

    sendPort.send(errorTransactions);
  }
}
