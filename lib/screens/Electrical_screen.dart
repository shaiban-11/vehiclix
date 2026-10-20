import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:rootysysproject/screens/Tyres_screen.dart';

class Electrical extends StatelessWidget {
  final String engineUpperCoverStatus;
  final ValueChanged<String> onEngineUpperCoverStatusChanged;

  final List<String> ElectricalItems;

  final Map<String, String> itemStatus;
  final ValueChanged<String> onItemTap;

  const Electrical({
    super.key,
    required this.engineUpperCoverStatus,
    required this.onEngineUpperCoverStatusChanged,

    required this.itemStatus,
    required this.onItemTap,
    required this.ElectricalItems,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildEngineUpperCover(),

        SizedBox(height: 10.h),

        ...ElectricalItems.map(
          (item) => Padding(
            padding: EdgeInsets.only(bottom: 10.h),
            child: _buildInteriorExteriorItem(item),
          ),
        ),
      ],
    );
  }

  // ================================================================
  // ENGINE UPPER COVER
  // ================================================================

  Widget _buildEngineUpperCover() {
    return Column(
      children: [
        SizedBox(height: 30.h),

        Container(
          width: 369.w,
          height: 169.h,
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
                      'Key',
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
                    size: 29.sp,
                    color: const Color(0xFFA3A3A3),
                  ),
                ],
              ),

              SizedBox(height: 20.h),

              // ==========================================================
              // STATUS / CAMERA / IMAGE
              // ==========================================================
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
                          _buildInteriorStatusButton(
                            'Fail',
                            Icons.cancel_outlined,
                          ),

                          SizedBox(width: 8.w),

                          _buildInteriorStatusButton(
                            'Pass',
                            Icons.verified_outlined,
                          ),
                        ],
                      ),
                    ),
                  ),

                  SizedBox(width: 8.w),

                  // ------------------------------------------------------
                  // CAMERA
                  // ------------------------------------------------------
                  GestureDetector(
                    onTap: () {
                      // TODO:
                      // Add your camera/image picker here.
                    },
                    child: Container(
                      width: 116.w,
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
                      child: Row(
                        children: [
                          SizedBox(width: 9.w),

                          Icon(
                            Icons.camera_alt_outlined,
                            size: 16.sp,
                            color: const Color(0xFF222222),
                          ),
                          SizedBox(width: 8.w),
                          Text(
                            "Add photo",
                            style: TextStyle(
                              color: const Color(0xFF222222),
                              fontWeight: FontWeight.w500,
                              fontFamily: "Manrope",
                              fontSize: 14.sp,
                            ),
                          ),
                        ],
                      ),

                      // ------------------------------------------------------
                      // IMAGE
                      // ------------------------------------------------------
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  // ================================================================
  // INTERIOR STATUS BUTTON
  // ================================================================

  Widget _buildInteriorStatusButton(String status, IconData icon) {
    final bool isSelected = engineUpperCoverStatus == status;

    return GestureDetector(
      onTap: () {
        onEngineUpperCoverStatusChanged(status);
      },
      child: Container(
        width: 84.w,
        height: 38.h,
        padding: EdgeInsets.only(top: 0.h, right: 0.w, bottom: 0.h, left: 0.w),
        decoration: BoxDecoration(
          color: const Color(0xFFE8E8E8),

          borderRadius: BorderRadius.circular(13.r),
        ),

        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: const Color(0xFF3A3A3A), size: 18.sp),
            SizedBox(width: 3.w),
            Text(
              status,

              style: TextStyle(
                fontFamily: 'Manrope',
                fontSize: 16.sp,
                fontWeight: FontWeight.w500,

                color: const Color(0xFF3A3A3A),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ================================================================
  // INTERIOR / EXTERIOR ITEM
  // ================================================================

  Widget _buildInteriorExteriorItem(String title) {
    return GestureDetector(
      onTap: () {
        // TODO:
        // Open the detailed UI for this item.
        //
        // For example:
        // Dashboard
        // Doors
        // Hood
        // etc.
      },
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
            // ========================================================
            // TITLE
            // ========================================================
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

            // ========================================================
            // ARROW
            // ========================================================
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

enum ResultType { fail, pass }
