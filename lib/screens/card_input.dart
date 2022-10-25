import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_custom_payments/generated/l10n.dart';
import 'package:flutter_custom_payments/models/payment_status.dart';
import 'package:flutter_custom_payments/providers/stripe_payments.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:flutter_work_utils/flutter_utils.dart';
import 'package:provider/provider.dart';

class CreditCardInput extends StatefulWidget {
  /// Color for the credit card form (Change color despite system color)
  final Color? backgroundColor;
  /// Stripe Customer Id
  final String customerId;

  const CreditCardInput({
    super.key,
    required this.customerId,
    this.backgroundColor
  });

  @override
  State<CreditCardInput> createState() => _CreditCardInputState();
}

class _CreditCardInputState extends State<CreditCardInput> {
  bool _adding = false;
  String? alias;
  CardFormEditController controller = CardFormEditController();

  void _addMethod () async {
    setState(() {
      _adding = true;
    });
    StripePayments stripePayments = Provider.of<StripePayments>(context, listen: false);
    if (controller.details.complete) {
      try {
        await stripePayments.createPaymentMethod(alias);
        await stripePayments.attachPaymentMethodToCustomer(widget.customerId);
        // ignore: use_build_context_synchronously
        Navigator.of(context).pop (PaymentStatus.success);
      } catch (error) {
        Navigator.of(context).pop (PaymentStatus.failure);
      } finally {
        if (mounted) {
          _adding = false;
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    Color backgroundColor = widget.backgroundColor ?? const Color.fromARGB(255, 23, 94, 194);
    return Scaffold(
      appBar: AppBar (
        title: Text (
          FP.of(context).newPaymentMethod,
          style: Theme.of(context).textTheme.headline3!.copyWith(
            color: Colors.white
          ),
        ),
      ),
      body: Container(
        height: MediaQuery.of(context).size.height,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Consumer<StripePayments>(
          builder: (context, stripePayments, _) {
            return Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 16),
                CardFormField(
                  controller: controller,
                  enablePostalCode: true,
                  style: CardFormStyle (
                    backgroundColor: backgroundColor,
                    textColor: Colors.white
                  ),
                ),
                const SizedBox(height: 16),
                TextFormField (
                  maxLength: 50,
                  maxLengthEnforcement: MaxLengthEnforcement.enforced,
                  onChanged: (val) {
                    alias = val;
                  },
                  decoration: InputDecoration (
                    labelText: FP.of(context).aliasLabel,
                  ),
                ),
                const SizedBox(height: 16),
                ElevatedButton (
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all(
                      backgroundColor.withOpacity(
                        controller.details.complete ? 1: 0.3
                      )
                    ),
                    overlayColor: MaterialStateProperty.all(Colors.transparent),
                  ),
                  onPressed: _addMethod,
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(16.0),
                    child: Center(
                      child: _adding 
                      ? CircularProgressIndicator (
                        valueColor: AlwaysStoppedAnimation (
                          getColorContrast(backgroundColor)
                        ),
                      )
                      : Text (
                        FP.of(context).addNewMethod,
                        style: Theme.of(context).textTheme.headline3!.copyWith(
                          color: getColorContrast(backgroundColor)
                        ),
                      ),
                    ),
                  )
                )
              ],
            );
          }
        ),
      ),
    );
  }
}