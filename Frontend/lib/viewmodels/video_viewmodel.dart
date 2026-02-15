import 'package:flutter/material.dart';
import 'package:toko/models/video.dart';
import 'package:video_player/video_player.dart';

//service khusus untuk API, Background Task, dll| viewmodel khusus untuk player| contorller, dll
class VideoViewmodel extends ChangeNotifier {
  VideoPlayerController? _videoPlayerController;
  bool isInitialize = false;
  bool isPlaying = false;
  Duration position = Duration.zero;
  Duration duration = Duration.zero;
  int? currentIndex;
  List<Video> videoList = [
    Video(title: "Butterfly", url: "https://flutter.github.io/assets-for-api-docs/assets/videos/butterfly.mp4"),
    Video(title: "Bee", url: "https://flutter.github.io/assets-for-api-docs/assets/videos/bee.mp4")
  ];

  VideoPlayerController? get videoPlayerController => _videoPlayerController;

  Future<void> initialize(int index)async{
    _videoPlayerController?.removeListener(listenerVideo);
    _videoPlayerController?.dispose();
    
    isInitialize = false;
    position = Duration.zero;
    duration = Duration.zero;
    isPlaying = false;
    currentIndex = index;
    notifyListeners(); //seperti setstate| ubah dan beritahu UI init, pos, dur, play, dan curI

    _videoPlayerController = VideoPlayerController.networkUrl(Uri.parse(videoList[index].url));
    await _videoPlayerController?.initialize();
    _videoPlayerController?.play();
    isInitialize = _videoPlayerController?.value.isInitialized ?? false;
    position = _videoPlayerController?.value.position ?? Duration.zero;
    duration = _videoPlayerController?.value.duration ?? Duration.zero;
    isPlaying = _videoPlayerController?.value.isPlaying ?? false;
    _videoPlayerController?.addListener(listenerVideo);
    notifyListeners();
  }

  void closeVideo(){
    _videoPlayerController?.removeListener(listenerVideo);
    _videoPlayerController?.dispose();
    isInitialize = false;
    position = Duration.zero;
    duration = Duration.zero;
    isPlaying = false;
    currentIndex = null;
    notifyListeners();
  }

  void listenerVideo(){
    isPlaying = _videoPlayerController?.value.isPlaying ?? false;
    position = _videoPlayerController?.value.position ?? Duration.zero;
    duration = _videoPlayerController?.value.duration ?? Duration.zero;
    notifyListeners();
  }

  void play() => _videoPlayerController?.play();
  void pause() => _videoPlayerController?.pause();
  void seek(Duration value) => _videoPlayerController?.seekTo(value);

  @override
  void dispose() {
    super.dispose();
    _videoPlayerController?.removeListener(listenerVideo);
    _videoPlayerController?.dispose();
  }
}