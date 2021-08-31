import 'package:dynamic_cast/data/itunes_podcast.dart';
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

  static Widget _loadArtWork(
      final BuildContext context, final ItunesPodcast podcast) {
    const defaultIcon = Icon(Icons.podcasts);

    final String? url = podcast.artworkUrl600 ??
        podcast.artworkUrl100 ??
        podcast.artworkUrl60 ??
        podcast.artworkUrl30;

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
            children: List.generate(list.length, (index) {
              final element = list[index];
              return ListTile(
                title: Text(element.collectionName),
                subtitle: element.artistName != null
                    ? Text(element.artistName!)
                    : null,
                leading: _loadArtWork(context, element),
              );
            }),
          ),
        );
      },
    );
  }
}
