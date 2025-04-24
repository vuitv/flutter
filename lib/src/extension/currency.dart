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
  String toCurrency({
    String? countryCode,
    int decimalDigits = 2,
    bool trailingZero = true,
  }) {
    final locale = (countryCode ?? CountryCodes.current).toUpperCase();
    if (locale == 'VN') return toCurrencyVN();
    return toCurrencyUS(
      decimalDigits: decimalDigits,
      trailingZero: trailingZero,
    );
  }

  /// Formats the number as a US currency string with '$'
  /// symbol and thousands separators.
  ///
  /// Examples:
  /// ```dart
  /// 12.34.toCurrencyUS()    // Returns '$12.34'
  /// 12.345.toCurrencyUS()   // Returns '$12.35'
  /// 123.toCurrencyUS(trailingZero: false)      // Returns '$123'
  /// 1234.00.toCurrencyUS(trailingZero: false)  // Returns '$1234'
  /// 1234.50.toCurrencyUS(trailingZero: false)  // Returns '$1234.5'
  /// 1234.0001.toCurrencyUS() // Returns '$1234.00'
  /// ```
  String toCurrencyUS({int decimalDigits = 2, bool trailingZero = true}) {
    if (decimalDigits == 0) {
      return toCurrencyString(
        toNumberFormat(),
        mantissaLength: 0,
        leadingSymbol: r'$',
      );
    }
    if (!trailingZero) {
      // negative number
      final isNegative = this < 0;
      var value = toStringAsFixed(decimalDigits);
      if (isNegative) {
        value = value.replaceAll(RegExp('^[-+]+'), '');
      }
      final parts = value.split('.');
      final integerPart = int.parse(parts[0]).toNumberFormat();
      final decimalPart = parts.length > 1 ? parts[1] : '';
      final trimmedDecimalPart = decimalPart.replaceAll(RegExp(r'0+$'), '');
      final formattedValue = trimmedDecimalPart.isEmpty ? integerPart : '$integerPart.$trimmedDecimalPart';

      value = '\$$formattedValue';
      if (isNegative) {
        value = '-$value';
      }
      return value;
    }

    return toCurrencyString(
      toNumberFormat(decimalDigits: decimalDigits),
      mantissaLength: decimalDigits,
      leadingSymbol: r'$',
    );
  }

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
