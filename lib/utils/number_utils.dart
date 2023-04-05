extension NumberFormartDouble on double {
  String toPriceUSD() {
    return this.toStringAsFixed(2).replaceAll('.00', '');
  }
}

extension NumberFormart on num {
  String toPriceUSD() {
    return this.toStringAsFixed(2).replaceAll('.00', '');
  }
}
