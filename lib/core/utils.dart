import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class Utils {
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

  void navigateTo(BuildContext context, Widget destination) {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (context) => destination),
    );
  }
}
