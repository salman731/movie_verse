

import 'package:Movieverse/models/watch_series/watch_series_cover.dart';

class WatchSeriesDetail extends WatchSeriesCover
{
  String? genre;

  String? ratings;

  String? releasedDate;

  String? country;

  String? actors;

  String? duration;

  String? description;

  String? production;

  String? id;

  Map<String,Map<String,String>>? episodeSeasonMap;

  WatchSeriesDetail(
      {String? title,
        String? url,
        String? coverUrl,
        String? tag1,
        String? tag2,
        this.episodeSeasonMap,
        this.genre,
        this.id,
        this.ratings,
        this.releasedDate,
        this.country,
        this.actors,
        this.duration,
        this.production,
        this.description}):super(title: title,url: url,imageURL: coverUrl,tag1: tag1,tag2: tag2);
}