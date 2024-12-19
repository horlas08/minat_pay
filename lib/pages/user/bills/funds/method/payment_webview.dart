import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:webview_flutter/webview_flutter.dart';

import '../../../../../config/font.constant.dart';
import '../../../../../helper/helper.dart';

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

    WebViewController controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..canGoBack()
      ..platform
      ..setNavigationDelegate(
        NavigationDelegate(
          onProgress: (int progress) {
            // Update loading bar.
          },
          onUrlChange: (change) {
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
              if (request.url.endsWith('cancel') ||
                  request.url.endsWith('close')) {
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

            return NavigationDecision.navigate;
          },
        ),
      )
      ..setBackgroundColor(Colors.blueGrey)
      ..loadRequest(Uri.parse(url.trim()));

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
      body: Padding(
        padding: const EdgeInsets.only(left: 0.0, right: 0.0, bottom: 20),
        child: WebViewWidget(
          controller: controller,
          // gestureRecognizers: {Factory(() => EagerGestureRecognizer())},
        ),
      ),
    );
  }
}
