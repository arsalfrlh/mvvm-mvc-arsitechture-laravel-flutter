import 'package:just_audio/just_audio.dart';

class AudioService {
  // _ itu artinya variabel private class di dart
  final _player = AudioPlayer();
  
  AudioPlayer get player => _player; //pakai get di function agar AudioPlayer bisa di akses readOnly di AudioViewmodel
  // get = cara membuka akses ke private variable
  // _player = melindungi dari akses langsung

  Future<void> setUrl(String url) async{
    await _player.setUrl(url);
  }

  void play() => _player.play();
  void pause() => _player.pause();
  void stop() => _player.stop();

  void seek(Duration value) => _player.seek(value);
}