class User {
  final int userId;
  final String userUniqueId;
  final String userFname;
  final String userEmail;
  final String userMobile;
  final int userStatus;
  final String? userReferral;
  final String? userPincode;
  final String? userCity;
  final String? userState;
  final String? userAddress;
  final String? userLat;
  final String? userLng;

  User({
    required this.userId,
    required this.userUniqueId,
    required this.userFname,
    required this.userEmail,
    required this.userMobile,
    required this.userStatus,
    this.userReferral,
    this.userPincode,
    this.userCity,
    this.userState,
    this.userAddress,
    this.userLat,
    this.userLng,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      userId: json['user_id'] ?? "",
      userUniqueId: json['user_unique_id'] ?? "",
      userFname: json['user_fname'] ?? "",
      userEmail: json['user_email'] ?? "",
      userMobile: json['user_mobile'] ?? "",
      userStatus: json['user_status'] ?? "",
      userReferral: json['user_referral'] ?? "",
      userPincode: json['user_pincode'] ?? "",
      userCity: json['user_city'] ?? "",
      userState: json['user_state'] ?? "",
      userAddress: json['user_address'] ?? "",
      userLat: json['user_lat'].toString() ?? "",
      userLng: json['user_lng'].toString() ?? "",
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'user_id': userId,
      'user_unique_id': userUniqueId,
      'user_fname': userFname,
      'user_email': userEmail,
      'user_mobile': userMobile,
      'user_status': userStatus,
      'user_referral': userReferral,
      'user_pincode': userPincode,
      'user_city': userCity,
      'user_state': userState,
      'user_address': userAddress,
      'user_lat': userLat,
      'user_lng': userLng,
    };
  }
}
