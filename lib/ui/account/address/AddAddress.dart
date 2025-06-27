
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:sanjivprkashan/model/address/UserAddress.dart';
import '../../../Constant.dart';
import '../../../controller/AddressController.dart';
import '../../../session/SessionManager.dart';
import '../../../utils/styleUtil.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class AddAddress extends StatefulWidget {
  final UserAddress? userAddress;
  const AddAddress({super.key, this.userAddress});

  @override
  State<AddAddress> createState() => _AddAddressState();
}

class _AddAddressState extends State<AddAddress> {
  late TextEditingController fNameController = TextEditingController();
  late TextEditingController lNameController = TextEditingController();
  late TextEditingController emailController = TextEditingController();
  late TextEditingController mobileController = TextEditingController();
  late TextEditingController houseNumberController = TextEditingController();
  late TextEditingController roadNameController = TextEditingController();
  late TextEditingController postCodeController = TextEditingController();
  late TextEditingController stateController = TextEditingController();
  late TextEditingController cityController = TextEditingController();
  late TextEditingController addressTypeOtherController = TextEditingController();

  final RxString selectedAddressType = "Home".obs;
  final RxBool isDefault = true.obs;
  String postId = "";


  final AddressController addressCtrl = Get.put(AddressController());

  @override
  void initState() {
    super.initState();
    fNameController = TextEditingController(text: widget.userAddress?.uaFname ?? "");
    lNameController = TextEditingController(text: widget.userAddress?.uaLname ?? "");
    emailController = TextEditingController(text: widget.userAddress?.uaEmail ?? "");
    mobileController = TextEditingController(text: widget.userAddress?.uaMobile ?? "");
    houseNumberController = TextEditingController(text: widget.userAddress?.uaShipHouse ?? "");
    roadNameController = TextEditingController(text: widget.userAddress?.uaShipAddress ?? "");
    postCodeController = TextEditingController(text: widget.userAddress?.uaShipPincode ?? "");
    stateController = TextEditingController(text: widget.userAddress?.uaShipState ?? "");
    cityController = TextEditingController(text: widget.userAddress?.uaAppShipCity ?? "");
    addressTypeOtherController = TextEditingController(text: widget.userAddress?.uaAddressTypeOther ?? "");
    selectedAddressType.value = _normalizeAddressType(widget.userAddress?.uaAddressType) ?? "Home";
    isDefault.value = widget.userAddress == null ? true : widget.userAddress?.uaDefaultAddress == 1 ? true : false;
    widget.userAddress != null ? postcodeListener() : null;
    postCodeController.addListener(postcodeListener);
  }

  void postcodeListener() {
    final text = postCodeController.text.trim();
    if (text.length == 6) {
      fetchCityStateFromPin(text);
    }
  }

  Future<void> fetchCityStateFromPin(String pin) async {
    Map<String, String> userData = {
      "pincode" : pin
    };
    try {
      var response = await http.post(Uri.parse(Constant.checkPinCode),
        body: userData,
        headers: Constant().userHeader,
      );
      if (response.statusCode == 200) {
        Map data = json.decode(response.body);

        debugPrint("dataaa ${data["data"]}  ${Constant().userHeader}");
        if (data['status'] == "success") {
          final postOffice = data['data'];
          stateController.text = postOffice['State'];
          cityController.text = postOffice['District'];
          postId = postOffice["pin_id"].toString();
        }else{
          if(data["message"] == "Session Expired"){
            SessionManager().logout();
          }
          showSnackbar("Opps!", data["message"]);
        }
      } else {
        showSnackbar("Error", "Failed to fetch getting response Code : ${response.statusCode}");
      }
    } catch (e) {
      showSnackbar("Error", e.toString());
      debugPrint("error ${e.toString()}");
    } finally {

    }
  }
  String? _normalizeAddressType(String? value) {
    if (value == null) return null;
    switch (value.toLowerCase()) {
      case 'Home':
        return 'Home';
      case 'Work':
        return 'Work';
      case 'Other':
        return 'Other';
      default:
        return 'Home'; // fallback or you can return null and handle it
    }
  }
  @override
  void dispose() {
    postCodeController.removeListener(postcodeListener);
    super.dispose();
  }

