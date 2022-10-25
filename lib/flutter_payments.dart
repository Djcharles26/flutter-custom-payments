library flutter_payments;

import 'package:flutter_stripe/flutter_stripe.dart';

export 'package:flutter_custom_payments/generated/l10n.dart';

export './providers/stripe_payments.dart';
export './screens/card_input.dart';
export './screens/payment_methods.dart';

Future<void> configureStripe (String publishableKey) async {
  Stripe.publishableKey = publishableKey;

  await Stripe.instance.applySettings();
}