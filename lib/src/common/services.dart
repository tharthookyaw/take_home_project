import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

import 'common.dart';

extension DateExtension on DateTime {
  DateTime get dateOnly => DateTime(year, month, day);

  String get timeFormat => DateFormat("HH:mm").format(this);

  String get dateFormat => DateFormat("yyyy-MM-dd").format(this);
}

abstract class HttpService {
  Future<MetalPrices?> getMetalPrices();
  Future<AppointmentSlot?> getSlotsForAppointment(DateTime date);
}

class RepositoryImpl extends HttpService {
  @override
  Future<MetalPrices?> getMetalPrices() async {
    try {
      var response = await http.get(Uri.parse(
          'https://406860e9-1877-4509-a313-3e050c0b704c.mock.pstmn.io/home/getPrices'));

      if (response.statusCode == 200) {
        return await compute(decodeMetalPrices, response.body);
      } else {
        throw 'Unable to load!';
      }
    } catch (e) {
      throw e.toString();
    }
  }

  @override
  Future<AppointmentSlot?> getSlotsForAppointment(DateTime date) async {
    String formattedDate = date.dateFormat;
    try {
      final uri = Uri.https(
          '406860e9-1877-4509-a313-3e050c0b704c.mock.pstmn.io',
          '/appointments/getSlots',
          {'date': formattedDate});
      final response = await http.get(uri);

      if (response.statusCode == 200) {
        return await compute(
            decodeAppointment, {'body': response.body, 'date': formattedDate});
      } else {
        throw 'Unable to retrieve appointment slots!';
      }
    } catch (e) {
      throw e.toString();
    }
  }

  static AppointmentSlot decodeAppointment(dynamic obj) {
    String date = obj['date'];
    var appt = AppointmentSlots.fromJson(jsonDecode(obj['body']));

    return appt.appointments.firstWhere((e) => e.date.dateFormat == date);
  }

  static MetalPrices decodeMetalPrices(dynamic obj) =>
      MetalPrices.fromJson(jsonDecode(obj));
}

// http.StreamedResponse response = await request.send();

// if (response.statusCode == 200) {
//   print(await response.stream.bytesToString());
// }
// else {
//   print(response.reasonPhrase);
// }

// var request = http.Request(
//         'GET',
//         Uri.parse(
//             'https://a69648a5-f361-43d0-a18c-5e0c6942687b.mock.pstmn.io/appointments/getSlots?date=2022-06-15'));
//     var response = await request.send();

// final queryParameters = {
//   'param1': 'one',
//   'param2': 'two',
// };
// final uri =
//     Uri.https('www.myurl.com', '/api/v1/test/${widget.pk}', queryParameters);
// final response = await http.get(uri, headers: {
//   HttpHeaders.authorizationHeader: 'Token $token',
//   HttpHeaders.contentTypeHeader: 'application/json',
// });
