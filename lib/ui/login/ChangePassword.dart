
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:sanjivprkashan/ui/login/ForgotPassword.dart';
import 'package:sanjivprkashan/ui/login/RegisterScreen.dart';

import '../../Constant.dart';
import '../../controller/LoginController.dart';
import '../../theme/mythemcolor.dart';
import '../../utils/common_color.dart';
import '../../utils/styleUtil.dart';

/*class ChangePassword extends StatefulWidget {
  const ChangePassword({super.key});

  @override
  _ChangePasswordState createState() => _ChangePasswordState();
}*/

class ChangePassword extends StatelessWidget {
  final String mToken;
  ChangePassword({super.key, required this.mToken});
  final TextEditingController _pController = TextEditingController();
  final TextEditingController _confrimPController = TextEditingController();

  final LoginController loginController = Get.put(LoginController());

  void _handleLogin() {
    String userId = _pController.text.toString().trim();
    String userPass = _confrimPController.text.toString().trim();
    if(userId.isEmpty){
      showSnackbar("Opps!", "Please enter your password!");
      return;
    }
    if(userPass.isEmpty){
      showSnackbar("Opps!", "Please enter your confirm password!");
      return;
    }
    if(userId.length < 3){
      showSnackbar("Opps!", "Please enter a valid password");
      return;
    }
    if(userPass.length < 3){
      showSnackbar("Opps!", "Please enter a valid confirm password");
      return;
    }
    if(userId != userPass){
      showSnackbar("Opps!", "Password not match");
      return;
    }
    Map<String, String> userData = {
      "password" : userPass,
    };
    loginController.changePassword(userData, mToken, "login");
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
                  "Change Password",
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  "Enter your new password",
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontSize: 12,
                      fontWeight: FontWeight.w400,
                      color: Theme.of(context).hintColor,
                      height: 1.8
                  ),
                ),

                const SizedBox(height: 35),
                TextFormField(
                  cursorColor: Colors.grey,
                  textInputAction: TextInputAction.next,
                  scrollPadding: EdgeInsets.only(
                      bottom: MediaQuery.of(context).viewInsets.bottom),
                  controller: _pController,
                  keyboardType: TextInputType.text,
                  decoration: InputDecoration(
                    floatingLabelBehavior:
                    FloatingLabelBehavior.never,
                    contentPadding:
                    const EdgeInsets.fromLTRB(15, 15, 15, 15),
                    hintText: 'Password',
                    hintStyle: const TextStyle(
                      fontFamily: 'm',
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5.0),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5.0),
                      borderSide: BorderSide(
                        color: Theme.of(context).primaryColor,
                        width: 1.0,
                      ),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(7.0),
                      borderSide: BorderSide(
                        color: Color(CommonColor.borderColor),
                        width: 1.0,
                      ),
                    ),
                  ),
                  obscureText: true,
                ),
                SizedBox(height: 20,),
                TextFormField(
                  cursorColor: Colors.grey,
                  textInputAction: TextInputAction.done,
                  scrollPadding: EdgeInsets.only(
                      bottom: MediaQuery.of(context)
                          .viewInsets
                          .bottom),
                  controller: _confrimPController,
                  keyboardType: TextInputType.text,
                  decoration: InputDecoration(
                      floatingLabelBehavior:
                      FloatingLabelBehavior.never,
                      contentPadding:
                      const EdgeInsets.fromLTRB(15, 15, 15, 15),
                      hintText: 'Confirm Password',
                      hintStyle: const TextStyle(
                        fontFamily: 'm',
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(5.0),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(5.0),
                        borderSide: BorderSide(
                          color: Theme.of(context).primaryColor,
                          width: 1.0,
                        ),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(7.0),
                        borderSide: BorderSide(
                          color: Color(CommonColor.borderColor),
                          width: 1.0,
                        ),
                      ),
                      suffixIcon: InkWell(
                          onTap: (){
                            loginController.isShowPassword.value = !loginController.isShowPassword.value;
                          },
                          child: Icon(loginController.isShowPassword.value ? Icons.visibility_off : Icons.visibility)
                      )
                  ),
                  obscureText: !loginController.isShowPassword.value,
                ),
                const SizedBox(height: 20),
                Padding(
                  padding: const EdgeInsets.fromLTRB(
                      0.0, 0.0, 0.0, 10.0),
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
                            'Change password',
                            style: Theme.of(context).textTheme.titleMedium?.copyWith(color: Colors.white)) :
                        buttonLoader()
                      // CircularProgressIndicator(color: Colors.white,),
                    ),
                  ),
                ),
              ],
            ),
          );
        }
        ),
      ),
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
