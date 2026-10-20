import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class GeneralPhotos extends StatefulWidget {
  const GeneralPhotos({super.key});

  @override
  State<GeneralPhotos> createState() => _GeneralPhotosState();
}

class _GeneralPhotosState extends State<GeneralPhotos> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,

      child: Padding(
        padding: EdgeInsets.only(left: 8.r),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Exterior",
              style: TextStyle(
                color: const Color(0xFF111111),
                fontFamily: "Manrope",
                fontSize: 14.sp,
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(height: 20.h),
            _buildExterioritem("Exterior"),
            SizedBox(height: 10.h),
            _buildExterioritem("Interior"),
            SizedBox(height: 10.h),
            _buildExterioritem("Engine Bay & Undercarriage"),
          ],
        ),
      ),
    );
  }

  Widget _buildExterioritem(String title) {
    return Container(
      padding: EdgeInsets.only(
        top: 10.h,
        right: 12.w,
        bottom: 10.h,
        left: 12.w,
      ),
      width: 371.w,
      height: 96.h,
      decoration: BoxDecoration(
        color: const Color(0xFFF5F5F5),
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title,
                style: TextStyle(
                  color: const Color(0xFF111111),
                  fontFamily: "Manrope",
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w600,
                ),
              ),
              Icon(
                Icons.arrow_forward_ios_outlined,
                size: 20,
                color: const Color(0xFF9CA3AF),
              ),
            ],
          ),
          SizedBox(height: 15.h),
          Align(
            alignment: Alignment.centerRight,
            child: Container(
              padding: EdgeInsets.all(10.r),
              width: 116.w,
              height: 39.h,
              decoration: BoxDecoration(
                color: const Color(0xFFF5F5F5),
                borderRadius: BorderRadius.circular(30.r),
                border: Border.all(width: 1.w, color: const Color(0xFFD1D1D1)),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Image.asset("assets/images/camera.png"),
                  SizedBox(width: 5.w),
                  Text(
                    "Add photo",
                    style: TextStyle(
                      color: const Color(0xFF222222),
                      fontWeight: FontWeight.w500,
                      fontSize: 14.sp,
                      fontFamily: "Manrope",
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
