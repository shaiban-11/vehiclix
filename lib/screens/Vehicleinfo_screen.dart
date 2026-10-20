import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:rootysysproject/bloc/Brands/bloc/brands_bloc.dart';
import 'package:rootysysproject/bloc/Brands/bloc/brands_event.dart';
import 'package:rootysysproject/bloc/Brands/bloc/brands_state.dart';

import 'package:rootysysproject/bloc/Fuel/bloc/fueltype_bloc.dart';
import 'package:rootysysproject/bloc/Fuel/bloc/fueltype_event.dart';
import 'package:rootysysproject/bloc/Fuel/bloc/fueltype_state.dart';

import 'package:rootysysproject/bloc/Transmission/bloc/transmission_bloc.dart';
import 'package:rootysysproject/bloc/Transmission/bloc/transmission_event.dart';
import 'package:rootysysproject/bloc/Transmission/bloc/transmission_state.dart';

import 'package:rootysysproject/bloc/vehicle_model/bloc/vehicle_model_bloc.dart';
import 'package:rootysysproject/bloc/vehicle_model/bloc/vehicle_model_event.dart';
import 'package:rootysysproject/bloc/vehicle_model/bloc/vehicle_model_state.dart';

import 'package:rootysysproject/screens/SelectinspectionBottmsheet_screen.dart';

class VehicleInformationScreen extends StatefulWidget {
  const VehicleInformationScreen({super.key});

  @override
  State<VehicleInformationScreen> createState() =>
      _VehicleInformationScreenState();
}

class _VehicleInformationScreenState extends State<VehicleInformationScreen> {
  String? selectedBrand;
  String? selectedBodyType;
  String? selectedModel;
  String? selectedFuelType;
  String? selectedTransmission;

  final TextEditingController modelYearController = TextEditingController();
  final TextEditingController registrationController = TextEditingController();
  final TextEditingController engineController = TextEditingController();
  final TextEditingController chassisController = TextEditingController();
  final TextEditingController odometerController = TextEditingController();

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;

