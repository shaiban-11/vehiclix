import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:rootysysproject/bloc/Brands/bloc/brands_bloc.dart';
import 'package:rootysysproject/bloc/Fuel/bloc/fueltype_bloc.dart';
import 'package:rootysysproject/bloc/Transmission/bloc/transmission_bloc.dart';
import 'package:rootysysproject/bloc/country_spec.dart/bloc/countryspec_bloc.dart';
import 'package:rootysysproject/bloc/createcustomervehicle/bloc/createcustomervehicle_bloc.dart';
import 'package:rootysysproject/bloc/customer/bloc/customer_bloc.dart';
import 'package:rootysysproject/bloc/customer_vehicle/bloc/customervehicle_bloc.dart';
import 'package:rootysysproject/bloc/customerprofile/bloc/customerprofile_bloc.dart';
import 'package:rootysysproject/bloc/customervehicledeletion/bloc/customervehicledeletion_bloc.dart';
import 'package:rootysysproject/bloc/draftinspection/bloc/draft_inspection_bloc.dart';
import 'package:rootysysproject/bloc/draftinspection/bloc/draft_inspection_event.dart';
import 'package:rootysysproject/bloc/homestats/bloc/homestats_bloc.dart';
import 'package:rootysysproject/bloc/inspectioncategories/bloc/inspectioncategories_bloc.dart';
import 'package:rootysysproject/bloc/inspectiondetail/bloc/inspectiondetail_bloc.dart';
import 'package:rootysysproject/bloc/inspectiontype/bloc/inspectiontype_bloc.dart';
import 'package:rootysysproject/bloc/login/bloc/login_bloc.dart';
import 'package:rootysysproject/bloc/submitinspection/bloc/submitinspection_bloc.dart';
import 'package:rootysysproject/bloc/updatecustomer/bloc/updatecustomer_bloc.dart';
import 'package:rootysysproject/bloc/updatevehicleinfo/bloc/updatevehicleinfo_bloc.dart';
import 'package:rootysysproject/bloc/user/bloc/user_bloc.dart';
import 'package:rootysysproject/bloc/vehicle_model/bloc/vehicle_model_bloc.dart';
import 'package:rootysysproject/bloc/vehicle_varients/bloc/vehicle_varients_bloc.dart';

import 'package:rootysysproject/repositories/Api/Transmission_api.dart';
import 'package:rootysysproject/repositories/Api/api_client.dart';
import 'package:rootysysproject/repositories/Api/brand_api.dart';
import 'package:rootysysproject/repositories/Api/ceratecustomervehicle_api.dart';
import 'package:rootysysproject/repositories/Api/counteryspec_api.dart';
import 'package:rootysysproject/repositories/Api/customerprofile_api.dart';
import 'package:rootysysproject/repositories/Api/customervehicledelete_api.dart';
import 'package:rootysysproject/repositories/Api/cutomer_api.dart';
import 'package:rootysysproject/repositories/Api/customervehicle_api.dart';
import 'package:rootysysproject/repositories/Api/draftinpsection_api.dart';
import 'package:rootysysproject/repositories/Api/fuel_api.dart';
import 'package:rootysysproject/repositories/Api/homestats_api.dart';
import 'package:rootysysproject/repositories/Api/inspectictioncategories_api.dart';
import 'package:rootysysproject/repositories/Api/inspectiondetails_api.dart';
import 'package:rootysysproject/repositories/Api/inspectiontype_api.dart';
import 'package:rootysysproject/repositories/Api/login_api.dart';
import 'package:rootysysproject/repositories/Api/User_api.dart';
import 'package:rootysysproject/repositories/Api/submitinspection_api.dart';
import 'package:rootysysproject/repositories/Api/updatecustomer_api.dart';
import 'package:rootysysproject/repositories/Api/updatevehicleinfo_api.dart';
import 'package:rootysysproject/repositories/Api/vehiclemodel_api.dart';
import 'package:rootysysproject/repositories/Api/vehiclevarients_api.dart';

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
        final apiClient = ApiClient();

        return MultiBlocProvider(
          providers: [
            BlocProvider<InspectionSubmitBloc>(
              create: (_) => InspectionSubmitBloc(
                repository: InspectionSubmitRepo(apiClient: ApiClient()),
              ),
            ),
            BlocProvider<LoginBloc>(
              create: (_) => LoginBloc(LoginApi(apiClient)),
            ),

            BlocProvider<UserBloc>(
              create: (_) => UserBloc(
                userRepository: UserRepository(apiClient: apiClient),
              ),
            ),
            BlocProvider(
              create: (context) => VehicleInspectionBloc(
                repository: VehicleInspectionRepository(apiClient: ApiClient()),
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
            BlocProvider<CustomerProfileBloc>(
              create: (_) =>
                  CustomerProfileBloc(CustomerProfileRepo(apiClient)),
            ),

            BlocProvider(
              create: (context) => InspectionBloc(
                repository: InspectionRepository(apiClient: apiClient),
              ),
            ),

            BlocProvider(
              create: (context) => InspectionDetailsBloc(
                repository: InspectionDetailsRepository(apiClient: apiClient),
              ),
            ),

            BlocProvider<VehicleVarientsBloc>(
              create: (_) => VehicleVarientsBloc(
                repository: VehicleVarientsRepository(apiClient: apiClient),
              ),
            ),
            BlocProvider(
              create: (context) => DraftInspectionBloc(
                repository: DraftInspectionRepository(apiClient: ApiClient()),
              )..add(FetchDraftInspections(page: 1, limit: 10)),
            ),
            BlocProvider(
              create: (context) => CustomerVehicleDeleteBloc(
                repository: CustomerVehicleDeleteRepository(
                  apiClient: ApiClient(),
                ),
              ),
            ),
            BlocProvider(
              create: (context) => CountrySpecBloc(
                countrySpecRepository: CountrySpecRepository(
                  apiClient: ApiClient(),
                ),
              ),
            ),
            BlocProvider<UpdateVehicleInfoBloc>(
              create: (_) => UpdateVehicleInfoBloc(
                repository: UpdateVehicleInfoRepository(apiClient: apiClient),
                apiClient: apiClient,
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
              create: (context) => CustomerVehicleCreateBloc(
                repository: CustomerVehicleCreateRepository(
                  apiClient: ApiClient(),
                ),
              ),
            ),
            BlocProvider(
              create: (context) => CustomerUpdateBloc(
                repository: CustomerUpdateRepository(apiClient: apiClient),
              ),
            ),

            BlocProvider<HomeStatsBloc>(
              create: (_) => HomeStatsBloc(
                repository: HomeStatsRepository(apiClient: apiClient),
              ),
            ),

            BlocProvider<CustomerVehicleBloc>(
              create: (_) =>
                  CustomerVehicleBloc(CustomerVehicleRepo(apiClient)),
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
