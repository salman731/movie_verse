


import 'package:Movieverse/models/all_movie_land/movie_file_info.dart';
import 'package:json_annotation/json_annotation.dart';

part 'all_movie_land_episode.g.dart';

@JsonSerializable()
class AllMovieLandEpisode
{
  String? episode;

  String? title;

  String? id;

  List<MovieFileInfo>? folder;

  AllMovieLandEpisode({this.episode, this.title, this.id, this.folder});

  factory AllMovieLandEpisode.fromJson(Map<String, dynamic> json) => _$AllMovieLandEpisodeFromJson(json);

  /// Connect the generated [_$PersonToJson] function to the `toJson` method.
  Map<String, dynamic> toJson() => _$AllMovieLandEpisodeToJson(this);
}