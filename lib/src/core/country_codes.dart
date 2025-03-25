/// This file contains a list of country codes and their corresponding names.
/// It is used to manage the current country code and provide a mapping of country codes to their names.
///
/// The `CountryCodes` class contains a static variable `current` to set the current country code.
/// It also contains a static map `countryCodes` that holds the country codes and their names.
/// /// The `countryCodes` map can be extended to include more countries as needed.
/// /// Example usage:
/// /// ```dart
/// import 'package:your_package/src/core/country_codes.dart';
/// /// void main() {
/// ///   // Set the current country code
/// ///   CountryCodes.current = 'VN';
/// ///   // Access the country name using the country code
/// ///   String countryName = CountryCodes.countryCodes[CountryCodes.current] ?? 'Unknown';
/// ///   print('Current country: $countryName'); // Output: Current country: Vietnam
/// /// /// }
/// /// ```
/// /// The `countryCodes` map can be used to get the name of a country based on its code.
/// /// The `current` variable can be set to the desired country code.
/// /// This is useful for applications that need to display country-specific information or formats.
/// /// The `CountryCodes` class is designed
/// to be easily extensible, allowing developers to add more countries as needed.
class CountryCodes {
  /// Sets the current country code.
  static String current = 'US';
}
