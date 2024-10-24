import 'dart:async';
import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:form_validator/form_validator.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:minat_pay/bloc/repo/app/app_bloc.dart';
import 'package:minat_pay/bloc/repo/app/app_event.dart';
import 'package:minat_pay/bloc/repo/app/app_state.dart';
import 'package:minat_pay/config/color.constant.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:touchable_opacity/touchable_opacity.dart';

import '../../../config/app.config.dart';
import '../../../helper/helper.dart';
import '../../../widget/app_header.dart';

showEditProfileModal(
    BuildContext context,
    TextEditingController updateFieldController,
    String fieldName,
    String fieldValue) {
  showGeneralDialog(
    context: context,
    barrierDismissible: true,
    barrierLabel: 'close',
    pageBuilder: (context, animation, secondaryAnimation) {
      return AlertDialog(
        // icon: Icon(Icons.add),
        title: const Text(
          "Update Profile",
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 14),
        ),

        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        content: Container(
          // height: 100,
          // width: double.infinity,
          constraints: const BoxConstraints(
            maxHeight: 150,
            minHeight: 100,
          ),
          child: Form(
              key: _updateProfileKey,
              child: Column(
                // mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    fieldName.toUpperCase().trim(),
                    textAlign: TextAlign.start,
                    style: TextStyle(
                      fontSize: 12,
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                  TextFormField(
                    validator: ValidationBuilder().required().build(),
                    controller: updateFieldController,
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    style: const TextStyle(color: AppColor.primaryColor),
                    decoration: const InputDecoration(
                      hintText: "",
                      hintStyle: TextStyle(
                        fontSize: 12,
                        color: AppColor.primaryColor,
                      ),
                      contentPadding: EdgeInsets.all(10),
                      border: InputBorder.none,
                      enabledBorder: InputBorder.none,
                      errorBorder: InputBorder.none,
                      focusedErrorBorder: InputBorder.none,
                      focusedBorder: InputBorder.none,
                    ),
                    onTapOutside: (v) {
                      FocusManager.instance.primaryFocus?.unfocus();
                    },
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        if (updateFieldController.text == fieldValue) {
                          return context.pop();
                        } else if (_updateProfileKey.currentState!.validate()) {
                          updateProfileRequest(
                              context, fieldName, updateFieldController.text);
                        }
                      },
                      child: Text(
                        'Update',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  )
                ],
              )),
        ),
      );
    },
  );
}

Future<void> updateProfileRequest(
    BuildContext context, String fieldName, String fieldValue) async {
  debugPrint(fieldName);
  debugPrint(fieldValue);
  // final token = context.read<AppBloc>().state.user?.apiKey;

  context.loaderOverlay.show();
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  final formData = {
    fieldName.toLowerCase(): fieldValue,
    'token': prefs.getString('token'),
  };
  print(formData);
  final resp = await curlPostRequest(
    path: profileUpdate,
    data: formData,
  );
  print(resp);
  if (resp?.statusCode == HttpStatus.ok && context.mounted) {
    final res = await refreshUSerDetail();
    if (res == null && context.mounted) {
      context.pop();
      context.loaderOverlay.hide();
      return await alertHelper(
          context, "error", "Unable to Update Check Internet Connection");
    }
    print(res);
    if (res?.statusCode == HttpStatus.ok && context.mounted) {
      context
          .read<AppBloc>()
          .add(UpdateUserEvent(userData: res?.data['data']['user_data']));
      context.pop();
      context.loaderOverlay.hide();

      return await alertHelper(context, "success", resp?.data['message']);
    }
  }
}

final _updateProfileKey = GlobalKey<FormState>();

class Profile extends HookWidget {
  const Profile({super.key});

