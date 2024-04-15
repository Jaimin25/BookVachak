import 'dart:developer';

import 'package:audio_video_progress_bar/audio_video_progress_bar.dart';
import 'package:bookvachak/helpers/librivox_books_provider.dart';
import 'package:bookvachak/modals/audio_track_modal.dart';
import 'package:bookvachak/modals/books_modal.dart';
import 'package:bookvachak/notifiers/play_button_notifier.dart';
import 'package:bookvachak/notifiers/progress_notifier.dart';
import 'package:bookvachak/screens/audio_player.dart';
import 'package:bookvachak/services/service_locator.dart';
import 'package:bookvachak/widgets/AudioTracks/audio_tracks_list.dart';
import 'package:bookvachak/widgets/Player/page_manager.dart';
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

late PageManager _pageManager;

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
    _pageManager = getIt<PageManager>();

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
      bottomNavigationBar: ValueListenableBuilder<bool>(
        valueListenable: _pageManager.isPlayerPlaying,
        builder: (context, value, child) {
          log(value.toString());
          return value
              ? GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => AudioPlayerScreen(
                            audioTracks: _pageManager.audioTracks!,
                            book: _pageManager.book!,
                            index: _pageManager.index!),
                      ),
                    );
                  },
                  child: Column(mainAxisSize: MainAxisSize.min, children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(10.0),
                          child: CachedNetworkImage(
                            imageUrl:
                                _pageManager.book!.coverMediaUrl as String,
                            placeholder: (context, url) {
                              return const SkeletonAvatar(
                                style: SkeletonAvatarStyle(
                                    width: 20.0, height: 20.0),
                              );
                            },
                            height: 45.0,
                          ),
                        ),
                        const SizedBox(
                          width: 10.0,
                        ),
                        const Expanded(child: CurrentSongTitle()),
                        const AudioControlButtons(),
                      ],
                    ),
                    const Padding(
                      padding: EdgeInsets.symmetric(vertical: 8.0),
                      child: Column(
                        children: [
                          AudioProgressBar(),
                        ],
                      ),
                    ),
                  ]),
                )
              : const Text('');
        },
      ),
    );
  }
}

class CurrentSongTitle extends StatelessWidget {
  const CurrentSongTitle({super.key});
  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<String>(
      valueListenable: _pageManager.currentSongTitleNotifier,
      builder: (_, title, __) {
        return Text(
          title,
          textAlign: TextAlign.left,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(fontSize: 22),
        );
      },
    );
  }
}

class AudioProgressBar extends StatelessWidget {
  const AudioProgressBar({super.key});
  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<ProgressBarState>(
      valueListenable: _pageManager.progressNotifier,
      builder: (_, value, __) {
        return ProgressBar(
          thumbRadius: 0,
          thumbGlowRadius: 0,
          progress: value.current,
          buffered: value.buffered,
          total: value.total,
          onSeek: _pageManager.seek,
          progressBarColor: Colors.orange,
          baseBarColor: Colors.orange[100],
          bufferedBarColor: Colors.orange[200],
          timeLabelTextStyle: const TextStyle(
            fontSize: 0,
          ),
        );
      },
    );
  }
}

class AudioControlButtons extends StatelessWidget {
  const AudioControlButtons({super.key});
  @override
  Widget build(BuildContext context) {
    return const SizedBox(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          // RepeatButton(),
          // PreviousSongButton(),
          PlayButton(),
          // NextSongButton(),
          // ShuffleButton(),
        ],
      ),
    );
  }
}

class PlayButton extends StatelessWidget {
  const PlayButton({super.key});
  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<ButtonState>(
      valueListenable: _pageManager.playButtonNotifier,
      builder: (_, value, __) {
        switch (value) {
          case ButtonState.loading:
            return Container(
              margin: const EdgeInsets.all(8.0),
              width: 32.0,
              height: 32.0,
              child: const CircularProgressIndicator(
                color: Colors.orange,
              ),
            );
          case ButtonState.paused:
            return IconButton(
              // backgroundColor: Colors.orangeAccent,
              onPressed: _pageManager.play,
              // shape: RoundedRectangleBorder(
              //   borderRadius: BorderRadius.circular(100),
              // ),
              icon: const Icon(
                Icons.play_arrow,
                size: 32.0,
              ),
            );
          case ButtonState.playing:
            return IconButton(
              // backgroundColor: Colors.orangeAccent,
              onPressed: _pageManager.pause,
              // shape: RoundedRectangleBorder(
              //   borderRadius: BorderRadius.circular(100),
              // ),
              icon: const Icon(Icons.pause, size: 32.0),
            );
        }
      },
    );
  }
}
