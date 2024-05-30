
import 'package:Movieverse/models/m4u_free/m4ufree_cover.dart';

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

  M4UFreeDetail(
  {String? title,
  String? url,
  String? coverUrl,
  this.genre,
  this.director,
  this.country,
  this.actors,
  this.runtime,
  this.quality,
  this.released,
  this.description}):super(title: title,url: url,imageURL: coverUrl);

}