

import 'package:Movieverse/models/pr_movies/vid_src_to_url.dart';
import 'package:json_annotation/json_annotation.dart';
part 'vid_src_to_url_response.g.dart';

@JsonSerializable()
class VidSrcToUrlResponse
{
  int? status;

  VidSrcToUrl? result;

  VidSrcToUrlResponse(this.status, this.result);

  factory VidSrcToUrlResponse.fromJson(Map<String, dynamic> json) => _$VidSrcToUrlResponseFromJson(json);

  /// Connect the generated [_$PersonToJson] function to the `toJson` method.
  Map<String, dynamic> toJson() => _$VidSrcToUrlResponseToJson(this);
}