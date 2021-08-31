import 'package:dynamic_cast/data/itunes_podcast.dart';
import 'package:dynamic_cast/i18n/translation.dart';
import 'package:dynamic_cast/model/model.dart';
import 'package:flutter/material.dart';
import 'package:webfeed/webfeed.dart';

class PodcastFeed extends StatefulWidget {
  ItunesPodcast _podcast;
  PodcastFeed(this._podcast);

  @override
  State<StatefulWidget> createState() {
    return _State(_podcast);
  }
}

class _State extends State<PodcastFeed> {
  ItunesPodcast _podcast;
  _State(this._podcast);

  @override
  Widget build(BuildContext context) {
    final page = Network.loadFeed(_podcast);
    page.then((value) => RssFeed.parse(value).items![0]);

    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(onPressed: () {/* TODO */}, icon: Icon(Icons.share))
        ],
      ),
      body: FutureBuilder(
          future: page,
          builder: (context, snapshot) {
            if (snapshot.connectionState != ConnectionState.done)
              return Center(child: CircularProgressIndicator());

            if (!snapshot.hasData)
              return Center(child: Text(str.connectionError));

            final data = RssFeed.parse(snapshot.data as String);
            final items = data.items!;

            return ListView.separated(
              itemCount: items.length,
              itemBuilder: (context, index) => _PodcastEpisode(items[index]),
              separatorBuilder: (context, index) => Divider(),
            );
          }),
    );
  }
}

class _PodcastEpisode extends StatelessWidget {
  final RssItem _item;

  _PodcastEpisode(this._item);

  @override
  Widget build(BuildContext context) {
    final duration = _item.itunes?.duration;
    final pubDate = _item.pubDate;
    return ListTile(
      title: Text(_item.title ?? " - "),
      subtitle: Text(duration != null ? str.formatDuration(duration) : " - "),
      onTap: () {/* TODO */},
      trailing: IconButton(
        icon: Icon(Icons.play_circle_outline),
        onPressed: () {/* TODO */},
      ),
    );
  }
}
