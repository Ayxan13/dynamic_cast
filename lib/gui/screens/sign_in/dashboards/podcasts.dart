import 'package:dynamic_cast/i18n/translation.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class PodcastsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(str.podcasts),
      ),
    );
  }
}
