import 'package:flutter/material.dart';
import 'package:thiran_tech/core/res/colors.dart';
import 'package:thiran_tech/core/res/image_path.dart';
import 'package:thiran_tech/core/res/strings.dart';
import 'package:thiran_tech/src/models/ticket_model.dart';

class Ticket_List_Tile extends StatelessWidget {
  const Ticket_List_Tile({
    super.key,
    required this.model,
  });

  final TicketModel model;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(13),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Text(
                  model.title,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                  ),
                ),
                Text(
                  model.description,
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 11,
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
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            color: Colors.black38,
                            fontWeight: FontWeight.bold,
                            fontSize: 12,
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
            mainAxisAlignment: MainAxisAlignment.center,
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
                  fontSize: 12,
                  fontWeight: FontWeight.w400,
                  color: AppColors.grey,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
