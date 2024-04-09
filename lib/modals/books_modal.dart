import 'package:bookvachak/services/rss_feed_parser.dart';

class AuthorModal {
  String? id;
  String? firstName;
  String? lastName;

  AuthorModal({this.id, this.firstName, this.lastName});

  factory AuthorModal.fromMap(Map<String, dynamic> authors) {
    return AuthorModal(
      id: authors['id'],
      firstName: authors['first_name'],
      lastName: authors['last_name'],
    );
  }
}

class BooksModal {
  late String? id;
  late String? title;
  late String? description;
  late String? coverMediaUrl;
  late String? totalEp;
  late String? urlRss;
  late AuthorModal? authors;
  late int? totaltimesecs;

  BooksModal({
    this.id,
    this.title,
    this.description,
    this.coverMediaUrl,
    this.totalEp,
    this.urlRss,
    this.authors,
    this.totaltimesecs,
  });

  static Future<BooksModal> fromJson(dynamic json) async {
    final rssFeedParser = RssFeedParser();
    final coverUrl = await rssFeedParser.fetchImageUrl(json['url_rss']);
    return BooksModal(
      id: json['id'],
      title: json['title'],
      description: json['description'],
      coverMediaUrl: coverUrl,
      totalEp: json['num_sections'],
      authors: AuthorModal.fromMap(json['authors'][0] as Map<String, dynamic>),
      urlRss: json['url_rss'],
      totaltimesecs: json['totaltimesecs'],
    );
  }
}
