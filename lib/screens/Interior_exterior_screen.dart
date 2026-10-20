import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class InteriorExterior extends StatelessWidget {
  final String engineUpperCoverStatus;
  final ValueChanged<String> onEngineUpperCoverStatusChanged;

  final List<String> interiorExteriorItems;

  final Map<String, String> itemStatus;
  final ValueChanged<String> onItemTap;

  const InteriorExterior({
    super.key,
    required this.engineUpperCoverStatus,
    required this.onEngineUpperCoverStatusChanged,
    required this.interiorExteriorItems,
    required this.itemStatus,
    required this.onItemTap,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildEngineUpperCover(),

        SizedBox(height: 10.h),

        ...interiorExteriorItems.map(
          (item) => Padding(
            padding: EdgeInsets.only(bottom: 10.h),
            child: _buildInteriorExteriorItem(item),
          ),
        ),
      ],
    );
  }

  Widget _buildEngineUpperCover() {
    return Column(
      children: [
        SizedBox(height: 10.h),
        Center(
          child: Image.asset(
            "assets/images/carparts.png",
            height: 197.h,
            width: 372.w,
          ),
        ),
        SizedBox(height: 30.h),

        Container(
          width: double.infinity,
          height: 197.h,
          padding: EdgeInsets.only(
            top: 10.h,
            right: 12.w,
            bottom: 10.h,
            left: 12.w,
          ),
          decoration: BoxDecoration(
            color: const Color(0xFFF5F5F5),
            borderRadius: BorderRadius.circular(12.r),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      'Engine Upper Cover',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontFamily: 'Manrope',
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w600,
                        height: 1.0,
                        color: const Color(0xFF111111),
                      ),
                    ),
                  ),

                  Icon(
                    Icons.keyboard_arrow_right_rounded,
                    size: 22.sp,
                    color: const Color(0xFFA3A3A3),
                  ),
                ],
              ),

              SizedBox(height: 20.h),

              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // ------------------------------------------------------
                  // STATUS BUTTONS
                  // ------------------------------------------------------
                  Expanded(
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      physics: const BouncingScrollPhysics(),
                      child: Row(
                        children: [
                          _buildInteriorStatusButton('Repaired'),

                          SizedBox(width: 8.w),

                          _buildInteriorStatusButton('Damaged'),

                          SizedBox(width: 8.w),

                          _buildInteriorStatusButton('Checked'),
                        ],
                      ),
                    ),
                  ),

                  SizedBox(width: 8.w),

                  GestureDetector(
                    onTap: () {},
                    child: Container(
                      width: 39.w,
                      height: 39.h,
                      decoration: BoxDecoration(
                        color: Colors.transparent,
                        border: Border.all(
                          color: const Color(0xFFD1D1D1),
                          width: 1.w,
                        ),
                        borderRadius: BorderRadius.circular(30.r),
                      ),
                      alignment: Alignment.center,
                      child: Icon(
                        Icons.camera_alt_outlined,
                        size: 19.sp,
                        color: const Color(0xFF222222),
                      ),
                    ),
                  ),

                  SizedBox(width: 8.w),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildInteriorStatusButton(String status) {
    final bool isSelected = engineUpperCoverStatus == status;

    return GestureDetector(
      onTap: () {
        onEngineUpperCoverStatusChanged(status);
      },
      child: Container(
        width: 84.w,
        height: 40.h,
        padding: EdgeInsets.all(10.w),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFFF5F5F5) : Colors.transparent,
          border: Border.all(
            color: isSelected
                ? const Color(0xFFE90000)
                : const Color(0xFFE8E8E8),
            width: 1.w,
          ),
          borderRadius: BorderRadius.circular(30.r),
        ),
        alignment: Alignment.center,
        child: Text(
          status,

          style: TextStyle(
            fontFamily: 'Manrope',
            fontSize: 13.sp,
            fontWeight: FontWeight.w500,
            height: 1.0,
            color: isSelected
                ? const Color(0xFFE90000)
                : const Color(0xFF000000),
          ),
        ),
      ),
    );
  }

  Widget _buildInteriorExteriorItem(String title) {
    return GestureDetector(
      onTap: () {},
      child: Container(
        width: double.infinity,
        height: 48.h,
        padding: EdgeInsets.only(
          top: 10.h,
          right: 12.w,
          bottom: 10.h,
          left: 12.w,
        ),
        decoration: BoxDecoration(
          color: const Color(0xFFF5F5F5),
          borderRadius: BorderRadius.circular(12.r),
        ),
        child: Row(
          children: [
            Expanded(
              child: Text(
                title,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontFamily: 'Manrope',
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w600,
                  height: 1.0,
                  color: const Color(0xFF111111),
                ),
              ),
            ),

            Icon(
              Icons.keyboard_arrow_right_rounded,
              size: 22.sp,
              color: const Color(0xFFA3A3A3),
            ),
          ],
        ),
      ),
    );
  }
}
