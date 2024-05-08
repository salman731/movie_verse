

import 'package:json_annotation/json_annotation.dart';
part 'vid_src_to_source.g.dart';

@JsonSerializable()
class VidSrcToSource
{
   String? id;

   String? title;

   VidSrcToSource(this.id, this.title);

   factory VidSrcToSource.fromJson(Map<String, dynamic> json) => _$VidSrcToSourceFromJson(json);

   /// Connect the generated [_$PersonToJson] function to the `toJson` method.
   Map<String, dynamic> toJson() => _$VidSrcToSourceToJson(this);
}