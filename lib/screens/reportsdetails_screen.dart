import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:rootysysproject/repositories/models/completeinspection_model.dart';

class FetchreportsScreen extends StatelessWidget {
  final InspectionCompletedData report;

  const FetchreportsScreen({super.key, required this.report});

  static const Color bg = Color(0xFFF7F8FA);
  static const Color white = Colors.white;
  static const Color primary = Color(0xFF171717);
  static const Color secondary = Color(0xFF929292);
  static const Color green = Color(0xFF20D52A);
  static const Color red = Color(0xFFE53935);
  static const Color divider = Color(0xFFD5D5D0);

  String get vehicleName =>
      report.vehicle?.name ?? 'Vehicle name not available';

  String get inspectionStatus => report.status ?? 'Status not available';

  String get inspectionType =>
      report.inspectionType?.name ?? 'Inspection type not available';

  String get customerName =>
      report.customer?.user?.name ?? 'Name not available';

  String get customerPhone =>
      report.customer?.user?.phone ??
      report.customer?.phoneNumber ??
      'Phone not available';

  String get customerAddress {
    final parts = [
      report.customer?.address,
      report.customer?.city,
      report.customer?.country,
    ].where((value) => value != null && value.trim().isNotEmpty).toList();

    return parts.isEmpty ? 'Address not available' : parts.join(', ');
  }

  String get inspectionDate {
    if (report.inspectionDate == null || report.inspectionDate!.isEmpty) {
      return 'Date not available';
    }

    final date = DateTime.tryParse(report.inspectionDate!);

    if (date == null) return report.inspectionDate!;

    final localDate = date.toLocal();

    return '${localDate.day.toString().padLeft(2, '0')}/'
        '${localDate.month.toString().padLeft(2, '0')}/'
        '${localDate.year}';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bg,
      appBar: AppBar(
        backgroundColor: white,
        surfaceTintColor: white,
        elevation: 0,
        toolbarHeight: 64.h,
        centerTitle: true,
        leading: IconButton(
          onPressed: () => Navigator.maybePop(context),
          icon: Icon(Icons.arrow_back, size: 27.sp, color: Colors.black),
        ),
        title: Text(
          'Report Details',
          style: TextStyle(
            fontSize: 19.sp,
            fontWeight: FontWeight.w600,
            color: Colors.black,
          ),
        ),
      ),
      body: SafeArea(
        top: false,
        child: LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: ConstrainedBox(
                constraints: BoxConstraints(minHeight: constraints.maxHeight),
                child: Padding(
                  padding: EdgeInsets.fromLTRB(15.w, 15.h, 15.w, 30.h),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      vehicleCard(),

                      SizedBox(height: 15.h),

                      Row(
                        children: [
                          Expanded(
                            child: scoreCard(
                              'Score',
                              '${report.overallScore ?? 0}/${report.totalWeight ?? 0}',
                              green,
                            ),
                          ),
                          SizedBox(width: 9.w),
                          Expanded(
                            child: scoreCard(
                              'Passed',
                              '${report.passCount ?? 0}',
                              primary,
                            ),
                          ),
                          SizedBox(width: 9.w),
                          Expanded(
                            child: scoreCard(
                              'Failed',
                              '${report.failCount ?? 0}',
                              red,
                            ),
                          ),
                        ],
                      ),

                      SizedBox(height: 9.h),

                      Row(
                        children: [
                          Expanded(
                            child: scoreCard(
                              'N/A',
                              '${report.naCount ?? 0}',
                              secondary,
                            ),
                          ),
                          SizedBox(width: 9.w),
                          Expanded(
                            child: scoreCard(
                              'N/C',
                              '${report.ncCount ?? 0}',
                              secondary,
                            ),
                          ),
                        ],
                      ),

                      SizedBox(height: 23.h),

                      sectionTitle('Inspection Information'),

                      SizedBox(height: 10.h),

                      informationCard([
                        InfoRow(
                          'Inspection No.',
                          report.inspectionNo ?? 'Not available',
                        ),
                        InfoRow('Date', inspectionDate),
                        InfoRow(
                          'Inspector',
                          report.inspector?.name ?? 'Not available',
                        ),
                      ]),

                      SizedBox(height: 23.h),

                      sectionTitle('Customer Details'),

                      SizedBox(height: 10.h),

                      informationCard([
                        InfoRow('Name', customerName),
                        InfoRow('Phone', customerPhone),
                        InfoRow('Address', customerAddress),
                      ]),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  // VEHICLE CARD
  Widget vehicleCard() {
    final imageUrl = report.vehicle?.image ?? '';

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: white,
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.025),
            blurRadius: 10.r,
            offset: Offset(0, 3.h),
          ),
        ],
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: double.infinity,
            height: 155.h,
            child: imageUrl.startsWith('http')
                ? Image.network(
                    imageUrl,
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) => vehicleImageFallback(),
                  )
                : vehicleImageFallback(),
          ),

