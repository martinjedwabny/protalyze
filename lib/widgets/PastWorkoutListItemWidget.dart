import 'package:Protalyze/containers/PastWorkoutListItem.dart';
import 'package:flutter/material.dart';

class PastWorkoutListItemWidget extends StatelessWidget {
  final PastWorkoutListItem _item;
  final VoidCallback _onTap, _onEdit, _onRemove;
  const PastWorkoutListItemWidget(this._item, this._onTap, this._onEdit, this._onRemove);
  @override
  Widget build(BuildContext context) {
    return Card(
        child: ListTile(
          title: _item.buildTitle(context),
          subtitle: _item.buildSubtitle(context),
          onTap: this._onTap,
          trailing: Wrap(
            spacing: 4, // space between two icons
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