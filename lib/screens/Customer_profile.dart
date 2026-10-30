import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:rootysysproject/bloc/customer/bloc/customer_bloc.dart';
import 'package:rootysysproject/bloc/customer/bloc/customer_event.dart';
import 'package:rootysysproject/bloc/customer_vehicle/bloc/customervehicle_bloc.dart';
import 'package:rootysysproject/bloc/customer_vehicle/bloc/customervehicle_event.dart';
import 'package:rootysysproject/bloc/customer_vehicle/bloc/customervehicle_state.dart';
import 'package:rootysysproject/bloc/customerprofile/bloc/customerprofile_bloc.dart';
import 'package:rootysysproject/bloc/customerprofile/bloc/customerprofile_event.dart';
import 'package:rootysysproject/bloc/customerprofile/bloc/customerprofile_state.dart';

import 'package:rootysysproject/bloc/customervehicledeletion/bloc/customervehicledeletion_bloc.dart';
import 'package:rootysysproject/bloc/customervehicledeletion/bloc/customervehicledeletion_event.dart';
import 'package:rootysysproject/bloc/customervehicledeletion/bloc/customervehicledeletion_state.dart';
import 'package:rootysysproject/repositories/Api/api_client.dart';
import 'package:rootysysproject/repositories/Api/customervehicledelete_api.dart';
import 'package:rootysysproject/screens/CreatenewCutomer_screen.dart';

import 'package:rootysysproject/screens/Vehicleinfo_screen.dart';

class CustomerProfileScreen extends StatefulWidget {
  final String customerId;
  const CustomerProfileScreen({super.key, required this.customerId});

  @override
  State<CustomerProfileScreen> createState() => _CustomerProfileScreenState();
}

class _CustomerProfileScreenState extends State<CustomerProfileScreen> {
  static const Color black = Color(0xFF111111);
  static const Color white = Color(0xFFFFFFFF);
  static const Color background = Color(0xFFF7F7F7);
  static const Color lightContainer = Color(0xFFF8F8F8);
  static const Color grayText = Color(0xFF737373);
  static const Color green = Color(0xFF93FF26);

  late final CustomerVehicleDeleteBloc _deleteBloc;
  bool _isDeletingVehicle = false;

