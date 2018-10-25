import 'package:flutter/material.dart';

Widget getHeader(ThemeData theme,
        {String title,
        String subtitle,
        String trailing,
        Color backgroundColor,
        Color textColor,
        onTap}) =>
    Container(
        color: backgroundColor ?? theme.secondaryHeaderColor,
        child: ListTile(
          title: Text(title,
              style: TextStyle(
                  color: textColor ?? theme.primaryColor,
                  fontSize: 18.0,
                  fontWeight: FontWeight.bold)),
          subtitle: subtitle == null
              ? null
              : Text(subtitle,
                  style: TextStyle(color: textColor ?? theme.primaryColor)),
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
