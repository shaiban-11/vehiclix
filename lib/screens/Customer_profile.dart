import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:rootysysproject/bloc/customer/bloc/customer_bloc.dart';
import 'package:rootysysproject/bloc/customer/bloc/customer_event.dart';

class CustomerProfileScreen extends StatefulWidget {
  const CustomerProfileScreen({super.key});

  @override
  State<CustomerProfileScreen> createState() => _CustomerProfileScreenState();
}

class _CustomerProfileScreenState extends State<CustomerProfileScreen> {
  static const Color black = Color(0xFF111111);
  static const Color white = Color(0xFFFFFFFF);

  static const Color background = Color(0xFFF7F7F7);
  static const Color lightContainer = Color(0xFFF8F8F8);

  static const Color grayText = Color(0xFF737373);
  static const Color companyText = Color(0x7D000000);

  static const Color green = Color(0xFF93FF26);
  static const Color red = Color(0xFFE90000);

  final List<String> vehicles = [
    'vehicle_1',
    'vehicle_2',
    'vehicle_3',
    'vehicle_4',
  ];
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;

      context.read<CustomerBloc>().add(
        const CustomerFetchRequested(page: 1, limit: 100),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: background,
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              width: 402.w,
              height: 292.h,
              decoration: const BoxDecoration(
                color: white,
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(30),
                  bottomRight: Radius.circular(30),
                ),
              ),
              child: Column(
                children: [
                  SizedBox(height: 40.h),

                  Padding(
                    padding: EdgeInsets.only(
                      left: 12.w,
                      right: 12.w,
                      top: 42.h,
                    ),
                    child: Row(
                      children: [
                        GestureDetector(
                          onTap: () {
                            Navigator.pop(context);
                          },
                          child: Container(
                            width: 38.w,
                            height: 38.h,
                            decoration: BoxDecoration(
                              color: lightContainer,
                              borderRadius: BorderRadius.circular(32.r),
                            ),
                            child: Center(
                              child: Icon(
                                Icons.chevron_left,
                                size: 22.sp,
                                color: black,
                              ),
                            ),
                          ),
                        ),

                        SizedBox(width: 10.w),

                        Expanded(
                          child: Text(
                            'Customer profile',
                            style: TextStyle(
                              fontFamily: 'Manrope',
                              fontSize: 18.sp,
                              fontWeight: FontWeight.w700,
                              color: black,
                              height: 1.0,
                            ),
                          ),
                        ),

                        GestureDetector(
                          onTap: () {},
                          child: Container(
                            width: 76.w,
                            height: 38.h,
                            decoration: BoxDecoration(
                              color: lightContainer,
                              borderRadius: BorderRadius.circular(22.r),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                // EDIT ICON
                                Icon(
                                  Icons.edit_outlined,
                                  size: 20.sp,
                                  color: const Color(0xFF171717),
                                ),

                                SizedBox(width: 5.w),

                                Text(
                                  'Edit',
                                  style: TextStyle(
                                    fontFamily: 'Manrope',
                                    fontSize: 14.sp,
                                    fontWeight: FontWeight.w500,
                                    color: const Color(0xFF171717),
                                    height: 1.0,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  Padding(
                    padding: EdgeInsets.only(
                      left: 15.w,
                      right: 12.w,
                      top: 27.h,
                    ),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: RichText(
                        text: TextSpan(
                          children: [
                            TextSpan(
                              text: 'Rahul ck',
                              style: TextStyle(
                                fontFamily: 'Manrope',
                                fontSize: 18.sp,
                                fontWeight: FontWeight.w600,
                                color: black,
                                height: 1.0,
                              ),
                            ),

                            TextSpan(
                              text: ' (individual)',
                              style: TextStyle(
                                fontFamily: 'Manrope',
                                fontSize: 14.sp,
                                fontWeight: FontWeight.w500,
                                color: grayText,
                                height: 1.0,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),

                  Padding(
                    padding: EdgeInsets.only(
                      left: 15.w,
                      right: 12.w,
                      top: 12.h,
                    ),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'rahul@gmail.com',
                        style: TextStyle(
                          fontFamily: 'Manrope',
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w500,
                          color: const Color(0xFF171717),
                          height: 1.0,
                        ),
                      ),
                    ),
                  ),

                  Padding(
                    padding: EdgeInsets.only(
                      left: 15.w,
                      right: 12.w,
                      top: 45.h,
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Contact Number',
                                style: TextStyle(
                                  fontFamily: 'Manrope',
                                  fontSize: 12.sp,
                                  fontWeight: FontWeight.w500,
                                  color: const Color(0x70000000),
                                  height: 1.0,
                                ),
                              ),

                              SizedBox(height: 9.h),

                              Text(
                                '7736 3133 76',
                                style: TextStyle(
                                  fontFamily: 'Manrope',
                                  fontSize: 14.sp,
                                  fontWeight: FontWeight.w500,
                                  color: black,
                                  height: 1.0,
                                ),
                              ),
                            ],
                          ),
                        ),

                        Container(
                          width: 1.w,
                          height: 34.h,
                          color: const Color(0xFFE5E5E5),
                        ),

                        Expanded(
                          child: Padding(
                            padding: EdgeInsets.only(left: 12.w),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'WhatsApp Number',
                                  style: TextStyle(
                                    fontFamily: 'Manrope',
                                    fontSize: 12.sp,
                                    fontWeight: FontWeight.w500,
                                    color: const Color(0x70000000),
                                    height: 1.0,
                                  ),
                                ),

                                SizedBox(height: 9.h),

                                Text(
                                  '7736 3133 76',
                                  style: TextStyle(
                                    fontFamily: 'Manrope',
                                    fontSize: 14.sp,
                                    fontWeight: FontWeight.w500,
                                    color: black,
                                    height: 1.0,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            Padding(
              padding: EdgeInsets.only(top: 20.h, left: 16.w, right: 16.w),
              child: GestureDetector(
                onTap: () {},
                child: Container(
                  width: 370.w,
                  height: 54.h,
                  padding: EdgeInsets.all(8.w),
                  decoration: BoxDecoration(
                    color: white,
                    borderRadius: BorderRadius.circular(11.r),
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 38.w,
                        height: 38.h,
                        decoration: BoxDecoration(
                          color: green,
                          shape: BoxShape.circle,
                        ),
                        child: Icon(Icons.add, size: 24.sp, color: black),
                      ),

                      SizedBox(width: 10.w),

                      Text(
                        'Inspect New Vehicle',
                        style: TextStyle(
                          fontFamily: 'Manrope',
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w600,
                          color: black,
                          height: 1.0,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            SizedBox(height: 20),
            SizedBox(
              child: Padding(
                padding: EdgeInsets.only(left: 16.w, right: 16.w),
                child: ListView.builder(
                  padding: EdgeInsets.zero,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: vehicles.length,
                  itemBuilder: (context, index) {
                    final vehicleId = vehicles[index];

                    return Padding(
                      padding: EdgeInsets.only(bottom: 8.h),
                      child: _vehicleCard(
                        key: ValueKey(vehicleId),
                        onDelete: () {
                          setState(() {
                            vehicles.removeAt(index);
                          });
                        },
                      ),
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _vehicleCard({Key? key, required VoidCallback onDelete}) {
    return SwipeVehicleCard(key: key, onDelete: onDelete);
  }
}

class SwipeVehicleCard extends StatefulWidget {
  final VoidCallback onDelete;

  const SwipeVehicleCard({super.key, required this.onDelete});

  @override
  State<SwipeVehicleCard> createState() => _SwipeVehicleCardState();
}

class _SwipeVehicleCardState extends State<SwipeVehicleCard> {
  // Maximum amount the card can move left.
  static const double maxSwipe = 46;

  double swipeOffset = 0;

  void _onHorizontalDragUpdate(DragUpdateDetails details) {
    setState(() {
      swipeOffset += details.delta.dx;

      if (swipeOffset > 0) {
        swipeOffset = 0;
      }

      if (swipeOffset < -maxSwipe) {
        swipeOffset = -maxSwipe;
      }
    });
  }

  void _onHorizontalDragEnd(DragEndDetails details) {
    setState(() {
      if (swipeOffset < -(maxSwipe / 2)) {
        swipeOffset = -maxSwipe;
      } else {
        swipeOffset = 0;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 370.w,
      height: 96.h,
      child: Stack(
        clipBehavior: Clip.none,
        alignment: Alignment.centerRight,
        children: [
          Positioned(
            right: 0,
            top: 8.h,
            child: GestureDetector(
              onTap: widget.onDelete,
              child: Container(
                width: 38.w,
                height: 80.h,
                decoration: BoxDecoration(
                  color: const Color(0xFFE90000),
                  borderRadius: BorderRadius.circular(10.r),
                ),
                child: Center(
                  child: Icon(
                    Icons.delete_outline,
                    color: Colors.white,
                    size: 22.sp,
                  ),
                ),
              ),
            ),
          ),

          AnimatedPositioned(
            duration: const Duration(milliseconds: 200),
            curve: Curves.easeOut,
            left: swipeOffset.w,
            top: 0,
            child: GestureDetector(
              onHorizontalDragUpdate: _onHorizontalDragUpdate,
              onHorizontalDragEnd: _onHorizontalDragEnd,

              child: Container(
                width: 370.w,
                height: 96.h,
                padding: EdgeInsets.all(8.w),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(15.r),
                ),
                child: Row(
                  children: [
                    Container(
                      width: 80.w,
                      height: 80.h,
                      decoration: BoxDecoration(
                        color: const Color(0xFFF3F3F4),
                        borderRadius: BorderRadius.circular(8.r),
                      ),
                      clipBehavior: Clip.antiAlias,
                      child: Center(
                        child: Image.asset(
                          'assets/images/vehicle.png',
                          width: 80.w,
                          height: 53.h,
                          fit: BoxFit.contain,
                          errorBuilder: (context, error, stackTrace) {
                            return Icon(
                              Icons.directions_car,
                              size: 55.sp,
                              color: const Color(0xFF777777),
                            );
                          },
                        ),
                      ),
                    ),

                    SizedBox(width: 11.w),

                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Exterior Inspection | Rahul ck',
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontFamily: 'Manrope',
                              fontSize: 14.sp,
                              fontWeight: FontWeight.w400,
                              color: const Color(0x7D000000),
                              height: 1.0,
                            ),
                          ),

                          SizedBox(height: 7.h),

                          Text(
                            'Toyota Innova',
                            style: TextStyle(
                              fontFamily: 'Manrope',
                              fontSize: 14.sp,
                              fontWeight: FontWeight.w600,
                              color: const Color(0xFF000000),
                              height: 1.0,
                            ),
                          ),

                          SizedBox(height: 8.h),

                          Row(
                            children: [
                              Text(
                                'See',
                                style: TextStyle(
                                  fontFamily: 'Source Code Pro',
                                  fontSize: 14.sp,
                                  fontWeight: FontWeight.w600,
                                  color: const Color(0xFF000000),
                                  height: 1.0,
                                ),
                              ),

                              SizedBox(width: 6.w),

                              // RIGHT ARROW CONTAINER
                              Container(
                                width: 16.w,
                                height: 16.h,
                                decoration: BoxDecoration(
                                  color: const Color(0xFFF0F0F0),
                                  borderRadius: BorderRadius.circular(19.2.r),
                                ),
                                child: Center(
                                  child: Icon(
                                    Icons.chevron_right,
                                    size: 13.sp,
                                    color: const Color(0xFF111111),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),

                    Container(
                      width: 24.w,
                      height: 24.h,
                      decoration: BoxDecoration(
                        color: const Color(0xFFF0F0F0),
                        borderRadius: BorderRadius.circular(28.8.r),
                      ),
                      child: Center(
                        child: Icon(
                          Icons.chevron_right,
                          size: 18.sp,
                          color: const Color(0xFF111111),
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
