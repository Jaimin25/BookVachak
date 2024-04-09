class AudioTracks {
  String? id;
  String? sectionNumber;
  String? title;
  String? trackUrl;
  String? playtime;

  AudioTracks(
      {this.id, this.sectionNumber, this.title, this.trackUrl, this.playtime});

  factory AudioTracks.fromJSON(Map<String, dynamic> data) {
    return AudioTracks(
      id: data['id'],
      sectionNumber: data['section_number'],
      title: data['title'],
      trackUrl: data['listen_url'],
      playtime: data['playtime'],
    );
  }
}
