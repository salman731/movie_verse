

import 'package:Movieverse/enums/primewire_home_screen_category_enum.dart';
import 'package:Movieverse/enums/watch_movies_home_category_enum.dart';

class PrimeWireCategoryUrlsContant
{
   static final featuredMovies = "https://www.primewire.tf/filter?sort=Featured&e=v";
   static final inTheatersMovies = "https://www.primewire.tf/filter?sort=In+Theaters&type=movie";
   static final streamingMovies = "https://www.primewire.tf/filter?sort=Streaming+Release&type=movie";
   static final latestMovies = "https://www.primewire.tf/filter?sort=New&type=movie";
   static final recentAddedMovies = "https://www.primewire.tf/filter?sort=Just+Added&free_links=true";
   static final trendingMovies = "https://www.primewire.tf/filter?sort=Trending+Today";

   static Map<String,String> urlsMap = {
     PrimewireHomeScreenCategoryEnum.Featured.name:featuredMovies,
     PrimewireHomeScreenCategoryEnum.InTheaters.name:inTheatersMovies,
     PrimewireHomeScreenCategoryEnum.Streaming.name:streamingMovies,
     PrimewireHomeScreenCategoryEnum.Latest.name:latestMovies,
     PrimewireHomeScreenCategoryEnum.Recent.name:recentAddedMovies,
     PrimewireHomeScreenCategoryEnum.Trending.name:trendingMovies,
   };
}


class WatchMoviesCategoryUrlsContant
{
  static final indianMovies = "https://www.watch-movies.com.pk/category/indian-movies/";
  static final hindiDubbedMovies = "https://www.watch-movies.com.pk/category/watch-hindi-dubbed-full-movies/";
  static final punjabiMovies = "https://www.watch-movies.com.pk/category/watch-punjabi-movies-online/";
  static final englishMovies = "https://www.watch-movies.com.pk/category/english-movies-free/";

  static Map<String,String> urlsMap = {
    WatchMoviesHomeScreenCategoryEnum.Indian.name:indianMovies,
    WatchMoviesHomeScreenCategoryEnum.HindiDubbed.name:hindiDubbedMovies,
    WatchMoviesHomeScreenCategoryEnum.English.name:englishMovies,
    WatchMoviesHomeScreenCategoryEnum.Punjabi.name:punjabiMovies,

  };
}

