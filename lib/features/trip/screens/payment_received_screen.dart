import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';
import 'package:ride_sharing_user_app/common_widgets/confirmation_dialog_widget.dart';
import 'package:ride_sharing_user_app/util/dimensions.dart';
import 'package:ride_sharing_user_app/util/images.dart';
import 'package:ride_sharing_user_app/util/styles.dart';
import 'package:ride_sharing_user_app/features/dashboard/screens/dashboard_screen.dart';
import 'package:ride_sharing_user_app/features/map/widgets/route_widget.dart';
import 'package:ride_sharing_user_app/features/ride/controllers/ride_controller.dart';
import 'package:ride_sharing_user_app/features/trip/controllers/trip_controller.dart';
import 'package:ride_sharing_user_app/features/trip/widgets/sub_total_header.dart';
import 'package:ride_sharing_user_app/common_widgets/app_bar_widget.dart';
import 'package:ride_sharing_user_app/common_widgets/button_widget.dart';
import 'package:ride_sharing_user_app/common_widgets/payment_item_info_widget.dart';

class PaymentReceivedScreen extends StatelessWidget {
  final bool fromParcel;
  const PaymentReceivedScreen({super.key,  this.fromParcel = false});

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvoked: (val) async {
        Get.offAll(()=> const DashboardScreen());
        return;
      },
      child: Scaffold(
        body: SingleChildScrollView(child: GetBuilder<RideController>(
            builder: (finalFareController) {
              double finalPrice = 0;
              if(finalFareController.finalFare != null ){
                finalPrice = finalFareController.finalFare!.paidFare!;

              }

              String firstRoute = '';
              String secondRoute = '';
              List<dynamic> extraRoute = [];
              if(finalFareController.finalFare != null){
                if(finalFareController.finalFare!.intermediateAddresses != null && finalFareController.finalFare!.intermediateAddresses != '[[, ]]'){
                  extraRoute = jsonDecode(finalFareController.finalFare!.intermediateAddresses!);

                  if(extraRoute.isNotEmpty){
                    firstRoute = extraRoute[0];
                  }

                  if(extraRoute.isNotEmpty && extraRoute.length>1){
                    secondRoute = extraRoute[1];
                  }

                }
              }

              return (finalFareController.finalFare != null) ?
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                AppBarWidget( title: 'sub_total'.tr, showBackButton: true,
                  onBackPressed: ()=> Get.offAll(()=> const DashboardScreen()),
                ),

                SubTotalHeaderTitle(
                  title: 'total_trip_cost'.tr,
                  color: Theme.of(context).textTheme.bodyMedium!.color, amount: finalPrice,
                ),

                if(!fromParcel)
                  Padding(padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeExtraLarge),
                    child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,children: [
                      SummeryItem(title: '${finalFareController.finalFare!.actualTime} ${'minute'.tr}',
                        subTitle: 'time'.tr,
                      ),

                      SummeryItem(title: '${finalFareController.finalFare!.actualDistance} km',
                        subTitle: 'distance'.tr,
                      ),

                    ]),
                  ),

                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeDefault,
                    vertical: Dimensions.paddingSizeSmall,
                  ),
                  child: Text('trip_details'.tr),
                ),

