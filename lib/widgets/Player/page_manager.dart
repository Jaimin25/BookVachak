import 'package:audio_service/audio_service.dart';
import 'package:bookvachak/modals/audio_track_modal.dart';
import 'package:bookvachak/modals/books_modal.dart';
import 'package:bookvachak/notifiers/play_button_notifier.dart';
import 'package:bookvachak/notifiers/progress_notifier.dart';
import 'package:bookvachak/notifiers/repeat_button_notifier.dart';
import 'package:bookvachak/services/audio_handler.dart';
import 'package:flutter/foundation.dart';
import 'package:just_audio/just_audio.dart';

class PageManager {
  // Listeners: Updates going to the UI
  List<AudioTracks>? audioTracks;
  String? trackTitle;
  String? artUri;
  String? artTitle;
  bool isPlaying = false;
  BooksModal? book;
  int? index;
  int? tempIndex;
  String? tempTitle;
  final currentSongTitleNotifier = ValueNotifier<String>('');
  final playlistNotifier = ValueNotifier<List<String>>([]);
  final progressNotifier = ProgressNotifier();
  final repeatButtonNotifier = RepeatButtonNotifier();
  final isFirstSongNotifier = ValueNotifier<bool>(true);
  final playButtonNotifier = PlayButtonNotifier();
  final isLastSongNotifier = ValueNotifier<bool>(true);
  final isShuffleModeEnabledNotifier = ValueNotifier<bool>(false);
  final isPlayerPlaying = ValueNotifier<bool>(false);

  late MyAudioHandler adh;

  late MyAudioHandler _audioHandler;

  PageManager({
    required this.adh,
  });

  void init(int indexx, String bookTitle) async {
    await _loadPlaylist(indexx, bookTitle);
    _listenToChangesInPlaylist();
    _listenToPlaybackState();
    _listenToCurrentPosition();
    _listenToBufferedPosition();
    _listenToTotalDuration();
    _listenToChangesInSong();
  }

  Future<void> _loadPlaylist(int indexx, String bookTitle) async {
    final mediaItems = audioTracks!
        .map(
          (item) => MediaItem(
            id: item.id ?? '',
            album: artTitle ?? '',
            title: item.title ?? '',
            artUri: Uri.parse(artUri ?? ''),
            extras: {'url': item.trackUrl},
          ),
        )
        .toList();
    _audioHandler.addQueueItems(mediaItems);

    if (tempTitle != bookTitle || indexx != tempIndex) {
      await _audioHandler.getPlayer().seek(Duration.zero, index: indexx);
      _audioHandler.getPlayer().play();
    }
    isPlayerPlaying.value = true;
  }

  void setValues(List<AudioTracks> tracks, String uri, String bookTitle,
      BooksModal bookk, int indexx) {
    if (artTitle == null ||
        bookTitle.toLowerCase() != artTitle?.toLowerCase()) {
      _audioHandler = adh;
      while (_audioHandler.queue.value.isNotEmpty) {
        _audioHandler.queue.value.removeLast();
      }
      _audioHandler.getPlayer().setAudioSource(
            ConcatenatingAudioSource(children: []),
          );
      final audioSources = tracks
          .map(
            (item) => ClippingAudioSource(
              child: AudioSource.uri(
                Uri.parse(
                  item.trackUrl.toString(),
                ),
                tag: MediaItem(
                  id: item.id ?? '',
                  album: artTitle ?? '',
                  title: item.title ?? '',
                  artUri: Uri.parse(artUri ?? ''),
                  extras: {'url': item.trackUrl},
                ),
              ),
            ),
          )
          .toList();
      _audioHandler.getPlayer().setAudioSource(
            ConcatenatingAudioSource(children: audioSources),
          );
    }
    tempIndex = index;
    tempTitle = artTitle;
    audioTracks = tracks;
    artTitle = bookTitle;
    artUri = uri;
    book = bookk;
    index = indexx;
    trackTitle = tracks[indexx].title;
  }

