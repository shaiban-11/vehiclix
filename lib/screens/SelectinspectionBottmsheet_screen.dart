import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:rootysysproject/bloc/inspectiontype/bloc/inspectiontype_bloc.dart';
import 'package:rootysysproject/bloc/inspectiontype/bloc/inspectiontype_event.dart';
import 'package:rootysysproject/bloc/inspectiontype/bloc/inspectiontype_state.dart';
import 'package:rootysysproject/screens/Tyres_screen.dart';

class SelectInspectionBottomSheet extends StatefulWidget {
  const SelectInspectionBottomSheet({
    super.key,
    required this.onFullInspectionTap,
    required this.vehicleid,
    required this.customerid,
    this.inspectionId,
  });

  final VoidCallback onFullInspectionTap;
  final String vehicleid;
  final String customerid;
  final String? inspectionId;

  @override
  State<SelectInspectionBottomSheet> createState() =>
      _SelectInspectionBottomSheetState();
}

class _SelectInspectionBottomSheetState
    extends State<SelectInspectionBottomSheet> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        context.read<InspectionBloc>().add(GetInspectionTypesEvent());
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 402.w,
      height: 440.h,
      decoration: BoxDecoration(
        color: const Color(0xFFF5F5F5),
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(28.r),
          topRight: Radius.circular(28.r),
        ),
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 24.h),
            Text(
              'Select inspect type',
              style: TextStyle(
                fontFamily: 'Manrope',
                fontWeight: FontWeight.w600,
                fontSize: 16.sp,
                height: 1.0,
                color: Colors.black,
              ),
            ),
            SizedBox(height: 20.h),
            Container(
              width: 370.w,
              height: 1.h,
              color: const Color(0xFFE8E8E8),
            ),
            SizedBox(height: 16.h),

            Expanded(
              child: BlocBuilder<InspectionBloc, InspectionState>(
                builder: (context, state) {
                  if (state is InspectionLoading) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  if (state is InspectionError) {
                    return Center(
                      child: Text(state.message, textAlign: TextAlign.center),
                    );
                  }

                  if (state is InspectionTypesLoaded) {
                    final inspections = state.inspectionModel.data ?? [];

                    if (inspections.isEmpty) {
                      return const Center(
                        child: Text('No inspection types found'),
                      );
                    }

                    return ListView.separated(
                      padding: EdgeInsets.zero,
                      itemCount: inspections.length,
                      separatorBuilder: (context, index) =>
                          SizedBox(height: 10.h),
                      itemBuilder: (context, index) {
                        final inspection = inspections[index];
                        final name = inspection.name?.trim() ?? '';
                        final normalizedName = name.toLowerCase();

                        String? image;
                        if (normalizedName.contains('full inspection')) {
                          image = 'assets/images/car.png';
                        } else if (normalizedName.contains('insurance')) {
                          image = 'assets/images/insurance inspect.png';
                        } else if (normalizedName.contains('interior')) {
                          image = 'assets/images/interior inspect.png';
                        }

                        return inspectiondetails(
                          image,
                          name,
                          onTap: () {
                            debugPrint('Tapped inspection: $name');
                            debugPrint('Inspection ID: ${inspection.id}');

                            if (inspection.id == null) {
                              debugPrint('Inspection ID is null');
                              return;
                            }

                            if (normalizedName.contains('full inspection') ||
                                normalizedName.contains('full inspect')) {
                              widget.onFullInspectionTap();
                            }

                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => TyresScreen(
                                  vehicleId: widget.vehicleid,
                                  typeItemId: inspection.id.toString(),
                                  customerId: widget.customerid,
                                  inspectionId: widget.inspectionId ?? '',
                                ),
                              ),
                            );
                          },
                        );
                      },
                    );
                  }

                  if (state is InspectionInitial) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  return const SizedBox.shrink();
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget inspectiondetails(
    String? image,
    String text, {
    String? containerText,
    VoidCallback? onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 370.w,
        height: 54.h,
        padding: EdgeInsets.all(8.w),
        decoration: BoxDecoration(
          color: const Color(0xFFFFFFFF),
          borderRadius: BorderRadius.circular(11.r),
        ),
        child: Row(
          children: [
            Container(
              width: 38.w,
              height: 38.h,
              decoration: BoxDecoration(
                color: const Color(0x2693FF26),
                borderRadius: BorderRadius.circular(5.r),
              ),
              alignment: Alignment.center,
              child: image != null
                  ? Image.asset(image, color: const Color(0xFF2A2A2A))
                  : Text(
                      containerText ?? 'R',
                      style: TextStyle(
                        fontFamily: 'Manrope',
                        fontWeight: FontWeight.w600,
                        fontSize: 17.sp,
                        color: const Color(0xFF2A2A2A),
                      ),
                      textAlign: TextAlign.center,
                    ),
            ),
            SizedBox(width: 10.w),
            Expanded(
              child: Text(
                text,
                style: TextStyle(
                  fontFamily: 'Manrope',
                  fontWeight: FontWeight.w600,
                  fontSize: 16.sp,
                  height: 1.0,
                  color: Colors.black,
                ),
              ),
            ),
            Container(
              width: 24.w,
              height: 24.h,
              decoration: const BoxDecoration(
                color: Color(0xFF93FF26),
                shape: BoxShape.circle,
              ),
              alignment: Alignment.center,
              child: Image.asset('assets/images/Vector (2).png'),
            ),
          ],
        ),
      ),
    );
  }
}
