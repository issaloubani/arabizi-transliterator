/// A library for transliterating Arabizi (Arabic chat alphabet) to Arabic script.
///
/// This library provides functionalities to convert Latin-based Arabizi text
/// into its corresponding Arabic script, handling both multi-character and
/// single-character transliterations, as well as providing dictionary-based
/// suggestions.
library;

class ArabiziTransliterator {
  /// A map for multi-character Arabizi combinations and their Arabic equivalents.
  ///
  /// These combinations are typically processed before single characters to
  /// ensure correct transliteration (e.g., 'sh' maps to 'ش' rather than 's' to 'س' and 'h' to 'ه').
  final Map<String, String> _multiCharMap = {
    'sh': 'ش',
    'kh': 'خ',
    'th': 'ث',
    'gh': 'غ',
    'ph': 'ف', // TODO: Confirm if 'ph' is a common enough Arabizi mapping for 'ف'. It's rare but included.
    'el': 'ال',
  };

  /// A map for single-character Arabizi (including numbers used as letters)
  /// and their Arabic equivalents.
  ///
  /// This map handles the core transliteration of individual Latin characters
  /// and numbers commonly used in Arabizi.
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

  /// A list of common Arabic prefixes used for stripping in suggestion mode.
  ///
  /// These prefixes are removed from transliterated words to improve the
  /// accuracy of dictionary lookups.
  final List<String> _prefixes = ['ال', 'ب', 'في', 'و', 'ل'];

  /// A dictionary of common Arabizi words and their Arabic transliterations.
  ///
  /// This dictionary is used to provide suggestions based on fuzzy matching
  /// with transliterated input.
  final Map<String, String> _dictionary = {
    'shukran': 'شكراً',
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
  };

  /// Transliterates an Arabizi input string to Arabic script using full phonetic rules.
  ///
  /// This method processes the input character by character, prioritizing
  /// multi-character combinations (e.g., 'sh', 'kh') before single characters.
  /// It also handles special cases for vowels at the beginning of words and
  /// doubled vowels.
  ///
  /// [input] The Arabizi string to transliterate.
  /// Returns the transliterated Arabic string.
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
      if (i + 1 < input.length && input[i] == input[i + 1] && vowels.contains(input[i])) {
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

  /// Transliterates an Arabizi input string partially, replacing only numbers
  /// and special multi-character combinations, while keeping English letters intact.
  ///
  /// This method is useful when only specific Arabizi conventions (like numbers
  /// representing Arabic letters or common multi-character mappings) need to
  /// be converted, preserving the rest of the Latin characters.
  ///
  /// [input] The Arabizi string to partially transliterate.
  /// Returns the partially transliterated Arabic string.
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
      if (_singleCharMap.containsKey(oneChar) && (oneChar.contains(RegExp(r'[0-9]')) || _multiCharMap.containsKey(input.substring(i, i + 1)))) {
        result += _singleCharMap[oneChar]!;
      } else {
        result += oneChar; // keep English letters intact
      }
      i++;
    }
    return result;
  }

  /// Strips common Arabic prefixes from a given Arabic string.
  ///
  /// This is a helper method used internally, primarily for improving
  /// dictionary lookup accuracy by normalizing words.
  ///
  /// [input] The Arabic string from which to strip prefixes.
  /// Returns the string with prefixes removed, if any.
  String _stripPrefixes(String input) {
    for (final prefix in _prefixes) {
      if (input.startsWith(prefix)) {
        return input.substring(prefix.length);
      }
    }
    return input;
  }

  /// Retrieves suggestions from the internal dictionary based on the transliterated input.
  ///
  /// The `mode` parameter determines how the input is transliterated before
  /// matching against the dictionary:
  /// - `'full'`: Applies full phonetic transliteration.
  /// - `'partial'`: Applies partial transliteration (numbers and special combos only).
  /// - `'strip'` (default): Applies full transliteration and then strips common Arabic prefixes.
  ///
  /// Suggestions are found using fuzzy matching (i.e., if the transliterated
  /// input is contained within a dictionary entry's Arabic value).
  ///
  /// [input] The Arabizi string for which to get suggestions.
  /// [mode] The transliteration mode to use ('full', 'partial', or 'strip'). Defaults to 'strip'.
  /// Returns a list of matching Arabic strings from the dictionary.
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
