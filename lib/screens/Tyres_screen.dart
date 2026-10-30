import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:rootysysproject/bloc/completeinspection/bloc/completetinspection_bloc.dart';
import 'package:rootysysproject/bloc/completeinspection/bloc/completetinspection_state.dart';
import 'package:rootysysproject/bloc/completeinspection/bloc/completetinspection_event.dart';
import 'package:rootysysproject/repositories/Api/api_client.dart';

import 'package:rootysysproject/bloc/inspectioncategories/bloc/inspectioncategories_bloc.dart';
import 'package:rootysysproject/bloc/inspectioncategories/bloc/inspectioncategories_event.dart';
import 'package:rootysysproject/bloc/inspectioncategories/bloc/inspectioncategories_state.dart';

import 'package:rootysysproject/bloc/submitinspection/bloc/submitinspection_bloc.dart';
import 'package:rootysysproject/bloc/submitinspection/bloc/submitinspection_event.dart';
import 'package:rootysysproject/bloc/submitinspection/bloc/submitinspection_state.dart';

// Completion API imports

import 'package:rootysysproject/repositories/models/inspectioncategoryandfileds_model.dart';
import 'package:rootysysproject/repositories/models/submitinspection_model.dart';

import 'package:rootysysproject/screens/Chasis_screen.dart';
import 'package:rootysysproject/screens/Comment_screen.dart';
import 'package:rootysysproject/screens/Electrical_screen.dart';
import 'package:rootysysproject/screens/Engine_screen.dart';
import 'package:rootysysproject/screens/Exterior_screen.dart';
import 'package:rootysysproject/screens/General_photos.dart';
import 'package:rootysysproject/screens/Interior_exterior_screen.dart';
import 'package:rootysysproject/screens/Transmission_screen.dart';
import 'package:rootysysproject/screens/front_left_popup.dart';

class TyresScreen extends StatefulWidget {
  final String customerId;
  final String vehicleId;
  final String typeItemId;
  final String inspectionId;

  const TyresScreen({
    super.key,
    required this.customerId,
    required this.vehicleId,
    required this.typeItemId,
    required this.inspectionId,
  });

  @override
  State<TyresScreen> createState() => _TyresScreenState();
}

class _TyresScreenState extends State<TyresScreen> {
  final ApiClient _apiClient = ApiClient();

  bool _isLoadingSavedInspection = false;
  bool _savedInspectionLoaded = false;
  bool showBackSuspensionContainers = false;
  String? selectedSuspension;

  String selectedTyre = '';

  int selectedStep = 0;

  bool frontSuspensionPass = true;
  bool frontSuspensionFail = false;
  bool backSuspensionPass = false;
  bool backSuspensionFail = true;

  String engineUpperCoverStatus = 'Damaged';
  String inspectionComment = '';
  bool isSubmitting = false;

  final List<String> TransmissionItems = [
    'Transmission fluid Leaks',
    'Gear Selector',
    'Unusual Noise',
    'Gear Shifting',
    'Differential',
  ];

  final List<String> ChasisItems = [
    'Core Support',
    'Frame rail',
    'Wheel house',
    'Right fender apron',
    'Shock tower/shock mount',
    'Radiator Side support(side baffle)',
    'Left fender apron',
  ];

  final List<String> interiorExteriorItems = [
    '2.Rear View Mirror',
    '3.Steering Wheel Upholstery',
    '4.Seats Upholstery',
    '5.Gear Lever',
    '6.Trunk Lining',
    '7.Armrest & Side Pockets',
    '8.Dashboard',
    '9.Floor Mats',
    '10.Doors',
    '11.Front Windscreen',
    '12.Rear Windscreen',
    '13.Side windows',
    '14.Hood',
    '15.Trunk',
    '16.Front Bumper',
    '17.Back Bumper',
  ];

  final List<String> ExteriorItems = [
    'Front Bumper',
    'Hood',
    'Fenders',
    'Roof',
    'Front Left Door',
    'Front Right Door',
    'Back Left Door',
    'Back Right Door',
    'Quarter Panels',
    'Trunk',
    'Mirrors',
    'Lights',
  ];

