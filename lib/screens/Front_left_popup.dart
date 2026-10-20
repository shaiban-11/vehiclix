import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class FrontLeftPopup extends StatefulWidget {
  final bool showBreakContainers;
  final bool showremark;
  final String tyreName;

  final VoidCallback? onSave;

  const FrontLeftPopup({
    super.key,
    required this.tyreName,
    this.onSave,
    required this.showBreakContainers,
    required this.showremark,
  });

  @override
  State<FrontLeftPopup> createState() => _FrontLeftPopupState();
}

class _FrontLeftPopupState extends State<FrontLeftPopup> {
  String selectedResult = 'Fail';

  final Set<String> selectedDefects = {};

  void _selectResult(String value) {
    setState(() {
      selectedResult = value;
    });
  }

  void _toggleDefect(String value) {
    setState(() {
      if (selectedDefects.contains(value)) {
        selectedDefects.remove(value);
      } else {
        selectedDefects.add(value);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 402.w,
      height: 508.h,
      decoration: BoxDecoration(
        color: const Color(0xFFFFFFFF),
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(28.r),
          topRight: Radius.circular(28.r),
        ),
      ),
      child: Column(
        children: [
          SizedBox(
            height: 80.h,
            child: Padding(
              padding: EdgeInsets.only(left: 12.w, right: 9.w, top: 16.h),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // FRONT LEFT
                  Padding(
                    padding: EdgeInsets.only(top: 14.h),
                    child: Text(
                      widget.tyreName,
                      style: TextStyle(
                        fontFamily: 'Manrope',
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w600,
                        height: 1.0,
                        color: const Color(0xFF000000),
                      ),
                    ),
                  ),

                  const Spacer(),

                  GestureDetector(
                    onTap: () {
                      widget.onSave?.call();
                      Navigator.pop(context);
                    },
                    child: Container(
                      width: 68.w,
                      height: 48.h,
                      decoration: BoxDecoration(
                        color: const Color(0xFF73F700),
                        borderRadius: BorderRadius.circular(42.46.r),
                      ),
                      alignment: Alignment.center,
                      child: Text(
                        'Save',
                        style: TextStyle(
                          fontFamily: 'Manrope',
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w500,
                          height: 1.0,
                          color: const Color(0xFF449400),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          Container(width: 370.w, height: 1.h, color: const Color(0xFFE8E8E8)),

          Expanded(
            child: SingleChildScrollView(
              physics: const NeverScrollableScrollPhysics(),
              child: Padding(
                padding: EdgeInsets.only(
                  left: 12.w,
                  right: 9.w,
                  top: 15.h,
                  bottom: 10.h,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // ==================================================
                    // TEST RESULT
                    // ==================================================
                    SizedBox(height: 5.h),
                    Text(
                      'Test result',
                      style: TextStyle(
                        fontFamily: 'Manrope',
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w500,
                        height: 1.0,
                        color: const Color(0x9E000000),
                      ),
                    ),

                    SizedBox(height: 10.h),

                    Row(
                      children: [
                        Expanded(
                          child: _ResultButton(
                            text: 'Fail',
                            type: ResultType.fail,
                            selected: selectedResult == 'Fail',
                            onTap: () => _selectResult('Fail'),
                          ),
                        ),

                        SizedBox(width: 8.w),

                        Expanded(
                          child: _ResultButton(
                            text: 'Pass',
                            type: ResultType.pass,
                            selected: selectedResult == 'Pass',
                            onTap: () => _selectResult('Pass'),
                          ),
                        ),
                      ],
                    ),

                    SizedBox(height: 8.h),

                    Row(
                      children: [
                        Expanded(
                          child: _ResultButton(
                            text: 'N/A',
                            type: ResultType.normal,
                            selected: selectedResult == 'N/A',
                            onTap: () => _selectResult('N/A'),
                          ),
                        ),

                        SizedBox(width: 8.w),

                        Expanded(
                          child: _ResultButton(
                            text: 'N/C',
                            type: ResultType.normal,
                            selected: selectedResult == 'N/C',
                            onTap: () => _selectResult('N/C'),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 26),
                    if (widget.showremark) ...[
                      Text(
                        "Remark",
                        style: TextStyle(
                          color: Color(0xFF222222),
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w500,
                          fontFamily: "Manrope",
                        ),
                      ),
                      SizedBox(height: 9.h),

                      Container(
                        margin: EdgeInsets.only(
                          top: 10.h,
                          right: 14.w,
                          bottom: 10.h,
                          left: 10.w,
                        ),
                        height: 57.h,
                        width: 370.w,
                        decoration: BoxDecoration(
                          color: const Color(0xFFF5F5F5),
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
                            hintText: "Comment",
                            hintStyle: TextStyle(
                              color: const Color(0xFF5C5C5C),
                              fontWeight: FontWeight.w500,
                              fontFamily: "Manrope",
                              fontSize: 14.sp,
                            ),
                            contentPadding: EdgeInsets.only(left: 10, top: 30),
                            border: OutlineInputBorder(
                              borderSide: BorderSide.none,
                            ),
                          ),
                        ),
                      ),
                    ],

                    SizedBox(height: 40.h),

                    if (!widget.showBreakContainers) ...[
                      if (!widget.showremark) ...[
                        Row(
                          children: [
                            Expanded(
                              child: _DefectButton(
                                text: 'Scratches',
                                selected: selectedDefects.contains('Scratches'),
                                onTap: () => _toggleDefect('Scratches'),
                              ),
                            ),

                            SizedBox(width: 10.w),

                            Expanded(
                              child: _DefectButton(
                                text: 'Bent',
                                selected: selectedDefects.contains('Bent'),
                                onTap: () => _toggleDefect('Bent'),
                              ),
                            ),
                          ],
                        ),

                        SizedBox(height: 10.h),

                        Row(
                          children: [
                            Expanded(
                              child: _DefectButton(
                                text: 'Cracks',
                                selected: selectedDefects.contains('Cracks'),
                                onTap: () => _toggleDefect('Cracks'),
                              ),
                            ),

                            SizedBox(width: 10.w),

                            Expanded(
                              child: _DefectButton(
                                text: 'Corrosion',
                                selected: selectedDefects.contains('Corrosion'),
                                onTap: () => _toggleDefect('Corrosion'),
                              ),
                            ),
                          ],
                        ),

                        SizedBox(height: 45.h),
                      ],

                      Text(
                        'Attach photo',
                        style: TextStyle(
                          fontFamily: 'Manrope',
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w500,
                          height: 1.0,
                          color: const Color(0x9E000000),
                        ),
                      ),

                      SizedBox(height: 10.h),

                      GestureDetector(
                        onTap: () {},
                        child: Container(
                          width: 139.w,
                          height: 39.h,
                          padding: EdgeInsets.symmetric(horizontal: 10.w),
                          decoration: BoxDecoration(
                            color: Colors.transparent,
                            border: Border.all(
                              color: const Color(0xFFD1D1D1),
                              width: 1.w,
                            ),
                            borderRadius: BorderRadius.circular(30.r),
                          ),
                          child: Row(
                            children: [
                              Icon(
                                Icons.camera_alt_outlined,
                                size: 18.sp,
                                color: const Color(0xFF222222),
                              ),

                              SizedBox(width: 5.w),

                              Flexible(
                                child: Text(
                                  'Attach photo',
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  softWrap: false,
                                  style: TextStyle(
                                    fontFamily: 'Manrope',
                                    fontSize: 14.sp,
                                    fontWeight: FontWeight.w500,
                                    height: 1.0,
                                    color: const Color(0xFF222222),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],

                    if (widget.showBreakContainers) ...[
                      BreakContainers(
                        titlefirst: "Break Type",
                        titlesecond: "Select break type",
                        showarrow: true,
                      ),
                      BreakContainers(
                        titlefirst: "Break pads",
                        titlesecond: "Select break type",
                        showarrow: false,
                      ),
                    ],
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

enum ResultType { fail, pass, normal }

class _ResultButton extends StatelessWidget {
  final String text;
  final ResultType type;
  final bool selected;
  final VoidCallback onTap;

  const _ResultButton({
    required this.text,
    required this.type,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    Color textColor;

    switch (type) {
      case ResultType.fail:
        textColor = const Color(0xFFE90000);
        break;

      case ResultType.pass:
        textColor = const Color(0xFF449400);
        break;

      case ResultType.normal:
        textColor = const Color(0xFF3E3E3E);
        break;
    }

    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 38.h,
        decoration: BoxDecoration(
          color: const Color(0xFFF5F5F5),
          borderRadius: BorderRadius.circular(13.r),
        ),
        child: Center(
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (type == ResultType.fail)
                Icon(
                  Icons.cancel_outlined,
                  size: 20.sp,
                  color: const Color(0xFFE90000),
                ),

              if (type == ResultType.pass)
                Icon(
                  Icons.check_circle_outline,
                  size: 20.sp,
                  color: const Color(0xFF449400),
                ),

              if (type == ResultType.fail || type == ResultType.pass)
                SizedBox(width: 5.w),

              Text(
                text,
                style: TextStyle(
                  fontFamily: 'Manrope',
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w600,
                  height: 1.0,
                  color: textColor,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _DefectButton extends StatelessWidget {
  final String text;
  final bool selected;
  final VoidCallback onTap;

  const _DefectButton({
    required this.text,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 46.h,
        decoration: BoxDecoration(
          color: selected ? const Color(0xFFF5F5F5) : const Color(0xFFFFFFFF),
          border: Border.all(color: const Color(0xFFE8E8E8), width: 1.w),
          borderRadius: BorderRadius.circular(32.r),
        ),
        padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 10.h),
        child: Center(
          child: Text(
            text,
            style: TextStyle(
              fontFamily: 'Manrope',
              fontSize: 14.sp,
              fontWeight: FontWeight.w600,
              height: 1.0,
              color: const Color(0xFF222222),
            ),
          ),
        ),
      ),
    );
  }
}

class BreakContainers extends StatelessWidget {
  final String titlefirst;
  final String titlesecond;
  final bool showarrow;
  const BreakContainers({
    super.key,
    required this.titlefirst,
    required this.titlesecond,
    required this.showarrow,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          titlefirst,
          style: TextStyle(
            color: const Color(0xFF222222),
            fontWeight: FontWeight.w500,
            fontFamily: "Manrope",
            fontSize: 14.sp,
          ),
        ),
        SizedBox(height: 10.h),
        Container(
          margin: EdgeInsets.only(
            top: 10.h,
            right: 14.w,
            bottom: 10.h,
            left: 14.w,
          ),
          height: 57.h,
          width: 370.w,
          decoration: BoxDecoration(
            color: const Color(0xFFF5F5F5),
            borderRadius: BorderRadius.circular(12.r),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: TextField(
                  style: TextStyle(
                    fontFamily: 'Manrope',
                    fontWeight: FontWeight.w500,
                    fontSize: 16.sp,
                    color: const Color(0xFF222222),
                  ),
                  decoration: InputDecoration(
                    suffixIcon: Icon(
                      showarrow ? Icons.keyboard_arrow_down : null,
                      size: 30.sp,
                      color: const Color(0xFF111111),
                    ),
                    hintText: titlesecond,
                    hintStyle: TextStyle(
                      color: const Color(0xFF5C5C5C),
                      fontWeight: FontWeight.w500,
                      fontFamily: "Manrope",
                      fontSize: 14.sp,
                    ),
                    contentPadding: EdgeInsets.only(left: 10, top: 20),
                    border: OutlineInputBorder(borderSide: BorderSide.none),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
