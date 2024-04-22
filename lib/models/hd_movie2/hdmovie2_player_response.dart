
import 'package:json_annotation/json_annotation.dart';

part 'hdmovie2_player_response.g.dart';

@JsonSerializable()
class HdMovie2PlayerResponse
{
  String? embed_url;

  String? type;

  HdMovie2PlayerResponse({this.embed_url, this.type});

  factory HdMovie2PlayerResponse.fromJson(Map<String, dynamic> json) => _$HdMovie2PlayerResponseFromJson(json);

  /// Connect the generated [_$PersonToJson] function to the `toJson` method.
  Map<String, dynamic> toJson() => _$HdMovie2PlayerResponseToJson(this);


}