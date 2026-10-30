import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:rootysysproject/bloc/inspectioncategories/bloc/inspectioncategories_bloc.dart';
import 'package:rootysysproject/bloc/inspectioncategories/bloc/inspectioncategories_state.dart';
import 'package:rootysysproject/screens/front_left_popup.dart';

class ExteriorScreen extends StatefulWidget {
  final String customerId;
  final String vehicleId;
  final String inspectionTypeId;
  final String categoryId;
  final String itemId;
  final String inspectionStatus;
  final List<String> ExteriorItems;
  final ValueChanged<String> onItemTap;
  final Map<String, String> itemStatus;
  final void Function(String itemName, String result) onResultChanged;

  const ExteriorScreen({
    super.key,
    required this.onItemTap,
    required this.ExteriorItems,
    required this.itemStatus,
    required this.onResultChanged,
    required this.customerId,
    required this.vehicleId,
    required this.inspectionTypeId,
    required this.categoryId,
    required this.itemId,
    required this.inspectionStatus,
  });

  @override
  State<ExteriorScreen> createState() => _ExteriorScreenState();
}

class _ExteriorScreenState extends State<ExteriorScreen> {
  String selectedExterior = '';

  // Read Exterior inspection items from the existing API state.

  List<String> _getExteriorItems(InspectionDetailsState state) {
    if (state is! InspectionDetailsLoaded) {
      return widget.ExteriorItems;
    }

    final categories = state.model.data?.categories ?? [];

    for (final category in categories) {
      final categoryName =
          category.categoryId?.name?.toLowerCase().trim() ?? '';

      if (categoryName != 'exterior') {
        continue;
      }

      final apiItems = category.items
          .map((entry) => entry.itemId?.name?.trim() ?? '')
          .where((name) => name.isNotEmpty)
          .toList();

      if (apiItems.isNotEmpty) {
        return apiItems;
      }
    }

    return widget.ExteriorItems;
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<InspectionDetailsBloc, InspectionDetailsState>(
      builder: (context, state) {
        final exteriorItems = _getExteriorItems(state);

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // CAR IMAGE
            Center(
              child: Image.asset(
                'assets/images/Carparts2.png',
                height: 197.h,
                width: 372.w,
              ),
            ),

            SizedBox(height: 20.h),

            // INSPECT POINTS
            Text(
              'inspect points',
              style: TextStyle(
                color: const Color(0x9E000000),
                fontWeight: FontWeight.w500,
                fontSize: 14.sp,
                fontFamily: 'Manrope',
              ),
            ),

            SizedBox(height: 10.h),

            // EXTERIOR ITEMS - 2 PER ROW
            Wrap(
              spacing: 10.w,
              runSpacing: 10.h,
              children: exteriorItems
                  .map((item) => _buildExteriorItem(context, item))
                  .toList(),
            ),
          ],
        );
      },
    );
  }

  Widget _buildExteriorItem(BuildContext context, String title) {
    final String status = widget.itemStatus[title] ?? '';

    final bool isSelected = selectedExterior == title;

    Color containerColor = const Color(0xFFF5F5F5);
    Color textColor = const Color(0xFF111111);
    Color iconColor = const Color(0xFFA3A3A3);

    if (status == 'Pass') {
      containerColor = const Color(0xFF73F700);
      textColor = const Color(0xFF449400);
      iconColor = const Color(0xFF449400);
    } else if (status == 'Fail') {
      containerColor = const Color(0xFFFFDADA);
      textColor = const Color(0xFFE90000);
      iconColor = const Color(0xFFE90000);
    }

    return GestureDetector(
      onTap: () {
        setState(() {
          selectedExterior = title;
        });

        widget.onItemTap(title);

        showexteriorbottomsheet(
          context,
          title,
          customerId: widget.customerId,
          vehicleId: widget.vehicleId,
          inspectionTypeId: widget.inspectionTypeId,
          categoryId: widget.categoryId,
          itemId: widget.itemId,
          inspectionStatus: widget.inspectionStatus,
          onResultChanged: (result) {
            widget.onResultChanged(title, result);
          },
        );
      },

      // IMPORTANT: Container must be the child of GestureDetector.
      child: Container(
        width: 178.w,
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
                  color: textColor,
                ),
              ),
            ),
            Icon(
              Icons.keyboard_arrow_right_rounded,
              size: 22.sp,
              color: iconColor,
            ),
          ],
        ),
      ),
    );
  }

  void showexteriorbottomsheet(
    BuildContext context,
    String selectedExterior, {
    required String customerId,
    required String vehicleId,
    required String inspectionTypeId,
    required String categoryId,
    required String itemId,
    required String inspectionStatus,
    required ValueChanged<String> onResultChanged,
  }) {
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
          child: FrontLeftPopup(
            tyreName: selectedExterior,
            customerId: customerId,
            vehicleId: vehicleId,
            inspectionTypeId: inspectionTypeId,
            categoryId: categoryId,
            itemId: itemId,
            inspectionStatus: inspectionStatus,
            showBreakContainers: false,
            showremark: true,
            onResultChanged: onResultChanged,
          ),
        );
      },
    );
  }
}
