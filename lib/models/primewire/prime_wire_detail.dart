
import 'package:Movieverse/models/primewire/prime_wire_cover.dart';
import 'package:Movieverse/models/primewire/primewire_season_episode.dart';

class PrimeWireDetail extends PrimeWireCover
{
  String? genre;

  String? ratings;

  String? releasedDate;

  String? country;

  String? actors;

  String? duration;

  String? description;

  String? company;

  String? crew;

  Map<String,List<PrimewireSeasonEpisode>>? seasonEpisodesMap;

  PrimeWireDetail(
      {String? title,
        String? url,
        String? coverUrl,
        this.seasonEpisodesMap,
        this.genre,
        this.ratings,
        this.releasedDate,
        this.company,
        this.crew,
        this.country,
        this.actors,
        this.duration,
        this.description}):super(title: title,url: url,imageURL: coverUrl,);
}