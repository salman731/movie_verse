// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'hdmovie2_player_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

HdMovie2PlayerRequest _$HdMovie2PlayerRequestFromJson(
        Map<String, dynamic> json) =>
    HdMovie2PlayerRequest(
      action: json['action'] as String?,
      post: json['post'] as String?,
      nume: json['nume'] as String?,
      type: json['type'] as String?,
    );

Map<String, dynamic> _$HdMovie2PlayerRequestToJson(
        HdMovie2PlayerRequest instance) =>
    <String, dynamic>{
      'action': instance.action,
      'post': instance.post,
      'nume': instance.nume,
      'type': instance.type,
    };
