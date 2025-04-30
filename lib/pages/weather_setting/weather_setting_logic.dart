import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:styled_widget/styled_widget.dart';

class WeatherSettingLogic extends GetxController {

  Color customColor = Colors.white;
  var fahrenheit = true.obs;

  Uint8List? image;


  void colorSelect(BuildContext context) {
    var currentColor = customColor;
    showDialog(
        context: context,
        builder: (b) {
          return AlertDialog(
              title: const Text('Select Color'),
              content: GetBuilder<WeatherSettingLogic>(
                  id: 'color',
                  builder: (_) {
                    return SingleChildScrollView(
                      physics: const AlwaysScrollableScrollPhysics(),
                      child: ColorPicker(
                        pickerColor: currentColor,
                        colorPickerWidth: 240,
                        onColorChanged: (color) {
                          currentColor = color;
                          update(['color']);
                        },
                      ),
                    );
                  }),
              actions: [
                TextButton(
                  onPressed: () {
                    Get.back();
                  },
                  child: const Text(
                    'Cancel',
                    style: TextStyle(color: Colors.black45),
                  ),
                ),
                TextButton(
                  onPressed: () async {
                    customColor = currentColor;
                    update(['color']);
                    update();
                    Get.back();
                    final SharedPreferences prefs = await SharedPreferences.getInstance();
                    await prefs.setString('color', currentColor.toHexString());
                  },
                  child: const Text(
                    'OK',
                    style: TextStyle(
                        color: Colors.black, fontWeight: FontWeight.bold),
                  ),
                ),
              ]);
        });
  }

  aboutWeatherUS(BuildContext context) async {
    var info = await PackageInfo.fromPlatform();
    showAboutDialog(
      applicationName: info.appName,
      applicationVersion: info.version,
      applicationIcon: Image.asset(
        'assets/launcher.webp',
        width: 76,
        height: 76,
      ),
      children: [
        const Text("""We can provide you with time"""),
      ],
      context: context,
    );
  }

  void imageSelected() async {
    final picker = ImagePicker();
    try {
      final pickedFile = await picker.pickImage(imageQuality: 90,maxWidth: 1024,source: ImageSource.gallery);
      if (pickedFile != null) {
        final imageBytes = await pickedFile.readAsBytes();
        image = imageBytes;
        String imageString = base64Encode(imageBytes);
        final SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setString('bg',imageString);
        update();
      }
    } catch (e) {
      Fluttertoast.showToast(msg: 'Please check album permissions or select a new image');
      return;
    }
  }

  @override
  void onInit() async {
    // TODO: implement onInit
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    fahrenheit.value = prefs.getBool('fahrenheit') ?? true;
    final  colorStr = prefs.getString('color');
    final imageStr = prefs.getString('bg');
    if(imageStr != null){
      image = base64Decode(imageStr);
    }
    customColor = colorStr?.toColor() ?? Colors.white;
    update();
    super.onInit();
  }
}
