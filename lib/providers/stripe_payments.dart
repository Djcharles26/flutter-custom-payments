import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_custom_payments/models/custom_payment_method.dart';
import 'package:flutter_custom_payments/models/payment_status.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:http/http.dart' as http;
import 'package:http_request_utils/body_utils.dart';

/// [StripePayments] is the provider in charge of creating, attaching or detaching payment methods
/// Generate Payment intents and manage their status.
/// 
///

class StripePayments extends ChangeNotifier {
  //configuration values
  /// [serverURL] Were the server end is located
  String serverURL = "http://192.168.100.110:5000";

  /// headers to be used in requests
  Map<String, String> headers = {};
  
  /// Customizable route method in order to obtain customer payment methods
  String Function (String)? getCustomerPaymentMethodsRoute;
  /// Customizable route method in order to obtain customer payment methods
  String Function (String)? attachPaymentMethodToCustomerRoute;
  /// Customizable route method in order to obtain customer payment methods
  String Function (String)? detachPaymentMethodToCustomerRoute;
  
  String Function (String)? preferPaymentMethodRoute;

  String _strGetCustomerPaymentMethodsRoute (customerId) {
    if (getCustomerPaymentMethodsRoute != null) {
      return getCustomerPaymentMethodsRoute! (customerId);
    } else  {
      return "api/stripe/customers/$customerId/payment/methods";
    }
  }

  String _strAttachPaymentMethodToCustomerRoute (customerId) {
    if (attachPaymentMethodToCustomerRoute != null) {
      return attachPaymentMethodToCustomerRoute! (customerId);
    } else {
      return "api/stripe/customers/$customerId/methods/attach";
    }
  }

  String _strDetachPaymentMethodToCustomerRoute (customerId) {
    if (detachPaymentMethodToCustomerRoute != null) {
      return detachPaymentMethodToCustomerRoute! (customerId);
    } else {
      return "api/stripe/customers/$customerId/methods/detach";
    }
  }
  
  String _strPreferPaymentMethodRoute (customerId) {
    if (preferPaymentMethodRoute != null) {
      return preferPaymentMethodRoute! (customerId);
    } else {
      return "api/stripe/customers/$customerId/methods/prefer";
    }
  }
  
  /// Customizable route in order to create payment intents
  String createPaymentIntentRoute;
  /// Customizable route in order to confirm payment intents
  String confirmPaymentIntentRoute;

  StripePayments ({
    this.getCustomerPaymentMethodsRoute,
    this.attachPaymentMethodToCustomerRoute,
    this.detachPaymentMethodToCustomerRoute,
    this.preferPaymentMethodRoute,
    this.createPaymentIntentRoute = "api/stripe/intents/create",
    this.confirmPaymentIntentRoute = "api/stripe/intents/confirm"
  });

  // work variables
  /// Payment Status management variable
  PaymentStatus _status = PaymentStatus.initial;
  PaymentStatus get status => _status;

  set status (newStatus) {
    _status = newStatus;
    notifyListeners();
  }

  /// CustomPaymentMethods array
  List<CustomPaymentMethod> _methods = [];
  List<CustomPaymentMethod> get methods => _methods;

  PaymentIntent? currentIntent;
  String? paymentMethodId;

  /// Cancel the process returning the status to initial state and cleaning variables
  void cancelProcess () {
    currentIntent = null;
    paymentMethodId = null;
    status = PaymentStatus.initial;
  }

  /// Create a payment method using stripe SDK
  Future<void> createPaymentMethod (String? alias) async {
    final paymentMethod = await Stripe.instance.createPaymentMethod(
      const PaymentMethodParams.card(
        paymentMethodData: PaymentMethodData (
          billingDetails: null
        )
      )
    );

    paymentMethodId = paymentMethod.id;
  }

  /// Request to get customer payment methods
  Future<void> getCustomerPaymentMethods (String customerId) async {
    final url = "$serverURL/${_strGetCustomerPaymentMethodsRoute (customerId)}";
    
    try {
      final res = await http.get(Uri.parse(url), 
        headers: {
          ...headers,
        },
      );
    
      switch(res.statusCode){
        case 200:
          final decoded = json.decode(res.body);
          _methods = decoded.map<CustomPaymentMethod> ((method) => CustomPaymentMethod.fromJson(method)).toList ();
          notifyListeners();
        break;
        default:
          throw HttpException(res.body, code: Code.request, status: res.statusCode);
      }
    } on HttpException {
      rethrow;
    } catch (error, bt) {
      // if(runtime == "Development"){
      Completer().completeError(error, bt);
      // }
      throw HttpException(error.toString(), code: Code.system);
    }
  }

