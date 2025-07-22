import 'package:intl/intl.dart';

class CurrencyFormatter {
  static final NumberFormat _currencyFormat = NumberFormat.currency(
    locale: 'en_US',
    symbol: '\$',
    decimalDigits: 2,
  );

  static final NumberFormat _currencyFormatNoSymbol = NumberFormat.currency(
    locale: 'en_US',
    symbol: '',
    decimalDigits: 2,
  );

  // Format currency with symbol
  static String format(double amount) {
    return _currencyFormat.format(amount);
  }

  // Format currency without symbol
  static String formatWithoutSymbol(double amount) {
    return _currencyFormatNoSymbol.format(amount).trim();
  }

  // Format currency with custom symbol
  static String formatWithSymbol(double amount, String symbol) {
    return '$symbol${formatWithoutSymbol(amount)}';
  }

  // Parse currency string to double
  static double? parse(String text) {
    try {
      // Remove currency symbols and whitespace
      String cleanText = text.replaceAll(RegExp(r'[^\d.,]'), '');
      
      // Handle different decimal separators
      if (cleanText.contains(',') && cleanText.contains('.')) {
        // Assume comma is thousands separator and dot is decimal
        cleanText = cleanText.replaceAll(',', '');
      } else if (cleanText.contains(',')) {
        // Check if comma is likely decimal separator
        final parts = cleanText.split(',');
        if (parts.length == 2 && parts.last.length <= 2) {
          cleanText = cleanText.replaceAll(',', '.');
        } else {
          cleanText = cleanText.replaceAll(',', '');
        }
      }
      
      return double.parse(cleanText);
    } catch (e) {
      return null;
    }
  }

  // Format for display in tables/lists
  static String formatCompact(double amount) {
    if (amount >= 1000000) {
      return '\$${(amount / 1000000).toStringAsFixed(1)}M';
    } else if (amount >= 1000) {
      return '\$${(amount / 1000).toStringAsFixed(1)}K';
    } else {
      return format(amount);
    }
  }

  // Format percentage
  static String formatPercentage(double value, {int decimals = 1}) {
    return '${(value * 100).toStringAsFixed(decimals)}%';
  }

  // Format tax amount
  static String formatTax(double amount, double taxRate) {
    final tax = amount * taxRate;
    return '${format(tax)} (${formatPercentage(taxRate)}%)';
  }

  // Format discount
  static String formatDiscount(double discount, {bool isPercentage = false}) {
    if (isPercentage) {
      return '-${formatPercentage(discount / 100)}';
    } else {
      return '-${format(discount)}';
    }
  }

  // Validate currency input
  static bool isValidCurrency(String text) {
    return parse(text) != null;
  }

  // Format for receipt printing
  static String formatForReceipt(double amount, {int width = 10}) {
    final formatted = format(amount);
    return formatted.padLeft(width);
  }

  // Format total with proper alignment
  static String formatTotal(double amount, {int totalWidth = 20}) {
    final formatted = format(amount);
    return formatted.padLeft(totalWidth);
  }

  // Format currency for different locales
  static String formatForLocale(double amount, String locale, String currencyCode) {
    final formatter = NumberFormat.currency(
      locale: locale,
      name: currencyCode,
      decimalDigits: 2,
    );
    return formatter.format(amount);
  }

  // Calculate tip amount
  static double calculateTip(double amount, double tipPercentage) {
    return amount * (tipPercentage / 100);
  }

  // Format tip display
  static String formatTip(double amount, double tipPercentage) {
    final tip = calculateTip(amount, tipPercentage);
    return '${format(tip)} (${tipPercentage.toStringAsFixed(0)}%)';
  }

  // Calculate total with tax and tip
  static double calculateTotal(double subtotal, double taxRate, double tipPercentage) {
    final tax = subtotal * taxRate;
    final tip = calculateTip(subtotal, tipPercentage);
    return subtotal + tax + tip;
  }

  // Format order summary
  static Map<String, String> formatOrderSummary({
    required double subtotal,
    required double taxRate,
    required double discount,
    double tipPercentage = 0,
  }) {
    final tax = subtotal * taxRate;
    final tip = calculateTip(subtotal, tipPercentage);
    final total = subtotal + tax + tip - discount;

    return {
      'subtotal': format(subtotal),
      'tax': format(tax),
      'tip': tip > 0 ? format(tip) : '',
      'discount': discount > 0 ? formatDiscount(discount) : '',
      'total': format(total),
    };
  }
}
