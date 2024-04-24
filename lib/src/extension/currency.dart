import 'package:vuitv/src/utils/text_input_formatter.dart';

///
extension CurrencyNumExt on num {
  ///
  String get toCurrencyUS => CurrencyInputFormatter.us().format.format(this);

  ///
  String get toCurrencyVN => CurrencyInputFormatter.vn().format.format(this);

  ///
  String get toNumberFormat => NumberDigitsInputFormatter().format.format(this);
}
