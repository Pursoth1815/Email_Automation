import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:thiran_tech/firebase_options.dart';
import 'package:thiran_tech/res/constant.dart';
import 'package:thiran_tech/view/pages/ticket_list.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    AppConstants.init(context);

    return const MaterialApp(
      home: TicketList(),
    );
  }
}
