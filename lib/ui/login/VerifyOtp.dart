
import 'dart:async';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:sanjivprkashan/ui/login/RegisterScreen.dart';

import '../../Constant.dart';
import '../../theme/mythemcolor.dart';
import '../../utils/common_color.dart';
import '../../utils/styleUtil.dart';
import '../../controller/LoginController.dart';

class VerifyOtp extends StatefulWidget {
  final String mToken;
  final String pType;
  const VerifyOtp({super.key, required this.mToken, required this.pType});

  @override
  _VerifyOtpState createState() => _VerifyOtpState();
}

class _VerifyOtpState extends State<VerifyOtp> {
  TextEditingController textEditingController = TextEditingController();

  final LoginController loginController = Get.put(LoginController());

  int secondsRemaining = 60;
  bool enableResend = false;
  late Timer timer;
  String enteredOtp = "";

  @override
  void initState() {
    super.initState();
    timer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (secondsRemaining != 0) {
        setState(() {
          secondsRemaining--;
        });
      } else {
        setState(() {
          enableResend = true;
        });
      }
    });
  }



  void _resendCode() {
    //other code here
    setState(() {
      secondsRemaining = 60;
      enableResend = false;
    });
  }

  @override
  dispose() {
    timer.cancel();
    super.dispose();
  }

  void _handleLogin() {
    if (enteredOtp.length == 4) {
      Map<String, String> userData = {
        'otp' : enteredOtp.toString(),
      };
      loginController.verifyUserOtp(userData, widget.mToken, widget.pType);
    } else {
      showSnackbar("Opps!", "Please enter a valid OTP");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Obx((){
          return Padding(
            padding: const EdgeInsets.all(20.0),
            child: ListView(
              children: [
                SizedBox(height: 20,),
                Image.asset(
                  alignment: AlignmentDirectional.topStart,
                  'assets/images/flogo.png',
                  height: 50,
                  width: MediaQuery.of(context).size.width-120,
                ),
                const SizedBox(height: 20),

                Text(
                  "OTP Verify",
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  "Please enter your OTP, we sand OTP on registered mobile number.",
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontSize: 12,
                      fontWeight: FontWeight.w400,
                      color: Theme.of(context).hintColor,
                      height: 1.8
                  ),
                ),

                const SizedBox(height: 35),
                Padding(
                  padding: const EdgeInsets.fromLTRB(15.0, 0.0, 15.0, 0.0),
                  child: PinCodeTextField(
                    mainAxisAlignment: MainAxisAlignment.center,
                    appContext: context,
                    length: 4,
                    // obscureText: true,
                    obscuringCharacter: '—',
                    blinkWhenObscuring: true,
                    animationType: AnimationType.fade,
                    hintCharacter: "-",
                    hintStyle: TextStyle(
                        color: Color(0XFF4D5C65)
                    ),
                    pinTheme: PinTheme(
                      shape: PinCodeFieldShape.box,
                      fieldOuterPadding: const EdgeInsets.symmetric(
                          vertical: 0.0, horizontal: 5),
                      borderRadius: BorderRadius.circular(10),
                      borderWidth: 0,
                      fieldHeight: 45,
                      fieldWidth: 45,
                      // errorBorderColor: Color(CommonAppTheme.redColor),
                      activeFillColor: Theme.of(context).colorScheme.primaryContainer,
                      inactiveFillColor: Theme.of(context).colorScheme.primaryContainer,
                      inactiveColor: myprimarycolor,
                      activeColor: Colors.green.shade50,
                      selectedColor: myprimarycolor,
                      selectedFillColor: Theme.of(context).colorScheme.primaryContainer,
                    ),
                    cursorColor: Colors.white,
                    cursorWidth: 0.5,
                    cursorHeight: 18,
                    controller: textEditingController,
                    animationDuration: const Duration(milliseconds: 300),
                    enableActiveFill: true,
                    textStyle: const TextStyle(
                      fontSize: 15,
                    ),
                    keyboardType: TextInputType.number,
                    boxShadows: const [
                      BoxShadow(
                        offset: Offset(0, 0.5),
                        color: Colors.black12,
                        blurRadius: 0,
                      )
                    ],
                    onCompleted: (v) {
                      enteredOtp = v;
                    },
                    // onTap: () {
                    //   print("Pressed");
                    // },
                    onChanged: (value) {
                      setState(() {
                        if (enteredOtp.length == 4) {
                          enteredOtp = value;
                        }
                      });
                    },
                    beforeTextPaste: (text) {
                      // debugPrint("Allowing to paste $text");
                      return true;
                    },
                  ),
                ),
                const SizedBox(height: 20),
                Padding(
                  padding: const EdgeInsets.fromLTRB(
                      30.0, 0.0, 30.0, 10.0),
                  child: Align(
                    alignment: Alignment.topCenter,
                    child: ElevatedButton(
                        onPressed: !loginController.isLoading.value ? _handleLogin : null,
                        style: ElevatedButton.styleFrom(
                          elevation: 0,
                          backgroundColor:
                          Theme.of(context).primaryColor,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(7),
                          ),
                          minimumSize:
                          const Size(double.infinity, 50),
                        ),

                        child: !loginController.isLoading.value ? Text(
                            'Verify',
                            style: Theme.of(context).textTheme.titleMedium?.copyWith(color: Colors.white)) :
                        buttonLoader()
                      // CircularProgressIndicator(color: Colors.white,),
                    ),
                  ),
                ),
                textSpanMobile()
              ],
            ),
          );
        }
        ),
      ),
    );
  }
  Widget textSpanMobile() {
    return Column(
      children: [
        if (!enableResend)
          Container(
            margin: const EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
            child: Text.rich(
                textAlign: TextAlign.center,
                TextSpan(
                    text: 'Didn\'t receive the OTP? ',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontSize: 14,
                      fontWeight: FontWeight.w300,
                    ),
                    children: <InlineSpan>[
                      TextSpan(
                        text: '$secondsRemaining Seconds',
                        style: TextStyle(
                          color: myprimarycolor,
                          fontSize: 14,
                          fontWeight: FontWeight.w300,
                        ),
                      ),
                    ]
                )
            ),),
        if (enableResend)
          Container(
            margin: const EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
            child: Text.rich(
                textAlign: TextAlign.center,
                TextSpan(
                    text: 'Didn\'t receive the OTP? ',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontSize: 14,
                      fontWeight: FontWeight.w300,
                    ),
                    children: <InlineSpan>[
                      TextSpan(
                        recognizer: TapGestureRecognizer()..onTap = () {
                          _resendCode();
                          loginController.resendOtp(widget.mToken);
                        },
                        text: 'Resend OTP',
                        style: TextStyle(
                          color: myprimarycolor,
                          fontSize: 14,
                          fontWeight: FontWeight.w300,
                        ),
                      ),
                    ]
                )
            ),),
      ],
    );
  }
  Widget textSignUp(BuildContext context){
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: Text.rich(
          textAlign: TextAlign.center,
          TextSpan(
              text: 'Don\'t have an account? ',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontSize: 14,
                fontWeight: FontWeight.w200,
              ),
              children: <InlineSpan>[
                TextSpan(
                  recognizer: TapGestureRecognizer()..onTap = () => Get.to(()=> RegisterScreen()),
                  text: 'Sign Up',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontSize: 15,
                      fontWeight: FontWeight.w800,
                      color: myprimarycolor
                  ),
                ),
              ]
          )
      ),
    );
  }

  Widget textSpan(BuildContext context){
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: Text.rich(
          textAlign: TextAlign.center,
          TextSpan(
              text: 'By clicking the login button, you agree to the\n',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontSize: 12,
                fontWeight: FontWeight.w200,
              ),
              children: <InlineSpan>[
                TextSpan(
                  recognizer: TapGestureRecognizer()..onTap = () => openWhatsApp(Constant.termsUrl),
                  text: 'Terms & Conditions ',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontSize: 12,
                      fontWeight: FontWeight.w800,
                      color: myprimarycolor
                  ),
                ),
                TextSpan(
                  text: 'and ',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontSize: 12,
                    fontWeight: FontWeight.w200,
                  ),
                ),
                TextSpan(
                  recognizer: TapGestureRecognizer()..onTap = () => openWhatsApp(Constant.privacyPolicy),
                  text: 'Privacy Policy',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontSize: 12,
                      fontWeight: FontWeight.w800,
                      color: myprimarycolor
                  ),
                ),
              ]
          )
      ),
    );
  }
}
