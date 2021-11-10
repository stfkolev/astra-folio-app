
import 'dart:math';

import 'package:astrafolioproject/models/Event.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';

class AddEventDialog extends StatefulWidget {
  const AddEventDialog({Key? key, required this.onFormSubmit}) : super(key: key);

  final Function(Event) onFormSubmit;

  @override
  AddEventState createState() => AddEventState();
}

class AddEventState extends State<AddEventDialog> {
  final _formKey = GlobalKey<FormState>();

  final titleController = TextEditingController();
  final descriptionController = TextEditingController();
  final dateController = TextEditingController();

  @override
  void dispose() {

    titleController.dispose();
    descriptionController.dispose();
    dateController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Form(
        key: _formKey,
        child: Column(

          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            // Text('Title', textAlign: TextAlign.start),
            Padding(
              padding: EdgeInsets.only(bottom: 16.0),
              child: TextFormField(
                controller: titleController,
                validator: (value) {
                  if(value == null || value.isEmpty)
                    return 'Моля въведете заглавие';

                  return null;
                },
                decoration: InputDecoration(
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                        borderSide: BorderSide(
                            color: Colors.black26
                        )
                    ),
                    filled: true,
                    labelText: 'Заглавие',
                    labelStyle: TextStyle(
                        fontSize: 18
                    )
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(bottom: 16.0),
              child: TextFormField(
                controller: descriptionController,
                validator: (value) {
                  if(value == null || value.isEmpty)
                    return 'Моля въведете описание';

                  return null;
                },
                decoration: InputDecoration(
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                        borderSide: BorderSide(
                            color: Colors.black26
                        )
                    ),
                    filled: true,
                    hintText: '\n\n\n',
                    labelText: 'Описание',
                    labelStyle: TextStyle(
                        fontSize: 18
                    )
                ),
                maxLines: null,
                keyboardType: TextInputType.multiline,
              ),
            ),
            Padding(
              padding: EdgeInsets.only(bottom: 16.0),
              child: DateTimeField(
                decoration: InputDecoration(
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                        borderSide: BorderSide(
                            color: Colors.black26
                        )
                    ),
                    filled: true,
                    hintText: '\n\n\n',
                    labelText: 'Дата и Час',
                    labelStyle: TextStyle(
                        fontSize: 18
                    )
                ),
                validator: (value) {
                  if(value == null) {
                    return 'Моля въведете дата и час';
                  }

                  return null;
                },
                format: DateFormat("dd.MM.yyyy, HH:mm"),
                onShowPicker: (context, currentValue) async {
                  final date = await showDatePicker(
                      context: context,
                      firstDate: DateTime.now(),
                      initialDate: currentValue ?? DateTime.now(),
                      lastDate: DateTime.now().add(Duration(days: 365)));
                  if (date != null) {
                    final time = await showTimePicker(
                      context: context,
                      initialTime:
                      TimeOfDay.fromDateTime(currentValue ?? DateTime.now()),
                    );
                    return DateTimeField.combine(date, time);
                  } else {
                    return currentValue;
                  }
                },
                onChanged: (date) => dateController.text = date.toString(),
              )
            ),
            Row(children: [
              Expanded(
                flex: 1,
                child: ElevatedButton(
                    style: ButtonStyle(
                        alignment: Alignment.center,
                        padding: MaterialStateProperty.all(EdgeInsets.all(16.0)),
                        backgroundColor: MaterialStateProperty.all(Color(0xFF135BFF)),
                        shadowColor: MaterialStateProperty.all(Color(0xFF135BFF)),

                        elevation: MaterialStateProperty.all(10.0)
                    ),
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        dynamic event = Event(
                            Random().nextInt(540),
                            titleController.text,
                            descriptionController.text,
                            DateTime.parse(dateController.text)
                        );

                       widget.onFormSubmit(event);
                       Navigator.of(context, rootNavigator: true).pop();
                      }
                    },
                    child: const Text('Добавяне')
                ),
              )
            ],)
          ],
      )
    );
  }

}