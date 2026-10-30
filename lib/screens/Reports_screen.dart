import 'package:flutter/material.dart';
import 'package:rootysysproject/repositories/models/completeinspection_model.dart';

import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:rootysysproject/screens/Profile_screen.dart';
import 'package:rootysysproject/repositories/Api/api_client.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rootysysproject/bloc/inspectiondetail/bloc/inspectiondetail_bloc.dart';
import 'package:rootysysproject/bloc/inspectiondetail/bloc/inspectiondetail_event.dart';
import 'package:rootysysproject/bloc/inspectiondetail/bloc/inspectiondetail_state.dart';
import 'package:rootysysproject/repositories/Api/inspectiondetails_api.dart';
import 'package:rootysysproject/repositories/models/inspectiondetails_model.dart';

import 'package:rootysysproject/screens/reportsdetails_screen.dart';

class ReportsScreen extends StatefulWidget {
  const ReportsScreen({super.key});

  @override
  State<ReportsScreen> createState() => _ReportsScreenState();
}

class _ReportsScreenState extends State<ReportsScreen> {
  static const Color black = Color(0xFF000000);
  static const Color grayText = Color(0xFF808080);
  static const Color background = Color(0xFFF7F7F7);
  static const Color white = Color(0xFFFFFFFF);
  static const Color green = Color(0xFF73F700);

  final TextEditingController searchController = TextEditingController();

  // Use your existing API client.
  late final ApiClient apiClient;

  String selectedFilter = 'All';

  late Future<List<Map<String, dynamic>>> reportsFuture;

  @override
  void initState() {
    super.initState();

    apiClient = ApiClient();
    reportsFuture = _fetchReports();
  }

  @override
  void dispose() {
    searchController.dispose();
    apiClient.close();
    super.dispose();
  }

  // =========================================================
  // FETCH REPORTS FROM API
  // =========================================================

  Future<List<Map<String, dynamic>>> _fetchReports() async {
    final List<Map<String, dynamic>> allReports = [];

    // Fetch draft inspections.
    try {
      final draftResponse = await apiClient.getDraftVehicleInspections(
        page: 1,
        limit: 100,
      );

      allReports.addAll(_extractReports(draftResponse));
    } catch (e) {
      debugPrint('Failed to fetch draft inspections: $e');
    }

    // Fetch completed inspections.
    try {
      final completedResponse = await apiClient.getCompletedVehicleInspections(
        page: 1,
        limit: 100,
      );

      allReports.addAll(_extractReports(completedResponse));
    } catch (e) {
      debugPrint('Failed to fetch completed inspections: $e');
    }

    // Remove duplicate reports by inspection ID.
    final Map<String, Map<String, dynamic>> uniqueReports = {};

    for (int i = 0; i < allReports.length; i++) {
      final report = allReports[i];

      final id =
          report['_id']?.toString() ?? report['id']?.toString() ?? 'report_$i';

      uniqueReports[id] = report;
    }

    if (allReports.isEmpty) {
      debugPrint('No inspection reports were returned by the API.');
    }

    return uniqueReports.values.toList();
  }

  // =========================================================
  // EXTRACT LIST FROM DIFFERENT RESPONSE FORMATS
  // =========================================================

  List<Map<String, dynamic>> _extractReports(dynamic response) {
    dynamic data = response;

    if (data is Map) {
      // API may return {success: true, data: [...]}
      data =
          data['data'] ??
          data['results'] ??
          data['inspections'] ??
          data['items'];
    }

    // Some paginated APIs return:
    // {data: {docs: [...]}}
    if (data is Map) {
      data =
          data['docs'] ??
          data['results'] ??
          data['inspections'] ??
          data['items'];
    }

    if (data is! List) {
      debugPrint('Unexpected reports response format: ${response.runtimeType}');
      return [];
    }

    return data
        .whereType<Map>()
        .map((item) => Map<String, dynamic>.from(item))
        .toList();
  }

  // =========================================================
  // REFRESH REPORTS
  // =========================================================

