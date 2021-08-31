import 'package:dynamic_cast/data/itunes_podcast.dart';
import 'package:dynamic_cast/gui/screens/podcast_view/feed.dart';
import 'package:dynamic_cast/i18n/translation.dart';
import 'package:dynamic_cast/model/model.dart';
import 'package:flutter/material.dart';
import 'package:transparent_image/transparent_image.dart';

class BuildSearchResults extends StatefulWidget {
  final String _searchTerm;

  BuildSearchResults(this._searchTerm);

  @override
  State<StatefulWidget> createState() => _State(_searchTerm);
}

class _State extends State<StatefulWidget> {
  Future<List<ItunesPodcast>?> _podcastsList;

  _State(String term) : _podcastsList = Network.searchPodcast(term);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _podcastsList,
      builder: (context, snapshot) {
        if (snapshot.connectionState != ConnectionState.done) {
          return Center(child: CircularProgressIndicator());
        }

        if (snapshot.hasError)
          return Center(child: Text(str.somethingWentWrong));

        final list = snapshot.data as List<ItunesPodcast>?;
        if (list == null)
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.do_not_disturb),
                Text(str.notFound),
              ],
            ),
          );

        return SingleChildScrollView(
          child: Column(
            children: List.generate(
              list.length,
              (index) {
                final element = list[index];
                return ListTile(
                    title: Text(element.collectionName),
                    subtitle: element.artistName != null
                        ? Text(element.artistName!)
                        : null,
                    leading: element.loadArtWork(context),
                    onTap: () => Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => PodcastFeed(element))));
              },
            ),
          ),
        );
      },
    );
  }
}
