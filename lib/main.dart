import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:payment_demo/screens/upi_and_qr_screen.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';

//rzp_test_RJpPNf4a0UPFjf
void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple)),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;

  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }

  Razorpay razorpay = Razorpay();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(backgroundColor: Theme.of(context).colorScheme.inversePrimary, title: Text(widget.title)),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text('You have pushed the button this many times:'),
            Text('$_counter', style: Theme.of(context).textTheme.headlineMedium),
            SizedBox(height: 30),
            ElevatedButton(
              onPressed: () {
                if (kIsWeb) {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => UpiAndQrScreen()));
                } else if (Platform.isAndroid || Platform.isIOS) {
                  var options = {
                    'key': "rzp_test_RJpPNf4a0UPFjf",
                    'amount': _counter * 100,
                    'name': 'Acme Corp.',
                    'description': 'Fine T-Shirt',
                    'prefill': {'contact': '8888888888', 'email': 'test@razorpay.com'},
                  };

                  razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, handlePaymentErrorResponse);
                  razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, handlePaymentSuccessResponse);
                  razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, handleExternalWalletSelected);
                  razorpay.open(options);
                }
              },
              child: Text("Pay Now"),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ),
    );
  }

  handlePaymentErrorResponse(PaymentFailureResponse response) {
    showAlertDialog(
      context,
      "Payment Failed",
      "Code: ${response.code}\nDescription: ${response.message}\nMetadata:${response.error.toString()}",
    );
  }

  void showAlertDialog(BuildContext context, String title, String message) {
    // set up the buttons
    // Widget continueButton = ElevatedButton(child: const Text("Continue"), onPressed: () {});
    // set up the AlertDialog
    AlertDialog alert = AlertDialog(title: Text(title), content: Text(message));
    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  handlePaymentSuccessResponse(PaymentSuccessResponse response) {
    showAlertDialog(context, "Payment SUCCESS", "Code: SUCCESS ${response.data}");
  }

  handleExternalWalletSelected(PaymentFailureResponse response) {
    showAlertDialog(
      context,
      "Payment Failed",
      "Code: ${response.code}\nDescription: ${response.message}\nMetadata:${response.error.toString()}",
    );
  }
}
