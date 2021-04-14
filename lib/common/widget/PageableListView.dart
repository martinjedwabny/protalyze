import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class PageableListView extends StatefulWidget {
  final bool shrinkWraps;
  final ScrollPhysics physics;
  final List<Widget> items;
  final int perPage;
  final String messageNoItems;
  const PageableListView({
    Key key,
    this.shrinkWraps,
    this.physics,
    @required this.items,
    @required this.perPage,
    @required this.messageNoItems,
  }) : super(key: key);

  @override
  _PageableListViewState createState() => _PageableListViewState();
}

class _PageableListViewState extends State<PageableListView> {
  int present = 0;

  @override
  Widget build(BuildContext context) {
    if (present == 0)
      present = min(widget.perPage, widget.items != null ? widget.items.length : 0);
    if (widget.items == null || widget.items.isEmpty) {
      return Padding(
        padding: EdgeInsets.symmetric(vertical:8),
        child: Text(widget.messageNoItems, 
          style: Theme.of(context).textTheme.headline6,
          textAlign: TextAlign.center,),);
    }
    return ListView.builder(
      shrinkWrap: true,
      physics: ClampingScrollPhysics(),
      itemCount: (present < widget.items.length) ? present + 1 : present,
      itemBuilder: (context, index) {
        if (index == present)
          return Container(
            height: 40,
            child: RaisedButton(
              padding: EdgeInsets.all(16.0),
              child: Text('Show more', style: TextStyle(color: Colors.white, fontSize: 16.0),),
              onPressed: () {
                setState(() {
                  present = min(present + widget.perPage, widget.items.length);
                });
              },
            ),
          );
          return widget.items[index];
      },
    );
  }
}