import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:styled_widget/styled_widget.dart';

import 'weather_clock_main_logic.dart';

class WeatherClockMainPage extends StatefulWidget {
  const WeatherClockMainPage({Key? key}) : super(key: key);

  @override
  State<WeatherClockMainPage> createState() => _WeatherClockMainPageState();
}

class _WeatherClockMainPageState extends State<WeatherClockMainPage> {
  WeatherClockMainLogic controller = Get.find();

  void checkNetwork() async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult.contains(ConnectivityResult.none)) {
      Get.toNamed('/get_failed');
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    checkNetwork();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<WeatherClockMainLogic>(builder: (_) {
      return Scaffold(
        body: Container(
          width: double.infinity,
          height: double.infinity,
          child: <Widget>[
            SizedBox(width: double.infinity,
              height: double.infinity,
              child: controller.image == null ? null : Image.memory(
                controller.image!,
                width: double.infinity,
                height: double.infinity,
                fit: BoxFit.fill,
              ),),
            SafeArea(
                child: <Widget>[
                  const SizedBox(
                    width: double.infinity,
                    height: double.infinity,
                  ),
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: Image.asset(
                      'assets/line.webp',
                      width: double.infinity,
                      height: 184,
                      fit: BoxFit.cover,
                    ),
                  ),
                  Obx(() {
                    return Positioned(
                        bottom: 50,
                        left: controller.sunLeft.value,
                        child: Image.asset(
                          'assets/sun.webp',
                          fit: BoxFit.cover,
                        ));
                  }),
                  <Widget>[
                    <Widget>[
                      Obx(() {
                        return Image.asset(
                          'assets/img${controller.type.value}.webp',
                          fit: BoxFit.cover,
                        );
                      }),
                      Obx(() {
                        return Text(
                          controller.fahrenheit.value
                              ? '${controller.f.value.toInt()}°F'
                              : '${controller.c.value.toInt()}°C',
                          style: TextStyle(
                              color: controller.textColor.value, fontSize: 20),
                        );
                      }),
                      const SizedBox(
                        height: 10,
                      ),
                      Obx(() {
                        return Text(
                          controller.typeStr.value,
                          style: TextStyle(
                              color: controller.textColor.value, fontSize: 20),
                        );
                      })
                    ].toColumn(),
                    Container(
                      width: 525,
                      height: 246,
                      alignment: Alignment.center,
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Obx(() {
                        return Text(
                          controller.hmStr.value,
                          style: TextStyle(
                              color: controller.textColor.value,
                              fontWeight: FontWeight.bold,
                              fontSize: 160),
                        );
                      }),
                    ).decorated(
                        image: const DecorationImage(
                            image: AssetImage('assets/bg.webp'), fit: BoxFit
                            .cover))
                  ].toRow(mainAxisAlignment: MainAxisAlignment.spaceBetween),
                  Positioned(
                      bottom: 0,
                      right: 0,
                      child: const Icon(
                        Icons.settings,
                        size: 30,
                        color: Colors.white,
                      ).gestures(onTap: () {
                        Get.toNamed('/weather_setting')?.then((_) {
                          controller.onRefreshTextColor();
                        });
                      }))
                ].toStack(alignment: Alignment.center))
          ].toStack(alignment: Alignment.center),
        ).decorated(
            gradient: const LinearGradient(
                colors: [Color(0xff4f7ffa), Color(0xff335fd1)],
                begin: Alignment.centerLeft,
                end: Alignment.centerRight)),
      );
    });
  }
}
