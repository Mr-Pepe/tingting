import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:provider/provider.dart';
import 'package:tingting/utils/utils.dart';
import 'package:tingting/values/dimensions.dart';

class AudioControls extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final player = Provider.of<AudioPlayer>(context);

    return StreamBuilder<Duration>(
      stream: player.durationStream,
      builder: (context, snapshot) {
        final duration = snapshot.data ?? Duration.zero;

        return StreamBuilder<Duration>(
          stream: player.positionStream,
          builder: (context, snapshot) {
            Duration position = snapshot.data ?? Duration.zero;
            if (position > duration) {
              position = duration;
            }
            return StreamBuilder<PlayerState>(
              stream: player.playerStateStream,
              builder: (context, snapshot) {
                final playerState = snapshot.data;
                final playing = playerState?.playing;
                final processingState = playerState?.processingState;

                if (playerState != null) {
                  return Column(children: <Widget>[
                    ProgressBar(
                      duration: duration,
                      position: position,
                      onChangeEnd: (newPosition) {
                        player.seek(newPosition);
                      },
                    ),
                    Row(
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
                              stream: player.volumeStream,
                              onChanged: player.setVolume,
                            );
                          },
                        ),
                        IconButton(
                          iconSize: otherButtonsSize,
                          icon: Icon(Icons.replay_5),
                          onPressed: () {
                            player.seek(clampDuration(
                                position - Duration(seconds: 5),
                                Duration.zero,
                                duration));
                          },
                        ),
                        IconButton(
                          iconSize: playButtonSize,
                          icon: _getCenterButtonIcon(processingState, playing),
                          onPressed: () => _centerButtonCallback(
                              processingState, playing, player),
                        ),
                        IconButton(
                          iconSize: otherButtonsSize,
                          icon: Icon(Icons.forward_5),
                          onPressed: () {
                            player.seek(clampDuration(
                                position + Duration(seconds: 5),
                                Duration.zero,
                                duration));
                          },
                        ),
                        StreamBuilder<double>(
                          stream: player.speedStream,
                          builder: (context, snapshot) => IconButton(
                            iconSize: otherButtonsSize,
                            icon: Text("${snapshot.data?.toStringAsFixed(1)}x",
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
                                stream: player.speedStream,
                                onChanged: player.setSpeed,
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  ]);
                } else {
                  return Container();
                }
              },
            );
          },
        );
      },
    );
  }
}

Icon _getCenterButtonIcon(ProcessingState processingState, bool playing) {
  IconData centerButtonIcon;
  if (playing != true) {
    centerButtonIcon = Icons.play_arrow;
  } else if (processingState != ProcessingState.completed) {
    centerButtonIcon = Icons.pause;
  } else {
    centerButtonIcon = Icons.replay;
  }

  return Icon(centerButtonIcon);
}

_centerButtonCallback(
    ProcessingState processingState, bool playing, AudioPlayer player) {
  if (playing != true) {
    player.play();
  } else if (processingState != ProcessingState.completed) {
    player.pause();
  } else {
    player.seek(Duration.zero);
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