  Future<void> _refreshReports() async {
    setState(() {
      reportsFuture = _fetchReports();
    });

    await reportsFuture;
  }

  // =========================================================
  // SAFE VALUE HELPERS
  // =========================================================

  String _stringValue(dynamic value) {
    if (value == null) return '';

    if (value is Map) {
      return value['name']?.toString() ??
          value['model_name']?.toString() ??
          value['variant_name']?.toString() ??
          '';
    }

    return value.toString();
  }

  Map<String, dynamic> _mapValue(dynamic value) {
    if (value is Map) {
      return Map<String, dynamic>.from(value);
    }

    return {};
  }

  // =========================================================
  // CUSTOMER NAME
  // =========================================================

  String _getCustomerName(Map<String, dynamic> report) {
    final customer = _mapValue(report['customer_id']);

    final user = _mapValue(customer['user_id']);

    final directName = _stringValue(
      report['customer_name'] ?? report['customerName'],
    );

    if (directName.isNotEmpty) {
      return directName;
    }

    final userName = _stringValue(user['name']);

    if (userName.isNotEmpty) {
      return userName;
    }

    final customerName = _stringValue(customer['name']);

    if (customerName.isNotEmpty) {
      return customerName;
    }

    return 'Unknown Customer';
  }

  // =========================================================
  // VEHICLE NAME
  // =========================================================

  String _getVehicleName(Map<String, dynamic> report) {
    final vehicle = _mapValue(report['vehicle_id']);

    final directName = _stringValue(
      report['vehicle_name'] ?? report['vehicleName'],
    );

    if (directName.isNotEmpty) {
      return directName;
    }

    final brand = _stringValue(vehicle['brand_id']);

    final model = _stringValue(vehicle['model_id']);

    final combinedName = [
      brand,
      model,
    ].where((value) => value.isNotEmpty).join(' ');

    if (combinedName.isNotEmpty) {
      return combinedName;
    }

    return 'Vehicle details unavailable';
  }

  // =========================================================
  // INSPECTION TITLE
  // =========================================================

  String _getInspectionTitle(Map<String, dynamic> report) {
    final inspectionType = _mapValue(
      report['inspectionTypeId'] ?? report['inspection_type_id'],
    );
    debugPrint('INSPECTION DATA: $report');

    final typeName = _stringValue(
      report['inspection_type_name'] ??
          report['inspectionType'] ??
          inspectionType['name'],
    );

    final customerName = _getCustomerName(report);

    final type = typeName.isNotEmpty ? typeName : 'Vehicle Inspection';

    return '$type | $customerName';
  }
  // =========================================================
  // NORMALIZE STATUS
  // =========================================================

  String _getReportStatus(Map<String, dynamic> report) {
    final rawStatus = _stringValue(report['status']).trim().toLowerCase();

    // Explicit failure statuses.
    if (['failed', 'fail', 'rejected'].contains(rawStatus)) {
      return 'Failed';
    }

    // Draft inspections are pending.
    if ([
      'draft',
      'pending',
      'in progress',
      'in_progress',
    ].contains(rawStatus)) {
      return 'Pending';
    }

    // Completed reports may have failed inspection items.
    if (['completed', 'complete'].contains(rawStatus)) {
      final failCount = report['fail_count'];

      final parsedFailCount = failCount is num
          ? failCount
          : num.tryParse(failCount?.toString() ?? '') ?? 0;

      if (parsedFailCount > 0) {
        return 'Failed';
      }

      return 'Passed';
    }

    // Handle APIs that provide the overall result separately.
    final result = _stringValue(
      report['result'] ?? report['overall_status'],
    ).toLowerCase();

    if (result == 'failed' || result == 'fail') {
      return 'Failed';
    }

    if (result == 'passed' || result == 'pass') {
      return 'Passed';
    }

    // Do not treat unknown statuses as completed.
    return rawStatus.isEmpty ? 'Unknown' : 'Pending';
  }

  // =========================================================
  // FILTER REPORTS
  // =========================================================

