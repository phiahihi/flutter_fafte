extension DoubleListExtenstion on List<double> {
  double get sum {
    var _sum = 0.0;
    forEach((element) => _sum += element);
    return _sum;
  }
}
