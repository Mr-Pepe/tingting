import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:provider/provider.dart';
import 'package:tingting/utils/utils.dart';
import 'package:tingting/values/dimensions.dart';
import 'package:tingting/viewModels/tingtingViewModel.dart';

class PlayerControls extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final model = Provider.of<TingTingViewModel>(context);

    return Container(
      child: StreamBuilder<Duration>(
        stream: model.player.durationStream,
        builder: (context, snapshot) {
          final duration = snapshot.data ?? Duration.zero;

          return StreamBuilder<Duration>(
            stream: model.player.positionStream,
            builder: (context, snapshot) {
              Duration position = snapshot.data ?? Duration.zero;
              if (position > duration) {
                position = duration;
              }
              return Column(
                children: <Widget>[
                  ProgressBar(
                    duration: duration,
                    position: position,
                    onChangeEnd: (newPosition) {
                      model.player.seek(newPosition);
                    },
                  ),
                  StreamBuilder<PlayerState>(
                    stream: model.player.playerStateStream,
                    builder: (context, snapshot) {
                      final playerState = snapshot.data;
                      final playing = playerState?.playing;

                      if (playerState != null) {
                        return Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            IconButton(
                              iconSize: otherButtonsSize,
                              icon: Icon(Icons.volume_up),
                              onPressed: () {
                                _showSliderDialog(
                                  context: context,
                                  title: "Adjust volume",
                                  divisions: 10,
                                  min: 0.0,
                                  max: 1.0,
                                  stream: model.player.volumeStream,
                                  onChanged: model.player.setVolume,
                                );
                              },
                            ),
                            IconButton(
                              iconSize: otherButtonsSize,
                              icon: Icon(Icons.replay_5),
                              onPressed: () {
                                model.player.seek(clampDuration(
                                    position - Duration(seconds: 5),
                                    Duration.zero,
                                    duration));
                              },
                            ),
                            IconButton(
                              iconSize: playButtonSize,
                              icon: playing
                                  ? Icon(Icons.pause)
                                  : Icon(Icons.play_arrow),
                              onPressed: () {
                                playing
                                    ? model.player.pause()
                                    : model.player.play();
                              },
                            ),
                            IconButton(
                              iconSize: otherButtonsSize,
                              icon: Icon(Icons.forward_5),
                              onPressed: () {
                                model.player.seek(clampDuration(
                                    position + Duration(seconds: 5),
                                    Duration.zero,
                                    duration));
                              },
                            ),
                            StreamBuilder<double>(
                              stream: model.player.speedStream,
                              builder: (context, snapshot) => IconButton(
                                iconSize: otherButtonsSize,
                                icon: Text(
                                    "${snapshot.data?.toStringAsFixed(1)}x",
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: speedButtonFontSize)),
                                onPressed: () {
                                  _showSliderDialog(
                                    context: context,
                                    title: "Adjust speed",
                                    divisions: 10,
                                    min: 0.5,
                                    max: 1.5,
                                    stream: model.player.speedStream,
                                    onChanged: model.player.setSpeed,
                                  );
                                },
                              ),
                            ),
                          ],
                        );
                      } else {
                        return Container();
                      }
                    },
                  ),
                ],
              );
            },
          );
        },
      ),
    );
  }
}

_showSliderDialog({
  BuildContext context,
  String title,
  int divisions,
  double min,
  double max,
  String valueSuffix = '',
  Stream<double> stream,
  ValueChanged<double> onChanged,
}) {
  showDialog(
    context: context,
    builder: (context) => AlertDialog(
      title: Text(title, textAlign: TextAlign.center),
      content: StreamBuilder<double>(
        stream: stream,
        builder: (context, snapshot) => Container(
          height: 100.0,
          child: Column(
            children: [
              Text('${snapshot.data?.toStringAsFixed(1)}$valueSuffix',
                  style: TextStyle(
                      fontFamily: 'Fixed',
                      fontWeight: FontWeight.bold,
                      fontSize: 24.0)),
              Slider(
                divisions: divisions,
                min: min,
                max: max,
                value: snapshot.data ?? 1.0,
                onChanged: onChanged,
              ),
            ],
          ),
        ),
      ),
    ),
  );
}

class ProgressBar extends StatefulWidget {
  final Duration duration;
  final Duration position;
  final ValueChanged<Duration> onChanged;
  final ValueChanged<Duration> onChangeEnd;

  ProgressBar({
    @required this.duration,
    @required this.position,
    this.onChanged,
    this.onChangeEnd,
  });

  @override
  _ProgressBarState createState() => _ProgressBarState();
}

class _ProgressBarState extends State<ProgressBar> {
  Duration _dragValue;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        textFieldPadding,
        0,
        textFieldPadding,
        textFieldPadding,
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

class ProgressText extends StatelessWidget {
  final Duration duration;
  final Duration position;
  const ProgressText({@required this.duration, @required this.position});

  @override
  Widget build(BuildContext context) {
    final text = duration == Duration.zero
        ? "--/--"
        : position.inMinutes.toString() +
            ":" +
            (position.inSeconds % 60).toString() +
            " / " +
            duration.inMinutes.toString() +
            ":" +
            (duration.inSeconds % 60).toString();
    return Text(text);
  }
}
