import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:rootysysproject/screens/Chasis_screen.dart';
import 'package:rootysysproject/screens/Comment_screen.dart';
import 'package:rootysysproject/screens/Electrical_screen.dart';
import 'package:rootysysproject/screens/Engine_screen.dart';
import 'package:rootysysproject/screens/Exterior_screen.dart';
import 'package:rootysysproject/screens/General_photos.dart';
import 'package:rootysysproject/screens/Interior_exterior_screen.dart';
import 'package:rootysysproject/screens/SelectinspectionBottmsheet_screen.dart';
import 'package:rootysysproject/screens/Transmission_screen.dart';
import 'package:rootysysproject/screens/front_left_popup.dart';
import 'package:rootysysproject/screens/poda.dart';

class TyresScreen extends StatefulWidget {
  const TyresScreen({super.key});

  @override
  State<TyresScreen> createState() => _TyresScreenState();
}

class _TyresScreenState extends State<TyresScreen> {
  bool showBackSuspensionContainers = false;
  String? selectedSuspension;
  int selected = 0;

  String selectedTyre = 'Front Left';

  int selectedStep = 1;

  // ================================================================
  // FRONT SUSPENSION
  // ================================================================

  bool frontSuspensionPass = true;
  bool frontSuspensionFail = false;

  // ================================================================
  // BACK SUSPENSION
  // ================================================================

  bool backSuspensionPass = false;
  bool backSuspensionFail = true;
  final List<String> TransmissionItems = [
    "Transmission fluid Leaks",
    "Gear Selector",
    "Unusual Noise",
    "Gear Shifting",
    "Differential",
  ];
  final List<String> ChasisItems = [
    "Core Support",
    "Frame rail",
    "Wheel house",
    "Right fender apron",
    "Shock tower/shock mount",
    "Radiator Side support(side baffle)",
    "Left fender apron",
  ];

  // ================================================================
  // INTERIOR & EXTERIOR
  // ================================================================

