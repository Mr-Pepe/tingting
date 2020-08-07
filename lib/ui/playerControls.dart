import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:provider/provider.dart';
import 'package:tingting/utils/utils.dart';
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
            stream: model.player.getPositionStream(),
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
                  StreamBuilder<FullAudioPlaybackState>(
                    stream: model.player.fullPlaybackStateStream,
                    builder: (context, snapshot) {
                      final fullState = snapshot.data;
                      final state = fullState?.state;

                      return SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          children: <Widget>[
                            RaisedButton(
                              child: (state != AudioPlaybackState.playing)
                                  ? Text("Play")
                                  : Text("Pause"),
                              onPressed: () {
                                (state != AudioPlaybackState.playing)
                                    ? model.player.play()
                                    : model.player.pause();
                              },
                            ),
                            RaisedButton(
                              child: Text("Stop"),
                              onPressed: () {
                                model.player.stop();
                              },
                            ),
                            RaisedButton(
                              child: Text("-5s"),
                              onPressed: () {
                                model.player.seek(clampDuration(
                                    position - Duration(seconds: 5),
                                    Duration.zero,
                                    duration));
                              },
                            ),
                            RaisedButton(
                              child: Text("+5s"),
                              onPressed: () {
                                if (state == AudioPlaybackState.stopped) {
                                  model.player.play();
                                  model.player.pause();
                                }
                                model.player.seek(clampDuration(
                                    position + Duration(seconds: 5),
                                    Duration.zero,
                                    duration));
                              },
                            ),
                          ],
                        ),
                      );
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
    return Wrap(
      direction: Axis.vertical,
      children: [
        Row(
          children: <Widget>[
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
            ProgressText(
              duration: widget.duration,
              position: _dragValue ?? widget.position,
            )
          ],
        ),
      ],
    );
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
