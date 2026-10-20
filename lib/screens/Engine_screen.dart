import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:rootysysproject/screens/Front_Left_door_screen.dart';

class EngineScreen extends StatefulWidget {
  const EngineScreen({super.key});

  @override
  State<EngineScreen> createState() => _EngineScreenState();
}

class _EngineScreenState extends State<EngineScreen> {
  String selectedEngine = "key";
  final List<String> Engineitems = [
    "key",
    "Engine Shield Cover",
    "Bonnet Hinge & Holder",
    "Turbo/Supercharger",
    "Fender Liners",
    "Driver Belt/Puleys",
    "Engine idle",
    "Engine Oil Filler Cap",
    "Radiator",
    "Engine Oil Leaks",
    "Engien Oil Condition",
    "Coolant Condition",
    "Coolant Cap"
        "Houses & Pipes",
    "Exahaust System",
    "Visible Rust",
    "Water Scaling/dirt marks",
    "4 Wheel Drive",
  ];
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          SizedBox(height: 10.h),

          ...Engineitems.map(
            (item) => Padding(
              padding: EdgeInsets.only(bottom: 10.h),
              child: _buildEngineItem(item),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEngineItem(String title) {
    final bool isSelected = selectedEngine == title;
    return GestureDetector(
      onTap: () {
        showEnginebottomsheet(context, title);

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
        width: 370,
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

void showEnginebottomsheet(BuildContext context, String selectedExterior) {
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
