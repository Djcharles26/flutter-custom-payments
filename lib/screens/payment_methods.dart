// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter_custom_payments/generated/l10n.dart';
import 'package:flutter_custom_payments/models/custom_payment_method.dart';
import 'package:flutter_custom_payments/models/payment_status.dart';
import 'package:flutter_custom_payments/providers/stripe_payments.dart';
import 'package:flutter_custom_payments/screens/card_input.dart';
import 'package:flutter_custom_payments/widgets/information_dialogs/confirm_dialog.dart';
import 'package:flutter_custom_payments/widgets/information_dialogs/error_dialog.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:http_request_utils/models/http_exception.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';
import 'package:skeletons/skeletons.dart';

class PaymentMethodsScreen extends StatefulWidget {
  final String customerId;
  final Stream<void>? reloadOnCall;
  const PaymentMethodsScreen({super.key, required this.customerId, this.reloadOnCall});
   

  @override
  State<PaymentMethodsScreen> createState() => _PaymentMethodsScreenState();
}

class _PaymentMethodsScreenState extends State<PaymentMethodsScreen> {
  bool _loading = true;
  String _preferMethodLoading = "";

  @override
  void initState() {
    super.initState();
    Future.microtask(() => _fetchInfo ());

    widget.reloadOnCall?.listen((event) {
      _fetchInfo();
    });
  }
  
  @override
  void reassemble() {
    Future.microtask(() => _fetchInfo ());
    super.reassemble();
  }

  void _fetchInfo({bool load = true}) async {
    if (load) {
      setState(() {
        _loading = true;
      });
    }
    try {
      await Provider.of<StripePayments> (context, listen: false).getCustomerPaymentMethods(widget.customerId);
    } on HttpException catch(error) {
      showErrorDialog(context, exception: error);
    } finally {
      setState(() {
        _loading = false;
      });
    }
  }

  void _deleteMethod (String methodId) async {
    bool? retval = await showConfirmDialog (
      context,
      title: FP.of(context).areYouSure,
      body: FP.of(context).thisActionCantBeUndone
    );

    if (retval ?? false) {
      try {
        await Provider.of<StripePayments> (context, listen: false).detachPaymentMethodFromCustomer (
          widget.customerId, methodId
        );
      } on HttpException catch (error) {
        showErrorDialog(context, exception: error);
      }
    }
  }

