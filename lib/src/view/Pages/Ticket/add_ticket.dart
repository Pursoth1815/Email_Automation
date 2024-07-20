import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:thiran_tech/core/res/colors.dart';
import 'package:thiran_tech/core/utils.dart';
import 'package:thiran_tech/src/controllers/Ticket_Controllers/ticket_list_provider.dart';
import 'package:thiran_tech/src/models/ticket_model.dart';

class AddTicketList extends ConsumerStatefulWidget {
  const AddTicketList({super.key});

  @override
  _AddTicketListState createState() => _AddTicketListState();
}

class _AddTicketListState extends ConsumerState<AddTicketList> {
  @override
  void initState() {
    super.initState();
    requestNotificationPermission();
  }

  Future<void> requestNotificationPermission() async {
    bool isAllowed = await AwesomeNotifications().isNotificationAllowed();
    if (!isAllowed) {
      await AwesomeNotifications().requestPermissionToSendNotifications(
        permissions: [
          NotificationPermission.Alert,
          NotificationPermission.Sound,
          NotificationPermission.Badge,
          NotificationPermission.Vibration,
          NotificationPermission.Light,
          NotificationPermission.FullScreenIntent,
        ],
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Add Ticket'),
        ),
        body: Center(
          child: ElevatedButton(
            onPressed: () async {
              final imgFile = await Utils().pickImage();

              if (imgFile != null) {
                String imgPath = await ref
                    .read(ticketProvider.notifier)
                    .uploadImage(imgFile);

                if (imgPath.isNotEmpty) {
                  TicketModel model = TicketModel(
                    title: "Pull Issue",
                    description: "Pull command not works",
                    location: "Chennai",
                    reportedDate: DateTime.now(),
                    attachment: imgPath,
                  );

                  try {
                    DocumentReference docRef = await ref
                        .read(ticketProvider.notifier)
                        .addTicket(model);
                    if (docRef.id.isNotEmpty) {
                      ref.read(ticketProvider.notifier).pushNotification();
                      print("data inserted");
                    } else {
                      print("data not inserted");
                    }
                  } catch (e) {
                    print("error in insertion");
                  }
                }
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.colorPrimaryLite,
              minimumSize: const Size(150, 50),
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(25.0),
              ),
              elevation: 4,
            ),
            child: const Text(
              'Add Ticket',
              style: TextStyle(
                color: AppColors.white,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ));
  }
}
