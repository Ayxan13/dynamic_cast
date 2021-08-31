import 'package:dynamic_cast/gui/components/search/podcast_search_bar.dart';
import 'package:dynamic_cast/gui/screens/podcast_view/feed.dart';
import 'package:dynamic_cast/i18n/translation.dart';
import 'package:dynamic_cast/model/model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class PodcastsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final likedPodcasts = podcastsModel.getLibrary();

    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: Text(str.podcasts),
        actions: [
          IconButton(
            onPressed: () =>
                showSearch(context: context, delegate: PodcastSearchDelegate()),
            icon: Icon(Icons.search),
          ),
          IconButton(
            onPressed: () {}, // TODO: implement
            icon: Icon(Icons.more_vert),
          ),
        ],
      ),
      body: GridView.count(
        crossAxisCount: 4,
        children: List.generate(likedPodcasts.length, (index) {
          final item = likedPodcasts[index];
          final toPodcast = () => Navigator.of(context)
              .push(MaterialPageRoute(builder: (context) => PodcastFeed(item)));

          return GestureDetector(
            onTap: toPodcast,
            child: item.loadArtWork(context),
          );
        }),
      ),
    );
  }
}
