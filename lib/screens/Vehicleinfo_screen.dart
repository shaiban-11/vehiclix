import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';

import 'package:rootysysproject/bloc/Brands/bloc/brands_bloc.dart';
import 'package:rootysysproject/bloc/Brands/bloc/brands_event.dart';
import 'package:rootysysproject/bloc/Brands/bloc/brands_state.dart';
import 'package:rootysysproject/bloc/country_spec.dart/bloc/countryspec_bloc.dart';
import 'package:rootysysproject/bloc/country_spec.dart/bloc/countryspec_event.dart';
import 'package:rootysysproject/bloc/country_spec.dart/bloc/countryspec_state.dart';
import 'package:rootysysproject/bloc/Fuel/bloc/fueltype_bloc.dart';
import 'package:rootysysproject/bloc/Fuel/bloc/fueltype_event.dart';
import 'package:rootysysproject/bloc/Fuel/bloc/fueltype_state.dart';
import 'package:rootysysproject/bloc/Transmission/bloc/transmission_bloc.dart';
import 'package:rootysysproject/bloc/Transmission/bloc/transmission_event.dart';
import 'package:rootysysproject/bloc/Transmission/bloc/transmission_state.dart';
import 'package:rootysysproject/bloc/createcustomervehicle/bloc/createcustomervehicle_bloc.dart';
import 'package:rootysysproject/bloc/createcustomervehicle/bloc/createcustomervehicle_event.dart';
import 'package:rootysysproject/bloc/createcustomervehicle/bloc/createcustomervehicle_state.dart';
import 'package:rootysysproject/bloc/updatevehicleinfo/bloc/updatevehicleinfo_bloc.dart';
import 'package:rootysysproject/bloc/updatevehicleinfo/bloc/updatevehicleinfo_event.dart';
import 'package:rootysysproject/bloc/updatevehicleinfo/bloc/updatevehicleinfo_state.dart';
import 'package:rootysysproject/bloc/vehicle_model/bloc/vehicle_model_bloc.dart';
import 'package:rootysysproject/bloc/vehicle_model/bloc/vehicle_model_event.dart';
import 'package:rootysysproject/bloc/vehicle_model/bloc/vehicle_model_state.dart';
import 'package:rootysysproject/bloc/vehicle_varients/bloc/vehicle_varients_bloc.dart';
import 'package:rootysysproject/bloc/vehicle_varients/bloc/vehicle_varients_event.dart';
import 'package:rootysysproject/bloc/vehicle_varients/bloc/vehicle_varients_state.dart';
import 'package:rootysysproject/screens/SelectinspectionBottmsheet_screen.dart';

class VehicleInformationScreen extends StatefulWidget {
  final String customerId;
  final String? vehicleId;
  final Map<String, dynamic>? initialVehicle;

  const VehicleInformationScreen({
    super.key,
    required this.customerId,
    this.vehicleId,
    this.initialVehicle,
  });

  @override
  State<VehicleInformationScreen> createState() =>
      _VehicleInformationScreenState();
}

class _VehicleInformationScreenState extends State<VehicleInformationScreen> {
  bool get isEditMode => widget.vehicleId != null;

  final ImagePicker _picker = ImagePicker();
  File? selectedImage;

  String? selectedBrand;
  String? selectedBodyType;
  String? selectedModel;
  String? selectedModelId;
  String? selectedVariant;
  String? selectedFuelType;
  String? selectedTransmission;
  String? selectedCountrySpec;
  String? selectedCountrySpecId;
  bool isCreatingVehicle = false;

  final modelYearController = TextEditingController();
  final registrationController = TextEditingController();
  final engineController = TextEditingController();
  final chassisController = TextEditingController();
  final odometerController = TextEditingController();
  final countrypsecController = TextEditingController();

