import 'package:bookvachak/modals/author_modal.dart';

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

  factory BooksModal.fromJson(dynamic json) {
    return BooksModal(
      id: json['id'],
      title: json['title'],
      description: json['description'],
      coverMediaUrl: json['coverMediaUrl'],
      totalEp: json['num_sections'],
      authors: AuthorModal.fromMap(json['authors'][0] as Map<String, dynamic>),
      urlRss: json['url_rss'],
      totaltimesecs: json['totaltimesecs'],
    );
  }
}
