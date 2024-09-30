class ScoreManager {
  static final ScoreManager _instance = ScoreManager._internal();
  int _score = 0;

  factory ScoreManager() {
    return _instance;
  }

  ScoreManager._internal();

  void increaseScore(int points) {
    _score += points;
  }

  int get score => _score;

  void resetScore() {
    _score = 0; // You can choose to implement score reset if needed
  }
}
