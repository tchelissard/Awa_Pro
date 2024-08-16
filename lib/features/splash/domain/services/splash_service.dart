

import 'package:ride_sharing_user_app/features/splash/domain/repositories/splash_repository_interface.dart';
import 'package:ride_sharing_user_app/features/splash/domain/services/splash_service_interface.dart';

class SplashService implements SplashServiceInterface{
 final SplashRepositoryInterface splashRepositoryInterface;
 SplashService({required this.splashRepositoryInterface});

  @override
  Future getConfigData() {
    return splashRepositoryInterface.getConfigData();
  }

  @override
  Future<bool> initSharedData() {
    return splashRepositoryInterface.initSharedData();
  }

  @override
  Future<bool> removeSharedData() {
    return splashRepositoryInterface.removeSharedData();
  }


}