import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ride_sharing_user_app/util/dimensions.dart';
import 'package:ride_sharing_user_app/util/styles.dart';
import 'package:ride_sharing_user_app/features/profile/controllers/profile_controller.dart';
import 'package:ride_sharing_user_app/features/splash/controllers/splash_controller.dart';
import 'package:ride_sharing_user_app/common_widgets/image_widget.dart';

class ProfileLevelWidgetWidget extends StatelessWidget {
  const ProfileLevelWidgetWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ProfileController>(builder: (profileController) {
      return Padding(
        padding: const EdgeInsets.fromLTRB(
          Dimensions.paddingSizeDefault, 100,
          Dimensions.paddingSizeDefault, Dimensions.paddingSizeDefault,
        ),
        child: Row(children:  [
          SizedBox(child: ClipRRect(
            borderRadius: BorderRadius.circular(Dimensions.paddingSizeExtraSmall),
            child: ImageWidget(
              width: 40,height: 40,
              image: '${Get.find<SplashController>().config!.imageBaseUrl!.profileImage}/${profileController.profileInfo?.profileImage??""}',
            ),
          )),
          const SizedBox(width: Dimensions.paddingSizeDefault),

          Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start,children: [
            Text(
              '${profileController.profileInfo?.firstName}  ${profileController.profileInfo?.lastName}',
              style: textBold.copyWith(color: Colors.white, fontSize: Dimensions.fontSizeLarge),
              maxLines: 1,overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: Dimensions.paddingSizeExtraSmall),

            if(Get.find<SplashController>().config!.levelStatus!)
              Container(
                decoration: BoxDecoration(color: Theme.of(context).primaryColor.withOpacity(.10),
                  borderRadius: BorderRadius.circular(Dimensions.paddingSizeExtraSmall),
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 2.0, horizontal: Dimensions.paddingSizeExtraSmall),
                  child: Text(
                    (profileController.profileInfo != null && profileController.profileInfo!.level != null) ?
                    '${profileController.levelModel?.data?.currentLevel?.name}':
                    '',
                    style: textRegular.copyWith(color: Colors.white),
                  ),
                ),
              ),
          ])),

          GestureDetector(
              onTap: ()=> Get.find<ProfileController>().toggleDrawer(),
              child: const SizedBox(child: Icon(CupertinoIcons.clear, color: Colors.white)),
          )


        ]),
      );
    });
  }
}
