import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../src.dart';

enum AppointmentTaskStatus { initial, loading, success, failure }

class AppointmentCubit extends Cubit<AppointmentState> {
  AppointmentCubit(this.repo) : super(const AppointmentState());
  final HttpService repo;

  getSlotsForAppointment(DateTime date) async {
    emit(const AppointmentState(status: AppointmentTaskStatus.loading));
    try {
      final res = await repo.getSlotsForAppointment(date);
      debugPrint("AppointmentCubit: $res");
      if (res != null) {
        emit(AppointmentState(
            status: AppointmentTaskStatus.success, slots: res));
      } else {
        emit(const AppointmentState(
            status: AppointmentTaskStatus.failure, errMsg: 'No Appointment'));
      }
    } catch (e) {
      debugPrint("getSlotsForAppointment(): ${e.toString()}");
      emit(AppointmentState(
          status: AppointmentTaskStatus.failure, errMsg: e.toString()));
    }
  }
}

class AppointmentState extends Equatable {
  const AppointmentState(
      {this.status = AppointmentTaskStatus.initial, this.slots, this.errMsg});
  final AppointmentTaskStatus status;
  final AppointmentSlot? slots;
  final String? errMsg;

  @override
  List<Object?> get props => [status, slots, errMsg];
}
