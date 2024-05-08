// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'vid_src_to_url_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

VidSrcToUrlResponse _$VidSrcToUrlResponseFromJson(Map<String, dynamic> json) =>
    VidSrcToUrlResponse(
      json['status'] as int?,
      json['result'] == null
          ? null
          : VidSrcToUrl.fromJson(json['result'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$VidSrcToUrlResponseToJson(
        VidSrcToUrlResponse instance) =>
    <String, dynamic>{
      'status': instance.status,
      'result': instance.result,
    };
