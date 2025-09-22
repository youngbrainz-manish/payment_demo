// ignore: deprecated_member_use, avoid_web_libraries_in_flutter
import 'dart:html' as html;
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';

class UpiAndQrScreen extends StatefulWidget {
  final int amount;
  const UpiAndQrScreen({super.key, required this.amount});

  @override
  State<UpiAndQrScreen> createState() => _UpiAndQrScreenState();
}

class _UpiAndQrScreenState extends State<UpiAndQrScreen> {
  final String vpa = '8840922540-1@okbizaxis';
  final String name = 'Test Payment';
  final String txnId = DateTime.now().millisecondsSinceEpoch.toString();
  final String orderId = 'ORDER123';
  final double amount = 1;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(child: buildBody(context: context)),
    );
  }

  Widget buildBody({required BuildContext context}) {
    return Container(
      height: double.infinity,
      width: double.infinity,
      color: Colors.purple.withValues(alpha: 0.2),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (!kIsWeb) Text("Choose Any Of Bellow to pay"),
            if (!kIsWeb)
              ElevatedButton(
                onPressed: () {
                  final upiUrl = 'upi://pay?pa=$vpa&pn=$name&tr=$orderId&tid=$txnId&am=${widget.amount}&cu=INR';
                  html.window.open(upiUrl, '_self');
                },
                child: Text("Pay"),
              ),
            Text("Scan QR to Pay"),
            QrImageView(data: 'upi://pay?pa=$vpa&pn=$name&am=$amount&cu=INR', version: QrVersions.auto, size: 200.0),
          ],
        ),
      ),
    );
  }
}
