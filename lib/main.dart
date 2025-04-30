import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:weather_clock/pages/get_failed/get_failed_binding.dart';
import 'package:weather_clock/pages/get_failed/get_failed_set.dart';
import 'package:weather_clock/pages/get_failed/get_failed_view.dart';
import 'package:weather_clock/pages/weather_clock_main/weather_clock_main_binding.dart';
import 'package:weather_clock/pages/weather_clock_main/weather_clock_main_view.dart';
import 'package:weather_clock/pages/weather_setting/weather_setting_binding.dart';
import 'package:weather_clock/pages/weather_setting/weather_setting_view.dart';
import 'package:weather_clock/pages/weather_tab/weather_tab_binding.dart';
import 'package:weather_clock/pages/weather_tab/weather_tab_view.dart';

Color primaryColor = Colors.black;
Color bgColor = Colors.black;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.landscapeLeft,
    DeviceOrientation.landscapeRight,
  ]);
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  final  colors = prefs.getString('color');
  if (colors == null) {
    await prefs.setString('color', Colors.white.toHexString());
    await prefs.setBool('fahrenheit', true);
  }
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      getPages: Weather,
      initialRoute: '/weather_tab',
      theme: ThemeData(
        useMaterial3: true,
        primaryColor: primaryColor,
        scaffoldBackgroundColor: bgColor,
        colorScheme: ColorScheme.light(
          primary: primaryColor,
        ),
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.transparent,
          elevation: 0,
          scrolledUnderElevation: 0,
          centerTitle: true,
          titleTextStyle: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.black,
            fontSize: 20,
          ),
        ),
        bottomNavigationBarTheme: BottomNavigationBarThemeData(
          selectedItemColor: primaryColor,
          selectedLabelStyle: const TextStyle(
            fontWeight: FontWeight.bold,
          ),
          elevation: 0,
          backgroundColor: Colors.white,
        ),
        inputDecorationTheme: const InputDecorationTheme(
          border: OutlineInputBorder(
            borderSide: BorderSide.none,
            borderRadius: BorderRadius.all(Radius.circular(10)),
          ),
        ),
        cardTheme: const CardTheme(
          color: Colors.white,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(10)),
          ),
        ),
        dialogTheme: const DialogTheme(
          actionsPadding: EdgeInsets.only(right: 10, bottom: 5),
        ),
        dividerTheme: DividerThemeData(
          thickness: 1,
          color: Colors.grey[200],
        ),
      ),
    );
  }
}
List<GetPage<dynamic>> Weather = [
  GetPage(name: '/weather_tab', page: () => const WeatherTabView(), binding: WeatherTabBinding()),
  GetPage(name: '/get_failed', page: () => const GetFailedView(), binding: GetFailedBinding()),
  GetPage(name: '/get_restart', page: () => const GetFailedSet()),
  GetPage(name: '/weather_main', page: () => const WeatherClockMainPage(), binding: WeatherClockMainBinding()),
  GetPage(name: '/weather_setting', page: () => WeatherSettingPage(), binding: WeatherSettingBinding()),
];