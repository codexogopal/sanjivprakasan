


import 'package:sanjivprkashan/session/SessionManager.dart';

class Constant {
  static String appName = "Sanjiv Prakashan";

  String paytmMid = "CtLRGe04609005345623";
  // static String BASE_URL = "https://sanjivprakashan.com/api/mobile-api/";
  static String BASE_URL = "https://studykee.com/projects/sanjivprakashan/api/mobile-api/";

  static String LOCAL_BASE_URL = "https://studykee.com/projects/sanjivprakashan/api/mobile-api/";

  static String loginProcess = "${BASE_URL}loginprocess";
  static String verifyOtp = "${BASE_URL}verifyotp";
  static String resendOtp = "${BASE_URL}resendotp";
  static String sendForgotOtp = "${BASE_URL}sendforgototp";
  static String forgotChangePassword = "${BASE_URL}forgotchangepassword";
  static String registerProcess = "${BASE_URL}register-process";

  static String getUserData = "${BASE_URL}getuserdata";
  static String dashboard = "${BASE_URL}dashboard";

  static String childCategories = "${BASE_URL}child-categories";

  static String productDetail = "${BASE_URL}product-detail";

  static String addToCart = "${BASE_URL}add-to-cart";

  static String allCategories = "${BASE_URL}all-categories";

  static String cartList = "${BASE_URL}cart-list";

  static String couponList = "${BASE_URL}coupon-list";

  static String applyCoupon = "${BASE_URL}apply-coupon";

  static String createTempOrder = "${BASE_URL}create-temp-order";

  static String reponsePaytm = "${BASE_URL}reponsepaytm";

  static String minusToCart = "${BASE_URL}minus-to-cart";

  static String removeItemFromCart = "${BASE_URL}removeitemfromcart";

  static String productList = "${BASE_URL}product-list";

  static String wishList = "${BASE_URL}wishlist";

  static String userEbooks = "${BASE_URL}user-ebooks";

  static String currentAffairs = "${BASE_URL}current-affairs";

  static String addRemoveWishlist = "${BASE_URL}add-remove-wishlist";

  static String userAddressList = "${BASE_URL}user-address-list";

  static String checkPinCode = "${BASE_URL}check-pincode";

  static String addUserAddress = "${BASE_URL}add-user-address";

  static String removeAddress = "${BASE_URL}remove-address";

  static String updateProfile = "${BASE_URL}updateprofile";

  static String allTestSeriesCourses = "${LOCAL_BASE_URL}test-series-courses";

  static String testSeriesCourseCategories = "${LOCAL_BASE_URL}test-series-course-categories";

  static String myOrdersList = "${LOCAL_BASE_URL}myorders";

  static String orderDetails = "${LOCAL_BASE_URL}order-detail";

  static String buyCourse = "${LOCAL_BASE_URL}buy-test-series-course";

  static String myTestSeriesCourses = "${LOCAL_BASE_URL}my-test-series-courses";

  static String courseWiseTestSeriesData = "${LOCAL_BASE_URL}course-wise-test-series-data";

  static String testQuestionsData = "${LOCAL_BASE_URL}test-questions-data";

  static String userTestSubmit = "${LOCAL_BASE_URL}user-test-submit";

  static String getProductsBySearch = "${LOCAL_BASE_URL}get-products-by-search";

  static String studentInformationDeskData = "${LOCAL_BASE_URL}student-information-desk-data";

  static String coursesCategories = "${LOCAL_BASE_URL}courses-categories";

  static String allCourses = "${LOCAL_BASE_URL}all-courses";

  static String myCourses = "${LOCAL_BASE_URL}my-courses";

  static String buyNewCourse = "${LOCAL_BASE_URL}buy-course";

  static String createCourseTempOrder = "${LOCAL_BASE_URL}create-course-temp-order";

  static String courseReponsePaytm = "${LOCAL_BASE_URL}coursereponsepaytm";

  static String userCoursesTransactions = "${LOCAL_BASE_URL}user-courses-transactions";

  static String testResultData = "${LOCAL_BASE_URL}test-result-data";





  static String privacyPolicy = "https://sanjivprakashan.com/privacy-policy";
  static String termsUrl = "https://sanjivprakashan.com/terms-of-service";
  static String termsConditionUrl = "https://sanjivprakashan.com/terms-conditions";
  static String termsOfEBookSaleUrl = "https://sanjivprakashan.com/terms-of-ebook-sale";
  static String bookShippingPolicyUrl = "https://sanjivprakashan.com/book-shipping-policy";
  static String faqUrl = "https://sanjivprakashan.com/faq";
  static String aboutUsUrl = "https://sanjivprakashan.com/about-us";
  static String contactUs = "https://sanjivprakashan.com/contact-us";
  static String aboutUs = "https://sanjivprakashan.com/company";



/*  Map<String, String> userHeader = {
    "x-authorization" : SessionManager().user_token ?? ""
  };*/
  Map<String, String> userHeader = {
    // 'Content-Type': 'application/json',
    'Accept': 'application/json',
    "X-AUTH-TOKEN" : SessionManager.getTokenId() ?? ""
  };
}
