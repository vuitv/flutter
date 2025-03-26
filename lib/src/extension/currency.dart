import 'package:flutter_multi_formatter/flutter_multi_formatter.dart';
import 'package:vuitv/src/core/country_codes.dart';
import 'package:vuitv/src/utils/text_input_formatter.dart';

/// Extension methods on [num] to format numbers as currency strings.
extension CurrencyNumExt on num {
  /// Formats the number as a currency string based on the provided
  /// country code.
  ///
  /// If no country code is provided, the current locale will be used.
  ///
  ///
  /// Example:
  /// ```dart
  /// 1234.56.toCurrency(countryCode: 'VN') // Returns '1,234₫'
  /// ```
  String toCurrency({String? countryCode, int decimalDigits = 2}) {
    final locale = (countryCode ?? CountryCodes.current).toUpperCase();
    if (locale == 'VN') return toCurrencyVN();
    return toCurrencyUS(decimalDigits: decimalDigits);
  }

  /// Formats the number as a US currency string with '$'
  /// symbol and thousands separators.
  ///
  /// Example:
  /// ```dart
  /// 1234.56.toCurrencyUS // Returns '$1,234.56'
  /// ```
  String toCurrencyUS({int decimalDigits = 2}) => toCurrencyString(
        toNumberFormat(decimalDigits: decimalDigits),
        mantissaLength: decimalDigits,
        leadingSymbol: r'$',
      );

  /// Formats the number as a Vietnamese currency string with 'đ'
  /// symbol and thousands separators.
  ///
  /// Example:
  /// ```dart
  /// 1234.toCurrencyVN // Returns '1,234đ'
  /// ```
  String toCurrencyVN() => toCurrencyString(
        toNumberFormat(),
        mantissaLength: 0,
        trailingSymbol: '₫',
      );

  /// Formats the number with thousands separators.
  ///
  /// Example:
  /// ```dart
  /// abc1234.56.toNumberFormat // Returns '123,456'
  /// ```
  String toNumberFormat({int decimalDigits = 0}) => NumberDigitsInputFormatter(
        decimalDigits: decimalDigits,
      ).format(this);
}
