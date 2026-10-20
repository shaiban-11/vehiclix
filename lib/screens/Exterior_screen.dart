import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:rootysysproject/screens/Front_Left_door_screen.dart';

class ExteriorScreen extends StatefulWidget {
  final List<String> ExteriorItems;
  final ValueChanged<String> onItemTap;

  const ExteriorScreen({
    super.key,
    required this.onItemTap,
    required this.ExteriorItems,
  });

  @override
  State<ExteriorScreen> createState() => _ExteriorScreenState();
}

class _ExteriorScreenState extends State<ExteriorScreen> {
  // Selected exterior item
  String selectedExterior = "Front Left Door";

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // =========================================================
        // CAR IMAGE
        // =========================================================
        Center(
          child: Image.asset(
            "assets/images/Carparts2.png",
            height: 197.h,
            width: 372.w,
          ),
        ),

        SizedBox(height: 20.h),

        // =========================================================
        // INSPECT POINTS
        // =========================================================
        Text(
          "inspect points",
          style: TextStyle(
            color: const Color(0x9E000000),
            fontWeight: FontWeight.w500,
            fontSize: 14.sp,
            fontFamily: "Manrope",
          ),
        ),

        SizedBox(height: 10.h),

        // =========================================================
        // EXTERIOR ITEMS - 2 PER ROW
        // =========================================================
        Wrap(
          spacing: 10.w,
          runSpacing: 10.h,
          children: widget.ExteriorItems.map(
            (item) => _buildExteriorItem(context, item),
          ).toList(),
        ),
      ],
    );
  }

  Widget _buildExteriorItem(BuildContext context, String title) {
    final bool isSelected = selectedExterior == title;

    return GestureDetector(
      onTap: () {
        setState(() {
          selectedExterior = title;
        });

        // Send selected item back to parent
        widget.onItemTap(title);

        // Open bottom sheet
        showexteriorbottomsheet(context, title);
      },
      child: Container(
        width: 178.w,
        height: 57.h,
        padding: EdgeInsets.only(
          top: 10.h,
          right: 12.w,
          bottom: 10.h,
          left: 12.w,
        ),
        decoration: BoxDecoration(
          color: const Color(0xFFF5F5F5),
          borderRadius: BorderRadius.circular(12.r),

          // Selected border
          border: isSelected
              ? Border.all(color: const Color(0xFFE90000), width: 1.5)
              : null,
        ),
        child: Row(
          children: [
            // =====================================================
            // TITLE
            // =====================================================
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
                  color: isSelected
                      ? const Color(0xFFE90000)
                      : const Color(0xFF111111),
                ),
              ),
            ),

            // =====================================================
            // ARROW
            // =====================================================
            Icon(
              Icons.keyboard_arrow_right_rounded,
              size: 22.sp,
              color: isSelected
                  ? const Color(0xFFE90000)
                  : const Color(0xFFA3A3A3),
            ),
          ],
        ),
      ),
    );
  }
}

// =================================================================
// EXTERIOR BOTTOM SHEET
// =================================================================

void showexteriorbottomsheet(BuildContext context, String selectedExterior) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (context) {
      return Container(
        width: 402.w,
        height: 677.h,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(28.r),
            topRight: Radius.circular(28.r),
          ),
        ),
        child: FrontLeftDoor(exteriorName: selectedExterior, showChasis: false),
      );
    },
  );
}
