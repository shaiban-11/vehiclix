import 'package:rootysysproject/repositories/Api/api_client.dart';
import 'package:rootysysproject/repositories/models/updatevehicleinfo_model.dart';

class UpdateVehicleInfoRepository {
  final ApiClient apiClient;

  UpdateVehicleInfoRepository({required this.apiClient});

  Future<UpdateVehicleInfoModel> updateVehicleInfo({
    required String customerId,
    required String vehicleId,
    required Map<String, dynamic> vehicleData,
  }) async {
    final response = await apiClient.updateCustomerVehicle(
      customerId: customerId,
      vehicleId: vehicleId,
      vehicleData: vehicleData,
    );

    return UpdateVehicleInfoModel.fromJson(
      Map<String, dynamic>.from(response as Map),
    );
  }
}