  List<Map<String, dynamic>> _getFilteredReports(
    List<Map<String, dynamic>> reports,
  ) {
    List<Map<String, dynamic>> filteredReports = reports;

    if (selectedFilter != 'All') {
      filteredReports = filteredReports.where((report) {
        return _getReportStatus(report) == selectedFilter;
      }).toList();
    }

    final searchText = searchController.text.trim().toLowerCase();

    if (searchText.isNotEmpty) {
      filteredReports = filteredReports.where((report) {
        final title = _getInspectionTitle(report).toLowerCase();

        final vehicle = _getVehicleName(report).toLowerCase();

        final inspectionNo = _stringValue(
          report['inspection_no'],
        ).toLowerCase();

        return title.contains(searchText) ||
            vehicle.contains(searchText) ||
            inspectionNo.contains(searchText);
      }).toList();
    }

    return filteredReports;
  }

  // =========================================================
  // MAIN UI
  // =========================================================

  @override
  Widget build(BuildContext context) {
    return Container(
      color: background,
      child: Stack(
        children: [
          RefreshIndicator(
            onRefresh: _refreshReports,
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              padding: EdgeInsets.only(
                left: 8.w,
                right: 8.w,
                top: 8.h,
                bottom: 95.h,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 50.h),

                  // -------------------------------------------------
                  // HEADER
                  // -------------------------------------------------
                  SizedBox(
                    height: 34.h,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Image.asset(
                          'assets/images/Layer_1.png',
                          width: 89.w,
                          height: 24.h,
                          fit: BoxFit.contain,
                        ),

                        SizedBox(
                          width: 34.w,
                          height: 34.h,
                          child: GestureDetector(
                            onTap: () {
                              showGeneralDialog(
                                context: context,
                                barrierDismissible: true,
                                barrierLabel: 'Profile',
                                barrierColor: Colors.black.withOpacity(0.15),
                                transitionDuration: const Duration(
                                  milliseconds: 200,
                                ),
                                pageBuilder:
                                    (context, animation, secondaryAnimation) {
                                      return const ProfileScreen();
                                    },
                              );
                            },
                            child: Image.asset(
                              'assets/images/Frame 15.png',
                              height: 14.h,
                              width: 14.w,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  SizedBox(height: 30.h),

                  // -------------------------------------------------
                  // SEARCH
                  // -------------------------------------------------
                  Container(
                    width: double.infinity,
                    height: 48.h,
                    padding: EdgeInsets.only(
                      top: 10.h,
                      right: 10.w,
                      bottom: 10.h,
                      left: 16.w,
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0xFFE8E8E8),
                      borderRadius: BorderRadius.circular(32.r),
                    ),
                    child: TextField(
                      controller: searchController,
                      textAlignVertical: TextAlignVertical.center,
                      onChanged: (value) {
                        setState(() {});
                      },
                      style: TextStyle(
                        fontFamily: 'Manrope',
                        fontSize: 12.sp,
                        fontWeight: FontWeight.w400,
                        color: black,
                      ),
                      decoration: InputDecoration(
                        hintText: 'Search reports...',
                        hintStyle: TextStyle(
                          fontFamily: 'Manrope',
                          fontSize: 12.sp,
                          fontWeight: FontWeight.w400,
                          color: grayText,
                        ),
                        border: InputBorder.none,
                        isDense: true,
                        contentPadding: EdgeInsets.only(
                          left: 5.h,
                          top: 0.h, // Increase this to move text down
                          bottom: 0.h,
                        ),
                      ),
                    ),
                  ),

                  SizedBox(height: 25.h),

                  // -------------------------------------------------
                  // FILTER BUTTONS
                  // -------------------------------------------------
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: [
                        _buildFilterButton('All'),
                        SizedBox(width: 9.w),
                        _buildFilterButton('Pending'),
                        SizedBox(width: 9.w),
                        _buildFilterButton('Passed'),
                        SizedBox(width: 9.w),
                        _buildFilterButton('Failed'),
                      ],
                    ),
                  ),

                  SizedBox(height: 18.h),

                  // -------------------------------------------------
                  // REPORT LIST
                  // -------------------------------------------------
                  FutureBuilder<List<Map<String, dynamic>>>(
                    future: reportsFuture,
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return SizedBox(
                          height: 220.h,
                          child: const Center(
                            child: CircularProgressIndicator(),
                          ),
                        );
                      }

                      if (snapshot.hasError) {
                        return _buildMessage(
                          message: 'Unable to load reports.\n${snapshot.error}',
                          icon: Icons.error_outline,
                          showRetry: true,
                        );
                      }

                      final reports = snapshot.data ?? [];

                      final filteredReports = _getFilteredReports(reports);

                      if (filteredReports.isEmpty) {
                        return _buildMessage(
                          message: reports.isEmpty
                              ? 'No inspection reports found.'
                              : 'No reports match your search or filter.',
                          icon: Icons.description_outlined,
                          showRetry: true,
                        );
                      }

                      return Column(
                        children: filteredReports.map((report) {
                          return Padding(
                            padding: EdgeInsets.only(bottom: 9.h),
                            child: _buildReportCard(report: report),
                          );
                        }).toList(),
                      );
                    },
                  ),

                  SizedBox(height: 100.h),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // =========================================================
  // EMPTY / ERROR MESSAGE
  // =========================================================

  Widget _buildMessage({
    required String message,
    required IconData icon,
    bool showRetry = false,
  }) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 30.h),
      child: Column(
        children: [
          Icon(icon, size: 40.sp, color: grayText),
          SizedBox(height: 12.h),
          Text(
            message,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontFamily: 'Manrope',
              fontSize: 12.sp,
              color: grayText,
            ),
          ),
          if (showRetry) ...[
            SizedBox(height: 12.h),
            TextButton.icon(
              onPressed: _refreshReports,
              icon: const Icon(Icons.refresh),
              label: const Text('Retry'),
            ),
          ],
        ],
      ),
    );
  }

