// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'all_movie_land_episode.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AllMovieLandEpisode _$AllMovieLandEpisodeFromJson(Map<String, dynamic> json) =>
    AllMovieLandEpisode(
      episode: json['episode'] as String?,
      title: json['title'] as String?,
      id: json['id'] as String?,
      folder: (json['folder'] as List<dynamic>?)
          ?.map((e) => MovieFileInfo.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$AllMovieLandEpisodeToJson(
        AllMovieLandEpisode instance) =>
    <String, dynamic>{
      'episode': instance.episode,
      'title': instance.title,
      'id': instance.id,
      'folder': instance.folder,
    };
