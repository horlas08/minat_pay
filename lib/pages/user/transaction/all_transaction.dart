import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:touchable_opacity/touchable_opacity.dart';
import 'package:widget_visibility_detector/widget_visibility_detector.dart';

import '../../../bloc/repo/app/app_bloc.dart';
import '../../../config/font.constant.dart';
import '../../../helper/helper.dart';
import '../../../widget/user/dashboard/transaction_item.dart';

class AllTransaction extends HookWidget {
  const AllTransaction({super.key});

  @override
  Widget build(BuildContext context) {
    final ValueNotifier<List<dynamic>> transactionList = useState([]);
    final ValueNotifier<bool> loading = useState(true);
    final user = context.read<AppBloc>().state.user;

    useEffect(() {
      getTransaction().then((res) {
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
      await Future.delayed(Duration(milliseconds: 1000));
      // if failed,use refreshFailed()
      _refreshController.refreshCompleted();
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'All Transaction',
          style: TextStyle(
            fontSize: 20,
            fontFamily: AppFont.mulish,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.only(left: 18.0, right: 18.0, bottom: 20),
        child: WidgetVisibilityDetector(
          onAppear: () {
            _refreshController.refreshCompleted();
            print('tab1 onAppear');
            print(user);
          },
          child: loading.value
              ? const Center(
                  child: CircularProgressIndicator(),
                )
              : transactionList.value.isNotEmpty
                  ? SmartRefresher(
                      onRefresh: _onRefresh,
                      controller: _refreshController,
                      header: const WaterDropHeader(),
                      child: ListView.builder(
                          primary: false,
                          shrinkWrap: true,
                          itemCount: transactionList.value.length,
                          itemBuilder: (context, index) {
                            return TouchableOpacity(
                              onTap: () {
                                context.pushNamed('transactionDetails',
                                    pathParameters: {
                                      'id': transactionList.value[index]
                                          ['trxid']
                                    });
                              },
                              activeOpacity: 0.4,
                              behavior: HitTestBehavior.translucent,
                              child: TransactionItem(
                                data: transactionList.value[index],
                              ),
                            );
                          }),
                    )
                  : const Center(
                      child: Text(
                        "No Transaction Found",
                        style: TextStyle(fontSize: 26),
                      ),
                    ),
        ),
      ),
    );
  }
}
