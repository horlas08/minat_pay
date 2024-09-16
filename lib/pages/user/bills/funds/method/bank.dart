import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:minat_pay/config/color.constant.dart';
import 'package:minat_pay/helper/helper.dart';
import 'package:share_plus/share_plus.dart';

import '../../../../../bloc/repo/app/app_bloc.dart';

class Bank extends StatelessWidget {
  const Bank({super.key});

  @override
  Widget build(BuildContext context) {
    List<Color> balanceColor = [Colors.red, Colors.greenAccent, Colors.purple];
    final accounts = context.read<AppBloc>().state.accounts;
    return SingleChildScrollView(
      scrollDirection: Axis.vertical,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          ...?accounts?.map(
            (account) {
              return Container(
                margin: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  // color: balanceColor[2],
                  color: AppColor.primaryColor,
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 15.0,
                    vertical: 12,
                  ),
                  child: Column(
                    children: [
                      const SizedBox(
                        height: 10,
                      ),
                      const Text(
                        "Account Number",
                        style: TextStyle(
                          fontSize: 25,
                          color: Colors.white,
                        ),
                      ),
                      Text(
                        account.accountNumber!,
                        style: const TextStyle(
                          fontSize: 25,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      const Text(
                        "Bank Bank",
                        style: TextStyle(
                          fontSize: 25,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      Text(
                        account.bankName!,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontSize: 25,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      const Text(
                        "Account Name",
                        style: TextStyle(
                          fontSize: 25,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      Text(
                        account.accountName!,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontSize: 25,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(
                        height: 15,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          IconButton(
                            onPressed: () async {
                              final result = await Share.share(
                                  'Account Number: ${account.accountNumber}  \n Account Name: ${account.accountName} \n Bank Name: ${account.bankName}');

                              if (result.status == ShareResultStatus.success) {
                                print(
                                    'Thank you for sharing your account details');
                              }
                            },
                            icon: const Icon(
                              Icons.share,
                              color: Colors.white,
                            ),
                          ),
                          // const Spacer(),
                          IconButton(
                            onPressed: () {
                              Clipboard.setData(
                                ClipboardData(text: account.accountNumber!),
                              ).then(
                                (value) {
                                  alertHelper(context, 'success',
                                      'Account Number (${account.accountNumber!}) Copy SuccessFul');
                                },
                              );
                            },
                            icon: const Icon(
                              Icons.copy,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              );
            },
          )
        ],
      ),
    );
  }
}
