import 'dart:math';

import 'package:astrafolioproject/models/Event.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class EventItem extends StatefulWidget {
  const EventItem ({Key? key, required this.event}): super(key: key);

  final Event event;

  @override
  State<StatefulWidget> createState() => _EventItemState();
}

class _EventItemState extends State<EventItem> {
  dynamic backgroundColors = [
    0xFFFFEBE5,
    0xFFFDF1DB,
    0xFFCFECFF,
    0xFFE5DBFF
  ];

  @override
  void initState() {
    super.initState();

  }
  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: EdgeInsets.all(8.0),
        child: Card(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(16.0))
            ),
            shadowColor: Colors.white,
            color: Color(backgroundColors[Random().nextInt(backgroundColors.length)]),
            elevation: 0.0,
            child: Padding(
              padding: EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  /*! Title */
                  Padding(
                    padding: EdgeInsets.only(bottom: 8.0),
                    child:
                    Text(
                        widget.event.name,
                        textAlign: TextAlign.start,
                        softWrap: true,
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                          color: Colors.black87,
                        )
                    ),
                  ),

                  /*! Description */
                  Text(
                      widget.event.description,
                      softWrap: true,
                      style: TextStyle(
                        color: Colors.black54,
                        fontSize: 16,
                        fontWeight: FontWeight.w400,
                      )
                  ),

                  Divider(color: Colors.black26,),

                  /*! Hours */
                  Row(children: [
                    Icon(
                        Icons.access_time,
                        color: Colors.black87
                    ),

                    Padding(
                      padding: EdgeInsets.only(left: 8.0),
                      child: Text(DateFormat.jm().format(widget.event.timestamp)),
                    ),
                  ],),
                ],
              ),
            )
        )
    );
  }
}