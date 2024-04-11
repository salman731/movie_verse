import 'package:json_annotation/json_annotation.dart';

part 'all_movie_land_search_request.g.dart';


@JsonSerializable()
class AllMovieLandSearchRequest
{
  @JsonKey(name: "do")
  String? do_search;

  String? subaction;

  String? search_start;

  String? full_search;

  String? result_from;

  String? story;

  AllMovieLandSearchRequest(
      {this.do_search,
      this.subaction,
      this.search_start,
      this.full_search,
      this.result_from,
      this.story});

  factory AllMovieLandSearchRequest.fromJson(Map<String, dynamic> json) => _$AllMovieLandSearchRequestFromJson(json);

  /// Connect the generated [_$PersonToJson] function to the `toJson` method.
  Map<String, dynamic> toJson() => _$AllMovieLandSearchRequestToJson(this);
}