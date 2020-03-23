/// model class of album for parse json response to pojo class

class Album {
  String artistName;
  String id;
  String releaseDate;
  String name;
  String kind;
  String copyright;
  String artistId;
  String artistUrl;
  String artworkUrl100;
  List<Genres> genres;
  String url;

  Album(
      {this.artistName,
        this.id,
        this.releaseDate,
        this.name,
        this.kind,
        this.copyright,
        this.artistId,
        this.artistUrl,
        this.artworkUrl100,
        this.genres,
        this.url});

  Album.fromJson(Map<String, dynamic> json) {
    artistName = json['artistName'];
    id = json['id'];
    releaseDate = json['releaseDate'];
    name = json['name'];
    kind = json['kind'];
    copyright = json['copyright'];
    artistId = json['artistId'];
    artistUrl = json['artistUrl'];
    artworkUrl100 = json['artworkUrl100'];
    if (json['genres'] != null) {
      genres = new List<Genres>();
      json['genres'].forEach((v) {
        genres.add(new Genres.fromJson(v));
      });
    }
    url = json['url'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['artistName'] = this.artistName;
    data['id'] = this.id;
    data['releaseDate'] = this.releaseDate;
    data['name'] = this.name;
    data['kind'] = this.kind;
    data['copyright'] = this.copyright;
    data['artistId'] = this.artistId;
    data['artistUrl'] = this.artistUrl;
    data['artworkUrl100'] = this.artworkUrl100;
    if (this.genres != null) {
      data['genres'] = this.genres.map((v) => v.toJson()).toList();
    }
    data['url'] = this.url;
    return data;
  }
}

class Genres {
  String genreId;
  String name;
  String url;

  Genres({this.genreId, this.name, this.url});

  Genres.fromJson(Map<String, dynamic> json) {
    genreId = json['genreId'];
    name = json['name'];
    url = json['url'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['genreId'] = this.genreId;
    data['name'] = this.name;
    data['url'] = this.url;
    return data;
  }
}