  void _handleLogin() {
    String fName = fNameController.text.trim();
    String lName = lNameController.text.trim();
    String email = emailController.text.trim();
    String mobile = mobileController.text.trim();
    String house = houseNumberController.text.trim();
    String road = roadNameController.text.trim();
    String postcode = postCodeController.text.trim();
    String state = stateController.text.trim();
    String city = cityController.text.trim();
    String aTypeOther = addressTypeOtherController.text.trim();
    String addressType = selectedAddressType.value;
    String defaultAddress = isDefault.value.toString();

    if (fName.isEmpty || lName.isEmpty || email.isEmpty || mobile.isEmpty || house.isEmpty || road.isEmpty || postcode.isEmpty) {
      showSnackbar("Oops!", "Please fill all required fields!");
      return;
    }
    if (!validateEmail(email)) {
      showSnackbar("Oops!", "Invalid email address!");
      return;
    }
    if (mobile.length != 10) {
      showSnackbar("Oops!", "Invalid mobile number!");
      return;
    }

    if(selectedAddressType.value == "Other"){
      if(aTypeOther.isEmpty){
        showSnackbar("Oops!", "Other type address name required!");
        return;
      }
    }

    Map<String, String> data = {
      "ua_fname": fName,
      "ua_lname": lName,
      "ua_email": email,
      "ua_mobile": mobile,
      "ua_ship_house": house,
      "ua_ship_address": road,
      "ua_ship_pincode": postcode,
      "ua_app_state_name": state,
      "ua_app_ship_city": city,
      "addr_type": addressType,
      "ua_default_address": defaultAddress.toString(),
      "ua_pin_id": postId,
      "ua_id" : "${widget.userAddress?.uaId ?? "0"}",
      "ua_address_type_other" : aTypeOther ?? ""
    };

    print("objectdata  $data");
    addressCtrl.addAddress(data);

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: Container(
        padding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
        height: 70,
        child: Column(
          children: [
            ElevatedButton(
              onPressed: !addressCtrl.isLoading.value ? _handleLogin : null,
              style: ElevatedButton.styleFrom(
                elevation: 0,
                backgroundColor: Theme.of(context).primaryColor,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(7)),
                minimumSize: const Size(double.infinity, 50),
              ),
              child: !addressCtrl.isLoading.value
                  ? Text('Save Address', style: Theme.of(context).textTheme.titleMedium?.copyWith(color: Colors.white))
                  : buttonLoader(),
            ),
          ],
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            otherAppBar(context, "Add Address", true, isCartShow: false),
            Flexible(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(child: _buildLabeledField("First Name", fNameController)),
                        const SizedBox(width: 10),
                        Expanded(child: _buildLabeledField("Last Name", lNameController)),
                      ],
                    ),
                    const SizedBox(height: 15),

                    _buildLabeledField("Email Address", emailController, inputType: TextInputType.emailAddress),
                    const SizedBox(height: 15),

                    _buildLabeledField("Phone Number", mobileController, inputType: TextInputType.phone, maxLength: 10),
                    const SizedBox(height: 15),

                    _buildLabeledField("House Number, Building Name", houseNumberController),
                    const SizedBox(height: 15),

                    _buildLabeledField("Road Name, Area/Colony", roadNameController),
                    const SizedBox(height: 15),

                    Row(
                      children: [
                        Expanded(child: _buildLabeledField("Postcode", postCodeController, inputType: TextInputType.number, maxLength: 6)),
                        const SizedBox(width: 10),
                        Expanded(child: _buildLabeledField("State", stateController, readOnly: true)),
                      ],
                    ),
                    const SizedBox(height: 15),

                    Row(
                      children: [
                        Expanded(child: _buildLabeledField("City", cityController, readOnly: true)),
                        const SizedBox(width: 10),
                        Expanded(child: _buildDropdownWithLabel("Address Type", selectedAddressType, ["Home", "Work", "Other"])),
                      ],
                    ),
                    Obx(() =>
                      Column(
                        children: [
                          if(selectedAddressType.value == "Other")
                            const SizedBox(height: 15),
                          if(selectedAddressType.value == "Other")
                            _buildLabeledField("Other Type Address", addressTypeOtherController),
                        ],
                      )
                    ),


                    Obx(() => CheckboxListTile(
                      value: isDefault.value,
                      onChanged: (value) => isDefault.value = value ?? true,
                      title: const Text("Set as default address"),
                      controlAffinity: ListTileControlAffinity.leading,
                      activeColor: Theme.of(context).primaryColor,
                      contentPadding: EdgeInsets.zero,
                    )),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
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
          decoration: InputDecoration(
            counterText: "",
            contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(7.0)),
          ),
        ),
      ],
    );
  }

  Widget _buildDropdownWithLabel(String label, RxString selected, List<String> options) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontWeight: FontWeight.w600)),
        const SizedBox(height: 5),
        Obx(() => DropdownButtonFormField<String>(
          value: selected.value,
          items: options
              .map((opt) => DropdownMenuItem<String>(
            value: opt,
            child: Text(opt),
          ))
              .toList(),
          onChanged: (val) => selected.value = val ?? options.first,
          decoration: InputDecoration(
            contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(7.0)),
          ),
        )),
      ],
    );
  }
}