          Padding(
            padding: EdgeInsets.fromLTRB(13.w, 13.h, 13.w, 13.h),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Text(
                        vehicleName,
                        style: TextStyle(
                          fontSize: 18.sp,
                          height: 1.45,
                          fontWeight: FontWeight.w600,
                          color: primary,
                        ),
                      ),
                    ),
                    SizedBox(width: 5.w),
                    Container(
                      margin: EdgeInsets.only(top: 2.h),
                      padding: EdgeInsets.symmetric(
                        horizontal: 10.w,
                        vertical: 6.h,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF4F4F4),
                        borderRadius: BorderRadius.circular(30.r),
                      ),
                      child: Text(
                        inspectionStatus.toUpperCase(),
                        style: TextStyle(
                          fontSize: 10.sp,
                          color: secondary,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),

                SizedBox(height: 3.h),

                Text(
                  inspectionType,
                  style: TextStyle(fontSize: 13.sp, color: secondary),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget vehicleImageFallback() {
    return Container(
      color: const Color(0xFFE4E4E4),
      child: Icon(Icons.directions_car, size: 50.sp, color: Colors.grey),
    );
  }

  // SCORE CARD
  Widget scoreCard(String title, String value, Color valueColor) {
    return Container(
      height: 74.h,
      decoration: BoxDecoration(
        color: white,
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.015),
            blurRadius: 8.r,
            offset: Offset(0, 3.h),
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: 11.sp,
              color: secondary,
              fontWeight: FontWeight.w400,
            ),
          ),
          SizedBox(height: 8.h),
          FittedBox(
            fit: BoxFit.scaleDown,
            child: Text(
              value,
              style: TextStyle(
                fontSize: 17.sp,
                fontWeight: FontWeight.w600,
                color: valueColor,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // SECTION TITLE
  Widget sectionTitle(String title) {
    return Text(
      title,
      style: TextStyle(
        fontSize: 15.sp,
        fontWeight: FontWeight.w600,
        color: primary,
      ),
    );
  }

  // INFORMATION CARD
  Widget informationCard(List<InfoRow> rows) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 13.w, vertical: 4.h),
      decoration: BoxDecoration(
        color: white,
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.02),
            blurRadius: 10.r,
            offset: Offset(0, 3.h),
          ),
        ],
      ),
      child: Column(
        children: List.generate(rows.length, (index) {
          final row = rows[index];

          return Column(
            children: [
              SizedBox(
                height: 37.h,
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        row.label,
                        style: TextStyle(
                          fontSize: 12.sp,
                          color: secondary,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ),
                    SizedBox(width: 8.w),
                    Flexible(
                      child: Text(
                        row.value,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        textAlign: TextAlign.right,
                        style: TextStyle(
                          fontSize: 12.sp,
                          color: const Color(0xFF222222),
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              if (index != rows.length - 1)
                Container(height: 1.h, color: divider),
            ],
          );
        }),
      ),
    );
  }
}

class InfoRow {
  final String label;
  final String value;

  const InfoRow(this.label, this.value);
}
