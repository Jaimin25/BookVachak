import 'dart:convert';
import 'dart:math';
import 'package:bookvachak/modals/books_modal.dart';
import 'package:http/http.dart' as http;

class LibrovoxBooksProvider {
  final lbvxAudioBooksUrl =
      "https://librivox.org/api/feed/audiobooks/?format=json&limit=25&fields={id,title,description,language,num_sections,authors,url_rss,totaltimesecs}&offset=";
  final lbvxAudioTracksUrl = "https://librivox.org/api/feed/audiotracks/";
  late String offset;

  LibrovoxBooksProvider() {
    Random rnd = Random();

    offset = (rnd.nextInt(50) + 75).toString();
  }

  Future<List<Future<BooksModal>>> fetchBooks() async {
    try {
      http.Response response =
          await http.get(Uri.parse(lbvxAudioBooksUrl + offset));

      if (response.statusCode == 200) {
        List<dynamic> books =
            jsonDecode(response.body)['books'] as List<dynamic>;
        List<Future<BooksModal>> bookList = books
            .where((item) => item['language'] == 'English')
            .map((item) async => BooksModal.fromJson(item))
            .take(8)
            .toList();

        return bookList;
      }
    } catch (e) {
      print(e);
    }
    return [];
  }
}
