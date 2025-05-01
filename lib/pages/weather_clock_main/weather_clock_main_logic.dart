import 'dart:async';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';

class WeatherClockMainLogic extends GetxController {
  Timer? _timer;

  var hmStr = ''.obs;
  var hmdStr = ''.obs;
  var weekDayStr = ''.obs;
  var type = 0.obs;
  var typeStr = 'Sunny'.obs;
  var sunLeft = 0.0.obs;
  var textColor = Colors.white.obs;
  var fahrenheit = true.obs;
  Uint8List? image;

  var c = 22.0.obs;
  var f = 71.6.obs;

  void startTimer() {
    final currentNow = DateTime.now();
    hmStr.value = DateFormat('HH:mm').format(currentNow);
    hmdStr.value = DateFormat('MM/dd/yyyy').format(currentNow);
    weekDayStr.value = DateFormat('EEEE').format(currentNow);
    var left = currentNow.hour * 20.0;
    if (left >= 480) {
      left = 480;
    }
    sunLeft.value = left;
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      final now = DateTime.now();
      hmStr.value = DateFormat('HH:mm').format(now);
      var left = now.hour * 20.0;
      if (left >= 480) {
        left = 480;
      }
      sunLeft.value = left;
    });
  }

  bool isValidCoordinate(double lat, double lng) {
    return (lat >= -90 && lat <= 90) && (lng >= -180 && lng <= 180);
  }

  double cToFahrenheit(double c) {
    return (c * 9 / 5) + 32;
  }

  double fToCelsius(double f) {
    return (f - 32) * 5 / 9;
  }

  Future<Map<String, dynamic>> fetchWeather(String city) async {
    final url = Uri.parse('http://wttr.in/$city?format=j1');
    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        throw Exception('Failed to load weather');
      }
    } catch (e) {
      throw Exception('Network error: $e');
    }
  }

  Future<void> _checkLocationPermission() async {
    final status = await Permission.locationWhenInUse.request();
    if (status.isGranted) {
      Position position = await Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(
          accuracy: LocationAccuracy.low,
          distanceFilter: 1000,
        ),
      );

      String? city = '';
      if (isValidCoordinate(position.latitude, position.longitude)) {
        try {
          List<Placemark> placemarks = await placemarkFromCoordinates(
            position.latitude,
            position.longitude,
          );

          if (placemarks.isEmpty) {
            return;
          }

          Placemark place = placemarks.first;
          city = place.locality;
          if (city == null || city.isEmpty) {
            city = place.subAdministrativeArea ?? place.administrativeArea;
          }
        } catch (_) {}
        if (city == null || city.isEmpty) {
          city = 'Beijing';
        }
        final data = await fetchWeather(city!);
        final current = data['current_condition'][0];
        final weatherDec = '${current['weatherDesc'][0]['value']}';
        final weatherC = '${current['temp_C']}';
        c.value = double.parse(weatherC);
        f.value = cToFahrenheit(double.parse(weatherC));
        if (weatherDec == 'Sunny') {
          type.value = 0;
          typeStr.value = 'Sunny';
        } else if (weatherDec == 'Rain') {
          type.value = 1;
          typeStr.value = 'Rain';
        } else if (weatherDec == 'Thunderstorm') {
          type.value = 2;
          typeStr.value = 'Thunderstorm';
        } else if (weatherDec == 'Cloudy') {
          type.value = 3;
          typeStr.value = 'Cloudy';
        } else if (weatherDec == 'Wind') {
          type.value = 4;
          typeStr.value = 'Wind';
        } else if (weatherDec == 'Partly Cloudy') {
          type.value = 5;
          typeStr.value = 'Partly Cloudy';
        } else if (weatherDec == 'Overcast') {
          type.value = 6;
          typeStr.value = 'Overcast';
        }
      }
    } else {
      _showPermissionDialog();
    }
  }

  void _showPermissionDialog() {
    showDialog(
      context: Get.context!,
      builder: (ctx) => AlertDialog(
        title: const Text('Location permissions required'),
        content: const Text('Please grant location permission to get distance'),
        actions: [
          TextButton(
            onPressed: () => openAppSettings(),
            child: const Text('Setting'),
          ),
        ],
      ),
    );
  }

  onRefreshTextColor() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final  colors = prefs.getString('color');
    final  background = prefs.getString('bg');
    fahrenheit.value = prefs.getBool('fahrenheit') ?? true;
    if (colors != null) {
      textColor.value = colors.toColor()!;
    }
    if (background != null) {
      image = base64Decode(background);
    }
    update();
  }

  @override
  void onInit() async {
    onRefreshTextColor();
    startTimer();
    _checkLocationPermission();
    super.onInit();
  }
}
