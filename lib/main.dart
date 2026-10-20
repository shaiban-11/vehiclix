import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:rootysysproject/bloc/Brands/bloc/brands_bloc.dart';
import 'package:rootysysproject/bloc/Fuel/bloc/fueltype_bloc.dart';
import 'package:rootysysproject/bloc/Transmission/bloc/transmission_bloc.dart';
import 'package:rootysysproject/bloc/customer/bloc/customer_bloc.dart';
import 'package:rootysysproject/bloc/homestats/bloc/homestats_bloc.dart';

import 'package:rootysysproject/bloc/login/bloc/login_bloc.dart';
import 'package:rootysysproject/bloc/user/bloc/user_bloc.dart';
import 'package:rootysysproject/bloc/vehicle_model/bloc/vehicle_model_bloc.dart';
import 'package:rootysysproject/repositories/Api/Transmission_api.dart';

import 'package:rootysysproject/repositories/Api/api_client.dart';
import 'package:rootysysproject/repositories/Api/brand_api.dart';
import 'package:rootysysproject/repositories/Api/cutomer_api.dart';
import 'package:rootysysproject/repositories/Api/fuel_api.dart';
import 'package:rootysysproject/repositories/Api/homestats_api.dart';
import 'package:rootysysproject/repositories/Api/login_api.dart';
import 'package:rootysysproject/repositories/Api/User_api.dart';
import 'package:rootysysproject/repositories/Api/vehiclemodel_api.dart';

import 'package:rootysysproject/screens/Login_screen.dart';

void main() {
  runApp(const VehiclixApp());
}

class VehiclixApp extends StatelessWidget {
  const VehiclixApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(402, 874),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) {
        // Create ONE ApiClient shared by both APIs.
        final apiClient = ApiClient();

        return MultiBlocProvider(
          providers: [
            BlocProvider<LoginBloc>(
              create: (_) => LoginBloc(LoginApi(apiClient)),
            ),
            BlocProvider<UserBloc>(
              create: (_) => UserBloc(
                userRepository: UserRepository(apiClient: apiClient),
              ),
            ),
            BlocProvider<BrandBloc>(
              create: (_) => BrandBloc(
                brandRepository: BrandRepository(apiClient: apiClient),
              ),
            ),
            BlocProvider<FuelTypeBloc>(
              create: (_) => FuelTypeBloc(
                fuelTypeRepository: FuelTypeRepository(apiClient: apiClient),
              ),
            ),

            BlocProvider<TransmissionBloc>(
              create: (_) => TransmissionBloc(
                transmissionRepository: TransmissionRepository(
                  apiClient: apiClient,
                ),
              ),
            ),
            BlocProvider<VehicleModelBloc>(
              create: (_) => VehicleModelBloc(
                vehicleModelRepository: VehicleModelRepository(
                  apiClient: apiClient,
                ),
              ),
            ),
            BlocProvider<CustomerBloc>(
              create: (_) => CustomerBloc(
                customerRepository: CustomerRepository(apiClient: apiClient),
              ),
            ),
            BlocProvider(
              create: (context) => HomeStatsBloc(
                repository: HomeStatsRepository(apiClient: ApiClient()),
              ),
            ),
          ],
          child: MaterialApp(
            debugShowCheckedModeBanner: false,
            title: 'Vehiclix',
            theme: ThemeData(
              useMaterial3: true,
              scaffoldBackgroundColor: Colors.white,
            ),
            home: const LoginScreen(),
          ),
        );
      },
    );
  }
}
