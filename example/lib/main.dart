import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_custom_payments/flutter_payments.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
// ignore: depend_on_referenced_packages
import 'package:provider/provider.dart';

void main() async {

  WidgetsFlutterBinding.ensureInitialized ();

  await configureStripe("");
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final StreamController reload = StreamController<dynamic>.broadcast();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Payments example',
      theme: ThemeData (
        textTheme: const TextTheme (
          bodyText1: TextStyle (
            fontSize: 14,
            color: Colors.black
          ),
          bodyText2: TextStyle (
            fontSize: 10,
            color: Colors.black
          ),
          headline1: TextStyle (
            fontSize: 48,
            color: Colors.black
          ),
          headline2: TextStyle (
            fontSize: 24,
            color: Colors.black,
            fontWeight: FontWeight.bold
          ),
          headline3: TextStyle (
            fontSize: 16,
            color: Colors.black,
            fontWeight: FontWeight.bold
          ),
          headline4: TextStyle (
            fontSize: 12,
            color: Colors.black,
            fontWeight: FontWeight.bold
          ),
        )
      ),
      localizationsDelegates: const [
        FP.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: FP.delegate.supportedLocales,
      locale: const Locale ('es'),
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Payments example'),
        ),
        body: MultiProvider(
          providers: [
            ChangeNotifierProvider.value(
              value: StripePayments ()
            )
          ],
          child:RefreshIndicator(
            onRefresh: () async => reload.sink.add (null),
            child: PaymentMethodsScreen (
              customerId: "cus_MeqVIz0Mph9SU4",
              reloadOnCall: reload.stream,
            ),
          )
        )
      ),
    );
  }
}