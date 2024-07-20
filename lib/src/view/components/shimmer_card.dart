import 'package:flutter/material.dart';
import 'package:thiran_tech/core/res/colors.dart';
import 'package:thiran_tech/core/res/constant.dart';
import 'package:thiran_tech/src/view/components/shimmer.dart';

class ShimmerCard extends StatelessWidget {
  final double? width;
  final double? height;
  const ShimmerCard({super.key, this.width, this.height});

  @override
  Widget build(BuildContext context) {
    double cardWidth;
    double cardHeight;
    if (width != null)
      cardWidth = width!;
    else
      cardWidth = AppConstants.screenWidth * 0.85;
    if (height != null)
      cardHeight = height!;
    else
      cardHeight = AppConstants.screenHeight * 0.18;
    return Expanded(
      child: ListView.separated(
        itemCount: 6,
        padding: EdgeInsets.symmetric(horizontal: 5, vertical: 10),
        itemBuilder: (context, index) {
          return Container(
            width: cardWidth,
            height: cardHeight,
            padding: EdgeInsets.all(15),
            decoration: BoxDecoration(color: AppColors.white, borderRadius: BorderRadius.circular(30)),
            child: Row(
              children: [
                ShimmerLoading(
                  isLoading: true,
                  child: Container(
                    width: AppConstants.screenWidth * 0.25,
                    decoration: BoxDecoration(color: AppColors.white, borderRadius: BorderRadius.circular(15)),
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _shimmerTextLoader(AppConstants.screenWidth * 0.35),
                    _shimmerTextLoader(AppConstants.screenWidth * 0.42),
                    _shimmerTextLoader(AppConstants.screenWidth * 0.25),
                  ],
                )
              ],
            ),
          );
        },
        separatorBuilder: (context, index) {
          return SizedBox(
            height: 10,
          );
        },
      ),
    );
  }

  ShimmerLoading _shimmerTextLoader(double width) {
    return ShimmerLoading(
      isLoading: true,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(5, 5, 0, 5),
        child: SizedBox(
          width: width,
          height: AppConstants.screenWidth * 0.035,
          child: Card(
            margin: EdgeInsets.zero,
            elevation: 2,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          ),
        ),
      ),
    );
  }
}