  @override
  void initState() {
    super.initState();
    _deleteBloc = CustomerVehicleDeleteBloc(
      repository: CustomerVehicleDeleteRepository(apiClient: ApiClient()),
    );
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      context.read<CustomerProfileBloc>().add(
        FetchCustomerProfile(widget.customerId),
      );
      context.read<CustomerBloc>().add(
        const CustomerFetchRequested(page: 1, limit: 100),
      );
      _refreshVehicles();
    });
  }

  @override
  void dispose() {
    _deleteBloc.close();
    super.dispose();
  }

  void _refreshVehicles() {
    if (mounted) {
      context.read<CustomerVehicleBloc>().add(
        FetchCustomerVehicles(widget.customerId),
      );
    }
  }

  Future<void> _openCreateVehicleScreen() async {
    final result = await Navigator.push<bool>(
      context,
      MaterialPageRoute(
        builder: (_) => VehicleInformationScreen(customerId: widget.customerId),
      ),
    );
    if (mounted && result == true) _refreshVehicles();
  }

  Future<void> _openEditVehicleScreen(dynamic vehicle) async {
    final vehicleId = _vehicleField(vehicle, [
      '_id',
      'id',
      'vehicle_id',
      'vehicleId',
    ]);
    if (vehicleId == null || vehicleId.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Vehicle ID is missing. Cannot edit this vehicle.'),
        ),
      );
      return;
    }
    final vehicleData = _vehicleToMap(vehicle);
    if (vehicleData == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Unable to read vehicle information.')),
      );
      return;
    }
    final result = await Navigator.push<bool>(
      context,
      MaterialPageRoute(
        builder: (_) => VehicleInformationScreen(
          customerId: widget.customerId,
          vehicleId: vehicleId,
          initialVehicle: vehicleData,
        ),
      ),
    );
    if (mounted && result == true) _refreshVehicles();
  }

  Future<void> _showDeleteConfirmation(String vehicleId) async {
    if (_isDeletingVehicle) return;
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Delete vehicle?'),
        content: const Text('Are you sure you want to delete this vehicle?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext, false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(dialogContext, true),
            child: const Text('Delete', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
    if (!mounted || confirmed != true) return;
    _deleteBloc.add(
      DeleteCustomerVehicleRequested(
        customerId: widget.customerId,
        vehicleId: vehicleId,
      ),
    );
  }

  Map<String, dynamic>? _vehicleToMap(dynamic vehicle) {
    if (vehicle is Map<String, dynamic>)
      return Map<String, dynamic>.from(vehicle);
    if (vehicle is Map) return Map<String, dynamic>.from(vehicle);
    try {
      final dynamic json = vehicle.toJson();
      if (json is Map<String, dynamic>) return Map<String, dynamic>.from(json);
      if (json is Map) return Map<String, dynamic>.from(json);
    } catch (_) {}
    return null;
  }

  String? _vehicleField(dynamic vehicle, List<String> keys) {
    final map = _vehicleToMap(vehicle);
    if (map == null) return null;
    for (final key in keys) {
      final value = map[key];
      if (value == null) continue;
      if (value is Map) {
        final nested =
            value['name'] ??
            value['title'] ??
            value['brand_name'] ??
            value['model_name'] ??
            value['plate_number'] ??
            value['_id'] ??
            value['id'];
        if (nested != null && nested.toString().trim().isNotEmpty)
          return nested.toString();
        continue;
      }
      final text = value.toString().trim();
      if (text.isNotEmpty) return text;
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<CustomerVehicleDeleteBloc, CustomerVehicleDeleteState>(
      bloc: _deleteBloc,
      listener: (context, state) {
        if (state is CustomerVehicleDeleteLoading) {
          setState(() => _isDeletingVehicle = true);
        } else if (_isDeletingVehicle) {
          setState(() => _isDeletingVehicle = false);
        }

        if (state is CustomerVehicleDeleteSuccess) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                state.response.message ?? 'Vehicle deleted successfully',
              ),
            ),
          );
          _refreshVehicles();
        } else if (state is CustomerVehicleDeleteFailure) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text(state.message)));
        }
      },
      child: Scaffold(
        backgroundColor: background,
        body: Stack(
          children: [
            RefreshIndicator(
              onRefresh: _refreshAllApis,
              child: SingleChildScrollView(
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
                      child: BlocBuilder<CustomerProfileBloc, CustomerProfileState>(
                        builder: (context, profileState) {
                          final customer = profileState.customerProfile?.data;
                          final user = customer?.user;
                          final profile = customer?.profile;
                          final customerName = user?.name ?? 'Customer';
                          final customerType =
                              profile?.customerType ?? 'Individual';
                          final email = user?.email ?? 'Email unavailable';
                          final phone = profile?.phoneNumber?.isNotEmpty == true
                              ? profile!.phoneNumber!
                              : user?.phone ?? 'Not available';
                          final whatsapp =
                              profile?.whatsappNumber ?? 'Not available';

                          return Column(
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
                                      onTap: () => Navigator.pop(context),
                                      child: Container(
                                        width: 38.w,
                                        height: 38.h,
                                        decoration: BoxDecoration(
                                          color: lightContainer,
                                          borderRadius: BorderRadius.circular(
                                            32.r,
                                          ),
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
                                      onTap: () async {
                                        final result =
                                            await Navigator.push<bool>(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) =>
                                                    CreateNewCustomerScreen(
                                                      isEdit: true,
                                                      customerId:
                                                          widget.customerId,
                                                    ),
                                              ),
                                            );

                                        if (!mounted || result != true) return;

                                        context.read<CustomerProfileBloc>().add(
                                          FetchCustomerProfile(
                                            widget.customerId,
                                          ),
                                        );

                                        context.read<CustomerBloc>().add(
                                          const CustomerFetchRequested(
                                            page: 1,
                                            limit: 100,
                                          ),
                                        );
                                      },
                                      child: Container(
                                        width: 76.w,
                                        height: 38.h,
                                        decoration: BoxDecoration(
                                          color: lightContainer,
                                          borderRadius: BorderRadius.circular(
                                            22.r,
                                          ),
                                        ),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
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
                                  child:
                                      profileState.status ==
                                          CustomerProfileStatus.loading
                                      ? Text(
                                          'Loading customer...',
                                          style: TextStyle(
                                            fontFamily: 'Manrope',
                                            fontSize: 18.sp,
                                            fontWeight: FontWeight.w600,
                                            color: black,
                                          ),
                                        )
                                      : profileState.status ==
                                            CustomerProfileStatus.failure
                                      ? Text(
                                          'Unable to load customer',
                                          style: TextStyle(
                                            fontFamily: 'Manrope',
                                            fontSize: 16.sp,
                                            fontWeight: FontWeight.w600,
                                            color: black,
                                          ),
                                        )
                                      : RichText(
                                          text: TextSpan(
                                            children: [
                                              TextSpan(
                                                text: customerName,
                                                style: TextStyle(
                                                  fontFamily: 'Manrope',
                                                  fontSize: 18.sp,
                                                  fontWeight: FontWeight.w600,
                                                  color: black,
                                                  height: 1.0,
                                                ),
                                              ),
                                              TextSpan(
                                                text:
                                                    ' (${customerType.toLowerCase()})',
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
                                    email,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
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
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
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
                                            phone,
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
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
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
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
                                              whatsapp,
                                              maxLines: 1,
                                              overflow: TextOverflow.ellipsis,
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
                          );
                        },
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(
                        top: 20.h,
                        left: 16.w,
                        right: 16.w,
                      ),
                      child: GestureDetector(
                        onTap: _openCreateVehicleScreen,
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
                                decoration: const BoxDecoration(
                                  color: green,
                                  shape: BoxShape.circle,
                                ),
                                child: Icon(
                                  Icons.add,
                                  size: 24.sp,
                                  color: black,
                                ),
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
                    SizedBox(height: 20.h),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16.w),
                      child:
                          BlocBuilder<
                            CustomerVehicleBloc,
                            CustomerVehicleState
                          >(
                            builder: (context, state) {
                              if (state.status ==
                                  CustomerVehicleStatus.loading) {
                                return const Center(
                                  child: Padding(
                                    padding: EdgeInsets.all(24),
                                    child: CircularProgressIndicator(),
                                  ),
                                );
                              }
                              if (state.status ==
                                  CustomerVehicleStatus.failure) {
                                return Center(
                                  child: Padding(
                                    padding: const EdgeInsets.all(20),
                                    child: Text(
                                      state.errorMessage ??
                                          'Failed to load vehicles',
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        fontFamily: 'Manrope',
                                        fontSize: 14.sp,
                                        color: grayText,
                                      ),
                                    ),
                                  ),
                                );
                              }
                              final vehicles =
                                  state.customerVehicle?.data ?? [];
                              if (vehicles.isEmpty) {
                                return Padding(
                                  padding: EdgeInsets.symmetric(vertical: 24.h),
                                  child: Center(
                                    child: Text(
                                      'No vehicles found',
                                      style: TextStyle(
                                        fontFamily: 'Manrope',
                                        fontSize: 14.sp,
                                        color: grayText,
                                      ),
                                    ),
                                  ),
                                );
                              }
                              return ListView.builder(
                                padding: EdgeInsets.zero,
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                itemCount: vehicles.length,
                                itemBuilder: (context, index) {
                                  final vehicle = vehicles[index];
                                  final vehicleMap =
                                      _vehicleToMap(vehicle) ?? {};

                                  String? imageUrl;

                                  final images = vehicleMap['vehicle_images'];

                                  if (images is List && images.isNotEmpty) {
                                    final firstImage = images.first;

                                    if (firstImage is Map) {
                                      imageUrl =
                                          firstImage['url']?.toString() ??
                                          firstImage['secure_url']
                                              ?.toString() ??
                                          firstImage['image_url']?.toString() ??
                                          firstImage['imageUrl']?.toString();
                                    } else if (firstImage is String) {
                                      imageUrl = firstImage;
                                    }
                                  } else if (images is Map) {
                                    imageUrl =
                                        images['url']?.toString() ??
                                        images['secure_url']?.toString() ??
                                        images['image_url']?.toString() ??
                                        images['imageUrl']?.toString();
                                  } else if (images is String) {
                                    imageUrl = images;
                                  }

                                  // Try other possible image fields.
                                  imageUrl ??= vehicleMap['cover_image']
                                      ?.toString();
                                  imageUrl ??= vehicleMap['image_url']
                                      ?.toString();
                                  imageUrl ??= vehicleMap['imageUrl']
                                      ?.toString();
                                  imageUrl ??= vehicleMap['vehicle_image']
                                      ?.toString();
                                  imageUrl ??= vehicleMap['vehicleImage']
                                      ?.toString();
                                  imageUrl ??= vehicleMap['image']?.toString();

                                  // Ignore empty strings.
                                  if (imageUrl != null &&
                                      imageUrl.trim().isEmpty) {
                                    imageUrl = null;
                                  }

                                  debugPrint('Vehicle image URL: $imageUrl');
                                  final vehicleId = _vehicleField(vehicle, [
                                    '_id',
                                    'id',
                                    'vehicle_id',
                                    'vehicleId',
                                  ]);
                                  final make =
                                      _vehicleField(vehicle, [
                                        'brand_name',
                                        'brand',
                                        'make',
                                        'model_name',
                                        'model',
                                      ]) ??
                                      'Vehicle';
                                  final plate =
                                      _vehicleField(vehicle, [
                                        'plate_number',
                                        'registration_number',
                                        'registrationNumber',
                                      ]) ??
                                      'Registration number unavailable';
                                  return Padding(
                                    padding: EdgeInsets.only(bottom: 8.h),
                                    child: _vehicleCard(
                                      key: ValueKey(
                                        vehicleId ?? 'vehicle-$index',
                                      ),
                                      title: make,
                                      subtitle: plate,
                                      imageUrl: imageUrl,
                                      onTap: () =>
                                          _openEditVehicleScreen(vehicle),
                                      onDelete: () {
                                        if (vehicleId == null ||
                                            vehicleId.isEmpty) {
                                          ScaffoldMessenger.of(
                                            context,
                                          ).showSnackBar(
                                            const SnackBar(
                                              content: Text(
                                                'Vehicle ID is missing.',
                                              ),
                                            ),
                                          );
                                          return;
                                        }
                                        _showDeleteConfirmation(vehicleId);
                                      },
                                    ),
                                  );
                                },
                              );
                            },
                          ),
                    ),
                    SizedBox(height: 20.h),
                  ],
                ),
              ),
            ),
            if (_isDeletingVehicle)
              Positioned.fill(
                child: Container(
                  color: Colors.black.withOpacity(0.15),
                  child: const Center(child: CircularProgressIndicator()),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _vehicleCard({
    Key? key,
    required String title,
    required String subtitle,
    required String? imageUrl,
    required VoidCallback onTap,
    required VoidCallback onDelete,
  }) {
    return SwipeVehicleCard(
      key: key,
      title: title,
      imageUrl: imageUrl,
      subtitle: subtitle,
      onTap: onTap,
      onDelete: onDelete,
    );
  }

  Future<void> _refreshAllApis() async {
    // 1. Refresh customer profile API
    context.read<CustomerProfileBloc>().add(
      FetchCustomerProfile(widget.customerId),
    );

    // 2. Refresh customer list API
    context.read<CustomerBloc>().add(
      const CustomerFetchRequested(page: 1, limit: 100),
    );

    // 3. Refresh this customer's vehicles API
    context.read<CustomerVehicleBloc>().add(
      FetchCustomerVehicles(widget.customerId),
    );

    // Keep the refresh indicator visible briefly.
    await Future<void>.delayed(const Duration(seconds: 1));
  }
}

class SwipeVehicleCard extends StatefulWidget {
  final VoidCallback onDelete;

  final VoidCallback onTap;
  final String title;
  final String subtitle;
  final String? imageUrl;

  const SwipeVehicleCard({
    this.imageUrl,
    super.key,
    required this.onDelete,
    required this.onTap,
    required this.title,
    required this.subtitle,
  });

  @override
  State<SwipeVehicleCard> createState() => _SwipeVehicleCardState();
}

class _SwipeVehicleCardState extends State<SwipeVehicleCard> {
  static const double maxSwipe = 46;
  double swipeOffset = 0;

  void _onHorizontalDragUpdate(DragUpdateDetails details) {
    setState(() {
      swipeOffset += details.delta.dx;
      if (swipeOffset > 0) swipeOffset = 0;
      if (swipeOffset < -maxSwipe) swipeOffset = -maxSwipe;
    });
  }

  void _onHorizontalDragEnd(DragEndDetails details) {
    setState(() => swipeOffset = swipeOffset < -(maxSwipe / 2) ? -maxSwipe : 0);
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
              onTap: () {
                if (swipeOffset == 0) widget.onTap();
              },
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
                        child:
                            (widget.imageUrl != null &&
                                widget.imageUrl!.trim().isNotEmpty)
                            ? Image.network(
                                widget.imageUrl!,
                                key: ValueKey(widget.imageUrl),
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
                              )
                            : Image.asset(
                                'assets/images/vehicle.png',
                                width: 80.w,
                                height: 53.h,
                                fit: BoxFit.contain,
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
                            widget.subtitle,
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
                            widget.title,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
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
