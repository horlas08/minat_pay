import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_native_contact_picker/flutter_native_contact_picker.dart'
    as contact_picker;
import 'package:minat_pay/config/color.constant.dart';
import 'package:minat_pay/config/font.constant.dart';
import 'package:minat_pay/helper/helper.dart';
import 'package:phone_form_field/phone_form_field.dart';
import 'package:touchable_opacity/touchable_opacity.dart';

import '../../../../data/mock/dummy_data.dart';

final PhoneController phoneController = PhoneController(
    initialValue: const PhoneNumber(isoCode: IsoCode.NG, nsn: ''));
final TextEditingController amountController = TextEditingController();

class Airtime extends HookWidget {
  const Airtime({super.key});

  @override
  Widget build(BuildContext context) {
    final networks = List.generate(6, (i) => i);
    final ValueNotifier<int?> selectedPlan = useState(null);
    final ValueNotifier<int> selectedNetwork = useState(1);
    final ValueNotifier<bool> openNetwork = useState(false);

    UnderlineInputBorder borderStyle = const UnderlineInputBorder(
      borderSide: BorderSide(
          style: BorderStyle.solid, color: AppColor.primaryColor, width: 2),
    );
    final contact_picker.FlutterContactPicker _contactPicker =
        new contact_picker.FlutterContactPicker();

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Airtime Subscription',
          style: TextStyle(
            fontSize: 20,
            fontFamily: AppFont.mulish,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {},
            child: const Text(
              'History',
              style: TextStyle(
                fontSize: 20,
                fontFamily: AppFont.mulish,
                fontWeight: FontWeight.bold,
              ),
            ),
          )
        ],
      ),
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  CircleAvatar(
                    child: IconButton(
                        onPressed: () async {
                          final contact = await _contactPicker.selectContact();

                          phoneController.value = PhoneNumber(
                              isoCode: IsoCode.NG,
                              nsn: contact!.phoneNumbers!.last);
                        },
                        icon: const Icon(Icons.people_alt_rounded)),
                  ),
                  const SizedBox(
                    width: 20,
                  ),
                  Expanded(
                    flex: 1,
                    child: PhoneFormField(
                      decoration: InputDecoration(
                        filled: false,
                        hintText: "Phone Number",
                        helperText: '',
                        focusedBorder: borderStyle,
                        enabledBorder: borderStyle,
                        focusedErrorBorder: borderStyle,
                        errorBorder: borderStyle,
                        border: borderStyle,
                        contentPadding: const EdgeInsets.all(8),
                        hintStyle: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontFamily: AppFont.aeonik,
                          fontSize: 23,
                        ),
                      ),
                      onTapOutside: (v) =>
                          FocusManager.instance.primaryFocus?.unfocus(),
                      enableSuggestions: true,
                      controller: phoneController,
                      validator: PhoneValidator.compose([
                        PhoneValidator.required(context),
                        PhoneValidator.validMobile(context)
                      ]),
                      onChanged: (phoneNumber) {
                        // phone.value = phoneNumber;
                        print(phoneController.value);
                        // print('changed into $phoneNumber'),
                      },
                      enabled: true,
                      isCountrySelectionEnabled: false,
                      countryButtonStyle: const CountryButtonStyle(
                        showDialCode: true,
                        showIsoCode: false,
                        showFlag: false,
                        showDropdownIcon: false,
                        flagSize: 20,
                        textStyle: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontFamily: AppFont.aeonik,
                          fontSize: 23,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(
                    width: 20,
                  ),
                  PopupMenuButton(
                    useRootNavigator: true,
                    onOpened: () {
                      openNetwork.value = true;
                    },
                    onCanceled: () {
                      openNetwork.value = false;
                    },
                    onSelected: (network) {
                      openNetwork.value = false;
                      selectedNetwork.value = network as int;
                    },
                    padding: const EdgeInsets.only(top: 0),
                    position: PopupMenuPosition.under,
                    color: Colors.white,
                    initialValue: selectedNetwork.value,
                    itemBuilder: (context) => [
                      ...providers.map(
                        (network) => PopupMenuItem(
                          value: network['id'],
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Image.asset(
                                'assets/images/network_providers/${network['logo']}',
                                height: 20,
                                width: 20,
                              ),
                              Text(network['name']),
                              selectedNetwork.value == network['id']
                                  ? const Icon(
                                      Icons.check_circle,
                                      color: AppColor.success,
                                    )
                                  : const Icon(Icons.circle_outlined)
                            ],
                          ),
                        ),
                      )
                    ],
                    icon: Row(
                      children: [
                        Image.asset(
                          'assets/images/network_providers/${providers[selectedNetwork.value]['logo']}',
                          height: 20,
                          width: 20,
                        ),
                        openNetwork.value == false
                            ? const Icon(Icons.arrow_drop_down)
                            : const Icon(Icons.arrow_drop_up)
                      ],
                    ),
                  )
                ],
              ),
              const SizedBox(
                height: 20,
              ),
              const Text(
                "Top Up",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: AppColor.primaryColor.withOpacity(0.05),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: GridView.builder(
                  scrollDirection: Axis.vertical,
                  padding: const EdgeInsets.only(bottom: 20),
                  shrinkWrap: true,
                  physics: const ScrollPhysics(),
                  dragStartBehavior: DragStartBehavior.start,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3),
                  itemCount: networks.length,
                  itemBuilder: (context, index) {
                    return TouchableOpacity(
                      onTapDown: (_) => selectedPlan.value = index,
                      onTapUp: (_) => selectedPlan.value = null,
                      onTap: () {
                        amountController.text =
                            airtimePrice[index]['price'].toString();
                      },
                      activeOpacity: 0.7,
                      // onTapDown: (_) => selectedPlan.value = null,
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          color: selectedPlan.value == index
                              ? AppColor.primaryColor
                              : Colors.black.withOpacity(0.04),
                          border: Border.all(
                              color: AppColor.primaryColor,
                              width: 2,
                              strokeAlign: BorderSide.strokeAlignInside),
                        ),
                        margin: const EdgeInsets.all(15),

                        // color: AppColor.primaryColor,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  currency(context),
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontFamily: AppFont.mulish,
                                    fontSize: 15,
                                    color: selectedPlan.value == index
                                        ? Colors.white
                                        : AppColor.secondaryColor,
                                  ),
                                ),
                                const SizedBox(
                                  width: 4,
                                ),
                                Text(
                                  airtimePrice[index]['price'].toString(),
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 20,
                                      color: selectedPlan.value == index
                                          ? Colors.white
                                          : AppColor.primaryColor),
                                ),
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  "Pay",
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontFamily: AppFont.mulish,
                                    fontSize: 10,
                                    color: selectedPlan.value == index
                                        ? Colors.white
                                        : AppColor.secondaryColor,
                                  ),
                                ),
                                SizedBox(
                                  width: 4,
                                ),
                                Text(
                                  "${currency(context)}${airtimePrice[index]['price']}",
                                  style: TextStyle(
                                      fontFamily: AppFont.mulish,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 10,
                                      color: selectedPlan.value == index
                                          ? Colors.white
                                          : AppColor.primaryColor),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
              Row(
                children: [
                  Expanded(
                    flex: 1,
                    child: TextFormField(
                      controller: amountController,
                      decoration: InputDecoration(
                        prefix: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            currency(context),
                            style: const TextStyle(
                              fontFamily: AppFont.mulish,
                              color: AppColor.primaryColor,
                            ),
                          ),
                        ),
                        filled: false,
                        hintText: "50, - 1,000,000",
                        helperText: '',
                        focusedBorder: borderStyle,
                        enabledBorder: borderStyle,
                        focusedErrorBorder: borderStyle,
                        errorBorder: borderStyle,
                        border: borderStyle,
                        contentPadding: const EdgeInsets.all(8),
                        hintStyle: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontFamily: AppFont.aeonik,
                          fontSize: 23,
                        ),
                      ),
                      keyboardType:
                          const TextInputType.numberWithOptions(decimal: false),
                      onTapOutside: (v) =>
                          FocusManager.instance.primaryFocus?.unfocus(),
                    ),
                  ),
                  SizedBox(
                    width: 20,
                  ),
                  TextButton(
                    style: const ButtonStyle(
                      backgroundColor:
                          WidgetStatePropertyAll(AppColor.primaryColor),
                    ),
                    onPressed: () {},
                    child: const Text(
                      "Pay",
                      style: TextStyle(color: Colors.white),
                    ),
                  )
                ],
              ),
              const SizedBox(
                height: 90,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
