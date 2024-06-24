import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:minat_pay/config/color.constant.dart';
import 'package:touchable_opacity/touchable_opacity.dart';

import '../../../../config/font.constant.dart';
import '../../../../data/mock/dummy_data.dart';
import '../../../../helper/helper.dart';

final TextEditingController amountController = TextEditingController();

class Electricity extends HookWidget {
  const Electricity({super.key});

  @override
  Widget build(BuildContext context) {
    final ValueNotifier<int?> amountSelected = useState(null);
    final ValueNotifier<String> electricityType = useState('prepaid');
    UnderlineInputBorder borderStyle = const UnderlineInputBorder(
      borderSide: BorderSide(
          style: BorderStyle.solid, color: AppColor.primaryColor, width: 2),
    );
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Electricity",
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
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              decoration: BoxDecoration(
                color: AppColor.primaryColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(10),
              ),
              padding: const EdgeInsets.all(10),
              margin: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Select Provider",
                    textAlign: TextAlign.left,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontFamily: AppFont.mulish,
                      fontSize: 20,
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  TextFormField(
                    keyboardType: const TextInputType.numberWithOptions(
                      decimal: false,
                      signed: false,
                    ),
                    enabled: false,
                    decoration: const InputDecoration(
                      hintText: "Select Provider",
                      hintStyle: TextStyle(
                        fontSize: 18,
                        color: AppColor.primaryColor,
                      ),
                      suffixIcon: Icon(Icons.arrow_forward_ios_rounded),
                      border: InputBorder.none,
                      enabledBorder: InputBorder.none,
                      focusedBorder: InputBorder.none,
                      enabled: false,
                    ),
                    onTapOutside: (v) {
                      FocusManager.instance.primaryFocus?.unfocus();
                    },
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Stack(
                        children: [
                          TouchableOpacity(
                            onTap: () {
                              electricityType.value = 'prepaid';
                            },
                            child: Container(
                              height: 60,
                              width: 150,
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                color: AppColor.primaryColor.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(10),
                                border: electricityType.value == 'prepaid'
                                    ? Border.all(
                                        color: AppColor.primaryColor,
                                        width: 2,
                                      )
                                    : Border.fromBorderSide(BorderSide.none),
                              ),
                              child: const Text(
                                "Prepaid",
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.w500,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ),
                          if (electricityType.value == 'prepaid')
                            Positioned(
                              bottom: 0,
                              right: 0,
                              child: Container(
                                decoration: const BoxDecoration(
                                  borderRadius: BorderRadius.only(
                                    topLeft: Radius.elliptical(30, 30),
                                  ),
                                  color: AppColor.primaryColor,
                                ),
                                padding: const EdgeInsets.only(top: 4, left: 4),
                                child: const Icon(
                                  Icons.check,
                                  size: 20,
                                  color: Colors.white,
                                ),
                              ),
                            )
                        ],
                      ),
                      const SizedBox(
                        width: 5,
                      ),
                      Stack(
                        children: [
                          TouchableOpacity(
                            child: Container(
                              height: 60,
                              width: 150,
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                color: AppColor.primaryColor.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(10),
                                border: electricityType.value == 'postpaid'
                                    ? Border.all(
                                        color: AppColor.primaryColor,
                                        width: 2,
                                      )
                                    : Border.fromBorderSide(BorderSide.none),
                              ),
                              child: const Text(
                                "Postpaid",
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.w500,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ),
                            onTap: () {
                              electricityType.value = 'postpaid';
                            },
                          ),
                          if (electricityType.value == 'postpaid')
                            Positioned(
                              bottom: 0,
                              right: 0,
                              child: Container(
                                decoration: const BoxDecoration(
                                  borderRadius: BorderRadius.only(
                                    topLeft: Radius.elliptical(30, 30),
                                  ),
                                  color: AppColor.primaryColor,
                                ),
                                padding: const EdgeInsets.only(top: 4, left: 4),
                                child: const Icon(
                                  Icons.check,
                                  size: 20,
                                  color: Colors.white,
                                ),
                              ),
                            )
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  const Text(
                    "Meter Number",
                    textAlign: TextAlign.left,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontFamily: AppFont.mulish,
                      fontSize: 20,
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  TextFormField(
                    keyboardType: const TextInputType.numberWithOptions(
                      decimal: false,
                      signed: false,
                    ),
                    decoration: const InputDecoration(
                      hintText: "Enter Meter Number",
                      hintStyle: TextStyle(
                        fontSize: 18,
                        color: AppColor.primaryColor,
                      ),
                      disabledBorder: InputBorder.none,
                      border: InputBorder.none,
                      enabledBorder: InputBorder.none,
                      focusedBorder: InputBorder.none,
                    ),
                    onTapOutside: (v) {
                      FocusManager.instance.primaryFocus?.unfocus();
                    },
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  const Text(
                    "Select Amount",
                    textAlign: TextAlign.left,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontFamily: AppFont.mulish,
                      fontSize: 20,
                    ),
                  ),
                  GridView.builder(
                    scrollDirection: Axis.vertical,
                    padding: const EdgeInsets.only(bottom: 20),
                    shrinkWrap: true,
                    physics: const ScrollPhysics(),
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 3),
                    itemCount: bettingPrice.length,
                    itemBuilder: (context, index) {
                      return TouchableOpacity(
                        onTapDown: (_) => amountSelected.value = index,
                        onTapUp: (_) => amountSelected.value = null,
                        onTap: () {
                          amountController.text =
                              bettingPrice[index]['price'].toString();
                        },
                        activeOpacity: 0.7,
                        // onTapDown: (_) => selectedPlan.value = null,
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            color: amountSelected.value == index
                                ? AppColor.primaryColor
                                : Colors.black.withOpacity(0.04),
                            border: Border.all(
                                color: AppColor.primaryColor,
                                width: 2,
                                strokeAlign: BorderSide.strokeAlignInside),
                          ),
                          margin: const EdgeInsets.all(15),
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
                                      color: amountSelected.value == index
                                          ? Colors.white
                                          : AppColor.secondaryColor,
                                    ),
                                  ),
                                  const SizedBox(
                                    width: 4,
                                  ),
                                  Text(
                                    bettingPrice[index]['price'].toString(),
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 20,
                                        color: amountSelected.value == index
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
                                      color: amountSelected.value == index
                                          ? Colors.white
                                          : AppColor.secondaryColor,
                                    ),
                                  ),
                                  const SizedBox(
                                    width: 4,
                                  ),
                                  Text(
                                    "${currency(context)}${bettingPrice[index]['price']}",
                                    style: TextStyle(
                                        fontFamily: AppFont.mulish,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 10,
                                        color: amountSelected.value == index
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
                  Row(
                    children: [
                      Expanded(
                        flex: 1,
                        child: TextFormField(
                          controller: amountController,
                          decoration: InputDecoration(
                            filled: false,
                            hintText: "50, - 1,000,000",
                            helperText: '',
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
                          keyboardType: const TextInputType.numberWithOptions(
                              decimal: false),
                          onTapOutside: (v) =>
                              FocusManager.instance.primaryFocus?.unfocus(),
                        ),
                      ),
                      const SizedBox(
                        width: 20,
                      ),
                    ],
                  ),
                  ElevatedButton(
                    onPressed: () {
                      FocusManager.instance.primaryFocus?.unfocus();
                    },
                    style: ButtonStyle(
                      minimumSize: WidgetStateProperty.all(
                        const Size.fromHeight(65),
                      ),
                    ),
                    child: const Text(
                      "Next",
                      style: TextStyle(
                          color: Colors.white, fontWeight: FontWeight.bold),
                    ),
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
