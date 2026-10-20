import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:rootysysproject/bloc/user/bloc/user_bloc.dart';
import 'package:rootysysproject/bloc/user/bloc/user_event.dart';
import 'package:rootysysproject/bloc/user/bloc/user_state.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  static const Color black = Color(0xFF000000);
  static const Color grayText = Color(0xFF808080);
  static const Color white = Color(0xFFFFFFFF);

  @override
  void initState() {
    super.initState();

    // Fetch the logged-in user's details when ProfileScreen opens.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        context.read<UserBloc>().add(UserFetchRequested());
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: SafeArea(
        child: Align(
          alignment: Alignment.topCenter,
          child: Container(
            width: 400.w,
            height: 364.h,
            decoration: BoxDecoration(
              color: white,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20.r),
                topRight: Radius.circular(20.r),
              ),
            ),
            child: Stack(
              clipBehavior: Clip.none,
              children: [
                // Top background
                Container(
                  width: double.infinity,
                  height: 89.h,
                  decoration: BoxDecoration(
                    color: const Color(0xFFCCCCCC),
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(20.r),
                      topRight: Radius.circular(20.r),
                    ),
                  ),
                ),

                // Inspector label
                Positioned(
                  left: 10.w,
                  top: 10.h,
                  child: Container(
                    width: 83.w,
                    height: 33.h,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: white,
                      borderRadius: BorderRadius.circular(21.r),
                    ),
                    child: Text(
                      'Inspector',
                      style: TextStyle(
                        fontFamily: 'Manrope',
                        fontSize: 10.sp,
                        fontWeight: FontWeight.w400,
                        color: black,
                      ),
                    ),
                  ),
                ),

                // Close button
                Positioned(
                  right: 14.w,
                  top: 10.h,
                  child: GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: Container(
                      width: 32.w,
                      height: 32.h,
                      decoration: const BoxDecoration(
                        color: white,
                        shape: BoxShape.circle,
                      ),
                      child: Icon(Icons.close, size: 18.sp, color: black),
                    ),
                  ),
                ),

                // Profile image
                Positioned(
                  top: 49.h,
                  left: 0,
                  right: 0,
                  child: Center(
                    child: Container(
                      width: 100.w,
                      height: 100.h,
                      decoration: BoxDecoration(
                        color: white,
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: const Color(0xFFE5E5E5),
                          width: 0.5,
                        ),
                      ),
                      child: Center(
                        child: Icon(
                          Icons.person,
                          color: const Color(0xFF999999),
                          size: 80.sp,
                        ),
                      ),
                    ),
                  ),
                ),

                // User details from UserBloc
                Positioned(
                  top: 153.h,
                  left: 12.w,
                  right: 12.w,
                  child: BlocBuilder<UserBloc, UserState>(
                    builder: (context, state) {
                      if (state is UserSuccess) {
                        final user = state.user.data;

                        final name = user?.name?.trim();
                        final email = user?.email?.trim();

                        return Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              name != null && name.isNotEmpty ? name : 'User',
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontFamily: 'Manrope',
                                fontSize: 16.sp,
                                fontWeight: FontWeight.w500,
                                color: black,
                                height: 1.0,
                              ),
                            ),
                            SizedBox(height: 10.h),
                            Text(
                              email != null && email.isNotEmpty
                                  ? email
                                  : 'Email not available',
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontFamily: 'Manrope',
                                fontSize: 12.sp,
                                fontWeight: FontWeight.w500,
                                color: grayText,
                                height: 1.0,
                              ),
                            ),
                          ],
                        );
                      }

                      if (state is UserFailure) {
                        return Text(
                          'Unable to load user details',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontFamily: 'Manrope',
                            fontSize: 12.sp,
                            color: Colors.red,
                          ),
                        );
                      }

                      return const Center(
                        child: SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        ),
                      );
                    },
                  ),
                ),

                // Logout button
                Positioned(
                  top: 232.h,
                  left: 0,
                  right: 0,
                  child: Center(
                    child: GestureDetector(
                      onTap: () {
                        // Add logout logic here.
                      },
                      child: Container(
                        width: 63.w,
                        height: 33.h,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: const Color(0x14E90000),
                          borderRadius: BorderRadius.circular(21.r),
                        ),
                        child: Text(
                          'Log out',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontFamily: 'Manrope',
                            fontSize: 12.sp,
                            fontWeight: FontWeight.w500,
                            color: const Color(0xFFE90000),
                            height: 1.0,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
