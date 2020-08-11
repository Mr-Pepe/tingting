import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

class GlobalAlignment extends Equatable {
  final List<String> original;
  final List<String> query;

  GlobalAlignment({@required this.original, @required this.query});

  @override
  List<Object> get props => [original, query];

  bool isEmpty() {
    return original.join() == '' && query.join() == '';
  }

  bool isNotEmpty() {
    return !isEmpty();
  }
}
