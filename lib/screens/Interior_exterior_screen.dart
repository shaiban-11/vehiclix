import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:rootysysproject/bloc/inspectioncategories/bloc/inspectioncategories_bloc.dart';
import 'package:rootysysproject/bloc/inspectioncategories/bloc/inspectioncategories_state.dart';

class InteriorExterior extends StatelessWidget {
  final String engineUpperCoverStatus;
  final ValueChanged<String> onEngineUpperCoverStatusChanged;

  // Fallback items from the parent screen.
  final List<String> interiorExteriorItems;

  final Map<String, String> itemStatus;
  final ValueChanged<String> onItemTap;

  // Pass 'interior' or 'exterior' depending on the selected inspection.
  final String categoryName;

  const InteriorExterior({
    super.key,
    required this.engineUpperCoverStatus,
    required this.onEngineUpperCoverStatusChanged,
    required this.interiorExteriorItems,
    required this.itemStatus,
    required this.onItemTap,
    this.categoryName = 'interior',
  });

  List<String> _getApiItems(InspectionDetailsState state) {
    if (state is! InspectionDetailsLoaded) {
      return interiorExteriorItems;
    }

    final categories = state.model.data?.categories ?? [];

    for (final category in categories) {
      final name = category.categoryId?.name?.trim().toLowerCase() ?? '';

      if (name != categoryName.trim().toLowerCase()) {
        continue;
      }

      final apiItems = category.items
          .map((entry) => entry.itemId?.name?.trim() ?? '')
          .where((itemName) => itemName.isNotEmpty)
          .toList();

      if (apiItems.isNotEmpty) {
        return apiItems;
      }
    }

    return interiorExteriorItems;
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<InspectionDetailsBloc, InspectionDetailsState>(
      builder: (context, state) {
        final List<String> displayItems = _getApiItems(state);

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 10.h),
            Row(
              children: [
                Wrap(
                  spacing: 8.w,
                  runSpacing: 8.h,
                  children: displayItems.map((item) {
                    return _buildInteriorExteriorItem(item);
                  }).toList(),
                ),
              ],
            ),
          ],
        );
      },
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
    final String status = itemStatus[title] ?? 'NC';

    Color containerColor;

    if (status == 'Pass') {
      containerColor = const Color(0xFF73F700); // Green
    } else if (status == 'Fail') {
      containerColor = const Color(0xFFFFDADA); // Light red
    } else {
      containerColor = const Color(0xFFF5F5F5); // Default
    }

    return GestureDetector(
      onTap: () {
        onItemTap(title);
      },
      child: Container(
        width: 175.w,
        height: 57.h,
        padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 10.h),
        decoration: BoxDecoration(
          color: containerColor,
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