  @override
  Widget build(BuildContext context) {
    const double space = 35;
    final ImagePicker picker = ImagePicker();
    final ValueNotifier<String?> fieldName = useState(null);
    final ValueNotifier<String?> fieldValue = useState(null);

    final updateFieldController = useTextEditingController();

    Future _pickImage({required ImageSource source}) async {
      final XFile? image = await picker.pickImage(
        source: source,
        imageQuality: 100,
        maxHeight: 500,
        maxWidth: 500,
      );
      if (image != null) {
        File file = File(image.path);
        String fileName = file.path.split('/').last;
        final SharedPreferences prefs = await SharedPreferences.getInstance();
        var formData = FormData.fromMap({
          'token': prefs.getString('token'),
          'photo': await MultipartFile.fromFile(
            file.path,
            filename: fileName,
          ),
        });
        if (context.mounted) {
          context.loaderOverlay.show();
          final resp = await curlPostRequest(
              path: profileUpdate,
              data: formData,
              options: Options(
                contentType: Headers.multipartFormDataContentType,
                headers: {
                  Headers.contentTypeHeader:
                      Headers.multipartFormDataContentType
                },
              ),
              queryParams: {'token': prefs.getString("token")});
          print(resp);
          if (resp?.statusCode == HttpStatus.ok && context.mounted) {
            final res = await refreshUSerDetail();
            print(res);
            if (res == null && context.mounted) {
              context.pop();
              context.loaderOverlay.hide();
              return await alertHelper(context, "error",
                  "Unable to Update Check Internet Connection");
            }
            print(res);
            if (res?.statusCode == HttpStatus.ok && context.mounted) {
              context.read<AppBloc>().add(
                  UpdateUserEvent(userData: res?.data['data']['user_data']));
              context.pop();
              context.loaderOverlay.hide();

              return await alertHelper(
                  context, "success", resp?.data['message']);
            } else {
              if (context.mounted) context.loaderOverlay.hide();
            }
          }
        }
      }
    }

    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: const AppHeader(
        title: 'Profile Settings',
      ),
      body: BlocConsumer<AppBloc, AppState>(
        listener: (context, state) {
          // TODO: implement listener
        },
        builder: (context, state) {
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 18.0, vertical: 20),
            child: Column(
              children: [
                Center(
                  child: TouchableOpacity(
                    activeOpacity: 0.3,
                    onTap: () {
                      showDialog(
                        useRootNavigator: true,
                        context: context,
                        builder: (context) {
                          return AlertDialog(
                            content: SizedBox(
                              height: 130,
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Column(
                                    children: [
                                      IconButton(
                                        onPressed: () async {
                                          try {
                                            _pickImage(
                                                source: ImageSource.gallery);
                                          } catch (e) {
                                            alertHelper(
                                                context, 'error', e.toString());
                                          }
                                        },
                                        icon: const Icon(
                                          Icons.image,
                                          size: 80,
                                          color: AppColor.primaryColor,
                                        ),
                                      ),
                                      const Text("Galary"),
                                    ],
                                  ),
                                  Column(
                                    children: [
                                      IconButton(
                                        onPressed: () async {
                                          _pickImage(
                                            source: ImageSource.camera,
                                          );
                                        },
                                        icon: const Icon(
                                          Icons.camera_alt_outlined,
                                          size: 80,
                                          color: AppColor.primaryColor,
                                        ),
                                      ),
                                      const Text("Camera"),
                                    ],
                                  )
                                ],
                              ),
                            ),
                          );
                        },
                      );
                    },
                    child: Container(
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey,
                            offset: Offset(0, 1),
                            blurRadius: 5,
                          ),
                        ],
                      ),
                      child: ClipOval(
                        child: Stack(
                          alignment: Alignment.bottomCenter,
                          children: [
                            Positioned(
                              child: CircleAvatar(
                                backgroundImage: CachedNetworkImageProvider(
                                  state.user!.photo!,
                                ),
                                radius: 50,
                                backgroundColor: AppColor.success,
                              ),
                            ),
                            Positioned(
                              bottom: 0,
                              // left: 0,
                              // right: 0,
                              child: Container(
                                height: 30,
                                width: 100,
                                decoration: const BoxDecoration(
                                  color: AppColor.primaryColor,
                                ),
                                child: const Icon(
                                  Icons.camera_alt_outlined,
                                  color: Colors.white,
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 50,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      "First Name",
                      style: TextStyle(
                        fontSize: 20,
                      ),
                    ),
                    Row(
                      children: [
                        Text(
                          state.user!.firstName!,
                          style: const TextStyle(
                            fontSize: 20,
                            color: AppColor.primaryColor,
                          ),
                        ),
                        IconButton(
                          onPressed: () {
                            updateFieldController.text =
                                state.user!.firstName!.trim();
                            fieldName.value = 'firstName';
                            fieldValue.value = state.user!.firstName!.trim();
                            showEditProfileModal(context, updateFieldController,
                                fieldName.value!, fieldValue.value!);
                          },
                          icon: const Icon(Icons.edit),
                          color: AppColor.primaryColor,
                        )
                      ],
                    ),
                  ],
                ),
                const SizedBox(
                  height: space - 20,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      "Last Name",
                      style: TextStyle(
                        fontSize: 20,
                      ),
                    ),
                    Row(
                      children: [
                        Text(
                          state.user!.lastName!,
                          style: const TextStyle(
                            fontSize: 20,
                            color: AppColor.primaryColor,
                          ),
                        ),
                        IconButton(
                          onPressed: () {
                            updateFieldController.text =
                                state.user!.lastName!.trim();
                            fieldName.value = 'lastName';
                            fieldValue.value = state.user!.lastName!.trim();
                            showEditProfileModal(context, updateFieldController,
                                fieldName.value!, fieldValue.value!);
                          },
                          icon: const Icon(Icons.edit),
                          color: AppColor.primaryColor,
                        )
                      ],
                    ),
                  ],
                ),
                const SizedBox(
                  height: space - 10,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      "User Name",
                      style: TextStyle(
                        fontSize: 20,
                      ),
                    ),
                    Text(
                      state.user!.username!,
                      style: const TextStyle(
                        fontSize: 20,
                        color: AppColor.primaryColor,
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: space - 10,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      "Phone Number",
                      style: TextStyle(
                        fontSize: 20,
                      ),
                    ),
                    Row(
                      children: [
                        Text(
                          state.user!.phoneNumber!,
                          style: const TextStyle(
                            fontSize: 20,
                            color: AppColor.primaryColor,
                          ),
                        ),
                        IconButton(
                          onPressed: () {
                            updateFieldController.text =
                                state.user!.phoneNumber!.trim();
                            fieldName.value = 'phoneNumber';
                            fieldValue.value = state.user!.phoneNumber!.trim();
                            showEditProfileModal(context, updateFieldController,
                                fieldName.value!, fieldValue.value!);
                          },
                          icon: const Icon(Icons.edit),
                          color: AppColor.primaryColor,
                        )
                      ],
                    ),
                  ],
                ),
                const SizedBox(
                  height: space - 10,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      "Email",
                      style: TextStyle(
                        fontSize: 20,
                      ),
                    ),
                    Text(
                      getEmailMask(state.user!.email!),
                      softWrap: true,
                      style: const TextStyle(
                        fontSize: 20,
                        color: AppColor.primaryColor,
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: space,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      "Account Type",
                      style: TextStyle(
                        fontSize: 20,
                      ),
                    ),
                    Text(
                      state.user!.userType! ? 'Agent' : "Normal",
                      softWrap: true,
                      style: const TextStyle(
                        fontSize: 20,
                        color: AppColor.primaryColor,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
