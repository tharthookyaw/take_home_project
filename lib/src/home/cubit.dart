import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../src.dart';

enum DashboardTaskStatus { initial, loading, success, failure }

class DashboardCubit extends Cubit<DashboardState> {
  DashboardCubit(this.repo) : super(const DashboardState());
  final HttpService repo;

  getMetalPriceByWeight() async {
    emit(const DashboardState(status: DashboardTaskStatus.loading));

    try {
      final res = await repo.getMetalPrices();
      if (res != null) {
        emit(DashboardState(status: DashboardTaskStatus.success, prices: res));
      } else {
        emit(const DashboardState(
            status: DashboardTaskStatus.failure, errMsg: 'No Metal Prices'));
      }
    } catch (e) {
      debugPrint("getMetalPriceByWeight(): ${e.toString()}");
      emit(DashboardState(
          status: DashboardTaskStatus.failure, errMsg: e.toString()));
    }
  }
}

class DashboardState extends Equatable {
  const DashboardState(
      {this.status = DashboardTaskStatus.initial, this.prices, this.errMsg});
  final DashboardTaskStatus status;
  final MetalPrices? prices;
  final String? errMsg;
  @override
  List<Object?> get props => [status, prices, errMsg];
}
