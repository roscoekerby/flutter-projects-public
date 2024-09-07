import 'package:flutter/material.dart';
import 'package:date_utils/date_utils.dart' as utils;
import './calendar_day.dart';

class EventCalendar extends StatefulWidget {
  final ValueChanged<DateTime> onDateSelected;
  final DateTime date;
  final List<DateTime> markedDates;

  const EventCalendar({
    required Key key,
    required this.date,
    required this.onDateSelected,
    required this.markedDates,
  }) : super(key: key);

  @override
  EventCalendarState createState() => EventCalendarState();
}

class EventCalendarState extends State<EventCalendar> {
  late DateTime currentDate;

  @override
  void initState() {
    super.initState();
    currentDate = widget.date;
  }

  void previousMonth(DateTime selectedDate) {
    setState(() {
      currentDate = utils.DateUtils.previousMonth(selectedDate);
    });
  }

  void nextMonth(DateTime selectedDate) {
    setState(() {
      currentDate = utils.DateUtils.nextMonth(selectedDate);
    });
  }

  Widget buildHeader(DateTime selectedDate) {
    List monthAndYear = utils.DateUtils.formatMonth(selectedDate).split(' ');
    String month = monthAndYear[0];
    String year = monthAndYear[1];

    TextStyle headerTextStyle = const TextStyle(fontSize: 18.0);
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: <Widget>[
        IconButton(
          icon: const Icon(Icons.chevron_left),
          onPressed: () => previousMonth(selectedDate),
        ),
        Row(
          children: <Widget>[
            Text('$month ', style: headerTextStyle),
            Text(year, style: headerTextStyle),
          ],
        ),
        IconButton(
          icon: const Icon(Icons.chevron_right),
          onPressed: () => nextMonth(selectedDate),
        ),
      ],
    );
  }

  List<Widget> buildDays(DateTime selectedDate) {
    final List<DateTime> datesOfMonth =
        utils.DateUtils.daysInMonth(selectedDate);
    return datesOfMonth.map((date) {
      if (date.month == selectedDate.month) {
        return CalendarDay(
          date,
          isMarked: widget.markedDates.contains(date),
          onDateSelected: () {
            setState(() {
              widget.onDateSelected(date);
              currentDate = date;
            });
          },
          key: Key('calendarDay_${date.day}'), // Provide a valid key
        );
      } else {
        return const Text('');
      }
    }).toList();
  }

  List<Widget> buildWeekdays() {
    return utils.DateUtils.weekdays.map((weekday) {
      return Center(
        child: Text(
          weekday,
          textAlign: TextAlign.center,
        ),
      );
    }).toList();
  }

  Widget buildCalendar(DateTime selectedDate) {
    List<Widget> gridChildren = [
      ...buildWeekdays(),
      ...buildDays(selectedDate),
    ];

    return GridView.count(
      shrinkWrap: true,
      crossAxisCount: 7,
      childAspectRatio: 1.01,
      padding: const EdgeInsets.only(top: 5.0, bottom: 0.0),
      physics: const ScrollPhysics(parent: NeverScrollableScrollPhysics()),
      children: gridChildren, // Moved `children` argument to the end
    );
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        mainAxisSize: MainAxisSize.max,
        children: <Widget>[
          buildHeader(currentDate),
          buildCalendar(currentDate),
        ],
      ),
    );
  }
}
