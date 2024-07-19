import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:thiran_tech/models/ticket_model.dart';
import 'package:thiran_tech/res/colors.dart';
import 'package:thiran_tech/res/constant.dart';
import 'package:thiran_tech/services/database_services.dart';

class TicketList extends StatelessWidget {
  const TicketList({super.key});

  @override
  Widget build(BuildContext context) {
    final DatabaseServices _databaseServices = DatabaseServices();
    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Text("Ticket List"),
            ElevatedButton(
              onPressed: () async {
                final img_file = await pickAndUploadImage();

                if (img_file != null) {
                  String imgPath =
                      await _databaseServices.uploadImage(img_file);

                  if (imgPath != '') {
                    TicketModel model = TicketModel(
                        title: "Storage Issue Gone Wrong",
                        description: "Somethine Went wrong here in Storage",
                        location: "coimbatore",
                        reportedDate: DateTime.now(),
                        attachment: imgPath);

                    _databaseServices.addTicket(model);
                  }
                }

                // Add ticket with the uploaded image
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
              child: Text(
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
        child: StreamBuilder(
          stream: _databaseServices.getTickets(),
          builder: (context, snapshot) {
            List ticketList = snapshot.data?.docs ?? [];
            if (ticketList.isEmpty) {
              return Center(
                child: Text("Add list"),
              );
            }
            return ListView.separated(
              separatorBuilder: (context, index) => SizedBox(
                height: 15,
              ),
              itemCount: ticketList.length,
              itemBuilder: (context, index) {
                TicketModel modelList = ticketList[index].data();

                return ListTile(
                  title: Text(modelList.title),
                  subtitle: Text(modelList.description),
                );
              },
            );
          },
        ),
      ),
    );
  }

  Future<dynamic> pickAndUploadImage() async {
    final picker = ImagePicker();
    final XFile? pickedFile =
        await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      final imageFile = File(pickedFile.path);

      return imageFile;
    } else {
      print('No image selected.');
      return null;
    }
  }
}
