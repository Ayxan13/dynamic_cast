// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'itunes_podcast.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ItunesPodcast _$ItunesPodcastFromJson(Map<String, dynamic> json) {
  return ItunesPodcast(
    collectionName: json['collectionName'] as String,
    feedUrl: json['feedUrl'] as String,
    artistName: json['artistName'] as String?,
    artworkUrl30: json['artworkUrl30'] as String?,
    artworkUrl60: json['artworkUrl60'] as String?,
    artworkUrl100: json['artworkUrl100'] as String?,
    artworkUrl600: json['artworkUrl600'] as String?,
    primaryGenreName: json['primaryGenreName'] as String?,
  );
}

Map<String, dynamic> _$ItunesPodcastToJson(ItunesPodcast instance) =>
    <String, dynamic>{
      'collectionName': instance.collectionName,
      'feedUrl': instance.feedUrl,
      'artistName': instance.artistName,
      'artworkUrl30': instance.artworkUrl30,
      'artworkUrl60': instance.artworkUrl60,
      'artworkUrl100': instance.artworkUrl100,
      'artworkUrl600': instance.artworkUrl600,
      'primaryGenreName': instance.primaryGenreName,
    };
