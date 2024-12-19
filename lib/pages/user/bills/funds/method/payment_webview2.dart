import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_paystack_max/flutter_paystack_max.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:minat_pay/helper/helper.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:webview_flutter/webview_flutter.dart';

import '../../../../../config/font.constant.dart';
import '../../../../../main.dart';

class PaymentWebView extends HookWidget {
  final String url;
  final String reference;
  const PaymentWebView({super.key, required this.url, required this.reference});

  @override
  Widget build(BuildContext context) {
    useEffect(() {
      print(url);
      print(reference);
    }, []);
    RefreshController _refreshController =
        RefreshController(initialRefresh: false);

    WebViewController controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setNavigationDelegate(
        NavigationDelegate(
          onProgress: (int progress) {
            progress == 100
                ? context.loaderOverlay.hide()
                : context.loaderOverlay.show();
          },
          onUrlChange: (change) {
            print("url change");
            print(change.url);
          },
          onPageStarted: (String url) {},
          onPageFinished: (String url) {},
          onHttpError: (HttpResponseError error) async {
            // Navigator.of(context).pop(); //close webview
            // await alertHelper(context, 'error', "Network Error");
            await alertHelper(context, 'error', error.toString());
            print(error);
          },
          onWebResourceError: (WebResourceError error) async {
            await alertHelper(context, 'error', error.description);
            print("_______");
            print(error.description);
            print("________");
          },
          onNavigationRequest: (NavigationRequest request) async {
            final parseUrl = Uri.parse(request.url);
            if (request.url == 'https://standard.paystack.co/close') {
              Navigator.of(context).pop(); //close webview
              await alertHelper(context, 'error', 'payment close');
            }
            if (context.mounted) {
              if (request.url.endsWith('cancel')) {
                Navigator.pop(context);
                await alertHelper(context, 'error', 'payment cancel');
                return NavigationDecision.prevent;
              }
            }

            if (request.url.startsWith('btravel://') ||
                request.url.contains('opay://')) {
              print('here');
              if (await canLaunchUrl(parseUrl)) {
                await launchUrl(parseUrl, mode: LaunchMode.externalApplication);
              } else {
                print(request.url);
              }
              return NavigationDecision.prevent;
            }

            print(request.url);
            if (context.mounted) {
              if (request.url.endsWith('cancel')) {
                Navigator.pop(context);
                await alertHelper(context, 'error', 'payment cancel');
                return NavigationDecision.prevent;
              }
            }

            if (request.url.contains(
                appServer.serverResponse.appconfiguration!.pcallback!)) {
              if (context.mounted) {
                // Navigator.of(context).pop();
                final res = await PaymentService.verifyTransaction(
                  paystackSecretKey:
                      appServer.serverResponse.appconfiguration!.psecret!,
                  reference,
                );

                if (res.data.status == PaystackTransactionStatus.success) {
                  if (context.mounted) {
                    return await alertHelper(
                        context, "success", "Payment Verification successful");
                  }
                } else {
                  if (context.mounted) {
                    return await alertHelper(
                        context, "error", "Payment Verification fail");
                  }
                }
              }
            }
            return NavigationDecision.navigate;
          },
        ),
      )
      ..loadRequest(Uri.parse('https://google.com'));

    Future<void> _onRefresh(BuildContext context) async {
      _refreshController.requestLoading();
      await controller.reload();
      _refreshController.refreshFailed();
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Paystack Checkout',
          style: TextStyle(
            fontSize: 20,
            fontFamily: AppFont.mulish,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: SmartRefresher(
        controller: _refreshController,
        header: const WaterDropHeader(),
        onRefresh: () => _onRefresh(context),
        child: Padding(
          padding: const EdgeInsets.only(left: 18.0, right: 18.0, bottom: 20),
          child: WebViewWidget(
            controller: controller,
          ),
        ),
      ),
    );
  }
}
