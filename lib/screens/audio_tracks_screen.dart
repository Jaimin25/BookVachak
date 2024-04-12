import 'package:bookvachak/helpers/librivox_books_provider.dart';
import 'package:bookvachak/modals/audio_track_modal.dart';
import 'package:bookvachak/modals/books_modal.dart';
import 'package:bookvachak/widgets/AudioTracks/audio_tracks_list.dart';
import 'package:bookvachak/widgets/Skeletons/audio_track_skeleton.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:skeletons/skeletons.dart';

class AudioTracksScreen extends StatefulWidget {
  final BooksModal? book;
  const AudioTracksScreen({super.key, this.book});

  @override
  State<AudioTracksScreen> createState() => _AudioTracksScreenState();
}

class _AudioTracksScreenState extends State<AudioTracksScreen> {
  List<AudioTracks>? _audioTracks;
  bool _isFetching = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    fetchAudio();
  }

  Future<void> fetchAudio() async {
    setState(() {
      _isFetching = true;
    });
    LibrivoxBooksProvider lbp = LibrivoxBooksProvider();
    List<AudioTracks> atList = await lbp.fetchAudioTracks(widget.book!.id!);

    setState(() {
      _audioTracks = atList;
      _isFetching = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.book!.title as String,
          style: const TextStyle(
            fontSize: 24.0,
          ),
        ),
        backgroundColor: Colors.orange,
        foregroundColor: Colors.white,
        shadowColor: Colors.grey,
        elevation: 1.0,
      ),
      body: Container(
        color: Colors.white,
        padding: const EdgeInsets.all(12.0),
        child: Column(
          children: [
            Card(
              elevation: 4.0,
              surfaceTintColor: Colors.white,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(10.0),
                child: CachedNetworkImage(
                  imageUrl: widget.book!.coverMediaUrl as String,
                  placeholder: (context, url) {
                    return const SkeletonAvatar(
                      style: SkeletonAvatarStyle(width: 200.0, height: 200.0),
                    );
                  },
                  height: 200.0,
                ),
              ),
            ),
            Html(
              data: widget.book!.description!
                  .substring(0, widget.book!.description!.indexOf(".")),
            ),
            const Divider(
              height: 4.0,
            ),
            _isFetching
                ? const Expanded(child: AudioTrackSkeleton())
                : Expanded(
                    child: AudioTracksList(
                      audioTracks: _audioTracks,
                      book: widget.book!,
                    ),
                  ),
          ],
        ),
      ),
    );
  }
}
