import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:rootysysproject/repositories/Api/api_client.dart';

import 'package:rootysysproject/bloc/homestats/bloc/homestats_bloc.dart';
import 'package:rootysysproject/bloc/homestats/bloc/homestats_event.dart';
import 'package:rootysysproject/bloc/homestats/bloc/homestats_state.dart';

import 'package:rootysysproject/bloc/user/bloc/user_bloc.dart';
import 'package:rootysysproject/bloc/user/bloc/user_event.dart';
import 'package:rootysysproject/bloc/user/bloc/user_state.dart';

import 'package:rootysysproject/screens/Customer_screen.dart';
import 'package:rootysysproject/screens/Profile_screen.dart';
import 'package:rootysysproject/screens/Tyres_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _VehicleInspectionHomeScreenState();
}

class _VehicleInspectionHomeScreenState extends State<HomeScreen> {
  int selectedBottomIndex = 0;

  static const Color black = Color(0xFF000000);
  static const Color darkText = Color(0xFF222222);
  static const Color grayText = Color(0xFF5C5C5C);
  static const Color lightGrayText = Color(0xFF808080);
  static const Color white = Color(0xFFFFFFFF);
  static const Color background = Color(0xFFF7F7F7);
  static const Color imageBackground = Color(0xFFF3F3F4);
  static const Color green = Color(0xFF93FF26);
  static const Color progressDarkGreen = Color(0xFF306800);
  static const Color selectedHome = Color(0xFFE4FFBF);

  final ApiClient _apiClient = ApiClient();

  late Future<List<Map<String, dynamic>>> _draftsFuture;
  late Future<List<Map<String, dynamic>>> _completedFuture;

