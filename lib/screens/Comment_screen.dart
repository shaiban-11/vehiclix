import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CommentScreen extends StatefulWidget {
  const CommentScreen({super.key});

  @override
  State<CommentScreen> createState() => _CommentScreenState();
}

class _CommentScreenState extends State<CommentScreen> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(
        top: 10.h,
        right: 12.w,
        bottom: 10.h,
        left: 12.w,
      ),
      height: 48.h,
      width: 372.w,
      decoration: BoxDecoration(
        color: Color(0xFFF5F5F5),
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: TextField(
        style: TextStyle(
          fontFamily: 'Manrope',
          fontWeight: FontWeight.w500,
          fontSize: 16.sp,
          color: const Color(0xFF222222),
        ),
        decoration: InputDecoration(
          hintText: "Add comments",
          hintStyle: TextStyle(
            color: const Color(0xFF5C5C5C),
            fontWeight: FontWeight.w500,
            fontFamily: "Manrope",
            fontSize: 14.sp,
          ),
          contentPadding: EdgeInsets.only(top: 16.h),
          border: const OutlineInputBorder(borderSide: BorderSide.none),
        ),
      ),
    );
  }
}
