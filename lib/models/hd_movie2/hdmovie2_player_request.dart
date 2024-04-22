
import 'package:json_annotation/json_annotation.dart';

part 'hdmovie2_player_request.g.dart';

@JsonSerializable()
class HdMovie2PlayerRequest
{
   String? action;

   String? post;

   String? nume;

   String? type;

   HdMovie2PlayerRequest({this.action, this.post, this.nume, this.type});

   factory HdMovie2PlayerRequest.fromJson(Map<String, dynamic> json) => _$HdMovie2PlayerRequestFromJson(json);

   /// Connect the generated [_$PersonToJson] function to the `toJson` method.
   Map<String, dynamic> toJson() => _$HdMovie2PlayerRequestToJson(this);

}