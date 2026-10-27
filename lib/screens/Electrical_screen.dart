import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';
import 'package:rootysysproject/bloc/inspectioncategories/bloc/inspectioncategories_bloc.dart';
import 'package:rootysysproject/bloc/inspectioncategories/bloc/inspectioncategories_state.dart';

class Electrical extends StatefulWidget {
  final String engineUpperCoverStatus;
  final ValueChanged<String> onEngineUpperCoverStatusChanged;

  final List<String> ElectricalItems;

  final Map<String, String> itemStatus;
  final ValueChanged<String> onItemTap;

  const Electrical({
    super.key,
    required this.engineUpperCoverStatus,
    required this.onEngineUpperCoverStatusChanged,
    required this.itemStatus,
    required this.onItemTap,
    required this.ElectricalItems,
  });

  @override
  State<Electrical> createState() => _ElectricalState();
}

class _ElectricalState extends State<Electrical> {
  final ImagePicker _imagePicker = ImagePicker();

  // Locally selected photo for the Key inspection item.
  XFile? _keyPhoto;

  // Fallback list is used when the API does not provide electrical items.
  final List<String> _defaultElectricalItems = [
    'Electrical Wiring',
    'Battery',
    'Alternator',
    'Starter Motor',
    'Headlights',
    'Tail Lights',
    'Indicators',
    'Brake Lights',
    'Hazard Lights',
    'Horn',
    'Power Windows',
    'Central Locking',
    'Instrument Cluster',
    'Dashboard Warning Lights',
    'Infotainment System',
    'Air Conditioning Controls',
    'Parking Sensors',
    'Reverse Camera',
  ];

  /// Reads electrical items from the inspection API response.
  ///
  /// Expected category structure:
  /// {
  ///   "categoryId": {"name": "Electrical"},
  ///   "items": [
  ///     {"itemId": {"name": "Battery"}}
  ///   ]
  /// }
  List<String> _getElectricalItems(InspectionDetailsState state) {
    if (state is! InspectionDetailsLoaded) {
      return widget.ElectricalItems.isNotEmpty
          ? widget.ElectricalItems
          : _defaultElectricalItems;
    }

    final categories = state.model.data?.categories;

    if (categories == null || categories.isEmpty) {
      return widget.ElectricalItems.isNotEmpty
          ? widget.ElectricalItems
          : _defaultElectricalItems;
    }

    for (final category in categories) {
      if (category is! Map) continue;

      final categoryInfo = category['categoryId'];

      String categoryName = '';

      if (categoryInfo is Map) {
        categoryName = (categoryInfo['name'] ?? '').toString();
      } else if (categoryInfo is String) {
        categoryName = categoryInfo;
      }

      if (categoryName.isEmpty) {
        categoryName = (category['name'] ?? '').toString();
      }

      final normalizedName = categoryName.toLowerCase();

      if (!normalizedName.contains('electrical') &&
          !normalizedName.contains('electric')) {
        continue;
      }

      final rawItems = category['items'];

      if (rawItems is! List || rawItems.isEmpty) {
        continue;
      }

      final List<String> apiItems = [];

      for (final item in rawItems) {
        if (item is! Map) continue;

        final itemInfo = item['itemId'];

        String itemName = '';

        if (itemInfo is Map) {
          itemName = (itemInfo['name'] ?? '').toString();
        }

        if (itemName.isEmpty) {
          itemName = (item['name'] ?? '').toString();
        }

        if (itemName.trim().isNotEmpty) {
          apiItems.add(itemName.trim());
        }
      }

      if (apiItems.isNotEmpty) {
        return apiItems;
      }
    }

    return widget.ElectricalItems.isNotEmpty
        ? widget.ElectricalItems
        : _defaultElectricalItems;
  }

  Future<void> _pickKeyPhoto() async {
    try {
      final XFile? photo = await _imagePicker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 80,
      );

      if (photo != null && mounted) {
        setState(() {
          _keyPhoto = photo;
        });

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Photo selected successfully')),
        );
      }
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
        final electricalItems = _getElectricalItems(state);

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildKeyInspectionCard(),

            SizedBox(height: 10.h),

            if (state is InspectionDetailsLoading)
              const Padding(
                padding: EdgeInsets.all(12),
                child: Center(child: CircularProgressIndicator()),
              ),