  final List<String> ElectricalItems = [
    'Infotainment',
    'Windows Operation',
    'Seats Adjustment',
    'Door Lock',
    'A/C Control & Cooling',
    'Central Console Button',
    'Cameras',
    'Gauges',
    'Rear View/Side View',
    'A/C Grills',
    'Ignition Systems',
    'Brake Lights',
    'Headlights',
    'Fog Lights',
    'Reverse Lights',
    'Number Plate Lights',
    'Indicators & Hazards',
    'Wipers',
    'Soft Closing Doors',
    'Sunroof/Moonroof',
    'Interior Lights',
    'Cruise Control',
  ];

  final Map<String, String> itemStatus = {};

  final List<String> tyreList = [
    'Front Left',
    'Front Right',
    'Rear Left',
    'Rear Right',
    'Spare Tire',
  ];

  String? _getCategoryId(String categoryName) {
    for (final category in inspectionCategories) {
      final name = category.categoryId?.name?.trim() ?? '';

      if (name.toLowerCase() == categoryName.trim().toLowerCase()) {
        return category.categoryId?.id;
      }
    }

    return null;
  }

  String? _getItemId(String categoryName, String itemName) {
    for (final category in inspectionCategories) {
      final name = category.categoryId?.name?.trim() ?? '';

      if (name.toLowerCase() != categoryName.trim().toLowerCase()) {
        continue;
      }

      for (final item in category.items) {
        final apiItemName = item.itemId?.name?.trim() ?? '';

        if (apiItemName.toLowerCase() == itemName.trim().toLowerCase()) {
          return item.itemId?.id;
        }
      }
    }

    return null;
  }

  // ------------------------------------------------------------
  // API CATEGORIES
  // ------------------------------------------------------------

  List<InspectionCategory> get inspectionCategories {
    final state = context.read<InspectionDetailsBloc>().state;

    if (state is! InspectionDetailsLoaded) {
      return <InspectionCategory>[];
    }

    final categories = List<InspectionCategory>.from(
      state.model.data?.categories ?? <InspectionCategory>[],
    );

    categories.sort((a, b) => (a.order ?? 0).compareTo(b.order ?? 0));

    return categories;
  }

  List<String> get apiCategoryNames {
    return inspectionCategories
        .map((category) => category.categoryId?.name?.trim() ?? '')
        .where((name) => name.isNotEmpty)
        .toList();
  }

  List<String> get steps => apiCategoryNames;

  int get currentStepIndex {
    if (steps.isEmpty) return 0;

    return selectedStep.clamp(0, steps.length - 1);
  }

  String get currentCategory {
    if (steps.isEmpty) return '';

    return steps[currentStepIndex];
  }

  String get normalizedCategory => currentCategory.toLowerCase().trim();

