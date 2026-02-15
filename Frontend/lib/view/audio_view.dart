import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:toko/models/song.dart';
import 'package:toko/viewmodels/audio_viewmodel.dart';

class AudioView extends StatefulWidget {
  const AudioView({super.key});

  @override
  State<AudioView> createState() => _AudioViewState();
}

class _AudioViewState extends State<AudioView> {

  @override
  void dispose() {
    final audioViewModel = Provider.of<AudioViewmodel>(context, listen: false);
    audioViewModel.player.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final audioViewmodel = Provider.of<AudioViewmodel>(context);
    return Scaffold(
      appBar: AppBar(title: Text("Audio Player"), backgroundColor: Colors.blue,),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView.builder(
          itemCount: audioViewmodel.songList.length,
          itemBuilder: (context, index) {
            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text("Judul: ${audioViewmodel.songList[index].title}"),
                SizedBox(height: 5,),
                Text(audioViewmodel.isComplete ? "Lagu selesai" : "Lagu sedang diputar"),
                SizedBox(height: 5,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    IconButton(
                      onPressed: () => audioViewmodel.isPlaying && audioViewmodel.currentIndex == index
                      ? audioViewmodel.pause()
                      : audioViewmodel.play(index),
                      icon: Icon(audioViewmodel.isPlaying && audioViewmodel.currentIndex == index ? Icons.pause : Icons.play_arrow)),
                    SizedBox(width: 10,),
                    StreamBuilder<Duration?>(
                      stream: audioViewmodel.player.durationStream,
                      builder: (context, snapshot) {
                        final duration = snapshot.data ?? Duration.zero;
                        return StreamBuilder<Duration>(
                          stream: audioViewmodel.player.positionStream,
                          builder: (context, snapshot) {
                            final position = snapshot.data ?? Duration.zero;
                            return Text("${position.inMinutes} / ${duration.inMinutes}m");
                          },
                        );
                      },
                    ),
                    SizedBox(height: 20,)
                  ],
                ),
              ],
            );
          },
        )
      ),
      bottomSheet: Container(
        width: 500,
        height: 80,
        child: StreamBuilder<Duration?>(
          stream: audioViewmodel.player.durationStream,
          builder: (context, snapshot) {
            final duration = snapshot.data ?? Duration.zero;
            return StreamBuilder<Duration>(
              stream: audioViewmodel.player.positionStream,
              builder: (context, snapshot) {
                final position = snapshot.data ?? Duration.zero;
                return Slider(
                  min: 0,
                  max: duration.inMilliseconds.toDouble(),
                  value: position.inMilliseconds.clamp(0, duration.inMilliseconds).toDouble(),
                  onChanged: (value) {
                    audioViewmodel.player.seek(Duration(milliseconds: value.toInt()));
                  },
                );
              },
            );
          },
        ),
      )
    );
  }
}