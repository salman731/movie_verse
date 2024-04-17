
import 'package:Movieverse/models/hd_movie2/hd_movie2_cover.dart';
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


  HdMovie2Detail(
      {String? title,
        String? url,
        String? coverUrl,
        this.tags,
        this.ratings,
        this.releasedDate,
        this.director,
        this.country,
        this.actors,
        this.duration,
        this.description}):super(title: title,url: url,imageURL: coverUrl,);
}