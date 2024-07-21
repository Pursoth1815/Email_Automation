import 'dart:developer';
import 'dart:io';

import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:thiran_tech/core/res/strings.dart';
import 'package:thiran_tech/core/services/database_services.dart';
import 'package:thiran_tech/src/models/ticket_model.dart';

class TicketStateNotifier extends StateNotifier<List<TicketModel>> {
  final DatabaseServices _databaseServices;
  final Ref ref;

  TicketStateNotifier(this._databaseServices, this.ref) : super([]) {
    _databaseServices.getTickets().listen((snapshot) {
      state = snapshot.docs.map((doc) => doc.data() as TicketModel).toList();
    });
  }

  Future<DocumentReference> addTicket(TicketModel model) async {
    return await _databaseServices.addTicket(model);
  }

  Future<bool> uploadImage(File imageFile, TicketModel model) async {
    ref.read(isLoading.notifier).state = true;
    String img_url = await _databaseServices.uploadImage(imageFile);

    model = model.copyWith(attachment: img_url);

    if (img_url.isNotEmpty) {
      try {
        DocumentReference docRef = await addTicket(model);
        if (docRef.id.isNotEmpty) {
          pushNotification();
          clearAllValues();
          return true;
        }
      } catch (e) {
        log("$e");
        return false;
      } finally {
        ref.read(isLoading.notifier).state = false;
      }
    }
    ref.read(isLoading.notifier).state = false;
    return false;
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

  void clearAllValues() {
    ref.read(isLoading.notifier).state = false;
    ref.read(titleProvider.notifier).state = '';
    ref.read(descriptionProvider.notifier).state = '';
    ref.read(locationProvider.notifier).state = '';
    ref.read(fileProvider.notifier).state = null;
  }
}

final ticketProvider =
    StateNotifierProvider<TicketStateNotifier, List<TicketModel>>((ref) {
  final databaseServices = ref.read(databaseServicesProvider);
  return TicketStateNotifier(databaseServices, ref);
});

final isLoading = StateProvider<bool>((ref) => false);
final titleProvider = StateProvider<String>((ref) => '');
final descriptionProvider = StateProvider<String>((ref) => '');
final locationProvider = StateProvider<String>((ref) => '');
final fileProvider = StateProvider<File?>((ref) => null);
