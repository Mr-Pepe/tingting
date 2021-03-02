import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:provider/provider.dart';
import 'package:tingting/ui/audioControls/seekBar.dart';
import 'package:tingting/utils/audio.dart';
import 'package:tingting/utils/utils.dart';
import 'package:tingting/values/dimensions.dart';

class AudioControls extends StatelessWidget {
  final Icon volumeUpIcon;
  final Icon replay5Icon;
  final Icon replayIcon;
  final Icon pauseIcon;
  final Icon playArrow;

  AudioControls({
    this.volumeUpIcon: const Icon(Icons.volume_up),
    this.replay5Icon: const Icon(Icons.replay_5),
    this.replayIcon: const Icon(Icons.replay),
    this.pauseIcon: const Icon(Icons.pause),
    this.playArrow: const Icon(Icons.play_arrow),
  });

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
                  return Column(key: Key('audioControls'), children: <Widget>[
                    SeekBar(
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
                          icon: volumeUpIcon,
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
                          key: Key('audioBackwardButton'),
                          iconSize: otherButtonsSize,
                          icon: replay5Icon,
                          onPressed: () {
                            player.seek(clampDuration(
                                position - Duration(seconds: 5),
                                Duration.zero,
                                duration));
                          },
                        ),
                        IconButton(
                          key: Key('playPauseButton'),
                          iconSize: playButtonSize,
                          icon: _getCenterButtonIcon(processingState, playing),
                          onPressed: () => togglePlayPause(player),
                        ),
                        IconButton(
                          key: Key('audioForwardButton'),
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
                            key: Key('adjust speed button'),
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

  Icon _getCenterButtonIcon(ProcessingState processingState, bool playing) {
    if (processingState == ProcessingState.completed) {
      return replayIcon;
    } else if (playing == true) {
      return pauseIcon;
    } else {
      return playArrow;
    }
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
