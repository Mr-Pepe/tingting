import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tingting/utils/interleaveOriginalAndQuery.dart';

main() {
  group('Test interleaving', () {
    final nContainers = 10;
    final originalContainers = List.generate(nContainers,
        (index) => Container(child: Center(child: Text(index.toString()))));
    final queryContainers = List.generate(
        nContainers,
        (index) => Container(
            child: Center(child: Text((index + nContainers).toString()))));

    test(
        'Returns original and query appended if they fit exactly in a line each',
        () {
      final interleaved = interleaveOriginalAndQuery(
          originalContainers, queryContainers, nContainers);

      expect(interleaved, equals(originalContainers + queryContainers));
    });

    test('Interleaves original and query when they do not fit in a line', () {
      final lenRow = nContainers ~/ 2;

      final interleaved = interleaveOriginalAndQuery(
          originalContainers, queryContainers, lenRow);

      expect(interleaved.take(lenRow), equals(originalContainers.take(lenRow)));
      expect(interleaved.skip(lenRow).take(lenRow),
          equals(queryContainers.take(lenRow)));
      expect(interleaved.skip(2 * lenRow).take(lenRow),
          equals(originalContainers.skip(lenRow)));
      expect(interleaved.skip(3 * lenRow), queryContainers.skip(lenRow));
    });

    test(
        'If linebreak indices are provided the corresponding elements are not added and a new line is started',
        () {
      final lenRow = nContainers ~/ 2;
      final lineBreak = 8;

      final interleaved = interleaveOriginalAndQuery(
          originalContainers, queryContainers, lenRow,
          lineBreaks: [lineBreak]);

      expect(interleaved.length, equals(22));
      for (var i in [13, 14, 18, 19]) {
        expect(interleaved[i].child, equals(null));
      }

      for (var i in Iterable<int>.generate(nContainers)) {
        final outcome = (i == lineBreak) ? false : true;
        expect(interleaved.contains(originalContainers[i]), equals(outcome));
        expect(interleaved.contains(queryContainers[i]), equals(outcome));
      }
    });

    test(
        'There is no empty line if the linebreak is at the beginning of a line',
        () {
      final lenRow = nContainers ~/ 2;
      final lineBreak = 5;

      final interleaved = interleaveOriginalAndQuery(
          originalContainers, queryContainers, lenRow,
          lineBreaks: [lineBreak]);

      expect(interleaved.length, equals(18));

      for (var i in Iterable<int>.generate(nContainers)) {
        final outcome = (i == lineBreak) ? false : true;
        expect(interleaved.contains(originalContainers[i]), equals(outcome));
        expect(interleaved.contains(queryContainers[i]), equals(outcome));
      }
    });

    test(
        'Empty rows can optionally be inserted between original/query row pairs',
        () {
      final lenRow = nContainers ~/ 2;

      final interleaved = interleaveOriginalAndQuery(
          originalContainers, queryContainers, lenRow,
          addSpacing: true);

      expect(interleaved.length, 25);
    });
  });
}
