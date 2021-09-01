import 'package:dynamic_cast/i18n/translation.dart';
import 'package:flutter/material.dart';
import 'package:webfeed/webfeed.dart';

class EpisodeTilePlayButton extends StatefulWidget {
  final RssItem _episode;

  EpisodeTilePlayButton(this._episode);

  @override
  State<StatefulWidget> createState() {
    return _State(_episode);
  }
}

class _State extends State<EpisodeTilePlayButton> {
  final RssItem _episode;
  _ButtonState _state = _ButtonState.paused;

  _State(this._episode);

  void _onTap() {
    // TODO
  }

  @override
  Widget build(BuildContext context) {
    final duration = _episode.itunes?.duration;
    final theme = Theme.of(context);
    return OutlinedButton.icon(
      onPressed: _onTap,
      icon: Icon(Icons.play_circle_outline),
      style: ButtonStyle(
        shape: MaterialStateProperty.all(
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(30.0))),
      ),
      label: Text(
        duration != null ? str.formatDuration(duration) : str.play,
        style: theme.textTheme.bodyText2,
      ),
    );
  }
}

enum _ButtonState { paused, loading, playing }
