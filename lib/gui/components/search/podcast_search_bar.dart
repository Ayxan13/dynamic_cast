import 'package:dynamic_cast/data/itunes_podcast.dart';
import 'package:dynamic_cast/gui/components/search/search_result.dart';
import 'package:dynamic_cast/model/model.dart';
import 'package:flutter/material.dart';

class PodcastSearchDelegate extends SearchDelegate<void> {
  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
          onPressed: () {
            if (query.isEmpty)
              Navigator.of(context).pop();
            else {
              query = "";
            }
          },
          icon: const Icon(Icons.clear))
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return const BackButton();
  }

  @override
  Widget buildResults(BuildContext context) {
    if (query.isEmpty) return Container();
    return BuildSearchResults(query);
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    final list = Network.searchPodcast(query);
    return FutureBuilder(
      future: list,
      builder: (context, snapshot) {
        if (!snapshot.hasData) return Container();

        final data = snapshot.data as List<ItunesPodcast>?;

        if (data == null) return Container();

        return ListView(
          children: List.generate(
            data.length,
            (index) => ListTile(
              title: Text(data[index].collectionName),
              leading: Icon(Icons.search),
            ),
          ),
        );
      },
    );
    // if (query.isEmpty) return Container();
    // return BuildSearchResults(query, lessInfo: true);
  }
}
