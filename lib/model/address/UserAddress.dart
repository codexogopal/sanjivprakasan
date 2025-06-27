class UserAddress {
  final int? uaId;
  final String? uaFname;
  final String? uaLname;
  final String? uaEmail;
  final String? uaMobile;
  final String? uaAppStateName;
  final String? uaAddressType;
  final String? uaAddressTypeOther;
  final String? uaCompanyName;
  final String? uaGstNumber;
  final String? uaShipState;
  final String? uaShipCity;
  final String? uaAppShipCity;
  final String? uaShipHouse;
  final String? uaShipAddress;
  final String? uaShipPincode;
  final int? uaUserId;
  final int? uaDefaultAddress;
  final int? uaCountryId;
  final String? uaCountryName;
  final int? uaPinId;
  final String? createdAt;
  final String? updatedAt;

  UserAddress({
    this.uaId,
    this.uaFname,
    this.uaLname,
    this.uaEmail,
    this.uaMobile,
    this.uaAppStateName,
    this.uaAddressType,
    this.uaAddressTypeOther,
    this.uaCompanyName,
    this.uaGstNumber,
    this.uaShipState,
    this.uaShipCity,
    this.uaAppShipCity,
    this.uaShipHouse,
    this.uaShipAddress,
    this.uaShipPincode,
    this.uaUserId,
    this.uaDefaultAddress,
    this.uaCountryId,
    this.uaCountryName,
    this.uaPinId,
    this.createdAt,
    this.updatedAt,
  });

  factory UserAddress.fromJson(Map<String, dynamic> json) {
    return UserAddress(
      uaId: json['ua_id'] ?? 0,
      uaFname: json['ua_fname'] ?? "",
      uaLname: json['ua_lname'] ?? "",
      uaEmail: json['ua_email'] ?? "",
      uaMobile: json['ua_mobile'] ?? "",
      uaAppStateName: json['ua_app_state_name'] ?? "",
      uaAddressType: json['ua_address_type'] ?? "",
      uaAddressTypeOther: json['ua_address_type_other'] ?? "",
      uaCompanyName: json['ua_company_name'] ?? "",
      uaGstNumber: json['ua_gst_number'] ?? "",
      uaShipState: json['ua_ship_state'] ?? "",
      uaShipCity: json['ua_ship_city'] ?? "",
      uaAppShipCity: json['ua_app_ship_city'] ?? "",
      uaShipHouse: json['ua_ship_house'] ?? "",
      uaShipAddress: json['ua_ship_address'] ?? "",
      uaShipPincode: json['ua_ship_pincode'] ?? "",
      uaUserId: json['ua_user_id'] ?? 0,
      uaDefaultAddress: json['ua_default_address'] ?? 0,
      uaCountryId: json['ua_country_id'] ?? 0,
      uaCountryName: json['ua_country_name'] ?? "",
      uaPinId: json['ua_pin_id'] ?? 0,
      createdAt: json['created_at'] ?? "",
      updatedAt: json['updated_at'] ?? "",
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'ua_id': uaId,
      'ua_fname': uaFname,
      'ua_lname': uaLname,
      'ua_email': uaEmail,
      'ua_mobile': uaMobile,
      'ua_app_state_name': uaAppStateName,
      'ua_address_type': uaAddressType,
      'ua_address_type_other': uaAddressTypeOther,
      'ua_company_name': uaCompanyName,
      'ua_gst_number': uaGstNumber,
      'ua_ship_state': uaShipState,
      'ua_ship_city': uaShipCity,
      'ua_app_ship_city': uaAppShipCity,
      'ua_ship_house': uaShipHouse,
      'ua_ship_address': uaShipAddress,
      'ua_ship_pincode': uaShipPincode,
      'ua_user_id': uaUserId,
      'ua_default_address': uaDefaultAddress,
      'ua_country_id': uaCountryId,
      'ua_country_name': uaCountryName,
      'ua_pin_id': uaPinId,
      'created_at': createdAt,
      'updated_at': updatedAt,
    };
  }
}
