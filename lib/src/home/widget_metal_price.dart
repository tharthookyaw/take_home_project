import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:dropdown_button2/dropdown_button2.dart';

import '../src.dart';

typedef DropdownCallback = void Function(String?)?;

class MetalPriceChart extends StatefulWidget {
  const MetalPriceChart({Key? key}) : super(key: key);

  @override
  State<MetalPriceChart> createState() => _MetalPriceChartState();
}

class _MetalPriceChartState extends State<MetalPriceChart> {
  String? selectedWeight;

  onSelect(value) {
    setState(() {
      selectedWeight = value as String;
    });
  }

  List<Widget> _addSizedBoxAfterItems(Map<String, double> prices) {
    var metals = <Widget>[];
    for (var e in prices.entries) {
      metals.addAll([
        Row(children: [
          Container(
            margin: const EdgeInsets.symmetric(vertical: 3),
            child: Text(e.key.toUpperCase(),
                style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    color: CupertinoColors.systemIndigo)),
          ),
          const Spacer(),
          Text('${e.value}',
              style: const TextStyle(fontWeight: FontWeight.bold))
        ]),
        if (e.key != prices.entries.last.key) const Divider()
      ]);
    }
    return metals;
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<DashboardCubit, DashboardState>(
      builder: (context, state) {
        return Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            decoration: BoxDecoration(
                color: CupertinoColors.lightBackgroundGray,
                borderRadius: BorderRadius.circular(3.5)),
            child: state.status == DashboardTaskStatus.loading
                ? const Center(child: CircularProgressIndicator())
                : state.status == DashboardTaskStatus.failure
                    ? Center(child: Text(state.errMsg!))
                    : Column(children: [
                        Row(
                          children: [
                            Text('${state.prices?.currentTime}',
                                style: const TextStyle(fontSize: 11)),
                          ],
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 12.0),
                          child: Row(
                            children: [
                              SizedBox(
                                  width: 75,
                                  height: 25,
                                  child: WeightDropdown(
                                      selectedWeight: selectedWeight ??
                                          state.prices!.weightsList[0],
                                      weightList: state.prices!.weightsList,
                                      onSelect: onSelect)),
                            ],
                          ),
                        ),
                        const SizedBox(height: 30),
                        ..._addSizedBoxAfterItems(state.prices!.prices
                            .getMetals(selectedWeight ??
                                state.prices!.weightsList[0])!)
                        // ...metalPrices!.entries
                        //     .map((e) => Row(
                        //           children: [
                        //             Container(
                        //               margin: const EdgeInsets.symmetric(vertical: 3),
                        //               child: Text(e.key.toUpperCase(),
                        //                   style: const TextStyle(
                        //                       fontWeight: FontWeight.bold)),
                        //             ),
                        //             const Spacer(),
                        //             Text('${e.value}')
                        //           ],
                        //         ))
                        //     .toList()
                      ]));
      },
    );
  }
}

class WeightDropdown extends StatelessWidget {
  const WeightDropdown(
      {Key? key,
      required this.weightList,
      required this.onSelect,
      required this.selectedWeight})
      : super(key: key);
  final List<String> weightList;
  final DropdownCallback onSelect;
  final String selectedWeight;

  @override
  Widget build(BuildContext context) {
    return DropdownButtonHideUnderline(
        child: DropdownButton2(
            items: weightList
                .map((item) => DropdownMenuItem<String>(
                    value: item,
                    child: Text(WeightLabel[item]!,
                        style: const TextStyle(
                            fontSize: 13, fontWeight: FontWeight.w500))))
                .toList(),
            value: selectedWeight,
            onChanged: onSelect,
            buttonHeight: 24,
            buttonWidth: 120,
            itemHeight: 32));
  }
}

// DropdownButtonHideUnderline
