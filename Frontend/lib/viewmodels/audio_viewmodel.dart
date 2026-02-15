import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:toko/models/song.dart';
import 'package:toko/services/audio_service.dart';

//service khusus untuk API, Background Task, dll| viewmodel khusus untuk player| contorller, dll
//contoh player just_audio dan audio_service, cocok di simpan diservice| jika hanya player saja simpan di viewmodel
class AudioViewmodel extends ChangeNotifier {
  final AudioService _audioService = AudioService();
  bool isPlaying = false;
  bool isComplete = false;
  int? currentIndex;
  List<Song> songList = [
    Song(title: "Linked", url: "http://192.168.0.100:8000/storage/song/linked.mp3"),
    Song(title: "Cyberfunk", url: "http://192.168.0.100:8000/storage/song/cyber.mp3"),
  ];

  AudioViewmodel(){
    _audioService.player.playerStateStream.listen((p){
      isPlaying = p.playing;
      notifyListeners();
    });
    _audioService.player.processingStateStream.listen((ps){
      isComplete = ps == ProcessingState.completed;
      if(currentIndex != null && isComplete && songList.length >= currentIndex!){
        play(currentIndex! + 1);
      }
      notifyListeners();
    });
  }

  AudioPlayer get player => _audioService.player; //function untuk return AudioPlayer dan read only di AdioView
  // AudioPlayer get player {
  //   return audioService.player;
  // } 

  Future<void> play(int index)async{
    if(currentIndex != index){
      currentIndex = index;
      await _audioService.setUrl(songList[index].url);
    }
    _audioService.play();
  }
  
  void pause() => _audioService.pause();

  @override
  void dispose() {
    super.dispose();
    _audioService.player.dispose();
  }
}