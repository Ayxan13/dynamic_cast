import 'package:dynamic_cast/data/itunes_podcast.dart';
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

    return SearchResults(query);
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return Container();
  }
}

class SearchResults extends StatefulWidget {
  final String _searchTerm;

  SearchResults(this._searchTerm);

  @override
  State<StatefulWidget> createState() {
    return _SearchResultsState(_searchTerm);
  }
}

class _SearchResultsState extends State<StatefulWidget> {
  Future<List<ItunesPodcast>?> _reults;
  List<ItunesPodcast>? _list;

  _SearchResultsState(String term) : _reults = Network.searchPodcast(term);

  @override
  Widget build(BuildContext context) {
    _reults.then((value) => setState(() => _list = value));
    if (_list == null) return Container();

    return SingleChildScrollView(
      child: Column(
        children: List.generate(_list!.length, (index) {
          final element = _list![index];
          return ListTile(
              title: Text(element.collectionName),
              subtitle:
                  element.artistName != null ? Text(element.artistName!) : null,
              leading: () {
                if (element.artworkUrl600 != null)
                  return Image.network(element.artworkUrl600!);
                else if (element.artworkUrl100 != null)
                  return Image.network(element.artworkUrl100!);
                else if (element.artworkUrl60 != null)
                  return Image.network(element.artworkUrl60!);
                else if (element.artworkUrl30 != null)
                  return Image.network(element.artworkUrl30!);
                else
                  return const Icon(Icons.close);
              }());
        }),
      ),
    );
  }
}
