import 'package:intl/intl.dart';

/// Utility class for formatting currency and game resource numbers cleanly.
class NumberFormatter {
  static final NumberFormat _standardFormatter = NumberFormat(
    '#,##0.##',
    'en_US',
  );

  /// Formats a raw number into readable idle suffixes (e.g. 1.25K, 4.50M, 12.30B, 1.00T).
  static String formatCompact(
    double value, {
    String prefix = '',
    String suffix = '',
  }) {
    if (value.isNaN || value.isInfinite) {
      return '${prefix}0$suffix';
    }
    if (value < 0) {
      return '-${formatCompact(-value, prefix: prefix, suffix: suffix)}';
    }
    if (value < 1000) {
      return '$prefix${_standardFormatter.format(value)}$suffix';
    }

    final List<String> units = [
      '',
      'K',
      'M',
      'B',
      'T',
      'Qa',
      'Qi',
      'Sx',
      'Sp',
      'Oc',
      'No',
      'Dc',
    ];
    int unitIndex = 0;
    double reduced = value;

    while (reduced >= 1000 && unitIndex < units.length - 1) {
      reduced /= 1000;
      unitIndex++;
    }

    final formatted = reduced.toStringAsFixed(reduced >= 100 ? 1 : 2);
    return '$prefix$formatted${units[unitIndex]}$suffix';
  }

  /// Formats currency with a leading dollar sign ($1.25M)
  static String formatCurrency(double value) {
    return formatCompact(value, prefix: '\$');
  }

  /// Formats rate of income (+$12.4K/s)
  static String formatRate(double value) {
    return '+${formatCompact(value, prefix: '\$')}/s';
  }
}
