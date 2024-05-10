
import 'package:Movieverse/models/cinezone/cinezone_cover.dart';

class CineZoneDetail extends CineZoneCover
{
  String? genre;

  String? ratings;

  String? releasedDate;

  String? country;

  String? actors;

  String? duration;

  String? description;

  String? production;

  String? director;

  String? type;

  String? year;

  String? serverId;

  Map<String,Map<String,String>>? episodeSeasonMap;

  CineZoneDetail(
      {String? title,
        String? url,
        String? coverUrl,
        String? tag1,
        String? tag2,
        this.genre,
        this.serverId,
        this.ratings,
        this.releasedDate,
        this.country,
        this.actors,
        this.duration,
        this.production,
        this.director,
        this.type,
        this.episodeSeasonMap,
        this.year,
        this.description}):super(title: title,url: url,imageURL: coverUrl,tag1: tag1,tag2: tag2);
}