class AiAssessment {
  static double calculateFMA({
    required double flex1,
    required double flex2,
    required double flex3,
    required double gripForce,
  }) {
    double flexAvg = (flex1 + flex2 + flex3) / 3;

    double flexScore = (flexAvg / 180) * 60;
    double gripScore = (gripForce / 5) * 40;

    double total = flexScore + gripScore;
    return total.clamp(0, 100);
  }
}
