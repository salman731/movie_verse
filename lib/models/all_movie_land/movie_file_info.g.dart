// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'movie_file_info.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MovieFileInfo _$MovieFileInfoFromJson(Map<String, dynamic> json) =>
    MovieFileInfo(
      title: json['title'] as String?,
      id: json['id'] as String?,
      file: json['file'] as String?,
    );

Map<String, dynamic> _$MovieFileInfoToJson(MovieFileInfo instance) =>
    <String, dynamic>{
      'title': instance.title,
      'id': instance.id,
      'file': instance.file,
    };
