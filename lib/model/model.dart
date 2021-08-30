import 'dart:convert';

import 'package:dynamic_cast/data/itunes_podcast.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart';
import 'package:webfeed/domain/itunes/itunes.dart';

abstract class PodcastsModel {
  List<ItunesPodcast> getLibrary();
}

class MockData extends PodcastsModel {
  List<ItunesPodcast> getLibrary() {
    return [
      ItunesPodcast(
          collectionName: "Hello Internet",
          feedUrl: "http://www.hellointernet.fm/podcast?format=rss",
          artistName: "CGP Grey & Brady Haran",
          artworkUrl30:
              "https://is5-ssl.mzstatic.com/image/thumb/Podcasts6/v4/19/33/fe/1933fe85-cd86-2191-8187-d725ca7359bf/mza_8038397602264410223.png/30x30bb.jpg",
          artworkUrl60:
              "https://is5-ssl.mzstatic.com/image/thumb/Podcasts6/v4/19/33/fe/1933fe85-cd86-2191-8187-d725ca7359bf/mza_8038397602264410223.png/60x60bb.jpg",
          artworkUrl100:
              "https://is5-ssl.mzstatic.com/image/thumb/Podcasts6/v4/19/33/fe/1933fe85-cd86-2191-8187-d725ca7359bf/mza_8038397602264410223.png/100x100bb.jpg",
          artworkUrl600:
              "https://is5-ssl.mzstatic.com/image/thumb/Podcasts6/v4/19/33/fe/1933fe85-cd86-2191-8187-d725ca7359bf/mza_8038397602264410223.png/600x600bb.jpg",
          primaryGenreName: "Education"),
      ItunesPodcast(
          collectionName: "Two's Complement",
          feedUrl: "https://www.twoscomplement.org/podcast/feed.xml",
          artistName: "Ben Rady and Matt Godbolt",
          artworkUrl30:
              "https://is3-ssl.mzstatic.com/image/thumb/Podcasts125/v4/ab/ba/ab/abbaab1e-0e02-2643-8235-f54cd76743b7/mza_9045029116033537275.png/30x30bb.jpg",
          artworkUrl60:
              "https://is3-ssl.mzstatic.com/image/thumb/Podcasts125/v4/ab/ba/ab/abbaab1e-0e02-2643-8235-f54cd76743b7/mza_9045029116033537275.png/60x60bb.jpg",
          artworkUrl100:
              "https://is3-ssl.mzstatic.com/image/thumb/Podcasts125/v4/ab/ba/ab/abbaab1e-0e02-2643-8235-f54cd76743b7/mza_9045029116033537275.png/100x100bb.jpg",
          artworkUrl600:
              "https://is3-ssl.mzstatic.com/image/thumb/Podcasts125/v4/ab/ba/ab/abbaab1e-0e02-2643-8235-f54cd76743b7/mza_9045029116033537275.png/600x600bb.jpg",
          primaryGenreName: "Technology"),
      ItunesPodcast(
          collectionName: "Cortex",
          feedUrl: "https://www.relay.fm/cortex/feed",
          artistName: "Relay FM",
          artworkUrl30:
              "https://is2-ssl.mzstatic.com/image/thumb/Podcasts115/v4/93/83/f4/9383f493-ac30-7917-2d00-9e664be8833a/mza_15955959681095971349.jpeg/30x30bb.jpg",
          artworkUrl60:
              "https://is2-ssl.mzstatic.com/image/thumb/Podcasts115/v4/93/83/f4/9383f493-ac30-7917-2d00-9e664be8833a/mza_15955959681095971349.jpeg/60x60bb.jpg",
          artworkUrl100:
              "https://is2-ssl.mzstatic.com/image/thumb/Podcasts115/v4/93/83/f4/9383f493-ac30-7917-2d00-9e664be8833a/mza_15955959681095971349.jpeg/100x100bb.jpg",
          artworkUrl600:
              "https://is2-ssl.mzstatic.com/image/thumb/Podcasts115/v4/93/83/f4/9383f493-ac30-7917-2d00-9e664be8833a/mza_15955959681095971349.jpeg/600x600bb.jpg",
          primaryGenreName: "Technology"),
      ItunesPodcast(
          collectionName: "The Unmade Podcast",
          feedUrl: "https://www.unmade.fm/episodes?format=rss",
          artistName: "Tim Hein and Brady Haran",
          artworkUrl30:
              "https://is2-ssl.mzstatic.com/image/thumb/Podcasts123/v4/9c/11/7d/9c117d0e-7579-bfd0-c5c8-06c6b37563af/mza_2920880226770440540.jpg/30x30bb.jpg",
          artworkUrl60:
              "https://is2-ssl.mzstatic.com/image/thumb/Podcasts123/v4/9c/11/7d/9c117d0e-7579-bfd0-c5c8-06c6b37563af/mza_2920880226770440540.jpg/60x60bb.jpg",
          artworkUrl100:
              "https://is2-ssl.mzstatic.com/image/thumb/Podcasts123/v4/9c/11/7d/9c117d0e-7579-bfd0-c5c8-06c6b37563af/mza_2920880226770440540.jpg/100x100bb.jpg",
          artworkUrl600:
              "https://is2-ssl.mzstatic.com/image/thumb/Podcasts123/v4/9c/11/7d/9c117d0e-7579-bfd0-c5c8-06c6b37563af/mza_2920880226770440540.jpg/600x600bb.jpg",
          primaryGenreName: "Comedy"),
      ItunesPodcast(
          collectionName: "Command Line Heroes",
          feedUrl: "https://feeds.pacific-content.com/commandlineheroes",
          artistName: "Red Hat",
          artworkUrl30:
              "https://is3-ssl.mzstatic.com/image/thumb/Podcasts125/v4/5c/2f/0f/5c2f0f37-d20b-ffd9-d987-4c9cb9c30bfb/mza_13553072883718784286.jpg/30x30bb.jpg",
          artworkUrl60:
              "https://is3-ssl.mzstatic.com/image/thumb/Podcasts125/v4/5c/2f/0f/5c2f0f37-d20b-ffd9-d987-4c9cb9c30bfb/mza_13553072883718784286.jpg/60x60bb.jpg",
          artworkUrl100:
              "https://is3-ssl.mzstatic.com/image/thumb/Podcasts125/v4/5c/2f/0f/5c2f0f37-d20b-ffd9-d987-4c9cb9c30bfb/mza_13553072883718784286.jpg/100x100bb.jpg",
          artworkUrl600:
              "https://is3-ssl.mzstatic.com/image/thumb/Podcasts125/v4/5c/2f/0f/5c2f0f37-d20b-ffd9-d987-4c9cb9c30bfb/mza_13553072883718784286.jpg/600x600bb.jpg",
          primaryGenreName: "Technology")
    ];
  }
}

final podcastsModel = MockData();

class Network {
  static void searchPodcastFill(
      final String term, final ObserverList<ItunesPodcast> toFill) async {
    final list = await searchPodcast(term);

    toFill.clear();

    if (list == null) return;

    for (int i = 0; i != list.length; ++i) {}
  }

  static Future<List<ItunesPodcast>?> searchPodcast(final String term) async {
    final params = {
      'media': 'podcast',
      'term': term,
    };

    final uri = Uri.https('itunes.apple.com', '/search', params);
    final response = await get(uri);

    if (response.statusCode != 200) return null;

    final json = jsonDecode(response.body);
    final podcasts = <ItunesPodcast>[];

    for (final podJson in json['results']) {
      try {
        podcasts.add(ItunesPodcast.fromJson(podJson));
      } catch (error) {
        // ... skip ...
      }
    }

    if (podcasts.isEmpty) return null;

    return podcasts;
  }
}
