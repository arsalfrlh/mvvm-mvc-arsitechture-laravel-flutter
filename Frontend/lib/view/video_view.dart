import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:toko/viewmodels/video_viewmodel.dart';
import 'package:video_player/video_player.dart';

class VideoView extends StatefulWidget {
  const VideoView({super.key});

  @override
  State<VideoView> createState() => _VideoViewState();
}

class _VideoViewState extends State<VideoView> {
  @override
  Widget build(BuildContext context) {
    final videoViewmodel = Provider.of<VideoViewmodel>(context);
    return Scaffold(
      appBar: AppBar(title: Text("Video Player"), backgroundColor: Colors.blue,),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Expanded(
              child: ListView.builder(
                itemCount: videoViewmodel.videoList.length,
                itemBuilder: (context, index) {
                  return Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text("Judul: ${videoViewmodel.videoList[index].title}"),
                      SizedBox(height: 5,),
                      IconButton(
                        onPressed: videoViewmodel.currentIndex != index
                          ? () => videoViewmodel.initialize(index)
                          : () => videoViewmodel.closeVideo(),
                        icon: Icon(videoViewmodel.currentIndex != index ? Icons.play_arrow : Icons.pause))
                    ],
                  );
                },
              ),
            ),
            SizedBox(height: 20,),
            if(videoViewmodel.isInitialize && videoViewmodel.videoPlayerController != null && videoViewmodel.currentIndex != null)...[
              AspectRatio(
                aspectRatio: videoViewmodel.videoPlayerController!.value.aspectRatio,
                child: VideoPlayer(videoViewmodel.videoPlayerController!),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  IconButton(
                    onPressed: () => videoViewmodel.isPlaying
                      ? videoViewmodel.pause()
                      : videoViewmodel.play(),
                    icon: Icon(videoViewmodel.isPlaying ? Icons.pause : Icons.play_arrow)),
                    SizedBox(width: 10,),
                    Text("${videoViewmodel.position.inSeconds} / ${videoViewmodel.duration.inSeconds} s")
                ],
              ),
              SizedBox(height: 15,),
              Slider(
                min: 0,
                max: videoViewmodel.duration.inMilliseconds.toDouble(),
                value: videoViewmodel.position.inMilliseconds.clamp(0, videoViewmodel.duration.inMilliseconds).toDouble(),
                onChanged: (value) {
                  videoViewmodel.seek(Duration(milliseconds: value.toInt()));
                },
              )
            ]
          ],
        ),
      ),
    );
  }
}