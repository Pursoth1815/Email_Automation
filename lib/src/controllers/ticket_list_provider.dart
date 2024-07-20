import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:thiran_tech/core/res/strings.dart';
import 'package:thiran_tech/core/services/database_services.dart';
import 'package:thiran_tech/src/models/ticket_model.dart';
import 'dart:io';

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

  Future<String> uploadImage(File imageFile) async {
    return await _databaseServices.uploadImage(imageFile);
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

final ticketProvider = StateNotifierProvider<TicketStateNotifier, List<TicketModel>>((ref) {
  final databaseServices = ref.read(databaseServicesProvider);
  return TicketStateNotifier(databaseServices);
});
