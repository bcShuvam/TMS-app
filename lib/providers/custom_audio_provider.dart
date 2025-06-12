import 'dart:io';

import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:path_provider/path_provider.dart';
import 'package:record/record.dart';
import 'package:path/path.dart' as p;

class CustomAudioProvider extends ChangeNotifier {
  final AudioRecorder audioRecorder = AudioRecorder();
  final AudioPlayer audioPlayer = AudioPlayer();
  String? recordingPath;
  bool isRecording = false, isPlaying = false;

  void recordAudio() async {
    if (isRecording) {
      String? filePath = await audioRecorder.stop();
      if(filePath != null){
        isRecording = false;
        recordingPath = filePath;
      }
    } else {
      if (await audioRecorder.hasPermission()) {
        final Directory appDocumentDir =
            await getApplicationDocumentsDirectory();
        final String filePath = p.join(appDocumentDir.path, 'recording.wav');
        await audioRecorder.start(const RecordConfig(), path: filePath);
        isRecording = true;
        recordingPath = null;
      }
    }
    notifyListeners();
  }

  void playStopAudioRecording() async {
    if(audioPlayer.playing){
      audioPlayer.stop();
      isPlaying = false;
    }else{
      await audioPlayer.setFilePath(recordingPath!);
      audioPlayer.play();
      isPlaying = true;
    }
  }
}
