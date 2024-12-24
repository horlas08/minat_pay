import 'package:flutter/material.dart';
import 'package:simple_app_cache_manager/simple_app_cache_manager.dart';
import 'package:touchable_opacity/touchable_opacity.dart';

import '../../../config/color.constant.dart';

class AppCacheWidget extends StatefulWidget {
  const AppCacheWidget({super.key});

  @override
  State<AppCacheWidget> createState() => _AppCacheWidgetState();
}

class _AppCacheWidgetState extends State<AppCacheWidget> with CacheMixin {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(
        12,
      ),
      decoration: BoxDecoration(
        color: AppColor.primaryColor.withOpacity(0.2),
        borderRadius: BorderRadius.circular(15),
      ),
      child: Row(
        children: [
          const Text(
            "Clear Cache",
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const Spacer(),
          ValueListenableBuilder(
            valueListenable: cacheSizeNotifier,
            builder: (context, cacheSize, child) => Text(
              cacheSize,
              style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
            ),
          ),
          const Spacer(),
          TouchableOpacity(
            onTap: () {
              cacheManager.clearCache();
              updateCacheSize();
            },
            child: Container(
              padding: const EdgeInsets.all(
                10,
              ),
              decoration: BoxDecoration(
                color: Colors.black,
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Icon(
                Icons.cleaning_services_outlined,
                size: 30,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

mixin CacheMixin on State<AppCacheWidget> {
  late final SimpleAppCacheManager cacheManager;
  late ValueNotifier<String> cacheSizeNotifier = ValueNotifier<String>('');

  @override
  void initState() {
    super.initState();
    cacheManager = SimpleAppCacheManager();
    updateCacheSize();
  }

  void updateCacheSize() async {
    final cacheSize = await cacheManager.getTotalCacheSize();
    cacheSizeNotifier.value = cacheSize;
  }
}
