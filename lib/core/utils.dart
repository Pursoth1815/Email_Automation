import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';

class Utils {
  String formatNumber(String num) {
    int number = int.parse(num);
    if (number >= 100000) {
      // For lakhs
      double value = number / 100000;
      return value == value.toInt() ? '${value.toInt()}l' : '${value.toStringAsFixed(1).replaceAll('.0', '')}l';
    } else if (number >= 1000) {
      // For thousands
      double value = number / 1000;
      return value == value.toInt() ? '${value.toInt()}k' : '${value.toStringAsFixed(1).replaceAll('.0', '')}k';
    } else {
      return number.toString();
    }
  }

  String getCurrentDate() {
    DateTime now = DateTime.now();
    DateFormat formater = DateFormat('dd-MM-yyyy');

    return formater.format(now);
  }

  String getRepoName(String input) {
    int lastSlashIndex = input.lastIndexOf('/');

    if (lastSlashIndex != -1) {
      return input.substring(lastSlashIndex + 1);
    } else {
      return input;
    }
  }

  Future<File?> pickImage() async {
    final picker = ImagePicker();
    final XFile? pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      return File(pickedFile.path);
    } else {
      print('No image selected.');
      return null;
    }
  }

  void showCustomSnackBar(BuildContext context, String message, {Color color = Colors.red}) {
    String titleText = '';
    if (color == Colors.red) {
      titleText = "fail";
    } else {
      titleText = "success";
    }

    final snackBar = SnackBar(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            titleText,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w500,
              color: Colors.white,
            ),
          ),
          SizedBox(height: 4),
          Text(
            message,
            style: TextStyle(
              fontSize: 14,
              color: Colors.white,
            ),
          ),
        ],
      ),
      backgroundColor: color,
      behavior: SnackBarBehavior.floating,
      margin: EdgeInsets.symmetric(horizontal: 15, vertical: 5),
      duration: Duration(seconds: 2),
      elevation: 5,
      dismissDirection: DismissDirection.horizontal,
    );

    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  void navigateTo(BuildContext context, Widget destination) {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (context) => destination),
    );
  }
}
