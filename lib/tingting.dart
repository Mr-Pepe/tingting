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
                        getProgressSlider(duration, position,
                            onChanged: (newPosition) {
                          model.player.seek(newPosition);
                        }),
                        Text(getProgressText(duration, position)),
                      ],
                    );
                  },
                );
              },
            ),
            StreamBuilder<FullAudioPlaybackState>(
              stream: model.player.fullPlaybackStateStream,
              builder: (context, snapshot) {
                // final state = fullState?.state;
                // final buffering = fullState?.buffering;
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
                        // child: (playerState == null ||
                        //         playerState != AudioPlayerState.PLAYING)
                        //     ? Text("Play")
                        //     : Text("Pause"),
                        // onPressed: () async {
                        //   if (playerState != null) {
                        //     if (playerState != AudioPlayerState.PLAYING) {
                        //       await player.play(audioFile.path, isLocal: true);
                        //     } else {
                        //       await player.pause();
                        //     }
                        //   }
                        // },
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

  Slider getProgressSlider(Duration duration, Duration position,
      {Function onChanged}) {
    return Slider(
      onChanged: duration == Duration.zero
          ? null
          : (v) {
              if (onChanged != null) {
                onChanged(Duration(milliseconds: v.round()));
              }
            },
      value: position.inMilliseconds.toDouble(),
      min: 0,
      max: position.inMilliseconds.toDouble(),
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
