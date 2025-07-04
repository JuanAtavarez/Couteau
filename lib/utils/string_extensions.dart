// lib/utils/string_extensions.dart

extension StringCapitalizationExtension on String {
  String capitalizeFirstOfEachWord() {
    return split(' ').map((word) => word.isNotEmpty ? '${word[0].toUpperCase()}${word.substring(1)}' : '').join(' ');
  }
}