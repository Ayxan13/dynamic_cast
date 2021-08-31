import 'package:flutter/material.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:transparent_image/transparent_image.dart';

// flutter pub run build_runner build
part 'itunes_podcast.g.dart';

@JsonSerializable()
class ItunesPodcast {
  String collectionName;
  String feedUrl;
  Image? image;
  String? artistName;
  String? artworkUrl30;
  String? artworkUrl60;
  String? artworkUrl100;
  String? artworkUrl600;
  String? primaryGenreName;

  ItunesPodcast({
    required this.collectionName,
    required this.feedUrl,
    this.artistName,
    this.artworkUrl30,
    this.artworkUrl60,
    this.artworkUrl100,
    this.artworkUrl600,
    this.primaryGenreName,
  });

  Widget loadArtWork(final BuildContext context) {
    const defaultIcon = Icon(Icons.podcasts);

    final String? url =
        artworkUrl600 ?? artworkUrl100 ?? artworkUrl60 ?? artworkUrl30;

    if (url == null) return Center(child: defaultIcon);

    final sideLength = MediaQuery.of(context).size.width * 0.15;

    return Container(
      width: sideLength,
      height: sideLength,
      child: FadeInImage.memoryNetwork(
        placeholder: kTransparentImage,
        image: url,
        fit: BoxFit.fill,
      ),
    );
  }

  factory ItunesPodcast.fromJson(Map<String, dynamic> json) =>
      _$ItunesPodcastFromJson(json);

  Map<String, dynamic> toJson() => _$ItunesPodcastToJson(this);
}
