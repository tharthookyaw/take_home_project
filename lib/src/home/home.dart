import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../src.dart';

class NavBar extends StatefulWidget {
  const NavBar({Key? key}) : super(key: key);

  static const routeName = '/navbar';

  @override
  State<NavBar> createState() => _NavBarState();
}

class _NavBarState extends State<NavBar> {
  int _selectedIndex = 0;
  late final DashboardCubit _bloc;

  final List<Widget> _pages = const [Dashboard(), Appointment()];
  late Widget _page;

  @override
  void initState() {
    super.initState();
    _bloc = context.read<DashboardCubit>();
    _bloc.getMetalPriceByWeight();
    _page = _pages[0];
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
      _page = _pages[_selectedIndex];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(child: _page),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Dashboard'),
          BottomNavigationBarItem(
              icon: Icon(Icons.business), label: 'Appointment')
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.amber[800],
        onTap: _onItemTapped,
      ),
    );
  }
}
