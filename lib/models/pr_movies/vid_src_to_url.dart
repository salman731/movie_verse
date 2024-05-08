import 'package:json_annotation/json_annotation.dart';
part 'vid_src_to_url.g.dart';


@JsonSerializable()
class VidSrcToUrl
{
  String? url;

  VidSrcToUrl(this.url);

  factory VidSrcToUrl.fromJson(Map<String, dynamic> json) => _$VidSrcToUrlFromJson(json);

  /// Connect the generated [_$PersonToJson] function to the `toJson` method.
  Map<String, dynamic> toJson() => _$VidSrcToUrlToJson(this);

}