import 'package:dynamic_cast/data/itunes_podcast.dart';
import 'package:dynamic_cast/i18n/translation.dart';
import 'package:dynamic_cast/mock/data_src.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class PodcastsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final likedPodcasts = MockData.getLibrary();

    return Scaffold(
      appBar: AppBar(
        title: Text(str.podcasts),
        actions: [
          IconButton(
            onPressed: () {
              // TODO: implement
            },
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
          if (item.artworkUrl100 != null)
            return Image.network(item.artworkUrl100!);
          else
            return Icon(Icons.not_interested);
        }),
      ),
    );
  }
}
