import 'package:expandable_bottom_sheet/expandable_bottom_sheet.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:just_the_tooltip/just_the_tooltip.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:ride_sharing_user_app/common_widgets/button_widget.dart';
import 'package:ride_sharing_user_app/common_widgets/image_widget.dart';
import 'package:ride_sharing_user_app/common_widgets/swipable_button/slider_buttion_widget.dar.dart';
import 'package:ride_sharing_user_app/features/chat/controllers/chat_controller.dart';
import 'package:ride_sharing_user_app/features/dashboard/screens/dashboard_screen.dart';
import 'package:ride_sharing_user_app/features/map/controllers/map_controller.dart';
import 'package:ride_sharing_user_app/features/map/controllers/otp_time_count_Controller.dart';
import 'package:ride_sharing_user_app/features/map/widgets/cancelation_radio_button.dart';
import 'package:ride_sharing_user_app/features/map/widgets/otp_verification_widget.dart';
import 'package:ride_sharing_user_app/features/map/widgets/route_widget.dart';
import 'package:ride_sharing_user_app/features/ride/controllers/ride_controller.dart';
import 'package:ride_sharing_user_app/features/splash/controllers/splash_controller.dart';
import 'package:ride_sharing_user_app/features/trip/controllers/trip_controller.dart';
import 'package:ride_sharing_user_app/helper/price_converter.dart';
import 'package:ride_sharing_user_app/localization/localization_controller.dart';
import 'package:ride_sharing_user_app/util/dimensions.dart';
import 'package:ride_sharing_user_app/util/images.dart';
import 'package:ride_sharing_user_app/util/styles.dart';

class RideAcceptedWidget extends StatefulWidget {
  final GlobalKey<ExpandableBottomSheetState> expandableKey;
  const RideAcceptedWidget({super.key, required this.expandableKey});

  @override
  State<RideAcceptedWidget> createState() => _RideAcceptedWidgetState();
}

