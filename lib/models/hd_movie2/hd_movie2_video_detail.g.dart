// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'hd_movie2_video_detail.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

HDMovie2VideoDetail _$HDMovie2VideoDetailFromJson(Map<String, dynamic> json) =>
    HDMovie2VideoDetail(
      id: json['id'] as String?,
      sources:
          (json['sources'] as List<dynamic>?)?.map((e) => e as String).toList(),
      domain: json['domain'] as String?,
    );

Map<String, dynamic> _$HDMovie2VideoDetailToJson(
        HDMovie2VideoDetail instance) =>
    <String, dynamic>{
      'id': instance.id,
      'sources': instance.sources,
      'domain': instance.domain,
    };
