import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:styled_widget/styled_widget.dart';

import 'weather_setting_logic.dart';

class WeatherSettingPage extends GetView<WeatherSettingLogic> {
  Widget _item(int index, BuildContext context) {
    final titles = ['Text palette', 'Background', 'Fahrenheit', 'About US'];
    return Container(
      color: Colors.transparent,
      height: 40,
      child: <Widget>[
        Text(titles[index]),
        index < 2
            ? ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: Container(
                  width: 40,
                  height: 40,
                  child: index == 0
                      ? null
                      : (controller.image == null
                          ? null
                          : Image.memory(controller.image!, fit: BoxFit.fill)),
                ).decorated(
                    color: index == 0
                        ? controller.customColor
                        : const Color(0xff4f7ffa),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: Colors.grey.shade300)),
              )
            : (index == 2
                ? Obx(() {
                    return Switch(
                        value: controller.fahrenheit.value,
                        activeTrackColor: Colors.green,
                        onChanged: (v) async {
                          controller.fahrenheit.value = v;
                          final SharedPreferences prefs =
                              await SharedPreferences.getInstance();
                          await prefs.setBool('fahrenheit', v);
                        });
                  })
                : const Text("v1.0.0").paddingOnly(right: 10))
      ].toRow(mainAxisAlignment: MainAxisAlignment.spaceBetween),
    ).gestures(onTap: () {
      switch (index) {
        case 0:
          controller.colorSelect(context);
          break;
        case 1:
          controller.imageSelected();
          break;
        case 2:
          break;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        foregroundColor: Colors.white,
        title: const Text(
          'Setting',
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        padding: const EdgeInsets.all(15),
        child: SafeArea(child: GetBuilder<WeatherSettingLogic>(builder: (_) {
          return SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            child: <Widget>[
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(12),
                child: <Widget>[
                  _item(0, context),
                  _item(1, context),
                  _item(2, context),
                  _item(3, context)
                ].toColumn(
                    separator: Divider(
                  height: 15,
                  color: Colors.grey.shade300,
                )),
              ).decorated(
                  color: Colors.white, borderRadius: BorderRadius.circular(12))
            ].toColumn(),
          );
        })),
      ).decorated(
          gradient: const LinearGradient(
              colors: [Color(0xff4f7ffa), Color(0xff335fd1)],
              begin: Alignment.centerLeft,
              end: Alignment.centerRight)),
    );
  }
}