            ...electricalItems.map(
              (item) => Padding(
                padding: EdgeInsets.only(bottom: 10.h),
                child: _buildElectricalItem(item),
              ),
            ),
          ],
        );
      },
    );
  }

  // ================================================================
  // KEY INSPECTION CARD
  // ================================================================

  Widget _buildKeyInspectionCard() {
    return Container(
      width: 369.w,
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 10.h),
      decoration: BoxDecoration(
        color: const Color(0xFFF5F5F5),
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  'Key',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontFamily: 'Manrope',
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w600,
                    color: const Color(0xFF111111),
                  ),
                ),
              ),
              Icon(
                Icons.keyboard_arrow_right_rounded,
                size: 29.sp,
                color: const Color(0xFFA3A3A3),
              ),
            ],
          ),

          SizedBox(height: 20.h),

          Row(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      _buildStatusButton('Fail', Icons.cancel_outlined),
                      SizedBox(width: 8.w),
                      _buildStatusButton('Pass', Icons.verified_outlined),
                    ],
                  ),
                ),
              ),

              SizedBox(width: 8.w),

              GestureDetector(
                onTap: _pickKeyPhoto,
                child: Container(
                  constraints: BoxConstraints(minWidth: 108.w),
                  height: 39.h,
                  padding: EdgeInsets.symmetric(horizontal: 10.w),
                  decoration: BoxDecoration(
                    color: _keyPhoto == null
                        ? Colors.transparent
                        : const Color(0xFFE8F5E9),
                    border: Border.all(
                      color: const Color(0xFFD1D1D1),
                      width: 1.w,
                    ),
                    borderRadius: BorderRadius.circular(30.r),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        _keyPhoto == null
                            ? Icons.camera_alt_outlined
                            : Icons.check_circle_outline,
                        size: 16.sp,
                        color: const Color(0xFF222222),
                      ),
                      SizedBox(width: 6.w),
                      Text(
                        _keyPhoto == null ? 'Add photo' : 'Photo added',
                        style: TextStyle(
                          color: const Color(0xFF222222),
                          fontWeight: FontWeight.w500,
                          fontFamily: 'Manrope',
                          fontSize: 12.sp,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),

          if (_keyPhoto != null) ...[
            SizedBox(height: 10.h),
            ClipRRect(
              borderRadius: BorderRadius.circular(8.r),
              child: Image.network(
                // A local file path is not a network URL.
                // Use Image.file to preview the selected gallery photo.
                '',
                errorBuilder: (context, error, stackTrace) {
                  return _buildSelectedPhotoPreview();
                },
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildSelectedPhotoPreview() {
    return Row(
      children: [
        Icon(Icons.image_outlined, size: 18.sp, color: const Color(0xFF16965A)),
        SizedBox(width: 6.w),
        Expanded(
          child: Text(
            _keyPhoto?.name ?? 'Photo selected',
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(fontSize: 12.sp, fontFamily: 'Manrope'),
          ),
        ),
        IconButton(
          tooltip: 'Remove photo',
          onPressed: () {
            setState(() {
              _keyPhoto = null;
            });
          },
          icon: const Icon(Icons.close),
        ),
      ],
    );
  }

  // ================================================================
  // STATUS BUTTONS
  // ================================================================

  Widget _buildStatusButton(String status, IconData icon) {
    final bool isSelected =
        widget.engineUpperCoverStatus.toLowerCase() == status.toLowerCase();

    return GestureDetector(
      onTap: () {
        widget.onEngineUpperCoverStatusChanged(status);
      },
      child: Container(
        width: 84.w,
        height: 38.h,
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFFD9F0E1) : const Color(0xFFE8E8E8),
          borderRadius: BorderRadius.circular(13.r),
          border: Border.all(
            color: isSelected ? const Color(0xFF16965A) : Colors.transparent,
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: const Color(0xFF3A3A3A), size: 18.sp),
            SizedBox(width: 3.w),
            Text(
              status,
              style: TextStyle(
                fontFamily: 'Manrope',
                fontSize: 14.sp,
                fontWeight: FontWeight.w500,
                color: const Color(0xFF3A3A3A),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ================================================================
  // ELECTRICAL ITEM
  // ================================================================

  Widget _buildElectricalItem(String title) {
    final String? status = widget.itemStatus[title];

    return GestureDetector(
      onTap: () {
        // Sends the selected API item name to the parent screen.
        widget.onItemTap(title);
      },
      child: Container(
        width: double.infinity,
        height: 48.h,
        padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 10.h),
        decoration: BoxDecoration(
          color: status == null
              ? const Color(0xFFF5F5F5)
              : const Color(0xFFE8F5E9),
          borderRadius: BorderRadius.circular(12.r),
          border: Border.all(
            color: status == null
                ? Colors.transparent
                : const Color(0xFF16965A),
          ),
        ),
        child: Row(
          children: [
            Expanded(
              child: Text(
                title,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontFamily: 'Manrope',
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w600,
                  color: const Color(0xFF111111),
                ),
              ),
            ),

            if (status != null && status.isNotEmpty) ...[
              Text(
                status,
                style: TextStyle(
                  fontSize: 12.sp,
                  fontWeight: FontWeight.w600,
                  color: const Color(0xFF16965A),
                ),
              ),
              SizedBox(width: 4.w),
            ],

            Icon(
              Icons.keyboard_arrow_right_rounded,
              size: 22.sp,
              color: const Color(0xFFA3A3A3),
            ),
          ],
        ),
      ),
    );
  }
}

enum ResultType { fail, pass }
