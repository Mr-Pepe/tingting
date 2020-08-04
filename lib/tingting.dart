import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:provider/provider.dart';
import 'package:tingting/tingtingViewModel.dart';
import 'package:tingting/values/strings.dart';

class TingTing extends StatefulWidget {
  TingTing({Key key}) : super(key: key);

  @override
  _TingTingState createState() => _TingTingState();
}

class _TingTingState extends State<TingTing> {
  @override
  Widget build(BuildContext context) {
    final model = Provider.of<TingTingViewModel>(context);

    return Container(
      child: Center(
        child: Column(
          children: <Widget>[
            StreamBuilder<Duration>(
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
                    return Row(
                      children: <Widget>[
                        SeekBar(
                          duration: duration,
                          position: position,
                          onChangeEnd: (newPosition) {
                            model.player.seek(newPosition);
                          },
                        ),
                        ProgressText(
                          duration: duration,
                          position: position,
                        )
                      ],
                    );
                  },
                );
              },
            ),
            StreamBuilder<FullAudioPlaybackState>(
              stream: model.player.fullPlaybackStateStream,
              builder: (context, snapshot) {
                final fullState = snapshot.data;
                final state = fullState?.state;
                final buffering = fullState?.buffering;

                return Row(
                  children: <Widget>[
                    RaisedButton(
                      child: Text(Strings.chooseAudioFile),
                      onPressed: () async {
                        final audioFile = await FilePicker.getFile();
                        if (audioFile != null) {
                          model.setAudioFile(audioFile);
                        }
                      },
                    ),
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
                        // child: Text("Stop"),
                        // onPressed: () async {
                        //   if (playerState != null) {
                        //     player.stop();
                        //     player.seek(Duration(microseconds: 0));
                        //   }
                        // },
                        ),
                  ],
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  String getProgressText(Duration duration, Duration position) {
    return duration == Duration.zero
        ? "--/--"
        : position.inMinutes.toString() +
            ":" +
            (position.inSeconds % 60).toString() +
            " / " +
            duration.inMinutes.toString() +
            ":" +
            (duration.inSeconds % 60).toString();
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
  double _dragValue;

  @override
  Widget build(BuildContext context) {
    return Slider(
      min: 0.0,
      max: widget.duration.inMilliseconds.toDouble(),
      value: _dragValue ?? widget.position.inMilliseconds.toDouble(),
      onChanged: (value) {
        setState(() {
          _dragValue = value;
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
    );
  }
}
