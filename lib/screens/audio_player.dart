import 'package:audio_video_progress_bar/audio_video_progress_bar.dart';
import 'package:bookvachak/modals/audio_track_modal.dart';
import 'package:bookvachak/modals/books_modal.dart';
import 'package:bookvachak/notifiers/play_button_notifier.dart';
import 'package:bookvachak/notifiers/progress_notifier.dart';
import 'package:bookvachak/notifiers/repeat_button_notifier.dart';
import 'package:bookvachak/services/service_locator.dart';
import 'package:bookvachak/widgets/Player/page_manager.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:skeletons/skeletons.dart';

class AudioPlayerScreen extends StatefulWidget {
  final List<AudioTracks> audioTracks;
  final BooksModal book;
  final int index;
  const AudioPlayerScreen(
      {super.key,
      required this.audioTracks,
      required this.book,
      required this.index});

  @override
  State<AudioPlayerScreen> createState() => _AudioPlayerScreenState();
}

late PageManager _pageManager;

class _AudioPlayerScreenState extends State<AudioPlayerScreen> {
  @override
  void initState() {
    super.initState();
    _pageManager = getIt<PageManager>();
    _pageManager.setValues(widget.audioTracks, widget.book.coverMediaUrl!,
        widget.book.title!, widget.book, widget.index);
    _pageManager.init(widget.index, widget.book.title!);
  }

  @override
  void dispose() {
    _pageManager.dispose();
    super.dispose();
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
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Card(
                    elevation: 4.0,
                    surfaceTintColor: Colors.white,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(10.0),
                      child: CachedNetworkImage(
                        imageUrl: widget.book.coverMediaUrl as String,
                        placeholder: (context, url) {
                          return const SkeletonAvatar(
                            style: SkeletonAvatarStyle(
                                width: 200.0, height: 200.0),
                          );
                        },
                        height: 300.0,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const CurrentSongTitle(),
            const SizedBox(height: 10.0),
            const AudioProgressBar(),
            const AudioControlButtons(),
            const SizedBox(
              height: 45.0,
            )
          ],
        ),
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
        return Padding(
          padding: const EdgeInsets.only(top: 10.0),
          child: Text(
            title,
            textAlign: TextAlign.left,
            style: const TextStyle(fontSize: 24),
          ),
        );
      },
    );
  }
}

class Playlist extends StatelessWidget {
  final PageManager? pageManager;
  const Playlist({super.key, required this.pageManager});
  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: ValueListenableBuilder<List<String>>(
        valueListenable: pageManager!.playlistNotifier,
        builder: (context, playlistTitles, _) {
          return ListView.builder(
            itemCount: playlistTitles.length,
            itemBuilder: (context, index) {
              return ListTile(
                title: Text(playlistTitles[index]),
              );
            },
          );
        },
      ),
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
          progress: value.current,
          buffered: value.buffered,
          total: value.total,
          onSeek: _pageManager.seek,
          progressBarColor: Colors.orange,
          baseBarColor: Colors.orange[100],
          bufferedBarColor: Colors.orange[200],
          thumbColor: Colors.orange,
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
      height: 60,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          // RepeatButton(),
          PreviousSongButton(),
          PlayButton(),
          NextSongButton(),
          // ShuffleButton(),
        ],
      ),
    );
  }
}

class RepeatButton extends StatelessWidget {
  const RepeatButton({super.key});
  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<RepeatState>(
      valueListenable: _pageManager.repeatButtonNotifier,
      builder: (context, value, child) {
        Icon icon;
        switch (value) {
          case RepeatState.off:
            icon = const Icon(Icons.repeat, color: Colors.grey);
            break;
          case RepeatState.repeatSong:
            icon = const Icon(Icons.repeat_one);
            break;
          case RepeatState.repeatPlaylist:
            icon = const Icon(Icons.repeat);
            break;
        }
        return IconButton(
          icon: icon,
          onPressed: _pageManager.repeat,
        );
      },
    );
  }
}

class PreviousSongButton extends StatelessWidget {
  const PreviousSongButton({super.key});
  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<bool>(
      valueListenable: _pageManager.isFirstSongNotifier,
      builder: (_, isFirst, __) {
        return IconButton(
          icon: const Icon(
            Icons.skip_previous,
            size: 32.0,
          ),
          onPressed: (isFirst) ? null : _pageManager.previous,
        );
      },
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
            return FloatingActionButton.large(
              backgroundColor: Colors.orangeAccent,
              onPressed: _pageManager.play,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(100),
              ),
              child: const Icon(
                Icons.play_arrow,
                size: 32.0,
              ),
            );
          case ButtonState.playing:
            return FloatingActionButton.large(
              backgroundColor: Colors.orangeAccent,
              onPressed: _pageManager.pause,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(100),
              ),
              child: const Icon(Icons.pause, size: 32.0),
            );
        }
      },
    );
  }
}

class NextSongButton extends StatelessWidget {
  const NextSongButton({super.key});
  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<bool>(
      valueListenable: _pageManager.isLastSongNotifier,
      builder: (_, isLast, __) {
        return IconButton(
          icon: const Icon(
            Icons.skip_next,
            size: 32.0,
          ),
          onPressed: (isLast) ? null : _pageManager.next,
        );
      },
    );
  }
}

class ShuffleButton extends StatelessWidget {
  const ShuffleButton({super.key});
  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<bool>(
      valueListenable: _pageManager.isShuffleModeEnabledNotifier,
      builder: (context, isEnabled, child) {
        return IconButton(
          icon: (isEnabled)
              ? const Icon(
                  Icons.shuffle,
                  color: Colors.green,
                )
              : const Icon(Icons.shuffle, color: Colors.grey),
          onPressed: _pageManager.shuffle,
        );
      },
    );
  }
}