class _RideAcceptedWidgetState extends State<RideAcceptedWidget> {
  String totalDistance = '0', estDistance = '0', removeComma= '0';
  int currentState = 0;
  JustTheController tooltipController = JustTheController();
  @override
  void initState() {
    Get.find<RiderMapController>().setSheetHeight(250, false);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      tooltipController.showTooltip();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<RiderMapController>(builder: (riderController){
      return GetBuilder<RideController>(builder: (rideController){
        if(rideController.tripDetail!.estimatedDistance.toString().contains("km")){
          removeComma = rideController.tripDetail!.estimatedDistance.toString().replaceAll("km", '');
          totalDistance = removeComma.replaceAll(",", '');

        }
        estDistance = double.parse(totalDistance).toStringAsFixed(2);

        return currentState == 0 ?
        rideController.tripDetail != null ?
        Padding(padding: const EdgeInsets.only(top: Dimensions.paddingSizeDefault),
          child: Column(children: [
            (riderController.currentRideState == RideState.accepted && riderController.isInside ) ?
            const OtpVerificationWidget() :
            Column(children: [
              const SizedBox(height: Dimensions.paddingSizeDefault),

              Text('your_pickup_time_is_continuing'.tr,
                style: textRegular.copyWith(
                  color: Theme.of(context).primaryColor, fontSize: Dimensions.fontSizeDefault,
                ),
              ),
              const SizedBox(height: Dimensions.paddingSizeExtraSmall),

              Text(
                'Please_reach_the_pickup_point'.tr,
                style: textRegular.copyWith(fontSize: Dimensions.fontSizeDefault),
              ),
              const SizedBox(height: Dimensions.paddingSizeExtraSmall),

              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(Dimensions.paddingSizeDefault),
                  border: Border.all(color: Theme.of(context).hintColor.withOpacity(0.25)),
                ),
                margin: const EdgeInsets.symmetric(vertical: Dimensions.paddingSizeExtraSmall,
                  horizontal: Dimensions.paddingSizeDefault,
                ),
                child: const OtpVerificationWidget(fromOtp: false),
              )
            ]),

            (riderController.currentRideState == RideState.accepted && riderController.isInside ) ?
            const SizedBox() :
            const SizedBox(height: Dimensions.paddingSizeDefault),

            Container(width: Get.width,
              margin: const EdgeInsets.only(
                left: Dimensions.paddingSizeLarge,
                right: Dimensions.paddingSizeLarge,
                bottom: Dimensions.paddingSizeLarge,
              ),
              decoration: BoxDecoration(borderRadius: BorderRadius.circular(Dimensions.paddingSizeSmall),
                border: Border.all(width: .75, color: Theme.of(context).hintColor.withOpacity(0.25)),
              ),
              child: Padding(padding: const EdgeInsets.all(Dimensions.paddingSizeSmall),
                child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                  Row(children: [
                    Stack(children: [
                      Container(
                        transform: Matrix4.translationValues(
                          Get.find<LocalizationController>().isLtr ? -3 : 3, -3, 0,
                        ),
                        child: CircularPercentIndicator(radius: 28, percent: .75,lineWidth: 1,
                          backgroundColor: Colors.transparent,
                          progressColor: Theme.of(Get.context!).primaryColor,
                        ),
                      ),

                      ClipRRect(borderRadius : BorderRadius.circular(100),
                        child: ImageWidget(width: 50,height: 50,
                          image: rideController.tripDetail!.customer?.profileImage != null ?
                          '${Get.find<SplashController>().config!.imageBaseUrl!.profileImageCustomer}'
                              '/${rideController.tripDetail!.customer?.profileImage??''}' :
                          '',
                        ),
                      ),
                    ]),

                    Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                      if(rideController.tripDetail!.customer!.firstName != null &&
                          rideController.tripDetail!.customer!.lastName != null)
                        SizedBox(width:100 ,
                          child: Text('${rideController.tripDetail!.customer!.firstName!} '
                              '${rideController.tripDetail!.customer!.lastName!}',
                          ),
                        ),

                      if(rideController.tripDetail!.customer != null)
                        Row(children: [
                          Icon(
                            Icons.star_rate_rounded, color: Theme.of(Get.context!).primaryColor,
                            size: Dimensions.iconSizeMedium,
                          ),

                          Text(
                            double.parse(rideController.tripDetail!.customerAvgRating!).toStringAsFixed(1),
                            style: textRegular.copyWith(),
                          ),
                        ]),
                    ]),
                  ]),

                  Container(width: 1,height: 25,color: Theme.of(context).primaryColor.withOpacity(0.15)),

                  InkWell(
                    onTap : () => Get.find<ChatController>().createChannel(
                      rideController.tripDetail!.customer!.id!,tripId: rideController.tripDetail!.id,
                    ),
                    child: SizedBox(width: Dimensions.iconSizeLarge,
                      child: Image.asset(Images.customerMessage),
                    ),
                  ),

                  Container(width: 1,height: 25,color: Theme.of(context).primaryColor.withOpacity(0.15)),

                  InkWell(
                    onTap: ()=> Get.find<SplashController>().sendMailOrCall(
                      "tel:${rideController.tripDetail!.customer!.phone}", false,
                    ),
                    child: SizedBox(width: Dimensions.iconSizeLarge,
                      child: Image.asset(Images.customerCall),
                    ),
                  ),

                  const SizedBox()
                ]),
              ),
            ),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeDefault),
              child: RouteWidget(
                pickupAddress: rideController.tripDetail?.pickupAddress ?? '',
                destinationAddress: rideController.tripDetail?.destinationAddress ?? '',
              ),
            ),
            const SizedBox(height: Dimensions.paddingSizeDefault),

