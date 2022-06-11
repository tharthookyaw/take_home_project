import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:syncfusion_flutter_calendar/calendar.dart';
import 'package:table_calendar/table_calendar.dart';

import '../src.dart';

final kToday = DateTime.now();
final kFirstDay = DateTime(kToday.year - 2, kToday.month, kToday.day);
final kLastDay = DateTime(kToday.year + 2, kToday.month, kToday.day);

class Appointment extends StatefulWidget {
  const Appointment({Key? key}) : super(key: key);

  @override
  State<Appointment> createState() => _AppointmentState();
}

class _AppointmentState extends State<Appointment> {
  late final AppointmentCubit _cubit;
  DateTime _focusedDay = DateTime.now();
  CalendarFormat _calendarFormat = CalendarFormat.week;
  DateTime? _selectedDay;

  @override
  void initState() {
    debugPrint("Appointment: initState()");
    super.initState();
    _cubit = context.read<AppointmentCubit>();
    _cubit.getSlotsForAppointment(_focusedDay);
  }

  void _onDaySelected(DateTime selectedDay, DateTime focusedDay) {
    if (!isSameDay(_selectedDay, selectedDay)) {
      setState(() {
        _selectedDay = selectedDay;
        _focusedDay = focusedDay;
      });
      _cubit.getSlotsForAppointment(selectedDay);
    }
  }

  // @override
  // Widget build(BuildContext context) {
  //   return Container(
  //     child: SfCalendar(
  //       view: CalendarView.day,
  //       showCurrentTimeIndicator: true,
  //       timeSlotViewSettings: TimeSlotViewSettings(
  //           timeInterval: Duration(minutes: 15), timeFormat: 'h:mm'),
  //     ),
  //   );
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          automaticallyImplyLeading: false,
          title: Text('Appointments',
              style: TextStyle(color: Colors.deepPurple[800]))),
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15.0),
              child: TableCalendar(
                focusedDay: _focusedDay,
                firstDay: kFirstDay,
                lastDay: kLastDay,
                calendarFormat: _calendarFormat,
                onDaySelected: _onDaySelected,
                selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
                startingDayOfWeek: StartingDayOfWeek.monday,
                availableCalendarFormats: const {
                  CalendarFormat.month: 'Month',
                  CalendarFormat.week: 'Week'
                },
                headerStyle: const HeaderStyle(
                    titleCentered: true, formatButtonVisible: false),
                onFormatChanged: (format) {
                  if (_calendarFormat != format) {
                    setState(() {
                      _calendarFormat = format;
                    });
                  }
                },
              ),
            ),
            SizedBox(
                height: 48,
                child: Column(
                  children: [
                    const Divider(),
                    Padding(
                      padding: const EdgeInsets.only(
                          left: 12, right: 8, top: 6, bottom: 6),
                      child: Row(children: const [
                        ColorIndicator(color: CupertinoColors.activeGreen),
                        SizedBox(width: 5),
                        Text('Available Slots', style: TextStyle(fontSize: 12)),
                        SizedBox(width: 10),
                        ColorIndicator(color: CupertinoColors.inactiveGray),
                        SizedBox(width: 5),
                        Text('Reserved Slots', style: TextStyle(fontSize: 12))
                      ]),
                    ),
                  ],
                )),
            BlocBuilder<AppointmentCubit, AppointmentState>(
              builder: (context, state) {
                if (state.status == AppointmentTaskStatus.loading) {
                  return const Expanded(
                      child: Center(child: CircularProgressIndicator()));
                }

                final slots = state.slots;
                if (slots?.slots == null) {
                  return const Expanded(
                    child: Center(
                        child: Text('No Appointment Slots!',
                            style: TextStyle(
                                color: CupertinoColors.secondaryLabel))),
                  );
                }
                return Expanded(
                  child: GridView.count(
                    crossAxisCount: 2,
                    shrinkWrap: true,
                    physics: const AlwaysScrollableScrollPhysics(),
                    padding: const EdgeInsets.only(left: 8, right: 8),
                    childAspectRatio: 14 / 2.7,
                    children: [
                      ...?slots?.slots
                          .map((e) => Container(
                                margin: const EdgeInsets.only(
                                    left: 4, right: 4, top: 3, bottom: 3),
                                padding: const EdgeInsets.only(left: 8, top: 6),
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(2.5),
                                    color: e.available
                                        ? CupertinoColors.activeGreen
                                        : CupertinoColors.inactiveGray),
                                child: Text(
                                    '${e.startTime.timeFormat} - ${e.endTime.timeFormat}'),
                              ))
                          .toList(),
                    ],
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

class ColorIndicator extends StatelessWidget {
  const ColorIndicator({Key? key, required this.color}) : super(key: key);
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 14,
      height: 14,
      decoration: BoxDecoration(color: color, shape: BoxShape.circle),
    );
  }
}
