import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tingting/utils/interleaveOriginalAndQuery.dart';
import 'package:tingting/values/strings.dart';

main() {
  group('Test interleaving', () {
    final nContainers = 10;
    final originalContainers = List.generate(nContainers,
        (index) => Container(child: Center(child: Text(index.toString()))));
    final queryContainers = List.generate(
        nContainers,
        (index) => Container(
            child: Center(child: Text((index + nContainers).toString()))));

    final queryContainersPlaceholder = List.generate(
        nContainers,
        (index) => Container(
            child: Center(child: Text((Strings.alignmentPlaceholder)))));

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
        'If linebreak indices are provided and the self written text is only the placeholder at those positions the corresponding elements are not added and a new line is started',
        () {
      final lenRow = nContainers ~/ 2;
      final lineBreakIndices = List.generate(nContainers, (i) => i == 8);

      final interleaved = interleaveOriginalAndQuery(
          originalContainers, queryContainersPlaceholder, lenRow,
          lineBreakIndices: lineBreakIndices);

      expect(interleaved.length, equals(30));
      for (var i in [13, 14, 18, 19]) {
        expect(interleaved[i].child, equals(null));
      }

      for (var i in Iterable<int>.generate(nContainers)) {
        final outcome = !lineBreakIndices[i];
        expect(interleaved.contains(originalContainers[i]), equals(outcome));
        expect(interleaved.contains(queryContainersPlaceholder[i]),
            equals(outcome));
      }
    });

    test('Self written character gets still written if aligned with line break',
        () {
      final originalContainers = List.generate(
        3,
        (index) => Container(child: Center(child: Text(index.toString()))),
      );
      final queryContainers = List.generate(3,
          (index) => Container(child: Center(child: Text((index).toString()))));

      final lenRow = 3;

      final lineBreakIndices = [false, true, false];

      final interleaved = interleaveOriginalAndQuery(
        originalContainers,
        queryContainers,
        lenRow,
        lineBreakIndices: lineBreakIndices,
      );

      expect(interleaved.length, equals(12));

      expect(interleaved[0], originalContainers[0]);
      expect(interleaved[1], originalContainers[1]);
      expect(interleaved[3], queryContainers[0]);
      expect(interleaved[4], queryContainers[1]);
      expect(interleaved[6], originalContainers[2]);
      expect(interleaved[9], queryContainers[2]);
    });

    test(
        'There is no empty line if the linebreak is at the beginning of a line',
        () {
      final lenRow = nContainers ~/ 2;
      final lineBreakIndices = List.generate(nContainers, (i) => i == 5);

      final interleaved = interleaveOriginalAndQuery(
          originalContainers, queryContainersPlaceholder, lenRow,
          lineBreakIndices: lineBreakIndices);

      expect(interleaved.length, equals(20));

      for (var i in Iterable<int>.generate(nContainers)) {
        final outcome = !lineBreakIndices[i];
        expect(interleaved.contains(originalContainers[i]), equals(outcome));
        expect(interleaved.contains(queryContainersPlaceholder[i]),
            equals(outcome));
      }
    });

    test(
        'Empty rows can optionally be inserted between original/query row pairs',
        () {
      final lenRow = nContainers ~/ 2;

      final interleaved = interleaveOriginalAndQuery(
          originalContainers, queryContainers, lenRow,
          addSpacing: true);

      expect(interleaved.length, equals(25));
    });

    test('The last line gets filled up to the end', () {
      final lenRow = 3;

      final interleaved = interleaveOriginalAndQuery(
          originalContainers, queryContainers, lenRow);

      expect(interleaved.length, equals(24));
    });

    test('There is only one line for spacing', () {
      final lenRow = nContainers ~/ 2;
      final lineBreakIndices = List.generate(nContainers, (i) => i == 5);

      final interleaved = interleaveOriginalAndQuery(
        originalContainers,
        queryContainersPlaceholder,
        lenRow,
        lineBreakIndices: lineBreakIndices,
        addSpacing: true,
      );

      expect(interleaved.length, equals(25));
    });
  });

  group('Error handling', () {
    test('Throws argument error if original and query are not the same length',
        () {
      final originalContainers = List.generate(5,
          (index) => Container(child: Center(child: Text(index.toString()))));
      final queryContainers = List.generate(
          4,
          (index) =>
              Container(child: Center(child: Text((index + 5).toString()))));

      final lenRow = 100;

      expect(
          () => interleaveOriginalAndQuery(
                originalContainers,
                queryContainers,
                lenRow,
              ),
          throwsArgumentError);
    });

    test(
        'Throws argument error if original and line break indices are not the same length',
        () {
      final originalContainers = List.generate(5,
          (index) => Container(child: Center(child: Text(index.toString()))));
      final queryContainers = List.generate(
          5,
          (index) =>
              Container(child: Center(child: Text((index + 5).toString()))));

      final lenRow = 100;

      final lineBreakIndices = [true, true];

      expect(
          () => interleaveOriginalAndQuery(
                originalContainers,
                queryContainers,
                lenRow,
                lineBreakIndices: lineBreakIndices,
              ),
          throwsArgumentError);
    });
  });
}
