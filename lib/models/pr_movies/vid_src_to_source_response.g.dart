// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'vid_src_to_source_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

VidSrcToSourceResponse _$VidSrcToSourceResponseFromJson(
        Map<String, dynamic> json) =>
    VidSrcToSourceResponse(
      json['status'] as int?,
      (json['result'] as List<dynamic>?)
          ?.map((e) => VidSrcToSource.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$VidSrcToSourceResponseToJson(
        VidSrcToSourceResponse instance) =>
    <String, dynamic>{
      'status': instance.status,
      'result': instance.result,
    };
