library arabizi_transliterator;

class ArabiziTransliterator {
  final Map<String, String> _multiCharMap = {
    'sh': 'ش',
    'kh': 'خ',
    'th': 'ث',
    'gh': 'غ',
    'ph': 'ف', // rare but included
    'el': 'ال',
  };

  final Map<String, String> _singleCharMap = {
    '2': 'ء',
    '3': 'ع',
    '5': 'خ',
    '6': 'ط',
    '7': 'ح',
    '8': 'ق',
    '9': 'ص',
    // also map some english vowels to Arabic (basic)
    'a': 'ا',
    'e': 'ي',
    'i': 'ي',
    'o': 'و',
    'u': 'و',
    'b': 'ب',
    't': 'ت',
    'j': 'ج',
    'd': 'د',
    'r': 'ر',
    'z': 'ز',
    's': 'س',
    'f': 'ف',
    'q': 'ق',
    'k': 'ك',
    'l': 'ل',
    'm': 'م',
    'n': 'ن',
    'h': 'ه',
    'y': 'ي',
    'w': 'و',
    'c': 'ك', // sometimes 'c' used for 'k'
  };

  final List<String> _prefixes = ['ال', 'ب', 'في', 'و', 'ل'];

  final Map<String, String> _dictionary = {
    'mar7aba': 'مرحبا',
    'kifak': 'كيفك',
    'shu': 'شو',
    'sar': 'صار',
    'ya3tik': 'يعطيك',
    'el3afye': 'العافية',
    '2eltellak': 'قلتلك',
    'bsafer': 'بسافر',
    'bhebbak': 'بحبك',
    '3am': 'عم',
    'ma3': 'مع',
    'mafi': 'مافي',
    'hal': 'هل',
    'mnih': 'منيح',
    'mnihah': 'منيحة',
    'sabah': 'صباح',
    'noor': 'نور',
    'sahtein': 'صحتين',
    'tkallem': 'تكلم',
    'ma': 'ما',
    'teshuf': 'تشوف',
    'shukran': 'شكراً',
  };

  /// Transliterate full word phonetics, replacing multi and single chars.
  String transliterateFull(String input) {
    if (input.isEmpty) {
      return '';
    }

    String result = '';
    int i = 0;
    input = input.toLowerCase();

    const vowels = ['a', 'e', 'i', 'o', 'u'];

    while (i < input.length) {
      // Check for multi-character combinations first
      if (i + 1 < input.length) {
        final twoChar = input.substring(i, i + 2);
        if (_multiCharMap.containsKey(twoChar)) {
          result += _multiCharMap[twoChar]!;
          i += 2;
          continue;
        }
      }

      // Handle doubled vowels
      if (i + 1 < input.length &&
          input[i] == input[i + 1] &&
          vowels.contains(input[i])) {
        result += _singleCharMap[input[i]]!;
        i += 2;
        continue;
      }

      final oneChar = input[i];

      // Handle single characters
      if (_singleCharMap.containsKey(oneChar)) {
        final isVowel = vowels.contains(oneChar);

        if (isVowel) {
          // Vowel at the start of the word
          if (i == 0) {
            if (oneChar == 'a') {
              result += 'أ';
            } else if (oneChar == 'i') {
              result += 'إ';
            } else if (oneChar == 'u') {
              result += 'أ';
            } else {
              result += _singleCharMap[oneChar]!;
            }
          }
          // Vowels 'i' and 'e' are always transliterated
          else if (oneChar == 'i' || oneChar == 'e') {
            result += _singleCharMap[oneChar]!;
          }
          // Other vowels (a, o, u) are considered short and skipped unless they are at the beginning.
        } else {
          // Consonants and numbers
          result += _singleCharMap[oneChar]!;
        }
      } else {
        result += oneChar; // Keep non-mapped characters
      }
      i++;
    }
    return result;
  }

  /// Transliterate only numbers and special combos, keep English chars as-is.
  String transliteratePartial(String input) {
    String result = '';
    int i = 0;
    input = input.toLowerCase();

    while (i < input.length) {
      // multi-char first
      if (i + 1 < input.length) {
        final twoChar = input.substring(i, i + 2);
        if (_multiCharMap.containsKey(twoChar)) {
          result += _multiCharMap[twoChar]!;
          i += 2;
          continue;
        }
      }

      final oneChar = input[i];
      if (_singleCharMap.containsKey(oneChar) &&
          (oneChar.contains(RegExp(r'[0-9]')) ||
              _multiCharMap.containsKey(input.substring(i, i + 1)))) {
        result += _singleCharMap[oneChar]!;
      } else {
        result += oneChar; // keep English letters intact
      }
      i++;
    }
    return result;
  }

  /// Remove common Arabic prefixes
  String _stripPrefixes(String input) {
    for (final prefix in _prefixes) {
      if (input.startsWith(prefix)) {
        return input.substring(prefix.length);
      }
    }
    return input;
  }

  /// Get suggestions from dictionary matching by fuzzy mode
  /// mode: 'full' = full phonetic translit matching
  ///       'partial' = only numbers replaced, English kept
  ///       'strip' = prefix stripping applied on transliterated string
  List<String> getSuggestions(String input, {String mode = 'strip'}) {
    String transliterated;

    if (mode == 'full') {
      transliterated = transliterateFull(input);
    } else if (mode == 'partial') {
      transliterated = transliteratePartial(input);
    } else {
      // strip mode: full translit + prefix stripping
      transliterated = transliterateFull(input);
      transliterated = _stripPrefixes(transliterated);
    }

    // Use contains for fuzzy matching
    final suggestions = <String>[];
    for (final value in _dictionary.values) {
      if (value.contains(transliterated)) {
        suggestions.add(value);
      }
    }

    return suggestions;
  }
}