                Padding(padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeDefault),
                  child: RouteWidget(
                    pickupAddress: '${finalFareController.finalFare!.pickupAddress}',
                    destinationAddress: '${finalFareController.finalFare!.destinationAddress}',
                    extraOne: firstRoute,
                    extraTwo: secondRoute,
                    entrance: finalFareController.finalFare?.entrance??'',
                  ),
                ),

                Padding(padding: const EdgeInsets.all(Dimensions.paddingSizeDefault),
                  child: Container(
                    padding: const EdgeInsets.fromLTRB(Dimensions.paddingSizeDefault,
                      Dimensions.paddingSizeDefault, Dimensions.paddingSizeDefault,0,
                    ),
                    decoration: BoxDecoration(
                      border: Border.all(color: Theme.of(context).primaryColor, width: 1),
                      borderRadius: BorderRadius.circular(Dimensions.paddingSizeSmall),
                    ),
                    child: Column(crossAxisAlignment: CrossAxisAlignment.start,children: [

                      Padding(padding: const EdgeInsets.only(bottom: Dimensions.paddingSizeDefault),
                        child: Text('payment_details'.tr,style: textSemiBold.copyWith(
                          color: Theme.of(context).primaryColor,
                        )),
                      ),

                      PaymentItemInfoWidget(icon: Images.farePrice,title: 'fare_price'.tr,
                        amount: finalFareController.finalFare?.distanceWiseFare?? 0,
                      ),

                      if(!fromParcel && finalFareController.finalFare!.cancellationFee!.toDouble() > 0)
                        PaymentItemInfoWidget(icon: Images.idleHourIcon,
                          title: 'cancellation_price'.tr,
                          amount: finalFareController.finalFare?.cancellationFee?? 0,
                        ),

                      if(!fromParcel && finalFareController.finalFare!.idleFee!.toDouble() > 0)
                        PaymentItemInfoWidget(icon: Images.idleHourIcon,
                          title: 'idle_price'.tr,
                          amount: finalFareController.finalFare?.idleFee?? 0,
                        ),

                      if(!fromParcel && finalFareController.finalFare!.delayFee!.toDouble() > 0)
                        PaymentItemInfoWidget(icon: Images.waitingPrice,
                          title: 'delay_price'.tr,
                          amount: finalFareController.finalFare?.delayFee?? 0,
                        ),

                      if(finalFareController.finalFare!.couponAmount!.toDouble() > 0)
                        PaymentItemInfoWidget(icon: Images.coupon,
                          title: 'coupon_amount'.tr,
                          amount: finalFareController.finalFare?.couponAmount?? 0,
                          discount: true,toolTipText: 'customer_applied_coupon_for_this_ride'.tr,
                          subTitle: 'later_admin_will_pay_you_this_amount',
                        ),

                      if(finalFareController.finalFare!.discountAmount!.toDouble() > 0)
                        PaymentItemInfoWidget(icon: Images.discountIcon,
                          title: 'discount_applied'.tr,
                          amount: finalFareController.finalFare?.discountAmount?? 0,
                          discount: true,toolTipText: 'discount_applied_for_this_ride'.tr,
                          subTitle: 'later_admin_will_pay_you_this_amount',
                        ),

                      if(finalFareController.finalFare!.vatTax!.toDouble() > 0)
                        PaymentItemInfoWidget(icon: Images.farePrice,
                          title: 'vat_tax'.tr,
                          amount: finalFareController.finalFare?.vatTax?? 0,
                        ),

                      PaymentItemInfoWidget(title: 'sub_total'.tr,
                        amount: finalFareController.finalFare?.paidFare?? 0,
                        isSubTotal: true,
                      ),

                    ]),
                  ),
                ),

              ]) :
              const SizedBox();
            }
          )),
        bottomNavigationBar: GetBuilder<RideController>(builder: (finalFareController) {
          return GetBuilder<TripController>(builder: (tripController) {
            return Container(height: 90,
              padding: const EdgeInsets.fromLTRB(
                Dimensions.paddingSizeDefault, Dimensions.paddingSizeDefault,
                Dimensions.paddingSizeDefault,Dimensions.paddingSizeLarge,
              ),
              child: tripController.isLoading ?
              Center(child: SpinKitCircle(color: Theme.of(context).primaryColor, size: 40.0,)) :
              ButtonWidget(buttonText: 'payment_received'.tr,
                onPressed: () {
                  Get.dialog(ConfirmationDialogWidget(
                    icon: Images.paymentIcon,
                    description: 'are_you_sure_you_got_cash_payment_from_customer'.tr,
                    onYesPressed: (){
                      tripController.paymentSubmit(
                        finalFareController.finalFare!.id!, 'cash', fromSenderPayment: fromParcel,
                      );
                    },
                  ));
                },
              ),
            );
          });
        }),
      ),
    );
  }
}

class SummeryItem extends StatelessWidget {
  final String title;
  final String subTitle;
  const SummeryItem({super.key, required this.title, required this.subTitle});

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      Icon(Icons.check_circle,size: Dimensions.iconSizeSmall, color: Theme.of(context).primaryColor),
      Text(title, style: textMedium.copyWith(color: Theme.of(context).primaryColor)),
      Text(subTitle, style: textRegular.copyWith(color: Theme.of(context).hintColor)),

    ],);
  }
}


