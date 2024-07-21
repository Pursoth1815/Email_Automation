import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:thiran_tech/core/res/colors.dart';

class CustomInputText extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final bool mutiline;
  const CustomInputText(
      {super.key,
      required this.controller,
      required this.hintText,
      this.mutiline = false});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 15),
      child: TextField(
        controller: controller,
        autocorrect: true,
        autofocus: false,
        onSubmitted: (value) {},
        onChanged: (value) {},
        onTapOutside: (event) {
          SystemChannels.textInput.invokeMethod('TextInput.hide');
          FocusScope.of(context).unfocus();
        },
        minLines: 1,
        maxLines: null,
        keyboardType: mutiline ? TextInputType.multiline : TextInputType.text,
        decoration: InputDecoration(
          contentPadding: EdgeInsets.symmetric(
            vertical: 25.0,
            horizontal: 15.0,
          ),
          hintText: hintText,
          hintStyle: TextStyle(color: Colors.black38, fontSize: 18),
          labelText: hintText,
          labelStyle: TextStyle(color: Colors.black38, fontSize: 18),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(15)),
            borderSide: BorderSide.none,
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(15)),
            borderSide: BorderSide(width: 2, color: AppColors.green),
          ),
          fillColor: AppColors.white,
          filled: true,
        ),
      ),
    );
  }
}
