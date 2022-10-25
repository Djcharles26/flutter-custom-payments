enum PaymentStatus {
  initial, /// The payment is in initial state (Payment method selection)
  loading, /// The payment is in progress
  success, /// The payment has been successful
  failure ///  The payment has failed
}