            if(rideController.tripDetail!.type != 'parcel')
              Padding(
                padding: const EdgeInsets.symmetric(horizontal:Dimensions.paddingSizeExtraLarge),
                child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [

                  Row(children: [
                    SizedBox(width: Dimensions.iconSizeMedium,child: Image.asset(Images.distanceCalculated)),
                    const SizedBox(width: Dimensions.paddingSizeSmall),

                    Text("total_distance".tr, style: textRegular.copyWith()),
                  ]),
                  const SizedBox(width: Dimensions.paddingSizeSmall),

                  Text(totalDistance.contains('km') ?
                  rideController.tripDetail!.estimatedDistance.toString() :
                  '${double.parse(rideController.tripDetail!.estimatedDistance.toString()).toStringAsFixed(2)} km',
                  ),

                ]),
              ),
            const SizedBox(height: Dimensions.paddingSizeDefault),

            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(Dimensions.radiusLarge),
                color: Theme.of(context).primaryColor.withOpacity(0.15),
              ),
              margin: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeDefault),
              padding: const EdgeInsets.all(Dimensions.paddingSizeDefault),
              child: Column(children: [
                Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                  Expanded(child: Row(children: [
                    Image.asset(Images.paymentTypeIcon,
                      height: Dimensions.paddingSizeDefault,
                      width: Dimensions.paddingSizeDefault,
                    ),
                    const SizedBox(width: Dimensions.paddingSizeSmall),

                    Text('payment_method'.tr,
                      style: textRegular.copyWith(color: Theme.of(context).primaryColor,
                        fontSize: Dimensions.fontSizeDefault,
                      ),
                    ),

                    if(rideController.tripDetail?.type == 'parcel')
                    JustTheTooltip(
                      backgroundColor: Get.isDarkMode ?
                      Theme.of(context).primaryColor :
                      Theme.of(context).textTheme.bodyMedium!.color,
                      controller: tooltipController,
                      preferredDirection: AxisDirection.up,
                      tailLength: 10,
                      isModal: true,
                      tailBaseWidth: 20,
                      content: Container(width: 200,
                        padding: const EdgeInsets.all(Dimensions.paddingSizeSmall),
                        child: Text(
                          _paymentToolTipText(
                            rideController.tripDetail?.parcelInformation?.payer ?? 'sender',
                            rideController.tripDetail?.paymentMethod ?? 'cash',
                          ),
                          style: textRegular.copyWith(
                              color: Colors.white, fontSize: Dimensions.fontSizeDefault),
                        ),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: Dimensions.paddingSizeSmall,
                        ),
                        child: Icon(Icons.info,color: Theme.of(context).primaryColor,size: 16),
                      ),
                    )
                  ])),

                  Text(
                    rideController.tripDetail?.paymentMethod?.replaceAll(
                      RegExp('[\\W_]+'),' ').capitalize ?? 'cash'.tr,
                    style: TextStyle(color: Theme.of(context).primaryColor),
                  )
                ]),
                const SizedBox(height: Dimensions.paddingSizeSmall),

                Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                  Row(children: [
                    Image.asset(Images.farePrice,
                      height: Dimensions.paddingSizeDefault,
                      width: Dimensions.paddingSizeDefault,
                    ),
                    const SizedBox(width: Dimensions.paddingSizeSmall),

                    Text('fare_price'.tr,
                      style: textRegular.copyWith(
                        color: Theme.of(context).primaryColor, fontSize: Dimensions.fontSizeDefault,
                      ),
                    ),
                    const SizedBox(width: Dimensions.paddingSizeSmall),

                    if(rideController.tripDetail?.type == 'parcel')
                    Container(
                      decoration: BoxDecoration(
                          color: Theme.of(context).primaryColor.withOpacity(0.25),
                          borderRadius: BorderRadius.circular(Dimensions.paddingSizeExtraSmall)
                      ),
                      padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeSmall),
                      child: Text(
                          (rideController.tripDetail?.parcelInformation?.payer ?? 'sender') == 'sender' ?
                          'sender_will_pay'.tr : 'receiver_will_pay'.tr
                      ),
                    ),
                  ]),

                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(Dimensions.radiusSmall),
                      color:  Theme.of(context).primaryColor.withOpacity(0.2),
                    ),
                    padding: const EdgeInsets.symmetric(
                      horizontal: Dimensions.paddingSizeSmall,
                      vertical: Dimensions.paddingSizeExtraSmall,
                    ),
                    child: Text(
                      PriceConverter.convertPrice(
                        context,double.parse(rideController.tripDetail!.estimatedFare!),
                      ),
                      style: textBold.copyWith(
                          fontSize: Dimensions.fontSizeSmall,color: Theme.of(context).primaryColor,
                      ),
                    ),
                  )
                ]),
              ]),
            ),
            const SizedBox(height: Dimensions.paddingSizeDefault),

            (rideController.tripDetail!.type == "ride_request") ?
            Padding(padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeDefault),
              child: SliderButton(
                action: () {
                  currentState = 1;
                  widget.expandableKey.currentState?.expand();
                  setState(() {});
                },
                label: Text('cancel_ride'.tr,
                  style: TextStyle(color: Theme.of(context).primaryColor),
                ),
                dismissThresholds: 0.5, dismissible: false, shimmer: false,width: 1170,
                height: 40, buttonSize: 40, radius: 20,
                icon: Center(child: Container(width: 36, height: 36,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle, color: Theme.of(context).cardColor,
                  ),
                  child: Center(child: Icon(
                    Get.find<LocalizationController>().isLtr ?
                    Icons.arrow_forward_ios_rounded :
                    Icons.keyboard_arrow_left,
                    color: Colors.grey, size: Dimensions.paddingSizeLarge,
                  )),
                )),
                isLtr: Get.find<LocalizationController>().isLtr,
                boxShadow: const BoxShadow(blurRadius: 0),
                buttonColor: Colors.transparent,
                backgroundColor: Theme.of(context).primaryColor.withOpacity(0.15),
                baseColor: Theme.of(context).primaryColor,
              ),
            ) :
            const SizedBox(),
          ]),
        ) :
        const SizedBox() :
        Padding(padding: const EdgeInsets.symmetric(horizontal:Dimensions.paddingSizeDefault),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            const SizedBox(height: Dimensions.paddingSizeSmall),
            Text('your_pickup_time_is_continuing'.tr,
              style: textSemiBold.copyWith(color: Theme.of(context).primaryColor,
                fontSize: Dimensions.fontSizeSmall,
              ),
            ),
            const SizedBox(height: Dimensions.paddingSizeSmall),

            const CancellationRadioButton(isOngoing: false),

            const SizedBox(height: Dimensions.paddingSizeLarge),
            Row(children: [
              Expanded(child: ButtonWidget(buttonText: 'no_continue_trip'.tr,
                showBorder: true,
                transparent: true,
                backgroundColor: Theme.of(context).primaryColor,
                borderColor: Theme.of(context).primaryColor,
                textColor: Theme.of(context).cardColor,
                radius: Dimensions.paddingSizeSmall,
                onPressed: (){
                  currentState = 0;
                  setState(() {});
                },
              )),
              const SizedBox(width: Dimensions.paddingSizeSmall),

              Expanded(child: ButtonWidget(buttonText: 'submit'.tr,
                showBorder: true,
                transparent: true,
                textColor: Get.isDarkMode ? Colors.white : Colors.black,
                borderColor: Theme.of(context).hintColor,
                radius: Dimensions.paddingSizeSmall,
                onPressed: (){
                  Get.find<RideController>().remainingDistance(
                    rideController.tripDetail!.id!, mapBound: true,
                  );
                  rideController.tripStatusUpdate(
                    'cancelled', rideController.tripDetail!.id!,
                    "trip_cancelled_successfully",
                    Get.find<TripController>().tripCancellationCauseList!.data![0].acceptedRide!
                    [Get.find<TripController>().tripCancellationCauseCurrentIndex],
                  ).then((value) async {
                    if(value.statusCode == 200){
                      Get.find<OtpTimeCountController>().initialCounter();
                      Get.find<RiderMapController>().setRideCurrentState(RideState.initial);
                      Get.offAll(()=> const DashboardScreen());

                    }});
                },
              )),
            ])
          ]),
        );
      });
    });
  }

  String _paymentToolTipText(String whoPay,String paymentMethod){
    if(whoPay == 'sender'){
      return paymentMethod == 'cash' ?
      'before_start_trip_collect_payment'.tr :
      'customer_paid_the_amount_digitally'.tr;
    }else{
      return 'the_receiver_pay_the_bill'.tr;
    }
  }
}
