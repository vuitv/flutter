import 'package:currency_text_input_formatter/currency_text_input_formatter.dart';
import 'package:vuitv/src/utils/text_input_formatter.dart';

///
extension CurrencyNumExt on num {
  ///
  String get toCurrencyUS => CurrencyInputFormatter.us().format.format(
        toStringAsFixed(2),
      );

  ///
  String get toCurrencyVN => CurrencyInputFormatter.us().format.format(
        toStringAsFixed(0),
      );

  ///
  String get toNumberFormat => NumberDigitsInputFormatter().format.format(
        toStringAsFixed(0),
      );
}
