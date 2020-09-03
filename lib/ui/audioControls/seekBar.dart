import 'package:flutter/material.dart';
import 'package:tingting/values/dimensions.dart';

class SeekBar extends StatefulWidget {
  final Duration duration;
  final Duration position;
  final ValueChanged<Duration> onChanged;
  final ValueChanged<Duration> onChangeEnd;

  SeekBar({
    @required this.duration,
    @required this.position,
    this.onChanged,
    this.onChangeEnd,
  });

  @override
  _SeekBarState createState() => _SeekBarState();
}

class _SeekBarState extends State<SeekBar> {
  Duration _dragValue;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        textFieldPadding,
        4,
        textFieldPadding,
        0,
      ),
      child: Stack(
        children: <Widget>[
          Positioned(
            left: 8.0,
            bottom: 0.0,
            child: Text(
                RegExp(r'((^0*[1-9]\d*:)?\d{2}:\d{2})\.\d+$')
                        .firstMatch("$_position")
                        ?.group(1) ??
                    '$_position',
                style: Theme.of(context).textTheme.caption),
          ),
          Slider(
            min: 0.0,
            max: widget.duration.inMilliseconds.toDouble(),
            value: _dragValue?.inMilliseconds?.toDouble() ??
                widget.position.inMilliseconds.toDouble(),
            onChanged: (value) {
              setState(() {
                _dragValue = Duration(milliseconds: value.round());
              });
              if (widget.onChanged != null) {
                widget.onChanged(Duration(milliseconds: value.round()));
              }
            },
            onChangeEnd: (value) {
              _dragValue = null;
              if (widget.onChangeEnd != null) {
                widget.onChangeEnd(Duration(milliseconds: value.round()));
              }
            },
          ),
          Positioned(
            right: 16.0,
            bottom: 0.0,
            child: Text(
                RegExp(r'((^0*[1-9]\d*:)?\d{2}:\d{2})\.\d+$')
                        .firstMatch("${widget.duration}")
                        ?.group(1) ??
                    '${widget.duration}',
                style: Theme.of(context).textTheme.caption),
          ),
        ],
      ),
    );
  }

  get _position {
    return _dragValue ?? widget.position;
  }
}
