import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'firebase_options.dart';

import './src/src.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const App());
}

class App extends StatelessWidget {
  const App({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<LoginCubit>(
            create: (context) => LoginCubit(AuthService())),
        BlocProvider<DashboardCubit>(
            create: (context) => DashboardCubit(RepositoryImpl())),
        BlocProvider<AppointmentCubit>(
            create: (context) => AppointmentCubit(RepositoryImpl()))
      ],
      child: MaterialApp(
          debugShowCheckedModeBanner: false,
          routes: {
            NavBar.routeName: (context) => const NavBar(),
          },
          home: const LoginScreen()),
    );
  }
}
