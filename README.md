<!--
This README describes the package. If you publish this package to pub.dev,
this README's contents appear on the landing page for your package.

For information about how to write a good package README, see the guide for
[writing package pages](https://dart.dev/guides/libraries/writing-package-pages).

For general information about developing packages, see the Dart guide for
[creating packages](https://dart.dev/guides/libraries/create-library-packages)
and the Flutter guide for
[developing packages and plugins](https://flutter.dev/developing-packages).
-->

# Sadad Flutter SDK
Sadad SDK for facilitating integration with Sadad REST APIs into your mobile app.


## Features
- Generate Refresh Token
- Generate Access Token
- Create an Invoice
- Get an Invoice by id
- Provide a Web View for Payment Process

## Installation
Use this package as a library

Run this command:

With Flutter:

``` $flutter pub add sadadpay_flutter ```

This will add a line like this to your package's pubspec.yaml (and run an implicit flutter pub get):

```
dependencies:
  sadadpay_flutter: ^0.0.3
```

Alternatively, your editor might support flutter pub get. Check the docs for your editor to learn more.

Import it, Now in your Dart code, you can use:

``` dart
import 'package:sadadpay_flutter/config/env.dart';
import 'package:sadadpay_flutter/interceptors/authorization_interceptor.dart';
import 'package:sadadpay_flutter/sadadpay.dart';
import 'package:sadadpay_flutter/service/payment_status.dart';
import 'package:sadadpay_flutter/service/sadad_service.dart';
import 'package:sadadpay_flutter/widgets/web_view.dart';
``` 

## Code Snapshot Details
To generate refresh token using clientkey and clientsecret, you can use ```generateRefreshToken``` method which is return json object.

```dart details
sadadPay.generateRefreshToken(clientKey: _clientKey, clientSecret: _clientSecret).then(
        (value) => _refreshToken = value['response']['refreshToken']);
```

To generate access token, you can use ```generateAccessToken``` method which is return json object.
```dart details
sadadPay.generateAccessToken(refreshToken: _refreshToken).then(
        (value) => _accessToken = value['response']['accessToken']);
```

To create invoice, you can use ```createInvoice``` method which is return json object.

```dart details
final invoices = {
    "Invoices": [
      {
        "amount": "10",
        "customer_Name": "customer",
        "customer_Email": "customer@example.com",
        "lang": "en",
        "currency_Code": "KWD",
        "items": [
          {"name": "x", "quantity": 2, "amount": 2},
          {"name": "y", "quantity": 6, "amount": 1}
        ]
      }
    ]
  };

sadadPay.createInvoice(invoices: invoices, token: _accessToken).then(
        (value) => setState(() => _invoiceId = value['response']['invoiceId']));
```

To get invoice by id, you can use ```getInvoice``` method which is return json object.
```dart details
sadadPay.getInvoice(invoiceId: _invoiceId, token: _accessToken).then(
        (value) => setState(() => _invoiceKey = value['response']['key']));
```
To use sadad web view, use can use ```SadadWebView``` which is return widget.
```dart
 @override
  Widget build(BuildContext context) {
    if (_invoiceKey != '') {
      return SadadWebView(
        invoiceKey: _invoiceKey,
        onSuccess: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const SuccessPage()),
          );
        },
        onFail: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const FailPage()),
          );
        },
        appBar: AppBar(
          title: const Text('App Bar'),
        ),
      );
    } else {
      return const CircularProgressIndicator();
    }
  }
}
```

## Full Example
```dart
import 'package:flutter/material.dart';
import 'package:sadadpay_flutter/config/env.dart';
import 'package:sadadpay_flutter/sadadpay.dart';
import 'package:sadadpay_flutter/widgets/web_view.dart';
void main() {
  runApp(const SadadDemo());
}

class SadadDemo extends StatelessWidget {
  const SadadDemo({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Sadad Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Sadad Demo Home Page'),
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
  // set your clientKey and clientSecret, They must be stored in a safe place such as database.
  final String _clientKey = "xxxxxxxxxxxx";
  final String _clientSecret = "xxxxxxxxxxxx";
  late String _refreshToken;
  late String _accessToken;
  late String _invoiceId;
  late String _invoiceKey = "";
  final invoices = {
    "Invoices": [
      {
        "amount": "10",
        "customer_Name": "customer",
        "customer_Email": "customer@example.com",
        "lang": "en",
        "currency_Code": "KWD",
        "items": [
          {"name": "x", "quantity": 2, "amount": 2},
          {"name": "y", "quantity": 6, "amount": 1}
        ]
      }
    ]
  };
  
  SadadPay sadadPay = SadadPay(env: Environment.dev);

  Future<void> initPaymentProcess() async {
    await sadadPay.generateRefreshToken(clientKey: _clientKey, clientSecret: _clientSecret).then(
        (value) => _refreshToken = value['response']['refreshToken']);
    await sadadPay.generateAccessToken(refreshToken: _refreshToken).then(
        (value) => _accessToken = value['response']['accessToken']);
    await sadadPay.createInvoice(invoices: invoices, token: _accessToken).then(
        (value) => setState(() => _invoiceId = value['response']['invoiceId']));
    await sadadPay.getInvoice(invoiceId: _invoiceId, token: _accessToken).then(
        (value) => setState(() => _invoiceKey = value['response']['key']));
  }

  @override
  initState() {
    super.initState();
    initPaymentProcess();
  }

  @override
  Widget build(BuildContext context) {
    if (_invoiceKey != '') {
      return SadadWebView(
        invoiceKey: _invoiceKey,
        onSuccess: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const SuccessPage()),
          );
        },
        onFail: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const FailPage()),
          );
        },
        appBar: AppBar(
          title: const Text('App Bar'),
        ),
      );
    } else {
      return const CircularProgressIndicator();
    }
  }
}

class SuccessPage extends StatelessWidget {
  const SuccessPage({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('App Bar'),
      ),
      body: const Center(
        child: Text('On Success page'),
      ),
    );
  }
}

class FailPage extends StatelessWidget {
  const FailPage({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('App Bar'),
      ),
      body: const Center(
        child: Text('On Fail page'),
      ),
    );
  }
}
```
