

import 'package:Movieverse/models/all_movie_land/all_movie_land_cover.dart';

class AllMovieLandDetail extends AllMovieLandCover
{
  String? tags;

  String? orginalName;

  String? director;

  String? country;

  String? actors;

  String? runtime;

  String? description;

  String? oringalLanguage;

  String? translationLanguage;

  Map<String,List<String>>? seasonEpisodeMap;

  AllMovieLandDetail(
      {String? title,
        String? url,
        String? coverUrl,
        this.seasonEpisodeMap,
        this.tags,
        this.director,
        this.country,
        this.actors,
        this.runtime,
        this.oringalLanguage,
        this.orginalName,
        this.translationLanguage,
        this.description}):super(title: title,url: url,imageURL: coverUrl);
}