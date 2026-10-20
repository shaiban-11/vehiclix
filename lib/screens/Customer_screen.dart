import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:rootysysproject/screens/CreatenewCutomer_screen.dart';
import 'package:rootysysproject/screens/Customer_profile.dart';

class SelectCustomerScreen extends StatelessWidget {
  const SelectCustomerScreen({super.key});

  static const Color black = Color(0xFF000000);
  static const Color dark = Color(0xFF111111);
  static const Color white = Color(0xFFFFFFFF);

  // R container color from Figma: #93FF2626
  static const Color rContainerColor = Color(0x2693FF26);

  // Company text: #0000007D
  static const Color companyTextColor = Color(0x7D000000);

  // Right arrow container
  static const Color arrowContainerColor = Color(0xFFF0F0F0);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F7F7),
      body: SafeArea(
        child: Column(
          children: [
            // =====================================================
            // HEADER
            // =====================================================
            Padding(
              padding: EdgeInsets.only(left: 16.w, right: 16.w, top: 42.h),
              child: Row(
                children: [
                  // LEFT ARROW CONTAINER
                  Container(
                    width: 28.w,
                    height: 28.h,
                    decoration: BoxDecoration(
                      color: white,
                      borderRadius: BorderRadius.circular(16.r),
                    ),
                    child: Center(
                      child: Icon(Icons.arrow_back, color: black, size: 24.sp),
                    ),
                  ),

                  SizedBox(width: 8.w),

                  // SELECT CUSTOMER
                  Text(
                    'Select Customer',
                    style: TextStyle(
                      fontFamily: 'Manrope',
                      fontSize: 18.sp,
                      fontWeight: FontWeight.w700,
                      color: black,
                      height: 1.0,
                    ),
                  ),
                ],
              ),
            ),

            // =====================================================
            // SEARCH TEXTFIELD
            // Width: 370
            // Height: 48
            // Top: 145
            // Left: 16
            // Radius: 32
            // Padding: 10, 10, 10, 16
            // =====================================================
            Padding(
              padding: EdgeInsets.only(top: 37.h, left: 16.w, right: 16.w),
              child: SizedBox(
                width: 370.w,
                height: 48.h,
                child: TextField(
                  style: TextStyle(
                    fontFamily: 'Manrope',
                    fontSize: 14.27.sp,
                    fontWeight: FontWeight.w500,
                    color: white,
                  ),
                  decoration: InputDecoration(
                    filled: true,

                    // Light gray search background
                    fillColor: const Color(0xFFE9E9E9),

                    hintText: 'Search Customer...',

                    hintStyle: TextStyle(
                      fontFamily: 'Manrope',
                      fontSize: 14.27.sp,
                      fontWeight: FontWeight.w500,
                      color: const Color(0xFF888888),
                      height: 1.0,
                    ),

                    prefixIcon: Icon(Icons.search, size: 24.sp, color: black),

                    contentPadding: EdgeInsets.only(
                      top: 10.h,
                      right: 10.w,
                      bottom: 10.h,
                      left: 16.w,
                    ),

                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(32.r),
                      borderSide: BorderSide.none,
                    ),

                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(32.r),
                      borderSide: BorderSide.none,
                    ),

                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(32.r),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
              ),
            ),

            // =====================================================
            // CREATE NEW CUSTOMER
            // Width: 370
            // Height: 54
            // Radius: 11
            // Padding: 8
            // Gap: 10
            // =====================================================
            Padding(
              padding: EdgeInsets.only(top: 20.h, left: 16.w, right: 16.w),
              child: GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => CreateNewCustomerScreen(),
                    ),
                  );
                },
                child: Container(
                  width: 370.w,
                  height: 54.h,
                  padding: EdgeInsets.all(8.w),
                  decoration: BoxDecoration(
                    color: white,
                    borderRadius: BorderRadius.circular(11.r),
                  ),
                  child: Row(
                    children: [
                      // ADD CONTAINER
                      Container(
                        width: 38.w,
                        height: 38.h,
                        decoration: BoxDecoration(
                          color: const Color(0xFF7FFF00),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(Icons.add, color: black, size: 25.sp),
                      ),

                      SizedBox(width: 10.w),

                      // CREATE NEW CUSTOMER TEXT
                      Text(
                        'Create New Customer',
                        style: TextStyle(
                          fontFamily: 'Manrope',
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w600,
                          color: black,
                          height: 1.0,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),

            // =====================================================
            // CUSTOMER CARDS
            // =====================================================
            SizedBox(height: 10.h),

            _customerCard(context),
            SizedBox(height: 10.h),

            _customerCard(context),
            SizedBox(height: 10.h),

            _customerCard(context),
            SizedBox(height: 10.h),

            _customerCard(context),
          ],
        ),
      ),
    );
  }

  // =============================================================
  // CUSTOMER CARD
  // Width: 370
  // Height: 56
  // Radius: 11
  // Padding: 8
  // Gap: 10
  // =============================================================
  Widget _customerCard(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => CustomerProfileScreen()),
        );
      },
      child: Container(
        width: 370.w,
        height: 56.h,
        padding: EdgeInsets.all(8.w),
        decoration: BoxDecoration(
          color: white,
          borderRadius: BorderRadius.circular(11.r),
        ),
        child: Row(
          children: [
            Container(
              width: 38.w,
              height: 38.h,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: rContainerColor,
                borderRadius: BorderRadius.circular(5.r),
              ),
              child: Text(
                'R',
                style: TextStyle(
                  fontFamily: 'Manrope',
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w600,
                  color: black,
                  height: 1.0,
                ),
              ),
            ),

            SizedBox(width: 10.w),

            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // RAHUL CK
                  Text(
                    'Rahul ck',
                    style: TextStyle(
                      fontFamily: 'Manrope',
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w600,
                      color: black,
                      height: 1.0,
                    ),
                  ),

                  SizedBox(height: 5.h),

                  // COMPANY
                  Text(
                    'Company',
                    style: TextStyle(
                      fontFamily: 'Manrope',
                      fontSize: 13.sp,
                      fontWeight: FontWeight.w400,
                      color: companyTextColor,
                      height: 1.0,
                    ),
                  ),
                ],
              ),
            ),

            // =====================================================
            // RIGHT ARROW CONTAINER
            // Width: 24
            // Height: 24
            // Radius: 28.8
            // Color: #F0F0F0
            // =====================================================
            Container(
              width: 24.w,
              height: 24.h,
              decoration: BoxDecoration(
                color: arrowContainerColor,
                borderRadius: BorderRadius.circular(28.8.r),
              ),
              child: Center(
                child: Icon(Icons.chevron_right, size: 18.sp, color: black),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
