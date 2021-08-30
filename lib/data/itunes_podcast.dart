import 'package:flutter/material.dart';
import 'package:json_annotation/json_annotation.dart';

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

  factory ItunesPodcast.fromJson(Map<String, dynamic> json) =>
      _$ItunesPodcastFromJson(json);

  Map<String, dynamic> toJson() => _$ItunesPodcastToJson(this);
}
