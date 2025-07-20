# Arabizi Transliterator

A Dart/Flutter package for transliterating Arabizi (Arabic chat alphabet) to Arabic script. This library provides functionalities to convert Latin-based Arabizi text into its corresponding Arabic script, handling both multi-character and single-character transliterations, as well as providing dictionary-based suggestions.

## Features

-   **Full Transliteration**: Convert Arabizi words to their full Arabic phonetic equivalent, handling special characters and multi-character combinations.
-   **Partial Transliteration**: Convert only numbers and specific multi-character combinations, keeping other English letters intact. Useful for mixed-language texts.
-   **Dictionary Suggestions**: Get Arabic word suggestions based on transliterated input, with options for full, partial, or prefix-stripped matching.

## Getting Started

### Add the dependency

Add `arabizi_transliterator` to your `pubspec.yaml` file:

```yaml
dependencies:
  arabizi_transliterator: ^1.0.0 # Use the latest version
```

Then, run `flutter pub get` in your terminal.

## Usage

Import the package in your Dart file:

```dart
import 'package:arabizi_transliterator/arabizi_transliterator.dart';
```

Create an instance of the `ArabiziTransliterator`:

```dart
final transliterator = ArabiziTransliterator();
```

### 1. Full Transliteration

This method converts an Arabizi string to its full Arabic phonetic equivalent.

```dart
String arabiziText = "mar7aba";
String arabicText = transliterator.transliterateFull(arabiziText);
print(arabicText); // Output: مرحبا

arabiziText = "shukran";
arabicText = transliterator.transliterateFull(arabiziText);
print(arabicText); // Output: شكراً

arabiziText = "kifak";
arabicText = transliterator.transliterateFull(arabiziText);
print(arabicText); // Output: كيفك
```

### 2. Partial Transliteration

This method converts only numbers and specific multi-character combinations, keeping other English letters intact.

```dart
String arabiziText = "ana b7ebbak";
String arabicText = transliterator.transliteratePartial(arabiziText);
print(arabicText); // Output: انا بحبك

arabiziText = "hi 3am teshuf?";
arabicText = transliterator.transliteratePartial(arabiziText);
print(arabicText); // Output: hi عم تشوف؟
```

### 3. Getting Suggestions

This method provides Arabic word suggestions from an internal dictionary based on the transliterated input. You can specify the `mode` for transliteration.

-   `mode: 'full'` (full phonetic transliteration)
-   `mode: 'partial'` (only numbers and special combos replaced)
-   `mode: 'strip'` (default: full transliteration + prefix stripping)

```dart
// Using default 'strip' mode
List<String> suggestions = transliterator.getSuggestions("sba7");
print(suggestions); // Output: [صباح]

// Using 'full' mode
suggestions = transliterator.getSuggestions("kif", mode: 'full');
print(suggestions); // Output: [كيفك]

// Using 'partial' mode
suggestions = transliterator.getSuggestions("ma3", mode: 'partial');
print(suggestions); // Output: [مع]
```

## Examples

For more detailed examples, please refer to the `example` folder in this repository.

## Additional Information

WAAW SO EMPTY, I will add some later ヾ(•ω•`)o