  // =========================================================
  // FILTER BUTTON
  // =========================================================

  Widget _buildFilterButton(String title) {
    final bool isSelected = selectedFilter == title;

    return GestureDetector(
      onTap: () {
        setState(() {
          selectedFilter = title;
        });
      },
      child: Container(
        width: 77.w,
        height: 39.h,
        padding: EdgeInsets.all(5.w),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFFE8E8E8) : white,
          borderRadius: BorderRadius.circular(24.r),
          border: Border.all(color: const Color(0xFFE8E8E8), width: 1.w),
        ),
        alignment: Alignment.center,
        child: Text(
          title,
          style: TextStyle(
            fontFamily: 'Manrope',
            fontSize: 14.sp,
            fontWeight: FontWeight.w400,
            color: black,
          ),
        ),
      ),
    );
  }

  // =========================================================
  // REPORT CARD
  // =========================================================

  Widget _buildReportCard({required Map<String, dynamic> report}) {
    final title = _getInspectionTitle(report);

    final vehicle = _getVehicleName(report);

    final status = _getReportStatus(report);

    final inspectionNo = _stringValue(report['inspection_no']);

    final vehicleData = _mapValue(report['vehicle_id']);

    final vehicleImages = vehicleData['vehicle_images'];

    String? imageUrl;

    if (vehicleImages is List && vehicleImages.isNotEmpty) {
      final firstImage = vehicleImages.first;

      if (firstImage is Map) {
        imageUrl = _stringValue(firstImage['url'] ?? firstImage['image_url']);
      } else if (firstImage is String) {
        imageUrl = firstImage;
      }
    }

    return GestureDetector(
      onTap: () {
        _openReportDetails(report);
      },
      child: Container(
        width: double.infinity,
        constraints: BoxConstraints(minHeight: 96.h),
        padding: EdgeInsets.all(8.w),
        decoration: BoxDecoration(
          color: white,
          borderRadius: BorderRadius.circular(15.r),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Vehicle image
            Container(
              width: 80.w,
              height: 80.h,
              decoration: BoxDecoration(
                color: const Color(0xFFF0F0F0),
                borderRadius: BorderRadius.circular(8.r),
              ),
              clipBehavior: Clip.antiAlias,
              child: imageUrl != null && imageUrl.isNotEmpty
                  ? Image.network(
                      imageUrl,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return _vehiclePlaceholder();
                      },
                    )
                  : Image.asset(
                      'assets/images/vehicle.png',
                      fit: BoxFit.contain,
                      errorBuilder: (context, error, stackTrace) {
                        return _vehiclePlaceholder();
                      },
                    ),
            ),

            SizedBox(width: 11.w),

            // -------------------------------------------------
            // REPORT DETAILS
            // -------------------------------------------------
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontFamily: 'Manrope',
                      fontSize: 12.sp,
                      fontWeight: FontWeight.w400,
                      color: grayText,
                      height: 1.2,
                    ),
                  ),

                  SizedBox(height: 5.h),

                  Text(
                    vehicle,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontFamily: 'Manrope',
                      fontSize: 13.sp,
                      fontWeight: FontWeight.w600,
                      color: black,
                      height: 1.2,
                    ),
                  ),

                  if (inspectionNo.isNotEmpty) ...[
                    SizedBox(height: 4.h),
                    Text(
                      inspectionNo,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontFamily: 'Manrope',
                        fontSize: 10.sp,
                        color: grayText,
                      ),
                    ),
                  ],

                  SizedBox(height: 5.h),

                  Row(
                    children: [
                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 7.w,
                          vertical: 3.h,
                        ),
                        decoration: BoxDecoration(
                          color: _statusBackground(status),
                          borderRadius: BorderRadius.circular(10.r),
                        ),
                        child: Text(
                          status,
                          style: TextStyle(
                            fontFamily: 'Manrope',
                            fontSize: 10.sp,
                            fontWeight: FontWeight.w500,
                            color: _statusColor(status),
                          ),
                        ),
                      ),

                      const Spacer(),

                      GestureDetector(
                        onTap: () {
                          _openReportDetails(report);
                        },
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              'See',
                              style: TextStyle(
                                fontFamily: 'Manrope',
                                fontSize: 12.sp,
                                fontWeight: FontWeight.w500,
                                color: black,
                                height: 1,
                              ),
                            ),
                            SizedBox(width: 4.w),
                            Container(
                              width: 14.w,
                              height: 14.h,
                              decoration: const BoxDecoration(
                                color: green,
                                shape: BoxShape.circle,
                              ),
                              child: Icon(
                                Icons.chevron_right,
                                size: 12.sp,
                                color: black,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // =========================================================
  // VEHICLE IMAGE PLACEHOLDER
  // =========================================================

  Widget _vehiclePlaceholder() {
    return Icon(Icons.directions_car, size: 35.sp, color: Colors.grey);
  }

  // =========================================================
  // STATUS COLORS
  // =========================================================

  Color _statusColor(String status) {
    switch (status) {
      case 'Pending':
        return Colors.orange.shade800;

      case 'Passed':
        return Colors.green.shade800;

      case 'Failed':
        return Colors.red.shade800;

      default:
        return grayText;
    }
  }

  Color _statusBackground(String status) {
    switch (status) {
      case 'Pending':
        return Colors.orange.shade50;

      case 'Passed':
        return Colors.green.shade50;

      case 'Failed':
        return Colors.red.shade50;

      default:
        return const Color(0xFFF0F0F0);
    }
  }

  // =========================================================
  // OPEN REPORT DETAILS
  // =========================================================
  void _openReportDetails(Map<String, dynamic> report) {
    final inspection = InspectionCompletedData.fromJson(report);

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => FetchreportsScreen(report: inspection),
      ),
    );
  }
}

