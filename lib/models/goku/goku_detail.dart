


import 'package:Movieverse/models/goku/goku_cover.dart';

class GokuDetail extends GokuCover
{
  String? genre;

  String? country;

  String? actors;

  String? duration;

  String? description;

  String? production;

  String? serverId;

  Map<String,Map<String,String>>? episodeSeasonMap;

  GokuDetail(
      {String? title,
        String? url,
        String? coverUrl,
        String? tag1,
        String? tag2,
        this.genre,
        this.serverId,
        this.country,
        this.actors,
        this.duration,
        this.production,
        this.episodeSeasonMap,
        this.description}):super(title: title,url: url,imageURL: coverUrl,tag1: tag1,tag2: tag2);
}