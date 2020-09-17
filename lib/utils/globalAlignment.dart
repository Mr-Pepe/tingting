import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:tingting/utils/mismatchIndices.dart';

class GlobalAlignment extends Equatable {
  final List<String> original;
  final List<String> query;
  final List<bool> mismatchIndices;
  final List<bool> lineBreakIndices;

  GlobalAlignment({@required this.original, @required this.query})
      : mismatchIndices = getCharacterMismatchIndices(original, query),
        lineBreakIndices = List.generate(
          original.length,
          (index) => original[index] == '\n',
        );

  @override
  List<Object> get props => [original, query];

  bool isEmpty() {
    return original.join() == '' && query.join() == '';
  }

  bool isNotEmpty() {
    return !isEmpty();
  }
}
