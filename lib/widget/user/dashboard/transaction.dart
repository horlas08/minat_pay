import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:minat_pay/widget/user/dashboard/transaction_item.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:touchable_opacity/touchable_opacity.dart';
import 'package:widget_visibility_detector/widget_visibility_detector.dart';

import '../../../bloc/repo/app/app_bloc.dart';
import '../../../config/color.constant.dart';
import '../../../helper/helper.dart';

class Transaction extends HookWidget {
  const Transaction({super.key});

  @override
  Widget build(BuildContext context) {
    // final ValueNotifier<List<Map<String, dynamic>>>  items = useState([]);
    final ValueNotifier<bool> loading = useState(true);
    final ValueNotifier<List<dynamic>> transactionList = useState([]);
    final user = context.read<AppBloc>().state.user;

    useEffect(() {
      getTransaction(limit: 5).then((res) {
        print(res?.data);
        if (res?.statusCode == HttpStatus.ok &&
            res?.data.containsKey('transactions') &&
            res?.data['transactions'].length > 0) {
          transactionList.value = res?.data['transactions'];
        }
        loading.value = false;
      });
      return null;
    }, []);
    RefreshController _refreshController =
        RefreshController(initialRefresh: false);
    void _onRefresh() async {
      // monitor network fetch

      getTransaction(limit: 5).then((res) {
        print(res?.data);
        if (res == null) {
          return _refreshController.refreshFailed();
        }
        if (res.statusCode == HttpStatus.ok &&
            res.data.containsKey('transactions') &&
            res.data['transactions'].length > 0) {
          transactionList.value = res.data['transactions'];
        }

        loading.value = false;
      });
      // if failed,use refreshFailed()
      _refreshController.refreshCompleted();
    }

    // void _onLoading() async {
    //   // monitor network fetch
    //   await Future.delayed(Duration(milliseconds: 1000));
    //   // if failed,use loadFailed(),if no data return,use LoadNodata()
    //   items.add((items.length + 1).toString());
    //   if (mounted) setState(() {});
    //   _refreshController.loadComplete();
    // }

    return WidgetVisibilityDetector(
      onAppear: () {
        _refreshController.refreshCompleted();
        print('tab1 onAppear');
        print(user);
      },
      child: Column(
        children: [
          Row(
            children: [
              Text(
                "Transaction",
                style: Theme.of(context)
                    .textTheme
                    .titleSmall
                    ?.copyWith(fontWeight: FontWeight.w900),
              ),
              const Spacer(),
              TouchableOpacity(
                activeOpacity: 0.4,
                child: Text(
                  "View All",
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Mulish',
                        color: AppColor.blueColor,
                      ),
                ),
              ),
            ],
          ),
          const SizedBox(
            height: 30,
          ),
          SizedBox(
            height: 300,
            child: loading.value
                ? const Center(
                    child: CircularProgressIndicator(),
                  )
                : transactionList.value.isNotEmpty
                    ? SmartRefresher(
                        enablePullUp: false,

                        physics: const BouncingScrollPhysics(),
                        onRefresh: _onRefresh,
                        controller: _refreshController,
                        header: const WaterDropHeader(),
                        child: Column(
                          children: [
                            ...List.generate(
                              transactionList.value.length,
                              (index) {
                                return TouchableOpacity(
                                  onTap: () {
                                    context.pushNamed('transactionDetails',
                                        pathParameters: {
                                          'id': transactionList.value[index]
                                              ['trxid']
                                        });
                                  },
                                  activeOpacity: 0.98,
                                  behavior: HitTestBehavior.translucent,
                                  child: TransactionItem(
                                    data: transactionList.value[index],
                                  ),
                                );
                              },
                            ),
                          ],
                        ),
                        // child: ListView.builder(
                        //     physics: const BouncingScrollPhysics(),
                        //
                        //     itemCount: transactionList.value.length,
                        //     itemBuilder: (context, index) {
                        //       return TouchableOpacity(
                        //         onTap: () {
                        //           context.pushNamed('transactionDetails',
                        //               pathParameters: {
                        //                 'id': transactionList.value[index]
                        //                     ['trxid']
                        //               });
                        //         },
                        //         activeOpacity: 0.98,
                        //         behavior: HitTestBehavior.translucent,
                        //         child: TransactionItem(
                        //           data: transactionList.value[index],
                        //         ),
                        //       );
                        //     }),
                      )
                    : const Center(
                        child: Text(
                          "No Transaction Found",
                          style: TextStyle(fontSize: 26),
                        ),
                      ),
          )
        ],
      ),
    );
  }
}
