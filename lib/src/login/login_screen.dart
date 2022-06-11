import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../src.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  late final LoginCubit _authBloc;

  @override
  void initState() {
    super.initState();
    _authBloc = context.read<LoginCubit>();
  }

  isLoading(state) => state.status == AuthStatus.loading;

  @override
  Widget build(BuildContext context) {
    return BlocListener<LoginCubit, LoginState>(
      listener: (context, state) async {
        if (state.status == AuthStatus.failure) {
          ScaffoldMessenger.of(context)
              .showSnackBar(SnackBar(content: Text('${state.errMsg}')));
        } else if (state.status == AuthStatus.success) {
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
              content: Text('Successfully Signed-in.'),
              duration: Duration(milliseconds: 700)));

          await Future.delayed(const Duration(seconds: 1)).then((_) {
            Navigator.pushNamed(context, NavBar.routeName);
          });
        }
      },
      child: Scaffold(body: SafeArea(
        child: Center(
          child: BlocBuilder<LoginCubit, LoginState>(builder: (context, state) {
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 15),
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("Welcome...",
                        style: TextStyle(
                            fontSize: 52,
                            fontStyle: FontStyle.italic,
                            color: Colors.teal[500])),
                    const SizedBox(height: 68),
                    if (isLoading(state))
                      const Center(child: CircularProgressIndicator()),
                    if (!isLoading(state))
                      ElevatedButton(
                          onPressed: () => _authBloc.signInAnonymous(),
                          child: const Text('Sign in (Anonymous)'))
                  ]),
            );
          }),
        ),
      )),
    );
  }
}
