import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:rootysysproject/screens/Tyres_screen.dart';

class SelectInspectionBottomSheet extends StatelessWidget {
  const SelectInspectionBottomSheet({
    super.key,
    required this.onFullInspectionTap,
  });

  final VoidCallback onFullInspectionTap;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 402.w,
      height: 440.h,
      decoration: BoxDecoration(
        color: const Color(0xFFF5F5F5),
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(28.r),
          topRight: Radius.circular(28.r),
        ),
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 24.h),

            Text(
              'Select inspect type',
              style: TextStyle(
                fontFamily: 'Manrope',
                fontWeight: FontWeight.w600,
                fontSize: 16.sp,
                height: 1.0,
                color: Colors.black,
              ),
            ),

            SizedBox(height: 20.h),

            // =====================================================
            // DIVIDER
            // =====================================================
            Container(
              width: 370.w,
              height: 1.h,
              color: const Color(0xFFE8E8E8),
            ),

            SizedBox(height: 16.h),

            // =====================================================
            // FULL INSPECTION
            inspectiondetails(
              "assets/images/car.png",
              'Full Inspect',
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => TyresScreen()),
                );
              },
            ),
            SizedBox(height: 10.h),
            inspectiondetails(
              "assets/images/insurance inspect.png",
              "insurance inspect",
            ),
            SizedBox(height: 10.h),
            inspectiondetails(
              "assets/images/interior inspect.png",
              "interior inspect",
            ),
            SizedBox(height: 10.h),
            inspectiondetails(null, "interior inspect"),
          ],
        ),
      ),
    );
  }

  Widget inspectiondetails(
    String? image,
    String text, {
    String? containerText,
    VoidCallback? onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 370.w,
        height: 54.h,
        padding: EdgeInsets.all(8.w),
        decoration: BoxDecoration(
          color: const Color(0xFFFFFFFF),
          borderRadius: BorderRadius.circular(11.r),
        ),
        child: Row(
          children: [
            Container(
              width: 38.w,
              height: 38.h,
              decoration: BoxDecoration(
                color: const Color(0x2693FF26),
                borderRadius: BorderRadius.circular(5.r),
              ),
              alignment: Alignment.center,

              child: image != null
                  ? Image.asset(image, color: const Color(0xFF2A2A2A))
                  : Text(
                      containerText ?? "R",
                      style: TextStyle(
                        fontFamily: 'Manrope',
                        fontWeight: FontWeight.w600,
                        fontSize: 17.sp,
                        color: const Color(0xFF2A2A2A),
                      ),
                      textAlign: TextAlign.center,
                    ),
            ),

            SizedBox(width: 10.w),

            Expanded(
              child: Text(
                text,
                style: TextStyle(
                  fontFamily: 'Manrope',
                  fontWeight: FontWeight.w600,
                  fontSize: 16.sp,
                  height: 1.0,
                  color: Colors.black,
                ),
              ),
            ),

            Container(
              width: 24.w,
              height: 24.h,
              decoration: const BoxDecoration(
                color: Color(0xFF93FF26),
                shape: BoxShape.circle,
              ),
              alignment: Alignment.center,
              child: Image.asset("assets/images/Vector (2).png"),
            ),
          ],
        ),
      ),
    );
  }
}
