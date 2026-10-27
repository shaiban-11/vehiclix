import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:rootysysproject/bloc/inspectioncategories/bloc/inspectioncategories_bloc.dart';
import 'package:rootysysproject/bloc/inspectioncategories/bloc/inspectioncategories_state.dart';
import 'package:rootysysproject/screens/Front_Left_door_screen.dart';

class TransmissionScreen extends StatefulWidget {
  final String engineUpperCoverStatus;
  final ValueChanged<String> onEngineUpperCoverStatusChanged;

  // Retained for compatibility with the existing TyresScreen.
  final List<String> TransmissionItems;

  final Map<String, String> itemStatus;
  final ValueChanged<String> onItemTap;

  const TransmissionScreen({
    super.key,
    required this.engineUpperCoverStatus,
    required this.onEngineUpperCoverStatusChanged,
    required this.itemStatus,
    required this.onItemTap,
    required this.TransmissionItems,
  });

  @override
  State<TransmissionScreen> createState() => _TransmissionScreenState();
}

class _TransmissionScreenState extends State<TransmissionScreen> {
  String? selectedTransmission;

  // Read transmission items from the existing inspection API response.
  List<String> get apiTransmissionItems {
    final state = context.read<InspectionDetailsBloc>().state;

    if (state is! InspectionDetailsLoaded) {
      return [];
    }

    final categories = state.model.data?.categories ?? [];

    for (final category in categories) {
      if (category is! Map) continue;

      final categoryData = category['categoryId'];

      if (categoryData is! Map) continue;

      final categoryName = categoryData['name']
          ?.toString()
          .toLowerCase()
          .trim();

      if (categoryName != 'transmission') continue;

      final items = category['items'];

      if (items is! List) return [];

      return items
          .whereType<Map>()
          .map((entry) {
            final itemData = entry['itemId'];

            if (itemData is Map) {
              return itemData['name']?.toString() ?? '';
            }

            return '';
          })
          .where((name) => name.isNotEmpty)
          .toList();
    }

    return [];
  }

  List<String> get displayTransmissionItems {
    final apiItems = apiTransmissionItems;

    // Use API items when available; otherwise preserve the existing list.
    return apiItems.isNotEmpty ? apiItems : widget.TransmissionItems;
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<InspectionDetailsBloc, InspectionDetailsState>(
      builder: (context, state) {
        final transmissionItems = displayTransmissionItems;

        if (state is InspectionDetailsLoading ||
            state is InspectionDetailsInitial) {
          return const Center(child: CircularProgressIndicator());
        }

        if (state is InspectionDetailsError) {
          return Center(
            child: Padding(
              padding: EdgeInsets.all(16.w),
              child: Text(
                'Unable to load transmission details: ${state.message}',
                textAlign: TextAlign.center,
              ),
            ),
          );
        }

        if (selectedTransmission != null &&
            !transmissionItems.contains(selectedTransmission)) {
          selectedTransmission = null;
        }

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildTransmissionUpperCover(),
            SizedBox(height: 10.h),

            if (transmissionItems.isEmpty)
              Padding(
                padding: EdgeInsets.symmetric(vertical: 12.h),
                child: const Text('No transmission inspection items found.'),
              )
            else
              ...transmissionItems.map(
                (item) => Padding(
                  padding: EdgeInsets.only(bottom: 10.h),
                  child: _buildTransmissionItem(item),
                ),
              ),
          ],
        );
      },
    );
  }

  // ================================================================
  // TRANSMISSION UPPER COVER
  // ================================================================

  Widget _buildTransmissionUpperCover() {
    return Column(
      children: [
        SizedBox(height: 30.h),
        Container(
          width: 370.w,
          height: 237.h,
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
                      selectedTransmission ?? 'Transmission Fluid Leaks',
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
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      physics: const BouncingScrollPhysics(),
                      child: Row(
                        children: [
                          _buildTransmissionStatusButton(
                            'Fail',
                            Icons.cancel_outlined,
                          ),
                          SizedBox(width: 8.w),
                          _buildTransmissionStatusButton(
                            'Pass',
                            Icons.verified_outlined,
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(width: 8.w),
                  GestureDetector(
                    onTap: () {
                      // Camera/image picker can be integrated here later.
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
                            'Add photo',
                            style: TextStyle(
                              color: const Color(0xFF222222),
                              fontWeight: FontWeight.w500,
                              fontFamily: 'Manrope',
                              fontSize: 14.sp,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 75.h),
              Container(
                width: 346.w,
                height: 48.h,
                padding: EdgeInsets.only(
                  top: 10.h,
                  right: 12.w,
                  bottom: 10.h,
                  left: 12.w,
                ),
                decoration: BoxDecoration(
                  color: const Color(0xFFE8E8E8),
                  borderRadius: BorderRadius.circular(12.r),
                ),
                alignment: Alignment.centerLeft,
                child: TextField(
                  style: TextStyle(
                    fontFamily: 'Manrope',
                    fontWeight: FontWeight.w500,
                    fontSize: 16.sp,
                    color: const Color(0xFF222222),
                  ),
                  decoration: InputDecoration(
                    hintText: 'Add comment',
                    hintStyle: TextStyle(
                      color: const Color(0xFF5C5C5C),
                      fontWeight: FontWeight.w500,
                      fontFamily: 'Manrope',
                      fontSize: 14.sp,
                    ),
                    contentPadding: const EdgeInsets.only(left: 10, top: 10),
                    border: const OutlineInputBorder(
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildTransmissionStatusButton(String status, IconData icon) {
    final bool isSelected = widget.engineUpperCoverStatus == status;

    return GestureDetector(
      onTap: () {
        widget.onEngineUpperCoverStatusChanged(status);
      },
      child: Container(
        width: 84.w,
        height: 38.h,
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFFD9FFD0) : const Color(0xFFE8E8E8),
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
  // TRANSMISSION ITEM
  // ================================================================

  Widget _buildTransmissionItem(String title) {
    final bool isSelected = selectedTransmission == title;

    return GestureDetector(
      onTap: () {
        setState(() {
          selectedTransmission = title;
        });

        widget.onItemTap(title);
        showTransmissionbottomsheet(context, title);
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
          color: isSelected ? const Color(0xFFD9FFD0) : const Color(0xFFF5F5F5),
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

// ================================================================
// TRANSMISSION BOTTOM SHEET
// ================================================================

void showTransmissionbottomsheet(
  BuildContext context,
  String selectedExterior,
) {
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
