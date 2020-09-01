import 'package:flutter_test/flutter_test.dart';
import 'package:tingting/utils/globalAlignment.dart';

void main() {
  group('Test isEmpty method', () {
    test('Returns true if all elements in original and query are empty strings',
        () {
      final alignment1 = GlobalAlignment(original: [''], query: ['']);
      final alignment2 = GlobalAlignment(original: ['', ''], query: ['', '']);

      expect(alignment1.isEmpty(), true);
      expect(alignment2.isEmpty(), true);
    });

    test('Returns true if original and query are empty lists', () {
      final alignment = GlobalAlignment(original: [], query: []);

      expect(alignment.isEmpty(), true);
    });

    test('Return true if original or query is not empty', () {
      expect(GlobalAlignment(original: ['a'], query: ['']).isEmpty(), false);
      expect(GlobalAlignment(original: [''], query: ['a']).isEmpty(), false);
      expect(GlobalAlignment(original: ['a'], query: ['a']).isEmpty(), false);
    });
  });
}
