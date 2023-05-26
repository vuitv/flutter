import 'dart:ui';

import 'package:currency_text_input_formatter/currency_text_input_formatter.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

///
class CurrencyInputFormatter extends CurrencyTextInputFormatter {
  ///
  CurrencyInputFormatter.us({
    super.locale = 'en',
    super.symbol = r'$',
    super.decimalDigits = 2,
  });

  ///
  CurrencyInputFormatter.vn({
    super.locale = 'vi',
    super.symbol = '₫',
    super.decimalDigits = 0,
  });
}

///
class NumberDigitsInputFormatter extends CurrencyTextInputFormatter {
  ///
  NumberDigitsInputFormatter({
    super.locale = 'vi',
    super.symbol = '',
    super.decimalDigits = 0,
  });
}

///
class PhoneInputFormatter extends TextInputFormatter {
  ///
  PhoneInputFormatter([this.locale]);

  static String _vnFormat(String text) {
    var s = text;
    s = s.replaceAll(' ', '');
    if (s.length <= 3) {
      s = s.replaceAllMapped(
        RegExp(r'(\d{1,3})'),
        (m) => '${m[1]}',
      );
    } else if (s.length <= 6) {
      s = s.replaceAllMapped(
        RegExp(r'(\d{3})(\d{1,3})'),
        (m) => '${m[1]} ${m[2]}',
      );
    } else {
      s = s.replaceAllMapped(
        RegExp(r'(\d{3})(\d{3})(\d{1,4})'),
        (m) => '${m[1]} ${m[2]} ${m[3]}',
      );
    }
    return s;
  }

  static String _usFormat(String text) {
    var s = text;
    s = s.replaceAll(' ', '');
    s = s.replaceAll('(', '');
    s = s.replaceAll(')', '');
    s = s.replaceAll('-', '');
    if (s.length <= 3) {
      s = s.replaceAllMapped(
        RegExp(r'(\d{1,3})'),
        (m) => '(${m[1]}',
      );
    } else if (s.length <= 6) {
      s = s.replaceAllMapped(
        RegExp(r'(\d{3})(\d{1,3})'),
        (m) => '(${m[1]}) ${m[2]}',
      );
    } else {
      s = s.replaceAllMapped(
        RegExp(r'(\d{3})(\d{3})(\d{1,4})'),
        (m) => '(${m[1]}) ${m[2]}-${m[3]}',
      );
    }
    return s;
  }

  ///
  static String format(String text, [Locale? locale]) {
    switch (locale?.languageCode) {
      case 'vi':
        return _vnFormat(text);
    }
    return _usFormat(text);
  }

  ///
  final Locale? locale;

  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    final s = format(newValue.text, locale);
    return TextEditingValue(
      text: s,
      selection: TextSelection.collapsed(offset: s.length),
    );
  }
}

///
class HexColorInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    var s = newValue.text;
    s = s.replaceAll('#', '');
    s = '#$s'.toUpperCase();

    return TextEditingValue(
      text: s,
      selection: TextSelection.collapsed(offset: s.length),
    );
  }
}

///
class UpperCaseInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    return TextEditingValue(
      text: newValue.text.toUpperCase(),
      selection: newValue.selection,
    );
  }
}

///
class TextCapitalizationFormatter extends TextInputFormatter {
  ///
  const TextCapitalizationFormatter()
      : capitalization = TextCapitalization.none;

  ///
  const TextCapitalizationFormatter.words()
      : capitalization = TextCapitalization.words;

  ///
  const TextCapitalizationFormatter.sentences()
      : capitalization = TextCapitalization.sentences;

  ///
  const TextCapitalizationFormatter.characters()
      : capitalization = TextCapitalization.characters;

  ///
  final TextCapitalization capitalization;

  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    var text = '';

    switch (capitalization) {
      case TextCapitalization.words:
        text = newValue.text.split(' ').map(inCaps).join(' ');
        break;
      case TextCapitalization.sentences:
        final sentences = newValue.text.split('.');
        for (var i = 0; i < sentences.length; i++) {
          sentences[i] = inCaps(sentences[i]);
        }
        text = sentences.join('.');
        break;
      case TextCapitalization.characters:
        text = newValue.text.toUpperCase();
        break;
      case TextCapitalization.none:
        text = newValue.text;
        break;
    }
    return TextEditingValue(
      text: text,
      selection: newValue.selection,
    );
  }

  ///
  static String inCaps(String text) {
    if (text.isEmpty) {
      return text;
    }
    var result = '';
    for (var i = 0; i < text.length; i++) {
      if (text[i] != ' ') {
        result += '${text[i].toUpperCase()}${text.substring(i + 1)}';
        break;
      } else {
        result += text[i];
      }
    }
    return result;
  }
}
