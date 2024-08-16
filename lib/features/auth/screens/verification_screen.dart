
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:ride_sharing_user_app/util/dimensions.dart';
import 'package:ride_sharing_user_app/util/images.dart';
import 'package:ride_sharing_user_app/util/styles.dart';
import 'package:ride_sharing_user_app/features/auth/controllers/auth_controller.dart';
import 'package:ride_sharing_user_app/features/splash/controllers/splash_controller.dart';
import 'package:ride_sharing_user_app/common_widgets/app_bar_widget.dart';
import 'package:ride_sharing_user_app/common_widgets/button_widget.dart';

class VerificationScreen extends StatefulWidget {
  final String number;
  final String? from;
  final String countryCode;
  const VerificationScreen({super.key, required this.number,  this.from, required this.countryCode});

  @override
  State<VerificationScreen> createState() => _VerificationScreenState();
}

class _VerificationScreenState extends State<VerificationScreen> {
  TextEditingController pinController = TextEditingController();
  Timer? _timer;
  int? _seconds = 0;

  @override
  void initState() {
    super.initState();
    _startTimer();
  }

  void _startTimer() {
    _seconds = Get.find<SplashController>().config!.otpResendTime!;
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      _seconds = _seconds! - 1;
      if(_seconds == 0) {
        timer.cancel();
        _timer?.cancel();
      }
      setState(() {});
    });
  }

  @override
  void dispose() {
    super.dispose();
    _timer?.cancel();
  }

  @override
  Widget build(BuildContext context) {
    int minutes = (_seconds! / 60).truncate();
    String minutesStr = (minutes % 60).toString().padLeft(2, '0');
    return Scaffold(
      appBar: AppBarWidget(title: 'otp_verification'.tr,showBackButton: true, regularAppbar: true,),
      body: Center(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.symmetric(horizontal:Dimensions.paddingSizeLarge),
          child: GetBuilder<AuthController>(builder: (authController) {
            return Column(mainAxisAlignment: MainAxisAlignment.center, children: [
                Image.asset(Images.verification, width: 120),

                const SizedBox(height: Dimensions.paddingSizeExtraLarge),
                Text('enter_verification_code'.tr,style: textSemiBold.copyWith(fontSize: Dimensions.fontSizeLarge),),

               (Get.find<SplashController>().config?.isDemo ?? true) ? Padding(padding: const EdgeInsets.all(Dimensions.paddingSizeSmall).copyWith(bottom: Dimensions.paddingSizeOver),
                 child: Text('for_demo_purpose_use'.tr, style: textSemiBold.copyWith(color: Theme.of(context).disabledColor))) :
              const SizedBox(height:  Dimensions.paddingSizeExtraLarge),

              

              SizedBox(width: 240,
                  child: PinCodeTextField(
                    length: 4,
                    appContext: context,
                    controller: pinController,
                    keyboardType: TextInputType.number,
                    animationType: AnimationType.slide,
                    pinTheme: PinTheme(
                      shape: PinCodeFieldShape.circle,
                      fieldHeight: 40,
                      fieldWidth: 40,
                      borderWidth: 1,
                      borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
                      selectedColor: Theme.of(context).primaryColor.withOpacity(0.2),
                      selectedFillColor: Get.isDarkMode?Colors.grey.withOpacity(0.6):Colors.white,
                      inactiveFillColor: Theme.of(context).cardColor,
                      inactiveColor: Theme.of(context).hintColor,
                      activeColor: Theme.of(context).hintColor,
                      activeFillColor: Theme.of(context).cardColor,
                    ),
                    animationDuration: const Duration(milliseconds: 300),
                    backgroundColor: Colors.transparent,
                    enableActiveFill: true,
                    onChanged: authController.updateVerificationCode,
                    beforeTextPaste: (text) => true,
                    textStyle: textSemiBold.copyWith(),

                    pastedTextStyle: textRegular.copyWith(color: Theme.of(context).textTheme.bodyMedium!.color))),

                if(_seconds! <= 0)
                Row(mainAxisAlignment: MainAxisAlignment.center, crossAxisAlignment: CrossAxisAlignment.center, children: [
                  Text('did_not_receive_the_code'.tr,style: textMedium.copyWith(color: Theme.of(context).textTheme.bodyMedium!.color!.withOpacity(.6)),),
                  TextButton(onPressed: (){
                    authController.sendOtp(countryCode:widget.countryCode, phone: widget.number).then((value){
                      if(value.statusCode == 200) {
                        _startTimer();
                      }
                    });
                    },
                    child: Text('resend_it'.tr,style: textSemiBold.copyWith(color: Theme.of(context).primaryColor),
                      textAlign: TextAlign.end))]),

                if(_seconds! > 0)
                  Text('${'resend_it'.tr} ${'after'.tr} ${_seconds! > 0 ? '$minutesStr:${_seconds! % 60}' : ''} ${'sec'.tr}'),


                const SizedBox(height: Dimensions.paddingSizeExtraLarge,),
                !authController.isLoading? authController.verificationCode.length == 4  ?
                Padding(padding:  const EdgeInsets.only(top: Dimensions.paddingSizeExtraLarge,),
                  child: ButtonWidget(buttonText: 'send'.tr, radius: 50,
                    onPressed: ()  => authController.otpVerification(widget.countryCode ,widget.number, authController.verificationCode, from: widget.from!).then((value){
                      if(value.statusCode == 200){
                        pinController.clear();
                      }
                    })),
                ) : const SizedBox.shrink(): Center(child: SpinKitCircle(color: Theme.of(context).primaryColor, size: 40.0,)),
                const SizedBox(height: Dimensions.paddingSizeExtraLarge),
              ],);
          }),
        ),
      ),
    );
  }
}
