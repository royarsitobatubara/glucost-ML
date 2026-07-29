class TempDiabetes {
  int? pregnancies;
  double? glucose;
  double? bloodPressure;
  double? skinThickness;
  double? insulin;
  double? bmi;
  double? diabetesPedigreeFunction;
  int? age;

  Map<String, dynamic> toJson() {
    return {
      "Pregnancies": pregnancies,
      "Glucose": glucose,
      "BloodPressure": bloodPressure,
      "SkinThickness": skinThickness,
      "Insulin": insulin,
      "BMI": bmi,
      "DiabetesPedigreeFunction": diabetesPedigreeFunction,
      "Age": age,
    };
  }

  void reset() {
    pregnancies = null;
    glucose = null;
    bloodPressure = null;
    skinThickness = null;
    insulin = null;
    bmi = null;
    diabetesPedigreeFunction = null;
    age = null;
  }
}