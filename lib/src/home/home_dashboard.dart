import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';

import "../src.dart";

class Dashboard extends StatefulWidget {
  const Dashboard({Key? key}) : super(key: key);

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  int _current = 0;
  final CarouselController _controller = CarouselController();

  List<Widget> dashboardList = [
    const MetalPriceChart(),
  ];

  @override
  Widget build(BuildContext context) {
    final _width = MediaQuery.of(context).size.width;
    final _height = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          automaticallyImplyLeading: false,
          title: Text('Dashboard', style: TextStyle(color: Colors.amber[800]))),
      body: SafeArea(
        child: Column(children: [
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CarouselSlider(
                  items: dashboardList,
                  carouselController: _controller,
                  options: CarouselOptions(
                      enlargeCenterPage: true,
                      enableInfiniteScroll: false,
                      aspectRatio: _width / (_height * .34),
                      onPageChanged: (index, reason) {
                        setState(() {
                          _current = index;
                        });
                      }),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: dashboardList.asMap().entries.map((entry) {
                    return GestureDetector(
                      onTap: () => _controller.animateToPage(entry.key),
                      child: Container(
                        width: 8.0,
                        height: 8.0,
                        margin: const EdgeInsets.symmetric(
                            vertical: 12.0, horizontal: 4.0),
                        decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color:
                                (Theme.of(context).brightness == Brightness.dark
                                        ? Colors.white
                                        : Colors.grey)
                                    .withOpacity(
                                        _current == entry.key ? .75 : 0.4)),
                      ),
                    );
                  }).toList(),
                ),
              ],
            ),
          ),
        ]),
      ),
    );
  }
}
