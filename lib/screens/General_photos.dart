import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';
import 'package:rootysysproject/bloc/inspectioncategories/bloc/inspectioncategories_bloc.dart';
import 'package:rootysysproject/bloc/inspectioncategories/bloc/inspectioncategories_state.dart';

class GeneralPhotos extends StatefulWidget {
  const GeneralPhotos({super.key});

  @override
  State<GeneralPhotos> createState() => _GeneralPhotosState();
}

class _GeneralPhotosState extends State<GeneralPhotos> {
  final ImagePicker _imagePicker = ImagePicker();

  final Map<String, List<XFile>> _selectedPhotos = {};

  final List<String> _fallbackCategories = [
    'Exterior',
    'Interior',
    'Engine Bay & Undercarriage',
  ];

  List<String> _getPhotoCategories(InspectionDetailsState state) {
    if (state is! InspectionDetailsLoaded) {
      return _fallbackCategories;
    }

    final categories = state.model.data?.categories;

    if (categories == null || categories.isEmpty) {
      return _fallbackCategories;
    }

    final List<String> apiCategories = [];

    for (final category in categories) {
      if (category is! Map) continue;

      final categoryId = category['categoryId'];

      String categoryName = '';

      if (categoryId is Map) {
        categoryName = (categoryId['name'] ?? '').toString();
      } else if (categoryId is String) {
        categoryName = categoryId;
      }

      if (categoryName.trim().isNotEmpty) {
        final normalizedName = categoryName.trim().toLowerCase();

        // General photo categories only.
        if (normalizedName == 'exterior' ||
            normalizedName == 'interior' ||
            normalizedName.contains('engine bay') ||
            normalizedName.contains('undercarriage')) {
          if (!apiCategories.contains(categoryName.trim())) {
            apiCategories.add(categoryName.trim());
          }
        }
      }
    }

    return apiCategories.isNotEmpty ? apiCategories : _fallbackCategories;
  }

  Future<void> _addPhoto(String category) async {
    try {
      final XFile? image = await _imagePicker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 85,
      );

      if (image == null || !mounted) return;

      setState(() {
        _selectedPhotos.putIfAbsent(category, () => []);
        _selectedPhotos[category]!.add(image);
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Photo added to $category'),
          duration: const Duration(seconds: 2),
        ),
      );
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Unable to select photo: $e')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<InspectionDetailsBloc, InspectionDetailsState>(
      builder: (context, state) {
        final photoCategories = _getPhotoCategories(state);

        return SizedBox(
          width: double.infinity,
          child: Padding(
            padding: EdgeInsets.only(left: 8.r),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Exterior',
                  style: TextStyle(
                    color: const Color(0xFF111111),
                    fontFamily: 'Manrope',
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w600,
                  ),
                ),

                SizedBox(height: 20.h),

                ...photoCategories.map(
                  (category) => Padding(
                    padding: EdgeInsets.only(bottom: 10.h),
                    child: _buildExteriorItem(category),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildExteriorItem(String title) {
    final int photoCount = _selectedPhotos[title]?.length ?? 0;

    return Container(
      padding: EdgeInsets.only(
        top: 10.h,
        right: 12.w,
        bottom: 10.h,
        left: 12.w,
      ),
      width: 371.w,
      height: 96.h,
      decoration: BoxDecoration(
        color: const Color(0xFFF5F5F5),
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: const Color(0xFF111111),
                    fontFamily: 'Manrope',
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),

              Icon(
                Icons.arrow_forward_ios_outlined,
                size: 20,
                color: const Color(0xFF9CA3AF),
              ),
            ],
          ),

          SizedBox(height: 15.h),

          Align(
            alignment: Alignment.centerRight,
            child: GestureDetector(
              onTap: () => _addPhoto(title),
              child: Container(
                padding: EdgeInsets.all(10.r),
                width: 116.w,
                height: 39.h,
                decoration: BoxDecoration(
                  color: const Color(0xFFF5F5F5),
                  borderRadius: BorderRadius.circular(30.r),
                  border: Border.all(
                    width: 1.w,
                    color: const Color(0xFFD1D1D1),
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Image.asset(
                      'assets/images/camera.png',
                      width: 18.w,
                      height: 18.h,
                    ),

                    SizedBox(width: 5.w),

                    Expanded(
                      child: Text(
                        photoCount > 0 ? 'Photos ($photoCount)' : 'Add photo',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          color: const Color(0xFF222222),
                          fontWeight: FontWeight.w500,
                          fontSize: 14.sp,
                          fontFamily: 'Manrope',
                        ),
                      ),
                    ),
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
