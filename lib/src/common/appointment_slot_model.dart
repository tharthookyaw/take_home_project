import 'package:intl/intl.dart';

final format = DateFormat("yyyy-MM-dd");

class AppointmentSlots {
  AppointmentSlots(this.appointments);
  final List<AppointmentSlot> appointments;

  factory AppointmentSlots.fromJson(List<dynamic> json) {
    var apts = <AppointmentSlot>[];
    json.forEach((e) {
      apts.add(AppointmentSlot.fromJson(e));
    });
    return AppointmentSlots(apts);
  }

  @override
  String toString() => 'AppointmentSlots: $appointments';
}

class AppointmentSlot {
  AppointmentSlot({required this.date, required this.slots});
  final DateTime date;
  final List<Slot> slots;

  factory AppointmentSlot.fromJson(dynamic json) {
    var slots = <Slot>[];
    (json['slots'] as List).forEach((e) {
      slots.add(Slot.fromJson(e));
    });
    return AppointmentSlot(slots: slots, date: format.parse(json['date']));
  }

  @override
  String toString() => 'date:$date\nslots: [$slots]';
}

class Slot {
  const Slot(
      {required this.startTime,
      required this.endTime,
      required this.available});
  final DateTime startTime;
  final DateTime endTime;
  final bool available;

  factory Slot.fromJson(dynamic json) {
    final _format = DateFormat("yyyy-MM-dd HH:mm");
    return Slot(
        startTime: _format.parse(json['start_time']),
        endTime: _format.parse(json['end_time']),
        available: json['available'] as bool);
  }
  @override
  String toString() =>
      'startTime: $startTime,endTime: $endTime, avail: $available';
}
