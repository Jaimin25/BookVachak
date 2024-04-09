import 'package:dart_rss/domain/rss_itunes_image.dart';
import 'package:http/http.dart' as http;
import 'package:dart_rss/dart_rss.dart';

class RssFeedParser {
  Future<String> fetchImageUrl(url) async {
    final client = http.Client();

    // RSS feed
    RssItunesImage img = await client.get(Uri.parse(url)).then((response) {
      return response.body;
    }).then((bodyString) {
      final channel = RssFeed.parse(bodyString);
      return channel.itunes?.image as RssItunesImage;
    });
    client.close();
    return img.href as String;
  }
}
