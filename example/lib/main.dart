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
        "customer_Name": "Bondok",
        "customer_Email": "bondok@sadadkw.com",
        "lang": "en",
        "currency_Code": "KWD",
        "items": [
          {"name": "Orange", "quantity": 2, "amount": 2},
          {"name": "Apple", "quantity": 6, "amount": 1}
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
