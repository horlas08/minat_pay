import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_native_contact_picker/flutter_native_contact_picker.dart'
    as contact_picker;
import 'package:minat_pay/config/color.constant.dart';
import 'package:minat_pay/config/font.constant.dart';
import 'package:minat_pay/widget/user/payment_modal.dart';
import 'package:phone_form_field/phone_form_field.dart';
import 'package:touchable_opacity/touchable_opacity.dart';

final PhoneController phoneController = PhoneController(
    initialValue: const PhoneNumber(isoCode: IsoCode.NG, nsn: ''));

final List<Map<String, dynamic>> providers = [
  {
    'id': 0,
    'name': 'Mtn',
    'logo': 'mtn_logo.jpg',
  },
  {
    'id': 1,
    'name': 'Glo',
    'logo': 'glo_logo.jpg',
  },
  {
    'id': 2,
    'name': 'Airtel',
    'logo': 'airtel_logo.png',
  },
  {
    'id': 3,
    'name': '9Mobile',
    'logo': '9mobile_logo.jpg',
  },
];

class Data extends HookWidget {
  const Data({super.key});

  @override
  Widget build(BuildContext context) {
    final networks = List.generate(20, (i) => i);
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
      // extendBody: true,
      appBar: AppBar(
        title: const Text(
          'Mobile Data',
          style: TextStyle(
              fontSize: 20,
              fontFamily: AppFont.mulish,
              fontWeight: FontWeight.bold),
        ),
        actions: [
          TextButton(
            onPressed: () {},
            child: const Text('History',
                style: TextStyle(
                    fontSize: 20,
                    fontFamily: AppFont.mulish,
                    fontWeight: FontWeight.bold)),
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

                          // print(PhoneNumber.parse(contact!.phoneNumbers!.last,
                          //     callerCountry: IsoCode.NG));
                          phoneController.value = PhoneNumber(
                              isoCode: IsoCode.NG,
                              nsn: contact!.phoneNumbers!.last);
                          // phoneController.value = PhoneNumber.parse(
                          //     contact!.phoneNumbers!.last,
                          //     callerCountry: IsoCode.NG);
                          print(phoneController.value);
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
                      // initialValue: phone.value,
                      // or use the
                      // PhoneNumber.parse(phone.value), // or use the
                      // controller
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
              GridView.builder(
                scrollDirection: Axis.vertical,
                // cacheExtent: 30,
                padding: const EdgeInsets.only(bottom: 20),
                shrinkWrap: true,
                physics: const ScrollPhysics(),
                dragStartBehavior: DragStartBehavior.start,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 4),
                itemCount: networks.length,
                itemBuilder: (context, index) {
                  return TouchableOpacity(
                    onTap: () => selectedPlan.value = index,
                    activeOpacity: 0.7,
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color: selectedPlan.value == index
                            ? AppColor.primaryColor
                            : Colors.black.withOpacity(0.1),
                        border: Border.all(
                            color: AppColor.primaryColor,
                            width: 2,
                            strokeAlign: BorderSide.strokeAlignInside),
                      ),
                      margin: const EdgeInsets.all(5),
                      // color: AppColor.primaryColor,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            '2gb',
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: selectedPlan.value == index
                                    ? Colors.white
                                    : AppColor.secondaryColor),
                          ),
                          Text(
                            '7days',
                            style: TextStyle(
                                fontWeight: selectedPlan.value == index
                                    ? FontWeight.bold
                                    : FontWeight.normal),
                          ),
                          Text(
                            'N1000',
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: selectedPlan.value == index
                                    ? Colors.white
                                    : AppColor.primaryColor),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
              Padding(
                padding: const EdgeInsets.all(15.0),
                child: TouchableOpacity(
                  child: ElevatedButton(
                    onPressed: () {
                      paymentModal(
                          context: context, title: "Complete Data Payment");
                    },
                    style: const ButtonStyle(
                      minimumSize: WidgetStatePropertyAll(
                        Size.fromHeight(65),
                      ),
                    ),
                    child: const Text(
                      "Pay Now",
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
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
