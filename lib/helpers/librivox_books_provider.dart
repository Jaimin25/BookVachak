import 'dart:convert';
import 'dart:math';
import 'package:bookvachak/modals/audio_track_modal.dart';
import 'package:bookvachak/modals/books_modal.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;

class LibrivoxBooksProvider {
  final lbvxAudioBooksUrl =
      "https://librivox.org/api/feed/audiobooks/?format=json&limit=25&fields={id,title,description,language,num_sections,authors,url_rss,totaltimesecs}&offset=";
  final lbvxAudioTracksUrl =
      "https://librivox.org/api/feed/audiotracks?format=json&project_id=";
  late String offset;

  LibrivoxBooksProvider() {
    Random rnd = Random();

    offset = (rnd.nextInt(50) + 75).toString();
  }

  Future<List<BooksModal>> fetchBooks() async {
    try {
      List urls = await loadCoverUrls();
      http.Response response =
          await http.get(Uri.parse(lbvxAudioBooksUrl + offset));

      if (response.statusCode == 200) {
        List<dynamic> books =
            jsonDecode(response.body)['books'] as List<dynamic>;
        List<BooksModal> bookList = books
            .where((item) => item['language'] == 'English')
            .map((item) {
              var coverUrl = urls.firstWhere(
                (url) => url['id'] == item['id'],
                orElse: () => null,
              );

              if (coverUrl != null) {
                item['coverMediaUrl'] =
                    "https://archive.org/download${coverUrl['cover_media_url']}";
              }

              return BooksModal.fromJson(
                item,
              );
            })
            .take(8)
            .toList();

        return bookList;
      }
    } catch (e) {
      print(e);
    }
    return [];
  }

  Future<List<AudioTracks>> fetchAudioTracks(String projectId) async {
    try {
      http.Response response =
          await http.get(Uri.parse(lbvxAudioTracksUrl + projectId));
      if (response.statusCode == 200) {
        List<dynamic> sections =
            jsonDecode(response.body)['sections'] as List<dynamic>;
        List<AudioTracks> audioTrackList =
            sections.map((item) => AudioTracks.fromJSON(item)).toList();

        return audioTrackList;
      }
    } catch (e) {
      print(e.toString());
    }
    return [];
  }
}

Future<List<dynamic>> loadCoverUrls() async {
  try {
    String txt =
        await rootBundle.loadString('assets/audio_book_cover_urls.json');

    final data = await jsonDecode(txt);
    List urls = data['url'];

    return urls;
  } catch (e) {
    print(e);
    return [];
  }
}
