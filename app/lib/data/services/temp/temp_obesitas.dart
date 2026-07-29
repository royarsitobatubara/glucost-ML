class TempObesitas {
  String? gender;
  int? age;
  double? height;
  double? weight;
  String? familyHistory;
  String? favc;
  double? fcvc;
  double? ncp;
  String? caec;
  String? smoke;
  double? ch2o;
  String? scc;
  double? faf;
  double? tue;
  String? calc;
  String? mtrans;

  Map<String, dynamic> toJson() {
    return {
      "Gender": gender,
      "Age": age,
      "Height": height,
      "Weight": weight,
      "family_history": familyHistory,
      "FAVC": favc,
      "FCVC": fcvc,
      "NCP": ncp,
      "CAEC": caec,
      "SMOKE": smoke,
      "CH2O": ch2o,
      "SCC": scc,
      "FAF": faf,
      "TUE": tue,
      "CALC": calc,
      "MTRANS": mtrans,
    };
  }

  void reset() {
    gender = null;
    age = null;
    height = null;
    weight = null;
    familyHistory = null;
    favc = null;
    fcvc = null;
    ncp = null;
    caec = null;
    smoke = null;
    ch2o = null;
    scc = null;
    faf = null;
    tue = null;
    calc = null;
    mtrans = null;
  }
}