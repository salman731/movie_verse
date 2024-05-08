

import 'package:Movieverse/models/pr_movies/vid_src_to_source.dart';
import 'package:json_annotation/json_annotation.dart';

part 'vid_src_to_source_response.g.dart';

@JsonSerializable()
class VidSrcToSourceResponse
{
   int? status;

   List<VidSrcToSource>? result;

   VidSrcToSourceResponse(this.status, this.result);

   factory VidSrcToSourceResponse.fromJson(Map<String, dynamic> json) => _$VidSrcToSourceResponseFromJson(json);

   /// Connect the generated [_$PersonToJson] function to the `toJson` method.
   Map<String, dynamic> toJson() => _$VidSrcToSourceResponseToJson(this);
}


