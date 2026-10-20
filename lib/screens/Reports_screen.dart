import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:rootysysproject/screens/Profile_screen.dart';

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

  String selectedFilter = 'All';

  bool isProfilePopupOpen = false;

  final List<Map<String, String>> reports = [
    {
      'image': 'assets/images/vehicle.png',
      'title': 'Exterior Inspection | Rahul ck',
      'vehicle': 'Toyota Innova',
      'status': 'Pending',
    },
    {
      'image': 'assets/images/vehicle.png',
      'title': 'Exterior Inspection | Rahul ck',
      'vehicle': 'Toyota Innova',
      'status': 'Passed',
    },
    {
      'image': 'assets/images/vehicle.png',
      'title': 'Exterior Inspection | Rahul ck',
      'vehicle': 'Toyota Innova',
      'status': 'Failed',
    },
  ];

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // ---------------------------------------------------------
        // MAIN REPORT SCREEN
        // ---------------------------------------------------------
        SingleChildScrollView(
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

              SizedBox(
                height: 34.h,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Image.asset(
                      'assets/images/Layer_1.png',
                      width: 89.w,
                      height: 24.h,
                      fit: BoxFit.contain,
                    ),

                    // PROFILE BUTTON
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
                          "assets/images/Frame 15.png",
                          height: 14.h,
                          width: 14.w,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              SizedBox(height: 30.h),

              // ---------------------------------------------------------
              // SEARCH
              // ---------------------------------------------------------
              Container(
                width: 370.w,
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
                    isCollapsed: true,
                    contentPadding: EdgeInsets.symmetric(
                      horizontal: 0.w,
                      vertical: 4.h,
                    ),
                  ),
                ),
              ),

              SizedBox(height: 25.h),

              // ---------------------------------------------------------
              // FILTER BUTTONS
              // ---------------------------------------------------------
              Row(
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

              SizedBox(height: 18.h),

              // ---------------------------------------------------------
              // REPORT CARDS
              // ---------------------------------------------------------
              ..._getFilteredReports().map(
                (report) => Padding(
                  padding: EdgeInsets.only(bottom: 9.h),
                  child: _buildReportCard(
                    image: report['image']!,
                    title: report['title']!,
                    vehicle: report['vehicle']!,
                  ),
                ),
              ),

              SizedBox(height: 300.h),
            ],
          ),
        ),

        // ---------------------------------------------------------
        // DARK/LIGHT OVERLAY
        // ---------------------------------------------------------

        // ---------------------------------------------------------
        // PROFILE POPUP
        // ---------------------------------------------------------
      ],
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
          color: isSelected ? const Color(0xFFE8E8E8) : const Color(0xFFE8E8E8),
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
  // FILTER REPORTS
  // =========================================================

  List<Map<String, String>> _getFilteredReports() {
    List<Map<String, String>> filteredReports = reports;

    if (selectedFilter != 'All') {
      filteredReports = filteredReports
          .where((report) => report['status'] == selectedFilter)
          .toList();
    }

    final String searchText = searchController.text.trim().toLowerCase();

    if (searchText.isNotEmpty) {
      filteredReports = filteredReports
          .where(
            (report) =>
                report['title']!.toLowerCase().contains(searchText) ||
                report['vehicle']!.toLowerCase().contains(searchText),
          )
          .toList();
    }

    return filteredReports;
  }

  // =========================================================
  // REPORT CARD
  // =========================================================

  Widget _buildReportCard({
    required String image,
    required String title,
    required String vehicle,
  }) {
    return Container(
      width: 370.w,
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
              color: const Color(0xFFF0F0F0),
              borderRadius: BorderRadius.circular(8.r),
            ),
            clipBehavior: Clip.antiAlias,
            child: Image.asset(
              image,
              fit: BoxFit.contain,
              errorBuilder: (context, error, stackTrace) {
                return Icon(
                  Icons.directions_car,
                  size: 35.sp,
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
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w400,
                    color: const Color(0xFF808080),
                    height: 1,
                  ),
                ),

                Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: Text(
                    vehicle,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontFamily: 'Manrope',
                      fontSize: 13.sp,
                      fontWeight: FontWeight.w600,
                      color: black,
                      height: 1,
                    ),
                  ),
                ),

                GestureDetector(
                  onTap: () {
                    // TODO: Open report details
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
          ),
        ],
      ),
    );
  }
}
