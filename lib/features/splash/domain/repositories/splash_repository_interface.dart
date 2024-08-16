

import 'package:get/get_connect/http/src/response/response.dart';
import 'package:ride_sharing_user_app/interface/repository_interface.dart';

abstract class SplashRepositoryInterface implements RepositoryInterface{

  Future<Response> getConfigData();
  Future<bool> initSharedData();
  Future<bool> removeSharedData();
}