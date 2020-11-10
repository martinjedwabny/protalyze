import 'package:Protalyze/containers/ListItem.dart';
import 'package:flutter/material.dart';

/// A ListItem that contains data to display a heading.
abstract class BlockListItem implements ListItem {

  Widget buildTitle(BuildContext context) => null;

  Widget buildSubtitle(BuildContext context) => null;

  Widget buildInputFields(BuildContext context) => null;
}