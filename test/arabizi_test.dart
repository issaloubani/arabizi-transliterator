import 'package:flutter_test/flutter_test.dart';
import 'package:arabizi/arabizi_transliterator.dart';

void main() {
  group('ArabiziTranslator', () {
    final translator = ArabiziTransliterator();

    test('should translate basic Arabizi to Arabic', () {
      expect(translator.transliterateFull('salam'), 'سلم');
      expect(translator.transliterateFull('marhaba'), 'مرحبا');
      expect(translator.transliterateFull('shukran'), 'شكرن');
    });

    test('should handle numbers in Arabizi', () {
      expect(translator.transliterateFull('7abibi'), 'حبيبي');
      expect(translator.transliterateFull('3omri'), 'عمري');
      expect(translator.transliterateFull('2ahlan'), 'أهلن');
    });

    test('should handle digraphs correctly', () {
      expect(translator.transliterateFull('khallas'), 'خلص');
      expect(translator.transliterateFull('ghali'), 'غلي');
      expect(translator.transliterateFull('shebak'), 'شبك');
    });

    test('should handle long vowels', () {
      expect(translator.transliterateFull('saeed'), 'سعيد');
      expect(translator.transliterateFull('noor'), 'نور');
      expect(translator.transliterateFull('baab'), 'باب');
    });

    test('should handle the definite article "al"', () {
      expect(translator.transliterateFull('albayt'), 'البيت');
      expect(translator.transliterateFull('alkitab'), 'الكتاب');
    });

    test('should handle mixed characters', () {
      expect(translator.transliterateFull('ana ra2is al majlis'), 'أنا رءيس المجلس');
      expect(translator.transliterateFull('3indama'), 'عندما');
    });

    test('should return an empty string for empty input', () {
      expect(translator.transliterateFull(''), '');
    });

    test('should handle strings with no Arabizi characters', () {
      expect(translator.transliterateFull('hello world'), 'hello world');
    });

    test('should handle single vowels at the beginning of a word', () {
      expect(translator.transliterateFull('ana'), 'أنا');
      expect(translator.transliterateFull('ommi'), 'أمي');
      expect(translator.transliterateFull('islam'), 'إسلم');
    });

    test('should not transliterate single vowels in the middle of a word', () {
      expect(translator.transliterateFull('salam'), 'سلم');
      expect(translator.transliterateFull('katab'), 'كتب');
    });

    test('should correctly transliterate partial words', () {
      expect(translator.transliteratePartial('salam'), 'salam');
      expect(translator.transliteratePartial('7abibi'), 'حabibi');
      expect(translator.transliteratePartial('3omri'), 'عomri');
      expect(translator.transliteratePartial('shukran'), 'شukran');
    });
  });
}
