


import 'package:Movieverse/models/up_movies/up_movies_cover.dart';
import 'package:Movieverse/models/watch_movies/watch_movies_cover.dart';

class WatchMoviesDetail extends WatchMoviesCover
{
  String? genre;

  String? addedDate;

  String? views;

  String? director;

  String? duration;

  String? description;

  WatchMoviesDetail(
      {String? title,
        String? url,
        String? coverUrl,
        this.genre,
        this.addedDate,
        this.views,
        this.duration,
        this.description,
        this.director}):super(title: title,url: url,imageURL: coverUrl);
}