  @override
  void initState() {
    super.initState();

    _draftsFuture = _fetchDrafts();
    _completedFuture = _fetchCompleted();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;

      context.read<UserBloc>().add(UserFetchRequested());

      context.read<HomeStatsBloc>().add(const HomeStatsFetchRequested());
    });
  }

  // =========================================================
  // FETCH DRAFT INSPECTIONS
  // =========================================================

  Future<List<Map<String, dynamic>>> _fetchDrafts() async {
    final response = await _apiClient.getDraftVehicleInspections(
      page: 1,
      limit: 100,
    );

    return _extractInspectionList(response);
  }

  // =========================================================
  // FETCH COMPLETED INSPECTIONS
  // =========================================================

  Future<List<Map<String, dynamic>>> _fetchCompleted() async {
    final response = await _apiClient.getCompletedVehicleInspections(
      page: 1,
      limit: 100,
    );

    return _extractInspectionList(response);
  }

  List<Map<String, dynamic>> _extractInspectionList(dynamic response) {
    if (response is! Map) {
      throw Exception('Invalid inspection API response');
    }

    if (response['success'] == false) {
      throw Exception(
        response['message']?.toString() ?? 'Unable to fetch inspections',
      );
    }

    final dynamic data = response['data'];

    if (data is! List) {
      return [];
    }

    return data
        .whereType<Map>()
        .map((item) => Map<String, dynamic>.from(item))
        .toList();
  }

  // =========================================================
  // EXTRACT IDS FROM API RESPONSE
  // =========================================================

  String _getId(dynamic value) {
    if (value is Map) {
      return (value['_id'] ?? value['id'] ?? '').toString();
    }

    return value?.toString() ?? '';
  }

  String _getInspectionId(Map<String, dynamic> inspection) {
    return _getId(inspection['_id'] ?? inspection['id']);
  }

  String _getCustomerId(Map<String, dynamic> inspection) {
    return _getId(inspection['customer_id']);
  }

  String _getVehicleId(Map<String, dynamic> inspection) {
    return _getId(inspection['vehicle_id']);
  }

  String _getInspectionTypeId(Map<String, dynamic> inspection) {
    return _getId(
      inspection['inspection_type_id'] ?? inspection['inspectionTypeId'],
    );
  }

  // =========================================================
  // NAVIGATE TO EXISTING INSPECTION FOR UPDATE
  // =========================================================

  void _showInspectionMessage(Map<String, dynamic> inspection) {
    final inspectionId = _getInspectionId(inspection);
    final customerId = _getCustomerId(inspection);
    final vehicleId = _getVehicleId(inspection);
    final typeItemId = _getInspectionTypeId(inspection);

    if (inspectionId.isEmpty ||
        customerId.isEmpty ||
        vehicleId.isEmpty ||
        typeItemId.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Inspection ID, customer ID, vehicle ID, '
            'or inspection type ID is missing.',
          ),
        ),
      );

      debugPrint('INSPECTION DATA: $inspection');
      debugPrint('Inspection ID: $inspectionId');
      debugPrint('Customer ID: $customerId');
      debugPrint('Vehicle ID: $vehicleId');
      debugPrint('Inspection type ID: $typeItemId');

      return;
    }

    debugPrint('Opening existing inspection for update');
    debugPrint('Inspection ID: $inspectionId');
    debugPrint('Customer ID: $customerId');
    debugPrint('Vehicle ID: $vehicleId');
    debugPrint('Inspection type ID: $typeItemId');

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => TyresScreen(
          customerId: customerId,
          vehicleId: vehicleId,
          typeItemId: typeItemId,
          inspectionId: inspectionId,
        ),
      ),
    ).then((_) {
      if (!mounted) return;

      _refreshInspections();
    });
  }

  // =========================================================
  // HELPERS: READ NESTED API DATA
  // =========================================================

  String _nestedName(dynamic value) {
    if (value is Map) {
      final dynamic user = value['user_id'];

      if (user is Map && user['name'] != null) {
        return user['name'].toString();
      }

      return value['name']?.toString() ??
          value['customer_name']?.toString() ??
          '';
    }

    return value?.toString() ?? '';
  }

  String _customerName(Map<String, dynamic> inspection) {
    return _nestedName(inspection['customer_id']);
  }

  String _vehicleName(Map<String, dynamic> inspection) {
    final dynamic vehicle = inspection['vehicle_id'];

    if (vehicle is Map) {
      return vehicle['name']?.toString() ??
          vehicle['vehicle_name']?.toString() ??
          '';
    }

    return '';
  }

  String _inspectionType(Map<String, dynamic> inspection) {
    final dynamic type =
        inspection['inspection_type_id'] ?? inspection['inspectionTypeId'];

    if (type is Map) {
      return type['name']?.toString() ?? 'Vehicle Inspection';
    }

    return 'Vehicle Inspection';
  }

  String _inspectionStatus(Map<String, dynamic> inspection) {
    final status = inspection['status']?.toString() ?? '';

    if (status.toLowerCase() == 'draft') {
      return 'Pending';
    }

    if (status.toLowerCase() == 'failed' || status.toLowerCase() == 'fail') {
      return 'Failed';
    }

    if (status.toLowerCase() == 'completed' ||
        status.toLowerCase() == 'passed' ||
        status.toLowerCase() == 'pass') {
      final failCount =
          int.tryParse(inspection['fail_count']?.toString() ?? '0') ?? 0;

      return failCount > 0 ? 'Failed' : 'Passed';
    }

    return status.isEmpty ? 'Pending' : status;
  }

  double _completionPercentage(Map<String, dynamic> inspection) {
    final value = inspection['completion_percentage'];

    if (value is num) {
      return (value.toDouble() / 100).clamp(0.0, 1.0);
    }

    return 0;
  }

  String _inspectionTitle(Map<String, dynamic> inspection) {
    final type = _inspectionType(inspection);
    final customer = _customerName(inspection);

    if (customer.isEmpty) {
      return type;
    }

    return '$type | $customer';
  }

  // =========================================================
  // REFRESH INSPECTIONS
  // =========================================================

  void _refreshInspections() {
    if (!mounted) return;

    setState(() {
      _draftsFuture = _fetchDrafts();
      _completedFuture = _fetchCompleted();
    });
  }

  @override
  void dispose() {
    _apiClient.close();
    super.dispose();
  }

  // =========================================================
  // MAIN BUILD
  // =========================================================

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: background,
      body: Stack(
        children: [
          Positioned.fill(
            child: selectedBottomIndex == 1
                ? _buildReportsContent()
                : _buildHomeContent(),
          ),
          _buildBottomNavigation(),
          if (selectedBottomIndex == 0) _buildFloatingButton(),
        ],
      ),
    );
  }

  // =========================================================
  // HOME CONTENT
  // =========================================================

  Widget _buildHomeContent() {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      padding: EdgeInsets.only(left: 8.w, right: 8.w, top: 8.h, bottom: 95.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 50.h),

          _buildHeader(),

          SizedBox(height: 30.h),

          Text(
            'Continue Inspection',
            style: TextStyle(
              fontFamily: 'Manrope',
              fontSize: 16.sp,
              fontWeight: FontWeight.w500,
              color: grayText,
            ),
          ),

          SizedBox(height: 10.h),

          _buildContinueInspection(),

          SizedBox(height: 18.h),

          // =================================================
          // HOME STATISTICS API
          // =================================================
          BlocBuilder<HomeStatsBloc, HomeStatsState>(
            builder: (context, state) {
              String today = '--';
              String completed = '--';
              String failed = '--';

              if (state is HomeStatsLoading) {
                today = '...';
                completed = '...';
                failed = '...';
              } else if (state is HomeStatsSuccess) {
                final stats = state.homeStats.data;

                today = stats?.today?.toString() ?? '0';
                completed = stats?.completed?.toString() ?? '0';
                failed = stats?.failed?.toString() ?? '0';
              } else if (state is HomeStatsFailure) {
                debugPrint('HOME STATS ERROR: ${state.message}');
              }

              return Row(
                children: [
                  Expanded(
                    child: _buildStatCard(title: 'Today', value: today),
                  ),
                  SizedBox(width: 8.w),
                  Expanded(
                    child: _buildStatCard(
                      title: 'Completed',
                      value: completed,
                      titleColor: const Color(0xFF278500),
                    ),
                  ),
                  SizedBox(width: 8.w),
                  Expanded(
                    child: _buildStatCard(
                      title: 'Failed',
                      value: failed,
                      titleColor: const Color(0xFFFF2D2D),
                    ),
                  ),
                ],
              );
            },
          ),

          SizedBox(height: 25.h),

          // =================================================
          // INSPECTIONS HEADING
          // =================================================
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Inspections',
                style: TextStyle(
                  fontFamily: 'Manrope',
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w500,
                  color: grayText,
                ),
              ),
              IconButton(
                onPressed: _refreshInspections,
                icon: const Icon(Icons.refresh),
              ),
            ],
          ),

          // =================================================
          // FETCH AND DISPLAY DRAFT INSPECTIONS
          // =================================================
          FutureBuilder<List<Map<String, dynamic>>>(
            future: _draftsFuture,
            builder: (context, draftSnapshot) {
              if (draftSnapshot.connectionState == ConnectionState.waiting) {
                return const Padding(
                  padding: EdgeInsets.all(24),
                  child: Center(child: CircularProgressIndicator()),
                );
              }

              if (draftSnapshot.hasError) {
                return _buildError(
                  draftSnapshot.error.toString(),
                  _refreshInspections,
                );
              }

              final drafts = draftSnapshot.data ?? [];

              if (drafts.isEmpty) {
                return _buildEmpty('No draft inspections found.');
              }

              return Column(
                children: [
                  for (int i = 0; i < drafts.length; i++) ...[
                    _buildInspectionCard(
                      title: _inspectionTitle(drafts[i]),
                      vehicle: _vehicleName(drafts[i]),
                      status: _inspectionStatus(drafts[i]),
                      inspection: drafts[i],
                    ),
                    if (i != drafts.length - 1) SizedBox(height: 9.h),
                  ],
                ],
              );
            },
          ),

          SizedBox(height: 100.h),
        ],
      ),
    );
  }

  // =========================================================
  // HEADER
  // =========================================================

  Widget _buildHeader() {
    return SizedBox(
      height: 58.h,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Image.asset(
                  'assets/images/Layer_1.png',
                  width: 89.w,
                  height: 24.h,
                  fit: BoxFit.contain,
                ),

                SizedBox(height: 5.h),

                Expanded(
                  child: BlocBuilder<UserBloc, UserState>(
                    builder: (context, state) {
                      if (state is UserLoading) {
                        return Text(
                          'Loading user...',
                          style: TextStyle(fontSize: 12.sp, color: grayText),
                        );
                      }

                      if (state is UserSuccess) {
                        final user = state.user.data;

                        return Text(
                          'Welcome, ${user?.name ?? 'User'}',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontFamily: 'Manrope',
                            fontSize: 13.sp,
                            fontWeight: FontWeight.w600,
                            color: darkText,
                          ),
                        );
                      }

                      if (state is UserFailure) {
                        return Text(
                          'Unable to load user',
                          style: TextStyle(fontSize: 11.sp, color: Colors.red),
                        );
                      }

                      return const SizedBox.shrink();
                    },
                  ),
                ),
              ],
            ),
          ),

          SizedBox(
            width: 34.w,
            height: 34.h,
            child: GestureDetector(
              onTap: _openProfile,
              child: Image.asset(
                'assets/images/Frame 15.png',
                height: 14.h,
                width: 14.w,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _openProfile() {
    showGeneralDialog(
      context: context,
      barrierDismissible: true,
      barrierLabel: 'Profile',
      barrierColor: Colors.black.withOpacity(0.15),
      transitionDuration: const Duration(milliseconds: 200),
      pageBuilder: (context, animation, secondaryAnimation) {
        return const ProfileScreen();
      },
    );
  }

  // =========================================================
  // CONTINUE INSPECTION
  // =========================================================

  Widget _buildContinueInspection() {
    return FutureBuilder<List<Map<String, dynamic>>>(
      future: _draftsFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Container(
            width: double.infinity,
            height: 116.h,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: white,
              borderRadius: BorderRadius.circular(12.r),
            ),
            child: const CircularProgressIndicator(),
          );
        }

        if (snapshot.hasError) {
          return _buildError(snapshot.error.toString(), _refreshInspections);
        }

        final drafts = snapshot.data ?? [];

        if (drafts.isEmpty) {
          return _buildEmpty('No inspection to continue.');
        }

        final inspection = drafts.first;
        final vehicle = _vehicleName(inspection);
        final progress = _completionPercentage(inspection);

        return Container(
          width: double.infinity,
          padding: EdgeInsets.all(12.w),
          decoration: BoxDecoration(
            color: white,
            borderRadius: BorderRadius.circular(12.r),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                vehicle.isEmpty ? 'Vehicle Inspection' : vehicle,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontFamily: 'Manrope',
                  fontSize: 17.sp,
                  fontWeight: FontWeight.w600,
                  color: black,
                ),
              ),

              SizedBox(height: 13.h),

              Row(
                children: [
                  Expanded(
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(10.r),
                      child: LinearProgressIndicator(
                        value: progress,
                        minHeight: 9.h,
                        backgroundColor: green,
                        valueColor: const AlwaysStoppedAnimation<Color>(
                          progressDarkGreen,
                        ),
                      ),
                    ),
                  ),

                  SizedBox(width: 8.w),

                  Text(
                    '${(progress * 100).round()}%',
                    style: TextStyle(
                      fontSize: 12.sp,
                      fontWeight: FontWeight.w600,
                      color: black,
                    ),
                  ),
                ],
              ),

              SizedBox(height: 10.h),

              GestureDetector(
                // Continue opens the selected existing draft.
                onTap: () {
                  _showInspectionMessage(inspection);
                },
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'Continue',
                      style: TextStyle(
                        fontFamily: 'Source Code Pro',
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w600,
                        color: black,
                      ),
                    ),

                    SizedBox(width: 5.w),

                    Container(
                      width: 20.w,
                      height: 20.h,
                      decoration: const BoxDecoration(
                        color: green,
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.chevron_right,
                        size: 17.sp,
                        color: black,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  // =========================================================
  // STATISTICS CARD
  // =========================================================

  Widget _buildStatCard({
    required String title,
    required String value,
    Color? titleColor,
  }) {
    return Container(
      height: 81.h,
      padding: EdgeInsets.all(12.w),
      decoration: BoxDecoration(
        color: white,
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              fontFamily: 'Manrope',
              fontSize: 14.sp,
              fontWeight: FontWeight.w600,
              color: titleColor ?? lightGrayText,
            ),
          ),

          const Spacer(),

          Text(
            value,
            style: TextStyle(
              fontFamily: 'Manrope',
              fontSize: 15.sp,
              fontWeight: FontWeight.w500,
              color: black,
            ),
          ),
        ],
      ),
    );
  }

  // =========================================================
  // INSPECTION CARD
  // =========================================================

  Widget _buildInspectionCard({
    required String title,
    required String vehicle,
    required String status,
    required Map<String, dynamic> inspection,
  }) {
    return Container(
      width: double.infinity,
      height: 105.h,
      padding: EdgeInsets.all(8.w),
      decoration: BoxDecoration(
        color: white,
        borderRadius: BorderRadius.circular(18.r),
      ),
      child: Row(
        children: [
          _buildVehicleImage(),

          SizedBox(width: 12.w),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontFamily: 'Manrope',
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w400,
                    color: lightGrayText,
                  ),
                ),

                Text(
                  vehicle.isEmpty ? 'Vehicle Inspection' : vehicle,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontFamily: 'Manrope',
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w600,
                    color: black,
                  ),
                ),

                GestureDetector(
                  // Open this exact draft for updating.
                  onTap: () {
                    _showInspectionMessage(inspection);
                  },
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        'See',
                        style: TextStyle(
                          fontFamily: 'Manrope',
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w600,
                          color: black,
                        ),
                      ),

                      SizedBox(width: 5.w),

                      Container(
                        width: 20.w,
                        height: 20.h,
                        decoration: const BoxDecoration(
                          color: green,
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          Icons.chevron_right,
                          size: 17.sp,
                          color: black,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // =========================================================
  // VEHICLE IMAGE
  // =========================================================

  Widget _buildVehicleImage() {
    return Container(
      width: 80.w,
      height: 80.h,
      decoration: BoxDecoration(
        color: imageBackground,
        borderRadius: BorderRadius.circular(8.r),
      ),
      clipBehavior: Clip.antiAlias,
      child: Image.asset(
        'assets/images/vehicle.png',
        fit: BoxFit.contain,
        errorBuilder: (context, error, stackTrace) {
          return Icon(Icons.directions_car, size: 40.sp, color: Colors.grey);
        },
      ),
    );
  }

  // =========================================================
  // REPORT STATUS CHIP
  // =========================================================

  Widget _statusChip(String status) {
    Color color;

    switch (status.toLowerCase()) {
      case 'passed':
        color = Colors.green;
        break;

      case 'failed':
        color = Colors.red;
        break;

      default:
        color = Colors.orange;
    }

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 7.w, vertical: 3.h),
      decoration: BoxDecoration(
        color: color.withOpacity(0.12),
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Text(
        status,
        style: TextStyle(
          fontSize: 10.sp,
          color: color,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  // =========================================================
  // REPORTS CONTENT
  // =========================================================

  Widget _buildReportsContent() {
    return _ReportsContent(
      draftsFuture: _draftsFuture,
      completedFuture: _completedFuture,
      customerName: _customerName,
      vehicleName: _vehicleName,
      inspectionTitle: _inspectionTitle,
      inspectionStatus: _inspectionStatus,
      onRefresh: _refreshInspections,
      buildVehicleImage: _buildVehicleImage,
      statusChip: _statusChip,
      onSee: _showInspectionMessage,
    );
  }

  // =========================================================
  // EMPTY STATE
  // =========================================================

  Widget _buildEmpty(String message) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(22.w),
      decoration: BoxDecoration(
        color: white,
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Center(
        child: Text(
          message,
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 13.sp, color: grayText),
        ),
      ),
    );
  }

  // =========================================================
  // ERROR STATE
  // =========================================================

  Widget _buildError(String message, VoidCallback retry) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: white,
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Column(
        children: [
          Text(
            'Unable to load inspections',
            style: TextStyle(
              fontSize: 14.sp,
              fontWeight: FontWeight.w600,
              color: Colors.red,
            ),
          ),

          SizedBox(height: 5.h),

          Text(
            message,
            maxLines: 3,
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 11.sp, color: grayText),
          ),

          TextButton(onPressed: retry, child: const Text('Retry')),
        ],
      ),
    );
  }

  // =========================================================
  // BOTTOM NAVIGATION
  // =========================================================

  Widget _buildBottomNavigation() {
    return Positioned(
      left: 10.w,
      bottom: 10.h,
      child: Container(
        width: 198.w,
        height: 58.h,
        decoration: BoxDecoration(
          color: white,
          borderRadius: BorderRadius.circular(34.r),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.06),
              blurRadius: 10.r,
              offset: Offset(0, 3.h),
            ),
          ],
        ),
        child: Row(
          children: [
            Expanded(
              child: _buildNavItem(
                index: 0,
                label: 'Home',
                icon: Icons.home_outlined,
              ),
            ),

            Expanded(
              child: _buildNavItem(
                index: 1,
                label: 'Reports',
                icon: Icons.content_paste_outlined,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNavItem({
    required int index,
    required String label,
    required IconData icon,
  }) {
    final selected = selectedBottomIndex == index;

    return GestureDetector(
      onTap: () {
        setState(() {
          selectedBottomIndex = index;
        });
      },
      child: Container(
        height: 50.h,
        margin: EdgeInsets.all(4.w),
        decoration: BoxDecoration(
          color: selected ? selectedHome : Colors.transparent,
          borderRadius: BorderRadius.circular(35.r),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 21.sp,
              color: selected ? const Color(0xFF4D8C00) : lightGrayText,
            ),

            SizedBox(height: 2.h),

            Text(
              label,
              style: TextStyle(
                fontFamily: 'Manrope',
                fontSize: 12.sp,
                fontWeight: FontWeight.w600,
                color: selected ? const Color(0xFF4D8C00) : lightGrayText,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // =========================================================
  // FLOATING ADD BUTTON
  // =========================================================

  Widget _buildFloatingButton() {
    return Positioned(
      right: 10.w,
      bottom: 10.h,
      child: GestureDetector(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => SelectCustomerScreen()),
          );
        },
        child: Container(
          width: 58.w,
          height: 58.h,
          decoration: BoxDecoration(
            color: green,
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.10),
                blurRadius: 8.r,
                offset: Offset(0, 3.h),
              ),
            ],
          ),
          child: Icon(Icons.add, color: black, size: 32.sp),
        ),
      ),
    );
  }
}

// =========================================================
// REPORTS WIDGET - SAME FILE
// =========================================================

class _ReportsContent extends StatefulWidget {
  final Future<List<Map<String, dynamic>>> draftsFuture;
  final Future<List<Map<String, dynamic>>> completedFuture;

  final String Function(Map<String, dynamic>) customerName;
  final String Function(Map<String, dynamic>) vehicleName;
  final String Function(Map<String, dynamic>) inspectionTitle;
  final String Function(Map<String, dynamic>) inspectionStatus;

  final VoidCallback onRefresh;
  final Widget Function() buildVehicleImage;
  final Widget Function(String) statusChip;
  final void Function(Map<String, dynamic>) onSee;

  const _ReportsContent({
    required this.draftsFuture,
    required this.completedFuture,
    required this.customerName,
    required this.vehicleName,
    required this.inspectionTitle,
    required this.inspectionStatus,
    required this.onRefresh,
    required this.buildVehicleImage,
    required this.statusChip,
    required this.onSee,
  });

  @override
  State<_ReportsContent> createState() => _ReportsContentState();
}

class _ReportsContentState extends State<_ReportsContent> {
  final TextEditingController searchController = TextEditingController();

  String selectedFilter = 'All';

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      padding: EdgeInsets.only(left: 8.w, right: 8.w, top: 58.h, bottom: 100.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Image.asset(
                'assets/images/Layer_1.png',
                width: 89.w,
                height: 24.h,
                fit: BoxFit.contain,
              ),

              IconButton(
                onPressed: widget.onRefresh,
                icon: const Icon(Icons.refresh),
              ),
            ],
          ),

          SizedBox(height: 25.h),

          // =================================================
          // SEARCH REPORTS
          // =================================================
          Container(
            width: double.infinity,
            height: 48.h,
            padding: EdgeInsets.symmetric(horizontal: 16.w),
            decoration: BoxDecoration(
              color: const Color(0xFFE8E8E8),
              borderRadius: BorderRadius.circular(32.r),
            ),
            child: TextField(
              controller: searchController,
              onChanged: (_) => setState(() {}),
              textAlignVertical: TextAlignVertical.center,
              style: TextStyle(fontFamily: 'Manrope', fontSize: 12.sp),
              decoration: InputDecoration(
                hintText: 'Search reports...',
                hintStyle: TextStyle(
                  fontFamily: 'Manrope',
                  fontSize: 12.sp,
                  color: const Color(0xFF808080),
                ),
                border: InputBorder.none,
                isCollapsed: true,
                suffixIcon: searchController.text.isEmpty
                    ? null
                    : IconButton(
                        icon: const Icon(Icons.clear),
                        onPressed: () {
                          searchController.clear();
                          setState(() {});
                        },
                      ),
              ),
            ),
          ),

          SizedBox(height: 20.h),

          // =================================================
          // FILTER BUTTONS
          // =================================================
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                for (final filter in [
                  'All',
                  'Pending',
                  'Passed',
                  'Failed',
                ]) ...[_buildFilterButton(filter), SizedBox(width: 9.w)],
              ],
            ),
          ),

          SizedBox(height: 18.h),

          // =================================================
          // FETCH DRAFT + COMPLETED REPORTS
          // =================================================
          FutureBuilder<List<List<Map<String, dynamic>>>>(
            future: Future.wait([widget.draftsFuture, widget.completedFuture]),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Padding(
                  padding: EdgeInsets.all(30),
                  child: Center(child: CircularProgressIndicator()),
                );
              }

              if (snapshot.hasError) {
                return _buildError(snapshot.error.toString());
              }

              final drafts = snapshot.data?[0] ?? [];
              final completed = snapshot.data?[1] ?? [];

              final all = <Map<String, dynamic>>[...drafts, ...completed];

              final filtered = all.where((inspection) {
                final status = widget.inspectionStatus(inspection);

                if (selectedFilter != 'All' && status != selectedFilter) {
                  return false;
                }

                final query = searchController.text.trim().toLowerCase();

                if (query.isEmpty) {
                  return true;
                }

                final title = widget.inspectionTitle(inspection).toLowerCase();

                final vehicle = widget.vehicleName(inspection).toLowerCase();

                final customer = widget.customerName(inspection).toLowerCase();

                final number = (inspection['inspection_no'] ?? '')
                    .toString()
                    .toLowerCase();

                return title.contains(query) ||
                    vehicle.contains(query) ||
                    customer.contains(query) ||
                    number.contains(query);
              }).toList();

              if (filtered.isEmpty) {
                return Container(
                  width: double.infinity,
                  padding: EdgeInsets.all(24.w),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                  child: Text(
                    all.isEmpty
                        ? 'No reports found.'
                        : 'No reports match your search or filter.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 13.sp,
                      color: const Color(0xFF808080),
                    ),
                  ),
                );
              }

              return Column(
                children: [
                  for (int i = 0; i < filtered.length; i++) ...[
                    _buildReportCard(filtered[i]),
                    if (i != filtered.length - 1) SizedBox(height: 9.h),
                  ],
                ],
              );
            },
          ),
        ],
      ),
    );
  }

  // =========================================================
  // REPORT FILTER BUTTON
  // =========================================================

  Widget _buildFilterButton(String title) {
    final selected = selectedFilter == title;

    return GestureDetector(
      onTap: () {
        setState(() {
          selectedFilter = title;
        });
      },
      child: Container(
        width: 77.w,
        height: 39.h,
        decoration: BoxDecoration(
          color: selected ? const Color(0xFFE4FFBF) : const Color(0xFFE8E8E8),
          borderRadius: BorderRadius.circular(24.r),
        ),
        alignment: Alignment.center,
        child: Text(
          title,
          style: TextStyle(
            fontFamily: 'Manrope',
            fontSize: 12.sp,
            color: Colors.black,
          ),
        ),
      ),
    );
  }

  // =========================================================
  // REPORT CARD
  // =========================================================

  Widget _buildReportCard(Map<String, dynamic> inspection) {
    final title = widget.inspectionTitle(inspection);
    final vehicle = widget.vehicleName(inspection);
    final status = widget.inspectionStatus(inspection);

    final number = inspection['inspection_no']?.toString() ?? '';

    return Container(
      width: double.infinity,
      height: 110.h,
      padding: EdgeInsets.all(8.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15.r),
      ),
      child: Row(
        children: [
          widget.buildVehicleImage(),

          SizedBox(width: 11.w),

          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  number.isEmpty ? title : '$number | $title',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontFamily: 'Manrope',
                    fontSize: 12.sp,
                    color: const Color(0xFF808080),
                  ),
                ),

                Text(
                  vehicle.isEmpty ? 'Vehicle Inspection' : vehicle,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontFamily: 'Manrope',
                    fontSize: 13.sp,
                    fontWeight: FontWeight.w600,
                    color: Colors.black,
                  ),
                ),

                Row(
                  children: [
                    widget.statusChip(status),

                    const Spacer(),

                    GestureDetector(
                      // Open the selected inspection.
                      onTap: () {
                        widget.onSee(inspection);
                      },
                      child: Row(
                        children: [
                          Text(
                            'See',
                            style: TextStyle(
                              fontSize: 12.sp,
                              color: Colors.black,
                            ),
                          ),

                          SizedBox(width: 4.w),

                          Container(
                            width: 14.w,
                            height: 14.h,
                            decoration: const BoxDecoration(
                              color: Color(0xFF93FF26),
                              shape: BoxShape.circle,
                            ),
                            child: Icon(
                              Icons.chevron_right,
                              size: 12.sp,
                              color: Colors.black,
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
    );
  }

  // =========================================================
  // REPORT ERROR
  // =========================================================

  Widget _buildError(String message) {
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Column(
        children: [
          const Text(
            'Unable to load reports',
            style: TextStyle(color: Colors.red),
          ),

          SizedBox(height: 8.h),

          Text(
            message,
            maxLines: 3,
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 11.sp, color: Colors.grey),
          ),

          TextButton(onPressed: widget.onRefresh, child: const Text('Retry')),
        ],
      ),
    );
  }
}
