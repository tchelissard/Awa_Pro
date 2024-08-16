import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ride_sharing_user_app/features/profile/controllers/profile_controller.dart';
import 'package:ride_sharing_user_app/features/profile/screens/profile_screen.dart';
import 'package:ride_sharing_user_app/helper/display_helper.dart';
import 'package:ride_sharing_user_app/helper/pusher_helper.dart';
import 'package:ride_sharing_user_app/localization/localization_controller.dart';
import 'package:ride_sharing_user_app/util/dimensions.dart';
import 'package:ride_sharing_user_app/util/images.dart';
import 'package:ride_sharing_user_app/features/home/widgets/add_vehicle_design_widget.dart';
import 'package:ride_sharing_user_app/features/home/widgets/custom_menu/custom_menu_button_widget.dart';
import 'package:ride_sharing_user_app/features/home/widgets/custom_menu/custom_menu_widget.dart';
import 'package:ride_sharing_user_app/features/home/widgets/my_activity_list_view_widget.dart';
import 'package:ride_sharing_user_app/features/home/widgets/ongoing_parcel_list_view_widget.dart';
import 'package:ride_sharing_user_app/features/home/widgets/ongoing_ride_card_widget.dart';
import 'package:ride_sharing_user_app/features/home/widgets/profile_info_card_widget.dart';
import 'package:ride_sharing_user_app/features/home/widgets/vehicle_pending_widget.dart';
import 'package:ride_sharing_user_app/features/profile/screens/profile_menu_screen.dart';
import 'package:ride_sharing_user_app/features/ride/controllers/ride_controller.dart';
import 'package:ride_sharing_user_app/common_widgets/app_bar_widget.dart';
import 'package:ride_sharing_user_app/common_widgets/sliver_delegate.dart';
import 'package:ride_sharing_user_app/common_widgets/zoom_drawer_context_widget.dart';


