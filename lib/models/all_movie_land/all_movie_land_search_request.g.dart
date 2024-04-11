// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'all_movie_land_search_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AllMovieLandSearchRequest _$AllMovieLandSearchRequestFromJson(
        Map<String, dynamic> json) =>
    AllMovieLandSearchRequest(
      do_search: json['do'] as String?,
      subaction: json['subaction'] as String?,
      search_start: json['search_start'] as String?,
      full_search: json['full_search'] as String?,
      result_from: json['result_from'] as String?,
      story: json['story'] as String?,
    );

Map<String, dynamic> _$AllMovieLandSearchRequestToJson(
        AllMovieLandSearchRequest instance) =>
    <String, dynamic>{
      'do': instance.do_search,
      'subaction': instance.subaction,
      'search_start': instance.search_start,
      'full_search': instance.full_search,
      'result_from': instance.result_from,
      'story': instance.story,
    };
