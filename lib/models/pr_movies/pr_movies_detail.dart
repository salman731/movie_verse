


import 'package:Movieverse/models/pr_movies/pr_movies_cover.dart';

class PrMoviesDetail extends PrMoviesCover
{
  String? genre;

  String? director;

  String? country;

  String? actors;

  String? runtime;

  String? description;

  String? released;

  String? ratings;

  String? languageQuality;

  String? studio;

  String? tvStatus;

  String? networks;

  Map<String,String>? episodeMap;

  PrMoviesDetail(
      {String? title,
        String? url,
        String? coverUrl,
        String? tags,
        this.genre,
        this.director,
        this.country,
        this.actors,
        this.runtime,
        this.languageQuality,
        this.released,
        this.ratings,
        this.studio,
        this.tvStatus,
        this.networks,
        this.episodeMap,
        this.description}):super(title: title,url: url,imageURL: coverUrl,tag: tags);
}