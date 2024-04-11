// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'all_movie_land_season.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AllMovieLandSeason _$AllMovieLandSeasonFromJson(Map<String, dynamic> json) =>
    AllMovieLandSeason(
      title: json['title'] as String?,
      id: json['id'] as String?,
      folder: (json['folder'] as List<dynamic>?)
          ?.map((e) => AllMovieLandEpisode.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$AllMovieLandSeasonToJson(AllMovieLandSeason instance) =>
    <String, dynamic>{
      'title': instance.title,
      'id': instance.id,
      'folder': instance.folder,
    };
