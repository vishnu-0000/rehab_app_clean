class FMAEngine {
  static int score(double value, double normal) {
    double ratio = value / normal;
    if (ratio < 0.33) return 0;
    if (ratio < 0.66) return 1;
    return 2;
  }
}
