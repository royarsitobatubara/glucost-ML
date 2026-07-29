class TempHeartAttack {
  int? gender;
  int? age;
  double? bodyMassIndex;
  int? smoker;
  double? systolicBloodPressure;
  int? hypertensionTreated;
  int? familyHistoryOfCardiovascularDisease;
  int? atrialFibrillation;
  int? chronicKidneyDisease;
  int? rheumatoidArthuritis;
  int? diabetes;
  int? chronicObstructivePulmonaryDisorder;
  double? forcedExpiratoryVolume1;

  Map<String, dynamic> toJson() {
    return {
      'gender': gender,
      'age': age,
      'body_mass_index': bodyMassIndex,
      'smoker': smoker,
      'systolic_blood_pressure': systolicBloodPressure,
      'hypertension_treated': hypertensionTreated,
      'family_history_of_cardiovascular_disease': familyHistoryOfCardiovascularDisease,
      'atrial_fibrillation': atrialFibrillation,
      'chronic_kidney_disease': chronicKidneyDisease,
      'rheumatoid_arthritis': rheumatoidArthuritis,
      'diabetes': diabetes,
      'chronic_obstructive_pulmonary_disorder': chronicObstructivePulmonaryDisorder,
      'forced_expiratory_volume_1': forcedExpiratoryVolume1,
    };
  }

  void reset() {
    gender = null;
    age = null;
    bodyMassIndex = null;
    smoker = null;
    systolicBloodPressure = null;
    hypertensionTreated = null;
    familyHistoryOfCardiovascularDisease = null;
    atrialFibrillation = null;
    chronicKidneyDisease = null;
    rheumatoidArthuritis = null;
    diabetes = null;
    chronicObstructivePulmonaryDisorder = null;
    forcedExpiratoryVolume1 = null;
  }
}