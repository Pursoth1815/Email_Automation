import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:thiran_tech/core/res/colors.dart';
import 'package:thiran_tech/core/res/constant.dart';
import 'package:thiran_tech/core/res/image_path.dart';
import 'package:thiran_tech/core/services/internet_connection_service.dart';
import 'package:thiran_tech/src/view/components/snackbar.dart';

enum ErrorConnectionState { error, noInternet }

class ErrorConnection extends ConsumerStatefulWidget {
  final ErrorConnectionState state;
  final String msg;
  final VoidCallback? onClick;
  final double? width;
  final double? height;
  const ErrorConnection({super.key, required this.state, required this.msg, this.onClick = null, this.width, this.height});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _ErrorConnectionState();
}

class _ErrorConnectionState extends ConsumerState<ErrorConnection> {
  bool btn_loading = false;
  @override
  Widget build(BuildContext context) {
    final repositoryState = ref.watch(networkNotifierProvider);

    String img_path = ImagePath.error;
    if (widget.state == ErrorConnectionState.noInternet) img_path = ImagePath.no_internet;
    return Container(
      width: widget.width ?? AppConstants.screenWidth,
      height: widget.height ?? (AppConstants.screenHeight - AppConstants.appBarHeight),
      padding: EdgeInsets.only(bottom: AppConstants.appBarHeight),
      decoration: BoxDecoration(
        color: AppColors.whiteLite,
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(75),
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(
            img_path,
            width: AppConstants.screenWidth * 0.7,
            height: AppConstants.screenWidth * 0.7,
            fit: BoxFit.cover,
            filterQuality: FilterQuality.high,
          ),
          SizedBox(
            height: AppConstants.screenHeight * 0.05,
          ),
          Text(
            widget.msg,
            style: TextStyle(
              fontSize: 15,
              color: AppColors.textColor,
              fontWeight: FontWeight.w500,
            ),
          ),
          if (widget.state == ErrorConnectionState.noInternet)
            Container(
              margin: EdgeInsets.only(top: AppConstants.screenHeight * 0.05),
              child: ElevatedButton(
                onPressed: () {
                  setState(() {
                    btn_loading = true;
                  });
                  Future.delayed(
                    Durations.extralong4,
                    () {
                      print("object");
                      if (repositoryState) {
                        widget.onClick;
                      } else {
                        showCustomSnackBar(context, "Please turn on Internet Connection");
                      }
                      setState(() {
                        btn_loading = false;
                      });
                    },
                  );
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
                child: btn_loading
                    ? SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: AppColors.white,
                        ),
                      )
                    : Text(
                        'Try Again!',
                        style: TextStyle(
                          color: AppColors.white,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
              ),
            )
        ],
      ),
    );
  }
}
