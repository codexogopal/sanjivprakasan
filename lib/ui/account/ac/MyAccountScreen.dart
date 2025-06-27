import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get.dart';
import 'package:sanjivprkashan/controller/HomeController.dart';
import 'package:sanjivprkashan/controller/LoginController.dart';
import 'package:sanjivprkashan/ui/account/address/MyAddressList.dart';
import 'package:sanjivprkashan/ui/web/MyWebView.dart';

import '../../../session/SessionManager.dart';
import '../../../theme/mythemcolor.dart';
import '../../../utils/common_color.dart';
import '../../../utils/styleUtil.dart';


class MyAccountScreen extends StatefulWidget {
  const MyAccountScreen({super.key});

  @override
  State<StatefulWidget> createState() => _MyAccountScreen();
}


class _MyAccountScreen extends State<MyAccountScreen> {
  final HomeController homeCtrl = Get.put(HomeController());
  final LoginController loginController = Get.put(LoginController());

  late TextEditingController fNameController = TextEditingController();
  late TextEditingController lMobileController = TextEditingController();
  late TextEditingController emailController = TextEditingController();
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  final TextEditingController _pController = TextEditingController();
  final TextEditingController _confrimPController = TextEditingController();

  @override
  void initState() {
    super.initState();
    fNameController = TextEditingController(text: homeCtrl.userData.value?.userFname ?? "");
    lMobileController = TextEditingController(text: homeCtrl.userData.value?.userMobile ?? "");
    emailController = TextEditingController(text: homeCtrl.userData.value?.userEmail ?? "");
  }
  @override
  void dispose() {
    super.dispose();
  }

  Future<void> getData() async {

  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      backgroundColor: Theme.of(context).colorScheme.secondaryContainer,
      // appBar: myStatusBar(context),
      body: SafeArea(
        child: Obx(() {
          if (homeCtrl.isLoading.value) {
            return Center(child: apiLoader());
          }
          return RefreshIndicator(
            onRefresh: () => getData(),
            child: Column(
              children: [
                otherAppBar(context, "My Account", true, isCartShow: false),
                Flexible(
                  child: ListView(
                    children: [
                      const SizedBox(height: 10,),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                        color: Theme.of(context).colorScheme.primaryContainer,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("Account Information", style: Theme.of(context).textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.normal, fontSize: 16
                            ),),
                            const SizedBox(height: 10,),
                            _buildLabeledField("Full Name", fNameController),
                            const SizedBox(height: 15),
                            _buildLabeledField("Email Address", emailController, inputType: TextInputType.emailAddress, readOnly: true),
                            const SizedBox(height: 15),
                            _buildLabeledField("Phone Number", lMobileController, inputType: TextInputType.phone, maxLength: 10, readOnly: true),
                            const SizedBox(height: 15),
                            ElevatedButton(
                              onPressed: !homeCtrl.isLoading.value ? _handleLogin : null,
                              style: ElevatedButton.styleFrom(
                                elevation: 0,
                                backgroundColor: Theme.of(context).primaryColor,
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(7)),
                                minimumSize: const Size(double.infinity, 50),
                              ),
                              child: !homeCtrl.isLoading.value
                                  ? Text('Update Profile', style: Theme.of(context).textTheme.titleMedium?.copyWith(color: Colors.white))
                                  : buttonLoader(),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 10,),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                        color: Theme.of(context).colorScheme.primaryContainer,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("Change Password", style: Theme.of(context).textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.normal, fontSize: 16
                            ),),
                            const SizedBox(height: 10,),
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
                                    onPressed: !loginController.isLoading.value ? _changPassword : null,
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
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        }),
      ),
    );
  }
  void _handleLogin() {
    String fName = fNameController.text.trim();
    if (fName.isEmpty) {
      showSnackbar("Oops!", "Please enter your full name!");
      return;
    }
    Map<String, String> data = {
      "user_fname": fName,
    };
    homeCtrl.updateUserName(data);
  }

  void _changPassword() {
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
    loginController.changePassword(userData, SessionManager.getTokenId()!, "ac");
  }

  Widget _buildLabeledField(
      String label,
      TextEditingController controller, {
        TextInputType inputType = TextInputType.text,
        bool readOnly = false,
        int? maxLength,
      }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontWeight: FontWeight.w600)),
        const SizedBox(height: 5),
        TextFormField(
          controller: controller,
          keyboardType: inputType,
          textInputAction: TextInputAction.next,
          readOnly: readOnly,
          maxLength: maxLength,
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
            color: readOnly ? Theme.of(context).hintColor : null
          ),
          decoration: InputDecoration(
            counterText: "",
            contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(7.0)),
          ),
        ),
      ],
    );
  }
}