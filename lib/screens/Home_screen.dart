import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:rootysysproject/bloc/homestats/bloc/homestats_bloc.dart';
import 'package:rootysysproject/bloc/homestats/bloc/homestats_event.dart';
import 'package:rootysysproject/bloc/homestats/bloc/homestats_state.dart';

import 'package:rootysysproject/bloc/user/bloc/user_bloc.dart';
import 'package:rootysysproject/bloc/user/bloc/user_event.dart';
import 'package:rootysysproject/bloc/user/bloc/user_state.dart';

import 'package:rootysysproject/screens/Customer_screen.dart';
import 'package:rootysysproject/screens/Profile_screen.dart';
import 'package:rootysysproject/screens/reports_screen.dart';

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

  final List<Map<String, String>> inspections = [
    {
      'image': 'assets/images/vehicle.png',
      'title': 'Exterior Inspection | Rahul ck',
      'vehicle': 'Toyota Innova',
    },
    {
      'image': 'assets/images/vehicle.png',
      'title': 'Exterior Inspection | Rahul ck',
      'vehicle': 'Toyota Innova',
    },
    {
      'image': 'assets/images/vehicle.png',
      'title': 'Exterior Inspection | Rahul ck',
      'vehicle': 'Toyota Innova',
    },
    {
      'image': 'assets/images/vehicle.png',
      'title': 'Exterior Inspection | Rahul ck',
      'vehicle': 'Toyota Innova',
    },
  ];

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;

      // Fetch user details.
      context.read<UserBloc>().add(UserFetchRequested());

      // Fetch home statistics.
      context.read<HomeStatsBloc>().add(const HomeStatsFetchRequested());
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: background,
      body: Stack(
        children: [
          _buildMainContent(),
          _buildBottomNavigation(),
          _buildFloatingButton(),
        ],
      ),
    );
  }

  Widget _buildMainContent() {
    if (selectedBottomIndex == 1) return ReportsScreen();

    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      padding: EdgeInsets.only(left: 8.w, right: 8.w, top: 8.h, bottom: 95.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 50.h),

          // Header: logo, user details and profile icon.
          SizedBox(
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
                                style: TextStyle(
                                  fontFamily: 'Manrope',
                                  fontSize: 12.sp,
                                  color: grayText,
                                ),
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
                              debugPrint('USER API ERROR: ${state.message}');

                              return Text(
                                'Error: ${state.message}',
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  fontFamily: 'Manrope',
                                  fontSize: 11.sp,
                                  color: Colors.red,
                                ),
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
                    onTap: () {
                      showGeneralDialog(
                        context: context,
                        barrierDismissible: true,
                        barrierLabel: 'Profile',
                        barrierColor: Colors.black.withOpacity(0.15),
                        transitionDuration: const Duration(milliseconds: 200),
                        pageBuilder: (context, animation, secondaryAnimation) {
                          return ProfileScreen();
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

          Text(
            'Continue Inspection',
            style: TextStyle(
              fontFamily: 'Manrope',
              fontSize: 16.sp,
              fontWeight: FontWeight.w500,
              color: grayText,
              height: 1,
            ),
          ),
          SizedBox(height: 10.h),

          Container(
            width: double.infinity,
            height: 116.h,
            padding: EdgeInsets.all(12.w),
            decoration: BoxDecoration(
              color: white,
              borderRadius: BorderRadius.circular(12.r),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Toyota Innova',
                  style: TextStyle(
                    fontFamily: 'Manrope',
                    fontSize: 17.sp,
                    fontWeight: FontWeight.w600,
                    color: black,
                    height: 1,
                  ),
                ),
                SizedBox(height: 13.h),
                SizedBox(
                  width: double.infinity,
                  height: 19.h,
                  child: Row(
                    children: [
                      Expanded(
                        child: Stack(
                          children: [
                            Container(
                              height: 9.h,
                              margin: EdgeInsets.only(top: 5.h),
                              decoration: BoxDecoration(
                                color: green,
                                borderRadius: BorderRadius.circular(10.r),
                              ),
                            ),
                            FractionallySizedBox(
                              widthFactor: 0.25,
                              child: Container(
                                height: 9.h,
                                margin: EdgeInsets.only(top: 5.h),
                                decoration: BoxDecoration(
                                  color: progressDarkGreen,
                                  borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(10.r),
                                    bottomLeft: Radius.circular(10.r),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(width: 8.w),
                      Text(
                        '30%',
                        style: TextStyle(
                          fontFamily: 'Manrope',
                          fontSize: 12.sp,
                          fontWeight: FontWeight.w600,
                          color: black,
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 10.h),
                GestureDetector(
                  onTap: () {},
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
                          height: 1,
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

          SizedBox(height: 18.h),

          // HOME STATISTICS API
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
                debugPrint('HOME STATS API ERROR: ${state.message}');
              }

              return Row(
                children: [
                  Expanded(
                    child: _buildStatCard(
                      title: 'Today',
                      value: today,
                      valueColor: black,
                    ),
                  ),
                  SizedBox(width: 8.w),
                  Expanded(
                    child: _buildStatCard(
                      title: 'Completed',
                      value: completed,
                      valueColor: black,
                      titleColor: const Color(0xFF278500),
                    ),
                  ),
                  SizedBox(width: 8.w),
                  Expanded(
                    child: _buildStatCard(
                      title: 'Failed',
                      value: failed,
                      valueColor: black,
                      titleColor: const Color(0xFFFF2D2D),
                    ),
                  ),
                ],
              );
            },
          ),

          SizedBox(height: 25.h),

          Text(
            'Inspections',
            style: TextStyle(
              fontFamily: 'Manrope',
              fontSize: 16.sp,
              fontWeight: FontWeight.w500,
              color: grayText,
              height: 1,
            ),
          ),
          SizedBox(height: 15.h),

          Column(
            children: [
              for (int index = 0; index < inspections.length; index++) ...[
                _buildInspectionCard(
                  image: inspections[index]['image']!,
                  title: inspections[index]['title']!,
                  vehicle: inspections[index]['vehicle']!,
                ),
                if (index != inspections.length - 1) SizedBox(height: 9.h),
              ],
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatCard({
    required String title,
    required String value,
    required Color valueColor,
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
              height: 1,
            ),
          ),
          const Spacer(),
          Text(
            value,
            style: TextStyle(
              fontFamily: 'Manrope',
              fontSize: 15.sp,
              fontWeight: FontWeight.w500,
              color: valueColor,
              height: 1,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInspectionCard({
    required String image,
    required String title,
    required String vehicle,
  }) {
    return Container(
      width: double.infinity,
      height: 96.h,
      padding: EdgeInsets.all(8.w),
      decoration: BoxDecoration(
        color: white,
        borderRadius: BorderRadius.circular(15.r),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            width: 80.w,
            height: 80.h,
            decoration: BoxDecoration(
              color: imageBackground,
              borderRadius: BorderRadius.circular(8.r),
            ),
            clipBehavior: Clip.antiAlias,
            child: Image.asset(
              image,
              fit: BoxFit.contain,
              errorBuilder: (context, error, stackTrace) {
                return Icon(
                  Icons.directions_car,
                  size: 40.sp,
                  color: Colors.grey,
                );
              },
            ),
          ),
          SizedBox(width: 11.w),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
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
                    height: 1,
                  ),
                ),
                Text(
                  vehicle,
                  style: TextStyle(
                    fontFamily: 'Manrope',
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w600,
                    color: black,
                    height: 1,
                  ),
                ),
                GestureDetector(
                  onTap: () {},
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
          ),
        ],
      ),
    );
  }

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
              child: GestureDetector(
                onTap: () {
                  setState(() => selectedBottomIndex = 0);
                },
                child: Container(
                  height: 50.h,
                  margin: EdgeInsets.only(left: 4.w, top: 4.h, bottom: 4.h),
                  decoration: BoxDecoration(
                    color: selectedBottomIndex == 0
                        ? selectedHome
                        : Colors.transparent,
                    borderRadius: BorderRadius.circular(35.r),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.home_outlined,
                        size: 21.sp,
                        color: selectedBottomIndex == 0
                            ? const Color(0xFF4D8C00)
                            : lightGrayText,
                      ),
                      SizedBox(height: 2.h),
                      Text(
                        'Home',
                        style: TextStyle(
                          fontFamily: 'Manrope',
                          fontSize: 12.sp,
                          fontWeight: FontWeight.w600,
                          color: selectedBottomIndex == 0
                              ? const Color(0xFF4D8C00)
                              : lightGrayText,
                          height: 1,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Expanded(
              child: GestureDetector(
                onTap: () {
                  setState(() => selectedBottomIndex = 1);
                },
                child: Container(
                  height: 50.h,
                  margin: EdgeInsets.only(right: 4.w, top: 4.h, bottom: 4.h),
                  decoration: BoxDecoration(
                    color: selectedBottomIndex == 1
                        ? selectedHome
                        : Colors.transparent,
                    borderRadius: BorderRadius.circular(35.r),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.content_paste_outlined,
                        size: 20.sp,
                        color: selectedBottomIndex == 1
                            ? const Color(0xFF4D8C00)
                            : lightGrayText,
                      ),
                      SizedBox(height: 2.h),
                      Text(
                        'Reports',
                        style: TextStyle(
                          fontFamily: 'Manrope',
                          fontSize: 12.sp,
                          fontWeight: FontWeight.w600,
                          color: selectedBottomIndex == 1
                              ? const Color(0xFF4D8C00)
                              : lightGrayText,
                          height: 1,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

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