  @override
  void initState() {
    super.initState();

    debugPrint('Selected inspection type ID: ${widget.typeItemId}');
    debugPrint('Inspection record ID: ${widget.inspectionId}');

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;

      context.read<InspectionDetailsBloc>().add(
        GetInspectionDataFieldsEvent(
          vehicleId: widget.vehicleId,
          typeItemId: widget.typeItemId,
        ),
      );
    });
  }

  Future<void> _loadSavedInspection() async {
    if (_savedInspectionLoaded ||
        _isLoadingSavedInspection ||
        widget.inspectionId.trim().isEmpty) {
      return;
    }

    _isLoadingSavedInspection = true;

    try {
      final response = await _apiClient.getVehicleInspection(
        widget.inspectionId,
      );

      if (!mounted) return;

      if (response is! Map) {
        debugPrint('Invalid inspection response: $response');
        return;
      }

      final responseMap = Map<String, dynamic>.from(response);

      if (responseMap['success'] != true) {
        debugPrint(
          'Unable to load saved inspection: '
          '${responseMap['message'] ?? 'Unknown error'}',
        );
        return;
      }

      final rawData = responseMap['data'];

      if (rawData is! Map) {
        debugPrint('Saved inspection data is missing.');
        return;
      }

      final inspectionData = Map<String, dynamic>.from(rawData);
      final rawRemarks = inspectionData['remarks'];

      if (rawRemarks is! List) {
        debugPrint('No saved inspection remarks found.');
        _savedInspectionLoaded = true;
        return;
      }

      final Map<String, String> restoredStatuses = {};
      String restoredComment = '';

      for (final rawCategory in rawRemarks) {
        if (rawCategory is! Map) continue;

        final categoryData = Map<String, dynamic>.from(rawCategory);
        final rawItems = categoryData['items'];

        if (rawItems is! List) continue;

        for (final rawItem in rawItems) {
          if (rawItem is! Map) continue;

          final item = Map<String, dynamic>.from(rawItem);
          final itemId = item['itemId']?.toString() ?? '';

          if (itemId.isEmpty) continue;

          // API item ID ഉപയോഗിച്ച് UI-യിലെ item name കണ്ടെത്തുന്നു.
          for (final category in inspectionCategories) {
            for (final categoryItem in category.items) {
              if (categoryItem.itemId?.id != itemId) continue;

              final itemName = categoryItem.itemId?.name?.trim() ?? '';

              if (itemName.isNotEmpty) {
                final status = item['status']?.toString().trim() ?? '';

                if (status.isNotEmpty) {
                  restoredStatuses[itemName] = status;
                }
              }
            }
          }

          final comment = item['comment']?.toString() ?? '';

          if (comment.trim().isNotEmpty) {
            restoredComment = comment;
          }
        }
      }

      if (!mounted) return;

      setState(() {
        itemStatus.addAll(restoredStatuses);

        if (restoredComment.isNotEmpty) {
          inspectionComment = restoredComment;
        }

        _savedInspectionLoaded = true;
      });

      debugPrint('Saved inspection data restored successfully.');
      debugPrint('Restored item statuses: $restoredStatuses');
    } catch (error, stackTrace) {
      debugPrint('Error loading saved inspection: $error');
      debugPrintStack(stackTrace: stackTrace);
    } finally {
      _isLoadingSavedInspection = false;
    }
  }

  List<String> getCategoryItems(String categoryName) {
    final wantedName = categoryName.trim().toLowerCase();

    for (final category in inspectionCategories) {
      final apiName = category.categoryId?.name?.trim().toLowerCase() ?? '';

      if (apiName != wantedName) continue;

      final items = List<InspectionCategoryItem>.from(category.items);

      items.sort((a, b) => (a.order ?? 0).compareTo(b.order ?? 0));

      return items
          .map((entry) => entry.itemId?.name?.trim() ?? '')
          .where((name) => name.isNotEmpty)
          .toList();
    }

    return <String>[];
  }

  // ------------------------------------------------------------
  // SUBMIT INSPECTION API
  // ------------------------------------------------------------

  Future<void> _submitInspection() async {
    if (isSubmitting) return;

    final categories = inspectionCategories;

    if (categories.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('No inspection categories available.')),
      );
      return;
    }

    final List<InspectionRemark> remarks = [];

    for (final category in categories) {
      final categoryId = category.categoryId?.id;

      if (categoryId == null || categoryId.isEmpty) {
        continue;
      }

      final List<InspectionItem> items = [];

      for (final entry in category.items) {
        final itemData = entry.itemId;
        final itemId = itemData?.id;

        if (itemId == null || itemId.isEmpty) {
          continue;
        }

        final itemName = itemData?.name?.trim() ?? '';
        final savedStatus = itemStatus[itemName] ?? 'NC';

        final apiStatus = switch (savedStatus.trim().toLowerCase()) {
          'pass' => 'Pass',
          'fail' => 'Fail',
          'n/a' => 'N/A',
          'n/c' => 'N/C',
          'nc' => 'NC',
          _ => 'NC',
        };

        items.add(
          InspectionItem(
            itemId: itemId,
            status: apiStatus,
            comment: inspectionComment.trim().isEmpty
                ? null
                : inspectionComment.trim(),
          ),
        );
      }

      if (items.isNotEmpty) {
        remarks.add(InspectionRemark(categoryId: categoryId, items: items));
      }
    }

    if (remarks.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('No valid inspection items were found.')),
      );
      return;
    }

    setState(() => isSubmitting = true);

    debugPrint('Submitting inspection type ID: ${widget.typeItemId}');

    final model = InspectionSubmitModel(
      customerId: widget.customerId,
      vehicleId: widget.vehicleId,
      inspectionTypeId: widget.typeItemId,
      status: 'Draft',
      remarks: remarks,
    );

    debugPrint('Submit request body: ${model.toJson()}');

    context.read<InspectionSubmitBloc>().add(
      SubmitInspectionEvent(inspection: model),
    );
  }

  // ------------------------------------------------------------
  // BUILD
  // ------------------------------------------------------------

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<InspectionDetailsBloc, InspectionDetailsState>(
      builder: (context, state) {
        if (state is InspectionDetailsLoading ||
            state is InspectionDetailsInitial) {
          return const Scaffold(
            backgroundColor: Colors.white,
            body: Center(child: CircularProgressIndicator()),
          );
        }

        if (state is InspectionDetailsError) {
          return Scaffold(
            backgroundColor: Colors.white,
            body: SafeArea(
              child: Center(
                child: Padding(
                  padding: EdgeInsets.all(24.w),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(
                        Icons.error_outline,
                        color: Colors.red,
                        size: 42,
                      ),
                      SizedBox(height: 12.h),
                      Text(state.message, textAlign: TextAlign.center),
                      SizedBox(height: 16.h),
                      ElevatedButton(
                        onPressed: () {
                          context.read<InspectionDetailsBloc>().add(
                            GetInspectionDataFieldsEvent(
                              vehicleId: widget.vehicleId,
                              typeItemId: widget.typeItemId,
                            ),
                          );
                        },
                        child: const Text('Retry'),
                      ),
                      TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: const Text('Back'),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        }

        if (!_savedInspectionLoaded && !_isLoadingSavedInspection) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (mounted) {
              _loadSavedInspection();
            }
          });
        }
        if (apiCategoryNames.isEmpty) {
          return const Scaffold(
            backgroundColor: Colors.white,
            body: Center(child: Text('No inspection categories available.')),
          );
        }

        // ----------------------------------------------------
        // SUBMIT + COMPLETE API LISTENERS
        // ----------------------------------------------------

        return MultiBlocListener(
          listeners: [
            BlocListener<InspectionSubmitBloc, InspectionSubmitState>(
              listener: (context, submitState) {
                if (submitState is InspectionSubmitLoading) {
                  if (mounted) {
                    setState(() => isSubmitting = true);
                  }
                } else if (submitState is InspectionSubmitSuccess) {
                  // Get inspection ID from the submit API response.
                  final inspectionId = submitState.inspectionId.trim();

                  debugPrint('INSPECTION ID FOR COMPLETION: $inspectionId');

                  if (inspectionId.isEmpty) {
                    setState(() => isSubmitting = false);

                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text(
                          'Inspection ID not found in submit response.',
                        ),
                        backgroundColor: Colors.red,
                      ),
                    );
                    return;
                  }

                  // Call completion API using the newly returned inspection ID.
                  context.read<CompletedInspectionBloc>().add(
                    CompletedInspectionRequested(inspectionId: inspectionId),
                  );
                } else if (submitState is InspectionSubmitFailure) {
                  if (mounted) {
                    setState(() => isSubmitting = false);
                  }

                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(submitState.message),
                      backgroundColor: Colors.red,
                    ),
                  );
                }
              },
            ),
            BlocListener<CompletedInspectionBloc, CompletedInspectionState>(
              listener: (context, completeState) {
                if (completeState is CompletedInspectionLoading) {
                  if (mounted) {
                    setState(() => isSubmitting = true);
                  }
                } else if (completeState is CompletedInspectionSuccess) {
                  if (mounted) {
                    setState(() => isSubmitting = false);
                  }

                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Inspection completed successfully!'),
                      backgroundColor: Colors.green,
                    ),
                  );

                  // Return to previous screen after completion.
                  // Return to Home screen after completion.
                  Navigator.popUntil(context, (route) => route.isFirst);
                } else if (completeState is CompletedInspectionFailure) {
                  if (mounted) {
                    setState(() => isSubmitting = false);
                  }

                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        'Inspection saved, but completion failed: '
                        '${completeState.message}',
                      ),
                      backgroundColor: Colors.red,
                    ),
                  );
                }
              },
            ),
          ],
          child: _buildInspectionScreen(),
        );

        return const Scaffold(
          backgroundColor: Colors.white,
          body: Center(child: CircularProgressIndicator()),
        );
      },
    );
  }

  // ------------------------------------------------------------
  // INSPECTION SCREEN UI - DESIGN UNCHANGED
  // ------------------------------------------------------------

  Widget _buildInspectionScreen() {
    final category = currentCategory;
    final normalized = normalizedCategory;
    final isInteriorStep = normalized == 'interior';

    final isInteriorExteriorStep =
        normalized == 'interior & exterior' ||
        normalized == 'interior and exterior';

    final isSuspensionStep = normalized.contains('suspension');

    final isElectricalStep = normalized.contains('electrical');
    final isExteriorStep = normalized == 'exterior';
    final isEngineStep = normalized.contains('engine');
    final isTransmissionStep = normalized.contains('transmission');

    final isChasisStep =
        normalized.contains('chassis') ||
        normalized.contains('chasis') ||
        normalized.contains('subframe');

    final isGeneralPhotosStep = normalized.contains('general photos');
    final isCommentStep = normalized.contains('comment');
    final isTyreStep = normalized.contains('tyre');

    final apiTyres = getCategoryItems(category);
    final displayTyres = getCategoryItems(category);

    if (!displayTyres.contains(selectedTyre)) {
      selectedTyre = displayTyres.isNotEmpty
          ? displayTyres.first
          : 'Front Left';
    }

    final apiInteriorItems = getCategoryItems(category);
    final displayInteriorExteriorItems = apiInteriorItems;

    final apiExteriorItems = getCategoryItems(category);
    final apiElectricalItems = getCategoryItems(category);
    final apiTransmissionItems = getCategoryItems(category);
    final apiChasisItems = getCategoryItems(category);

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.only(left: 18.w, right: 18.w, top: 18.h),
              child: _buildProgressIndicator(),
            ),
            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.symmetric(horizontal: 10.w),
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 27.h),
                    Text(
                      category,
                      style: TextStyle(
                        fontFamily: 'Manrope',
                        fontWeight: FontWeight.w700,
                        fontSize: 18.sp,
                        height: 1.0,
                        color: const Color(0xFF111111),
                      ),
                    ),
                    SizedBox(height: 20.h),

                    if (isInteriorStep)
                      InteriorExterior(
                        engineUpperCoverStatus: engineUpperCoverStatus,
                        onEngineUpperCoverStatusChanged: (status) {
                          setState(() => engineUpperCoverStatus = status);
                        },
                        interiorExteriorItems: displayInteriorExteriorItems,
                        itemStatus: itemStatus,
                        onItemTap: (item) {
                          showTyrePopup(context, item, showremark: true);
                        },
                      )
                    else if (isInteriorExteriorStep)
                      InteriorExterior(
                        engineUpperCoverStatus: engineUpperCoverStatus,
                        onEngineUpperCoverStatusChanged: (status) {
                          setState(() => engineUpperCoverStatus = status);
                        },
                        interiorExteriorItems: displayInteriorExteriorItems,
                        itemStatus: itemStatus,
                        onItemTap: (item) {
                          setState(() {
                            itemStatus[item] = 'Selected';
                          });
                        },
                      )
                    else if (isElectricalStep)
                      Electrical(
                        engineUpperCoverStatus: engineUpperCoverStatus,
                        onEngineUpperCoverStatusChanged: (status) {
                          setState(() => engineUpperCoverStatus = status);
                        },
                        ElectricalItems: apiElectricalItems,
                        itemStatus: itemStatus,
                        onItemTap: (item) {
                          setState(() => itemStatus[item] = 'Selected');
                        },
                      )
                    else if (isTransmissionStep)
                      TransmissionScreen(
                        engineUpperCoverStatus: engineUpperCoverStatus,
                        onEngineUpperCoverStatusChanged: (status) {
                          setState(() => engineUpperCoverStatus = status);
                        },
                        TransmissionItems: apiTransmissionItems,
                        itemStatus: itemStatus,
                        onItemTap: (item) {
                          setState(() => itemStatus[item] = 'Selected');
                        },
                      )
                    else if (isEngineStep)
                      EngineScreen()
                    else if (isCommentStep)
                      CommentScreen(
                        initialComment: inspectionComment,
                        onCommentChanged: (value) {
                          inspectionComment = value;
                        },
                      )
                    else if (isGeneralPhotosStep)
                      GeneralPhotos()
                    else if (isSuspensionStep)
                      _buildSuspensionInspection()
                    else if (isExteriorStep)
                      ExteriorScreen(
                        customerId: widget.customerId,
                        vehicleId: widget.vehicleId,
                        inspectionTypeId: widget.typeItemId,
                        categoryId: _getCategoryId('Exterior') ?? '',
                        itemId:
                            _getItemId(
                              'Exterior',
                              apiExteriorItems.isNotEmpty
                                  ? apiExteriorItems.first
                                  : '',
                            ) ??
                            '',
                        inspectionStatus: 'Draft',
                        ExteriorItems: apiExteriorItems,
                        itemStatus: itemStatus,
                        onItemTap: (String value) {},
                        onResultChanged: (itemName, result) {
                          if (!mounted) return;

                          setState(() {
                            itemStatus[itemName] = result;
                          });
                        },
                      )
                    else if (isChasisStep)
                      ChasisScreen(
                        onItemTap: (String value) {},
                        ExteriorItems: apiChasisItems,
                      )
                    else ...[
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          'Inspect points',
                          style: TextStyle(
                            fontFamily: 'Manrope',
                            fontWeight: FontWeight.w500,
                            fontSize: 14.sp,
                            color: const Color(0xFF000000).withOpacity(0.62),
                          ),
                        ),
                      ),

                      SizedBox(height: 12.h),

                      if (displayTyres.isNotEmpty)
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 8.w),
                          child: Wrap(
                            spacing: 10.w,
                            runSpacing: 8.h,
                            children: displayTyres.map(_buildTyreCard).toList(),
                          ),
                        )
                      else
                        const Text('No inspection points available.'),
                    ],
                    SizedBox(height: 80.h),
                  ],
                ),
              ),
            ),
            _buildBottomButtons(),
          ],
        ),
      ),
    );
  }

  Widget _buildSuspensionInspection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: 15.h),
        if (!showBackSuspensionContainers) ...[
          Text(
            'Front Suspension',
            style: TextStyle(
              fontFamily: 'Manrope',
              fontWeight: FontWeight.w500,
              fontSize: 14.sp,
              height: 1.0,
              color: const Color(0xFF000000).withOpacity(0.62),
            ),
          ),
          SizedBox(height: 12.h),
          _buildSuspensionButtons(isFront: true),
          SizedBox(height: 50.h),
          Text(
            'Back Suspension',
            style: TextStyle(
              fontFamily: 'Manrope',
              fontWeight: FontWeight.w500,
              fontSize: 14.sp,
              height: 1.0,
              color: const Color(0xFF000000).withOpacity(0.62),
            ),
          ),
          SizedBox(height: 12.h),
          _buildSuspensionButtons(isFront: false),
        ],
        if (showBackSuspensionContainers) ...[
          SizedBox(height: 20.h),
          Row(
            children: [
              _Suspensioncontainers('Front'),
              SizedBox(width: 10.w),
              _Suspensioncontainers('Back'),
            ],
          ),
        ],
      ],
    );
  }

  Widget _buildSuspensionButtons({required bool isFront}) {
    final failSelected = isFront ? frontSuspensionFail : backSuspensionFail;
    final passSelected = isFront ? frontSuspensionPass : backSuspensionPass;

    return Row(
      children: [
        Expanded(
          child: _buildSuspensionButton(
            text: 'Fail',
            isSelected: failSelected,
            selectedColor: const Color(0x40E90000),
            icon: Icons.cancel_outlined,
            onTap: () => setState(() {
              if (isFront) {
                frontSuspensionFail = true;
                frontSuspensionPass = false;
              } else {
                backSuspensionFail = true;
                backSuspensionPass = false;
              }
            }),
          ),
        ),
        SizedBox(width: 8.w),
        Expanded(
          child: _buildSuspensionButton(
            text: 'Pass',
            isSelected: passSelected,
            selectedColor: const Color(0xFFD1FF91),
            icon: Icons.check_circle_outline,
            onTap: () => setState(() {
              if (isFront) {
                frontSuspensionPass = true;
                frontSuspensionFail = false;
              } else {
                backSuspensionPass = true;
                backSuspensionFail = false;
              }
            }),
          ),
        ),
      ],
    );
  }

  Widget _buildSuspensionButton({
    required String text,
    required bool isSelected,
    required Color selectedColor,
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 38.h,
        constraints: BoxConstraints(maxWidth: 180.w),
        padding: EdgeInsets.symmetric(horizontal: 37.w, vertical: 6.h),
        decoration: BoxDecoration(
          color: isSelected ? selectedColor : const Color(0xFFF5F5F5),
          borderRadius: BorderRadius.circular(13.r),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 16.sp, color: const Color(0xFF222222)),
            SizedBox(width: 8.w),
            Text(
              text,
              style: TextStyle(
                fontFamily: 'Manrope',
                fontWeight: FontWeight.w500,
                fontSize: 14.sp,
                height: 1.0,
                color: const Color(0xFF222222),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTyreCard(String tyreName) {
    final status = (itemStatus[tyreName] ?? '').trim().toLowerCase();

    Color containerColor = const Color(0xFFF5F5F5);
    Color textColor = Colors.black;
    Color iconColor = Colors.grey;

    if (status == 'pass') {
      containerColor = const Color(0xFF73F700);
      textColor = Colors.black;
      iconColor = Colors.black;
    } else if (status == 'fail') {
      containerColor = const Color(0xFFFFDADA);
      textColor = const Color(0xFFE90000);
      iconColor = const Color(0xFFE90000);
    }

    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () {
        selectedTyre = tyreName;
        showTyrePopup(context, tyreName, showremark: true);
      },
      child: Container(
        width: 178.w,
        height: 57.h,
        padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 10.h),
        decoration: BoxDecoration(
          color: containerColor,
          borderRadius: BorderRadius.circular(12.r),
        ),
        child: Row(
          children: [
            Expanded(
              child: Text(
                tyreName,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontFamily: 'Manrope',
                  fontWeight: FontWeight.w500,
                  fontSize: 12.sp,
                  color: textColor,
                ),
              ),
            ),
            Icon(Icons.arrow_forward_ios, size: 14.sp, color: iconColor),
          ],
        ),
      ),
    );
  }

  // ------------------------------------------------------------
  // BOTTOM BUTTONS
  // ------------------------------------------------------------

  Widget _buildBottomButtons() {
    final category = normalizedCategory;

    return Container(
      width: double.infinity,
      color: Colors.white,
      padding: EdgeInsets.only(left: 12.w, right: 12.w, top: 8.h, bottom: 10.h),
      child: Row(
        children: [
          SizedBox(
            width: 94.w,
            height: 52.h,
            child: OutlinedButton(
              onPressed: () => Navigator.pop(context),
              style: OutlinedButton.styleFrom(
                backgroundColor: Colors.white,
                side: BorderSide(
                  color: const Color(0xFF000000).withOpacity(0.18),
                  width: 1.w,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(46.r),
                ),
                padding: EdgeInsets.zero,
              ),
              child: Text(
                'Back',
                style: TextStyle(
                  fontFamily: 'Source Code Pro',
                  fontWeight: FontWeight.w600,
                  fontSize: 16.sp,
                  height: 1,
                  color: const Color(0xFF222222),
                ),
              ),
            ),
          ),
          SizedBox(width: 8.w),
          Expanded(
            child: SizedBox(
              height: 52.h,
              child: ElevatedButton(
                onPressed: isSubmitting
                    ? null
                    : () {
                        if (currentStepIndex < steps.length - 1) {
                          setState(() {
                            selectedStep = currentStepIndex + 1;
                            showBackSuspensionContainers = false;
                          });
                        } else {
                          _submitInspection();
                        }
                      },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF73F700),
                  disabledBackgroundColor: const Color(0xFFB8B8B8),
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(46.r),
                  ),
                  padding: EdgeInsets.zero,
                ),
                child: isSubmitting
                    ? SizedBox(
                        width: 22.w,
                        height: 22.w,
                        child: const CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Colors.black,
                        ),
                      )
                    : Text(
                        'Continue',
                        style: TextStyle(
                          fontFamily: 'Source Code Pro',
                          fontWeight: FontWeight.w600,
                          fontSize: 16.sp,
                          height: 1,
                          color: Colors.black,
                        ),
                      ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProgressIndicator() {
    final double stepWidth = 105.w;

    return SizedBox(
      height: 58.h,
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        physics: const BouncingScrollPhysics(),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: List.generate(steps.length, (index) {
            final isLast = index == steps.length - 1;

            final StepType stepType = index < currentStepIndex
                ? StepType.completed
                : index == currentStepIndex
                ? StepType.current
                : StepType.inactive;

            return SizedBox(
              width: stepWidth,
              child: Stack(
                clipBehavior: Clip.none,
                children: [
                  Align(
                    alignment: Alignment.topCenter,
                    child: Container(
                      width: 32.w,
                      height: 32.w,
                      decoration: BoxDecoration(
                        color: _colorofcontainers(stepType),
                        shape: BoxShape.circle,
                      ),
                      child: stepType == StepType.completed
                          ? Icon(Icons.check, size: 18.sp, color: Colors.black)
                          : stepType == StepType.current
                          ? Center(
                              child: Container(
                                width: 10.w,
                                height: 10.w,
                                decoration: const BoxDecoration(
                                  color: Color(0xFF777777),
                                  shape: BoxShape.circle,
                                ),
                              ),
                            )
                          : null,
                    ),
                  ),
                  if (!isLast)
                    Positioned(
                      top: 15.5.h,
                      left: 70.w,
                      child: Container(
                        width: 69.w,
                        height: 1.h,
                        color: index < currentStepIndex
                            ? Colors.black
                            : const Color(0xFFD1D1D1),
                      ),
                    ),
                  Positioned(
                    top: 38.h,
                    left: 0,
                    right: 0,
                    child: Text(
                      steps[index],
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontFamily: 'Manrope',
                        fontSize: 12.sp,
                        fontWeight: FontWeight.w600,
                        height: 1.0,
                        color: index < currentStepIndex
                            ? Colors.black
                            : index == currentStepIndex
                            ? const Color(0xFFA3A3A3)
                            : const Color(0xFFD1D1D1),
                      ),
                    ),
                  ),
                ],
              ),
            );
          }),
        ),
      ),
    );
  }

  Color _colorofcontainers(StepType type) {
    switch (type) {
      case StepType.completed:
        return const Color(0xFF73F700);
      case StepType.current:
      case StepType.inactive:
        return const Color(0xFFE8E8E8);
    }
  }

  void showTyrePopup(
    BuildContext context,
    String tyreName, {
    bool showBreakContainers = false,
    bool showremark = false,
  }) {
    final categoryId = _getCategoryId(currentCategory);
    final itemId = _getItemId(currentCategory, tyreName);

    if (categoryId == null || itemId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Category ID or Item ID not found')),
      );
      return;
    }

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (popupContext) => FrontLeftPopup(
        tyreName: tyreName,
        customerId: widget.customerId,
        vehicleId: widget.vehicleId,
        inspectionTypeId: widget.typeItemId,
        categoryId: categoryId,
        itemId: itemId,
        inspectionStatus: 'Draft',
        showBreakContainers: showBreakContainers,
        showremark: showremark,
        onResultChanged: (result) {
          if (!mounted) return;
          setState(() {
            itemStatus[tyreName] = result;
          });
        },
        onSaveDetails: (details) {
          if (!mounted) return;
          setState(() {
            itemStatus[tyreName] = (details['result'] as String?) ?? 'NC';
          });
        },
        onSave: () {},
      ),
    );
  }

  Widget _Suspensioncontainers(String title) {
    final isSelected = selectedSuspension == title;

    return GestureDetector(
      onTap: () => setState(() => selectedSuspension = title),
      child: Container(
        padding: EdgeInsets.only(
          top: 10.h,
          right: 12.w,
          left: 12.w,
          bottom: 10.h,
        ),
        width: 178.w,
        height: 57.h,
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFF5CC600) : const Color(0xFFF5F5F5),
          borderRadius: BorderRadius.circular(12.r),
        ),
        child: Row(
          children: [
            Text(
              title,
              style: TextStyle(
                color: isSelected ? const Color(0xFFD1FF91) : Colors.black,
                fontWeight: FontWeight.w600,
                fontSize: 14.sp,
                fontFamily: 'Manrope',
              ),
            ),
            SizedBox(width: 10.w),
            if (isSelected)
              Container(
                width: 18.w,
                height: 18.h,
                decoration: BoxDecoration(
                  color: const Color(0xFF5CC600),
                  shape: BoxShape.circle,
                  border: Border.all(color: const Color(0xFFF5F5F5)),
                ),
                child: Icon(
                  Icons.check,
                  size: 13.sp,
                  color: const Color(0xFFF5F5F5),
                ),
              ),
            const Spacer(),
            Icon(
              Icons.arrow_forward_ios,
              size: 14.sp,
              color: isSelected
                  ? const Color(0xFFD1FF91)
                  : const Color(0xFFA3A3A3),
            ),
          ],
        ),
      ),
    );
  }
}

enum StepType { completed, current, inactive }
