import 'package:bookvachak/helpers/librivox_books_provider.dart';
import 'package:flutter/material.dart';

class BookAudioTracks extends StatefulWidget {
  final String? projectId;
  const BookAudioTracks({super.key, this.projectId});

  @override
  State<BookAudioTracks> createState() => _BookAudioTracksState();
}

class _BookAudioTracksState extends State<BookAudioTracks> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  Future<void> fetchAudio() async {
    LibrivoxBooksProvider lbp = LibrivoxBooksProvider();
    await lbp.fetchAudioTracks(widget.projectId!);
  }

  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}
