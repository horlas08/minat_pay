import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:minat_pay/bloc/repo/app/app_bloc.dart';
import 'package:minat_pay/helper/helper.dart';
import 'package:minat_pay/main.dart';
import 'package:minat_pay/widget/app_header.dart';
import 'package:touchable_opacity/touchable_opacity.dart';
import 'package:url_launcher/url_launcher.dart';

class Support extends StatelessWidget {
  const Support({super.key});

  @override
  Widget build(BuildContext context) {
    final user = context.read<AppBloc>().state.user;
    return Scaffold(
      appBar: const AppHeader(
        title: "",
        showAction: false,
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Hello ${user?.firstName}",
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w800,
              ),
            ),
            const Text(
              "How can we help you today?",
              style: TextStyle(
                fontSize: 10,
                color: Colors.grey,
                fontWeight: FontWeight.w800,
              ),
            ),
            const SizedBox(
              height: 30,
            ),
            FittedBox(
              child: SvgPicture.asset(
                "assets/svg/support_image.svg",
                height: 317,
                width: 214,
              ),
            ),
            const SizedBox(
              height: 40,
            ),
            TouchableOpacity(
              onTap: () async {
                try {
                  final url = Uri.parse(
                      "tel:${appServer.serverResponse.contact!.call!}");
                  await launchUrl(url);
                } on PlatformException catch (error) {
                  if (!context.mounted) return;
                  await alertHelper(context, 'error', error.message ?? "error");
                }
              },
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const Icon(Icons.support_agent_rounded),
                  const SizedBox(
                    width: 15,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "Call center line",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      Text(
                        appServer.serverResponse.contact!.call!,
                        style: const TextStyle(color: Colors.grey),
                      ),
                    ],
                  )
                ],
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            TouchableOpacity(
              onTap: () async {
                try {
                  final url = Uri.parse(
                      "mailto:${appServer.serverResponse.contact!.email!}?subject=Minatpay support &body=Hello,%20am%20 ${user?.username}");
                  await launchUrl(url);
                } on PlatformException catch (error) {
                  if (!context.mounted) return;
                  await alertHelper(context, 'error', error.message ?? "error");
                }
              },
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.email_outlined,
                  ),
                  const SizedBox(
                    width: 15,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "Email Us",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      Text(
                        appServer.serverResponse.contact!.email!,
                        style: const TextStyle(color: Colors.grey),
                      ),
                    ],
                  )
                ],
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            TouchableOpacity(
              onTap: () async {
                try {
                  final url = Uri.parse(
                      "https://wa.me/${appServer.serverResponse.contact!.whatsapp!}?text=Hello%20i%20need%20help%20with%20my%20minatpay%20account");
                  await launchUrl(url);
                } on PlatformException catch (error) {
                  if (!context.mounted) return;
                  await alertHelper(context, 'error', error.message ?? "error");
                }
              },
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SvgPicture.asset("assets/svg/WhatsappLogo.svg"),
                  const SizedBox(
                    width: 15,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "Whatsapp line",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      Text(
                        appServer.serverResponse.contact!.whatsapp!,
                        style: const TextStyle(color: Colors.grey),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(
              height: 20,
            ),
          ],
        ),
      ),
    );
  }
}
