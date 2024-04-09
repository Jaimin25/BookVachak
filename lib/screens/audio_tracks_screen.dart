import 'package:bookvachak/helpers/librivox_books_provider.dart';
import 'package:flutter/material.dart';

class AudioTracksScreen extends StatefulWidget {
  final String? projectId;
  const AudioTracksScreen({super.key, this.projectId});

  @override
  State<AudioTracksScreen> createState() => _AudioTracksScreenState();
}

class _AudioTracksScreenState extends State<AudioTracksScreen> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    fetchAudio();
  }

  Future<void> fetchAudio() async {
    LibrivoxBooksProvider lbp = LibrivoxBooksProvider();
    await lbp.fetchAudioTracks(widget.projectId!);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "BookVachak",
          style: TextStyle(
            fontSize: 24.0,
          ),
        ),
        backgroundColor: Colors.orange,
        foregroundColor: Colors.white,
        shadowColor: Colors.grey,
        elevation: 1.0,
      ),
      body: const Text('hello'),
    );
  }
}
