import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:rootysysproject/bloc/inspectioncategories/bloc/inspectioncategories_bloc.dart';
import 'package:rootysysproject/bloc/inspectioncategories/bloc/inspectioncategories_event.dart';
import 'package:rootysysproject/bloc/inspectioncategories/bloc/inspectioncategories_state.dart';

import 'package:rootysysproject/screens/Front_Left_door_screen.dart';

class EngineScreen extends StatefulWidget {
  final String? vehicleId;
  final String? typeItemId;

  const EngineScreen({super.key, this.vehicleId, this.typeItemId});

  @override
  State<EngineScreen> createState() => _EngineScreenState();
}

class _EngineScreenState extends State<EngineScreen> {
  String selectedEngine = '';

  // Fallback items are used only when the API has no engine items.
  final List<String> _defaultEngineItems = [
    'Key',
    'Engine Shield Cover',
    'Bonnet Hinge & Holder',
    'Turbo/Supercharger',
    'Fender Liners',
    'Drive Belt/Pulleys',
    'Engine Idle',
    'Engine Oil Filler Cap',
    'Radiator',
    'Engine Oil Leaks',
    'Engine Oil Condition',
    'Coolant Condition',
    'Coolant Cap',
    'Hoses & Pipes',
    'Exhaust System',
    'Visible Rust',
    'Water Scaling/Dirt Marks',
    '4 Wheel Drive',
  ];

  @override
  void initState() {
    super.initState();

    // Request inspection fields when IDs are provided.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;

      final vehicleId = widget.vehicleId;
      final typeItemId = widget.typeItemId;

      if (vehicleId != null &&
          vehicleId.isNotEmpty &&
          typeItemId != null &&
          typeItemId.isNotEmpty) {
        context.read<InspectionDetailsBloc>().add(
          GetInspectionDataFieldsEvent(
            vehicleId: vehicleId,
            typeItemId: typeItemId,
          ),
        );
      }
    });
  }

  /// Finds engine-related items in the inspection API response.
  ///
  /// Supports category names such as:
  /// Engine, Engine Bay, Engine & Undercarriage.

  List<String> _getEngineItems(InspectionDetailsState state) {
    if (state is! InspectionDetailsLoaded) {
      return _defaultEngineItems;
    }

    final categories = state.model.data?.categories ?? [];

    for (final category in categories) {
      final categoryName =
          category.categoryId?.name?.toLowerCase().trim() ?? '';

      final isEngineCategory =
          categoryName.contains('engine') ||
          categoryName.contains('underhood') ||
          categoryName.contains('under hood');

      if (!isEngineCategory) continue;

      final items = category.items
          .map((entry) => entry.itemId?.name?.trim() ?? '')
          .where((name) => name.isNotEmpty)
          .toList();

      if (items.isNotEmpty) {
        return items;
      }
    }

    return _defaultEngineItems;
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<InspectionDetailsBloc, InspectionDetailsState>(
      builder: (context, state) {
        final engineItems = _getEngineItems(state);

        if (state is InspectionDetailsLoading) {
          return const Center(child: CircularProgressIndicator());
        }

        if (state is InspectionDetailsError &&
            widget.vehicleId != null &&
            widget.typeItemId != null) {
          return Center(
            child: Padding(
              padding: EdgeInsets.all(16.w),
              child: Text(
                'Unable to load engine inspection items.\n'
                '${state.message}',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 14.sp, color: Colors.red),
              ),
            ),
          );
        }

        return Column(
          children: [
            SizedBox(height: 10.h),
            ...engineItems.map(
              (item) => Padding(
                padding: EdgeInsets.only(bottom: 10.h),
                child: _buildEngineItem(item),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildEngineItem(String title) {
    final bool isSelected = selectedEngine == title;

    return GestureDetector(
      onTap: () {
        setState(() {
          selectedEngine = title;
        });

        showEngineBottomSheet(context, title);
      },
      child: Container(
        width: double.infinity,
        height: 48.h,
        padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 10.h),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFFE8F5E9) : const Color(0xFFF5F5F5),
          borderRadius: BorderRadius.circular(12.r),
          border: Border.all(
            color: isSelected ? const Color(0xFF16965A) : Colors.transparent,
          ),
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

void showEngineBottomSheet(BuildContext context, String selectedEngine) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (bottomSheetContext) {
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
        child: FrontLeftDoor(exteriorName: selectedEngine, showChasis: false),
      );
    },
  );
}
