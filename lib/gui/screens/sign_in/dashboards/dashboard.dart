import 'package:dynamic_cast/gui/custom_theme.dart';
import 'package:dynamic_cast/gui/screens/sign_in/dashboards/podcasts.dart';
import 'package:dynamic_cast/i18n/translation.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class DashBoard extends StatelessWidget {
  @override
  Widget build(final BuildContext context) {
    return DefaultTabController(
      length: 4,
      child: Scaffold(
        bottomNavigationBar: _navbar(context),
        body: TabBarView(
          children: [
            PodcastsScreen(),
            Center(child: Text("TODO: Filters")),
            Center(child: Text("TODO: Discover")),
            Center(child: Text("TODO: Profile")),
          ],
        ),
      ),
    );
  }

  Widget _navbar(final BuildContext context) {
    return Container(
      color: customTheme.primaryClr,
      child: TabBar(
        tabs: [
          Tab(text: str.podcasts, icon: Icon(Icons.grid_view)),
          Tab(text: str.filters, icon: Icon(Icons.filter_list)),
          Tab(text: str.discover, icon: Icon(Icons.search)),
          Tab(text: str.profile, icon: Icon(Icons.account_circle)),
        ],
      ),
    );
  }
}
