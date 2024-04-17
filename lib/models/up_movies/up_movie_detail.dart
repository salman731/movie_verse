


import 'package:Movieverse/models/up_movies/up_movies_cover.dart';

class UpMovieDetail extends UpMoviesCover
{
  String? genre;

  String? director;

  String? country;

  String? actors;

  String? duration;

  String? description;

  UpMovieDetail(
      {String? title,
        String? url,
        String? coverUrl,
        String? year,
      this.genre,
      this.director,
      this.country,
      this.actors,
      this.duration,
      this.description}):super(title: title,url: url,imageURL: coverUrl,year: year);
}