  void _addMethod (StripePayments stripePayments) async {
    dynamic retval = await Navigator.of(context).push(
      PageTransition (
        type: PageTransitionType.topToBottom,
        child: ChangeNotifierProvider.value(
          value: stripePayments,
          child: CreditCardInput (
            customerId: widget.customerId,
          ),
        ),
        ctx: context
      )
    );
    
    if (retval == PaymentStatus.success) {
      _fetchInfo();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar (
          content: Text (
            FP.of(context).paymentMethodSuccessfullyAdded,
            style: Theme.of(context).textTheme.headline4!.copyWith(
              color: Colors.white
            ),
          ),
          backgroundColor: Colors.green [500]!,
        )
      );
    } else if (retval == PaymentStatus.failure) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar (
          content: Text (
            FP.of(context).errorProcess,
            style: Theme.of(context).textTheme.headline4!.copyWith(
              color: Colors.white
            ),
          ),
          backgroundColor: Colors.red [500]!,
        )
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar (
          content: Text (
            FP.of(context).cancelProcess,
            style: Theme.of(context).textTheme.headline4!.copyWith(
              color: Colors.white
            ),
          ),
          backgroundColor: const Color.fromARGB(255, 255, 157, 0),
        )
      );
    }
  }

  void _preferMethod (String methodId) async {
    try {
      setState(() {
        _preferMethodLoading = methodId;
      });
      await Provider.of<StripePayments> (context, listen: false).preferPaymentMethod (widget.customerId, methodId);

      _fetchInfo(load: false);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar (
          content: Text (
            FP.of (context).methodSuccessfullySetAsPreferred,
            maxLines: 3,
            style: Theme.of(context).textTheme.bodyText1!.copyWith(
              color: Colors.white
            ),
          ),
          backgroundColor: Colors.green [500]!,
        )
      );
    } on HttpException catch (error) {
      showErrorDialog(context, exception: error);
    } finally {
      setState(() {
        _preferMethodLoading = "";
      });
    }
  }

  Widget _addNewPaymentMethod (StripePayments stripePayments, {EdgeInsets padding = EdgeInsets.zero}) {
    return ListTile (
      onTap: () => _addMethod (stripePayments),
      contentPadding: padding,
      leading: const Icon (Icons.add),
      title: Text (
        FP.of(context).addNewMethod,
        style: Theme.of(context).textTheme.headline3,
      )
    );
  }

  Widget _noMethodsAvailable (StripePayments stripePayments) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column (
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 16),
          Text (
            FP.of(context).noPaymentMethods,
            style: Theme.of(context).textTheme.bodyText1!.copyWith(
              color: Colors.grey
            ),
          ),
          _addNewPaymentMethod(stripePayments),
        ],
      ),
    );
  }

  Widget _paymentMethod (CustomPaymentMethod method) {
    return Slidable(
      startActionPane: ActionPane (
        motion: const DrawerMotion (),
        children: [
          SlidableAction(
            autoClose: true,
            icon: Icons.star,
            backgroundColor: Colors.orange,
            foregroundColor: Colors.white,
            label: FP.of (context).preferMethod,
            onPressed: (ctx) => _preferMethod (method.id)
          ),
          SlidableAction(
            autoClose: true,
            icon: Icons.delete,
            backgroundColor: Colors.red,
            foregroundColor: Colors.white,
            onPressed: (ctx) => _deleteMethod (method.id)
          )
        ],
      ),
      child: Container(
        decoration: BoxDecoration (
          border:  Border (
            bottom: BorderSide (
              color: Theme.of(context).dividerColor,
              width: 1
            )
          )
        ),
        child: ListTile (
          minLeadingWidth: 52,
          leading: SizedBox(
            width: 52,
            child: Row (
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Visibility (
                  visible: _preferMethodLoading == method.id,
                  child: Container (
                    margin: const EdgeInsets.only(right: 4),
                    width: 16,
                    height: 16,
                    child: const CircularProgressIndicator (
                      valueColor: AlwaysStoppedAnimation (
                        Colors.grey
                      ),
                    ),
                  ),
                ),
                Visibility(
                  visible: method.preferred,
                  child: Container (
                    margin: const EdgeInsets.only(right: 4),
                    child: const Center(
                      child: Icon (
                        Icons.star,
                        size: 16,
                        color: Colors.grey,
                      ),
                    ),
                  ),
                ),
                Image.asset (
                  method.imageBrand ?? "assets/no-image.png",
                  width: 32,
                  height: 32,
                  package: "flutter_custom_payments",
                  fit: BoxFit.contain,
                  errorBuilder: (ctx, _, __) {
                    return Text (
                      method.brand ?? "N/A",
                      style: Theme.of(context).textTheme.subtitle2,
                    );
                  },
                ),
              ],
            ),
          ),
          title: Text (
            "•••• •••• •••• ${method.lastFour}",
            style: Theme.of(context).textTheme.headline3,
          ),
          subtitle: Text (
            "${method.expMonth.toString().padLeft(2, "0")}/${method.expYear}",
            style: Theme.of(context).textTheme.bodyText2,
          ),
          trailing: Text (
            method.funding,
            style: Theme.of(context).textTheme.bodyText1,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Skeleton(
      isLoading: _loading,
      skeleton: SkeletonListView (
        itemCount: 5,
        padding: const EdgeInsets.only(top: 8, left: 32, right: 16),
      ),
      child: Consumer<StripePayments> (
        builder: (ctx, stripePayments, _) {
          if (stripePayments.methods.isEmpty) {
            return _noMethodsAvailable(stripePayments);
          } else {
            return ListView.builder(
              itemCount: stripePayments.methods.length + 1,
              itemBuilder: (ctx, i) {
                if (i == stripePayments.methods.length) {
                  return _addNewPaymentMethod(stripePayments, padding: const EdgeInsets.only (left: 16));
                }
                CustomPaymentMethod method = stripePayments.methods [i];
    
                return _paymentMethod(method);
              }
            );
          }
        },
      ),
    );
  }
}