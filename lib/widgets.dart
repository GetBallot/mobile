import 'package:flutter/material.dart';

Widget getHeader(ThemeData theme, {String text, String trailing, onTap}) =>
    Container(
        color: theme.secondaryHeaderColor,
        child: ListTile(
          title: Text(text,
              style: TextStyle(
                  color: theme.primaryColor,
                  fontSize: 18.0,
                  fontWeight: FontWeight.bold)),
          trailing: trailing == null
              ? null
              : new Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Text(trailing,
                      style:
                          TextStyle(color: theme.primaryColor, fontSize: 18.0)),
                ),
          onTap: onTap,
        ));
