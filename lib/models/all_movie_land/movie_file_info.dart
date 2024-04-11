
import 'package:json_annotation/json_annotation.dart';

part 'movie_file_info.g.dart';

@JsonSerializable()
class MovieFileInfo
{
  String? title;

  String? id;

  String? file;

  MovieFileInfo({this.title, this.id, this.file});

  factory MovieFileInfo.fromJson(Map<String, dynamic> json) => _$MovieFileInfoFromJson(json);

  Map<String, dynamic> toJson() => _$MovieFileInfoToJson(this);
}