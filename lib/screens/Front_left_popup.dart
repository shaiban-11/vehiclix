import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';

import 'package:rootysysproject/bloc/uploadfiles/bloc/uploadfiles_bloc.dart';
import 'package:rootysysproject/bloc/uploadfiles/bloc/uploadfiles_event.dart';
import 'package:rootysysproject/bloc/uploadfiles/bloc/uploadfiles_state.dart';

import 'package:rootysysproject/bloc/submitinspection/bloc/submitinspection_bloc.dart';
import 'package:rootysysproject/bloc/submitinspection/bloc/submitinspection_event.dart';
import 'package:rootysysproject/bloc/submitinspection/bloc/submitinspection_state.dart';

import 'package:rootysysproject/repositories/models/submitinspection_model.dart';

class FrontLeftPopup extends StatefulWidget {
  final String tyreName;

  // Real IDs must come from your parent inspection screen.
  final String customerId;
  final String vehicleId;
  final String inspectionTypeId;
  final String categoryId;
  final String itemId;

  // This is the overall inspection status accepted by your API.
  final String inspectionStatus;

  final bool showBreakContainers;
  final bool showremark;

  final VoidCallback? onSave;
  final ValueChanged<String>? onResultChanged;
  final ValueChanged<Map<String, dynamic>>? onSaveDetails;

  const FrontLeftPopup({
    super.key,
    required this.tyreName,
    required this.customerId,
    required this.vehicleId,
    required this.inspectionTypeId,
    required this.categoryId,
    required this.itemId,
    required this.inspectionStatus,
    required this.showBreakContainers,
    required this.showremark,
    this.onSave,
    this.onResultChanged,
    this.onSaveDetails,
  });

  @override
  State<FrontLeftPopup> createState() => _FrontLeftPopupState();
}

class _FrontLeftPopupState extends State<FrontLeftPopup> {
  String selectedResult = '';

  final Set<String> selectedDefects = {};

  final TextEditingController _remarkController = TextEditingController();

  final TextEditingController _breakTypeController = TextEditingController();

  final TextEditingController _breakPadsController = TextEditingController();

  final ImagePicker _imagePicker = ImagePicker();

  final List<XFile> _selectedPhotos = [];

  bool _isSaving = false;

