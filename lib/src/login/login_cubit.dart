import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../common/common.dart';

enum AuthStatus { initial, loading, success, failure }

class LoginCubit extends Cubit<LoginState> {
  LoginCubit(this.authService) : super(const LoginState());

  final AuthService authService;

  void signInAnonymous() async {
    emit(const LoginState(status: AuthStatus.loading));
    try {
      await authService.signInAnon();
      emit(const LoginState(status: AuthStatus.success));
    } on AuthException catch (e) {
      emit(LoginState(status: AuthStatus.failure, errMsg: e.msg));
    } catch (e) {
      emit(const LoginState(status: AuthStatus.failure, errMsg: "Error"));
    }
  }
}

class LoginState extends Equatable {
  const LoginState({this.status = AuthStatus.initial, this.errMsg});
  final AuthStatus status;
  final String? errMsg;
  @override
  List<Object?> get props => [status, errMsg];
}
