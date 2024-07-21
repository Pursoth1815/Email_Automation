import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:thiran_tech/core/res/colors.dart';
import 'package:thiran_tech/core/res/constant.dart';
import 'package:thiran_tech/core/res/image_path.dart';
import 'package:thiran_tech/core/res/strings.dart';
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
      backgroundColor: AppColors.light_black,
      appBar: _homeAppbar(context),
      body: Align(
        alignment: Alignment.bottomCenter,
        child: Container(
            width: AppConstants.screenWidth,
            height: (AppConstants.screenHeight * 0.85),
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
            decoration: BoxDecoration(
              color: AppColors.whiteLite,
              borderRadius: BorderRadius.vertical(
                top: Radius.circular(75),
              ),
            ),
            child: Column(
              children: [
                Container(
                  margin: EdgeInsets.only(right: 15, bottom: 15, top: 15),
                  alignment: Alignment.centerRight,
                  child: ElevatedButton(
                    onPressed: () =>
                        Utils().navigateTo(context, AddTicketList()),
                    style: ButtonStyle(
                      shape: WidgetStateProperty.all<RoundedRectangleBorder>(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                      ),
                      backgroundColor: WidgetStatePropertyAll(AppColors.green),
                    ),
                    child: Text(
                      AppStrings.add_ticket,
                      style: TextStyle(
                        color: AppColors.white,
                        letterSpacing: 2,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                ticketList.isEmpty
                    ? const Center(child: Text("Add list"))
                    : connectionStatus.isConnected
                        ? Expanded(
                            child: ListView.separated(
                              separatorBuilder: (context, index) =>
                                  const SizedBox(height: 15),
                              itemCount: ticketList.length,
                              itemBuilder: (context, index) {
                                final model = ticketList[index];
                                return Container(
                                  padding: EdgeInsets.all(10),
                                  decoration: BoxDecoration(
                                    color: AppColors.white,
                                    borderRadius: BorderRadius.circular(13),
                                  ),
                                  child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceEvenly,
                                          children: [
                                            Text(
                                              model.title,
                                              style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 18,
                                              ),
                                            ),
                                            Text(
                                              model.description,
                                              maxLines: 3,
                                              overflow: TextOverflow.ellipsis,
                                              style: TextStyle(
                                                fontSize: 14,
                                                color: Colors.black38,
                                              ),
                                            ),
                                            Container(
                                              margin: EdgeInsets.only(top: 15),
                                              child: Row(
                                                children: [
                                                  Icon(
                                                    Icons.location_on,
                                                    color: AppColors.DarkPink,
                                                  ),
                                                  SizedBox(
                                                    width: 10,
                                                  ),
                                                  Expanded(
                                                    child: Text(
                                                      model.location,
                                                      maxLines: 1,
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                      style: TextStyle(
                                                        color: Colors.black38,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        fontSize: 15,
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Image.asset(
                                            ImagePath.gallery,
                                            width: 35,
                                            height: 35,
                                          ),
                                          SizedBox(height: 5),
                                          Text(
                                            AppStrings.view_image,
                                            style: TextStyle(
                                              fontSize: 17,
                                              fontWeight: FontWeight.w400,
                                              color: AppColors.grey,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                );
                              },
                            ),
                          )
                        : const Center(child: Text("No internet")),
              ],
            )),
      ),
    );
  }

  AppBar _homeAppbar(BuildContext context) {
    return AppBar(
      backgroundColor: AppColors.light_black,
      leading: InkWell(
        onTap: () {
          Navigator.of(context).pop();
        },
        child: Padding(
          padding: const EdgeInsets.only(left: 8.0, top: 15.0),
          child: Icon(
            Icons.arrow_back_ios,
            color: AppColors.whiteLite,
          ),
        ),
      ),
      automaticallyImplyLeading: false,
      centerTitle: true,
      title: Padding(
        padding: const EdgeInsets.only(top: 15.0),
        child: Text(
          AppStrings.ticket_list.toUpperCase(),
          style: TextStyle(
            wordSpacing: 8,
            letterSpacing: 4,
            color: AppColors.whiteLite,
            fontSize: 20,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }
}
