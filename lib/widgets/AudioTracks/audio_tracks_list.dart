import 'package:bookvachak/modals/audio_track_modal.dart';
import 'package:bookvachak/modals/books_modal.dart';
import 'package:bookvachak/screens/audio_player.dart';
import 'package:flutter/material.dart';

class AudioTracksList extends StatefulWidget {
  const AudioTracksList({
    super.key,
    required List<AudioTracks>? audioTracks,
    required book,
  })  : _audioTracks = audioTracks,
        _book = book;

  final List<AudioTracks>? _audioTracks;
  final BooksModal _book;

  @override
  State<AudioTracksList> createState() => _AudioTracksListState();
}

class _AudioTracksListState extends State<AudioTracksList> {
  String formatTime(int seconds) {
    final minutes = seconds ~/ 60;
    final remainingSeconds = seconds - minutes * 60;
    return '${minutes.toString().padLeft(2, '0')}:${remainingSeconds.toString().padLeft(2, '0')}';
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: widget._audioTracks!.length,
      itemBuilder: (cotext, index) {
        return ListTile(
          onTap: () {},
          title: Text(widget._audioTracks![index].title!),
          subtitle: Text(
            formatTime(
              int.parse(widget._audioTracks![index].playtime!),
            ),
          ),
          trailing: IconButton(
            icon: const Icon(Icons.play_arrow),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => AudioPlayerScreen(
                      audioTracks: widget._audioTracks!, book: widget._book),
                ),
              );
            },
          ),
        );
      },
    );
  }
}
