import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:rootysysproject/bloc/inspectioncategories/bloc/inspectioncategories_bloc.dart';
import 'package:rootysysproject/bloc/inspectioncategories/bloc/inspectioncategories_state.dart';

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
  String selectedExterior = 'Core Support';

  /// Fallback list used only when chassis items are unavailable in the API
  /// and the parent screen has not provided any items.
  final List<String> _defaultChassisItems = [
    'Core Support',
    'Chassis Frame',
    'Front Cross Member',
    'Rear Cross Member',
    'Radiator Support',
    'Apron',
    'Firewall',
    'Pillar',
    'Floor Pan',
    'Boot Floor',
    'Underbody',
    'Visible Rust',
    'Chassis Damage',
  ];

  /// Extracts chassis items from the inspection API response.
  ///
  /// Expected structure:
  /// {
  ///   "categoryId": {"name": "Chassis"},
  ///   "items": [
  ///     {"itemId": {"name": "Core Support"}}
  ///   ]
  /// }

  List<String> _getChassisItems(InspectionDetailsState state) {
    // API data load ആയിട്ടില്ലെങ്കിൽ fallback items ഉപയോഗിക്കുക.
    if (state is! InspectionDetailsLoaded) {
      return widget.ExteriorItems.isNotEmpty
          ? widget.ExteriorItems
          : _defaultChassisItems;
    }

    final categories = state.model.data?.categories ?? [];

    for (final category in categories) {
      final categoryName =
          category.categoryId?.name?.toLowerCase().trim() ?? '';

      final isChassisCategory =
          categoryName.contains('chassis') ||
          categoryName.contains('chasis') ||
          categoryName.contains('underbody') ||
          categoryName.contains('under body');

      if (!isChassisCategory) continue;

      final apiItems = category.items
          .map((entry) => entry.itemId?.name?.trim() ?? '')
          .where((name) => name.isNotEmpty)
          .toList();

      if (apiItems.isNotEmpty) {
        return apiItems;
      }
    }

    // API-യിൽ chassis category ഇല്ലെങ്കിൽ fallback.
    return widget.ExteriorItems.isNotEmpty
        ? widget.ExteriorItems
        : _defaultChassisItems;
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<InspectionDetailsBloc, InspectionDetailsState>(
      builder: (context, state) {
        final chassisItems = _getChassisItems(state);

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Image.asset(
                'assets/images/carparts3.png',
                height: 197.h,
                width: 372.w,
                fit: BoxFit.contain,
              ),
            ),

            SizedBox(height: 20.h),

            if (state is InspectionDetailsLoading)
              Padding(
                padding: EdgeInsets.only(bottom: 12.h),
                child: const Center(child: CircularProgressIndicator()),
              ),

            if (state is InspectionDetailsError)
              Padding(
                padding: EdgeInsets.only(bottom: 12.h),
                child: Text(
                  'Could not load chassis inspection items. '
                  'Showing available fallback items.',
                  style: TextStyle(
                    fontSize: 12.sp,
                    color: Colors.orange.shade800,
                  ),
                ),
              ),

            SizedBox(height: 10.h),

            Wrap(
              spacing: 10.w,
              runSpacing: 10.h,
              children: chassisItems
                  .map((item) => _buildChassisItem(context, item))
                  .toList(),
            ),
          ],
        );
      },
    );
  }

  Widget _buildChassisItem(BuildContext context, String title) {
    final bool isSelected = selectedExterior == title;

    return GestureDetector(
      onTap: () {
        setState(() {
          selectedExterior = title;
        });

        // Notify the parent screen about the selected API item.
        widget.onItemTap(title);

        // Open the existing chassis inspection detail bottom sheet.
        showChasisBottomSheet(context, title);
      },
      child: Container(
        width: 370.w,
        height: 48.h,
        padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 10.h),
        decoration: BoxDecoration(
          color: const Color(0xFFF5F5F5),
          borderRadius: BorderRadius.circular(12.r),
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

/// Opens the existing chassis inspection detail bottom sheet.
void showChasisBottomSheet(BuildContext context, String selectedExterior) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (bottomSheetContext) {
      return Container(
        width: 402.w,
        constraints: BoxConstraints(
          maxHeight: MediaQuery.of(bottomSheetContext).size.height * 0.9,
        ),
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
