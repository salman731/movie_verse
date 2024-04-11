

import 'package:Movieverse/models/all_movie_land/all_movie_land_episode.dart';
import 'package:json_annotation/json_annotation.dart';

part 'all_movie_land_season.g.dart';

@JsonSerializable()
class AllMovieLandSeason
{
  String? title;

  String? id;

  List<AllMovieLandEpisode>? folder;

  AllMovieLandSeason({this.title, this.id, this.folder});

  factory AllMovieLandSeason.fromJson(Map<String, dynamic> json) => _$AllMovieLandSeasonFromJson(json);

  /// Connect the generated [_$PersonToJson] function to the `toJson` method.
  Map<String, dynamic> toJson() => _$AllMovieLandSeasonToJson(this);
}