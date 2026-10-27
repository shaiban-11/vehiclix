import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';

class FrontLeftDoor extends StatefulWidget {
  final String exteriorName;
  final bool showChasis;
  final VoidCallback? onSave;

  // Optional callback to send inspection details to the parent.
  final ValueChanged<Map<String, dynamic>>? onSaveDetails;

  const FrontLeftDoor({
    super.key,
    required this.exteriorName,
    this.onSave,
    required this.showChasis,
    this.onSaveDetails,
  });

  @override
  State<FrontLeftDoor> createState() => _FrontLeftDoorState();
}

class _FrontLeftDoorState extends State<FrontLeftDoor> {
  final List<String> frontleftdooroptions = [
    'Original paint',
    'Repainted',
    'Cosmetic paint',
    'Faded paint',
    'Scratch',
    'Deep Scratch',
    'Dent',
    'Major Dent',
  ];

  final TextEditingController _remarkController = TextEditingController();
  final ImagePicker _imagePicker = ImagePicker();

  String selectedResult = 'Fail';

  final Set<String> selectedDefects = {};
  final List<XFile> selectedPhotos = [];

  Future<void> _pickPhoto() async {
    try {
      final XFile? photo = await _imagePicker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 85,
      );

      if (photo != null && mounted) {
        setState(() {
          selectedPhotos.add(photo);
        });
      }
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Unable to select photo: $e')));
    }
  }

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

  void _saveInspection() {
    final Map<String, dynamic> inspectionDetails = {
      'inspectionItem': widget.exteriorName,
      'result': selectedResult,
      'defects': selectedDefects.toList(),
      'remark': _remarkController.text.trim(),
      'photos': selectedPhotos.map((photo) => photo.path).toList(),
    };

    // Send details to the parent screen.
    widget.onSaveDetails?.call(inspectionDetails);

    // Close the bottom sheet.
    Navigator.pop(context);

    // Preserve the existing callback.
    widget.onSave?.call();
  }

  @override
  void dispose() {
    _remarkController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        width: double.infinity,
        constraints: BoxConstraints(
          maxHeight: MediaQuery.of(context).size.height * 0.90,
        ),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(28.r),
            topRight: Radius.circular(28.r),
          ),
        ),
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.only(
              left: 12.w,
              right: 9.w,
              top: 16.h,
              bottom: 20.h,
            ),
            child: Column(
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Padding(
                        padding: EdgeInsets.only(top: 14.h),
                        child: Text(
                          widget.exteriorName,
                          style: TextStyle(
                            fontFamily: 'Manrope',
                            fontSize: 16.sp,
                            fontWeight: FontWeight.w600,
                            height: 1.0,
                            color: const Color(0xFF000000),
                          ),
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: _saveInspection,
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

                SizedBox(height: 20.h),

                Container(
                  width: 370.w,
                  height: 1.h,
                  color: const Color(0xFFE8E8E8),
                ),

                Padding(
                  padding: EdgeInsets.only(
                    left: 12.w,
                    right: 9.w,
                    top: 15.h,
                    bottom: 10.h,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: 5.h),

                      // TEST RESULT
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

                      SizedBox(height: 20.h),

                      // DEFECT OPTIONS
                      Wrap(
                        spacing: 10.w,
                        runSpacing: 10.h,
                        children: [
                          for (final option in frontleftdooroptions)
                            if (!widget.showChasis ||
                                ![
                                  'Scratch',
                                  'Deep Scratch',
                                  'Dent',
                                  'Major Dent',
                                ].contains(option))
                              _DefectButton(
                                text: option,
                                selected: selectedDefects.contains(option),
                                onTap: () => _toggleDefect(option),
                              ),
                        ],
                      ),

                      SizedBox(height: 15.h),

                      // REMARK
                      Text(
                        'Remark',
                        style: TextStyle(
                          color: const Color(0xFF222222),
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w500,
                          fontFamily: 'Manrope',
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
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: const Color(0xFFF5F5F5),
                          borderRadius: BorderRadius.circular(12.r),
                        ),
                        child: TextField(
                          controller: _remarkController,
                          style: TextStyle(
                            fontFamily: 'Manrope',
                            fontWeight: FontWeight.w500,
                            fontSize: 16.sp,
                            color: const Color(0xFF222222),
                          ),
                          decoration: InputDecoration(
                            hintText: 'Comment',
                            hintStyle: TextStyle(
                              color: const Color(0xFF5C5C5C),
                              fontWeight: FontWeight.w500,
                              fontFamily: 'Manrope',
                              fontSize: 14.sp,
                            ),
                            contentPadding: const EdgeInsets.only(
                              left: 10,
                              top: 18,
                            ),
                            border: const OutlineInputBorder(
                              borderSide: BorderSide.none,
                            ),
                          ),
                        ),
                      ),

                      SizedBox(height: 15.h),

                      // ATTACH PHOTO
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
                        onTap: _pickPhoto,
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
                              Expanded(
                                child: Text(
                                  selectedPhotos.isEmpty
                                      ? 'Attach photo'
                                      : 'Photos (${selectedPhotos.length})',
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

                      if (selectedPhotos.isNotEmpty) ...[
                        SizedBox(height: 10.h),
                        Text(
                          '${selectedPhotos.length} photo(s) selected',
                          style: TextStyle(
                            fontFamily: 'Manrope',
                            fontSize: 12.sp,
                            color: const Color(0xFF555555),
                          ),
                        ),
                      ],
                    ],
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
          border: Border.all(
            color: selected ? textColor : Colors.transparent,
            width: 1.2.w,
          ),
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
        width: 175.w,
        height: 46.h,
        decoration: BoxDecoration(
          color: selected ? const Color(0xFFFFEEEE) : const Color(0xFFFFFFFF),
          border: Border.all(
            color: selected ? const Color(0xFFE90000) : const Color(0xFFE8E8E8),
            width: 1.w,
          ),
          borderRadius: BorderRadius.circular(32.r),
        ),
        padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 10.h),
        child: Center(
          child: Text(
            text,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontFamily: 'Manrope',
              fontSize: 14.sp,
              fontWeight: FontWeight.w600,
              height: 1.0,
              color: selected
                  ? const Color(0xFFE90000)
                  : const Color(0xFF222222),
            ),
          ),
        ),
      ),
    );
  }
}
