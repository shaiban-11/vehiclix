import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:rootysysproject/screens/Front_Left_door_screen.dart';

class ChasisScreen extends StatefulWidget {
  final List<String> ExteriorItems;
  final ValueChanged<String> onItemTap;

  const ChasisScreen({
    super.key,
    required this.onItemTap,
    required this.ExteriorItems,
  });

  @override
  State<ChasisScreen> createState() => _ChasisScreenState();
}

class _ChasisScreenState extends State<ChasisScreen> {
  String selectedExterior = "Core Support";

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Center(
          child: Image.asset(
            "assets/images/carparts3.png",
            height: 197.h,
            width: 372.w,
          ),
        ),

        SizedBox(height: 20.h),

        SizedBox(height: 10.h),

        Wrap(
          spacing: 10.w,
          runSpacing: 10.h,
          children: widget.ExteriorItems.map(
            (item) => _buildChasisItem(context, item),
          ).toList(),
        ),
      ],
    );
  }

  Widget _buildChasisItem(BuildContext context, String title) {
    final bool isSelected = selectedExterior == title;

    return GestureDetector(
      onTap: () {
        setState(() {
          selectedExterior = title;
        });

        widget.onItemTap(title);

        showChasisbottomsheet(context, title);
      },
      child: Container(
        width: 370.w,
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

          // Selected border
          border: isSelected
              ? Border.all(color: const Color(0xFFE90000), width: 1.5)
              : null,
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
                  color: isSelected
                      ? const Color(0xFFE90000)
                      : const Color(0xFF111111),
                ),
              ),
            ),

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

void showChasisbottomsheet(BuildContext context, String selectedExterior) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (context) {
      return Container(
        width: 402.w,

        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(28.r),
            topRight: Radius.circular(28.r),
          ),
        ),
        child: FrontLeftDoor(exteriorName: selectedExterior, showChasis: true),
      );
    },
  );
}
