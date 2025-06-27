
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

import '../../Constant.dart';
import '../../theme/mythemcolor.dart';
import '../../utils/common_color.dart';
import '../../utils/styleUtil.dart';
import '../../controller/LoginController.dart';

/*class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}*/

class RegisterScreen extends StatelessWidget {
  final TextEditingController fNameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController mobileController = TextEditingController();

  final LoginController loginController = Get.put(LoginController());
  void _handleLogin() {
    String fName = fNameController.text.toString().trim();
    String password = passwordController.text.toString().trim();
    String emailId = emailController.text.toString().trim();
    String mobileNo = mobileController.text.toString().trim();
    if(fName.isEmpty){
      showSnackbar("Opps!", "Please enter your full name!");
      return;
    }
    if(password.isEmpty){
      showSnackbar("Opps!", "Please enter your password!");
      return;
    }
    if(password.length < 3){
      showSnackbar("Opps!", "Please enter a valid password!");
      return;
    }
    if(emailId.isEmpty){
      showSnackbar("Opps!", "Please enter your email address!");
      return;
    }
    if(!validateEmail(emailId)){
      showSnackbar("Opps!", "Please enter a valid email address!");
      return;
    }
    if(mobileNo.isEmpty){
      showSnackbar("Opps!", "Please enter your mobile number!");
      return;
    }
    if(mobileNo.length != 10){
      showSnackbar("Opps!", "Please enter a valid mobile number!");
      return;
    }
    Map<String, String> userData = {
      "name" : fName,
      "email" : emailId,
      "mobile" : mobileNo,
      "password" : password,
    };
    loginController.registerProcess(userData);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: textSpan(context),
      body: SafeArea(
        child: Obx((){
         /* if(loginController.isLoading.value){
            return Center(child: CircularProgressIndicator());
          }*/
          return ListView(
            children: [
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
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
                      "Sign Up with ${Constant.appName}",
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      "Please enter a valid mobile no./email address & password to access your ${Constant.appName} account.",
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
                          bottom: MediaQuery.of(context)
                              .viewInsets
                              .bottom),
                      controller: fNameController,
                      keyboardType: TextInputType.text,
                      decoration: InputDecoration(


                        counterText: "",
                        floatingLabelBehavior:
                        FloatingLabelBehavior.never,
                        contentPadding:
                        const EdgeInsets.fromLTRB(15, 15, 15, 15),
                        hintText: 'Enter Full Name',
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
                    ),
                    const SizedBox(height: 20),
                    TextFormField(
                      cursorColor: Colors.grey,
                      textInputAction: TextInputAction.next,
                      maxLength: 10,
                      scrollPadding: EdgeInsets.only(
                          bottom: MediaQuery.of(context)
                              .viewInsets
                              .bottom),
                      controller: mobileController,
                      keyboardType: TextInputType.phone,
                      decoration: InputDecoration(
                        counterText: "",
                        floatingLabelBehavior:
                        FloatingLabelBehavior.never,
                        contentPadding:
                        const EdgeInsets.fromLTRB(15, 15, 15, 15),
                        hintText: 'Enter mobile number',
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
                    ),
                    const SizedBox(height: 20),
                    TextFormField(
                      cursorColor: Colors.grey,
                      textInputAction: TextInputAction.next,
                      scrollPadding: EdgeInsets.only(
                          bottom: MediaQuery.of(context)
                              .viewInsets
                              .bottom),
                      controller: emailController,
                      keyboardType: TextInputType.emailAddress,
                      decoration: InputDecoration(
                        counterText: "",
                        floatingLabelBehavior:
                        FloatingLabelBehavior.never,
                        contentPadding:
                        const EdgeInsets.fromLTRB(15, 15, 15, 15),
                        hintText: 'Enter email id',
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
                    ),
                    const SizedBox(height: 20),
                    TextFormField(
                      cursorColor: Colors.grey,
                      textInputAction: TextInputAction.done,
                      scrollPadding: EdgeInsets.only(
                          bottom: MediaQuery.of(context)
                              .viewInsets
                              .bottom),
                      controller: passwordController,
                      keyboardType: TextInputType.text,
                      decoration: InputDecoration(
                          counterText: "",
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
                          suffixIcon: InkWell(
                              onTap: (){
                                loginController.isShowPassword.value = !loginController.isShowPassword.value;
                              },
                              child: Icon(loginController.isShowPassword.value ? Icons.visibility : Icons.visibility_off)
                          )
                      ),
                      obscureText: loginController.isShowPassword.value,
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
                              'Sign Up',
                              style: Theme.of(context).textTheme.titleMedium?.copyWith(color: Colors.white)) :
                          buttonLoader()
                          // CircularProgressIndicator(color: Colors.white,),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        textSignUp(context),
                      ],
                    )
                  ],
                ),
              ),
            ],
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
              text: 'Already have an account? ',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontSize: 14,
                fontWeight: FontWeight.w200,
              ),
              children: <InlineSpan>[
                TextSpan(
                  recognizer: TapGestureRecognizer()..onTap = () => Get.back(),
                  text: 'Sign In',
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
