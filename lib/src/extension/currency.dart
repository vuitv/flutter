import 'package:vuitv/src/utils/text_input_formatter.dart';

///
extension CurrencyNumExt on num {
  ///
  String get toCurrencyUS => CurrencyInputFormatter.us().format(
        toStringAsFixed(2),
      );

  ///
  String get toCurrencyVN => CurrencyInputFormatter.us().format(
        toStringAsFixed(0),
      );

  ///
  String get toNumberFormat => NumberDigitsInputFormatter().format(
        toStringAsFixed(0),
      );
}