  MyAudioHandler getAudioHandler() {
    return _audioHandler;
  }

  void _listenToChangesInPlaylist() {
    _audioHandler.queue.listen((playlist) {
      if (playlist.isEmpty) {
        currentSongTitleNotifier.value = '';
        playlistNotifier.value = [];
      } else {
        final newList = audioTracks!.map((item) => item.title!).toList();
        playlistNotifier.value = newList;
      }
      _updateSkipButtons();
    });
  }

  void _listenToPlaybackState() {
    _audioHandler.playbackState.listen((playbackState) {
      final isPlaying = playbackState.playing;
      final processingState = playbackState.processingState;
      if (processingState == AudioProcessingState.loading ||
          processingState == AudioProcessingState.buffering) {
        playButtonNotifier.value = ButtonState.loading;
      } else if (!isPlaying) {
        playButtonNotifier.value = ButtonState.paused;
      } else if (processingState != AudioProcessingState.completed) {
        playButtonNotifier.value = ButtonState.playing;
      } else {
        _audioHandler.seek(Duration.zero);
        _audioHandler.pause();
      }
    });
  }

  void _listenToCurrentPosition() {
    AudioService.position.listen((position) {
      final oldState = progressNotifier.value;
      progressNotifier.value = ProgressBarState(
        current: position,
        buffered: oldState.buffered,
        total: oldState.total,
      );
    });
  }

  void _listenToBufferedPosition() {
    _audioHandler.playbackState.listen((playbackState) {
      final oldState = progressNotifier.value;
      progressNotifier.value = ProgressBarState(
        current: oldState.current,
        buffered: playbackState.bufferedPosition,
        total: oldState.total,
      );
    });
  }

  void _listenToTotalDuration() {
    _audioHandler.mediaItem.listen((mediaItem) {
      final oldState = progressNotifier.value;
      progressNotifier.value = ProgressBarState(
        current: oldState.current,
        buffered: oldState.buffered,
        total: mediaItem?.duration ?? Duration.zero,
      );
    });
  }

  void _listenToChangesInSong() {
    _audioHandler.mediaItem.listen((mediaItem) {
      currentSongTitleNotifier.value = mediaItem?.title ?? '';
      _updateSkipButtons();
    });
  }

  void _updateSkipButtons() {
    final mediaItem = _audioHandler.mediaItem.value;
    final playlist = _audioHandler.queue.value;
    if (playlist.length < 2 || mediaItem == null) {
      isFirstSongNotifier.value = true;
      isLastSongNotifier.value = true;
    } else {
      isFirstSongNotifier.value = playlist.first == mediaItem;
      isLastSongNotifier.value = playlist.last == mediaItem;
    }
  }

  void play() => _audioHandler.play();
  void pause() => _audioHandler.pause();

  void seek(Duration position) => _audioHandler.seek(position);

  void previous() => _audioHandler.skipToPrevious();
  void next() => _audioHandler.skipToNext();

  void repeat() {
    repeatButtonNotifier.nextState();
    final repeatMode = repeatButtonNotifier.value;
    switch (repeatMode) {
      case RepeatState.off:
        _audioHandler.setRepeatMode(AudioServiceRepeatMode.none);
        break;
      case RepeatState.repeatSong:
        _audioHandler.setRepeatMode(AudioServiceRepeatMode.one);
        break;
      case RepeatState.repeatPlaylist:
        _audioHandler.setRepeatMode(AudioServiceRepeatMode.all);
        break;
    }
  }

  void shuffle() {
    final enable = !isShuffleModeEnabledNotifier.value;
    isShuffleModeEnabledNotifier.value = enable;
    if (enable) {
      _audioHandler.setShuffleMode(AudioServiceShuffleMode.all);
    } else {
      _audioHandler.setShuffleMode(AudioServiceShuffleMode.none);
    }
  }

  @override
  void dispose() {
    // _audioHandler.customAction('dispose');
  }

  void stop() {
    _audioHandler.stop();
  }
}