  void _selectResult(String value) {
    setState(() {
      selectedResult = value;
    });

    widget.onResultChanged?.call(value);
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
      final List<XFile> photos = await _imagePicker.pickMultiImage(
        imageQuality: 85,
      );

      if (photos.isNotEmpty && mounted) {
        setState(() {
          _selectedPhotos.addAll(photos);
        });
      }
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Photo selection failed: $e')));
    }
  }

  void _removePhoto(int index) {
    setState(() {
      _selectedPhotos.removeAt(index);
    });
  }

  // Upload one photo and get its server URL.
  Future<String> _uploadOnePhoto(XFile photo) async {
    final uploadBloc = context.read<FileUploadBloc>();

    uploadBloc.add(
      FileUploadRequested(folder: 'customer-vehicle', file: File(photo.path)),
    );

    final uploadState = await uploadBloc.stream.firstWhere(
      (state) => state is FileUploadSuccess || state is FileUploadFailure,
    );

    if (uploadState is FileUploadFailure) {
      throw Exception(uploadState.message);
    }

    if (uploadState is FileUploadSuccess) {
      final url = uploadState.response.data?.url;

      if (url != null && url.isNotEmpty) {
        return url;
      }

      throw Exception('Upload response-ൽ not in image url.');
    }

    throw Exception('Photo upload failed.');
  }

  Future<void> _save() async {
    if (_isSaving) return;

    // Comment mandatory
    if (_remarkController.text.trim().isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('please comment')));
      return;
    }

    // Photo mandatory
    if (_selectedPhotos.isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('please attach one photo')));
      return;
    }

    // നിങ്ങളുടെ existing code ഇവിടെ തുടരണം

    // IDs must come from the real inspection data.
    if (widget.customerId.isEmpty ||
        widget.vehicleId.isEmpty ||
        widget.inspectionTypeId.isEmpty ||
        widget.categoryId.isEmpty ||
        widget.itemId.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Inspection ID-കൾ ലഭ്യമല്ല.')),
      );
      return;
    }

    setState(() {
      _isSaving = true;
    });

    try {
      // STEP 1: Upload all selected photos.
      final List<String> uploadedUrls = [];

      for (final photo in _selectedPhotos) {
        final url = await _uploadOnePhoto(photo);
        uploadedUrls.add(url);
      }

      if (!mounted) return;

      // STEP 2: Prepare the selected UI values.
      final details = <String, dynamic>{
        'inspectionItem': widget.tyreName,
        'result': selectedResult,
        'defects': selectedDefects.toList(),
        'remark': _remarkController.text.trim(),
        'breakType': _breakTypeController.text.trim(),
        'breakPads': _breakPadsController.text.trim(),
        'photos': uploadedUrls,
      };

      // STEP 3: Convert the UI values to your existing API model.
      final inspection = InspectionSubmitModel(
        customerId: widget.customerId,
        vehicleId: widget.vehicleId,
        inspectionTypeId: widget.inspectionTypeId,
        status: widget.inspectionStatus,
        remarks: [
          InspectionRemark(
            categoryId: widget.categoryId,
            items: [
              InspectionItem(
                itemId: widget.itemId,
                status: selectedResult,
                defects: selectedDefects.toList(),
                comment: _remarkController.text.trim(),
                images: uploadedUrls
                    .map((url) => InspectionImage(url: url))
                    .toList(),
              ),
            ],
          ),
        ],
      );

      // STEP 4: Submit through your existing BLoC.
      final submitBloc = context.read<InspectionSubmitBloc>();

      submitBloc.add(SubmitInspectionEvent(inspection: inspection));

      // Wait for the API submission result.
      final submitState = await submitBloc.stream.firstWhere(
        (state) =>
            state is InspectionSubmitSuccess ||
            state is InspectionSubmitFailure,
      );

      if (!mounted) return;

      if (submitState is InspectionSubmitFailure) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Inspection submit പരാജയപ്പെട്ടു: '
              '${submitState.message}',
            ),
            backgroundColor: Colors.red,
          ),
        );
        return;
      }

      // STEP 5: Return the saved UI values to the parent.
      widget.onSaveDetails?.call(details);
      widget.onSave?.call();

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Inspection  submitted successfully'),
          backgroundColor: Colors.green,
        ),
      );

      Navigator.pop(context, details);
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('not saved : $e'), backgroundColor: Colors.red),
      );
    } finally {
      if (mounted) {
        setState(() {
          _isSaving = false;
        });
      }
    }
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
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(28.r),
          topRight: Radius.circular(28.r),
        ),
      ),
      child: Column(
        children: [
          // HEADER
          SizedBox(
            height: 65.h,
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 12.w),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      widget.tyreName,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontFamily: 'Manrope',
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w600,
                        color: Colors.black,
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: _isSaving ? null : _save,
                    child: Container(
                      width: 68.w,
                      height: 42.h,
                      decoration: BoxDecoration(
                        color: const Color(0xFF73F700),
                        borderRadius: BorderRadius.circular(42.r),
                      ),
                      alignment: Alignment.center,
                      child: _isSaving
                          ? SizedBox(
                              width: 20.w,
                              height: 20.w,
                              child: const CircularProgressIndicator(
                                strokeWidth: 2,
                                color: Color(0xFF449400),
                              ),
                            )
                          : Text(
                              'Save',
                              style: TextStyle(
                                fontFamily: 'Manrope',
                                fontSize: 14.sp,
                                fontWeight: FontWeight.w500,
                                color: const Color(0xFF449400),
                              ),
                            ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          Container(height: 1.h, color: const Color(0xFFE8E8E8)),

          // FORM
          Expanded(
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              padding: EdgeInsets.fromLTRB(12.w, 15.h, 12.w, 20.h),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Test result',
                    style: TextStyle(
                      fontFamily: 'Manrope',
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w500,
                      color: const Color(0xFF777777),
                    ),
                  ),

                  SizedBox(height: 10.h),

                  // PASS AND FAIL
                  Row(
                    children: [
                      Expanded(
                        child: _resultButton(
                          text: 'Fail',
                          selected: selectedResult == 'Fail',
                          color: const Color(0xFFE90000),
                          icon: Icons.cancel_outlined,
                          onTap: () => _selectResult('Fail'),
                        ),
                      ),
                      SizedBox(width: 8.w),
                      Expanded(
                        child: _resultButton(
                          text: 'Pass',
                          selected: selectedResult == 'Pass',
                          color: const Color(0xFF449400),
                          icon: Icons.check_circle_outline,
                          onTap: () => _selectResult('Pass'),
                        ),
                      ),
                    ],
                  ),

                  SizedBox(height: 8.h),

                  // N/A AND N/C
                  Row(
                    children: [
                      Expanded(
                        child: _resultButton(
                          text: 'N/A',
                          selected: selectedResult == 'N/A',
                          color: const Color(0xFF3E3E3E),
                          onTap: () => _selectResult('N/A'),
                        ),
                      ),
                      SizedBox(width: 8.w),
                      Expanded(
                        child: _resultButton(
                          text: 'N/C',
                          selected: selectedResult == 'N/C',
                          color: const Color(0xFF3E3E3E),
                          onTap: () => _selectResult('N/C'),
                        ),
                      ),
                    ],
                  ),

                  SizedBox(height: 22.h),

                  // REMARK
                  if (widget.showremark) ...[
                    Text(
                      'Remark',
                      style: TextStyle(
                        fontFamily: 'Manrope',
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w500,
                        color: const Color(0xFF222222),
                      ),
                    ),
                    SizedBox(height: 9.h),
                    TextField(
                      controller: _remarkController,
                      maxLines: 2,
                      decoration: InputDecoration(
                        hintText: 'Comment',
                        filled: true,
                        fillColor: const Color(0xFFF5F5F5),
                        contentPadding: EdgeInsets.all(12.w),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12.r),
                          borderSide: BorderSide.none,
                        ),
                      ),
                    ),
                    SizedBox(height: 20.h),
                  ],

                  // DEFECTS
                  if (!widget.showBreakContainers && !widget.showremark) ...[
                    Row(
                      children: [
                        Expanded(child: _defectButton('Scratches')),
                        SizedBox(width: 10.w),
                        Expanded(child: _defectButton('Bent')),
                      ],
                    ),
                    SizedBox(height: 10.h),
                    Row(
                      children: [
                        Expanded(child: _defectButton('Cracks')),
                        SizedBox(width: 10.w),
                        Expanded(child: _defectButton('Corrosion')),
                      ],
                    ),
                    SizedBox(height: 20.h),
                  ],

                  // BRAKE FIELDS
                  if (widget.showBreakContainers) ...[
                    _labeledField(
                      title: 'Break Type',
                      hint: 'Select break type',
                      controller: _breakTypeController,
                    ),
                    SizedBox(height: 12.h),
                    _labeledField(
                      title: 'Break pads',
                      hint: 'Select break pads',
                      controller: _breakPadsController,
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
                        color: const Color(0xFF777777),
                      ),
                    ),

                    SizedBox(height: 10.h),

                    GestureDetector(
                      onTap: _isSaving ? null : _pickPhoto,
                      child: Container(
                        height: 40.h,
                        padding: EdgeInsets.symmetric(horizontal: 12.w),
                        decoration: BoxDecoration(
                          border: Border.all(color: const Color(0xFFD1D1D1)),
                          borderRadius: BorderRadius.circular(30.r),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(Icons.camera_alt_outlined),
                            SizedBox(width: 6.w),
                            Text(
                              _selectedPhotos.isEmpty
                                  ? 'Attach photo'
                                  : 'Photos (${_selectedPhotos.length})',
                              style: TextStyle(
                                fontSize: 14.sp,
                                fontFamily: 'Manrope',
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                    // SELECTED PHOTO PREVIEWS
                    if (_selectedPhotos.isNotEmpty) ...[
                      SizedBox(height: 12.h),
                      Wrap(
                        spacing: 8.w,
                        runSpacing: 8.h,
                        children: List.generate(_selectedPhotos.length, (
                          index,
                        ) {
                          final photo = _selectedPhotos[index];

                          return Stack(
                            clipBehavior: Clip.none,
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(7.r),
                                child: Image.file(
                                  File(photo.path),
                                  width: 58.w,
                                  height: 58.w,
                                  fit: BoxFit.cover,
                                ),
                              ),
                              Positioned(
                                right: -5.w,
                                top: -5.h,
                                child: GestureDetector(
                                  onTap: _isSaving
                                      ? null
                                      : () => _removePhoto(index),
                                  child: Container(
                                    width: 19.w,
                                    height: 19.w,
                                    decoration: const BoxDecoration(
                                      color: Colors.white,
                                      shape: BoxShape.circle,
                                    ),
                                    child: Icon(
                                      Icons.close,
                                      size: 14.sp,
                                      color: Colors.red,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          );
                        }),
                      ),
                    ],
                  ],
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _resultButton({
    required String text,
    required bool selected,
    required Color color,
    required VoidCallback onTap,
    IconData? icon,
  }) {
    return GestureDetector(
      onTap: _isSaving ? null : onTap,
      child: Container(
        height: 38.h,
        decoration: BoxDecoration(
          color: const Color(0xFFF5F5F5),
          borderRadius: BorderRadius.circular(13.r),
          border: Border.all(
            color: selected ? color : Colors.transparent,
            width: 1.2.w,
          ),
        ),
        child: Center(
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (icon != null) ...[
                Icon(icon, size: 18.sp, color: color),
                SizedBox(width: 5.w),
              ],
              Text(
                text,
                style: TextStyle(
                  fontFamily: 'Manrope',
                  fontSize: 15.sp,
                  fontWeight: FontWeight.w600,
                  color: color,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _defectButton(String text) {
    final selected = selectedDefects.contains(text);

    return GestureDetector(
      onTap: _isSaving ? null : () => _toggleDefect(text),
      child: Container(
        height: 42.h,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: selected ? const Color(0xFFFFEEEE) : Colors.white,
          border: Border.all(
            color: selected ? const Color(0xFFE90000) : const Color(0xFFE8E8E8),
          ),
          borderRadius: BorderRadius.circular(30.r),
        ),
        child: Text(
          text,
          style: TextStyle(
            fontFamily: 'Manrope',
            fontSize: 13.sp,
            fontWeight: FontWeight.w600,
            color: selected ? const Color(0xFFE90000) : const Color(0xFF222222),
          ),
        ),
      ),
    );
  }

  Widget _labeledField({
    required String title,
    required String hint,
    required TextEditingController controller,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(
            fontFamily: 'Manrope',
            fontSize: 14.sp,
            fontWeight: FontWeight.w500,
          ),
        ),
        SizedBox(height: 8.h),
        TextField(
          controller: controller,
          decoration: InputDecoration(
            hintText: hint,
            filled: true,
            fillColor: const Color(0xFFF5F5F5),
            contentPadding: EdgeInsets.all(12.w),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12.r),
              borderSide: BorderSide.none,
            ),
          ),
        ),
      ],
    );
  }
}