  /// Request to attach the payment methods to customer
  Future<void> attachPaymentMethodToCustomer (String customerId) async {
    final url = "$serverURL/${_strAttachPaymentMethodToCustomerRoute (customerId)}";
    
    try {
      final res = await http.post(Uri.parse(url),
        headers: {
          "content-type": "application/json",
          ...headers,
        },
        body: json.encode ({
          "payment_method_id": paymentMethodId
        })
      );
    
      switch(res.statusCode){
        case 200:
        break;
        default:
          throw HttpException(res.body, code: Code.request, status: res.statusCode);
      }
    } on HttpException {
      rethrow;
    } catch (error, bt) {
      // if(runtime == "Development"){
        Completer().completeError(error, bt);
      // }
      throw HttpException(error.toString(), code: Code.system);
    }
  }

  /// Request to detach the payment methods from customer
  Future<void> detachPaymentMethodFromCustomer (String customerId, String paymentMethodId) async {
    final url = "$serverURL/${_strDetachPaymentMethodToCustomerRoute(customerId)}";
    
    try {
      final res = await http.delete(
        Uri.parse(url).replace(
          queryParameters: {"payment_method_id": paymentMethodId}
        ),
        headers: {
          ...headers,
        },
      );
    
      switch(res.statusCode){
        case 200:
        break;
        default:
          throw HttpException(res.body, code: Code.request, status: res.statusCode);
      }
    } on HttpException {
      rethrow;
    } catch (error, bt) {
      Completer().completeError(error, bt);
      throw HttpException(error.toString(), code: Code.system);
    }
  }

  Future<void> preferPaymentMethod (String customerId, String paymentMethodId) async {
    final url = "$serverURL/${_strPreferPaymentMethodRoute (customerId)}";
    
    try {
      final res = await http.post(Uri.parse(url), 
        headers: {
          ...headers,
          "content-type": 'application/json'
        },
        body: json.encode ({
          "payment_method_id": paymentMethodId
        })
      );
    
      switch(res.statusCode){
        case 200:
        break;
        default:
          throw HttpException(res.body, code: Code.request, status: res.statusCode);
      }
    } on HttpException {
      rethrow;
    } catch (error, bt) {
      Completer().completeError(error, bt);
      throw HttpException(error.toString(), code: Code.system);
    }
  }

  /// Request to create a payment intent
  Future<void> createPaymentIntent () async {
    final url = "$serverURL/$createPaymentIntentRoute";

    status = PaymentStatus.loading;
    
    try {
      final res = await http.post(Uri.parse(url),
        headers: {
          "content-type": "application/json",
          ...headers,
        },
        body: json.encode ({
          "amount": 1000,
          "payment_method_id": paymentMethodId,
          "currency": "mxn"
        })
      );
    
      switch(res.statusCode){
        case 200:
          final decoded = json.decode(res.body);

          if (decoded ["requires_action"] != null) {
            await _handlePaymentIntentAction(decoded ["client_secret"]);
          } else {
            status = PaymentStatus.success;
          }
        break;
        default:
          status = PaymentStatus.failure;
          throw HttpException(res.body, code: Code.request, status: res.statusCode);
      }
    } on HttpException {
      rethrow;
    } catch (error, bt) {
      status = PaymentStatus.failure;
      Completer().completeError(error, bt);
      
      throw HttpException(error.toString(), code: Code.system);
    }
  }

  /// Middle action called when payment intent requires action
  Future<void> _handlePaymentIntentAction (String clientSecret) async {
    currentIntent = await Stripe.instance.handleNextAction(clientSecret);

    if (currentIntent?.status == PaymentIntentsStatus.RequiresConfirmation) {
      await confirmPaymentIntent(clientSecret);
    } else {
      status = PaymentStatus.failure;
    }
  }

  /// Request to confirm the payment intent
  Future<void> confirmPaymentIntent (String clientSecret) async {
    final url = "$serverURL/$confirmPaymentIntentRoute";

    try {
      final res = await http.post(Uri.parse(url),
        headers: {
          "content-type": "application/json",
          ...headers,
        },
        body: json.encode ({
          "payment_intent_id": currentIntent?.id
        })
      );
    
      switch(res.statusCode){
        case 200:
          status = PaymentStatus.success;
        break;
        default:
          status = PaymentStatus.failure;
          throw HttpException(res.body, code: Code.request, status: res.statusCode);
      }
    } on HttpException {
      rethrow;
    } catch (error, bt) {
      status = PaymentStatus.failure;
      // if(runtime == "Development"){
      Completer().completeError(error, bt);
      // }
      throw HttpException(error.toString(), code: Code.system);
    }
  }
}