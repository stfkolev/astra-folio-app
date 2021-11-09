import 'dart:async';
import 'dart:math';

import 'dart:developer' as developer;

import 'package:astrafolioproject/dialogs/EditEventDialog.dart';
import 'package:astrafolioproject/models/Event.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class EventItem extends StatefulWidget {
  EventItem ({Key? key, required this.event, required this.onEventItemEdited, required this.onEventItemDeleted}): super(key: key);

  Event event;
  final Function(Event) onEventItemEdited;
  final Function(Event) onEventItemDeleted;

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

  late Timer timer;
  late Duration timeDifference;

  @override
  void initState() {
    super.initState();
    timer = Timer.periodic(Duration(minutes: 1), (timer) {
      setState(() {
        timeDifference = widget.event.timestamp.difference(DateTime.now());
      });
    });
  }

  @override
  void dispose() {
    timer.cancel();
    super.dispose();

  }

  @override
  Widget build(BuildContext context) {
    Duration timeDifference = widget.event.timestamp.difference(DateTime.now());

    return GestureDetector(
      onLongPressStart: (details) async {
        dynamic selected = await showMenu(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10)
            ),
            context: context,
            position: RelativeRect.fromLTRB(
            details.localPosition.dx,
            details.globalPosition.dy,
            0,
            details.localPosition.dy
        ), items: [
          PopupMenuItem(
            textStyle: TextStyle(
                color: Color(0xFF135BFF)
            ),
            value: 'edit',
            child: Row(
              children: [
                Padding(
                    padding: EdgeInsets.only(right: 4.0),
                    child: Icon(Icons.edit_road, color: Color(0xFF135BFF),)
                ),
                Text('Edit')
              ],
            )
          ),
          PopupMenuItem(
            textStyle: TextStyle(
              color: Colors.redAccent
            ),
            value: 'delete',
            child: Row(
              children: [
                Padding(
                  padding: EdgeInsets.only(right: 4.0),
                  child: Icon(Icons.delete_forever_rounded, color: Colors.redAccent,)
                ),
                Text('Delete')
              ],
            )
          ),
        ]);

        switch(selected) {
          case 'delete': {
           widget.onEventItemDeleted(widget.event);
            break;
          }

          case 'edit': {
            showDialog(
                useSafeArea: true,
                context: context,
                builder: (BuildContext buildContext) {
                  return AlertDialog(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(10.0)),
                      ),
                      title: Text('Редактиране на събитие', textAlign: TextAlign.center,),
                      content: Builder(
                          builder: (context) {
                            var height = MediaQuery.of(context).size.height;
                            var width = MediaQuery.of(context).size.width;

                            return Container(
                              height: height - 400,
                              width: width + 400,
                              child: EditEventDialog(event: widget.event, onFormSubmit: (event) {
                                widget.onEventItemEdited(event);
                              }),
                            );
                          }
                      )
                  );
                }
            );
            break;
          }

          default:
            break;
        }
      },
      child: Padding(
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
                        padding: EdgeInsets.only(left: 4.0, right: 8.0),
                        child: Text(DateFormat.jm().format(widget.event.timestamp)),
                      ),

                      Visibility(
                        visible: timeDifference.inMinutes > 0,
                        child: Row(
                          children: [
                            Icon(
                                Icons.access_alarm,
                                color: Color(0xFF135BFF)
                            ),

                            Padding(
                                padding: EdgeInsets.only(left: 4.0),
                                child:
                                Text(
                                  'Starts in '
                                      '${timeDifference.inHours > 0 ? timeDifference.inHours.toString() + ' hours, ' : ''}'
                                      '${timeDifference.inMinutes.remainder(60)} mins',
                                  style: TextStyle(
                                      color: Color(0xFF135BFF)
                                  ),
                                )
                            ),
                          ],
                        ),
                      )
                    ],),
                  ],
                ),
              )
          )
      ),
    );
  }
}