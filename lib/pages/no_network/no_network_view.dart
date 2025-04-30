import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:styled_widget/styled_widget.dart';

import 'no_network_logic.dart';

class NoNetworkPage extends GetView<NoNetworkLogic> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('No Network'),
        backgroundColor: Colors.white,
      ),
      body: SizedBox(
        width: double.infinity,
        height: double.infinity,
        child: SafeArea(
            child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: <Widget>[
            const SizedBox(
              height: 30,
            ),
            Image.asset(
              'assets/noNetwork.webp',
              width: 88,
              height: 85,
              fit: BoxFit.cover,
            ),
            const SizedBox(
              height: 20,
            ),
            const Text(
              'Your cellular network is abnorma try again later',
              style: TextStyle(color: Colors.grey, fontWeight: FontWeight.w500),
            ),
            const SizedBox(
              height: 20,
            ),
            Container(
              width: 116,
              height: 44,
              alignment: Alignment.center,
              child: const Text('Reload',style: TextStyle(fontWeight: FontWeight.bold),),
            )
                .decorated(
                    borderRadius: BorderRadius.circular(12),
                    color: Colors.white,
                    border: Border.all(color: Colors.black, width: 1))
                .gestures(onTap: () {
              controller.checkNetwork();
            })
          ].toColumn(),
        ).marginAll(15)),
      ),
    );
  }
}
