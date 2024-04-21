

import 'package:json_annotation/json_annotation.dart';

part 'hd_movie2_video_detail.g.dart';

@JsonSerializable()
class HDMovie2VideoDetail
{
  String? id;

  List<String>? sources;

  String? domain;

  HDMovie2VideoDetail({this.id, this.sources, this.domain});

  factory HDMovie2VideoDetail.fromJson(Map<String, dynamic> json) => _$HDMovie2VideoDetailFromJson(json);

  /// Connect the generated [_$PersonToJson] function to the `toJson` method.
  Map<String, dynamic> toJson() => _$HDMovie2VideoDetailToJson(this);
}