class HomeMenu extends GetView<ProfileController> {
  const HomeMenu({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ProfileController>(
      builder: (_) => ZoomDrawer(
        controller: _.zoomDrawerController,
        menuScreen: const ProfileMenuScreen(),
        mainScreen: const HomeScreen(),
        borderRadius: 24.0,
        isRtl: !Get.find<LocalizationController>().isLtr,
        angle: -5.0,
        menuBackgroundColor: Theme.of(context).primaryColor,
        slideWidth: MediaQuery.of(context).size.width * 0.85,
        mainScreenScale: .4,
        mainScreenTapClose: true,
      ),
    );
  }
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool clickedMenu = false;
  @override
  void initState() {
    loadData();
    super.initState();
  }
  Future<void> loadData() async{
    Get.find<ProfileController>().getCategoryList(1);
    Get.find<ProfileController>().getDailyLog();
    Get.find<RideController>().getOngoingParcelList();
    Get.find<ProfileController>().getProfileLevelInfo();
    await Get.find<RideController>().getLastTrip();
    if(Get.find<RideController>().ongoingTripDetails != null){
      for(int i =0 ;i<Get.find<RideController>().ongoingTripDetails!.length; i++){

        List<String> data = ["ongoing","accepted"];
        if(data.contains(Get.find<RideController>().ongoingTripDetails![i].currentStatus)){
          PusherHelper().tripCancelAfterOngoing(Get.find<RideController>().ongoingTripDetails![i].id!);
          PusherHelper().tripPaymentSuccessful(Get.find<RideController>().ongoingTripDetails![i].id!);
          PusherHelper().customerCouponAppliedOrRemoved(Get.find<RideController>().ongoingTripDetails![i].id!);
        }
        if(Get.find<RideController>().ongoingTripDetails![i].currentStatus == 'completed' &&
            Get.find<RideController>().ongoingTripDetails![i].paymentStatus == 'unpaid'){
          PusherHelper().customerCouponAppliedOrRemoved(Get.find<RideController>().ongoingTripDetails![i].id!);
        }
      }
    }

    await Get.find<RideController>().getPendingRideRequestList(1,limit: 100);
    if(Get.find<RideController>().getPendingRideRequestModel != null){
      for(int i =0 ;i<Get.find<RideController>().getPendingRideRequestModel!.data!.length; i++){
        PusherHelper().customerInitialTripCancel(Get.find<RideController>().getPendingRideRequestModel!.data![i].id!,Get.find<ProfileController>().driverId);
        PusherHelper().anotherDriverAcceptedTrip(Get.find<RideController>().getPendingRideRequestModel!.data![i].id!,Get.find<ProfileController>().driverId);
        PusherHelper().customerCouponAppliedOrRemoved(Get.find<RideController>().getPendingRideRequestModel!.data![i].id!);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () async{
        Get.find<ProfileController>().getProfileInfo();
      },
      child: Scaffold(
          body: Stack(children: [
            CustomScrollView(slivers: [
              SliverPersistentHeader(pinned: true, delegate: SliverDelegate(height: 120,
                  child: Column(children: [
                    AppBarWidget(
                      title: 'dashboard'.tr, showBackButton: false,
                      onTap: (){
                        Get.find<ProfileController>().toggleDrawer();
                      },
                    ),
                  ])
              )),

              SliverToBoxAdapter(child: GetBuilder<ProfileController>(builder: (profileController) {
                return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  const SizedBox(height: 60.0),

                  if(profileController.profileInfo?.vehicle != null &&
                      profileController.profileInfo?.vehicleStatus != 0  &&
                      profileController.profileInfo?.vehicleStatus != 1
                  )
                    GetBuilder<RideController>(builder: (rideController) {
                      return const OngoingRideCardWidget();
                    }),

                  if(profileController.profileInfo?.vehicle == null && profileController.profileInfo?.vehicleStatus == 0)
                    const AddYourVehicleWidget(),

                  if(profileController.profileInfo?.vehicle != null && profileController.profileInfo?.vehicleStatus == 1)
                    VehiclePendingWidget(
                      icon: Images.reward1,
                      description: 'create_account_approve_description_vehicle'.tr,
                      title: 'registration_not_approve_yet_vehicle'.tr,
                    ),

                  if(Get.find<ProfileController>().profileInfo?.vehicle != null)
                    const MyActivityListViewWidget(),
                  const SizedBox(height: 100),
                ]);
              }))
            ]),

            Positioned(top: 90,left: 0,right: 0,
              child: GetBuilder<ProfileController>(builder: (profileController) {
                return GestureDetector(
                    onTap: (){
                      Get.to(()=> const ProfileScreen());
                    },
                    child: ProfileStatusCardWidget(profileController: profileController));
              }),
            ),
          ]),

          floatingActionButton: GetBuilder<RideController>(
              builder: (rideController) {
                int ridingCount = (rideController.ongoingTrip == null || rideController.ongoingTrip!.isEmpty) ? 0 :
                (
                    rideController.ongoingTrip![0].currentStatus == 'ongoing' ||
                        rideController.ongoingTrip![0].currentStatus == 'accepted' ||
                        (
                            rideController.ongoingTrip![0].currentStatus =='completed' &&
                                rideController.ongoingTrip![0].paymentStatus == 'unpaid'
                        ) ||
                        (
                            rideController.ongoingTrip![0].currentStatus =='cancelled' &&
                                rideController.ongoingTrip![0].paymentStatus == 'unpaid' &&
                                rideController.ongoingTrip![0].cancelledBy == 'customer'
                        ) && rideController.ongoingTrip![0].type != 'parcel'
                ) ? 1 : 0;
                int parcelCount = rideController.parcelListModel?.totalSize?? 0;
                return Padding(
                  padding: const EdgeInsets.only(bottom: 80),
                  child: CustomMenuButtonWidget(
                    openForegroundColor: Colors.white,
                    closedBackgroundColor: Theme.of(context).primaryColor,
                    openBackgroundColor: Theme.of(context).primaryColorDark,
                    labelsBackgroundColor: Theme.of(context).cardColor,
                    speedDialChildren: <CustomMenuWidget>[
                      CustomMenuWidget(
                        child: const Icon(Icons.directions_run),
                        foregroundColor: Colors.white,
                        backgroundColor: Theme.of(context).primaryColor,
                        label: 'ongoing_ride'.tr,
                        onPressed: () {
                          if(
                          rideController.ongoingTrip![0].currentStatus == 'ongoing' ||
                              rideController.ongoingTrip![0].currentStatus == 'accepted' ||
                              (
                                  rideController.ongoingTrip![0].currentStatus =='completed' &&
                                      rideController.ongoingTrip![0].paymentStatus == 'unpaid'
                              ) ||
                              (
                                  rideController.ongoingTrip![0].paidFare != "0" &&
                                      rideController.ongoingTrip![0].paymentStatus == 'unpaid'
                              )
                          ){
                            Get.find<RideController>().getCurrentRideStatus(froDetails: true);
                          }else{
                            showCustomSnackBar('no_trip_available'.tr);
                          }
                        },
                        closeSpeedDialOnPressed: false,
                      ),

                      CustomMenuWidget(
                        child: Text('${rideController.parcelListModel?.totalSize}'),
                        foregroundColor: Colors.white,
                        backgroundColor: Theme.of(context).primaryColor,
                        label: 'parcel_delivery'.tr,
                        onPressed: () {
                          if(
                          rideController.parcelListModel != null &&
                              rideController.parcelListModel!.data != null &&
                              rideController.parcelListModel!.data!.isNotEmpty
                          ){
                            Get.to(()=>  OngoingParcelListViewWidget(
                              title: 'ongoing_parcel_list',
                              parcelListModel: rideController.parcelListModel!,
                            ));

                          }else{
                            showCustomSnackBar('no_parcel_available'.tr);
                          }
                        },
                        closeSpeedDialOnPressed: false,
                      ),
                    ],
                    child: Padding(
                      padding: const EdgeInsets.all(Dimensions.paddingSizeDefault),
                      child: Badge(label: Text('${ridingCount + parcelCount}'),child: Image.asset(Images.ongoing)),
                    ),
                  ),
                );
              }
          )
      ),
    );
  }

}





