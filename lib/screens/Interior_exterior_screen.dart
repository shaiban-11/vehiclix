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

    final categories = state.model.data?.categories;

    if (categories == null || categories.isEmpty) {
      return interiorExteriorItems;
    }

    for (final category in categories) {
      if (category is! Map) continue;

      final categoryId = category['categoryId'];

      String name = '';

      if (categoryId is Map) {
        name = (categoryId['name'] ?? '').toString();
      } else if (categoryId is String) {
        name = categoryId;
      }

      if (name.trim().toLowerCase() != categoryName.trim().toLowerCase()) {
        continue;
      }

      final items = category['items'];

      if (items is! List) {
        return interiorExteriorItems;
      }

      final List<String> apiItems = [];

      for (final item in items) {
        if (item is! Map) continue;

        final itemId = item['itemId'];

        String itemName = '';

        if (itemId is Map) {
          itemName = (itemId['name'] ?? '').toString();
        } else if (itemId is String) {
          itemName = itemId;
        }

        if (itemName.trim().isNotEmpty) {
          apiItems.add(itemName.trim());
        }
      }

      // Use API items when available; otherwise use the fallback list.
      return apiItems.isNotEmpty ? apiItems : interiorExteriorItems;
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
            _buildEngineUpperCover(),
            SizedBox(height: 10.h),

            ...displayItems.map(
              (item) => Padding(
                padding: EdgeInsets.only(bottom: 10.h),
                child: _buildInteriorExteriorItem(item),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildEngineUpperCover() {
    return Column(
      children: [
        SizedBox(height: 10.h),

        Center(
          child: Image.asset(
            'assets/images/carparts.png',
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
                    onTap: () {
                      // Camera action can be connected here.
                    },
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
      onTap: () {
        onItemTap(title);
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
