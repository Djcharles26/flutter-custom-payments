// GENERATED CODE - DO NOT MODIFY BY HAND
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'intl/messages_all.dart';

// **************************************************************************
// Generator: Flutter Intl IDE plugin
// Made by Localizely
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, lines_longer_than_80_chars
// ignore_for_file: join_return_with_assignment, prefer_final_in_for_each
// ignore_for_file: avoid_redundant_argument_values, avoid_escaping_inner_quotes

class FP {
  FP();

  static FP? _current;

  static FP get current {
    assert(_current != null,
        'No instance of FP was loaded. Try to initialize the FP delegate before accessing FP.current.');
    return _current!;
  }

  static const AppLocalizationDelegate delegate = AppLocalizationDelegate();

  static Future<FP> load(Locale locale) {
    final name = (locale.countryCode?.isEmpty ?? false)
        ? locale.languageCode
        : locale.toString();
    final localeName = Intl.canonicalizedLocale(name);
    return initializeMessages(localeName).then((_) {
      Intl.defaultLocale = localeName;
      final instance = FP();
      FP._current = instance;

      return instance;
    });
  }

  static FP of(BuildContext context) {
    final instance = FP.maybeOf(context);
    assert(instance != null,
        'No instance of FP present in the widget tree. Did you add FP.delegate in localizationsDelegates?');
    return instance!;
  }

  static FP? maybeOf(BuildContext context) {
    return Localizations.of<FP>(context, FP);
  }

  /// `New Payment Method`
  String get newPaymentMethod {
    return Intl.message(
      'New Payment Method',
      name: 'newPaymentMethod',
      desc: '',
      args: [],
    );
  }

  // skipped getter for the 'Add payment method' key

  /// `Are you sure?`
  String get areYouSure {
    return Intl.message(
      'Are you sure?',
      name: 'areYouSure',
      desc: '',
      args: [],
    );
  }

  /// `This action cant be undone`
  String get thisActionCantBeUndone {
    return Intl.message(
      'This action cant be undone',
      name: 'thisActionCantBeUndone',
      desc: '',
      args: [],
    );
  }

  /// `Payment Method added successfully`
  String get paymentMethodSuccessfullyAdded {
    return Intl.message(
      'Payment Method added successfully',
      name: 'paymentMethodSuccessfullyAdded',
      desc: '',
      args: [],
    );
  }

  /// `Payment Method removed successfully`
  String get paymentMethodSuccessfullyRemoved {
    return Intl.message(
      'Payment Method removed successfully',
      name: 'paymentMethodSuccessfullyRemoved',
      desc: '',
      args: [],
    );
  }

  /// `There was an error in the process`
  String get errorProcess {
    return Intl.message(
      'There was an error in the process',
      name: 'errorProcess',
      desc: '',
      args: [],
    );
  }

  /// `Process was cancelled`
  String get cancelProcess {
    return Intl.message(
      'Process was cancelled',
      name: 'cancelProcess',
      desc: '',
      args: [],
    );
  }

  /// `Add new payment method`
  String get addNewMethod {
    return Intl.message(
      'Add new payment method',
      name: 'addNewMethod',
      desc: '',
      args: [],
    );
  }

  /// `No payment methods are available, create one to start`
  String get noPaymentMethods {
    return Intl.message(
      'No payment methods are available, create one to start',
      name: 'noPaymentMethods',
      desc: '',
      args: [],
    );
  }

  /// `Alias (Optional)`
  String get aliasLabel {
    return Intl.message(
      'Alias (Optional)',
      name: 'aliasLabel',
      desc: '',
      args: [],
    );
  }

  /// `Default method`
  String get preferMethod {
    return Intl.message(
      'Default method',
      name: 'preferMethod',
      desc: '',
      args: [],
    );
  }

  /// `The payment Method was set as default successfully`
  String get methodSuccessfullySetAsPreferred {
    return Intl.message(
      'The payment Method was set as default successfully',
      name: 'methodSuccessfullySetAsPreferred',
      desc: '',
      args: [],
    );
  }
}

class AppLocalizationDelegate extends LocalizationsDelegate<FP> {
  const AppLocalizationDelegate();

  List<Locale> get supportedLocales {
    return const <Locale>[
      Locale.fromSubtags(languageCode: 'en'),
      Locale.fromSubtags(languageCode: 'es'),
    ];
  }

  @override
  bool isSupported(Locale locale) => _isSupported(locale);
  @override
  Future<FP> load(Locale locale) => FP.load(locale);
  @override
  bool shouldReload(AppLocalizationDelegate old) => false;

  bool _isSupported(Locale locale) {
    for (var supportedLocale in supportedLocales) {
      if (supportedLocale.languageCode == locale.languageCode) {
        return true;
      }
    }
    return false;
  }
}