  String engineUpperCoverStatus = 'Damaged';

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
    "Indicators & Hazards",
    "Wipers",
    "Soft Closing Doors",
    "Sunroof/Moonroof",
    "Interior Lights",
    "Cruise Control",
  ];

  // Stores status for each Interior & Exterior item.
  //
  // Example:
  // itemStatus['Dashboard'] = 'Damaged';
  final Map<String, String> itemStatus = {};

  // ================================================================
  // TYRE LIST
  // ================================================================

  final List<String> tyreList = [
    'Front Left',
    'Front Right',
    'Rear Left',
    'Rear Right',
    'Spare Tire',
  ];

  // ================================================================
  // STEPS
  // ================================================================

  final List<String> steps = [
    'Vehicle Info',
    'Tyres',
    'Rims',
    'Brake',
    'Suspension',
    'Interior & Exterior',
    'Electrical',
    'Exterior',
    'Engine',
    'Transmission',
    'Chasis & Subframe',
    'General Photos',
    'Comments',
  ];

  // ================================================================
  // BUILD
  // ================================================================

  @override
  Widget build(BuildContext context) {
    final bool isSuspensionStep = selectedStep == 4;

    // Interior & Exterior is index 5 in your steps list.
    final bool isInteriorExteriorStep = selectedStep == 5;
    final bool isElectricalStep = selectedStep == 6;
    final bool isExteriorStep = selectedStep == 7;
    final bool isEngineStep = selectedStep == 8;
    final bool isTransmissionStep = selectedStep == 9;
    final bool isChasisStep = selectedStep == 10;
    final bool isGeneralPhotosStep = selectedStep == 11;
    final bool isCommentStep = selectedStep == 12;

    return Scaffold(
      backgroundColor: Colors.white,

      body: SafeArea(
        child: Column(
          children: [
            // ==========================================================
            // TOP STEPPER
            // ==========================================================
            Padding(
              padding: EdgeInsets.only(left: 18.w, right: 18.w, top: 18.h),
              child: _buildTopStepper(),
            ),

            // ==========================================================
            // MAIN CONTENT
            // ==========================================================
            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.symmetric(horizontal: 10.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 27.h),

                    // ==================================================
                    // CURRENT STEP TITLE
                    // ==================================================
                    Text(
                      steps[selectedStep],
                      style: TextStyle(
                        fontFamily: 'Manrope',
                        fontWeight: FontWeight.w700,
                        fontSize: 18.sp,
                        height: 1.0,
                        color: const Color(0xFF111111),
                      ),
                    ),

                    SizedBox(height: 20.h),

                    // ==================================================
                    // INTERIOR & EXTERIOR
                    // ==================================================
                    if (isInteriorExteriorStep)
                      InteriorExterior(
                        engineUpperCoverStatus: engineUpperCoverStatus,

                        onEngineUpperCoverStatusChanged: (status) {
                          setState(() {
                            engineUpperCoverStatus = status;
                          });
                        },

                        interiorExteriorItems: interiorExteriorItems,

                        itemStatus: itemStatus,

                        onItemTap: (item) {
                          setState(() {
                            // You can handle item selection here.
                            itemStatus[item] = 'Selected';
                          });
                        },
                      )
                    else if (isElectricalStep)
                      Electrical(
                        engineUpperCoverStatus: engineUpperCoverStatus,

                        onEngineUpperCoverStatusChanged: (status) {
                          setState(() {
                            engineUpperCoverStatus = status;
                          });
                        },

                        ElectricalItems: ElectricalItems,

                        itemStatus: itemStatus,

                        onItemTap: (item) {
                          setState(() {
                            // You can handle item selection here.
                            itemStatus[item] = 'Selected';
                          });
                        },
                      )
                    else if (isTransmissionStep)
                      TransmissionScreen(
                        engineUpperCoverStatus: engineUpperCoverStatus,

                        onEngineUpperCoverStatusChanged: (status) {
                          setState(() {
                            engineUpperCoverStatus = status;
                          });
                        },

                        TransmissionItems: TransmissionItems,

                        itemStatus: itemStatus,

                        onItemTap: (item) {
                          setState(() {
                            // You can handle item selection here.
                            itemStatus[item] = 'Selected';
                          });
                        },
                      )
                    else if (isEngineStep)
                      EngineScreen()
                    else if (isCommentStep)
                      CommentScreen()
                    else if (isGeneralPhotosStep)
                      GeneralPhotos()
                    // ==================================================
                    // SUSPENSION
                    // ==================================================
                    else if (isSuspensionStep)
                      _buildSuspensionInspection()
                    else if (isExteriorStep)
                      ExteriorScreen(
                        // ==================================================
                        // ALL OTHER STEPS
                        // ==================================================
                        onItemTap: (String value) {},
                        ExteriorItems: ExteriorItems,
                      )
                    else if (isChasisStep)
                      ChasisScreen(
                        // ==================================================
                        // ALL OTHER STEPS
                        // ==================================================
                        onItemTap: (String value) {},
                        ExteriorItems: ChasisItems,
                      )
                    else ...[
                      Text(
                        'Inspect points',
                        style: TextStyle(
                          fontFamily: 'Manrope',
                          fontWeight: FontWeight.w500,
                          fontSize: 14.sp,
                          height: 1.0,
                          color: const Color(0xFF000000).withOpacity(0.62),
                        ),
                      ),

                      SizedBox(height: 12.h),

                      Wrap(
                        spacing: 10.w,
                        runSpacing: 8.h,
                        children: tyreList.map((tyre) {
                          return _buildTyreCard(tyre);
                        }).toList(),
                      ),
                    ],

                    SizedBox(height: 80.h),
                  ],
                ),
              ),
            ),

            // ==========================================================
            // BOTTOM BUTTONS
            // ==========================================================
            _buildBottomButtons(),
          ],
        ),
      ),
    );
  }

  // ================================================================
  // TOP STEPPER
  // ================================================================

  Widget _buildTopStepper() {
    return _buildProgressIndicator();
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
              _Suspensioncontainers("Front"),

              SizedBox(width: 10.w),

              _Suspensioncontainers("Back"),
            ],
          ),
        ],
      ],
    );
  }

  Widget _buildSuspensionButtons({required bool isFront}) {
    final bool failSelected = isFront
        ? frontSuspensionFail
        : backSuspensionFail;

    final bool passSelected = isFront
        ? frontSuspensionPass
        : backSuspensionPass;

    return Row(
      children: [
        Expanded(
          child: _buildSuspensionButton(
            text: 'Fail',
            isSelected: failSelected,
            selectedColor: const Color(0x40E90000),
            icon: Icons.cancel_outlined,
            onTap: () {
              setState(() {
                if (isFront) {
                  frontSuspensionFail = true;
                  frontSuspensionPass = false;
                } else {
                  backSuspensionFail = true;
                  backSuspensionPass = false;
                }
              });
            },
          ),
        ),

        SizedBox(width: 8.w),

        Expanded(
          child: _buildSuspensionButton(
            text: 'Pass',
            isSelected: passSelected,
            selectedColor: const Color(0xFFD1FF91),
            icon: Icons.check_circle_outline,
            onTap: () {
              setState(() {
                if (isFront) {
                  frontSuspensionPass = true;
                  frontSuspensionFail = false;
                } else {
                  backSuspensionPass = true;
                  backSuspensionFail = false;
                }
              });
            },
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
    final bool isSelected = selectedTyre == tyreName;

    return GestureDetector(
      onTap: () {
        setState(() {
          selectedTyre = tyreName;
        });
      },
      child: Container(
        width: 178.w,
        height: 57.h,
        padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 10.h),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFF5CC600) : const Color(0xFFF5F5F5),
          borderRadius: BorderRadius.circular(12.r),
        ),
        child: Row(
          children: [
            Text(
              tyreName,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontFamily: 'Manrope',
                fontWeight: FontWeight.w500,
                fontSize: 12.sp,
                height: 1.0,
                color: isSelected ? Colors.white : const Color(0xFF222222),
              ),
            ),

            SizedBox(width: 8.w),

            if (isSelected)
              Container(
                width: 18.w,
                height: 18.h,
                decoration: BoxDecoration(
                  color: const Color(0xFF5CC600),
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.white, width: 1.5.w),
                ),
                alignment: Alignment.center,
                child: Icon(Icons.check, size: 13.sp, color: Colors.white),
              ),

            const Spacer(),

            Icon(
              Icons.arrow_forward_ios,
              size: 14.sp,
              color: isSelected ? Colors.white : const Color(0xFF999999),
            ),
          ],
        ),
      ),
    );
  }

  // ================================================================
  // BOTTOM BUTTONS
  // ================================================================

  Widget _buildBottomButtons() {
    return Container(
      width: double.infinity,
      color: Colors.white,
      padding: EdgeInsets.only(left: 12.w, right: 12.w, top: 8.h, bottom: 10.h),
      child: Row(
        children: [
          // ==========================================================
          // BACK
          // ==========================================================
          SizedBox(
            width: 94.w,
            height: 52.h,
            child: OutlinedButton(
              onPressed: () {
                Navigator.pop(context);
              },
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

          // ==========================================================
          // CONTINUE
          // ==========================================================
          Expanded(
            child: SizedBox(
              height: 52.h,
              child: ElevatedButton(
                onPressed: () {
                  // ==================================================
                  // SUSPENSION
                  // ==================================================

                  if (selectedStep == 4) {
                    if (!showBackSuspensionContainers) {
                      // First Continue:
                      // Show Front & Back containers.
                      setState(() {
                        showBackSuspensionContainers = true;
                      });
                    } else {
                      // Second Continue:
                      // Open existing popup.
                      showTyrePopup(context, selectedTyre, showremark: true);
                    }
                  }
                  // ==================================================
                  // BRAKE
                  // ==================================================
                  else if (selectedStep == 3) {
                    showTyrePopup(
                      context,
                      selectedTyre,
                      showBreakContainers: true,
                    );
                  }
                  // ==================================================
                  // INTERIOR & EXTERIOR
                  // ==================================================
                  else if (selectedStep == 6) {
                    showTyrePopup(context, selectedTyre, showremark: true);
                    // The Interior & Exterior UI is already
                    // displayed on this screen.
                    //
                    // Continue simply moves to the next step.

                    setState(() {
                      if (selectedStep < steps.length - 1) {
                        selectedStep++;
                      }
                    });
                  }
                  // ==================================================
                  // OTHER STEPS
                  // ==================================================
                  else {
                    showTyrePopup(context, selectedTyre);
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF73F700),
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(46.r),
                  ),
                  padding: EdgeInsets.zero,
                ),
                child: Text(
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

  // ================================================================
  // PROGRESS INDICATOR
  // ================================================================

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
            final bool isLast = index == steps.length - 1;

            final StepType stepType = index < selectedStep
                ? StepType.completed
                : index == selectedStep
                ? StepType.current
                : StepType.inactive;

            return SizedBox(
              width: stepWidth,
              child: Stack(
                clipBehavior: Clip.none,
                children: [
                  // =================================================
                  // STEP CIRCLE
                  // =================================================
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
                        color: index < selectedStep
                            ? Colors.black
                            : const Color(0xFFD1D1D1),
                      ),
                    ),

                  // =================================================
                  // STEP LABEL
                  // =================================================
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
                        color: index < selectedStep
                            ? Colors.black
                            : index == selectedStep
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

  // ================================================================
  // STEP COLOR
  // ================================================================

  Color _colorofcontainers(StepType type) {
    switch (type) {
      case StepType.completed:
        return const Color(0xFF73F700);

      case StepType.current:
        return const Color(0xFFE8E8E8);

      case StepType.inactive:
        return const Color(0xFFE8E8E8);
    }
  }

  // ================================================================
  // SHOW TYRE POPUP
  // ================================================================

  void showTyrePopup(
    BuildContext context,
    String tyreName, {
    bool showBreakContainers = false,
    bool showremark = false,
  }) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      barrierColor: Colors.black.withOpacity(0.45),
      isDismissible: true,
      enableDrag: true,
      builder: (context) {
        return FrontLeftPopup(
          tyreName: tyreName,

          onSave: () {
            setState(() {
              if (selectedStep < steps.length - 1) {
                selectedStep++;
              }
            });
          },

          showBreakContainers: showBreakContainers,

          showremark: showremark,
        );
      },
    );
  }

  // ================================================================
  // SUSPENSION CONTAINER
  // ================================================================

  Widget _Suspensioncontainers(String title) {
    final bool isSelected = selectedSuspension == title;

    return GestureDetector(
      onTap: () {
        setState(() {
          selectedSuspension = title;
        });
      },
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
                fontFamily: "Manrope",
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

// ================================================================
// STEP TYPE
// ================================================================

enum StepType { completed, current, inactive }
