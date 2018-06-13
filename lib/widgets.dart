import 'package:flutter/material.dart';

Widget getHeader(ThemeData theme, String text) => Container(
    color: theme.secondaryHeaderColor,
    child: ListTile(
        title: Text(text,
            style: TextStyle(
                color: theme.primaryColor,
                fontSize: 18.0,
                fontWeight: FontWeight.bold))));
