

import 'package:Movieverse/models/film_1k_cover.dart';

class Film1kDetail extends Film1kCover
{
  String? genre;

  String? director;

  String? country;

  String? actors;

  String? runtime;

  String? description;

  String? released;

  String? language;

  Film1kDetail(
      {String? title,
        String? url,
        String? coverUrl,
        String? year,
        this.genre,
        this.director,
        this.country,
        this.actors,
        this.runtime,
        this.language,
        this.released,
        this.description}):super(title: title,url: url,imageURL: coverUrl);
}