class TempStress {
  double? humidity;
  double? temperature;
  int? stepCount;

  Map<String, dynamic> toJson() {
    return {
      'Humidity': humidity,
      'Temperature': temperature,
      'Step_count': stepCount,
    };
  }

  void reset() {
    humidity = null;
    temperature = null;
    stepCount = null;
  }
}