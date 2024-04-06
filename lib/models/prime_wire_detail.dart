
import 'package:Movieverse/models/prime_wire_cover.dart';

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

  PrimeWireDetail(
      {String? title,
        String? url,
        String? coverUrl,
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