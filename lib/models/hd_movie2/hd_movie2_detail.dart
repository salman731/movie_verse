
import 'package:Movieverse/models/hd_movie2/hd_movie2_cover.dart';
import 'package:Movieverse/models/hd_movie2/hdmovie2_player_request.dart';
import 'package:Movieverse/models/primewire/primewire_season_episode.dart';

class HdMovie2Detail extends HdMovie2Cover
{
  String? tags;

  String? ratings;

  String? releasedDate;

  String? country;

  String? actors;

  String? duration;

  String? description;

  String? director;

  String? postId;

  List<HdMovie2PlayerRequest>? players;


  HdMovie2Detail(
      {String? title,
        String? url,
        String? coverUrl,
        String? tag1,
        String? tag2,
        this.tags,
        this.ratings,
        this.releasedDate,
        this.director,
        this.country,
        this.actors,
        this.duration,
        this.postId,
        this.players,
        this.description}):super(title: title,url: url,imageURL: coverUrl,tag1: tag1,tag2: tag2);
}