import 'package:dynamic_cast/data/itunes_podcast.dart';
import 'package:dynamic_cast/gui/screens/podcast_view/feed_episode_tile_play_button.dart';
import 'package:dynamic_cast/i18n/translation.dart';
import 'package:dynamic_cast/model/model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:webfeed/webfeed.dart';

class PodcastFeed extends StatefulWidget {
  final ItunesPodcast _podcast;
  PodcastFeed(this._podcast);

  @override
  State<StatefulWidget> createState() {
    return _State(_podcast);
  }
}

class _State extends State<PodcastFeed> {
  ItunesPodcast _podcast;
  _State(this._podcast);

  Widget _body(BuildContext context) {
    final page = Network.loadFeed(_podcast);
    final theme = Theme.of(context);
    return FutureBuilder(
        future: page,
        builder: (context, snapshot) {
          if (snapshot.connectionState != ConnectionState.done) {
            return Column(
              children: [
                _infoHeader(context),
                Spacer(),
                CircularProgressIndicator(),
                Spacer(),
              ],
            );
          }

          if (!snapshot.hasData) return _infoHeader(context);

          final data = RssFeed.parse(snapshot.data as String);
          final items = data.items;

          if (items == null) return Center(child: Text(str.noEpisodes));

          return ListView.builder(
            itemCount: items.length + 2,
            itemBuilder: (context, index) {
              switch (index) {
                case 0:
                  return _infoHeader(context);

                case 1:
                  return Container(
                    margin: const EdgeInsets.all(10),
                    child: Text(str.formatNEpisodes(items.length),
                        style: theme.textTheme.headline6),
                  );
                default:
                  return _PodcastEpisode(items[index - 2]);
              }
            },
          );
        });
  }

  Widget _infoHeader(final BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final theme = Theme.of(context);

    final infoSectionHeight = screenHeight * 0.25;
    final decorBarHeight = infoSectionHeight * 0.75;
    final actionBarHeight = infoSectionHeight * 0.25;

    return Stack(
      children: [
        Column(
          children: [
            Container(
              height: decorBarHeight,
              color: theme.accentColor,
            ),
            Container(
              // height: actionBarHeight,
              child: Column(
                children: [
                  Row(
                    children: [
                      Spacer(),
                      IconButton(
                          onPressed: () {/* TODO */},
                          icon: Icon(CupertinoIcons.bell_solid)),
                      IconButton(
                          onPressed: () {/* TODO */},
                          icon: Icon(Icons.settings_outlined)),
                      IconButton(
                          onPressed: () {/* TODO */},
                          icon: Icon(Icons.check_circle_outline)),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
        Container(
          padding: EdgeInsets.fromLTRB(
              actionBarHeight / 5, actionBarHeight / 5, 0, 0),
          child: _podcast.loadArtWork(context, widthProportion: 0.45),
        )
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(onPressed: () {/* TODO */}, icon: Icon(Icons.share))
        ],
      ),
      body: _body(context),
    );
  }
}

class _PodcastEpisode extends StatelessWidget {
  final RssItem _item;

  Widget _actions(BuildContext context) {
    return Row(
      children: [
        EpisodeTilePlayButton(_item),
        IconButton(onPressed: () {/* TODO */}, icon: Icon(Icons.playlist_add)),
        IconButton(
            onPressed: () {/* TODO */}, icon: Icon(Icons.download_rounded)),
      ],
    );
  }

  _PodcastEpisode(this._item);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final title = _item.itunes?.title ?? _item.title;
    final pubDate = _item.pubDate;

    return Material(
      child: Column(
        children: [
          InkWell(
            onTap: () {/* TODO */},
            child: Ink(
              child: Container(
                margin: const EdgeInsets.all(10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (pubDate != null)
                      Text(DateFormat.yMd().format(pubDate),
                          style: theme.textTheme.bodyText2),
                    Text(title ?? " - ", style: theme.textTheme.bodyText1),
                    _actions(context),
                  ],
                ),
              ),
            ),
          ),
          Divider(thickness: 1),
        ],
      ),
    );
  }
}
