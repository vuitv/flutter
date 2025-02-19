# 🧑‍💻 vuitv code base

[![Pub][pub_badge]][pub_link]
[![style: very good analysis][very_good_analysis_badge]][very_good_analysis_link]
[![License: MIT][license_badge]][license_link]

<!--
This package provides a collection of utilities and extensions for building Dart/Flutter applications.

Key features:
- JSON converters for common data types 
- Text input formatters for currency, phone numbers, etc.
- Color utilities including hex color parsing
- String extensions and validators

The package follows Very Good Analysis code style guidelines and is licensed under MIT.
-->

A collection of utilities and formatters for Flutter applications, created by VuiTv 🤖

## Setup

Add to your `pubspec.yaml`:

```yaml
dependencies:
  vuitv: ^3.22.0
```

## Features

### Text Input Formatters
  * Currency formatting (USD, VND)
  * Phone number formatting (US and Vietnamese formats)
  * Hex color input
  * Text capitalization
  * Number formatting

## Examples

Currency Formatter
```dart
// US currency formatter ($)
final usFormatter = CurrencyInputFormatter.us();
// Output: $1,234.56

// Vietnamese currency formatter (₫)
final vnFormatter = CurrencyInputFormatter.vn();
// Output: 1,234₫
```

Phone Number Formatter
```dart
// US format
final usPhone = PhoneInputFormatter();
// Input: 1234567890
// Output: (123) 456-7890

// Vietnamese format
final vnPhone = PhoneInputFormatter(const Locale('vi'));
// Input: 1234567890
// Output: 123 456 7890
```

Hex Color Formatter
```dart
final hexColor = HexColorInputFormatter();
// Input: #FF0000
// Output: Color(0xFFFF0000)
```

Text Capitalization
```dart
// Capitalize words
final wordCaps = TextCapitalizationFormatter.words();
// Input: hello world
// Output: Hello World

// Capitalize sentences
final sentenceCaps = TextCapitalizationFormatter.sentences();
// Input: hello. world.
// Output: Hello. World.
```

---

[pub_badge]: https://img.shields.io/badge/pub-3.19.6-blue
[pub_link]: https://pub.dev/packages/vuitv
[license_badge]: https://img.shields.io/badge/license-MIT-blue.svg
[license_link]: https://opensource.org/licenses/MIT
[very_good_analysis_badge]: https://img.shields.io/badge/style-very_good_analysis-B22C89.svg
[very_good_analysis_link]: https://pub.dev/packages/very_good_analysis