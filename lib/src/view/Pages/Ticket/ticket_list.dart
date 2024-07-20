import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:thiran_tech/core/res/colors.dart';
import 'package:thiran_tech/core/res/constant.dart';
import 'package:thiran_tech/core/services/internet_connection_service.dart';
import 'package:thiran_tech/core/utils.dart';
import 'package:thiran_tech/src/controllers/Ticket_Controllers/ticket_list_provider.dart';
import 'package:thiran_tech/src/view/Pages/Ticket/add_ticket.dart';

class TicketList extends ConsumerWidget {
  const TicketList({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ticketList = ref.watch(ticketProvider);
    final connectionStatus = ref.watch(networkNotifierProvider);

    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            const Text("Ticket List"),
            ElevatedButton(
              onPressed: () async {
                Utils().navigateTo(context, AddTicketList());
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.colorPrimaryLite,
                minimumSize: Size(150, 50),
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
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
          ],
        ),
      ),
      body: Container(
          width: AppConstants.screenWidth,
          height: AppConstants.screenHeight * 0.8,
          child: ticketList.isEmpty
              ? const Center(child: Text("Add list"))
              : connectionStatus.isConnected
                  ? ListView.separated(
                      separatorBuilder: (context, index) =>
                          const SizedBox(height: 15),
                      itemCount: ticketList.length,
                      itemBuilder: (context, index) {
                        final model = ticketList[index];
                        return ListTile(
                          title: Text(model.title),
                          subtitle: Text(model.description),
                        );
                      },
                    )
                  : const Center(child: Text("No internet"))),
    );
  }
}
