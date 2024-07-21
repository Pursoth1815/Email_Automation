import 'dart:io';

import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:thiran_tech/core/res/strings.dart';
import 'package:thiran_tech/core/services/database_services.dart';
import 'package:thiran_tech/src/models/ticket_model.dart';

class TicketStateNotifier extends StateNotifier<List<TicketModel>> {
  final DatabaseServices _databaseServices;

  TicketStateNotifier(this._databaseServices) : super([]) {
    _databaseServices.getTickets().listen((snapshot) {
      state = snapshot.docs.map((doc) => doc.data() as TicketModel).toList();
    });
  }

  Future<DocumentReference> addTicket(TicketModel model) async {
    return await _databaseServices.addTicket(model);
  }

  Future<String> uploadImage(File imageFile, TicketModel model) async {
    String img_url = await _databaseServices.uploadImage(imageFile);
    print(titleProvider.name);
    model = model.copyWith(attachment: img_url);

    if (img_url.isNotEmpty) {
      try {
        DocumentReference docRef = await addTicket(model);
        if (docRef.id.isNotEmpty) {
          pushNotification();
          print("data inserted");
        } else {
          print("data not inserted");
        }
      } catch (e) {
        print("error in insertion");
      }
    }
    return '';
  }

  Future<void> pushNotification() async {
    try {
      await AwesomeNotifications().isNotificationAllowed().then((isAllowed) {
        if (!isAllowed) {
          AwesomeNotifications().requestPermissionToSendNotifications(
            permissions: [
              NotificationPermission.Alert,
              NotificationPermission.Sound,
              NotificationPermission.Badge,
              NotificationPermission.Vibration,
              NotificationPermission.Light,
              NotificationPermission.FullScreenIntent,
            ],
          );
        } else {
          generateNotification();
        }
      });
    } catch (e) {
      print('Error writing PDF to file: $e');
      return;
    }
  }

  Future<void> generateNotification() async {
    await AwesomeNotifications().createNotification(
      content: NotificationContent(
        id: 10,
        channelKey: 'thiran_tech_channel',
        title: AppStrings.appName,
        body: AppStrings.ticketInsertMsg,
        wakeUpScreen: true,
        fullScreenIntent: true,
        criticalAlert: true,
      ),
    );
  }
}

final ticketProvider =
    StateNotifierProvider<TicketStateNotifier, List<TicketModel>>((ref) {
  final databaseServices = ref.read(databaseServicesProvider);
  return TicketStateNotifier(databaseServices);
});

final titleProvider = StateProvider<String>((ref) => '');
final descriptionProvider = StateProvider<String>((ref) => '');
final locationProvider = StateProvider<String>((ref) => '');
final fileProvider = StateProvider<File>((ref) => File(''));
