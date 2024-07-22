import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:thiran_tech/core/res/colors.dart';
import 'package:thiran_tech/core/res/constant.dart';
import 'package:thiran_tech/core/res/image_path.dart';
import 'package:thiran_tech/core/res/strings.dart';
import 'package:thiran_tech/core/utils.dart';
import 'package:thiran_tech/src/controllers/Ticket_Controllers/ticket_list_provider.dart';
import 'package:thiran_tech/src/models/ticket_model.dart';
import 'package:thiran_tech/src/view/Pages/Ticket/widgets/input_text.dart';
import 'package:thiran_tech/src/view/components/dotted_border.dart';
import 'package:thiran_tech/src/view/components/snackbar.dart';

class AddTicketList extends ConsumerStatefulWidget {
  const AddTicketList({super.key});

  @override
  _AddTicketListState createState() => _AddTicketListState();
}

class _AddTicketListState extends ConsumerState<AddTicketList> {
  late TextEditingController _titleController;
  late TextEditingController _descriptionController;
  late TextEditingController _locationController;

  @override
  void initState() {
    super.initState();
    requestNotificationPermission();

    _titleController = TextEditingController(text: ref.read(titleProvider));
    _descriptionController = TextEditingController(text: ref.read(descriptionProvider));
    _locationController = TextEditingController(text: ref.read(locationProvider));
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _locationController.dispose();
    super.dispose();
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
    return WillPopScope(
      onWillPop: () async {
        ref.read(ticketProvider.notifier).clearAllValues();
        return true;
      },
      child: Scaffold(
          resizeToAvoidBottomInset: false,
          backgroundColor: AppColors.light_black,
          appBar: _homeAppbar(),
          body: Align(
            alignment: Alignment.bottomCenter,
            child: SingleChildScrollView(
              child: Container(
                  width: AppConstants.screenWidth,
                  height: (AppConstants.screenHeight * 0.8),
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  decoration: BoxDecoration(
                    color: AppColors.whiteLite,
                    borderRadius: BorderRadius.vertical(
                      top: Radius.circular(75),
                    ),
                  ),
                  child: Container(
                    margin: EdgeInsets.symmetric(horizontal: 20, vertical: 30),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        CustomInputText(
                          controller: _titleController,
                          hintText: AppStrings.title,
                        ),
                        CustomInputText(
                          controller: _locationController,
                          hintText: AppStrings.location,
                          mutiline: true,
                        ),
                        CustomInputText(
                          controller: _descriptionController,
                          hintText: AppStrings.description,
                        ),
                        Container(
                          margin: EdgeInsets.only(top: 20),
                          child: Consumer(
                            builder: (context, ref, child) {
                              final imageFile = ref.watch(fileProvider);
                              if (imageFile != null) {
                                return InkWell(
                                  onTap: () async => ref.read(fileProvider.notifier).state = await Utils().pickImage() ?? null,
                                  child: Container(
                                    height: AppConstants.screenHeight * 0.2,
                                    decoration: BoxDecoration(
                                      image: DecorationImage(image: FileImage(imageFile), fit: BoxFit.cover, filterQuality: FilterQuality.high),
                                      borderRadius: BorderRadius.circular(15),
                                    ),
                                  ),
                                );
                              } else {
                                return CustomPaint(
                                  painter: DashedPainter(color: AppColors.colorPrimarySecondary, strokeWidth: 2, dashPattern: [20, 20], radius: Radius.circular(20)),
                                  child: Container(
                                    height: AppConstants.screenHeight * 0.2,
                                    decoration: BoxDecoration(
                                      color: AppColors.colorPrimary.withOpacity(0.1),
                                      borderRadius: BorderRadius.circular(15),
                                    ),
                                    child: Center(
                                      child: InkWell(
                                        onTap: () async {
                                          ref.read(fileProvider.notifier).state = await Utils().pickImage() ?? null;
                                        },
                                        child: Column(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: [
                                            Image.asset(
                                              ImagePath.folder,
                                              width: 100,
                                              height: 100,
                                            ),
                                            Text(
                                              AppStrings.select_file,
                                              style: TextStyle(
                                                fontSize: 12,
                                                wordSpacing: 5,
                                                fontWeight: FontWeight.w400,
                                                color: AppColors.grey,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                );
                              }
                            },
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.only(top: 20),
                          alignment: Alignment.centerRight,
                          child: Text(
                            "${AppStrings.reported_date}  :  ${Utils().getCurrentDate()}",
                            style: TextStyle(
                              fontSize: 11,
                              color: AppColors.blackLite,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                        Spacer(),
                        Padding(
                          padding: EdgeInsets.only(top: 25),
                          child: ElevatedButton(
                            onPressed: () async {
                              if (_titleController.text.isEmpty) {
                                showCustomSnackBar(context, "Title Should not be Empty");
                                // Utils().showCustomSnackBar(context, "Title Should not be Empty");
                                return;
                              } else if (_descriptionController.text.isEmpty) {
                                return;
                              } else if (_locationController.text.isEmpty) {
                                return;
                              } else if (ref.read(fileProvider) == null) {
                                return;
                              }
                              TicketModel finalList =
                                  TicketModel(title: _titleController.text, description: _descriptionController.text, location: _locationController.text, reportedDate: DateTime.now(), attachment: '');

                              bool flag = await ref.read(ticketProvider.notifier).uploadImage(ref.read(fileProvider)!, finalList);
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.green,
                              minimumSize: const Size(300, 50),
                              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(25.0),
                              ),
                              elevation: 4,
                            ),
                            child: ref.watch(isLoading)
                                ? CircularProgressIndicator(
                                    strokeWidth: 3,
                                    color: AppColors.white,
                                  )
                                : Text(
                                    AppStrings.save,
                                    style: TextStyle(
                                      letterSpacing: 8,
                                      fontSize: 14,
                                      color: AppColors.white,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                          ),
                        ),
                        Spacer(),
                      ],
                    ),
                  )),
            ),
          )),
    );
  }

  AppBar _homeAppbar() {
    return AppBar(
      backgroundColor: AppColors.light_black,
      leading: InkWell(
        onTap: () {
          ref.read(ticketProvider.notifier).clearAllValues();
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
      centerTitle: true,
      title: Padding(
        padding: const EdgeInsets.only(top: 15.0),
        child: Text(
          AppStrings.add_ticket.toUpperCase(),
          style: TextStyle(
            wordSpacing: 8,
            letterSpacing: 4,
            color: AppColors.whiteLite,
            fontSize: 15,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
      automaticallyImplyLeading: false,
    );
  }
}
