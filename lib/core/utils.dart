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
      return value == value.toInt()
          ? '${value.toInt()}l'
          : '${value.toStringAsFixed(1).replaceAll('.0', '')}l';
    } else if (number >= 1000) {
      // For thousands
      double value = number / 1000;
      return value == value.toInt()
          ? '${value.toInt()}k'
          : '${value.toStringAsFixed(1).replaceAll('.0', '')}k';
    } else {
      return number.toString();
    }
  }

  String getCurrentDate() {
    DateTime now = DateTime.now();
    DateFormat formater = DateFormat('dd-MM-yyyy');

    return formater.format(now);
  }

  Future<File?> pickImage() async {
    final picker = ImagePicker();
    final XFile? pickedFile =
        await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      return File(pickedFile.path);
    } else {
      print('No image selected.');
      return null;
    }
  }

  void navigateTo(BuildContext context, Widget destination) {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (context) => destination),
    );
  }
}
