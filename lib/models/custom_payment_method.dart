import 'package:http_request_utils/body_utils.dart';

class CustomPaymentMethod {
  /// PaymentMethod Id
  String id;
  /// Card Brand [Visa, MasterCard, Amex, etc.]
  String? brand;
  /// Card Country
  String? country;
  /// Card Expiry month
  int expMonth;
  /// Card Expiry year
  int expYear;
  /// Card Last four digits
  String lastFour;
  /// Card Funding [debit, credit, etc.]
  String funding;
  /// Preferred payment method flag
  bool preferred;
  /// Created date
  DateTime created;

  /// Method to obtain brand Image from assets
  String? get imageBrand {
    switch (brand) {
      case "visa": 
        return "assets/brands/visa_logo.png";
      case "mastercard":
        return "assets/brands/mastercard_logo.jpeg";
    }
    return null;
  }

  CustomPaymentMethod ({
    required this.id,
    this.brand,
    this.country,
    required this.expMonth,
    required this.expYear,
    required this.lastFour,
    required this.funding,
    required this.preferred,
    required this.created
  });

  factory CustomPaymentMethod.fromJson (dynamic json) {
    return CustomPaymentMethod (
      id: jsonField<String> (json, ["id",],  nullable: false),
      brand: jsonField<String> (json, ["card", "brand"]),
      country: jsonField<String> (json, ["card", "country"]),
      expMonth: jsonField<int> (json, ["card", "exp_month"],  nullable: false),
      expYear: jsonField<int> (json, ["card", "exp_year"],  nullable: false),
      lastFour: jsonField<String> (json, ["card", "last4"],  nullable: false),
      funding: jsonField<String> (json, ["card", "funding"],  nullable: false),
      preferred: jsonClassField<bool> (json, ["metadata", "preferred"], (val) => val == "True", defaultValue: false),
      created: DateTime.fromMillisecondsSinceEpoch(
        jsonField<int> (json, ["created"]),
      )
    );
  }
}