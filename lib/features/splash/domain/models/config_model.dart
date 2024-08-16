class ConfigModel {
  String? businessName;
  String? logo;
  bool? bidOnFare;
  String? countryCode;
  String? businessAddress;
  String? businessContactPhone;
  String? businessContactEmail;
  String? businessSupportPhone;
  String? businessSupportEmail;
  String? baseUrl;
  String? webSocketUrl;
  String? webSocketPort;
  String? webSocketKey;
  ImageBaseUrl? imageBaseUrl;
  String? currencyDecimalPoint;
  String? currencyCode;
  String? currencySymbolPosition;
  AboutUs? aboutUs;
  AboutUs? privacyPolicy;
  AboutUs? termsAndConditions;
  AboutUs? legal;
  bool? smsVerification;
  bool? emailVerification;
  String? mapApiKey;
  int? paginationLimit;
  String? facebookLogin;
  String? googleLogin;
  List<String>? timeZones;
  bool? verification;
  bool? conversionStatus;
  int? conversionRate;
  int? otpResendTime;
  bool? selfRegistration;
  String? currencySymbol;
  bool? reviewStatus;
  bool? maintenanceMode;
  double? completionRadius;
  bool? isDemo;
  bool? levelStatus;

  ConfigModel(
      {this.businessName,
        this.logo,
        this.bidOnFare,
        this.countryCode,
        this.businessAddress,
        this.businessContactPhone,
        this.businessContactEmail,
        this.businessSupportPhone,
        this.businessSupportEmail,
        this.baseUrl,
        this.webSocketUrl,
        this.webSocketPort,
        this.webSocketKey,
        this.imageBaseUrl,
        this.currencyDecimalPoint,
        this.currencyCode,
        this.currencySymbolPosition,
        this.aboutUs,
        this.privacyPolicy,
        this.termsAndConditions,
        this.legal,
        this.smsVerification,
        this.emailVerification,
        this.mapApiKey,
        this.paginationLimit,
        this.facebookLogin,
        this.googleLogin,
        this.timeZones,
        this.verification,
        this.conversionStatus,
        this.conversionRate,
        this.otpResendTime,
        this.selfRegistration,
        this.currencySymbol,
        this.reviewStatus,
        this.maintenanceMode,
        this.completionRadius,
        this.isDemo,
        this.levelStatus
      });

  ConfigModel.fromJson(Map<String, dynamic> json) {
    businessName = json['business_name'];
    logo = json['logo'];
    bidOnFare = json['bid_on_fare'];
    if(json['country_code'] != null && json['country_code'] != ""){
      countryCode = json['country_code']??'BD';
    }else{
      countryCode = 'BD';
    }
    businessAddress = json['business_address'];
    businessContactPhone = json['business_contact_phone'];
    businessContactEmail = json['business_contact_email'];
    businessSupportPhone = json['business_support_phone'];
    businessSupportEmail = json['business_support_email'];
    baseUrl = json['base_url'];
    webSocketUrl = json['websocket_url'];
    webSocketPort = json['websocket_port'];
    webSocketKey = json['websocket_key'];
    imageBaseUrl = json['image_base_url'] != null
        ? ImageBaseUrl.fromJson(json['image_base_url'])
        : null;
    currencyDecimalPoint = json['currency_decimal_point'];
    currencyCode = json['currency_code'];
    currencySymbolPosition = json['currency_symbol_position'];
    aboutUs = json['about_us'] != null
        ? AboutUs.fromJson(json['about_us'])
        : null;
    privacyPolicy = json['privacy_policy'] != null
        ? AboutUs.fromJson(json['privacy_policy'])
        : null;
    termsAndConditions = json['terms_and_conditions'] != null
        ? AboutUs.fromJson(json['terms_and_conditions'])
        : null;
    legal = json['legal'] != null
        ? AboutUs.fromJson(json['legal'])
        : null;
    smsVerification = json['sms_verification'];
    emailVerification = json['email_verification'];
    mapApiKey = json['map_api_key'];
    paginationLimit = json['pagination_limit'];
    facebookLogin = json['facebook_login'].toString();
    googleLogin = json['google_login'].toString();
    isDemo = json['is_demo'];
    levelStatus = json['level_status'];
    verification = '${json['verification']}'.contains('true');
    conversionStatus = json['conversion_status']??true;
    if(json['conversion_rate'] != null){
      conversionRate = json['conversion_rate'];
    }else{
      conversionRate = 0;
    }
    otpResendTime = int.parse(json['otp_resend_time'].toString());
    selfRegistration = json['self_registration'];
    currencySymbol = json['currency_symbol'];
    reviewStatus = json['review_status'];
    maintenanceMode = json['maintenance_mode'];
    if(json['driver_completion_radius'] != null){
      try{
        completionRadius = json['driver_completion_radius'].toDouble();
      }catch(e){
        completionRadius = double.parse(json['driver_completion_radius'].toString());
      }
    }

  }

}



class ImageBaseUrl {
  String? profileImageCustomer;
  String? banner;
  String? vehicleCategory;
  String? vehicleModel;
  String? vehicleBrand;
  String? profileImage;
  String? identityImage;
  String? documents;
  String? pages;
  String? conversation;

  ImageBaseUrl(
      {this.profileImageCustomer,
        this.banner,
        this.vehicleCategory,
        this.vehicleModel,
        this.vehicleBrand,
        this.profileImage,
        this.identityImage,
        this.documents,
        this.pages,
        this.conversation
      });

  ImageBaseUrl.fromJson(Map<String, dynamic> json) {
    profileImageCustomer = json['profile_image_customer'];
    banner = json['banner'];
    vehicleCategory = json['vehicle_category'];
    vehicleModel = json['vehicle_model'];
    vehicleBrand = json['vehicle_brand'];
    profileImage = json['profile_image'];
    identityImage = json['identity_image'];
    documents = json['documents'];
    pages = json['pages'];
    conversation = json['conversation'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['profile_image_customer'] = profileImageCustomer;
    data['banner'] = banner;
    data['vehicle_category'] = vehicleCategory;
    data['vehicle_model'] = vehicleModel;
    data['vehicle_brand'] = vehicleBrand;
    data['profile_image'] = profileImage;
    data['identity_image'] = identityImage;
    data['documents'] = documents;
    data['pages'] = pages;
    return data;
  }
}
class AboutUs {
  String? image;
  String? name;
  String? shortDescription;
  String? longDescription;

  AboutUs({this.image, this.name, this.shortDescription, this.longDescription});

  AboutUs.fromJson(Map<String, dynamic> json) {
    image = json['image'];
    name = json['name'];
    shortDescription = json['short_description'];
    longDescription = json['long_description'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['image'] = image;
    data['name'] = name;
    data['short_description'] = shortDescription;
    data['long_description'] = longDescription;
    return data;
  }
}