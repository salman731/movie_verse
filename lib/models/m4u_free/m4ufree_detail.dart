
import 'package:Movieverse/models/m4u_free/m4ufree_cover.dart';
import 'package:Movieverse/models/m4u_free/m4ufree_episode.dart';

class M4UFreeDetail extends M4UFreeCover
{

  String? genre;

  String? director;

  String? country;

  String? actors;

  String? runtime;

  String? description;

  String? released;

  String? quality;

  List<M4UFreeEpisode>? episodeList;

  M4UFreeDetail(
  {String? title,
  String? url,
  String? coverUrl,
  this.episodeList,
  this.genre,
  this.director,
  this.country,
  this.actors,
  this.runtime,
  this.quality,
  this.released,
  this.description}):super(title: title,url: url,imageURL: coverUrl);

}