// Open the details sheet and fetch the selected inspection by ID.

/// Shows the selected inspection details returned by the detail API.
/// This widget is in the same file so the ReportsScreen integration
/// remains in one Dart file.
class VehicleInspectionDetailsSheet extends StatelessWidget {
  final String inspectionId;

  const VehicleInspectionDetailsSheet({super.key, required this.inspectionId});

  static const Color _green = Color(0xFF73F700);
  static const Color _black = Color(0xFF000000);
  static const Color _gray = Color(0xFF808080);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        height: MediaQuery.of(context).size.height * 0.88,
        decoration: const BoxDecoration(
          color: Color(0xFFF7F7F7),
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 18, 12, 12),
              child: Row(
                children: [
                  const Expanded(
                    child: Text(
                      'Inspection Details',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                        color: _black,
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 34.w,
                    height: 34.h,
                    child: GestureDetector(
                      onTap: () {
                        showGeneralDialog(
                          context: context,
                          barrierDismissible: true,
                          barrierLabel: 'Profile',
                          barrierColor: Colors.black.withOpacity(0.15),
                          transitionDuration: const Duration(milliseconds: 200),
                          pageBuilder:
                              (context, animation, secondaryAnimation) {
                                return const ProfileScreen();
                              },
                        );
                      },
                      child: Image.asset(
                        'assets/images/Frame 15.png',
                        height: 14.h,
                        width: 14.w,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const Divider(height: 1),
            Expanded(
              child: BlocBuilder<VehicleInspectionBloc, VehicleInspectionState>(
                builder: (context, state) {
                  if (state is VehicleInspectionLoading ||
                      state is VehicleInspectionInitial) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  if (state is VehicleInspectionFailure) {
                    return Center(
                      child: Padding(
                        padding: const EdgeInsets.all(24),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(
                              Icons.error_outline,
                              color: Colors.red,
                              size: 42,
                            ),
                            const SizedBox(height: 12),
                            const Text(
                              'Unable to load inspection details',
                              style: TextStyle(fontWeight: FontWeight.w600),
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(height: 8),
                            Text(
                              state.message,
                              textAlign: TextAlign.center,
                              style: const TextStyle(color: _gray),
                            ),
                            const SizedBox(height: 16),
                            ElevatedButton.icon(
                              onPressed: () {
                                context.read<VehicleInspectionBloc>().add(
                                  FetchVehicleInspection(
                                    inspectionId: inspectionId,
                                  ),
                                );
                              },
                              icon: const Icon(Icons.refresh),
                              label: const Text('Retry'),
                            ),
                          ],
                        ),
                      ),
                    );
                  }

                  if (state is VehicleInspectionSuccess) {
                    final data = state.inspection.data;

                    if (data == null) {
                      return const Center(
                        child: Text('Inspection details are empty.'),
                      );
                    }

                    return _buildInspectionContent(data);
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

  Widget _buildInspectionContent(InspectionData data) {
    final customerName = data.customer?.user?.name ?? 'Not available';
    final vehicle = data.vehicle;
    final vehicleName = [
      vehicle?.brand?.name ?? '',
      vehicle?.model?.name ?? '',
      vehicle?.variant?.name ?? '',
    ].where((value) => value.isNotEmpty).join(' ');

    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 28),
      children: [
        _sectionTitle('Inspection Summary'),
        _detailCard([
          _detailRow('Inspection number', data.inspectionNo),
          _detailRow(
            'Inspection type',
            data.inspectionType?.name ?? 'Not available',
          ),
          _detailRow('Customer', customerName),
          _detailRow('Inspector', data.inspector?.name ?? 'Not available'),
          _detailRow('Date', data.inspectionDate ?? 'Not available'),
          _detailRow('Status', data.status),
        ]),
        const SizedBox(height: 16),
        _sectionTitle('Vehicle Information'),
        _detailCard([
          _detailRow(
            'Vehicle',
            vehicleName.isEmpty ? 'Not available' : vehicleName,
          ),
          _detailRow('Plate number', vehicle?.plateNumber ?? 'Not available'),
          _detailRow(
            'Year',
            vehicle == null || vehicle.year == 0
                ? 'Not available'
                : vehicle.year.toString(),
          ),
          _detailRow('VIN', vehicle?.vin ?? 'Not available'),
          _detailRow('Engine number', vehicle?.engineNumber ?? 'Not available'),
          _detailRow('Fuel type', vehicle?.fuelType?.name ?? 'Not available'),
          _detailRow(
            'Transmission',
            vehicle?.transmission?.name ?? 'Not available',
          ),
          _detailRow(
            'Odometer',
            vehicle == null ? 'Not available' : vehicle.odometer.toString(),
          ),
        ]),
        const SizedBox(height: 16),
        _sectionTitle('Inspection Result'),
        _detailCard([
          _detailRow('Overall score', data.overallScore.toString()),
          _detailRow('Total weight', data.totalWeight.toString()),
          _detailRow('Gained score', data.gainedScore.toString()),
          _detailRow('Passed', data.passCount.toString()),
          _detailRow('Failed', data.failCount.toString()),
          _detailRow('N/A', data.naCount.toString()),
          _detailRow('N/C', data.ncCount.toString()),
        ]),
        const SizedBox(height: 16),
        _sectionTitle('Inspection Categories'),
        if (data.categories.isEmpty)
          const Text(
            'No inspection categories available.',
            style: TextStyle(color: _gray),
          )
        else
          ...data.categories.map((category) {
            return Container(
              margin: const EdgeInsets.only(bottom: 12),
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(14),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    category.category?.name ?? 'Category',
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                      color: _black,
                    ),
                  ),
                  const SizedBox(height: 10),
                  if (category.items.isEmpty)
                    const Text(
                      'No items in this category.',
                      style: TextStyle(color: _gray),
                    )
                  else
                    ...category.items.map((item) {
                      return Container(
                        padding: const EdgeInsets.symmetric(vertical: 9),
                        decoration: const BoxDecoration(
                          border: Border(
                            top: BorderSide(color: Color(0xFFEAEAEA)),
                          ),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Expanded(
                                  child: Text(
                                    item.item?.name ?? 'Inspection item',
                                    style: const TextStyle(
                                      fontWeight: FontWeight.w600,
                                      color: _black,
                                    ),
                                  ),
                                ),
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 9,
                                    vertical: 4,
                                  ),
                                  decoration: BoxDecoration(
                                    color: _statusBackground(item.status),
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  child: Text(
                                    item.status.isEmpty
                                        ? 'Unknown'
                                        : item.status,
                                    style: TextStyle(
                                      fontSize: 11,
                                      color: _statusColor(item.status),
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            if (item.comment.isNotEmpty) ...[
                              const SizedBox(height: 5),
                              Text(
                                item.comment,
                                style: const TextStyle(
                                  color: _gray,
                                  fontSize: 12,
                                ),
                              ),
                            ],
                            if (item.selectedDefects.isNotEmpty) ...[
                              const SizedBox(height: 5),
                              Text(
                                'Defects: ${item.selectedDefects.join(', ')}',
                                style: const TextStyle(
                                  color: Colors.red,
                                  fontSize: 12,
                                ),
                              ),
                            ],
                          ],
                        ),
                      );
                    }),
                ],
              ),
            );
          }),
      ],
    );
  }

  Widget _sectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 9),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 15,
          fontWeight: FontWeight.w700,
          color: _black,
        ),
      ),
    );
  }

  Widget _detailCard(List<Widget> children) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Column(children: children),
    );
  }

  Widget _detailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 4,
            child: Text(
              label,
              style: const TextStyle(color: _gray, fontSize: 12),
            ),
          ),
          Expanded(
            flex: 6,
            child: Text(
              value.isEmpty ? 'Not available' : value,
              textAlign: TextAlign.end,
              style: const TextStyle(
                color: _black,
                fontSize: 12,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Color _statusColor(String status) {
    switch (status.toLowerCase()) {
      case 'pass':
      case 'passed':
        return Colors.green.shade800;
      case 'fail':
      case 'failed':
        return Colors.red.shade800;
      case 'n/a':
        return Colors.orange.shade800;
      default:
        return _gray;
    }
  }

  Color _statusBackground(String status) {
    switch (status.toLowerCase()) {
      case 'pass':
      case 'passed':
        return Colors.green.shade50;
      case 'fail':
      case 'failed':
        return Colors.red.shade50;
      case 'n/a':
        return Colors.orange.shade50;
      default:
        return const Color(0xFFF0F0F0);
    }
  }
}