      context.read<BrandBloc>().add(BrandsFetchRequested());
      context.read<FuelTypeBloc>().add(FuelTypesFetchRequested());
      context.read<TransmissionBloc>().add(TransmissionFetchRequested());
      context.read<VehicleModelBloc>().add(VehicleModelFetchRequested());
    });
  }

  @override
  void dispose() {
    modelYearController.dispose();
    registrationController.dispose();
    engineController.dispose();
    chassisController.dispose();
    odometerController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                padding: EdgeInsets.only(
                  left: 10.w,
                  right: 10.w,
                  top: 12.h,
                  bottom: 15.h,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 20.h),
                    _buildProgressIndicator(),
                    SizedBox(height: 20.h),
                    _buildSectionTitle(),
                    SizedBox(height: 18.h),

                    // Brand - API
                    _buildLabel('Brand'),
                    SizedBox(height: 8.h),

                    BlocBuilder<BrandBloc, BrandState>(
                      builder: (context, state) {
                        if (state is BrandLoading) {
                          return _buildDropdown(
                            hint: 'Loading brands...',
                            value: null,
                            items: const [],
                            onChanged: (_) {},
                          );
                        }

                        if (state is BrandFailure) {
                          return _buildRetry(
                            message: 'Unable to load brands',
                            onRetry: () {
                              context.read<BrandBloc>().add(
                                BrandsFetchRequested(),
                              );
                            },
                          );
                        }

                        if (state is BrandSuccess) {
                          final brands = state.brandResponse.data ?? [];

                          final brandNames = brands
                              .map((brand) => brand.name)
                              .whereType<String>()
                              .where((name) => name.trim().isNotEmpty)
                              .toSet()
                              .toList();

                          if (brandNames.isEmpty) {
                            return _buildDropdown(
                              hint: 'No brands available',
                              value: null,
                              items: const [],
                              onChanged: (_) {},
                            );
                          }

                          return _buildDropdown(
                            hint: 'Select car brand',
                            value: brandNames.contains(selectedBrand)
                                ? selectedBrand
                                : null,
                            items: brandNames,
                            onChanged: (value) {
                              setState(() {
                                selectedBrand = value;
                              });
                            },
                          );
                        }

                        return _buildDropdown(
                          hint: 'Select car brand',
                          value: null,
                          items: const [],
                          onChanged: (_) {},
                        );
                      },
                    ),

                    SizedBox(height: 18.h),

                    // Body Type - Existing static options
                    _buildLabel('Body type'),
                    SizedBox(height: 8.h),
                    _buildDropdown(
                      hint: 'Select body type',
                      value: selectedBodyType,
                      items: const [
                        'Sedan',
                        'SUV',
                        'Hatchback',
                        'Coupe',
                        'Pickup',
                      ],
                      onChanged: (value) {
                        setState(() {
                          selectedBodyType = value;
                        });
                      },
                    ),

                    SizedBox(height: 18.h),

                    // Model - API
                    _buildLabel('Model'),
                    SizedBox(height: 8.h),

                    BlocBuilder<VehicleModelBloc, VehicleModelState>(
                      builder: (context, state) {
                        if (state is VehicleModelLoading) {
                          return _buildDropdown(
                            hint: 'Loading models...',
                            value: null,
                            items: const [],
                            onChanged: (_) {},
                          );
                        }

                        if (state is VehicleModelFailure) {
                          return _buildRetry(
                            message: 'Unable to load vehicle models',
                            onRetry: () {
                              context.read<VehicleModelBloc>().add(
                                VehicleModelFetchRequested(),
                              );
                            },
                          );
                        }

                        if (state is VehicleModelSuccess) {
                          final models = state.vehicleModelResponse.data ?? [];

                          final modelNames = models
                              .map((model) => model.name)
                              .whereType<String>()
                              .where((name) => name.trim().isNotEmpty)
                              .toSet()
                              .toList();

                          if (modelNames.isEmpty) {
                            return _buildDropdown(
                              hint: 'No models available',
                              value: null,
                              items: const [],
                              onChanged: (_) {},
                            );
                          }

                          return _buildDropdown(
                            hint: 'Select model',
                            value: modelNames.contains(selectedModel)
                                ? selectedModel
                                : null,
                            items: modelNames,
                            onChanged: (value) {
                              setState(() {
                                selectedModel = value;
                              });
                            },
                          );
                        }

                        return _buildDropdown(
                          hint: 'Select model',
                          value: null,
                          items: const [],
                          onChanged: (_) {},
                        );
                      },
                    ),

                    SizedBox(height: 18.h),

                    // Model Year + Registration Number
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: _buildSmallField(
                            label: 'Model Year',
                            hint: 'YYYY',
                            controller: modelYearController,
                          ),
                        ),
                        SizedBox(width: 8.w),
                        Expanded(
                          child: _buildSmallField(
                            label: 'Registration Number',
                            hint: '000000000',
                            controller: registrationController,
                          ),
                        ),
                      ],
                    ),

                    SizedBox(height: 18.h),

                    // Engine Number + Chassis Number
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: _buildSmallField(
                            label: 'Engine Number',
                            hint: '00000000000',
                            controller: engineController,
                          ),
                        ),
                        SizedBox(width: 8.w),
                        Expanded(
                          child: _buildSmallField(
                            label: 'Chasis Number',
                            hint: '000000000000',
                            controller: chassisController,
                          ),
                        ),
                      ],
                    ),

                    SizedBox(height: 18.h),

                    // Fuel Type - API
                    _buildLabel('Fuel type'),
                    SizedBox(height: 8.h),

                    BlocBuilder<FuelTypeBloc, FuelTypeState>(
                      builder: (context, state) {
                        if (state is FuelTypeLoading) {
                          return _buildDropdown(
                            hint: 'Loading fuel types...',
                            value: null,
                            items: const [],
                            onChanged: (_) {},
                          );
                        }

                        if (state is FuelTypeFailure) {
                          return _buildRetry(
                            message: 'Unable to load fuel types',
                            onRetry: () {
                              context.read<FuelTypeBloc>().add(
                                FuelTypesFetchRequested(),
                              );
                            },
                          );
                        }

                        if (state is FuelTypeSuccess) {
                          final fuelTypes = state.fuelTypesResponse.data ?? [];

                          final fuelNames = fuelTypes
                              .map((fuel) => fuel.name)
                              .whereType<String>()
                              .where((name) => name.trim().isNotEmpty)
                              .toSet()
                              .toList();

                          if (fuelNames.isEmpty) {
                            return _buildDropdown(
                              hint: 'No fuel types available',
                              value: null,
                              items: const [],
                              onChanged: (_) {},
                            );
                          }

                          return _buildDropdown(
                            hint: 'Select Fuel type',
                            value: fuelNames.contains(selectedFuelType)
                                ? selectedFuelType
                                : null,
                            items: fuelNames,
                            onChanged: (value) {
                              setState(() {
                                selectedFuelType = value;
                              });
                            },
                          );
                        }

                        return _buildDropdown(
                          hint: 'Select Fuel type',
                          value: null,
                          items: const [],
                          onChanged: (_) {},
                        );
                      },
                    ),

                    SizedBox(height: 18.h),

                    // Transmission - API
                    _buildLabel('Transmission'),
                    SizedBox(height: 8.h),

                    BlocBuilder<TransmissionBloc, TransmissionState>(
                      builder: (context, state) {
                        if (state is TransmissionLoading) {
                          return _buildDropdown(
                            hint: 'Loading transmissions...',
                            value: null,
                            items: const [],
                            onChanged: (_) {},
                          );
                        }

                        if (state is TransmissionFailure) {
                          return _buildRetry(
                            message: 'Unable to load transmissions',
                            onRetry: () {
                              context.read<TransmissionBloc>().add(
                                TransmissionFetchRequested(),
                              );
                            },
                          );
                        }

                        if (state is TransmissionSuccess) {
                          final transmissions =
                              state.transmissionResponse.data ?? [];

                          final transmissionNames = transmissions
                              .map((transmission) => transmission.name)
                              .whereType<String>()
                              .where((name) => name.trim().isNotEmpty)
                              .toSet()
                              .toList();

                          if (transmissionNames.isEmpty) {
                            return _buildDropdown(
                              hint: 'No transmissions available',
                              value: null,
                              items: const [],
                              onChanged: (_) {},
                            );
                          }

                          return _buildDropdown(
                            hint: 'Select Transmission type',
                            value:
                                transmissionNames.contains(selectedTransmission)
                                ? selectedTransmission
                                : null,
                            items: transmissionNames,
                            onChanged: (value) {
                              setState(() {
                                selectedTransmission = value;
                              });
                            },
                          );
                        }

                        return _buildDropdown(
                          hint: 'Select Transmission type',
                          value: null,
                          items: const [],
                          onChanged: (_) {},
                        );
                      },
                    ),

                    SizedBox(height: 18.h),

                    // Odometer
                    _buildLabel('Odometer reading'),
                    SizedBox(height: 8.h),
                    _buildTextField(
                      hint: 'Enter km',
                      controller: odometerController,
                    ),

                    SizedBox(height: 9.h),

                    // Attach Photo
                    _buildAttachPhoto(),
                    SizedBox(height: 10.h),
                  ],
                ),
              ),
            ),

            // Bottom buttons
            _buildBottomButtons(),
          ],
        ),
      ),
    );
  }

  Widget _buildRetry({required String message, required VoidCallback onRetry}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          message,
          style: TextStyle(
            fontFamily: 'Manrope',
            fontSize: 12.sp,
            color: Colors.red,
          ),
        ),
        TextButton(onPressed: onRetry, child: const Text('Retry')),
      ],
    );
  }

  Widget _buildProgressIndicator() {
    final steps = ['Vehicle Info', 'Brake', 'Rims', 'Brake'];
    const int selectedStep = 0;

    return Padding(
      padding: EdgeInsets.only(left: 15.w),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        physics: const NeverScrollableScrollPhysics(),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: List.generate(steps.length, (index) {
            final isLast = index == steps.length - 1;
            final isSelected = index == selectedStep;

            return Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Column(
                  children: [
                    Container(
                      width: 32.w,
                      height: 32.w,
                      decoration: const BoxDecoration(
                        color: Color(0xFFE8E8E8),
                        shape: BoxShape.circle,
                      ),
                      child: isSelected
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
                    SizedBox(height: 2.h),
                    Text(
                      steps[index],
                      maxLines: 1,
                      style: TextStyle(
                        fontFamily: 'Manrope',
                        fontSize: 8.sp,
                        fontWeight: FontWeight.w400,
                        color: const Color(0xFF333333),
                      ),
                    ),
                  ],
                ),
                if (!isLast)
                  Container(
                    width: 50.w,
                    height: 1.h,
                    margin: EdgeInsets.only(top: 16.h, left: 8.w, right: 8.w),
                    color: const Color(0xFFE8E8E8),
                  ),
              ],
            );
          }),
        ),
      ),
    );
  }

  Widget _buildSectionTitle() {
    return Text(
      'Vehicle Information',
      style: TextStyle(
        fontFamily: 'Manrope',
        fontWeight: FontWeight.w700,
        fontSize: 18.sp,
        height: 1,
        color: const Color(0xFF111111),
      ),
    );
  }

  Widget _buildLabel(String text) {
    return Text(
      text,
      style: TextStyle(
        fontFamily: 'Manrope',
        fontWeight: FontWeight.w500,
        fontSize: 16.sp,
        height: 1,
        color: const Color(0xFF222222),
      ),
    );
  }

  Widget _buildDropdown({
    required String hint,
    required String? value,
    required List<String> items,
    required ValueChanged<String?> onChanged,
  }) {
    return Container(
      width: double.infinity,
      height: 57.h,
      padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 10.h),
      decoration: BoxDecoration(
        color: const Color(0xFFF5F5F5),
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: value,
          isExpanded: true,
          icon: Icon(
            Icons.keyboard_arrow_down_rounded,
            size: 24.sp,
            color: const Color(0xFF111111),
          ),
          hint: Text(
            hint,
            style: TextStyle(
              fontFamily: 'Manrope',
              fontWeight: FontWeight.w400,
              fontSize: 12.sp,
              color: const Color(0xFF555555),
            ),
          ),
          dropdownColor: Colors.white,
          borderRadius: BorderRadius.circular(12.r),
          items: items.map((item) {
            return DropdownMenuItem<String>(
              value: item,
              child: Text(
                item,
                style: TextStyle(
                  fontFamily: 'Manrope',
                  fontSize: 13.sp,
                  fontWeight: FontWeight.w400,
                  color: const Color(0xFF222222),
                ),
              ),
            );
          }).toList(),
          onChanged: onChanged,
        ),
      ),
    );
  }

  Widget _buildSmallField({
    required String label,
    required String hint,
    required TextEditingController controller,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildLabel(label),
        SizedBox(height: 8.h),
        _buildTextField(hint: hint, controller: controller),
      ],
    );
  }

  Widget _buildTextField({
    required String hint,
    required TextEditingController controller,
  }) {
    return Container(
      height: 57.h,
      decoration: BoxDecoration(
        color: const Color(0xFFF5F5F5),
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: TextField(
        controller: controller,
        style: TextStyle(
          fontFamily: 'Manrope',
          fontSize: 12.sp,
          fontWeight: FontWeight.w400,
          color: const Color(0xFF222222),
        ),
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: TextStyle(
            fontFamily: 'Manrope',
            fontSize: 12.sp,
            fontWeight: FontWeight.w400,
            color: const Color(0xFF666666),
          ),
          contentPadding: EdgeInsets.symmetric(
            horizontal: 14.w,
            vertical: 10.h,
          ),
          border: InputBorder.none,
          enabledBorder: InputBorder.none,
          focusedBorder: InputBorder.none,
        ),
      ),
    );
  }

  Widget _buildAttachPhoto() {
    return GestureDetector(
      onTap: () {
        // TODO: Add image picker here
      },
      child: Container(
        width: 139.w,
        height: 39.h,
        padding: EdgeInsets.all(10.w),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(30.r),
          border: Border.all(color: const Color(0xFFD1D1D1), width: 1.w),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.photo_camera_outlined,
              size: 16.sp,
              color: const Color(0xFF222222),
            ),
            SizedBox(width: 7.w),
            Text(
              'Attach photo',
              style: TextStyle(
                fontFamily: 'Manrope',
                fontWeight: FontWeight.w500,
                fontSize: 14.sp,
                height: 1,
                color: const Color(0xFF222222),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBottomButtons() {
    return Container(
      width: double.infinity,
      color: Colors.white,
      padding: EdgeInsets.only(left: 12.w, right: 12.w, top: 8.h, bottom: 10.h),
      child: Row(
        children: [
          // Back
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

          // Continue
          Expanded(
            child: SizedBox(
              height: 52.h,
              child: ElevatedButton(
                onPressed: () {
                  showModalBottomSheet(
                    context: context,
                    isScrollControlled: true,
                    backgroundColor: Colors.transparent,
                    builder: (context) {
                      return SelectInspectionBottomSheet(
                        onFullInspectionTap: () {
                          Navigator.pop(context);
                          // Navigate to Full Inspection screen here
                        },
                      );
                    },
                  );
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
}