  @override
  void initState() {
    super.initState();

    final vehicle = widget.initialVehicle;
    if (vehicle != null) {
      modelYearController.text =
          _readVehicleValue([
            vehicle['year'],
            vehicle['model_year'],
            vehicle['modelYear'],
          ]) ??
          '';
      registrationController.text =
          _readVehicleValue([
            vehicle['plate_number'],
            vehicle['registration_number'],
            vehicle['registrationNumber'],
            vehicle['plateNumber'],
          ]) ??
          '';
      engineController.text =
          _readVehicleValue([
            vehicle['engine_number'],
            vehicle['engineNumber'],
          ]) ??
          '';
      chassisController.text =
          _readVehicleValue([
            vehicle['vin'],
            vehicle['chassis_number'],
            vehicle['chassisNumber'],
          ]) ??
          '';
      odometerController.text =
          _readVehicleValue([
            vehicle['odometer'],
            vehicle['odometer_reading'],
            vehicle['odometerReading'],
          ]) ??
          '';

      selectedBrand = _readVehicleObject(
        vehicle,
        nameKeys: const ['brand_name', 'brandName'],
        objectKeys: const ['brand', 'brand_id', 'brandId'],
      );
      selectedBodyType = _readVehicleObject(
        vehicle,
        nameKeys: const [
          'body_type_name',
          'bodyTypeName',
          'body_type',
          'bodyType',
        ],
        objectKeys: const ['body_type', 'bodyType'],
      );
      selectedModel = _readVehicleObject(
        vehicle,
        nameKeys: const ['model_name', 'modelName'],
        objectKeys: const ['model', 'vehicle_model', 'vehicleModel'],
      );
      selectedModelId = _readVehicleValue([
        vehicle['model_id'],
        vehicle['modelId'],
        vehicle['vehicle_model_id'],
        vehicle['vehicleModelId'],
        _nestedVehicleValue(
          vehicle,
          const ['model', 'vehicle_model', 'vehicleModel'],
          const ['_id', 'id', 'model_id', 'modelId'],
        ),
      ]);
      selectedVariant = _readVehicleObject(
        vehicle,
        nameKeys: const ['variant_name', 'variantName'],
        objectKeys: const ['variant', 'vehicle_variant', 'vehicleVariant'],
      );
      selectedFuelType = _readVehicleObject(
        vehicle,
        nameKeys: const [
          'fuel_type_name',
          'fuelTypeName',
          'fuel_type',
          'fuelType',
        ],
        objectKeys: const [
          'fuel_type',
          'fuelType',
          'fuel_type_id',
          'fuelTypeId',
        ],
      );
      selectedTransmission = _readVehicleObject(
        vehicle,
        nameKeys: const [
          'transmission_name',
          'transmissionName',
          'transmission',
          'transmission_type',
        ],
        objectKeys: const ['transmission', 'transmission_id', 'transmissionId'],
      );
      selectedCountrySpec = _readVehicleObject(
        vehicle,
        nameKeys: const [
          'country_spec_name',
          'countrySpecName',
          'country_spec',
          'countrySpec',
        ],
        objectKeys: const ['country_spec', 'countrySpec'],
      );
      selectedCountrySpecId = _readVehicleValue([
        vehicle['country_spec_id'],
        vehicle['countrySpecId'],
        _nestedVehicleValue(
          vehicle,
          const ['country_spec', 'countrySpec'],
          const ['_id', 'id', 'country_spec_id', 'countrySpecId'],
        ),
      ]);
    }

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      context.read<BrandBloc>().add(BrandsFetchRequested());
      context.read<FuelTypeBloc>().add(FuelTypesFetchRequested());
      context.read<TransmissionBloc>().add(TransmissionFetchRequested());
      context.read<VehicleModelBloc>().add(VehicleModelFetchRequested());
      context.read<CountrySpecBloc>().add(const CountrySpecFetchRequested());
      context.read<VehicleVarientsBloc>().add(
        VehicleVarientsFetchRequested(page: 1, limit: 100),
      );
    });
  }

  /// Returns the first non-empty value, including values inside nested maps.
  String? _readVehicleValue(List<dynamic> values) {
    for (final value in values) {
      if (value == null) continue;
      if (value is Map) {
        final nested =
            value['name'] ??
            value['title'] ??
            value['value'] ??
            value['_id'] ??
            value['id'];
        if (nested != null && nested.toString().trim().isNotEmpty) {
          return nested.toString().trim();
        }
        continue;
      }
      final text = value.toString().trim();
      if (text.isNotEmpty && text != 'null') return text;
    }
    return null;
  }

  dynamic _nestedVehicleValue(
    Map<String, dynamic> vehicle,
    List<String> objectKeys,
    List<String> valueKeys,
  ) {
    for (final key in objectKeys) {
      final value = vehicle[key];
      if (value is Map) {
        for (final valueKey in valueKeys) {
          final nested = value[valueKey];
          if (nested != null && nested.toString().trim().isNotEmpty) {
            return nested;
          }
        }
      }
    }
    return null;
  }

  /// Reads a dropdown display value from either a direct field or nested object.
  String? _readVehicleObject(
    Map<String, dynamic> vehicle, {
    required List<String> nameKeys,
    required List<String> objectKeys,
  }) {
    for (final key in nameKeys) {
      final value = vehicle[key];
      if (value == null) continue;
      if (value is Map) {
        final name =
            value['name'] ??
            value['title'] ??
            value['value'] ??
            value['variant_name'] ??
            value['variantName'];
        if (name != null && name.toString().trim().isNotEmpty) {
          return name.toString().trim();
        }
      } else {
        final text = value.toString().trim();
        if (text.isNotEmpty && text != 'null') return text;
      }
    }
    for (final key in objectKeys) {
      final value = vehicle[key];
      if (value is Map) {
        final name =
            value['name'] ??
            value['title'] ??
            value['value'] ??
            value['variant_name'] ??
            value['variantName'];
        if (name != null && name.toString().trim().isNotEmpty) {
          return name.toString().trim();
        }
      } else if (value != null && nameKeys.contains(key)) {
        final text = value.toString().trim();
        if (text.isNotEmpty && text != 'null') return text;
      }
    }
    return null;
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

  void _showMessage(String message) {
    if (!mounted) return;
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(message)));
  }

  Future<void> _createVehicle() async {
    if (isCreatingVehicle) return;

    if (widget.customerId.trim().isEmpty) {
      _showMessage('Customer ID is missing');
      return;
    }
    if (isEditMode && widget.vehicleId!.trim().isEmpty) {
      _showMessage('Vehicle ID is missing');
      return;
    }

    if (selectedBrand == null ||
        selectedBodyType == null ||
        selectedModel == null ||
        selectedVariant == null ||
        selectedFuelType == null ||
        selectedTransmission == null ||
        selectedCountrySpecId == null ||
        selectedCountrySpecId!.trim().isEmpty ||
        modelYearController.text.trim().isEmpty ||
        registrationController.text.trim().isEmpty ||
        engineController.text.trim().isEmpty ||
        chassisController.text.trim().isEmpty ||
        odometerController.text.trim().isEmpty) {
      _showMessage('Please fill all vehicle information');
      return;
    }

    final year = int.tryParse(modelYearController.text.trim());
    final odometer = int.tryParse(odometerController.text.trim());
    if (year == null || year < 1900 || year > 2100) {
      _showMessage('Please enter a valid model year');
      return;
    }
    if (odometer == null || odometer < 0) {
      _showMessage('Please enter a valid odometer reading');
      return;
    }

    final brandState = context.read<BrandBloc>().state;
    final modelState = context.read<VehicleModelBloc>().state;
    final variantState = context.read<VehicleVarientsBloc>().state;
    final fuelState = context.read<FuelTypeBloc>().state;
    final transmissionState = context.read<TransmissionBloc>().state;
    final countrySpecState = context.read<CountrySpecBloc>().state;

    if (brandState is! BrandSuccess ||
        modelState is! VehicleModelSuccess ||
        variantState is! VehicleVarientsSuccess ||
        fuelState is! FuelTypeSuccess ||
        transmissionState is! TransmissionSuccess ||
        countrySpecState is! CountrySpecSuccess) {
      _showMessage('Please wait until all dropdown data is loaded');
      return;
    }

    final brands = brandState.brandResponse.data;
    final models = modelState.vehicleModelResponse.data ?? [];
    final variants = variantState.response.data ?? [];
    final fuelTypes = fuelState.fuelTypesResponse.data ?? [];
    final transmissions = transmissionState.transmissionResponse.data ?? [];

    if (!brands.any((e) => e.name == selectedBrand) ||
        !models.any((e) => e.name == selectedModel) ||
        !fuelTypes.any((e) => e.name == selectedFuelType) ||
        !transmissions.any((e) => e.name == selectedTransmission)) {
      _showMessage('Unable to find the selected dropdown data');
      return;
    }

    final matchingVariants = variants.where(
      (e) =>
          e.modelId == selectedModelId &&
          e.variantName?.trim() == selectedVariant,
    );
    if (matchingVariants.isEmpty) {
      _showMessage('Unable to find the selected vehicle variant');
      return;
    }

    final variantId = matchingVariants.first.id;
    final fuelTypeId = fuelTypes
        .firstWhere((e) => e.name == selectedFuelType)
        .id;
    final transmissionId = transmissions
        .firstWhere((e) => e.name == selectedTransmission)
        .id;

    if (variantId == null ||
        variantId.trim().isEmpty ||
        fuelTypeId == null ||
        transmissionId == null) {
      _showMessage('An ID is missing from the selected dropdown data');
      return;
    }

    final Map<String, dynamic> requestBody = {
      'variant_id': variantId,
      'year': year,
      'plate_number': registrationController.text.trim(),
      'engine_number': engineController.text.trim(),
      'vin': chassisController.text.trim(),
      'fuel_type_id': fuelTypeId,
      'transmission_id': transmissionId,
      'country_spec': selectedCountrySpecId,
      'odometer': odometer,
    };

    debugPrint(
      '${isEditMode ? 'UPDATE' : 'CREATE'} customer: ${widget.customerId}',
    );
    debugPrint('Vehicle request body: $requestBody');

    setState(() => isCreatingVehicle = true);
    if (isEditMode) {
      context.read<UpdateVehicleInfoBloc>().add(
        UpdateVehicleInfoRequested(
          customerId: widget.customerId,
          vehicleId: widget.vehicleId!,
          vehicleData: requestBody,
        ),
      );
    } else {
      context.read<CustomerVehicleCreateBloc>().add(
        CreateCustomerVehicleRequested(
          customerId: widget.customerId,
          body: requestBody,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<UpdateVehicleInfoBloc, UpdateVehicleInfoState>(
      listener: (context, state) {
        if (!mounted) return;
        if (state is UpdateVehicleInfoLoading) {
          setState(() => isCreatingVehicle = true);
        } else if (state is UpdateVehicleInfoSuccess) {
          setState(() => isCreatingVehicle = false);
          _showMessage(
            state.response.message ?? 'Vehicle updated successfully',
          );
          Navigator.pop(context, true);
        } else if (state is UpdateVehicleInfoFailure) {
          setState(() => isCreatingVehicle = false);
          _showMessage(state.message);
        }
      },
      child: BlocListener<CustomerVehicleCreateBloc, CustomerVehicleCreateState>(
        listener: (context, state) {
          if (!mounted) return;
          if (state.status == CustomerVehicleCreateStatus.loading) {
            setState(() => isCreatingVehicle = true);
          } else if (state.status == CustomerVehicleCreateStatus.success) {
            setState(() => isCreatingVehicle = false);
            _showMessage(
              state.response?.message ?? 'Vehicle created successfully',
            );

            final id = state.response?.data?.id?.toString();
            if (id == null || id.isEmpty) {
              _showMessage('Vehicle created, but vehicle ID was not returned');
              return;
            }
            showModalBottomSheet(
              context: context,
              isScrollControlled: true,
              backgroundColor: Colors.transparent,
              builder: (sheetContext) => SelectInspectionBottomSheet(
                onFullInspectionTap: () => Navigator.pop(sheetContext),
                vehicleid: id,
                customerid: widget.customerId,
              ),
            );
          } else if (state.status == CustomerVehicleCreateStatus.failure) {
            setState(() => isCreatingVehicle = false);
            _showMessage(state.errorMessage ?? 'Failed to create vehicle');
          }
        },
        child: Scaffold(
          backgroundColor: Colors.white,
          body: SafeArea(
            child: Column(
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
                    padding: EdgeInsets.fromLTRB(10.w, 12.h, 10.w, 15.h),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(height: 20.h),
                        _buildProgressIndicator(),
                        SizedBox(height: 20.h),
                        Text(
                          'Vehicle Information',
                          style: TextStyle(
                            fontFamily: 'Manrope',
                            fontWeight: FontWeight.w700,
                            fontSize: 18.sp,
                            color: const Color(0xFF111111),
                          ),
                        ),
                        SizedBox(height: 18.h),
                        _label('Brand'),
                        SizedBox(height: 8.h),
                        BlocBuilder<BrandBloc, BrandState>(
                          builder: (context, state) {
                            if (state is BrandLoading) {
                              return _dropdown(
                                'Loading brands...',
                                null,
                                const [],
                                (_) {},
                              );
                            }
                            if (state is BrandFailure) {
                              return _retry(
                                'Unable to load brands',
                                () => context.read<BrandBloc>().add(
                                  BrandsFetchRequested(),
                                ),
                              );
                            }
                            if (state is BrandSuccess) {
                              final names = state.brandResponse.data
                                  .map((e) => e.name)
                                  .whereType<String>()
                                  .where((e) => e.trim().isNotEmpty)
                                  .toSet()
                                  .toList();
                              return _dropdown(
                                names.isEmpty
                                    ? 'No brands available'
                                    : 'Select car brand',
                                names.contains(selectedBrand)
                                    ? selectedBrand
                                    : null,
                                names,
                                (v) => setState(() => selectedBrand = v),
                              );
                            }
                            return _dropdown(
                              'Select car brand',
                              null,
                              const [],
                              (_) {},
                            );
                          },
                        ),
                        SizedBox(height: 18.h),
                        _label('Body type'),
                        SizedBox(height: 8.h),
                        _dropdown(
                          'Select body type',
                          const [
                                'Sedan',
                                'SUV',
                                'Hatchback',
                                'Coupe',
                                'Pickup',
                              ].contains(selectedBodyType)
                              ? selectedBodyType
                              : null,
                          const [
                            'Sedan',
                            'SUV',
                            'Hatchback',
                            'Coupe',
                            'Pickup',
                          ],
                          (v) => setState(() => selectedBodyType = v),
                        ),
                        SizedBox(height: 18.h),
                        _label('Model'),
                        SizedBox(height: 8.h),
                        BlocBuilder<VehicleModelBloc, VehicleModelState>(
                          builder: (context, state) {
                            if (state is VehicleModelLoading) {
                              return _dropdown(
                                'Loading models...',
                                null,
                                const [],
                                (_) {},
                              );
                            }
                            if (state is VehicleModelFailure) {
                              return _retry(
                                'Unable to load vehicle models',
                                () => context.read<VehicleModelBloc>().add(
                                  VehicleModelFetchRequested(),
                                ),
                              );
                            }
                            if (state is VehicleModelSuccess) {
                              final models =
                                  state.vehicleModelResponse.data ?? [];
                              final names = models
                                  .map((e) => e.name)
                                  .whereType<String>()
                                  .where((e) => e.trim().isNotEmpty)
                                  .toSet()
                                  .toList();
                              // If initial model name is supplied, restore its model ID.
                              final preselected = models
                                  .where((e) => e.name == selectedModel)
                                  .toList();
                              if (selectedModelId == null &&
                                  preselected.isNotEmpty) {
                                selectedModelId = preselected.first.id;
                              }
                              return _dropdown(
                                names.isEmpty
                                    ? 'No models available'
                                    : 'Select model',
                                names.contains(selectedModel)
                                    ? selectedModel
                                    : null,
                                names,
                                (v) {
                                  final found = models
                                      .where((e) => e.name == v)
                                      .toList();
                                  setState(() {
                                    selectedModel = v;
                                    selectedModelId = found.isNotEmpty
                                        ? found.first.id
                                        : null;
                                    selectedVariant = null;
                                  });
                                },
                              );
                            }
                            return _dropdown(
                              'Select model',
                              null,
                              const [],
                              (_) {},
                            );
                          },
                        ),
                        SizedBox(height: 18.h),
                        _label('Variant'),
                        SizedBox(height: 8.h),
                        BlocBuilder<VehicleVarientsBloc, VehicleVarientsState>(
                          builder: (context, state) {
                            if (state is VehicleVarientsLoading) {
                              return _dropdown(
                                'Loading variants...',
                                null,
                                const [],
                                (_) {},
                              );
                            }
                            if (state is VehicleVarientsFailure) {
                              return _retry(
                                'Unable to load vehicle variants',
                                () => context.read<VehicleVarientsBloc>().add(
                                  VehicleVarientsFetchRequested(
                                    page: 1,
                                    limit: 100,
                                  ),
                                ),
                              );
                            }
                            if (state is VehicleVarientsSuccess) {
                              final variants = state.response.data ?? [];
                              final matching = variants.where(
                                (e) => e.modelId == selectedModelId,
                              );
                              final names = matching
                                  .map((e) => e.variantName?.trim())
                                  .whereType<String>()
                                  .where((e) => e.isNotEmpty)
                                  .toSet()
                                  .toList();
                              return _dropdown(
                                selectedModelId == null
                                    ? 'Select model first'
                                    : names.isEmpty
                                    ? 'No variants available for this model'
                                    : 'Select variant',
                                names.contains(selectedVariant)
                                    ? selectedVariant
                                    : null,
                                names,
                                (v) => setState(() => selectedVariant = v),
                              );
                            }
                            return _dropdown(
                              'Select variant',
                              null,
                              const [],
                              (_) {},
                            );
                          },
                        ),
                        SizedBox(height: 18.h),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              child: _smallField(
                                'Model Year',
                                'YYYY',
                                modelYearController,
                              ),
                            ),
                            SizedBox(width: 8.w),
                            Expanded(
                              child: _smallField(
                                'Registration Number',
                                '000000000',
                                registrationController,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 18.h),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              child: _smallField(
                                'Engine Number',
                                '00000000000',
                                engineController,
                              ),
                            ),
                            SizedBox(width: 8.w),
                            Expanded(
                              child: _smallField(
                                'Chasis Number',
                                '000000000000',
                                chassisController,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 18.h),
                        _label('Fuel type'),
                        SizedBox(height: 8.h),
                        BlocBuilder<FuelTypeBloc, FuelTypeState>(
                          builder: (context, state) {
                            if (state is FuelTypeLoading) {
                              return _dropdown(
                                'Loading fuel types...',
                                null,
                                const [],
                                (_) {},
                              );
                            }
                            if (state is FuelTypeFailure) {
                              return _retry(
                                'Unable to load fuel types',
                                () => context.read<FuelTypeBloc>().add(
                                  FuelTypesFetchRequested(),
                                ),
                              );
                            }
                            if (state is FuelTypeSuccess) {
                              final types = state.fuelTypesResponse.data ?? [];
                              final names = types
                                  .map((e) => e.name)
                                  .whereType<String>()
                                  .where((e) => e.trim().isNotEmpty)
                                  .toSet()
                                  .toList();
                              return _dropdown(
                                names.isEmpty
                                    ? 'No fuel types available'
                                    : 'Select Fuel type',
                                names.contains(selectedFuelType)
                                    ? selectedFuelType
                                    : null,
                                names,
                                (v) => setState(() => selectedFuelType = v),
                              );
                            }
                            return _dropdown(
                              'Select Fuel type',
                              null,
                              const [],
                              (_) {},
                            );
                          },
                        ),
                        SizedBox(height: 18.h),
                        _label('Transmission'),
                        SizedBox(height: 8.h),
                        BlocBuilder<TransmissionBloc, TransmissionState>(
                          builder: (context, state) {
                            if (state is TransmissionLoading) {
                              return _dropdown(
                                'Loading transmissions...',
                                null,
                                const [],
                                (_) {},
                              );
                            }
                            if (state is TransmissionFailure) {
                              return _retry(
                                'Unable to load transmissions',
                                () => context.read<TransmissionBloc>().add(
                                  TransmissionFetchRequested(),
                                ),
                              );
                            }
                            if (state is TransmissionSuccess) {
                              final items =
                                  state.transmissionResponse.data ?? [];
                              final names = items
                                  .map((e) => e.name)
                                  .whereType<String>()
                                  .where((e) => e.trim().isNotEmpty)
                                  .toSet()
                                  .toList();
                              return _dropdown(
                                names.isEmpty
                                    ? 'No transmissions available'
                                    : 'Select Transmission type',
                                names.contains(selectedTransmission)
                                    ? selectedTransmission
                                    : null,
                                names,
                                (v) => setState(() => selectedTransmission = v),
                              );
                            }
                            return _dropdown(
                              'Select Transmission type',
                              null,
                              const [],
                              (_) {},
                            );
                          },
                        ),
                        SizedBox(height: 18.h),
                        _label('Country Spec'),
                        SizedBox(height: 8.h),
                        BlocBuilder<CountrySpecBloc, CountrySpecState>(
                          builder: (context, state) {
                            if (state is CountrySpecLoading) {
                              return _dropdown(
                                'Loading country specifications...',
                                null,
                                const [],
                                (_) {},
                              );
                            }

                            if (state is CountrySpecFailure) {
                              return _retry(
                                'Unable to load country specifications',
                                () => context.read<CountrySpecBloc>().add(
                                  const CountrySpecFetchRequested(),
                                ),
                              );
                            }

                            if (state is CountrySpecSuccess) {
                              final specs =
                                  state.countrySpecResponse.data ?? [];
                              final validSpecs = specs
                                  .where(
                                    (spec) =>
                                        spec.id != null &&
                                        spec.id!.trim().isNotEmpty &&
                                        spec.name != null &&
                                        spec.name!.trim().isNotEmpty,
                                  )
                                  .toList();

                              final names = validSpecs
                                  .map((spec) => spec.name!.trim())
                                  .toSet()
                                  .toList();

                              final selectedIsValid = validSpecs.any(
                                (spec) =>
                                    spec.id == selectedCountrySpecId &&
                                    spec.name!.trim() == selectedCountrySpec,
                              );

                              return _dropdown(
                                names.isEmpty
                                    ? 'No country specifications available'
                                    : 'Select Country Spec',
                                selectedIsValid ? selectedCountrySpec : null,
                                names,
                                (value) {
                                  if (value == null) return;
                                  final matches = validSpecs
                                      .where(
                                        (spec) => spec.name!.trim() == value,
                                      )
                                      .toList();

                                  setState(() {
                                    selectedCountrySpec = value;
                                    selectedCountrySpecId = matches.isNotEmpty
                                        ? matches.first.id
                                        : null;
                                  });
                                },
                              );
                            }

                            return _dropdown(
                              'Select Country Spec',
                              null,
                              const [],
                              (_) {},
                            );
                          },
                        ),
                        SizedBox(height: 18.h),
                        _label('Odometer reading'),
                        SizedBox(height: 8.h),
                        _textField('Enter km', odometerController),
                        SizedBox(height: 9.h),
                        _buildAttachPhoto(),
                        SizedBox(height: 10.h),
                      ],
                    ),
                  ),
                ),
                _buildBottomButtons(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _retry(String message, VoidCallback retry) => Column(
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
      TextButton(onPressed: retry, child: const Text('Retry')),
    ],
  );

  Widget _label(String text) => Text(
    text,
    style: TextStyle(
      fontFamily: 'Manrope',
      fontWeight: FontWeight.w500,
      fontSize: 16.sp,
      color: const Color(0xFF222222),
    ),
  );

  Widget _dropdown(
    String hint,
    String? value,
    List<String> items,
    ValueChanged<String?> onChanged,
  ) {
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
          hint: Text(
            hint,
            style: TextStyle(
              fontFamily: 'Manrope',
              fontSize: 12.sp,
              color: const Color(0xFF555555),
            ),
          ),
          icon: Icon(
            Icons.keyboard_arrow_down_rounded,
            size: 24.sp,
            color: const Color(0xFF111111),
          ),
          dropdownColor: Colors.white,
          borderRadius: BorderRadius.circular(12.r),
          items: items
              .map(
                (item) => DropdownMenuItem<String>(
                  value: item,
                  child: Text(
                    item,
                    style: TextStyle(
                      fontFamily: 'Manrope',
                      fontSize: 13.sp,
                      color: const Color(0xFF222222),
                    ),
                  ),
                ),
              )
              .toList(),
          onChanged: onChanged,
        ),
      ),
    );
  }

  Widget _smallField(
    String label,
    String hint,
    TextEditingController controller,
  ) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      _label(label),
      SizedBox(height: 8.h),
      _textField(hint, controller),
    ],
  );

  Widget _textField(String hint, TextEditingController controller) => Container(
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
        color: const Color(0xFF222222),
      ),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: TextStyle(
          fontFamily: 'Manrope',
          fontSize: 12.sp,
          color: const Color(0xFF666666),
        ),
        contentPadding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 10.h),
        border: InputBorder.none,
        enabledBorder: InputBorder.none,
        focusedBorder: InputBorder.none,
      ),
    ),
  );

  Widget _buildAttachPhoto() => GestureDetector(
    onTap: _pickImage,
    child: Container(
      width: 139.w,
      height: 100.h,
      padding: EdgeInsets.all(8.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: const Color(0xFFD1D1D1), width: 1.w),
      ),
      child: selectedImage != null
          ? ClipRRect(
              borderRadius: BorderRadius.circular(8.r),
              child: Image.file(
                selectedImage!,
                fit: BoxFit.cover,
                width: double.infinity,
                height: double.infinity,
              ),
            )
          : Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.photo_camera_outlined,
                  size: 24.sp,
                  color: const Color(0xFF222222),
                ),
                SizedBox(height: 5.h),
                Text(
                  'Attach photo',
                  style: TextStyle(
                    fontFamily: 'Manrope',
                    fontWeight: FontWeight.w500,
                    fontSize: 12.sp,
                    color: const Color(0xFF222222),
                  ),
                ),
              ],
            ),
    ),
  );

  Widget _buildBottomButtons() => Container(
    width: double.infinity,
    color: Colors.white,
    padding: EdgeInsets.only(left: 12.w, right: 12.w, top: 8.h, bottom: 10.h),
    child: Row(
      children: [
        SizedBox(
          width: 94.w,
          height: 52.h,
          child: OutlinedButton(
            onPressed: isCreatingVehicle ? null : () => Navigator.pop(context),
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
              onPressed: isCreatingVehicle ? null : _createVehicle,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF73F700),
                disabledBackgroundColor: const Color(0xFF73F700),
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(46.r),
                ),
                padding: EdgeInsets.zero,
              ),
              child: isCreatingVehicle
                  ? SizedBox(
                      width: 22.w,
                      height: 22.w,
                      child: const CircularProgressIndicator(
                        color: Colors.black,
                        strokeWidth: 2,
                      ),
                    )
                  : Text(
                      isEditMode ? 'Update Vehicle' : 'Continue',
                      style: TextStyle(
                        fontFamily: 'Source Code Pro',
                        fontWeight: FontWeight.w600,
                        fontSize: 16.sp,
                        color: Colors.black,
                      ),
                    ),
            ),
          ),
        ),
      ],
    ),
  );

  Widget _buildProgressIndicator() {
    const steps = ['Vehicle Info', 'Brake', 'Rims', 'Brake'];
    return Padding(
      padding: EdgeInsets.only(left: 15.w),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        physics: const NeverScrollableScrollPhysics(),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: List.generate(steps.length, (index) {
            final isLast = index == steps.length - 1;
            final isSelected = index == 0;
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

  Future<void> _pickImage() async {
    try {
      final image = await _picker.pickImage(source: ImageSource.gallery);
      if (image != null && mounted) {
        setState(() => selectedImage = File(image.path));
      }
    } catch (e) {
      _showMessage('Unable to select image');
      debugPrint('Image picker error: $e');
    }
  }
}
