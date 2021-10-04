import 'package:protalize/pages/past_workouts/PastWorkoutListItem.dart';
import 'package:flutter/material.dart';

class PastWorkoutListItemWidget extends StatelessWidget {
  final PastWorkoutListItem _item;
  final VoidCallback _onTap, _onEdit, _onRemove;
  const PastWorkoutListItemWidget(this._item, this._onTap, this._onEdit, this._onRemove);
  @override
  Widget build(BuildContext context) {
    return Card(
        child: ListTile(
          contentPadding: EdgeInsets.only(left: 12, right: 4),
          title: _item.buildTitle(context),
          subtitle: _item.buildContent(context),
          onTap: this._onTap,
          trailing: Wrap(
            spacing: 0.0, // space between two icons
            children: <Widget>[
              IconButton(
                icon: Icon(Icons.edit),
                tooltip: 'Edit',
                onPressed: this._onEdit,
              ),
              IconButton(
                  icon: Icon(Icons.delete_outline),
                  tooltip: 'Remove',
                  onPressed: this._onRemove),
            ],
          ),
        ),
      );
  }
  
}