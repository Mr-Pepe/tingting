import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:tingting/utils/getMismatchIndices.dart';

class GlobalAlignment extends Equatable {
  final List<String> original;
  final List<String> query;
  final List<bool> mismatchIndices;

  GlobalAlignment({@required this.original, @required this.query})
      : mismatchIndices = getMismatchIndices(original, query);

  @override
  List<Object> get props => [original, query];

  bool isEmpty() {
    return original.join() == '' && query.join() == '';
  }

  bool isNotEmpty() {
    return !isEmpty();
  }
}
