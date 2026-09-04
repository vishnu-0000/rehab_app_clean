class RecommendationEngine {
  static String recommend(int finger, int grip, int wrist) {
    if (finger == 0 || wrist == 0) {
      return "Passive Assisted Exercise";
    }
    if (grip == 1) {
      return "Assisted Grip Training";
    }
    return "Active Free Exercise";
  }
}
