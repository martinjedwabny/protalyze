import 'package:flutter/material.dart';

/// The base class for the different types of items the list can contain.
abstract class ListItem {
  Widget buildTitle(BuildContext context);
  Widget buildContent(BuildContext context);
}
