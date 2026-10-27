import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';

class FrontLeftPopup extends StatefulWidget {
  final bool showBreakContainers;
  final bool showremark;
  final String tyreName;
  final VoidCallback? onSave;

  // Optional callback to send collected values to the parent.
  final ValueChanged<Map<String, dynamic>>? onSaveDetails;

  const FrontLeftPopup({
    super.key,
    required this.tyreName,
    this.onSave,
    required this.showBreakContainers,
    required this.showremark,
    this.onSaveDetails,
  });

  @override
  State<FrontLeftPopup> createState() => _FrontLeftPopupState();
}

class _FrontLeftPopupState extends State<FrontLeftPopup> {
  String selectedResult = 'Fail';

  final Set<String> selectedDefects = {};

  final TextEditingController _remarkController = TextEditingController();
  final TextEditingController _breakTypeController = TextEditingController();
  final TextEditingController _breakPadsController = TextEditingController();

  final ImagePicker _imagePicker = ImagePicker();
  final List<XFile> _selectedPhotos = [];

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

  Future<void> _pickPhoto() async {
    try {
      final XFile? photo = await _imagePicker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 85,
      );

      if (photo != null && mounted) {
        setState(() {
          _selectedPhotos.add(photo);
        });
      }
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Unable to select photo: $e')));
    }
  }

  void _save() {
    final Map<String, dynamic> details = {
      'inspectionItem': widget.tyreName,
      'result': selectedResult,
      'defects': selectedDefects.toList(),
      'remark': _remarkController.text.trim(),
      'breakType': _breakTypeController.text.trim(),
      'breakPads': _breakPadsController.text.trim(),
      'photos': _selectedPhotos.map((photo) => photo.path).toList(),
    };

    // Return the collected inspection details to the parent.
    widget.onSaveDetails?.call(details);

    // Close the popup.
    Navigator.pop(context);

    // Preserve the existing callback.
    widget.onSave?.call();
  }

  @override
  void dispose() {
    _remarkController.dispose();
    _breakTypeController.dispose();
    _breakPadsController.dispose();
    super.dispose();
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
                  Expanded(
                    child: Padding(
                      padding: EdgeInsets.only(top: 14.h),
                      child: Text(
                        widget.tyreName,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
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
                    onTap: _save,
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
              physics: const BouncingScrollPhysics(),
              child: Padding(
                padding: EdgeInsets.only(
                  left: 12.w,
                  right: 9.w,
                  top: 15.h,
                  bottom: 20.h,
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

                    SizedBox(height: 26.h),

                    // REMARK
                    if (widget.showremark) ...[
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

                      _buildTextField(
                        controller: _remarkController,
                        hint: 'Comment',
                      ),
                    ],

                    SizedBox(height: 25.h),

                    // DEFECT OPTIONS
                    if (!widget.showBreakContainers && !widget.showremark) ...[
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

                      SizedBox(height: 30.h),
                    ],

                    // BRAKE FIELDS
                    if (widget.showBreakContainers) ...[
                      _buildLabeledField(
                        title: 'Break Type',
                        hint: 'Select break type',
                        controller: _breakTypeController,
                        showArrow: true,
                      ),

                      SizedBox(height: 12.h),

                      _buildLabeledField(
                        title: 'Break pads',
                        hint: 'Select break pads',
                        controller: _breakPadsController,
                        showArrow: false,
                      ),

                      SizedBox(height: 20.h),
                    ],

                    // ATTACH PHOTO
                    if (!widget.showBreakContainers) ...[
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
                          width: 150.w,
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
                                  _selectedPhotos.isEmpty
                                      ? 'Attach photo'
                                      : 'Photos (${_selectedPhotos.length})',
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
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

                      if (_selectedPhotos.isNotEmpty) ...[
                        SizedBox(height: 8.h),
                        Text(
                          '${_selectedPhotos.length} photo(s) selected',
                          style: TextStyle(
                            fontSize: 12.sp,
                            fontFamily: 'Manrope',
                            color: const Color(0xFF5C5C5C),
                          ),
                        ),
                      ],
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

  Widget _buildTextField({
    required TextEditingController controller,
    required String hint,
  }) {
    return Container(
      margin: EdgeInsets.only(top: 10.h, right: 14.w, bottom: 10.h, left: 10.w),
      height: 57.h,
      width: double.infinity,
      decoration: BoxDecoration(
        color: const Color(0xFFF5F5F5),
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: TextField(
        controller: controller,
        style: TextStyle(
          fontFamily: 'Manrope',
          fontWeight: FontWeight.w500,
          fontSize: 16.sp,
          color: const Color(0xFF222222),
        ),
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: TextStyle(
            color: const Color(0xFF5C5C5C),
            fontWeight: FontWeight.w500,
            fontFamily: 'Manrope',
            fontSize: 14.sp,
          ),
          contentPadding: EdgeInsets.only(left: 10.w, top: 18.h),
          border: const OutlineInputBorder(borderSide: BorderSide.none),
        ),
      ),
    );
  }

  Widget _buildLabeledField({
    required String title,
    required String hint,
    required TextEditingController controller,
    required bool showArrow,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(
            color: const Color(0xFF222222),
            fontWeight: FontWeight.w500,
            fontFamily: 'Manrope',
            fontSize: 14.sp,
          ),
        ),
        SizedBox(height: 8.h),
        Container(
          height: 57.h,
          width: double.infinity,
          decoration: BoxDecoration(
            color: const Color(0xFFF5F5F5),
            borderRadius: BorderRadius.circular(12.r),
          ),
          child: TextField(
            controller: controller,
            style: TextStyle(
              fontFamily: 'Manrope',
              fontWeight: FontWeight.w500,
              fontSize: 16.sp,
              color: const Color(0xFF222222),
            ),
            decoration: InputDecoration(
              suffixIcon: showArrow
                  ? Icon(
                      Icons.keyboard_arrow_down,
                      size: 30.sp,
                      color: const Color(0xFF111111),
                    )
                  : null,
              hintText: hint,
              hintStyle: TextStyle(
                color: const Color(0xFF5C5C5C),
                fontWeight: FontWeight.w500,
                fontFamily: 'Manrope',
                fontSize: 14.sp,
              ),
              contentPadding: EdgeInsets.only(left: 10.w, top: 18.h),
              border: const OutlineInputBorder(borderSide: BorderSide.none),
            ),
          ),
        ),
      ],
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
