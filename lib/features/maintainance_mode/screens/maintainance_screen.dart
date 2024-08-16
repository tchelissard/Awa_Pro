import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';
import 'package:ride_sharing_user_app/helper/display_helper.dart';
import 'package:ride_sharing_user_app/util/dimensions.dart';
import 'package:ride_sharing_user_app/util/images.dart';
import 'package:ride_sharing_user_app/util/styles.dart';
import 'package:ride_sharing_user_app/features/auth/controllers/auth_controller.dart';
import 'package:ride_sharing_user_app/features/auth/screens/sign_in_screen.dart';
import 'package:ride_sharing_user_app/features/dashboard/screens/dashboard_screen.dart';
import 'package:ride_sharing_user_app/features/location/controllers/location_controller.dart';
import 'package:ride_sharing_user_app/features/profile/controllers/profile_controller.dart';
import 'package:ride_sharing_user_app/features/splash/controllers/splash_controller.dart';
import 'package:ride_sharing_user_app/common_widgets/app_bar_widget.dart';
import 'package:ride_sharing_user_app/common_widgets/button_widget.dart';

class MaintenanceScreen extends StatelessWidget {
  const MaintenanceScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBarWidget(title: 'maintenance'.tr, showBackButton: false,),

        body: GetBuilder<SplashController>(
          builder: (configController) {
            return Center(child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [

                Image.asset(Images.maintenance, width: 200, height: 200),
                Text('maintenance_mode'.tr, style: textMedium.copyWith(fontSize: 20, color: Theme.of(context).textTheme.bodyLarge!.color,)),
                const SizedBox(height: Dimensions.paddingSizeExtraSmall),
                Text('maintenance_text'.tr, textAlign: TextAlign.center, style: textRegular,),

                configController.loading? Center(child: Padding(padding: EdgeInsets.only(top: Get.width/5),
                  child: SpinKitCircle(color: Theme.of(context).primaryColor, size: 40.0,))):


                Padding(padding: EdgeInsets.all(Get.width/5),
                  child: ButtonWidget(buttonText: 'retry'.tr, onPressed: () async{
                    await Get.find<SplashController>().getConfigData(reload: true).then((value){
                      if(Get.find<SplashController>().config!.maintenanceMode != null && Get.find<SplashController>().config!.maintenanceMode!){
                        showCustomSnackBar('try_few_minute_latter'.tr);
                      }else{
                        if(Get.find<AuthController>().isLoggedIn()){
                          Get.find<ProfileController>().getProfileInfo().then((value){
                            if(value.statusCode ==200){
                              Get.find<LocationController>().getCurrentLocation().then((value){
                                Get.find<AuthController>().updateToken();
                                Get.offAll(()=> const DashboardScreen());
                              });
                            }
                          });
                        }else{Get.offAll(()=> const SignInScreen());}
                      }
                    });
                  },),
                )
              ]),
            );
          }
        ));
  }
}
