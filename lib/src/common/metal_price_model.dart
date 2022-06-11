import 'package:flutter/foundation.dart';

const WeightLabel = {
  "ounce": "OZ",
  "gram": "G",
  "hundred_gram": "100G",
  "thousand_gram": "1000G"
};

class MetalPrices {
  MetalPrices({required this.prices, required this.currentTime});
  final PriceByWeight prices;
  final String currentTime;

  factory MetalPrices.fromJson(dynamic json) {
    return MetalPrices(
        prices: PriceByWeight.fromJson(json['prices']),
        currentTime: json['current_time']);
  }

  getMetals(String w) => prices.getMetals(w);

  get weightsList => <String>['ounce', 'gram', 'hundred_gram', 'thousand_gram'];

  @override
  String toString() =>
      "MetalPrices(prices: $prices, \ncurrentTime: $currentTime)";
}

class PriceByWeight {
  PriceByWeight({this.ounce, this.gram, this.hundredGram, this.thousandGram});
  final Map<String, double>? ounce;
  final Map<String, double>? gram;
  final Map<String, double>? hundredGram;
  final Map<String, double>? thousandGram;

  factory PriceByWeight.fromJson(dynamic json) {
    assert(json is Map);
    return PriceByWeight(
        ounce: Map<String, double>.from(json['ounce']),
        gram: Map<String, double>.from(json['gram']),
        hundredGram: Map<String, double>.from(json['hundred_gram']),
        thousandGram: Map<String, double>.from(json['thousand_gram']));
  }

  Map<String, double>? getMetals(String w) => w == 'ounce'
      ? ounce
      : w == 'gram'
          ? gram
          : w == 'hundred_gram'
              ? hundredGram
              : thousandGram;

  @override
  String toString() =>
      "\n<ounce: $ounce\ngram: $gram\nhundredGram: $hundredGram\nthousandGram: $thousandGram>";
}
