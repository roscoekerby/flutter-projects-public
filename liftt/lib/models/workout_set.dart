class WorkoutSet {
  final int reps;
  final int weight;
  final int volume;

  WorkoutSet({
    required this.reps,
    required this.weight,
    required this.volume,
  });

  Map<String, Object> toJson() {
    return {
      "reps": reps,
      "weight": weight,
      "volume": volume,
    };
  }

  static WorkoutSet fromJson(Map<String, Object> json) {
    return WorkoutSet(
      reps: json['reps'] as int,
      weight: json['weight'] as int,
      volume: json['volume'] as int,
    );
  }
}
