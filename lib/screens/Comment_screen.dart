import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CommentScreen extends StatefulWidget {
  final String initialComment;
  final ValueChanged<String>? onCommentChanged;

  const CommentScreen({
    super.key,
    this.initialComment = '',
    this.onCommentChanged,
  });

  @override
  State<CommentScreen> createState() => _CommentScreenState();
}

class _CommentScreenState extends State<CommentScreen> {
  late final TextEditingController _commentController;

  @override
  void initState() {
    super.initState();

    _commentController = TextEditingController(text: widget.initialComment);

    _commentController.addListener(_onCommentChanged);
  }

  void _onCommentChanged() {
    widget.onCommentChanged?.call(_commentController.text);
  }

  @override
  void dispose() {
    _commentController.removeListener(_onCommentChanged);
    _commentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 10.h),
      height: 48.h,
      width: 372.w,
      decoration: BoxDecoration(
        color: const Color(0xFFF5F5F5),
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: TextField(
        controller: _commentController,
        maxLines: 1,
        textInputAction: TextInputAction.done,
        style: TextStyle(
          fontFamily: 'Manrope',
          fontWeight: FontWeight.w500,
          fontSize: 16.sp,
          color: const Color(0xFF222222),
        ),
        decoration: InputDecoration(
          hintText: 'Add comments',
          hintStyle: TextStyle(
            color: const Color(0xFF5C5C5C),
            fontWeight: FontWeight.w500,
            fontFamily: 'Manrope',
            fontSize: 14.sp,
          ),
          contentPadding: EdgeInsets.only(bottom: 8.h),
          isDense: true,
          border: const OutlineInputBorder(borderSide: BorderSide.none),
          enabledBorder: const OutlineInputBorder(borderSide: BorderSide.none),
          focusedBorder: const OutlineInputBorder(borderSide: BorderSide.none),
        ),
      ),
    );
  }
}
